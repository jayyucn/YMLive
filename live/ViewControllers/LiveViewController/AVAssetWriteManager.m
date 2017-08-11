//
//  AVAssetWriteManager.m
//  FMRecordVideo
//
//  Created by qianjn on 2017/3/15.
//  Copyright © 2017年 SF. All rights reserved.
//
//  Github:https://github.com/suifengqjn
//  blog:http://gcblog.github.io/
//  简书:http://www.jianshu.com/u/527ecf8c8753

#import "AVAssetWriteManager.h"
#import <CoreMedia/CoreMedia.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "QiniuSDK.h"
#import "HappyDNS.h"

#import "AVSEWatermark.h"
#import "CaptureStreamUtil.h"

typedef void(^WatermarkBlock)(void);

typedef void(^ShareCompletionBlock)(NSString *videoUrl);


#define RECORD_MAX_TIME 8.0           //最长录制时间
#define TIMER_INTERVAL 0.05         //计时器刷新频率

@interface AVAssetWriteManager ()


@property (nonatomic, strong) dispatch_queue_t writeQueue;
@property (nonatomic, strong) NSURL           *videoUrl;

@property (nonatomic, strong)AVAssetWriter *assetWriter;
@property (nonatomic, strong) AVAssetWriterInputPixelBufferAdaptor *writerAdaptor;

@property (nonatomic, strong)AVAssetWriterInput *assetWriterVideoInput;
@property (nonatomic, strong)AVAssetWriterInput *assetWriterAudioInput;



@property (nonatomic, strong) NSDictionary *videoCompressionSettings;
@property (nonatomic, strong) NSDictionary *audioCompressionSettings;


@property (nonatomic, assign) BOOL canWrite;
@property (nonatomic, assign) FMVideoViewType viewType;

//watermark
@property (nonatomic, copy) WatermarkBlock watermarkBlock; //添加水印完成回调
@property(nonatomic) AVMutableComposition *composition;
@property(nonatomic) AVMutableVideoComposition *videoComposition;
@property(nonatomic) AVMutableAudioMix *audioMix;
@property(nonatomic) AVAsset *inputAsset;
@property(nonatomic) CALayer *watermarkLayer;

//
@property (nonatomic, copy) ShareCompletionBlock shareBlock;

@end

@implementation AVAssetWriteManager

#pragma mark - private method


- (instancetype)initWithURL:(NSURL *)URL viewType:(FMVideoViewType )type
{
    self = [super init];
    if (self) {
        _videoUrl = URL;
        _viewType = type;
        _writeQueue = dispatch_queue_create("com.5miles", DISPATCH_QUEUE_SERIAL);
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(editCommandCompletionNotificationReceiver:)
                                                     name:AVSEEditCommandCompletionNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(exportCommandCompletionNotificationReceiver:)
                                                     name:AVSEExportCommandCompletionNotification
                                                   object:nil];
        
    }
    return self;
}
#pragma mark- watermark

- (void)appendWatermarkWithURL:(NSURL *)url completionHandler:(void(^)(void))handler {
    self.inputAsset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVSEAddWatermarkCommand *watermarkCommand = [[AVSEAddWatermarkCommand alloc] initWithComposition:self.composition videoComposition:self.videoComposition audioMix:self.audioMix];
    [watermarkCommand performWithAsset:self.inputAsset];
    self.watermarkBlock = handler;
}
- (void)editCommandCompletionNotificationReceiver:(NSNotification*) notification
{
    if ([[notification name] isEqualToString:AVSEEditCommandCompletionNotification]) {
        // Update the document's composition, video composition etc
        self.composition = [[notification object] mutableComposition];
        self.videoComposition = [[notification object] mutableVideoComposition];
        self.audioMix = [[notification object] mutableAudioMix];
        if([[notification object] watermarkLayer])
            self.watermarkLayer = [[notification object] watermarkLayer];
        dispatch_async( dispatch_get_main_queue(), ^{
            [self putCompositionTogether];
        });
    }
}
- (void)putCompositionTogether
{
    if(self.watermarkLayer) {
        CALayer *exportWatermarkLayer = self.watermarkLayer;
        CALayer *parentLayer = [CALayer layer];
        CALayer *videoLayer = [CALayer layer];
        parentLayer.frame = CGRectMake(0, 0, self.videoComposition.renderSize.width, self.videoComposition.renderSize.height);
        videoLayer.frame = CGRectMake(0, 0, self.videoComposition.renderSize.width, self.videoComposition.renderSize.height);
        [parentLayer addSublayer:videoLayer];
//        exportWatermarkLayer.position = CGPointMake(self.videoComposition.renderSize.width*2/3, self.videoComposition.renderSize.height/6);
        exportWatermarkLayer.position = CGPointMake(self.videoComposition.renderSize.width-60, 50);
        
        [parentLayer addSublayer:exportWatermarkLayer];
        self.videoComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
        AVSEExportCommand *exportCommand = [[AVSEExportCommand alloc] initWithComposition:self.composition videoComposition:self.videoComposition audioMix:self.audioMix];
        [exportCommand performWithAsset:nil];
    }
    
}


- (void)exportCommandCompletionNotificationReceiver:(NSNotification *)notification
{
    __weak typeof(self)weakself = self;
    if ([[notification name] isEqualToString:AVSEExportCommandCompletionNotification]) {
        dispatch_async( dispatch_get_main_queue(), ^{
            weakself.watermarkBlock();
//            [self exportDidEnd];
            
        });
    }
}


#pragma mark- appendSampleBuffer

- (void)appendVideoBuffer:(CVPixelBufferRef)sampleBuffer fps:(int64_t)fps
{
    CMTime timeStamp = CMTimeMake(fps, 1000);
    if (CMTimeGetSeconds(timeStamp) < 0) {
        return;
    }
//    CFRetain(sampleBuffer);
    dispatch_async(self.writeQueue, ^{
        @autoreleasepool {
            
            if (!self.canWrite) {
                [self.assetWriter startWriting];
                [self.assetWriter startSessionAtSourceTime:timeStamp];
                self.canWrite = YES;
            }
            //写入视频数据
            if (self.assetWriterVideoInput.readyForMoreMediaData) {
                
                BOOL success = [self.writerAdaptor appendPixelBuffer:sampleBuffer withPresentationTime:timeStamp];
                if (!success) {
                    @synchronized (self) {
                        [self stopWriteWithCompletionHandler:nil];
                        [self destroyWrite];
                    }
                }
            }
//            CFRelease(sampleBuffer);
        }
    } );
}

//开始写入数据
- (void)appendSampleBuffer:(CMSampleBufferRef)sampleBuffer ofMediaType:(NSString *)mediaType
{
 
    if (!sampleBuffer) {
        return;
    }
    CMTime mTimeStamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    if (CMTimeGetSeconds(mTimeStamp) < 0) {
        return;
    }
    CFRetain(sampleBuffer);
    dispatch_async(self.writeQueue, ^{
        @autoreleasepool {
            
            if (!self.canWrite && mediaType == AVMediaTypeVideo) {
                [self.assetWriter startWriting];
                [self.assetWriter startSessionAtSourceTime:CMSampleBufferGetPresentationTimeStamp(sampleBuffer)];
                self.canWrite = YES;
            }
            //写入视频数据
            if (mediaType == AVMediaTypeVideo) {
                NSLog(@"video time %lf", CMTimeGetSeconds(mTimeStamp));
                if (self.assetWriterVideoInput.readyForMoreMediaData) {
                   CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
                    BOOL success = [self.writerAdaptor appendPixelBuffer:pixelBuffer withPresentationTime:mTimeStamp];
                    if (!success) {
                        NSLog(@"写入失败：%@", self.assetWriter.error);
                        @synchronized (self) {
                            [self stopWriteWithCompletionHandler:nil];
                            [self destroyWrite];
                        }
                    }
                }
            }
            
            //写入音频数据
            if (mediaType == AVMediaTypeAudio) {
                NSLog(@"audio time %lf", CMTimeGetSeconds(mTimeStamp));
                if (self.assetWriterAudioInput.readyForMoreMediaData) {
                    BOOL success = [self.assetWriterAudioInput appendSampleBuffer:sampleBuffer];
                    if (!success) {
                        @synchronized (self) {
                            [self stopWriteWithCompletionHandler:nil];
                            [self destroyWrite];
                        }
                    }
                }
            }
            
            CFRelease(sampleBuffer);
        }
    } );
}





+ (BOOL)appendToAdapter:(AVAssetWriterInputPixelBufferAdaptor*)adaptor
            pixelBuffer:(CVPixelBufferRef)buffer
                 atTime:(CMTime)presentTime
              withInput:(AVAssetWriterInput*)writerInput
{
    while (!writerInput.readyForMoreMediaData) {
        usleep(1);
    }
    
    return [adaptor appendPixelBuffer:buffer withPresentationTime:presentTime];
}




#pragma mark - public methed
- (void)startWrite
{
    self.writeState = FMRecordStatePrepareRecording;
    if (!self.assetWriter) {
        [self setUpWriter];
    }
    
}
- (void)stopWriteWithCompletionHandler:(void (^)(NSString *))completion
{
    self.shareBlock = completion;
    self.writeState = FMRecordStateFinish;
    __weak __typeof(self)weakself = self;
    if(_assetWriter && _assetWriter.status == AVAssetWriterStatusWriting){
        dispatch_async(self.writeQueue, ^{
            
            [[NSFileManager defaultManager] removeItemAtPath:weakself.videoUrl.absoluteString error:nil];
            
            [_assetWriter finishWritingWithCompletionHandler:^{
                     
                //add watermark and write to photo library
                [weakself appendWatermarkWithURL:weakself.videoUrl completionHandler:^{
                    NSError *removeError;
                    [[NSFileManager defaultManager] removeItemAtURL:weakself.videoUrl error:&removeError];
                    if (removeError) {
                        NSLog(@"删除失败：%@", removeError);
                    }
                    [weakself uploadVideoToQN];
                    [LCNoticeAlertView showMsg:ESLocalizedString(@"视频已保存到相册")];
                    [weakself destroyWrite];
                    
                }];
                
            }];
        });
    }else if(_assetWriter){
        NSLog(@"++++++++ writing status: %ld +++++++++", (long)_assetWriter.status);
        NSLog(@"++++++++ error: %@", _assetWriter.error);
    }
}

#pragma mark-上传视频
- (void)uploadVideoToQN {
    __weak __typeof(&*self) weak_self = self;//ESWeakSelf;
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:nil
                                                  withPath:URL_LIVE_UPLOAD_TOKEN
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:^(NSDictionary *responseDic) {
//                                              ESStrongSelf;
//                                              __typeof(&*weak_self) self = weak_self;
                                              NSString *token = responseDic[@"token"];
                                              [weak_self uploadWithToken:token];
                                              
                                            }withFailBlock:^(NSError *error) {
                                                
                                            }];
}
- (void)uploadWithToken:(NSString *)token
{
    ESWeakSelf;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *outputPath = paths[0];
    outputPath = [outputPath stringByAppendingString:@"/output.mp4"];
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:outputPath options:NSDataReadingMappedIfSafe error:&error];
    if(data == nil && error!=nil) {
        //Print error description
        NSLog(@"convert to data failed: %@", error);
    }
//    QNConfiguration *config =[QNConfiguration build:^(QNConfigurationBuilder *builder) {
//        NSMutableArray *array = [[NSMutableArray alloc] init];
//        [array addObject:[QNResolver systemResolver]];
//        QNDnsManager *dns = [[QNDnsManager alloc] init:array networkInfo:[QNNetworkInfo normal]];
//        //是否选择  https  上传
//        builder.zone = [[QNAutoZone alloc] initWithHttps:YES dns:dns];
//        //设置断点续传
//        NSError *error;
//        builder.recorder =  [QNFileRecorder fileRecorderWithFolder:@"sharevideos" error:&error];
//    }];
    BOOL isHttps = TRUE;
    QNZone * httpsZone = [[QNAutoZone alloc] initWithHttps:isHttps dns:nil];
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.zone = httpsZone;
    }];
    QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
    
    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:@"video/mp4" progressHandler:^(NSString *key, float percent) {
        NSLog(@"key == %@,  percent == %.2f", key, percent);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadProgressNotification" object:[NSNumber numberWithFloat:percent]];
    }
                                                                 params:nil
                                                               checkCrc:NO
                                                     cancellationSignal:nil];
    __weak typeof(self)weakself = self;
    [upManager putData:data key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        NSLog(@"info ===== %@", info);
        NSLog(@"key ==== %@", key);
        NSLog(@"resp ===== %@", resp);
        NSString *videoUrl = [NSString stringWithFormat:@"%@%@",URL_UPLOADED_VIDEO_HEAD, [resp objectForKey:@"key"]];
        
        [LCMyUser mine].videoURL = videoUrl;
        
        if (videoUrl && videoUrl.length > 0) {
           if(weakself.shareBlock) weakself.shareBlock(videoUrl);
            
        }
        
    } option:uploadOption];
    
}

#pragma mark - private method
//设置写入视频属性
- (void)setUpWriter
{
    self.assetWriter = [AVAssetWriter assetWriterWithURL:self.videoUrl fileType:AVFileTypeMPEG4 error:nil];
    // 视频设置
    NSInteger videoWidth = [[NSNumber numberWithFloat:ScreenWidth] integerValue];
    NSInteger videoHeight = [[NSNumber numberWithFloat:ScreenHeight] integerValue];
    if (videoWidth % 2 == 1) {
        videoWidth = videoWidth - 1;
    }
    if (videoHeight % 2 == 1) {
        videoHeight = videoHeight - 1;
    }
    NSDictionary *outputSettings = @{AVVideoCodecKey : AVVideoCodecH264, AVVideoWidthKey : @(videoWidth), AVVideoHeightKey : @(videoHeight)};
    _assetWriterVideoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:outputSettings];
    _assetWriterVideoInput.expectsMediaDataInRealTime = YES;
    
    NSDictionary *sourcePixelBufferAttributes = @{(NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_420YpCbCr8Planar)};
    self.writerAdaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:_assetWriterVideoInput
                                                                                                sourcePixelBufferAttributes:sourcePixelBufferAttributes];
    
    // 音频设置
    AudioChannelLayout acl;
    bzero( &acl, sizeof(acl));
    acl.mChannelLayoutTag = kAudioChannelLayoutTag_Mono;
    
    self.audioCompressionSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [ NSNumber numberWithInt: kAudioFormatMPEG4AAC], AVFormatIDKey,
                                     [ NSNumber numberWithInt: 1 ], AVNumberOfChannelsKey,
                                     [ NSNumber numberWithFloat: [AVAudioSession sharedInstance].sampleRate], AVSampleRateKey,
                                     [ NSData dataWithBytes: &acl length: sizeof( acl ) ], AVChannelLayoutKey,
                                     //[ NSNumber numberWithInt:AVAudioQualityLow], AVEncoderAudioQualityKey,
                                     [ NSNumber numberWithInt: 96000], AVEncoderBitRatePerChannelKey,
                                     nil];
    
    _assetWriterAudioInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:self.audioCompressionSettings];
    _assetWriterAudioInput.expectsMediaDataInRealTime = NO;
    
    
    if ([_assetWriter canAddInput:_assetWriterVideoInput]) {
        [_assetWriter addInput:_assetWriterVideoInput];
    }else {
        NSLog(@"AssetWriter videoInput append Failed");
    }
    if ([_assetWriter canAddInput:_assetWriterAudioInput]) {
        [_assetWriter addInput:_assetWriterAudioInput];
    }else {
        NSLog(@"AssetWriter audioInput Append Failed");
    }
    
    
    self.writeState = FMRecordStateRecording;
    
}
- (void)destroyWrite
{
    self.assetWriter = nil;
    self.assetWriterAudioInput = nil;
    self.assetWriterVideoInput = nil;
    self.videoUrl = nil;
   
}
- (void)dealloc
{
    [self destroyWrite];
}

@end
