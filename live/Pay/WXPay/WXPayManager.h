//
//  WXPayManager.h
//  qianchuo
//
//  Created by jacklong on 16/5/1.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//
#import <ShareSDK3/WXApi.h>

@interface WXPayManager : NSObject<WXApiDelegate>

ES_SINGLETON_DEC(wxPayManager);

@property (nonatomic)enum WXScene scene;
@property (nonatomic,strong)UIViewController *showWxView;
@property (nonatomic,strong)NSString *out_trade_no;// wx orderid
@property (nonatomic,assign)SHARE_TYPE_POS shareType;

- (BOOL) isWXAppInstall;// 是否安装
- (void) sendLinkContent;//分享连接 
- (void) sendAuthReq;// 微信登录

- (void) sendPay:(NSMutableDictionary *)goods;// 微信支付

+ (NSString *)jumpToBizPay;
@end
