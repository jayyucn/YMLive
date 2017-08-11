//
//  DoLiveViewController.m
//  live
//
//  Created by kenneth on 15-7-9.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import "DoLiveViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PushLiveViewController.h"
#import "TrailerLiveViewController.h" 
//#import "MultiVideoViewController.h"

@interface DoLiveViewController ()<TrailerLiveViewDelegate>
{
    BOOL hideStatus;
    PushLiveViewController *_liveController;
    TrailerLiveViewController *_trailerLiveController;
}
@end

@implementation DoLiveViewController

- (void)dealloc
{
    [_liveController removeFromParentViewController];
    [_trailerLiveController removeFromParentViewController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _liveController = [[PushLiveViewController alloc] init];
    
    _trailerLiveController = [[TrailerLiveViewController alloc] init];
    [self addChildViewController:_trailerLiveController];
    [self addChildViewController:_liveController];
  
    
    _liveController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _trailerLiveController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _trailerLiveController.delegate = self;
    [self.view addSubview:_trailerLiveController.view];
  
}

#pragma mark 代理
- (void)startLiveController:(NSString *)title image:(UIImage *)image
{
    hideStatus = NO;
    [self hideStatusBar];
    [LCMyUser mine].liveUserId = [LCMyUser mine].userID;
    [LCMyUser mine].liveUserName = [LCMyUser mine].nickname;
    [LCMyUser mine].liveUserLogo = [LCMyUser mine].faceURL;
    [LCMyUser mine].liveUserGrade = [LCMyUser mine].userLevel;
    [LCMyUser mine].livePraiseNum = @"0";
    [LCMyUser mine].liveType = LIVE_DOING;
    _liveController.liveTitle = title;
//    _liveController.liveImage = image;
    [self transitionFromViewController:_trailerLiveController toViewController:_liveController duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil  completion:nil];
//    UINavigationController *_liveNav = [[UINavigationController alloc] initWithRootViewController:_liveController];
//    _liveNav.navigationBarHidden = YES;
//    [self.navigationController pushViewController:_liveController animated:YES];
    
}

- (void)publishTrailerSuccess
{
    if(self.delegate)
    {
        [self.delegate publishTrailerSuccess];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



#pragma mark 显示status bar
- (void)hideStatusBar
{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return hideStatus;
}
@end