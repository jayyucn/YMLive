//
//  KFAlertWindow.h
//  KaiFang
//
//  Created by Elf Sundae on 13-12-24.
//  Copyright (c) 2013年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LCAlertWindow : UIWindow
/// app原来的keyWindow
@property (nonatomic, retain, readonly) UIWindow *appKeyWindow;

+ (instancetype)sharedWindow;

/**
 * 将view addSubView到alertWindow上面，然后显示。
 *
 * @param view 要显示的view
 */
- (void)showView:(UIView *)view;
/**
 * 移除view并隐藏自己，如果alertView上面还有其他试图，不会影响其他试图的显示.
 *
 * @param view 要影藏的view
 */
- (void)dismissView:(UIView *)view;
/**
 * Dismiss所有由此alertWindow显示的View
 */
- (void)dismissAll;


/**
 * Sigleton
 */
+ (id)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
- (id)init __attribute__((unavailable("init not available, call sharedInstance instead")));
+ (id)new __attribute__((unavailable("new not available, call sharedInstance instead")));

@end
