//
//  CaptureUtil.m
//  qianchuo
//
//  Created by 林伟池 on 16/9/19.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "CaptureUtil.h"
#import <AssetsLibrary/AssetsLibrary.h>
@import OpenGLES;

@interface CaptureUtil () <AVCaptureAudioDataOutputSampleBufferDelegate>

@property (strong, nonatomic) AVAssetWriter *mWriter;
@property (strong, nonatomic) AVAssetWriterInput *mVideoWriterInput;
@property (strong, nonatomic) AVAssetWriterInput *mAudioWriterInput;
@property (strong, nonatomic) AVAssetWriterInputPixelBufferAdaptor *mVideoWriterAdaptor;
@property (strong, nonatomic) CADisplayLink *mDisplayLink;
@property (strong, nonatomic) AVCaptureSession *mCaptureSession;
@property (strong, nonatomic) AVCaptureConnection *mAudioConnection;


@end


@implementation CaptureUtil {
    dispatch_queue_t mWriterQueue;
    dispatch_queue_t mAudioOutputQueue;
    CMTime mTimeStamp;
    BOOL mIsStart;
    int mFrameInterval;
    UIBackgroundTaskIdentifier mBackgroundIdentifier;
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
        
        mFrameInterval = 2;
        mWriterQueue = dispatch_queue_create("com.qianchuo.HuoWuLive.capture.writer", NULL);
        

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(captureApplicationDidEnterBackground:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(captureApplicationWillEnterForeground:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

#pragma mark - update

- (void)startCapture {
    
    dispatch_async(mWriterQueue, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *moviePath = [[paths lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",@"test"]];
        [[NSFileManager defaultManager] removeItemAtPath:moviePath error:nil];
        
        
        mBackgroundIdentifier = UIBackgroundTaskInvalid;
        NSError *vError = nil;
        self.mWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:moviePath] fileType:AVFileTypeQuickTimeMovie error:&vError];
        
        //Video
        NSDictionary *outputSettings = @{AVVideoCodecKey : AVVideoCodecH264, AVVideoWidthKey : @([UIScreen mainScreen].bounds.size.width), AVVideoHeightKey : @([UIScreen mainScreen].bounds.size.height)};
        self.mVideoWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:outputSettings];
        self.mVideoWriterInput.expectsMediaDataInRealTime = YES;
        
        NSDictionary *sourcePixelBufferAttributes = @{(NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32ARGB)};
        self.mVideoWriterAdaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:self.mVideoWriterInput
                                                                                                    sourcePixelBufferAttributes:sourcePixelBufferAttributes];
        NSParameterAssert(self.mWriter);
        NSParameterAssert([self.mWriter canAddInput:self.mVideoWriterInput]);
        [self.mWriter addInput:self.mVideoWriterInput];
        
        //Audio
        self.mCaptureSession = [[AVCaptureSession alloc] init];
        
        
        AVCaptureDevice *vAudioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        AVCaptureDeviceInput *vAudioIn = [[AVCaptureDeviceInput alloc] initWithDevice:vAudioDevice error:nil];
        if ( [self.mCaptureSession canAddInput:vAudioIn] ) {
            [self.mCaptureSession addInput:vAudioIn];
        }
        
        AVCaptureAudioDataOutput *vAudioOut = [[AVCaptureAudioDataOutput alloc] init];
        // Put audio on its own queue to ensure that our video processing doesn't cause us to drop audio
        mAudioOutputQueue = dispatch_queue_create( "com.qianchuo.HuoWuLive.capture.audio", DISPATCH_QUEUE_SERIAL );
        [vAudioOut setSampleBufferDelegate:self queue:mAudioOutputQueue];
        
        if ( [self.mCaptureSession canAddOutput:vAudioOut] ) {
            [self.mCaptureSession addOutput:vAudioOut];
        }
        self.mAudioConnection = [vAudioOut connectionWithMediaType:AVMediaTypeAudio];
        
        NSDictionary *vOutputSettings = [vAudioOut recommendedAudioSettingsForAssetWriterWithOutputFileType:AVFileTypeQuickTimeMovie];
        self.mAudioWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:vOutputSettings];
        self.mAudioWriterInput.expectsMediaDataInRealTime = YES;
        [self.mWriter addInput:self.mAudioWriterInput];
        
        [self.mWriter startWriting];
        [self.mCaptureSession startRunning];
        
        self.mDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(captureFrame:)];
        self.mDisplayLink.frameInterval = mFrameInterval;
        [self.mDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    });
    
    
}



- (void)cleanup {
    self.mWriter = nil;
    self.mVideoWriterInput = nil;
    self.mVideoWriterAdaptor = nil;
    self.mCaptureSession = nil;
    self.mAudioWriterInput = nil;
    self.mAudioConnection = nil;
    mIsStart = NO;
}

- (void)stopCapture {
    [self.mDisplayLink invalidate];
    
    dispatch_async(mWriterQueue, ^ {
        if (self.mWriter.status != AVAssetWriterStatusCompleted && self.mWriter.status != AVAssetWriterStatusUnknown) {
            [self.mVideoWriterInput markAsFinished];
        }
        [self.mCaptureSession stopRunning];
        [self.mWriter finishWritingWithCompletionHandler:^ {
            ALAssetsLibrary *vAL = [[ALAssetsLibrary alloc] init];
            [vAL writeVideoAtPathToSavedPhotosAlbum:[self.mWriter outputURL] completionBlock:^(NSURL *assetURL, NSError *error) {
                [[NSFileManager defaultManager] removeItemAtURL:[self.mWriter outputURL] error:nil];
                [self cleanup];
                NSString *message = @"success";
                if (error) {
                    message = [error description];
                }
                UIAlertView *alertView = [UIAlertView alertViewWithTitle:@"保存视频" message:message cancelButtonTitle:@"确定" didDismissBlock:nil otherButtonTitles:nil, nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [alertView show];
                });
                
            }];
        }];
    });
}


- (void)captureFrame:(CADisplayLink *)aSender {
    if (!mIsStart) {
        return ;
    }
    dispatch_async(mWriterQueue, ^ {
        if (self.mVideoWriterInput.readyForMoreMediaData) {
            CVReturn vStatus = kCVReturnSuccess;
            CVPixelBufferRef vBuffer = NULL;
            CFTypeRef vBackingData;
            __block UIImage *vScreenshot = nil;
            dispatch_sync(dispatch_get_main_queue(), ^{
                vScreenshot = [self screenshot];
            });
            CGImageRef vImage = vScreenshot.CGImage;
            
            CGDataProviderRef vDataProvider = CGImageGetDataProvider(vImage);
            CFDataRef vData = CGDataProviderCopyData(vDataProvider);
            vBackingData = CFDataCreateMutableCopy(kCFAllocatorDefault, CFDataGetLength(vData), vData);
            CFRelease(vData);
            
            const UInt8 *vBytePtr = CFDataGetBytePtr(vBackingData);
            
            vStatus = CVPixelBufferCreateWithBytes(kCFAllocatorDefault,
                                                   CGImageGetWidth(vImage),
                                                   CGImageGetHeight(vImage),
                                                   kCVPixelFormatType_32BGRA,
                                                   (void *)vBytePtr,
                                                   CGImageGetBytesPerRow(vImage),
                                                   NULL,
                                                   NULL,
                                                   NULL,
                                                   &vBuffer);
            NSParameterAssert(vStatus == kCVReturnSuccess && vBuffer);
            if (vBuffer && self.mWriter.status == AVAssetWriterStatusWriting) {
                if(![self.mVideoWriterAdaptor appendPixelBuffer:vBuffer withPresentationTime:mTimeStamp]) {
                    NSLog(@"%s -> appendPixelBuffer faild", __FUNCTION__);
                    
                }
                CVPixelBufferRelease(vBuffer);
            }
            CFRelease(vBackingData);
        }
    });
}

- (UIImage *)screenshot {
    UIScreen *vMainScreen = [UIScreen mainScreen];
    CGSize vImageSize = vMainScreen.bounds.size;
    UIGraphicsBeginImageContext(vImageSize);
    CGContextRef vContext = UIGraphicsGetCurrentContext();
    UIWindow *vWindow = [(AppDelegate *)[UIApplication sharedApplication].delegate window];
    CGContextSaveGState(vContext);
    CGContextTranslateCTM(vContext, vWindow.center.x, vWindow.center.y);
    CGContextConcatCTM(vContext, [vWindow transform]);
    CGContextTranslateCTM(vContext,
                          -vWindow.bounds.size.width * vWindow.layer.anchorPoint.x,
                          -vWindow.bounds.size.height * vWindow.layer.anchorPoint.y);
    if (self.mCaptureView) {
        [self.mCaptureView.layer renderInContext:vContext];
    }
    else {
        [vWindow.layer.presentationLayer renderInContext:vContext];
    }
    
    CGContextRestoreGState(vContext);
    
    UIImage *vImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return vImage;
}



- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - get

- (void)captureApplicationDidEnterBackground:(id)sender {
    if (mIsStart) {
        [self stopCapture];
    }
}


- (void)captureApplicationWillEnterForeground:(id)sender {
}




#pragma mark - Audio Output Delegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    mTimeStamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    if (!mIsStart) {
        [self.mWriter startSessionAtSourceTime:mTimeStamp];
        mIsStart = YES;
    }
    if ([self.mWriter status] == AVAssetWriterStatusWriting
        && [self.mAudioWriterInput isReadyForMoreMediaData]
        && connection == self.mAudioConnection
        && mIsStart) {
        if (![self.mAudioWriterInput appendSampleBuffer:sampleBuffer]) {
            NSLog(@"%s -> ", __FUNCTION__);
        }
        else {
            NSLog(@"audio time %lf", CMTimeGetSeconds(mTimeStamp));
        }
    }
}


#pragma mark - message

@end
