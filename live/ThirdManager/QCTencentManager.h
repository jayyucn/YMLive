//
//  QCTencentManager.h
//  qianchuo
//
//  Created by jacklong on 16/5/4.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>


@interface QCTencentManager : NSObject<QQApiInterfaceDelegate>
{
    TencentOAuth* tencentOAuth;
    NSArray* permissions;
    
    QQApiObject *_qqApiObject;
}
@property (nonatomic,strong)TencentOAuth* tencentOAuth;
@property (nonatomic,strong)NSArray *permissions;
@property (nonatomic,assign)SHARE_TYPE_POS shareType;
@property (nonatomic,assign)BOOL isShareInZone;

ES_SINGLETON_DEC(tencentManager);

- (BOOL)isQQInstall;

- (void)tencentOAuthWithoutSafari;//登录不用safari

-(void)shareWithFriend;//分享朋友

-(void)shareInQzone;//分享空间

@end
