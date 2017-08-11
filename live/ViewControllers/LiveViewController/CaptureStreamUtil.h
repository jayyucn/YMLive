//
//  CaptureStreamUtil.h
//  qianchuo
//
//  Created by 林伟池 on 16/9/19.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface CaptureStreamUtil : NSObject

@property (nonatomic , strong) UIView* mCaptureView;
@property (nonatomic , assign) BOOL mIsCaptureStream;


#pragma mark - init
+ (instancetype)shareInstance;


#pragma mark - update

- (void)startCapture;
- (void)stopCaptureWithCompletionHandler:(void(^)(NSString *videoUrl))completion;


#pragma mark - get

- (void)appendAudioSampleWithRenderBuffer:(AudioBufferList *)sampleBuffer asbd:(AudioStreamBasicDescription)asbd presentTimeStamp:(int64_t)pts;
- (void)appendVideoSample:(CVPixelBufferRef)pixelBuffer presentTimeStamp:(int64_t)pts;


#pragma mark - message

@end

