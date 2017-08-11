//
//  StartVideoLiveView.h
//  qianchuo 开始准备直播view
//
//  Created by jacklong on 16/4/29.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

@protocol StartVideoLiveViewDelegate <NSObject>

- (void)showWebView;

- (void)startLivePush:(NSString*)title;

- (void)closeLiveVC;
@end

@interface StartVideoLiveView : UIView

@property (nonatomic, assign) BOOL isSharing;

@property (nonatomic, strong) UITextField *liveTitleTextView;

@property (nonatomic,weak) id<StartVideoLiveViewDelegate> delegate;

- (void)showView:(UIView*)superView;

// 开始分享
- (void)startLiveAction;
@end
