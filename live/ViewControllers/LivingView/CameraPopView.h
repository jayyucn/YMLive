//
//  CameraPopView.h
//  qianchuo
//
//  Created by jacklong on 16/5/1.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//
#import "DXPopover.h"

@protocol CameraPopViewDelegate  <NSObject>
- (void)onShanLightController:(int)state;// 开关闪光灯

- (void)onCameraController:(int)state;// 翻转控制

- (void)onBeautyController:(int)state;// 美颜控制
@end

@interface CameraPopView : NSObject

ES_SINGLETON_DEC(cameraPopView);

@property (nonatomic,weak) id<CameraPopViewDelegate> delegate;

- (void) showPopoverWithView:(UIView *)view withTargetView:(UIView *)targetView;

- (void) initPopViewData;

- (void) setPopViewData:(NSArray *)configs;

- (BOOL) popViewIsHidden;
@end
