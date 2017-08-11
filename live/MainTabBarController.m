//
//  MainTabBarController.m
//  live
//
//  Created by kenneth on 15-7-9.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//
#import "MainTabBarController.h"
#import "Macro.h"
#import "IPAddressUtil.h"
#import "UIImage+Category.h"
#import "DoLiveViewController.h"
#import "WatchCutLiveViewController.h"
#import "PushLiveViewController.h"
#import "FindViewController.h"
#import "OneToOneSquareViewController.h"

#import "MBProgressHUD.h"
#import "WatchLiveTableViewController.h"
#import "BaseNavigationController.h"
#import "MyInfoViewController.h"
#import "AFNetworking.h"
#import "ShowAdView.h"
#import "ShowWebViewController.h"
#import "NSObject+LYDealloc.h"
#import <AVFoundation/AVBase.h>
#import <AVFoundation/AVAudioSession.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <CoreAudio/CoreAudioTypes.h>
@import CoreTelephony;

@interface MainTabBarController ()<UITabBarControllerDelegate /*,TIMConnListenerImplDelegate*/>
{
    WatchLiveTableViewController *_watchController;
    MyInfoViewController         *_myController;
    FindViewController           *_findViewController;
    OneToOneSquareViewController *_oneToOneSquareVC;
    MBProgressHUD                *_HUD;
    UIButton                     *_liveButton;
    UIButton                     *_liveButtonBg;
    UIView                       *_lineView;
}

@end

@implementation MainTabBarController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self initTabBar];
    
    /*
    #ifdef DEBUG
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            SEL memoryWarningSel = @selector(_performMemoryWarning);
            if ([[UIApplication sharedApplication] respondsToSelector:memoryWarningSel])
            {
                [[UIApplication sharedApplication] performSelector:memoryWarningSel];
                
                NSLog(@"WRAING");
            }
            else
            {
                NSLog(@"%@", @"Whoops UIApplication no loger responds to - _performMemoryWarning");
            }
        });
    #endif
     */
    
#ifdef DEBUG
    [self checkHTTPS];
#endif
    
    [self checkIPAddress];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{  // 必须放在后台线程，会卡主UI线程
        [self showWifiInfo];
        if (ESOSVersionIsAbove8() && !ESOSVersionIsAbove9()) { // 只有iOS 8存在问题，需要修复
            [NSObject hookNSObjectDealloc];
        }
    });
    
}

- (void) showWifiInfo
{
    // NSFoundationVersionNumber_iOS_8_4
    if (NSFoundationVersionNumber > 1299) {
        CTCellularData *cellularData = [[CTCellularData alloc]init];
        cellularData.cellularDataRestrictionDidUpdateNotifier =  ^(CTCellularDataRestrictedState state){
            //获取联网状态
            switch (state) {
                case kCTCellularDataRestricted:
                    NSLog(@"Restricrted");
                {
                    UIAlertView *alterView = [UIAlertView alertViewWithTitle:@"设置存在问题" message:@"是否为应用打开网络" cancelButtonTitle:@"否" didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        if (buttonIndex == 0) {
                            NSLog(@"Restricted");
                            NSURL *url = [NSURL URLWithString:@"prefs:root=WIFI"];
                            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                [[UIApplication sharedApplication] openURL:url];
                            } else {
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                            }
                        }
                    } otherButtonTitles:@"是", nil];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [alterView show];
                    });
                    
                }
                    break;
                case kCTCellularDataNotRestricted:
                {
                    NSLog(@"Not Restricted");
                    
                }
                    break;
                case kCTCellularDataRestrictedStateUnknown:
                {
                    NSLog(@"Unknown");
                }
                    break;
                default:
                    break;
            };
        };
    }
}

#pragma mark 初始化Tab
- (void)initTabBar
{
    //网络时间代理
#if 0 //-elf
    [MultiIMManager sharedInstance].connListenerImpl.delegate = self;
#endif
    //初始化MBProgressHUD
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    [_HUD show:YES];
    _HUD.hidden = YES;
    self.delegate = self;
    
    //viewcontrollers
    _watchController = [[WatchLiveTableViewController alloc] init];
    BaseNavigationController* firstNav = [[BaseNavigationController alloc] initWithRootViewController:_watchController];
    
    //    _findViewController = [[FindViewController alloc] initWithStyle:UITableViewStyleGrouped hasRefreshControl:NO];
    //    BaseNavigationController* secondNav = [[BaseNavigationController alloc] initWithRootViewController:_findViewController];
    
    UIViewController* three = [[UIViewController alloc] init];
    
    //    _oneToOneSquareVC = [[OneToOneSquareViewController alloc] init];
    //    BaseNavigationController* fourNav = [[BaseNavigationController alloc] initWithRootViewController:_oneToOneSquareVC];
    
    _myController = [[MyInfoViewController alloc] init];
    BaseNavigationController* fiveNav = [[BaseNavigationController alloc] initWithRootViewController:_myController];
    fiveNav.navigationBarHidden = YES;
    self.viewControllers = [NSArray arrayWithObjects:firstNav,three,fiveNav,nil];
    
    //获取tabBarItem
    UITabBarItem *watchLiveItem = [self.tabBar.items objectAtIndex:0];
    //    UITabBarItem *findItem = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *doLiveItem = [self.tabBar.items objectAtIndex:1];
    //    UITabBarItem *oneToOneSquareItem = [self.tabBar.items objectAtIndex:3];
    UITabBarItem *myCenterItem = [self.tabBar.items objectAtIndex:2];
    //设置tabBarItem背景图标
    [self setTabBarItem:watchLiveItem withNormalImageName:@"image/tab/watch_tab_icon_f" andSelectedImageName:@"image/tab/watch_tab_icon_n" andTitle:@"首页"];
    [self setTabBarItem:doLiveItem withNormalImageName:@"" andSelectedImageName:@""  andTitle:@""];
    [self setTabBarItem:myCenterItem withNormalImageName:@"image/tab/myinfo_tab_icon_f" andSelectedImageName:@"image/tab/myinfo_tab_icon_n" andTitle:@"用户中心"];
    
    //设置未选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    //设置选中字体颜色
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ColorPink, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    //设置tabbar背景颜色
    [[UITabBar appearance] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] andSize:self.tabBar.frame.size]];
    //      [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"image/liveroom/tab_bg"]];
    [[UITabBar appearance] setShadowImage:[UIImage imageWithColor:[UIColor clearColor] andSize:CGSizeMake(SCREEN_WIDTH, 1)]];
    
    //设置tabbarcontroller的tabbaritem图片的大小
    UIImage *tabbarimage=[UIImage imageNamed:@"image/liveroom/tab_bg"];
    UIImageView *tabBarBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -12,
                                                                                           self.tabBar.frame.size.width, self.tabBar.frame.size.height+10)];
    //tabBarBackgroundImageView.contentMode = UIViewContentModeScaleAspectFit;//效果将按原图原来的比例缩放
    tabBarBackgroundImageView.image =tabbarimage;
    [self.tabBar insertSubview:tabBarBackgroundImageView atIndex:0]; //atIndex决定你的图片显示在标签栏的哪一层
    
    _liveButtonBg = [UIButton buttonWithType:UIButtonTypeCustom];
    _liveButtonBg.frame = CGRectMake(SCREEN_WIDTH/3, -40, SCREEN_WIDTH/3, 80);
    _liveButtonBg.backgroundColor = [UIColor clearColor];
    _liveButtonBg.adjustsImageWhenHighlighted = NO;//去除按钮的按下效果（阴影）
    _liveButtonBg.userInteractionEnabled = NO;
   
    //我来直播
    _liveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _liveButton.frame = CGRectMake(self.tabBar.frame.size.width / 2 - 40, -35, 80, 80);
    [_liveButton setImage:[UIImage imageNamed:@"image/tab/live_tab_icon_n"] forState:UIControlStateNormal];
    [_liveButton setImage:[UIImage imageNamed:@"image/tab/live_tab_icon_f"] forState:UIControlStateHighlighted];
    _liveButton.adjustsImageWhenHighlighted = NO;//去除按钮的按下效果（阴影）
    [_liveButton addTarget:self action:@selector(liveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserStartPageInfo]) {
        
        ShowAdView *showAdView = [[ShowAdView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        showAdView.advDict = [[NSUserDefaults standardUserDefaults] objectForKey:kUserStartPageInfo];
        ESWeakSelf;
        [showAdView setCallbackBlock: ^(){
            ESStrongSelf;
            [self checkLuanchOption];
        }];
        showAdView.adDetailBlock = ^(){
            ESStrongSelf;
            NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:kUserStartPageInfo];
            NSString *webUrl = dict[@"url"];
            if (webUrl) {
                if ([webUrl rangeOfString:@"itunes.apple.com"].location != NSNotFound) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webUrl]];
                } else {
                    ShowWebViewController *showWebVC = [[ShowWebViewController alloc] init];
                    showWebVC.isShowRightBtn = YES;
                    showWebVC.rightBtnTitleStr = ESLocalizedString(@"关 闭");
                    BaseNavigationController *adNav = [[BaseNavigationController alloc] initWithRootViewController:showWebVC];
                    
                    showWebVC.hidesBottomBarWhenPushed = YES;
                    showWebVC.webTitleStr = dict[@"title"];
                    showWebVC.webUrlStr = webUrl;
                    
                    [[ESApp rootViewController] presentViewController:adNav animated:YES completion:nil];
                }
            }
        };
        [showAdView showView:self.view];
    }
    else {
        [self checkLuanchOption];
    }
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self checkLuanchOption];
    }];
}

#pragma mark 进入直播
- (void)checkLuanchOption {
    NSDictionary *option = [[NSUserDefaults standardUserDefaults] objectForKey:kUserLaunchOptions];
    if (option) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserLaunchOptions];
        if (option[@"LIVE"] && option[@"NICKNAME"] && ![LCMyUser mine].liveUserId ) { // 打开直播间
            UIAlertView *alterView = [UIAlertView alertViewWithTitle:nil message:[NSString stringWithFormat:@"是否进入%@的直播间", option[@"NICKNAME"]] cancelButtonTitle:@"否" didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 0 && option[@"LIVE"]) {
                    WatchCutLiveViewController *watchLiveViewController = [[WatchCutLiveViewController alloc ] init];
                    watchLiveViewController.mFromPush = YES;
                    [LCMyUser mine].liveUserId = option[@"LIVE"];
                    [LCMyUser mine].liveType = LIVE_WATCH;
                    watchLiveViewController.liveArray = [NSMutableArray array];
                    watchLiveViewController.pos = 0;
                    
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:watchLiveViewController];
                    
                    [self presentViewController:navigationController animated:NO completion:nil];
                }
            } otherButtonTitles:@"是", nil];
            
            [alterView show];
        }
    }
}


#pragma mark 点击我来直播
- (void)liveButtonClicked
{
    // 判断是否是模拟器
    if ([[UIDevice systemVersion]  isEqualToString:@"iPhone Simulator"]) {
        [self showInfo:@"请用真机进行测试, 此模块不支持模拟器测试"];
        return ;
    }
    
    // 判断是否有摄像头
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [self showInfo:@"您的设备没有摄像头或者相关的驱动, 不能进行直播"];
        return;
    }
    
    // 判断是否有摄像头权限
    AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
        [self showInfo:@"app需要访问您的摄像头。\n请启用摄像头-设置/隐私/摄像头"];
        return;
    }
    
    // 开启麦克风权限
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                return YES;
            }
            else {
                [self showInfo:@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"];
                return NO;
            }
        }];
    }
    
    
    PushLiveViewController *_liveController = [[PushLiveViewController alloc] init];
    
    [LCMyUser mine].liveUserId = [LCMyUser mine].userID;
    [LCMyUser mine].liveUserName = [LCMyUser mine].nickname;
    [LCMyUser mine].liveUserLogo = [LCMyUser mine].faceURL;
    [LCMyUser mine].liveUserGrade = [LCMyUser mine].userLevel;
    [LCMyUser mine].livePraiseNum = @"0";
    [LCMyUser mine].liveType = LIVE_DOING;
    
    UINavigationController * doLiveNav = [[UINavigationController alloc] initWithRootViewController:_liveController];
    doLiveNav.navigationBarHidden = YES;
    doLiveNav.navigationBar.frame =  CGRectMake(0, STATUS_HEIGHT, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT);
    [_watchController presentViewController:doLiveNav animated:YES completion:nil];
}

- (void)showInfo:(NSString *)info
{
    if ([self isKindOfClass:[UIViewController class]] || [self isKindOfClass:[UIView class]]) {
        //        [[[UIAlertView alloc] initWithTitle:@"有美直播" message:info delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil] show];
        
        UIAlertView *alert = [UIAlertView alertViewWithTitle:@"有美直播" message:info cancelButtonTitle:@"取消" didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex)
                              {
                                  if(buttonIndex != alertView.cancelButtonIndex)
                                  {
                                      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                  }
                              } otherButtonTitles:@"设置", nil];
        [alert show];
    }
}

#pragma mark 设置tabBarItem默认图标和选中图标
- (void)setTabBarItem:(UITabBarItem*) tabBarItem withNormalImageName:(NSString*)normalImageName andSelectedImageName:(NSString*)selectedImageName andTitle:(NSString*)title{
    [tabBarItem setImage:[[UIImage imageNamed:normalImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem setSelectedImage:[[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem setTitle:title];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if ([tabBarController.childViewControllers indexOfObject:viewController] == 1) {
        // 中间的不可选取
        return NO;
    }
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if (tabBarController.selectedIndex == 1)
    {
        _lineView.hidden = NO;
    }
    else
    {
        _lineView.hidden = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if(_liveButton.superview != nil){
        [_liveButton removeFromSuperview];
    }
    [self.tabBar addSubview:_liveButton];
    
    if (_liveButtonBg.superview != nil) {
        [_liveButtonBg removeFromSuperview];
    }
    [self.tabBar addSubview:_liveButtonBg];
    
    if (_lineView.superview != nil) {
        [_lineView removeFromSuperview];
    }
    [self.tabBar addSubview:_lineView];
    
}

- (void)checkHTTPS {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:@"https://www.baidu.com/"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"https失败 error %@", error);
            
        } else {
            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
            if (responseCode == 200) {
                NSString* string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"https成功 %@", string);
            }
            else{
                NSLog(@"https失败 %@", response);
            }
        }
    }];
    [task resume];
}

#pragma mark - check
- (void)checkIPAddress {
    NSString* string = [IPAddressUtil getIPAddressIsIPv4:YES];
    if ([IPAddressUtil isValidatIP:string]) {
        NSDate* savedTimestamp = [[NSUserDefaults standardUserDefaults] objectForKey:IPAddressTimestampKey];
        NSString* savedServerIPAddress = [[NSUserDefaults standardUserDefaults] objectForKey:ServerIPAddressKey];
        NSDate* now = [NSDate dateWithTimeIntervalSinceNow:0];
        if (savedTimestamp && savedServerIPAddress && [now timeIntervalSinceDate:savedTimestamp] < 0) { // 一直更新
            // 不需要更新
            NSLog(@"%@ : %@ \n拉流IP地址", savedTimestamp, savedServerIPAddress);
        }
        else
        {
            // 需要更新
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:IPAddressTimestampKey];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:ServerIPAddressKey];
            
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:@"http://120.92.234.96/d?dn=play2.zhibo12345.com"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"拉流失败 error %@", error);
                    
                } else {
                    NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                    if (responseCode == 200) {
                        NSString* string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        NSLog(@"拉流成功 %@", string);
                        if (string) {
                            NSArray* array = [string componentsSeparatedByString:@";"];
                            if (array && array.count > 0) {
                                long index = arc4random() % array.count;
                                [[NSUserDefaults standardUserDefaults] setObject:[NSDate dateWithTimeIntervalSinceNow:0] forKey:IPAddressTimestampKey];
                                [[NSUserDefaults standardUserDefaults] setObject:array[index] forKey:ServerIPAddressKey];
                                NSLog(@"缓存%@", array[index]);
                            }
                        }
                    }
                    else{
                        NSLog(@"拉流失败 ");
                    }
                }
            }];
            [task resume];
        }
    }
}

#pragma mark 消息和连接代理
#if 0 //-elf
- (void)onConnSucc
{
    NSNumber* status = [NSNumber numberWithInt:NETWORK_CONN];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_IMNETWORK object:status];
}

- (void)onConnFailed:(int)code err:(NSString*)err
{
    NSNumber* status = [NSNumber numberWithInt:NETWORK_FAIL];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_IMNETWORK object:status];
}

- (void)onDisconnect:(int)code err:(NSString*)err
{
    NSNumber* status = [NSNumber numberWithInt:NETWORK_DISCONN];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_IMNETWORK object:status];
}
#endif
@end
