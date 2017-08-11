//
//  WatchCutLiveViewController.h
//  qianchuo
//
//  Created by jacklong on 16/8/14.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "LivingView.h"

@interface WatchCutLiveViewController : UIViewController

@property (nonatomic, assign) BOOL mFromPush;

@property (nonatomic, assign) NSInteger pos;

@property (nonatomic, strong) NSString *playerUrl;

@property (nonatomic, strong) NSMutableArray *liveArray;

//其他view都加到这个上面，以便于跟着手势移动！
@property (nonatomic, strong) LivingView *livingView;

@property (nonatomic, strong) UIView *panedView;

+ (void) ShowWatchLiveViewController:(UINavigationController *)navController withInfoDict:(NSDictionary *)userInfoDict withArray:(NSMutableArray *)array withPos:(int)pos;

#pragma mark  拖动事件
- (void) handleSwipe:(UIPanGestureRecognizer*) recognizer;

///滑动的时候要切换背景
- (void)showNextAnchorBG;
- (void)showBeforeAnchorBG;

///没有达到预定的阈值，需要还原
- (void)showCurrentAnchorBG;

///超过预定的阈值，展示上一个或者下一个主播
- (void)showNextAnchor;
- (void)showBeforeAnchor;
//隐藏状态栏
- (void)hideStatusBar:(BOOL)hidden;

@end
