//
//  LCCore+PresentViewController.m
//  XCLive
//
//  Created by ztkztk on 14-4-12.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCCore.h"

//#import "LCFaceViewController.h"
#import "LCRegisterViewController.h"


//#import "LCSquareViewController.h"
//#import "LCNewsViewController.h"
//#import "LCMessageListViewController.h"
//#import "LCDiscoverViewController.h"
//#import "LCMineViewController.h"
#import "LCLandViewController.h"
//#import "LCStartViewController.h"
//#import "LCVerifyInviteController.h"
#import "KFRegisterFirstController.h"
#import "LCRegDoneController.h"
#import "LoginViewController.h"
#import "BaseNavigationController.h"
#import "MainTabBarController.h"

//#import "DatesRootViewController.h"

@implementation LCCore (PresentViewController)

+(void)presentVerifyInviteController
{
//    LCVerifyInviteController *verifyInviteController = [[LCVerifyInviteController alloc] init];
//    BaseNavigationController *navController=[[BaseNavigationController alloc] initWithRootViewController:verifyInviteController];
//    [[self globalCore].tabBarController presentModalViewController:navController animated:YES];
    
}

+(void)presentStartController
{
    NSLog(@"-++-presentStartController");
//    LCStartViewController *startController = [[LCStartViewController alloc] init];
//    BaseNavigationController *navController=[[BaseNavigationController alloc] initWithRootViewController:startController];
//    [LCCore keyWindow].rootViewController=navController;
//    
}

+(void)presentFaceViewController
{
//    LCFaceViewController *faceController = [[LCFaceViewController alloc] init];
//    [LCCore keyWindow].rootViewController=faceController;
    //[faceController pickFromCamera];
    
}

+(void)presentMainViewController
{
    if (![LCMyUser mine].hasLogged) {
        [[LCMyUser mine] save];
    } else {
        // 同步关注列表
        [[LCCore globalCore] requestAttentUserArray];
    }
    
    [LCCore globalCore].isEnterHome = YES;
    
    MainTabBarController* main = [[MainTabBarController alloc] init];
    [LCCore keyWindow].rootViewController = main;
}

+(void)presentRegisterController
{
    LCRegisterViewController *registerController=[[LCRegisterViewController alloc] init];
    BaseNavigationController *registerNavController=[[BaseNavigationController alloc] initWithRootViewController:registerController];
    [LCCore keyWindow].rootViewController=registerNavController; 
}

+(void)presentRegisterDetailController
{
    LCRegDoneController *registerDetailController=[[LCRegDoneController alloc] initWithStyle:UITableViewStyleGrouped hasRefreshControl:NO];
    BaseNavigationController *registerNavController=[[BaseNavigationController alloc] initWithRootViewController:registerDetailController];
    [LCCore keyWindow].rootViewController=registerNavController;
//    [[LCCore keyWindow] makeKeyAndVisible];
}

+(void)presentRegisterFirstController
{
    KFRegisterFirstController *registerController=[[KFRegisterFirstController alloc]init];
    BaseNavigationController *registerNavController=[[BaseNavigationController alloc] initWithRootViewController:registerController];
    [LCCore keyWindow].rootViewController=registerNavController;
//    [[LCCore keyWindow] makeKeyAndVisible];
}

+(void)presentRegisterSecondController
{
    LCRegDoneController *registerController=[[LCRegDoneController alloc] initWithStyle:UITableViewStyleGrouped hasRefreshControl:NO];
    BaseNavigationController *registerNavController=[[BaseNavigationController alloc] initWithRootViewController:registerController];
    [LCCore keyWindow].rootViewController=registerNavController; 
}

+(void)presentLandController
{
    /*
    LCLandViewController *landController=[[LCLandViewController alloc] init];
    BaseNavigationController *landNavController=[[BaseNavigationController alloc] initWithRootViewController:landController];
    [LCCore keyWindow].rootViewController=landNavController;
     */
    
    LoginViewController *loginController = [[LoginViewController alloc] init];
    BaseNavigationController *loginNavController = [[BaseNavigationController alloc] initWithRootViewController:loginController];
    [LCCore keyWindow].rootViewController = loginNavController;
}


@end
