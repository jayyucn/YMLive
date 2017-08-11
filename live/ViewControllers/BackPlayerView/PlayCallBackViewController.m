//
//  PlayCallBackViewController.m
//  qianchuo
//
//  Created by jacklong on 16/8/8.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "PlayCallBackViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "Reachability.h"
#import "KSYBasePlayView.h"
#import "KSYProgressToolBar.h"
#import "PlayBackFloatView.h"
#import "RechargeViewController.h"
#import "TopsRankControlView.h"
#import "LiveChatListViewController.h"
#import "LiveChatDetailViewController.h"
#import "LuxuryManager.h"
#import "UserSpaceViewController.h"

@interface  PlayCallBackViewController()<PlayBackFloatViewDelegate>
{
    BOOL isPausePlayback;
    UINavigationController *chatNavigationController;
}

//@property (nonatomic, strong) UIButton        *closeCallBackViewController;

@property (nonatomic, strong) KSYBasePlayView *playView;
@property (nonatomic, strong) KSYProgressToolBar *progressToolBar;
@property (nonatomic, strong) PlayBackFloatView *floatView;

@end

@implementation PlayCallBackViewController


- (void)dealloc
{
    NSLog(@"dealloc %@",NSStringFromClass(self.class));
  
}


- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self initPlayBackView]; 
    
    // 暂停直播
    [[NSNotificationCenter defaultCenter] postNotificationName:HuoWuLive_PAUSE_NOTIFION object:nil];
    
    // 暂停回放
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playOnPause) name:AUCALLBACKPLAY_PAUSE_NOTIFITION object:nil];
}

- (void) initPlayBackView
{
    [LCMyUser mine].playBackUserId = _playerUid;
    [LCMyUser mine].playVdoid = _playVdoid;
    
    
    _playView = [[KSYBasePlayView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) urlString:_playerCallBackUrl];
    
    [self.view addSubview:_playView];
    
    
    _floatView = [[PlayBackFloatView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _floatView.delegate = self;
    [self.view addSubview:_floatView];
    
    [_floatView updateRecvDiamond:_playBackDict[@"recv_diamond"]];
    [_floatView.userFaceImageView sd_setImageWithURL:[NSURL URLWithString:[NSString faceURLString:_playBackDict[@"face"]]] placeholderImage:[UIImage imageWithColor:RGB16(COLOR_FONT_WHITE) andSize:_floatView.userFaceImageView.frame.size]];
    if ([_playBackDict[@"grade"] intValue] > 0) {
        _floatView.gradeFlagImgView.image = [UIImage createUserGradeFlagImage:[_playBackDict[@"grade"] intValue] withIsManager:(_playBackDict[@"offical"] && [_playBackDict[@"offical"] intValue] ==1)?true:false];
        _floatView.gradeFlagImgView.hidden = NO;
    } else {
        _floatView.gradeFlagImgView.hidden = YES;
    }
    
    [_floatView showUserCount:[NSString stringWithFormat:@"%d",[_playBackDict[@"visit_total"] intValue]]];
    
    [_floatView.audienceTableView loadAudienceData];
    
    _progressToolBar = [[KSYProgressToolBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 80, SCREEN_WIDTH, 40)];
    _progressToolBar.timeLabel = _floatView.timeLabel;
    ESWeakSelf;
    _progressToolBar.playControlEventBlock = ^(BOOL isStop){
        ESStrongSelf;
        if (isStop) {
            [_self.playView pause];
        }else {
            [_self.playView play];
        }
    };
    _progressToolBar.seekToBlock = ^(double value){
        ESStrongSelf;
        [_self.playView moviePlayerSeekTo:value];
        if ([_self.playView isPlaying]) {
            [_self.playView play];
        }
    };
    [self.view addSubview:_progressToolBar];
    _floatView.progressBar = _progressToolBar;
    
    _playView.progressToolBar = _progressToolBar;
    
    [LuxuryManager luxuryManager].livingView = _floatView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.navigationController.isNavigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    
    if (isPausePlayback) {
        isPausePlayback = NO;
        
        [_playView play];
    }
}


#pragma mark - 暂停点播
- (void) playOnPause
{
    if (isPausePlayback) {
        isPausePlayback = YES;
        [_playView pause];
    }
}

#pragma mark - 重新加载
- (void) setIsAgainLoad:(BOOL)isAgainLoad
{
    _isAgainLoad = isAgainLoad;
    
    if (_isAgainLoad) {
        
        if (_playView) {
            [_playView shutDown];
        }
        
        if (_playView) {
            [_playView removeFromSuperview];
            _playView = nil;
        }
        
        if (_floatView) {
            [_floatView removeFromSuperview];
            _floatView = nil;
        }
        
        if (_progressToolBar) {
            [_progressToolBar removeFromSuperview];
            _progressToolBar = nil;
        }
        
        
        [LCMyUser mine].playVdoid = nil;
        [LCMyUser mine].playBackUserId = nil;
        
        
        [LuxuryManager luxuryManager].livingView = nil;
        
        if ([LuxuryManager luxuryManager].luxuryArray && [LuxuryManager luxuryManager].luxuryArray.count > 0) {
            [[LuxuryManager luxuryManager].luxuryArray removeAllObjects];
        }
        
        [LuxuryManager luxuryManager].isShowAnimation = NO;
        
        
        [self initPlayBackView];
//        [LCMyUser mine].playBackUserId = _playerUid;
//        [LCMyUser mine].playVdoid = _playVdoid;
//    
//        [_floatView updateRecvDiamond:_playBackDict[@"recv_diamond"]];
//        [_floatView.userFaceImageView sd_setImageWithURL:[NSURL URLWithString:[NSString faceURLString:_playBackDict[@"face"]]] placeholderImage:[UIImage imageWithColor:RGB16(COLOR_FONT_WHITE) andSize:_floatView.userFaceImageView.frame.size]];
//
//        if ([_playBackDict[@"grade"] intValue] > 0) {
//            _floatView.gradeFlagImgView.image = [UIImage createUserGradeFlagImage:[_playBackDict[@"grade"] intValue]];
//            _floatView.gradeFlagImgView.hidden = NO;
//        } else {
//            _floatView.gradeFlagImgView.hidden = YES;
//        }
//        
//        [_floatView showUserCount:[NSString stringWithFormat:@"%d",[_playBackDict[@"visit_total"] intValue]]];
//
//        _playView.playerUrl = _playerCallBackUrl;
        
    }
}

- (void) closeCallBackPlayAction
{
    if (_playView) {
        [_playView shutDown];
    }
    
    if (chatNavigationController) {// 正在聊天结果主播退出直播
        [self closeChat];
    }
    
    [LCMyUser mine].playVdoid = nil;
    [LCMyUser mine].playBackUserId = nil;
    
    
    [LuxuryManager luxuryManager].livingView = nil;
    
    if ([LuxuryManager luxuryManager].luxuryArray && [LuxuryManager luxuryManager].luxuryArray.count > 0) {
        [[LuxuryManager luxuryManager].luxuryArray removeAllObjects];
    }
    
    [LuxuryManager luxuryManager].isShowAnimation = NO;
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 

#pragma mark - float delegate

- (void)closeLivingView:(PlayBackFloatView*)livingView
{
    [self closeCallBackPlayAction];
}

// 点亮操作
- (void)loveTap:(PlayBackFloatView*)livingView
{
    if (chatNavigationController) {
        [self closeChat];
        return ;
    }
}


#define BACKGROUND_TAG 1001

- (void)closeChat {
    ESWeakSelf;
    [UIView animateWithDuration:0.5 animations:^{
        ESStrongSelf;
        _self->chatNavigationController.view.top = CGRectGetHeight(self.view.bounds);
    } completion:^(BOOL finished) {
        ESStrongSelf;
        [_self->chatNavigationController removeFromParentViewController];
        [_self->chatNavigationController.view removeFromSuperview];
        UIView* backgroundView = [_self.view viewWithTag:BACKGROUND_TAG];
        [backgroundView removeFromSuperview];
        chatNavigationController = nil;
    }];
}

#pragma mark - 显示会话列表界面
- (void)showConversationVC
{
    if (!chatNavigationController) {
        
        LiveChatListViewController *chatController = [[LiveChatListViewController alloc] init];
        chatController.mNavigationController = self.navigationController;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:chatController];
        chatNavigationController = navigationController;
        
        navigationController.view.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
        
        
        ESWeakSelf;
        chatController.lyLeftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:ESLocalizedString(@"关闭") style:UIBarButtonItemStylePlain handler:^(UIBarButtonItem *barButtonItem) {
            ESStrongSelf;
            [_self closeChat];
        }];
        
        [self addChildViewController:navigationController];
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) / 3)];
        backgroundView.tag = BACKGROUND_TAG;
        [self.view addSubview:navigationController.view];
        [self.view addSubview:backgroundView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint locationInView) {
            ESStrongSelf;
            [_self closeChat];
            [backgroundView removeGestureRecognizer:tap];
        }];
        [backgroundView addGestureRecognizer:tap];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            navigationController.navigationBar.top = CGRectGetHeight(self.view.bounds) / 3 - navigationController.navigationBar.height;
            [UIView animateWithDuration:0.25 animations:^{
                navigationController.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
                //                navigationController.navigationBar.height = 24;
            } completion:^(BOOL finished) {
                NSLog(@"over %@", [navigationController.view description]);
            }];
            
        });
    }
}

#pragma mark 显示私聊
- (void)showPrivChat:(NSDictionary *)userInfoDict
{
    if (![LCMyUser mine].priChatTag || ![[LCMyUser mine].priChatTag isEqualToString:@"0"])
    {
        // 弹出提示
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"很抱歉，您没有私信的权限"
                                   delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil] show];
        
        return;
    }
    
    if (!chatNavigationController) {
        LiveChatDetailViewController *chatController = [[LiveChatDetailViewController alloc] initWithUserInfoDictionary:userInfoDict];
        chatController.viewFrame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
        chatController.mNavigationController = self.navigationController;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:chatController];
        chatNavigationController = navigationController;
        navigationController.navigationBarHidden = YES;
        
        navigationController.view.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
        ESWeakSelf;
        chatController.lyLeftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:ESLocalizedString(@"关闭") style:UIBarButtonItemStylePlain handler:^(UIBarButtonItem *barButtonItem) {
            ESStrongSelf;
            [_self closeChat];
        }];
        
        [self addChildViewController:navigationController];
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) / 3)];
        backgroundView.tag = BACKGROUND_TAG;
        [self.view addSubview:navigationController.view];
        [self.view addSubview:backgroundView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint locationInView) {
            ESStrongSelf;
            [_self closeChat];
            [backgroundView removeGestureRecognizer:tap];
        }];
        [backgroundView addGestureRecognizer:tap];
        
        [UIView animateWithDuration:0.25 animations:^{
            navigationController.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
        }];
    }
    //    [[[ChatViewController alloc] initWithUserInfoDictionary:userInfoDict] pushFromNavigationController:self.navigationController animated:YES];
}


// 显示排行榜
- (void)showRankVC
{
    TopsRankControlView *topsRankVC = [[TopsRankControlView alloc] initWithStyle:UITableViewStylePlain hasRefreshControl:YES];
    topsRankVC.isLiveUser = NO;
    topsRankVC.userId = _playerUid;
    [self.navigationController pushViewController:topsRankVC animated:YES];
}

// 显示用户
- (void)showUserSpaceVC:(LiveUser *)liveUser
{
    NSString *userIdStr = [NSString stringWithFormat:@"%@",liveUser.userId];
    if (!userIdStr || userIdStr.length <= 0) {
        return;
    }
    
    ESWeakSelf;
    UserSpaceViewController *onlineUserVC = [[UserSpaceViewController alloc] init];
    onlineUserVC.liveUser = liveUser;
    onlineUserVC.isShowBg = YES;
    onlineUserVC.privateChatBlock = ^(NSDictionary * userInfoDict) {
        ESStrongSelf;
        [_self showPrivChat:userInfoDict];
    };
    onlineUserVC.showUserHomeBlock = ^(NSString *userId){
        if (!userId) {
            return;
        }
        ESStrongSelf;
        HomeUserInfoViewController *userInfoVC = [[HomeUserInfoViewController alloc] init];
        userInfoVC.userId = userId;
        [_self.navigationController pushViewController:userInfoVC animated:YES];
    };
    [[ESApp rootViewControllerForPresenting] popupViewController:onlineUserVC completion:nil];
}

// 显示充值界面
- (void)showRechargeVC
{
    RechargeViewController *rechargeVC = [[RechargeViewController alloc] init];
    [self.navigationController pushViewController:rechargeVC animated:YES];
}

// 换房间
- (void)changeRoom:(NSDictionary *)userInfoDict
{
    
}

@end
