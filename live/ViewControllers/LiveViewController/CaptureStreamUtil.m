//
//  CaptureStreamUtil.m
//  qianchuo
//
//  Created by 林伟池 on 16/9/19.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "CaptureStreamUtil.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AVAssetWriteManager.h"

@interface CaptureStreamUtil ()// <AVAssetWriteManagerDelegate>

@property (strong, nonatomic) AVAssetWriter *mWriter;
@property (strong, nonatomic) AVAssetWriterInput *mVideoWriterInput;
@property (strong, nonatomic) AVAssetWriterInput *mAudioWriterInput;
@property (strong, nonatomic) AVAssetWriterInputPixelBufferAdaptor *mVideoWriterAdaptor;

@property (nonatomic, strong) AVAssetWriteManager *writeManager;

@end


@implementation CaptureStreamUtil {
    dispatch_queue_t mWriterQueue;
    BOOL mIsStart;
    CMTime mTimeStamp;
}


#pragma mark - init

+ (instancetype)shareInstance {
    static id test;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        test = [[[self class] alloc] init];
     
    });
    return test;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        mWriterQueue = dispatch_queue_create("com.qianchuo.HuoWuLive.capture.writer", DISPATCH_QUEUE_SERIAL);

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(captureStreamApplicationDidEnterBackground:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(captureStreamApplicationWillEnterForeground:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

#pragma mark - update
//存放视频的文件夹
- (NSString *)videoFolder
{
    NSString *cacheDir = [XCFileManager cachesDir];
    NSString *direc = [cacheDir stringByAppendingPathComponent:VIDEO_FOLDER];
    if (![XCFileManager isExistsAtPath:direc]) {
        [XCFileManager createDirectoryAtPath:direc];
    }
    return direc;
}
//清空文件夹
- (void)clearFile
{
    [XCFileManager removeItemAtPath:[self videoFolder]];
    
}

//写入的视频路径
- (NSString *)createVideoFilePath
{
    NSString *videoName = [NSString stringWithFormat:@"%@.mp4", [NSUUID UUID].UUIDString];
    NSString *path = [[self videoFolder] stringByAppendingPathComponent:videoName];
    return path;
    
}
- (void)startCapture {
    NSURL *videoUrl;
    if (!videoUrl) {
        videoUrl = [[NSURL alloc] initFileURLWithPath:[self createVideoFilePath]];
//        NSLog(@"Start capture with media path: %@", [self createVideoFilePath]);
    }
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtURL:videoUrl error:&error];
    self.writeManager = [[AVAssetWriteManager alloc] initWithURL:videoUrl viewType:TypeFullScreen];
    
    [self.writeManager startWrite];
}

- (void)stopCaptureWithCompletionHandler:(void (^)(NSString *))completion
{
    [self.writeManager stopWriteWithCompletionHandler:completion];
    
}


- (void)appendVideoSample:(CVPixelBufferRef)pixelBuffer presentTimeStamp:(int64_t)pts
{
    if (!self.writeManager || !pixelBuffer) {
        return;
    }
    CMSampleBufferRef sampleBuffer = [self createVideoSampleWithPixelBuffer:pixelBuffer timeStamp:pts];
    if (self.writeManager.writeState == FMRecordStateRecording) {
        
        [self.writeManager appendSampleBuffer:sampleBuffer ofMediaType:AVMediaTypeVideo];
//        [self.writeManager appendVideoBuffer:pixelBuffer fps:pts];
    }
}

- (void)appendAudioSampleWithRenderBuffer:(AudioBufferList *)sampleBuffer asbd:(AudioStreamBasicDescription)asbd presentTimeStamp:(int64_t)pts
{
    if (!self.writeManager || !sampleBuffer) {
        return;
    }
    CMSampleBufferRef buffer = [self createAudioSampleWithAudioBufferList:sampleBuffer asbd:asbd presentTimeStamp:pts];
    if (self.writeManager.writeState == FMRecordStateRecording) {
        [self.writeManager appendSampleBuffer:buffer ofMediaType:AVMediaTypeAudio];
    }
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - get

- (void)captureStreamApplicationDidEnterBackground:(id)sender {
    if (self.writeManager) {
        [self stopCaptureWithCompletionHandler:nil];
    }
}


- (void)captureStreamApplicationWillEnterForeground:(id)sender {
}





#pragma mark - 将AudioBufferList转化为CMSampleBufferRef
- (CMSampleBufferRef)createVideoSampleWithPixelBuffer:(CVPixelBufferRef)pixelBuffer timeStamp:(int64_t)pts
{
    CFRetain(pixelBuffer);
    CMSampleBufferRef newSampleBuffer = NULL;
    CMSampleTimingInfo timimgInfo = {CMTimeMake(1, 24), CMTimeMake(pts, 1000), kCMTimeInvalid};
    CMVideoFormatDescriptionRef videoInfo = NULL;
    CMVideoFormatDescriptionCreateForImageBuffer(
                                                 NULL, pixelBuffer, &videoInfo);
    CMSampleBufferCreateForImageBuffer(kCFAllocatorDefault,
                                       pixelBuffer,
                                       true,
                                       NULL,
                                       NULL,
                                       videoInfo,
                                       &timimgInfo,
                                       &newSampleBuffer);
    CFRelease(pixelBuffer);
    
    return newSampleBuffer;
}
- (CMSampleBufferRef)createAudioSampleWithAudioBufferList:(AudioBufferList *)bufferList asbd:(AudioStreamBasicDescription)asbd presentTimeStamp:(int64_t)pts

//- (CMSampleBufferRef)createAudioSample:(void *)audioData frames:(UInt32)len timing:(CMSampleTimingInfo)timing
{
    UInt32 len = bufferList->mBuffers[0].mDataByteSize;
    CMSampleTimingInfo timing = {CMTimeMake(1, 24), CMTimeMake(pts, 1000), kCMTimeInvalid};
    
    CMSampleBufferRef buff = NULL;
    static CMFormatDescriptionRef format = NULL;
    
    OSStatus error = 0;
    error = CMAudioFormatDescriptionCreate(kCFAllocatorDefault, &asbd, 0, NULL, 0, NULL, NULL, &format);
    if (error) {
        return NULL;
    }
    
    error = CMSampleBufferCreate(kCFAllocatorDefault, NULL, false, NULL, NULL, format, len/4, 1, &timing, 0, NULL, &buff);
    if (error) {
        return NULL;
    }
    
    error = CMSampleBufferSetDataBufferFromAudioBufferList(buff, kCFAllocatorDefault, kCFAllocatorDefault, 0, bufferList);
    if(error){
        return NULL;
    }
    
    return buff;
}


@end
