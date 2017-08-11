///
//  KFCore+Analytics.m
//  KaiFang
//
//  Created by Elf Sundae on 13-12-3.
//  Copyright (c) 2013年 www.0x123.com. All rights reserved.
//

#import "LCCore.h"
#import <AdSupport/AdSupport.h>

//#import "UMSocial.h"
//#import "UMSocialWechatHandler.h"
//#import "UMSocialQQHandler.h"

@implementation LCCore (Analytics)

+ (NSDictionary *)analyticsInformation
{
        NSDictionary *dict = @{
                               @"system_name" : [UIDevice systemName],
                               @"system_version" : [UIDevice systemVersion],
                               @"device_model" : [UIDevice platform],
                               @"platform" : [UIDevice platform],
                               @"carrier" : [UIDevice carrierString],
                               @"udid" : [UIDevice openUDID], 
                               @"app_version" :[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
                               @"app_channel" : kf_config_clientChannel,
                               @"app_bundleID":[ESApp appBundleIdentifier],
                               @"lang" : [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode],
                               @"jailbroken":[NSNumber numberWithInt:([UIDevice isJailbroken] ? 1 : 0)], 
                               @"idfa":[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString],
                               @"ry":@"1",
                               };
        return dict;
}


+ (NSDictionary *)appInformation
{
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:[self analyticsInformation]];
    [info addEntriesFromDictionary:@{
                                     @"is_jailbroken" : [NSNumber numberWithInt:([UIDevice isJailbroken] ? 1 : 0)],
                                     @"network" : [UIDevice currentNetworkReachabilityStatusString],
                                     }];
    return (NSDictionary *)info;
}



//添加友盟
+(void)setUmengTrack {
    
//    [MobClick setCrashReportEnabled:YES]; // 如果不需要捕捉异常，注释掉此行
//#if DEBUG
//    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
//#endif
//    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
//    //
//    [MobClick startWithAppkey:UMENG_APPKEY
//                 reportPolicy:kUMeng_ReportPolicy_SendOnExit
//                    channelId:kf_config_clientChannel];
//    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
//    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
//    
//    //      [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
//    
//    
//    
//    [MobClick updateOnlineConfig];  //在线参数配置
//    
//    [LCCore checkUMengUpdate:nil];
//    
//    /*
//     //    1.6.8之前的初始化方法
//     //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
//     */
//    
////    //share
////    [UMSocialData setAppKey:UMENG_APPKEY];
////        //设置微信AppId，设置分享url，默认使用友盟的网址
////        [UMSocialWechatHandler setWXAppId:@"wx66dbf485286b9342" appSecret:@"0ec07e1e211cd11ed83aa87e55f7b4ba" url:@"http://www.yuanphone.com/down"];
////    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
////    [UMSocialQQHandler setQQWithAppId:APP_ID_QQ appKey:@"cfe903ba832b6992303bcd9f9c475d86" url:@"http://sns.whalecloud.com/app/E4NF3K"];
//    //打开新浪微博的SSO开关
//    //[UMSocialConfig setSupportSinaSSO:YES appRedirectUrl:nil];
}

+(void)checkUMengUpdate:(LCUMengUpdateBlock)UMengUpdateBlock
{
    [LCCore globalCore].UMengUpdateBlock=UMengUpdateBlock;
//    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
}


-(void)setShareImageURL:(NSString *)imageURL
{
//    NSString *weixinURL=[NSString stringWithFormat:@"%@share?uid=%@",getBaseURL(),imageURL];
//    //设置微信AppId，url地址传nil，将默认使用友盟的网址，需要#import "UMSocialWechatHandler.h"
//    
//        [UMSocialWechatHandler setWXAppId:@"wx66dbf485286b9342" appSecret:@"0ec07e1e211cd11ed83aa87e55f7b4ba" url:weixinURL];
//    
//    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
//    NSString *QQURL=[NSString stringWithFormat:@"%@share?uid=%@",getBaseURL(),imageURL];
//    [UMSocialQQHandler setQQWithAppId:APP_ID_QQ appKey:@"cfe903ba832b6992303bcd9f9c475d86" url:QQURL];
//
    //[UMSocialQQHandler setQQWithAppId:@"100624236" appKey:@"cfe903ba832b6992303bcd9f9c475d86" url:@"http://sns.whalecloud.com/app/E4NF3K"];
}
 


+(void)updateMethod:(NSDictionary *)appInfo
{
    
      NSLog(@"update info %@",appInfo);
//    if([[appInfo objectForKey:@"update"] isEqualToString:@"YES"]==YES)
//    {
//        NSString *newVersion = [[NSString alloc]initWithString:[appInfo objectForKey:@"version"]];
//            ESWeakSelf;
//            UIAlertView *alert = [UIAlertView alertViewWithTitle:[NSString stringWithFormat:@"有新版本V%@",newVersion]
//                                                         message:[NSString stringWithString:[appInfo objectForKey:@"update_log"]]
//                                               cancelButtonTitle:@"下次再说"
//                                                 didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
//                                                         ESStrongSelf;
//                                                         if (buttonIndex != alertView.cancelButtonIndex) {
//                                                                 NSString *newVersionPath = [[NSString alloc]initWithString:[appInfo objectForKey:@"path"]];
//                                                                 NSURL *url = [NSURL URLWithString:newVersionPath];
//                                                                 [[UIApplication sharedApplication]openURL:url];
//                                                         }
//                                                 } otherButtonTitles:@"更新", nil];
//            [alert show];
//        
//        [[NSUserDefaults standardUserDefaults] setObject:appInfo forKey:@"updateVersion"];
//        
//        if([LCCore globalCore].UMengUpdateBlock)
//            [LCCore globalCore].UMengUpdateBlock(YES);
//        [UIAlertView alertViewWithTitle:[NSString stringWithFormat:@"有新版本V%@",newVersion]
//                                message:[NSString stringWithString:[appInfo objectForKey:@"update_log"]]
//                      cancelButtonTitle:@"下次再说"
//                     customizationBlock:nil
//                           dismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
//                               NSString *newVersionPath = [[NSString alloc]initWithString:[appInfo objectForKey:@"path"]];
//                               NSURL *url = [NSURL URLWithString:newVersionPath];
//                               [[UIApplication sharedApplication]openURL:url];
//                           }
//                            cancelBlock:^{
//                                
//                            }
//                      otherButtonTitles:@"更新", nil];
//    }else{
//        if([LCCore globalCore].UMengUpdateBlock)
//            [LCCore globalCore].UMengUpdateBlock(NO);
//    }
//    
//    [[NSUserDefaults standardUserDefaults] setObject:appInfo forKey:@"updateVersion"];
    
    
    
}

@end
