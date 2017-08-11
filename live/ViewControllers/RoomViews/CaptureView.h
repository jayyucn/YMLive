//
//  CaptureView.h
//  TaoHuaLive
//
//  Created by kellyke on 2017/7/11.
//  Copyright © 2017年 上海七夕. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CaptureDelegate <NSObject>
@optional

-(void)onStartAction:(int)isstart;

@end

typedef void(^BeginBlock)(UIButton *beginBtn);
typedef void(^EndBlock)(UIButton *EndBtn);
typedef void(^CancelBlock)(UIButton *cancelBtn);

@interface CaptureView : UIView

@property (nonatomic, weak) id <CaptureDelegate> delegate;
//- (void)drawProgress:(CGFloat )progress;

//录制段视频
- (void)recordVideoWhenBegin:(BeginBlock)begin
                         end:(EndBlock)end
                   andCancel:(CancelBlock)cancel;
- (void)reset;

@end
