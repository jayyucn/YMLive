//
//  KFCore.h
//  KaiFang
//
//  Created by Elf Sundae on 8/2/13.
//  Copyright (c) 2013 www.0x123.com. All rights reserved.
//

#import "LCDefines.h"
#import "QCShareResource.h"

typedef NS_OPTIONS(NSUInteger, LCPurchaseSource) {
        LCPurchaseSourceNone            = 0,
        LCPurchaseSourceApple           = 1 << 0,
        LCPurchaseSourceAlipay          = 1 << 1,
        //LCPurchaseSourceWXPay           = 1 << 2,
};

typedef enum : NSInteger {
    SHARE_TYPE_ROOM = 0,
    SHARE_FINISH_LIVE,
    SHARE_START_LIVE,
    SHARE_RECORD_VIDEO
} SHARE_TYPE_POS;

// 第三方平台分享成功
#define QQ_ZONE_SHARE_SUCC   @"qzone"
#define QQ_SHARE_SUCC        @"qq"
#define WEIXIN_SHARE_SUCC    @"weixin"
#define WEIXIN_CIRCLE_SHARE_SUCC     @"friend_circle"
#define SINA_SHARE_SUCC      @"sina"


@interface LCCore : NSObject<UITabBarControllerDelegate>

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

@property (nonatomic, assign) BOOL  fromMask;
@property (nonatomic, strong) NSString *shareType;


#pragma mark - Helper
+ (LCCore *)globalCore;
+ (AppDelegate *)appDelegate;
+ (UIWindow *)keyWindow;
//+ (IIViewDeckController *)appRootIIViewController;
+ (UIViewController *)appRootViewController;
+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancelButton;


#pragma mark - 域名扩展
+ (void) getDomainExtend;

// URL请求域名头
+ (NSString *) requestUrlHead;

// 图片域名头
+ (NSString *) imgUrlHead;

// 上传图片域名头
+ (NSString *) uploadFaceUrlHead;

+ (NSString *) uploadedVideoUrlHead;

// web网址域名头
+ (NSString *) webUrlHead;


#pragma mark - 字典转json
+ (NSString*)convertToJSONData:(id)infoDict;

#pragma mark - json 转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


#pragma mark - 分享成功
+ (void) shareSucc:(NSString *)sharePlatType;

- (BOOL)isValidateMobile:(NSString *)mobile;

- (void)shakeView:(UIView*)viewToShake;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Global UIApplication

+ (NSDictionary *)pushRemoteNotification;
+ (void)setPushRemoteNotification:(NSDictionary *)push;

- (void)sendPushToken:(NSString *)tokenFromServer;
- (void)processPushRemoteNotification; //处理推送
+ (void)clearApplicationIconBadgeNumber; // 删除App的Icon上的badge number
- (void)applicationDidRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)applicationDidFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
- (void)applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - HTTP Request
- (void)showNetworkErrorAlert:(NSInteger)errorCode;
+ (NSString *)userAgent;
+ (NSString *)userAgentForURLParameter;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - KPCore Private Methods
- (void)_registerNotification:(NSString *)name selector:(SEL)selector;
- (void)_unregisterNotification:(NSString *)name;

/**
 * Sigleton
 */
+ (id)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
- (id)init __attribute__((unavailable("init not available, call sharedInstance instead")));
+ (id)new __attribute__((unavailable("new not available, call sharedInstance instead")));

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Properties
// Configurate
@property (nonatomic, copy) NSString *apiBaseURL;
// Apple审核时暂时关闭元宝消费（Apple拒绝理由是消费要使用IAP)
@property (nonatomic) BOOL shouldShowPayment;
// AppStore正在审核
@property (nonatomic) BOOL isAppStoreReviewing;

// 第三方登录 sync不重置
@property (nonatomic) BOOL isThirdLogin;

// 进入主页
@property (nonatomic) BOOL isEnterHome;

// 1v1邀请对象
@property (nonatomic, strong) ChatUser  *inviteChatUser;
// 1v1限制条件
@property (nonatomic, assign) int       setDiamond;

- (void)showEULA;

//@property (nonatomic,strong)LCTabBarController *tabBarController;

@property (nonatomic)BOOL Registering;
@property (nonatomic)BOOL viewLoaded;
@property (nonatomic,copy)LCUMengUpdateBlock UMengUpdateBlock;

@property (nonatomic, strong) MBProgressHUD *progressHUD;
+ (void)showProgressHUD:(NSString *)text animated:(BOOL)animated;
+ (void)hideProgressHUD:(BOOL)animated;

//- (BOOL)isNotifyNewMessage;
@property (nonatomic) BOOL newMessageNotifyShowsDetail;
@property (nonatomic) BOOL newMessageNotifyPlaySound;
@property (nonatomic) BOOL newMessageNotifyPlayVibrate;

- (LCPurchaseSource)purchaseSource;

@property (nonatomic) BOOL shouldRequestSync;
- (void)requestSync;

- (void)requestAttentUserArray;

- (void)updateMyProfile;

- (BOOL)isPushNotificationEnabled;

- (void)showOpenNotificationPrompt;

- (void)logoutLC;
@end


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - App Info
@interface LCCore (AppInfo)

@end


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Configuration
@interface LCCore (Configuration)

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Configuration
@interface LCCore (PresentViewController)

+(void)presentStartController;
+(void)presentFaceViewController;
+(void)presentMainViewController;
+(void)presentRegisterController;
+(void)presentRegisterDetailController;
+(void)presentVerifyInviteController;
+(void)presentLandController;
+(void)presentRegisterFirstController;
+(void)presentRegisterSecondController;


@end



//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Analytics
@interface LCCore (Analytics)
+(void)setUmengTrack;

+ (NSDictionary *)analyticsInformation;
+ (NSDictionary *)appInformation;

+ (void)checkUMengUpdate:(LCUMengUpdateBlock)UMengUpdateBlock;

-(void)setShareImageURL:(NSString *)imageURL;


@end
