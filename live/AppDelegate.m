//
//  AppDelegate.m
//  live
//
//  Created by kenneth on 15-7-9.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import "AppDelegate.h"
#import "Macro.h"
#import "Business.h"
#import "LiveGiftFile.h"
#import "XGPush.h"
#import <AVFoundation/AVAudioSession.h>

//#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "MainTabBarController.h"

#import "LCLeadController.h"
#import "KSYLiveInitManager.h"
#import "IMBridge.h"
#import "RechargeViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXPayManager.h"
#import "QCTencentManager.h"
//#import "QCSinaManager.h"
#import "IAPReceiptVerificator.h"
#import <RMStore.h>
#import <Bugly/Bugly.h>
#import <UMengAnalytics/UMMobClick/MobClick.h>

#import <PLStreamingEnv.h>

@interface AppDelegate ()
@property (nonatomic , strong) IAPReceiptVerificator *receiptVerificator;
@end

@implementation AppDelegate

void uncaughtExceptionHandler(NSException *exception) {
    //crash保存
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString* log = [NSString stringWithFormat:@"%@crash:%@\n,stack trace:%@",version,exception,[exception callStackSymbols]];
    [[LCMyUser mine] saveCrash:log];
    [[LCMyUser mine] exitApp];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    [[FBSDKApplicationDelegate sharedInstance] application:application
//                             didFinishLaunchingWithOptions:launchOptions];
//    if (DEFINE_IS_HuoWuLive) {
//        NSLog(@"kkkyes");
//    }
    [Bugly startWithAppId:@"7418fd0bde"];
    _Launching = YES;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = ColorBackGround;
    
    //注册异常处理
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    UIColor *barTintColor = ColorPink;
    //UIColor *barTintColor = [UIColor colorWithRed:0.0/255 green:102.0/255 blue:204.0/255 alpha:1.0];
    
#ifdef kUmengAppKey
    [MobClick setLogEnabled:EnableVendorSDKLog];
    [MobClick setAppVersion:[ESApp appVersion]];
    [MobClick setCrashReportEnabled:NO];
    UMConfigInstance.appKey = kUmengAppKey;
    UMConfigInstance.channelId = kf_config_clientChannel;
    UMConfigInstance.bCrashReportEnabled = NO;
    UMConfigInstance.ePolicy = SEND_INTERVAL;
    [MobClick startWithConfigure:UMConfigInstance];
#endif
    
    /**
     *  信鸽推送
     */
    [XGPush startApp:XGAPP_ID appKey:XGAPP_KEY];
    [XGPush handleLaunching:launchOptions];
    
    if(launchOptions) {
        NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if(remoteNotification) {
            [[NSUserDefaults standardUserDefaults] setObject:remoteNotification forKey:kUserLaunchOptions];
            NSLog(@"推送过来的消息是%@",remoteNotification);
        }
    }
    
    UIColor *barItemColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setBarTintColor:barTintColor];
    [[UINavigationBar appearance] setTintColor:barItemColor];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:barItemColor];
    NSShadow *shadow = [NSShadow new];
    shadow.shadowColor = [UIColor colorWithWhite:0.f alpha:0.7f];
    shadow.shadowOffset = CGSizeMake(0.f, 1.f);
    [[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : barItemColor}];
    
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"showGuidViewx"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"showGuidViewx"];
    }
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : [ESApp sharedApp].userAgentForWebView}];
    
    [Business sharedInstance];
    [[IMBridge bridge] setupRongIMKit];
    
    application.statusBarStyle = UIStatusBarStyleLightContent;
    
    /* setup rootViewController */
    [LCCore globalCore];
    [LCCore getDomainExtend];// 获取扩展域名
    [LiveGiftFile creatGiftDocument];// 生成礼物文件夹
    [KSYLiveInitManager ksylive];// 初始化金山云直播
    
    if ([ESApp isFreshLaunch:NULL]) {
        // 第一次启动时显示启动画面
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"HadShowLeadView"];
        LCLeadController *leadController=[[LCLeadController alloc] init];
        self.window.rootViewController=leadController;
    } else {
        [LCCore presentMainViewController];
        
        // 如果已登录则直接跳进去
        if ([LCMyUser mine].hasLogged) {
            [LCCore globalCore].shouldRequestSync = YES;
            
            [[LCCore globalCore] requestSync];
        } else {  // 否则就请求sync看是登录还是注册
            [[LCStart sharedStart] requestForStart:YES];
        }
    }
    
    //后台定时器开启
    // Override point for customization after application launch.
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&setCategoryErr];
    [[AVAudioSession sharedInstance] setActive:YES error:&activationErr];
    [self makeSelfVisible];
    
    NSSet *set = [NSMutableSet set];
    for (int i = 1; i <= 5; ++i) {
        set = [set setByAddingObject:[NSString stringWithFormat:@"%@.%d", [ESApp appBundleIdentifier], i]];
    }
    
    [[RMStore defaultStore] requestProducts:set
                                    success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
                                        NSLog(@"%@", [invalidProductIdentifiers description]);
                                    } failure:^(NSError *error) {
                                        NSLog(@"%@", error);
                                    }];
    self.receiptVerificator = [[IAPReceiptVerificator alloc] init];
    [RMStore defaultStore].receiptVerificator = self.receiptVerificator;
    
    
    NSDictionary* message = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (message) {
        NSString *payloadMsg = [message objectForKey:@"payload"];
        NSString *record = [NSString stringWithFormat:@"[APN]%@, %@", [NSDate date], payloadMsg];
        
        NSLog(@"%@", record);
    }
    
    [PLStreamingEnv initEnv];
    
    //在 info.plist 中打开 Application supports iTunes file sharing
    if (![[[UIDevice currentDevice] model] isEqualToString:@"iPhone Simulator"]) {
//        [self redirectNSlogToDocumentFolder];
    }    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PauseBgVideo" object:self];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"HadShowLeadView"] boolValue])
    {
        if (_Launching) {
            _Launching=NO;
            return;
        }
        
        if(![[LCMyUser mine] hasLogged])
            [[LCStart sharedStart] requestForStart:NO];
    }
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
//    [FBSDKAppEvents activateApp];
    long num=application.applicationIconBadgeNumber;
    if(num != 0){
        application.applicationIconBadgeNumber = 0;
    }
    [application cancelAllLocalNotifications];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ResumeBgVideo" object:self];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[LCMyUser mine] exitApp];
}


+ (instancetype)sharedAppDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString *urlString=[url absoluteString];
    NSLog(@"urlString==%@",urlString);
    
    if ([urlString rangeOfString:@"wechat"].location != NSNotFound ||  [urlString rangeOfString:@"//oauth"].location != NSNotFound || [urlString rangeOfString:@"//pay"].location != NSNotFound)//微信分享和支付
    {
        return [WXApi handleOpenURL:url delegate:[WXPayManager wxPayManager]];
    }
    else if ([urlString rangeOfString:@"tencent"].location != NSNotFound ||[urlString rangeOfString:kQQAppID].location != NSNotFound)//腾讯
    {
        [QQApiInterface handleOpenURL:url delegate:[QCTencentManager tencentManager]];
        if (YES == [TencentOAuth CanHandleOpenURL:url])
        {
            return [TencentOAuth HandleOpenURL:url];
        }
    } else if ([urlString rangeOfString:@"weibosdk://"].location != NSNotFound || [urlString rangeOfString:kWeiboAppKey].location != NSNotFound) {
//        [WeiboSDK handleOpenURL:url delegate:[QCSinaManager sinaManager]];
    }
    else if ([urlString rangeOfString:@"alith://safepay"].location != NSNotFound) {
        [RechargeViewController aliPaymentResultHandler:url];
    }
//    else if ([urlString rangeOfString:@"com.facebook"].location != NSNotFound) {
//        [[FBSDKApplicationDelegate sharedInstance] application:application
//                                                       openURL:url
//                                             sourceApplication:sourceApplication
//                                                    annotation:annotation];
//    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    return [self application:app openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

- (void)enterMain
{
    MainTabBarController* main = [[MainTabBarController alloc] init];
    self.window.rootViewController = main;
}

- (void)makeSelfVisible
{
    [self.window makeKeyAndVisible];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - notification

- (void)registerPush {
//    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
//    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
//    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
//    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    UIApplication *app = [UIApplication sharedApplication];
    if ([app respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [app registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert |
                                                       UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound)
                                           categories:nil]];
        [app registerForRemoteNotifications];
        
    } else {
        [app registerForRemoteNotificationTypes:(UIUserNotificationTypeAlert |
                                                 UIUserNotificationTypeBadge |
                                                 UIUserNotificationTypeSound)];
    }


    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:5];
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    localNotification.fireDate = date;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertBody = @"Finally got it!";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [[LCCore globalCore] applicationDidFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[LCCore globalCore] applicationDidRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    
    
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"信鸽推送注册成功");
        NSLog(@"信鸽账号%@", [LCMyUser mine].userID);
        // 设置账号
        if ([LCMyUser mine].userID) {
            [XGPush setAccount:[LCMyUser mine].userID];
        }
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"信鸽推送注册失败");
    };
    
    
    //注册设备
    NSString * deviceTokenStr = [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
    
    //打印获取的deviceToken的字符串
    NSLog(@"[XGPush Demo] deviceTokenStr is %@",deviceTokenStr);
}

//注册UserNotification成功的回调
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //用户已经允许接收以下类型的推送
    UIUserNotificationType allowedTypes = [notificationSettings types];
    NSLog(@"用户已经允许接收以下类型的推送 %d", (int)allowedTypes);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[LCCore globalCore] applicationDidReceiveRemoteNotification:userInfo];
    [[IMBridge bridge] showNavMsg:userInfo[@"aps"][@"alert"]];
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
        [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:kUserLaunchOptions];
    }
    //推送反馈(app运行时)
    [XGPush handleReceiveNotification:userInfo];
}

- (void)redirectNSlogToDocumentFolder {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MMddHHmmss"];
    NSString *formattedDate = [dateformatter stringFromDate:currentDate];
    
    NSString *fileName = [NSString stringWithFormat:@"rc%@.log", formattedDate];
    NSString *logFilePath =
    [documentDirectory stringByAppendingPathComponent:fileName];
    
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+",
            stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+",
            stderr);
}


@end
