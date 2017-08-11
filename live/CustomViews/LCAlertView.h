//
//  KFAlertView.h
//  KaiFang
//
//  Created by Elf Sundae on 13-12-24.
//  Copyright (c) 2013年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCAlertWindow.h"

typedef NS_OPTIONS(NSUInteger, LCAlertViewAnimationOption) {
        LCAlertViewAnimationOptionNone = 0,
        LCAlertViewAnimationOptionSmallToBig = 1 << 0, // default
        LCAlertViewAnimationOptionBigToSmall = 1 << 1,
        
        ///////////////////////////////////////////////////////////
        LCAlertViewAnimationOptionCurveEaseInOut = 1 << 10, // default
        ///////////////////////////////////////////////////////////
        
        LCAlertViewAnimationOptionShowGradient = 1 << 20, // default
};


#define LCAlertViewWidth 280.0f
/**
 * 要显示在LCAlertWindow上的view容器, show和dismiss时已带动画
 */
@interface LCAlertView : UIView
{
        /// 第一次显示的时间戳
        NSTimeInterval _firstShowTime;
}


/// 用于放置其他任何UI元素
@property (nonatomic, strong) UIView *backgroundView;
/// 自动隐藏的时间间隔，为0时不自动隐藏
@property (nonatomic) NSTimeInterval autoDismissTimeInterval;
- (BOOL)shouldAutoDismiss;
/// 不管屏幕上点击哪里就隐藏
@property (nonatomic) BOOL shouldDismissWhenTouchsAnywhere;
/// 在shouldDismissWhenTouchsAnywhere为YES时，“强制”显示的最短时间.为0时不强制
@property (nonatomic) NSTimeInterval minShownTime;

@property (nonatomic) BOOL isShowing;

/// 圆角
@property (nonatomic) CGFloat cornerRadius;
/// 阴影
@property (nonatomic) CGFloat shadowRadius;
/// 整个alertWindow的尺寸
- (CGSize)screenSize;

- (void)showWithAnimation:(LCAlertViewAnimationOption)animationOption duration:(NSTimeInterval)animationDuration;
/// 带默认动画效果
- (void)showWithAnimated;
- (void)dismissWithAnimated;
- (void)dismiss;

#pragma mark - Subclass
/// 布局view， 设置BackgroundView和self的frame
- (void)layoutSubviews;




@end
