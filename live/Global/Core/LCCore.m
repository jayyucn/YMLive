//
//  KFCore.m
//  KaiFang
//
//  Created by Elf Sundae on 8/2/13.
//  Copyright (c) 2013 www.0x123.com. All rights reserved.
//

#import "LCCore.h"
#import "LCMyUser.h"
#import "LCStart.h"
#import "ChatUtil.h"

#import "LCNoticeAlertView.h"

@interface LCCore ()
{
    UIBackgroundTaskIdentifier _backgroundTask;
    NSString *_pushTokenFromServer;
}

@end

@implementation LCCore

@synthesize isAppStoreReviewing = _isAppStoreReviewing;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Global Helper

+ (LCCore *)globalCore
{
    static LCCore *_sharedCore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedCore = [[super alloc] initSharedInstance];
    });
    return _sharedCore;
}

- (id)initSharedInstance
{
    self = [super init];
    if (self) {
        // !!!: 在这里 以及调用的方法里 不要处理UI相关的东西!
        // 因为该方法可能被放在后台线程
        
        /* UIApplication */
        [self _registerNotification:UIApplicationDidReceiveMemoryWarningNotification
                           selector:@selector(applicationDidReceiveMemoryWarning:)];
        [self _registerNotification:UIApplicationWillResignActiveNotification
                           selector:@selector(applicationWillResignActive:)];
        [self _registerNotification:UIApplicationDidBecomeActiveNotification
                           selector:@selector(applicationDidBecomeActive:)];
        [self _registerNotification:UIApplicationDidEnterBackgroundNotification
                           selector:@selector(applicationDidEnterBackground:)];
        [self _registerNotification:ESNetworkReachabilityDidChangeNotification selector:@selector(ESNetworkReachabilityDidChangeNotificationHandler:)];
        
        
        [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        
        if ([kf_config_clientChannel isEqualToString:kClientChannel_AppStore]) {
            id isReviewing = [NSUserDefaults objectForKey:@"is_app_store_reviewing"];
            _isAppStoreReviewing = (isReviewing ? [isReviewing boolValue] : YES);
        }
        
//        [self addNotification:KFSocketReadDataNotification handler:^(NSNotification *notification, NSDictionary *userInfo) {
//            
//            NSDictionary *socketData = userInfo[KFSocketReadDataNotificationKey_Data];
//            if ([socketData isKindOfClass:[NSDictionary class]]) {
//                [_self socketDidReadData:socketData];
//            }
//        }];
        
    }
    return self;
}

- (void)ESNetworkReachabilityDidChangeNotificationHandler:(id)sender
{
    if ([UIDevice currentNetworkReachabilityStatus] != ESNetworkReachabilityStatusNotReachable) {
        if ([[LCCore keyWindow].rootViewController isKindOfClass:[UITabBarController class]]) {
            // -Elf
            [self requestSync];
        } else {
            // 旧逻辑
            [[LCStart sharedStart] requestForStart:NO];
        }
    }
}

-(void)socketDidReadData:(NSDictionary *)dataDic
{
    //NSLog(@"dataDic==%@",dataDic);
    
    
    //NSLog(@"Socket: %@", dataDic);
    NSString *type = nil;
    ESStringVal(&type, dataDic[@"type"]);
    
    NSString *uid = nil;
    ESStringVal(&uid, dataDic[@"uid"]);
    NSString *recv = nil;
    ESStringVal(&recv, dataDic[@"recv"]);
    NSString *localID = nil;
    ESStringVal(&localID, dataDic[@"lid"]);
    NSString *msgID = nil;
    ESStringVal(&msgID, dataDic[@"id"]);
    
    
    if ([type isEqualToString:@"reconn"]) {
        
        NSString *uid = @"";
        ESStringVal(&uid, dataDic[@"uid"]);
        if ([uid isEqualToString:[LCMyUser mine].userID])
        {
            [LCNoticeAlertView showMsg:@"您的账号在其他地方登录，请重新登录！"];
            
            [[LCMyUser mine] reset];
            
            [LCCore presentLandController];
        }
        
    }else if([type isEqualToString:@"kickout"])
    {
        NSString *uid = @"";
        ESStringVal(&uid, dataDic[@"recv"]);
        if ([uid isEqualToString:[LCMyUser mine].userID])
        {
            [LCNoticeAlertView showMsg:dataDic[@"msg"]];
            
            [[LCMyUser mine] reset];
            
            [LCCore presentLandController];
        }
        
        
    }
//    else if([type isEqualToString:@"emailauth"])
//    {
//        NSString *uid = @"";
//        ESStringVal(&uid, dataDic[@"recv"]);
//        if ([uid isEqualToString:[LCMyUser mine].userID])
//        {
//            [LCSet mineSet].email_auth=YES;
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_EmailAuthSuccess
//                                                                object:nil
//                                                              userInfo:nil];
//        }
//    } else if ([type isEqualToString:@"updateprofile"]) {
//        // 更新profile
//        [self updateMyProfile];
//    }
}

//- (void)tabBarController:(UITabBarController *)tabBarController
// didSelectViewController:(UIViewController *)viewController
//{

//    if(tabBarController.selectedIndex==0)
//    {
//        [(UINavigationController *)viewController popToRootViewControllerAnimated:NO];
//        NSLog(@"tabBarController");
//        
//    }
//    else if(tabBarController.selectedIndex == 3)
//    {
//        //        [self.tabBarController setBadgeVisit:NO];
//    }
//}

+ (AppDelegate *)appDelegate
{
    return [AppDelegate sharedAppDelegate];
}

+(UIWindow *)keyWindow
{
    return [self appDelegate].window;
}

+ (UIViewController *)appRootViewController
{
    return [self keyWindow].rootViewController;
}

+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancelButton
{
    [UIAlertView showWithTitle:title message:message cancelButtonTitle:cancelButton];
}

#pragma mark - 域名扩展
+ (void) getDomainExtend
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:@"http://139.199.184.20/?sys=ios&pf=qianjiao"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"拉流失败 error %@", error);
            
        } else {
            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
            if (responseCode == 200) {
                NSString* string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                NSDictionary *infoDict = [LCCore dictionaryWithJsonString:string];
                NSLog(@"getDomainExtend %@",infoDict);
                if (infoDict) {
                    NSString *phoneHeadURL = infoDict[@"phone"];
                    NSString *imgHeadURL = infoDict[@"img"];
                    NSString *upimgURL = infoDict[@"upimg"];
                    NSString *webURL = infoDict[@"web"];
                    
                    if (phoneHeadURL && phoneHeadURL.length > 0) {
                        [[NSUserDefaults standardUserDefaults] setObject:phoneHeadURL forKey:kAPP_HEAD_URL];
                    }
                    
                    if (imgHeadURL && imgHeadURL.length > 0) {
                        [[NSUserDefaults standardUserDefaults] setObject:imgHeadURL forKey:kAPP_IMG_URL];
                    }
                    
                    if (upimgURL && upimgURL.length > 0) {
                        [[NSUserDefaults standardUserDefaults] setObject:upimgURL forKey:kAPP_UPFACE_URL];
                    }
                    
                    
                    if (webURL && webURL.length > 0) {
                        [[NSUserDefaults standardUserDefaults] setObject:webURL forKey:kAPP_WEB_URL];
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

// URL请求域名头
+ (NSString *) requestUrlHead
{
    
    NSString *urlHead = [[NSUserDefaults standardUserDefaults] objectForKey:kAPP_HEAD_URL];
    
    if (urlHead && urlHead.length > 0) {
        return [urlHead stringByAppendingString:@"/"];
    } else {
#ifdef DEBUG
        return @"http://phone.hainandaocheng.com/";
#else
        return @"http://phone.hainandaocheng.com/";
#endif
    }
}

// 图片域名头
+ (NSString *) imgUrlHead
{
    NSString *urlImg = [[NSUserDefaults standardUserDefaults] objectForKey:kAPP_IMG_URL];
    if (urlImg && urlImg.length > 0) {
        return [urlImg stringByAppendingString:@"/"];
    } else {
        return @"http://qianjiao-1253248688.image.myqcloud.com";
    }
}

// 上传图片域名头
+ (NSString *) uploadFaceUrlHead
{
    NSString *faceImgUrl = [[NSUserDefaults standardUserDefaults] objectForKey:kAPP_UPFACE_URL];
    if (faceImgUrl && faceImgUrl.length > 0) {
        return faceImgUrl;
    } else {
        return @"http://upimg.hainandaocheng.com/upload.php";
    }
}
+ (NSString *) uploadedVideoUrlHead
{
    return @"http://dianbo.hainantaohua.com/";
}
// web网址域名头
+ (NSString *) webUrlHead
{
    NSString *webUrl = [[NSUserDefaults standardUserDefaults] objectForKey:kAPP_WEB_URL];
    if (webUrl && webUrl.length > 0) {
        return [webUrl stringByAppendingString:@"/"];
    } else {
        return @"http://web.hainandaocheng.com";
    }
}



#pragma mark - 分享成功
+ (void) shareSucc:(NSString *)sharePlatType
{
    if ([LCMyUser mine].liveType == LIVE_NONE) {
        return;
    }
    
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic)
    {
        if ([responseDic[@"stat"] intValue] == 200) {
            NSLog(@"share succ respones dict:%@",responseDic);
            int diamond = [responseDic[@"diamond"] intValue];
            if (diamond > 0) {
                [LCMyUser mine].diamond = diamond;
            }
            
            if (![LCMyUser mine].playBackUserId) {
                int recDiamond = [responseDic[@"recv_diamond"] intValue];
                if (recDiamond > 0) {
                    [LCMyUser mine].liveRecDiamond = recDiamond;
                }
            }
            
            NSString *msg = ESStringValue(responseDic[@"msg"]);
            if (msg) {
                ESDispatchOnMainThreadAsynchrony(^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:kUserShareSuccMsg object:msg];
                });
            }
        } else {
            NSLog(@"share fail info:%@",responseDic[@"msg"]);
        }
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        NSLog(@"share fail =%@",error);
        
    };
    if (sharePlatType) {
        NSString *uid;
        if ([LCMyUser mine].playBackUserId) {
            uid = [LCMyUser mine].playBackUserId;
        } else if ([LCMyUser mine].liveUserId) {
            uid = [LCMyUser mine].liveUserId;
        }
        
        if (uid) {
            [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"share_from":sharePlatType,@"liveuid":uid,@"vdoid":[LCMyUser mine].playVdoid?[LCMyUser mine].playVdoid:@""}
                                                          withPath:@"share/success"
                                                       withRESTful:GET_REQUEST
                                                  withSuccessBlock:successBlock
                                                     withFailBlock:failBlock];
        }
    }
}

#pragma mark 手机号码验证
/*
 电话号码
 移动  134［0-8］ 135 136 137 138 139 150 151 152 158 159 182 183 184 157 187 188 147 178
 联通  130 131 132 155 156 145 185 186 176
 电信  133 153 180 181 189 177
 
 上网卡专属号段
 移动 147
 联通 145
 
 虚拟运营商专属号段
 移动 1705
 联通 1709
 电信 170 1700
 
 卫星通信 1349
 */

-(BOOL) isValidateMobile:(NSString *)mobile
{
    NSString * phoneRegex = @"^1(3[0-9]|4[57]|5[0-35-9]|(7[0[059]|6｜7｜8])|8[0-9])\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

#pragma mark 抖动
- (void)shakeView:(UIView*)viewToShake
{
    CGFloat t =4.0;
    CGAffineTransform translateRight  =CGAffineTransformTranslate(CGAffineTransformIdentity, t,0.0);
    CGAffineTransform translateLeft =CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
    viewToShake.transform = translateLeft;
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        viewToShake.transform = translateRight;
    } completion:^(BOOL finished){
        if(finished){
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform =CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}


#pragma mark 显示提示信息
+ (void)showProgressHUD:(NSString *)text animated:(BOOL)animated
{
    if ([self globalCore].progressHUD) {
        return;
    }
    [self globalCore].progressHUD = [MBProgressHUD showHUDAddedTo:[LCCore keyWindow] animated:animated];
    [self globalCore].progressHUD.labelText = text;
    [self globalCore].progressHUD.removeFromSuperViewOnHide = YES;
}

+ (void)hideProgressHUD:(BOOL)animated
{
    if ([self globalCore].progressHUD) {
        [[self globalCore].progressHUD hide:animated];
        [[self globalCore].progressHUD removeFromSuperview];
        [self globalCore].progressHUD = nil;
    }
}

//- (BOOL)isNotifyNewMessage
//{
//        return ([UIApplication sharedApplication].enabledRemoteNotificationTypes != UIRemoteNotificationTypeNone);
//}


/*
 
 + (IIViewDeckController *)appRootIIViewController
 {
 return [[self appDelegate] rootIIViewDeckController];
 }
 
 */

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - KPCore Private Methods

- (void)_registerNotification:(NSString *)name selector:(SEL)selector
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:name object:nil];
}
- (void)_unregisterNotification:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
}



- (void)reachabilityChangedNotification:(NSNotification *)notification
{
//    if ([UIDevice currentNetworkStatus] != NotReachable) {
//        //[self retryMainRequestTimerTask];
//    }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Getter & Setter

- (void)_resetShouldShowPayment
{
    if ([kClientChannel_AppStore isEqualToString:kf_config_clientChannel]) {
        BOOL should = NO;
        ESBoolVal(&should, [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKey_shouldShowPayment]);
        _shouldShowPayment = should;
    } else {
        _shouldShowPayment = YES;
    }
}

- (void)setShouldShowPayment:(BOOL)should
{
    if ([kClientChannel_AppStore isEqualToString:kf_config_clientChannel]) {
        _shouldShowPayment = should;
        [NSUserDefaults setObject:@(should) forKey:kUserDefaultsKey_shouldShowPayment];
        //                ESDispatchOnGlobalQueue(DISPATCH_QUEUE_PRIORITY_DEFAULT, ^{
        //                        [[NSUserDefaults standardUserDefaults] setObject:@(should) forKey:kUserDefaultsKey_shouldShowPayment];
        //                        [[NSUserDefaults standardUserDefaults] synchronize];
        //                });
    }
}

- (void)setIsAppStoreReviewing:(BOOL)isAppStoreReviewing
{
    if ([kf_config_clientChannel isEqualToString:kClientChannel_AppStore]) {
        if (isAppStoreReviewing != _isAppStoreReviewing) {
            _isAppStoreReviewing = isAppStoreReviewing;
            [NSUserDefaults setObject:@(_isAppStoreReviewing) forKey:@"is_app_store_reviewing"];
        }
    }
}

- (BOOL)isAppStoreReviewing
{
    if ([kf_config_clientChannel isEqualToString:kClientChannel_AppStore]) {
        return _isAppStoreReviewing;
    }
    return NO;
}

- (LCPurchaseSource)purchaseSource
{
#if DEBUG && 0
    //return 0xFF;
    return LCPurchaseSourceApple;
    return LCPurchaseSourceAlipay;
#else
    LCPurchaseSource source;
    if ([UIDevice isJailbroken] ||
        ![kf_config_clientChannel isEqualToString:kClientChannel_AppStore]) {
        source = LCPurchaseSourceAlipay;
    } else {
        source = LCPurchaseSourceApple;
        if (!self.isAppStoreReviewing)
        {
            source |= LCPurchaseSourceAlipay;
        }
    }
    return source;
#endif
}

- (void)showEULA
{
    return;
    
    if (![kf_config_clientChannel isEqualToString:kClientChannel_AppStore]) {
        return;
    }
    
    if ([NSUserDefaults objectForKey:@"has_shown_eula"]) {
        return;
    }
    
    NSString *eulaString = @"您必须同意接受以下服务条款才能使用本应用。\n"
    @"本应用是一款社交软件，请文明用语，禁止发布有关色情、暴力、歧视诽谤他人等内容，以及让他人感觉不适的内容。\n"
    @"我们有健全的7x24举报处理机制，对不文明使用本应用的用户零容忍。";
    
    UIAlertView *alert = [UIAlertView alertViewWithTitle:@"最终用户许可协议(EULA)"
                                                 message:eulaString
                                       cancelButtonTitle:@"同意"
                                         didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex)
                          {
                              if (buttonIndex == alertView.cancelButtonIndex) {
                                  [NSUserDefaults setObject:@(YES) forKey:@"has_shown_eula"];
                              } else {
                                  exit(0);
                              }
                          } otherButtonTitles:@"不同意", nil];
    [alert show];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * 请求完main后，获取token。比较服务端返回的token，如果不一样就发送给服务端
 */
- (void)sendPushToken:(NSString *)tokenFromServer
{
    if (tokenFromServer && ESIsStringWithAnyText(tokenFromServer)) {
        _pushTokenFromServer = tokenFromServer;
    }
    
    
#if !TARGET_IPHONE_SIMULATOR
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
#endif
}

- (void)applicationDidRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [deviceToken description];
    
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"============ deviceToken: ==============\n%@", token);
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES]
                                              forKey:@"PushNotificationSet"];
    
    if ([_pushTokenFromServer isKindOfClass:[NSString class]] &&
        [token isEqualToString:_pushTokenFromServer]) {
        return;
    }
    
    [LCStart sendPushTokenToSever:token];
}

- (void)applicationDidFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"getting push token failed: %@", error);
}

- (void)applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (![userInfo isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSLog(@"========== state %d \n%@", (int)[UIApplication sharedApplication].applicationState, userInfo);
    
    [[self class] setPushRemoteNotification:userInfo];
    
    if (UIApplicationStateActive != [UIApplication sharedApplication].applicationState) {
        [self processPushRemoteNotification];
    }
}

static NSDictionary *_shared_pushRemoteNotification = nil;
+ (NSDictionary *)pushRemoteNotification
{
    return _shared_pushRemoteNotification;
}

+ (void)setPushRemoteNotification:(NSDictionary *)push
{
    NSLog(@"=*=*=*=*==== setPushRemoteNotification  ==*=*=*=*=== \n%@", push);
    _shared_pushRemoteNotification = push;
}

+ (void)clearApplicationIconBadgeNumber
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)processPushRemoteNotification
{
    //        return ; //这个版本不处理push跳转，后续再考虑要跳转到哪。
    //
    //        __autoreleasing NSString* openURLString = nil;
    //        if (ESStringVal(&openURLString, [_shared_pushRemoteNotification objectForKey:@"open_url"])) {
    //                [ESApplication openURLWithString:openURLString];
    //        } else {
    //
    //        }
    
    //        if (UIApplicationStateActive != [UIApplication sharedApplication].applicationState) {
    
    
    //            if (![_shared_pushRemoteNotification isKindOfClass:[NSDictionary class]] ||
    //                ![_shared_pushRemoteNotification[@"aps"] isKindOfClass:[NSDictionary class]] ||
    //                ![_shared_pushRemoteNotification[@"aps"][@"other"] isKindOfClass:[NSDictionary class]]) {
    //                return;
    //            }
    //            NSDictionary *info = _shared_pushRemoteNotification[@"aps"][@"other"];
    //            NSString *type = nil;
    //            if (!ESStringVal(&type, info[@"type"])) {
    //                return;
    //            }
    
    /*
     if ([@"adv" isEqualToString:type]) {
     NSString *url = nil;
     if (ESStringVal(&url, info[@"url"])) {
     [LCCore presentADVControllerWithADVDic:@{@"title" : (info[@"title"] ?: @""),
     @"url": url}];
     }
     } else if ([@"live" isEqualToString:type]) {
     NSString *uid = nil;
     if (ESStringVal(&uid, info[@"uid"])) {
     [LCCore presentLiveRoomViewControllerWithRoomID:uid];
     }
     }
     */
    [[self class] setPushRemoteNotification:nil];
    
    //        }
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)applicationDidReceiveMemoryWarning:(NSNotification *)notification
{
    
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
    KFLog(@"====== application Will Resign Active ======");
    
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    KFLog(@"====== application Did Become Active ======");
    //    LiveShowRoomViewController *room = [LiveShowRootViewController getCurrentRoom];
    //    if(room)
    //    {
    //        room.actionImage.hidden = YES;
    //    }
    
    
//    [UMSocialSnsService  applicationDidBecomeActive];
    
#if 0
    /* 实现快速响应，否则在内存紧张的情况下会导致从后台切换回来要显示很长时间的启动画面。*/
    ESDispatchOnGlobalQueue(DISPATCH_QUEUE_PRIORITY_DEFAULT, ^{
        ESDispatchAsyncOnMainThread(^{
            static BOOL _isFristActivie = YES;
            if (_isFristActivie) {
                _isFristActivie = NO;
                return;
            }
            
            
            NSInteger badgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber];
            /*  注意如果要在使用判断 badgeNumber 不为0时同步数据等操作，
             就不要在 -applicationDidReceiveRemoteNotification 中将appBadgeNumber置空 */
            if (badgeNumber > 0) {
                // sync data, etc.
            }
        });
    });
#endif
}


- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    KFLog(@"====== application Did Enter Background ======");
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Sync

- (void)requestSync
{
    static BOOL __isRequestingSync = NO;
    if (!self.shouldRequestSync) {
        return;
    }
    if (__isRequestingSync) {
        return;
    }
    __isRequestingSync = YES;
    
    
    ESWeakSelf;
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        __isRequestingSync = NO;
        
        NSLog(@"index sync:%@",responseDic);
        
        ESStrongSelf;
        _self.shouldRequestSync = NO;
        
        if (responseDic[@"filter_version"] && responseDic[@"filterurl"]) {
            int version = ESIntValue(responseDic[@"filter_version"]);
            NSNumber *localVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kDirtyWordVersion];
            if (!localVersion || localVersion.intValue < version) {
                [[ChatUtil shareInstance] downLoadDirtyFile:responseDic[@"filterurl"]];
            }
        }
        
        
        int stat = 0;
        if (ESIntVal(&stat, responseDic[@"stat"]) && URL_REQUEST_SUCCESS == stat)
        {
            // 获取私信标识
            if (responseDic[@"userinfo"][@"private_chat_status"])
            {
                int tag = [responseDic[@"userinfo"][@"private_chat_status"] intValue];
                [LCMyUser mine].priChatTag = [NSString stringWithFormat:@"%d", tag];
                NSLog(@"JoyYou-YMLive :: private chat status = %@", [LCMyUser mine].priChatTag);
            }
            
            [LCStart firstLoadView:responseDic];
            return;
        }
        
        [[LCMyUser mine] reset];
        [LCCore presentLandController];
        
        if ( ESIsStringWithAnyText(responseDic[@"msg"]))
        {
            [UIAlertView showWithTitle:responseDic[@"msg"] message:nil];
        }
    };
    
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        NSLog(@"start app fail =%@",error);
        __isRequestingSync = NO;
        [[LCMyUser mine] reset];
        [LCCore presentLandController];
    };
    
    NSLog(@"parameter index/sync:%@",[LCCore analyticsInformation]);
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:[LCCore analyticsInformation]
                                                  withPath:URL_LIVE_START
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}

// 获取关注用户集合
- (void)requestAttentUserArray
{
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        NSLog(@"requestAttentUserArray %@",responseDic);
        if (URL_REQUEST_SUCCESS == [responseDic[@"stat"] intValue]) {
            
            NSMutableString * mutableString = [NSMutableString stringWithFormat:@"10000,%@", responseDic[@"uids"]];
            
            [[LCMyUser mine] saveAllAttentUsers:mutableString];
           
        }
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        NSLog(@"start app fail =%@",error);
        
    };
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:nil
                                                  withPath:URL_ATTENT_ARRAY_SYNC_LIST
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}

- (void)updateMyProfile
{
//    [LCJSONClient get:@"profile" parameters:nil success:^(NSDictionary *dict) {
//        int stat = 0;
//        if (ESIntVal(&stat, dict[@"stat"]) && 200 == stat) {
//            [[LCMyUser mine] fillWithDictionary:dict[@"userinfo"]];
//            [[LCMyUser mine] save];
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_EditInfo_Success object:nil];
//        }
//    } failure:nil];
}


- (BOOL)isPushNotificationEnabled
{
    BOOL enabled = NO;
    UIApplication *app = [UIApplication sharedApplication];
    if ([app respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
        enabled = app.isRegisteredForRemoteNotifications;
    } else {
        enabled = app.enabledRemoteNotificationTypes != UIRemoteNotificationTypeNone;
    }
    return enabled;
}

- (void)showOpenNotificationPrompt
{
    if (![LCCore globalCore].isPushNotificationEnabled) {
        UIAlertView *alert = [UIAlertView alertViewWithTitle:@"\"有美直播\"想给您发送推送通知" message:@"\"通知\"可能包括提醒、声音和图标标记。这些可在\"设置\"中配置。" cancelButtonTitle:@"不允许" didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex)
                              {
                                  if(buttonIndex != alertView.cancelButtonIndex)
                                  {
                                      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                  }
                              } otherButtonTitles:@"设置", nil];
        [alert show];
    }
}

- (void)logoutLC
{
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - HTTP Request

+ (NSString *)userAgentForURLParameter
{
    return nil;
    //        NSString *ua = [NSString stringWithFormat:@"i|%d|%@|%@|%@|%d",
    //                        (int)kp_config_clientVersion,
    //                        kp_config_clientPublishID,
    //                        [self clientChannel],
    //                        [NSString stringWithFormat:@"os_%@", [ESDevice systemVersion]],
    //                        (int)[ESDevice deviceScreenType]];
    //        return [ua stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

// User Agent For WebView & HTTPRequest
+ (NSString *)userAgent
{
 
    return [ESApp sharedApp].userAgentForWebView;
    
    
    //        NSString *defaultUA = [NSString stringWithFormat:@"Mozilla/5.0 (iPhone; CPU iPhone OS %@ like Mac OS X)",
    //                               [[ESDevice systemVersion] stringByReplacingOccurrencesOfString:@"." withString:@"_"] ];
    //        return defaultUA;
    //        return [NSString stringWithFormat:@"%@ OS (iOS/%@/%@) Version (%d/%@/%@) UDID (%@) Retina (%d)",
    //                defaultUA,
    //                kp_config_clientPublishID, [self clientChannel],
    //                kp_config_clientVersion, [ESApplication appVersion], [ESDevice systemVersion],
    //                [ESDevice deviceIdentifier],
    //                (int)[ESDevice isRetinaScreen]];
}

//static JDMessageView *_connectionFailureView = nil;
//static JDMessageView *_requestTimedoutView = nil;

- (void)showNetworkErrorAlert:(NSInteger)errorCode
{
    //        if (ASIConnectionFailureErrorType == errorCode && !_connectionFailureView) {
    //                _connectionFailureView = [[JDMessageView alloc] initWithSuperView:[[self class] keyWindow] title:@"网络连接失败。" message:nil];
    //                _connectionFailureView.delayTime = 3.0;
    //                _connectionFailureView.animationType = JDMessageViewAnimationTypePop;
    //                _connectionFailureView.delegate = self;
    //                [_connectionFailureView show];
    //        } else if (ASIRequestTimedOutErrorType == errorCode && !_requestTimedoutView) {
    //                _requestTimedoutView = [[JDMessageView alloc] initWithSuperView:[[self class] keyWindow] title:@"网络连接超时，请检查您的网络。" message:nil];
    //                _requestTimedoutView.delayTime = 3.0;
    //                _requestTimedoutView.animationType = JDMessageViewAnimationTypePop;
    //                _requestTimedoutView.delegate = self;
    //                [_requestTimedoutView show];
    //        }
}

//- (void)messageViewDidDismiss:(JDMessageView *)msgView
//{
//    if (msgView == _connectionFailureView) {
//        _connectionFailureView = nil;
//    } else if (msgView == _requestTimedoutView) {
//        _requestTimedoutView = nil;
//    }
//}

#pragma mark - 字典转json
+ (NSString*)convertToJSONData:(id)infoDict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString = @"";
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return jsonString;
}

#pragma mark - json 转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

#pragma mark -- youmeng Analytics


@end
