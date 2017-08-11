//
//  CaptureUtil.h
//  qianchuo
//
//  Created by 林伟池 on 16/9/19.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface CaptureUtil : NSObject

@property (nonatomic , strong) UIView* mCaptureView;

#pragma mark - init
+ (instancetype)shareInstance;


#pragma mark - update

- (void)startCapture;
- (void)stopCapture;


#pragma mark - get




#pragma mark - message

@end
