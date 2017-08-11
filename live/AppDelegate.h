//
//  AppDelegate.h
//  live
//
//  Created by kenneth on 15-7-9.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic)BOOL Launching;

@property (strong, nonatomic) UIWindow *window;


+ (instancetype)sharedAppDelegate;

//- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;

//- (void)pushViewController:(UIViewController *)vc animated:(BOOL)flag;

- (void)enterMain;

- (void)makeSelfVisible;

@end

