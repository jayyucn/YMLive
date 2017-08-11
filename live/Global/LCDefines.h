//
//  KFDefines.h
//  KaiFang
//
//  Created by Elf Sundae on 13-10-28.
//  Copyright (c) 2013年 www.0x123.com. All rights reserved.
//

#ifndef KaiFang_KFDefines_h
#define KaiFang_KFDefines_h

#import <Foundation/Foundation.h>

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Config

#define CHAT_TEST       0

// @"App Store"  @"AdHoc" @"Enterprise" @"91" @"tongbu" @"pp"
#define kClientChannel_AppStore         @"App Store"
#define kClientChannel_Development      @"dev"
#define kClientChannel_AdHoc            @"AdHoc"
#define kClientChannel_Enterprise       @"Enterprise"
#define kClientChannel_91               @"91"
#define kClientChannel_TongBuTui        @"tongbu"
#define kClientChannel_PP               @"pp"
#define kClientChannel_Haima            @"haima"
#define kClientChannel_Fir              @"fir"
#define kClientChannel_PuGongYing       @"pgy"
#define kf_config_clientChannel         kClientChannel_AppStore
#if !DEBUG
#warning 打包前修改这里的渠道
#endif



#pragma mark - 域名扩展保存
#define kAPP_HEAD_URL                           @"app_head_url"
#define kAPP_IMG_URL                            @"app_img_url"
#define kAPP_UPFACE_URL                         @"app_face_url"
#define kAPP_WEB_URL                            @"app_web_url"




#define kShareTitleAfterMatch @"有美直播：明星范" // 明星范
#define kShareTitlePersonalPhoto @"有美直播：分享照片"
#define kShareTitleMatchCouple @"免费相亲约会,夫妻相匹配" // 夫妻相

#if DEBUG
/* 目前开启这个fix时，console看不到log输出，调试时可以把这里设为0 */
#define __KFVideoFixNoSound__   0
#else
#define __KFVideoFixNoSound__   0
#endif
//#if !__KFVideoFixNoSound__
//#warning __KFVideoFixNoSound__ == 0
//#endif

#define __KFLoginViaWeb__       0
#if !__KFLoginViaWeb__
#define __KFLoginViaShareSDK__  1
#else
#define __KFLoginViaShareSDK__  0
#endif

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Cache Keys

#define kCacheKey_ChatTotalNewsCount    @"chat_total_news_count"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - User Defaults
#define kUserDefaultsKey_ClientVersion          @"kf_client_version"
#define kUserDefaultsKey_Mine                   @"current_user"
#define kUserDefalutKey_Live                    @"live_user_info"
#define kUserDefaultsKey_Set                    @"set_info"
#define kUserDefaultsKey_shouldShowPayment      @"kf_show_payment"

#define kUserDefaultsKey_NewsVoice                   @"NewsVoice"
#define kUserDefaultsKey_NewsVibration                @"NewsVibration"
#define kUserDefaultsKey_NewsDetail                     @"NewsDetail"

#define kUserDefaultsKey_Location                      @"Location"
#define kUserDefaultsKey_TimeLocation                      @"TimeLocation"
#define kUserDefaultsKey_SubmitLocation                      @"SubmitLocationLocation"

#define kUserDefaultsKey_InviteCode                            @"InviteCode"
#define kUserDefaultsKey_ShouldInviteCode                      @"ShouldInviteCode"
#define kUserOnetoOneAgreeKey                                  @"kUserOnetoOneAgreeKey"
#define kUserOTORequestSeqTime                                 @"kUserOTORequestSeqTime"// 1V1间隔时间

#define kUserShareSuccMsg                         @"share_succ_msg"
#define kUserStartPageInfo                        @"user_start_page"
#define kUserLaunchOptions                        @"kUserLaunchOptions"
#define kUserCancelInviteUpMike                   @"kUserCancelInviteUpMike"

#define kUserOVO_MSG                              @"kUserOVO_MSG"
#define KUserOVO_GIFT                             @"KUserOVO_GIFT"
#define kUserOVO_Prompt_KEY                       @"kUserOVO_Prompt"

#define kDirtyWordServerUrl                     @"dirtywordserver_url"
#define kDirtyWordVersion                       @"dirtyword_version"

#define HuoWuLive_PAUSE_NOTIFION                     @"HuoWuLive_pause_notifition"// 暂停观看直播
#define AUCALLBACKPLAY_PAUSE_NOTIFITION           @"AUCALLBACKPLAY_PAUSE_NOTIFITION"// 暂停回放

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Constans

#define IOS_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])
#define IOS_VERSION_IS_ABOVE_7 (IOS_VERSION >= 7.f)

#define kKFLiveRoomContentViewTopMarginOnIOS7 (0.f)

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define AddHeightForView  ScreenHeight > 480 ? (568.0-480.0):0.0f

//状态栏、导航栏、标签栏高度
#define STATUS_HEIGHT ([UIApplication sharedApplication].statusBarFrame.size.height)
#define NAVIGATIONBAR_HEIGHT (self.navigationController.navigationBar.frame.size.height)
#define TABBAR_HEIGHT (self.tabBarController.tabBar.frame.size.height)

#define StatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height


#define ESButtonColorBlue ([UIColor colorWithRed:46.f/255 green:134.0/255 blue:255.0/255 alpha:1.0f])
#define ESButtonColorCoffee ([UIColor colorWithRed:164.f/255 green:120.0/255 blue:67.0/255 alpha:1.0f])

#define ColorPink ([UIColor colorWithRed:177.0/255 green:250.0/255 blue:255.0/255 alpha:1.0])
#define ColorBackGround (UIColorWithRGBA(242.f, 242.f, 242.f, 1.f))
#define ColorDark (UIColorWithRGB(85, 85, 85))


//字体颜色
#define COLOR_FONT_RED   0xD54A45
#define COLOR_FONT_WHITE 0xFFFFFF
#define COLOR_FONT_LIGHTWHITE 0xEEEEEE
#define COLOR_FONT_DARKGRAY  0x555555
#define COLOR_FONT_GRAY  0x777777
#define COLOR_FONT_LIGHTGRAY  0x999999
#define COLOR_FONT_BLACK 0x000000

//背景颜色
#define COLOR_BG_GRAY      0xEDEDED
#define COLOR_BG_ALPHABLACK     0x88000000
#define COLOR_BG_ORANGE 0xf69e21
#define COLOR_BG_ALPHARED  0x88D54A45
#define COLOR_BG_LIGHTGRAY 0xEEEEEE
#define COLOR_BG_ALPHAWHITE 0x55FFFFFF
#define COLOR_BG_WHITE     0xFFFFFF
#define COLOR_BG_DARKGRAY     0xAFAEAE
#define COLOR_BG_RED       0xD54A45
#define COLOR_BG_BLUE      0x4586DA
#define COLOR_BG_CLEAR     0x00000000

//rbg转UIColor(16进制)
#define RGB16(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define RGBA16(rgbaValue) [UIColor colorWithRed:((float)((rgbaValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbaValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbaValue & 0xFF))/255.0 alpha:((float)((rgbaValue & 0xFF000000) >> 24))/255.0]

/** UMeng */
#if DEBUG
#define kUMeng_ReportPolicy_SendOnExit  0  // DEBUG时实时发送
#else
#define kUMeng_ReportPolicy_SendOnExit  SEND_ON_EXIT // 7  //退出或进入后台时发送
#endif

/**
 * Just used to fix OHAttributedLabel warning
 */
#define COCOAPODS 1
#define OHATTRIBUTEDLABEL_DEDICATED_PROJECT 1


typedef void (^LCRequestSuccessResponseBlock)(NSDictionary *responseDic);
typedef void (^LCRequestFailResponseBlock)(NSError *error);


typedef void (^LCUMengUpdateBlock)(BOOL NewVersion);


//#define LCAppURL @"http://itunes.apple.com/us/app/id695118198"


#define UMENG_APPKEY @"53b4410556240bcc8306ba1f"
#define BAIDU_APPKEY @"uuhvsfAF45fe4Ge4T1GkGx9m313oSvTV"

#define Date_Badge_Num_key @"dateNumber"
#define Date_Notification_Data @"dateApplyData"

#define PreAccount @"PreAccount"

//tao
#define RefreshMask   @"refreshMask"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Defines

typedef struct {
        int left;
        int right;
} LCRange;

extern LCRange LCRangeMake(int left, int right);
extern LCRange const LCRangeZero;
extern BOOL LCRangeIsZero(LCRange range);

extern NSString *LCRangeToString(LCRange range);
extern LCRange LCRangeFromString(NSString *string);

//typedef NS_ENUM(NSInteger, LCMarriageState) {
//        LCMarriageStateSingle = 0, //单身
//        LCMarriageStateMarried = 1, //已婚
//        LCMarriageStateAberration = 2, //离异
//        LCMarriageStateMateDied = 3, // 丧偶
//};


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Functions
/// Sample log
void KFLog(NSString *format, ...);
#define KFLogLive(format, ...)  //KFLog((@"<LiveRoom> " format), ##__VA_ARGS__)
#define KFLogVideo(format, ...)  KFLog((@"<Video> " format), ##__VA_ARGS__)

#endif


#define RGBAColor(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
