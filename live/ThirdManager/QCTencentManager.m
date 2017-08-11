//
//  QCTencentManager.m
//  qianchuo
//
//  Created by jacklong on 16/5/4.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "QCTencentManager.h"
#import "QCShareResource.h"
#import "WXUtil.h"

@interface QCTencentManager(){
    BOOL isRequestContent;
}
@end

@implementation QCTencentManager

ES_SINGLETON_IMP(tencentManager);

@synthesize tencentOAuth;
@synthesize permissions;

-(id)init
{
    if(self=[super init])
    {
        self.permissions = [NSArray arrayWithObjects:@"all", nil];
        
        
        self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:kQQAppID
                                                    andDelegate:self];
    }
    return self;
}



- (BOOL)isQQInstall
{
    if ([QQApiInterface isQQInstalled]) {
        //判断是否有qq
        return true;
    }
    return false;
}

/**
 * tencentOAuth
 */

- (void)tencentOAuthWithoutSafari
{
    [tencentOAuth authorize:permissions inSafari:NO];
}


/**
 * Get user info.
 */

- (void)getUserInfo
{
    if(![tencentOAuth getUserInfo]){
        [self showInvalidTokenOrOpenIDMessage];
    }
    
}

- (void)showInvalidTokenOrOpenIDMessage{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"api调用失败" message:@"可能授权已过期，请重新获取" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark share in qzone
-(void)shareInQzone//分享空间
{
    [self requestShareContent:YES];
}

- (void)addShareResponse:(APIResponse*) response
{
    
    if (URLREQUEST_SUCCEED == response.retCode && kOpenSDKErrorSuccess == response.detailRetCode)
    {
//        NSMutableString *str=[NSMutableString stringWithFormat:@""];
//        for (id key in response.jsonResponse)
//        {
//            [str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
//        }
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:[NSString stringWithFormat:@"%@",str]
//                              
//                                                       delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
//        [alert show];
        
    }
    else
    {
        NSString *errMsg = [NSString stringWithFormat:@"errorMsg:%@\n%@", response.errorMsg, [response.jsonResponse objectForKey:@"msg"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:errMsg delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
        [alert show];
    }
    
}



#pragma  mark share with friend


-(void)shareWithFriend//分享朋友
{
    [self requestShareContent:NO];
}

/*
 -(void)shareInQzone
 {
 QQApiTextObject *txtObj = [QQApiTextObject objectWithText:@"testtestytwddfvsdfsd"];
 
 SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
 
 
 //分享到QZone
 QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
 
 [self handleSendResult:sent];
 
 }
 */

/*
 #pragma mark UIAlertViewDelegate
 - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
 {
 SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:_qqApiObject];
 QQApiSendResultCode sent = 0;
 if (0 == buttonIndex)
 {
 //分享到QZone
 sent = [QQApiInterface SendReqToQZone:req];
 }
 else
 {
 //分享到QQ
 sent = [QQApiInterface sendReq:req];
 }
 [self handleSendResult:sent];
 }
 */

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        default:
        {
            break;
        }
    }
}

/**
 * Called when the user successfully logged in.
 */
- (void)tencentDidLogin {
    // 登录成功
	   
    NSLog(@"tencentOAuth.accessToken");
    if (tencentOAuth.accessToken
        && 0 != [tencentOAuth.accessToken length])
    {
        // _tencentOAuth.accessToken;
        
        NSLog(@"tencentOAuth.accessToken==%@====%@",tencentOAuth.openId,tencentOAuth.redirectURI);
        
        //琅琊直播认证
        //[self getUserInfo];
        [self HuoWuLiveOAuth];
        
        //[self getUserInfo];
    }
    else
    {
        //登录不成功 没有获取accesstoken;
    }
}

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled){
        //用户取消登录;
    }
    else {
        //登录失败"
    }
    
}

/**
 * Called when the notNewWork.
 */
-(void)tencentDidNotNetWork
{
    //无网络连接，请设置网络
}

/**
 * Called when the logout.
 */
-(void)tencentDidLogout
{
    //退出登录成功，请重新登录;
    
}

/**
 * call sever for land
 */
// 有美直播
-(void)HuoWuLiveOAuth
{
    
    ESWeakSelf
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        
        NSLog(@"qq getuser info =%@",responseDic);
        
        ESStrongSelf
        if ([responseDic[@"ret"] intValue] == 0) {
            NSMutableDictionary *userinfoDic = [NSMutableDictionary dictionary];
            [userinfoDic setObject:responseDic[@"nickname"] forKey:@"nickname"];
            [userinfoDic setObject:responseDic[@"figureurl_qq_2"] forKey:@"face"];
            if ([responseDic[@"gender"] isEqualToString:@"男"]) {
                [userinfoDic setObject:@"1" forKey:@"sex"];
            } else {
                [userinfoDic setObject:@"2" forKey:@"sex"];
            }
            
            [userinfoDic setObject:tencentOAuth.openId forKey:@"openid"];
            [userinfoDic setObject:tencentOAuth.accessToken forKey:@"access_token"];
            [userinfoDic setObject:@"qq" forKey:@"pf"];
            
            [_self loginThird:userinfoDic];
        }else{
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
    };
    
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        NSLog(@"request  =%@",error);
    };
    
    NSDictionary *parameters=@{@"openid":tencentOAuth.openId,@"access_token":tencentOAuth.accessToken,@"oauth_consumer_key":kQQAppID};
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameters
                                                  withPath:@"https://graph.qq.com/user/get_user_info"
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}

- (void) loginThird:(NSDictionary *)userInfo
{
    NSMutableDictionary *loginInfo = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    [loginInfo setObject:[UIDevice openUDID] forKey:@"udid"];
    [loginInfo setObject:@"1" forKey:@"app_type"];
    [loginInfo setObject:@"1" forKey:@"ry"];
    NSLog(@"device:udid:%@",[UIDevice openUDID]);
    
    NSMutableString *string = [NSMutableString string];
    NSArray<NSString *>* arr = [loginInfo allKeys];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(NSString*  _Nonnull obj1, NSString*  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    for (NSString *key in arr) {
        [string appendFormat:@"%@/", loginInfo[key]];
    }
    [string appendString:@"HuoWuLive"];
    
    NSLog("before %@", string);
    NSString* md5String = [WXUtil md5:string];
    NSLog(@"after %@", md5String);
          
    
    LCRequestSuccessResponseBlock requestSuccessBlock=^(NSDictionary *responseDic){
        NSLog(@"qq login %@",responseDic);
        
        int stat = [responseDic[@"stat"] intValue];
        if(stat == URL_REQUEST_SUCCESS
                && responseDic[@"userinfo"])
        {
            [[LCCore globalCore] sendPushToken:responseDic[@"userinfo"][@"device_token"]];
            
            
            [[LCMyUser mine] fillWithDictionary:responseDic[@"userinfo"]];
            [[LCMyUser mine] save];
            
            [LCCore globalCore].isThirdLogin = false;
            
            [LCCore presentMainViewController];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_Land_Sucess object:nil];
        }
        else
        {
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
        
    };
    
    LCRequestFailResponseBlock requestFailBlock=^(NSError *error){
        NSLog(@"reqWXUserInfo error=%@",error);
    };
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:loginInfo
                                                  withPath:URL_THIRD_LOGIN
                                               withRESTful:POST_REQUEST
                                          withSuccessBlock:requestSuccessBlock
                                             withFailBlock:requestFailBlock];
}



#pragma mark - QQApiInterfaceDelegate
- (void)onReq:(QQBaseReq *)req
{
    switch (req.type)
    {
        case EGETMESSAGEFROMQQREQTYPE:
        {
            
            break;
        }
        default:
        {
            break;
        }
    }
}

- (void)onResp:(QQBaseResp *)resp
{
    switch (resp.type)
    {
        case ESENDMESSAGETOQQRESPTYPE:
        {
            
            SendMessageToQQResp* sendResp = (SendMessageToQQResp*)resp;
            
            if([sendResp.result intValue]==0)
                [LCCore shareSucc:_isShareInZone?QQ_ZONE_SHARE_SUCC:QQ_SHARE_SUCC];
            break;
        }
        default:
        {
            break;
        }
    }
}

#pragma mark - 开始请求分享内容
- (void) requestShareContent:(BOOL)isShareToZone
{
    if (isRequestContent) {
        return;
    }
    isRequestContent = YES;
    self.isShareInZone = isShareToZone;
    ESWeakSelf;
    LCRequestSuccessResponseBlock requestSuccessBlock=^(NSDictionary *responseDic){
        NSLog(@"request share content %@",responseDic);
        ESStrongSelf;
        isRequestContent = NO;
        
        int stat = [responseDic[@"stat"] intValue];
        if(stat == URL_REQUEST_SUCCESS)
        {
            [QCShareResource shareResource].shareUrlString = responseDic[@"url"];
            [QCShareResource shareResource].shareTitle = responseDic[@"title"];
            [QCShareResource shareResource].shareImgUrl = responseDic[@"img"];
            [QCShareResource shareResource].shareDescription = responseDic[@"desc"];
            
            if (isShareToZone) {
                [_self startShareWithZone];
            } else {
                [_self startShareWithFriend];
            }
        }
        else
        {
            [QCShareResource shareResource].shareUrlString = [NSString stringWithFormat:@"http://web.hainandaocheng.com/play?uid=%@&liveid=%@&share_from=qq&share_uid=%@",[LCMyUser mine].userID,[LCMyUser mine].playVdoid?[LCMyUser mine].playVdoid:[LCMyUser mine].liveUserId,[LCMyUser mine].userID];
            if (isShareToZone) {
                [_self startShareWithZone];
            } else {
                [_self startShareWithFriend];
            }
        }
        
    };
    
    LCRequestFailResponseBlock requestFailBlock=^(NSError *error){
        NSLog(@"request share error=%@",error);
        ESStrongSelf;
        isRequestContent = NO;
        
        [QCShareResource shareResource].shareUrlString = [NSString stringWithFormat:@"http://web.hainandaocheng.com/play?uid=%@&liveid=%@&share_from=qq&share_uid=%@",[LCMyUser mine].userID,[LCMyUser mine].playVdoid?[LCMyUser mine].playVdoid:[LCMyUser mine].liveUserId,[LCMyUser mine].userID];
        if (isShareToZone) {
            [_self startShareWithZone];
        } else {
            [_self startShareWithFriend];
        }
        
    };
    
    NSString *roomUserId;
    if ([LCMyUser mine].playBackUserId) {
        roomUserId = [LCMyUser mine].playBackUserId;
    } else if ([LCMyUser mine].liveUserId) {
        roomUserId = [LCMyUser mine].liveUserId;
    }
    
    if (roomUserId) {
        __weak typeof(self)weakself = self;
        if (_shareType == SHARE_RECORD_VIDEO) {
            [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"url":[LCMyUser mine].videoURL,@"title":[LCMyUser mine].nickname} withPath:@"share/screen" withRESTful:GET_REQUEST withSuccessBlock:^(NSDictionary *responseDic) {
                isRequestContent = NO;
                
                int stat = [responseDic[@"stat"] intValue];
                if(stat == URL_REQUEST_SUCCESS)
                {
                    [QCShareResource shareResource].shareUrlString = responseDic[@"url"];
                    [QCShareResource shareResource].shareTitle = [LCMyUser mine].nickname;
                    [QCShareResource shareResource].shareImgUrl = [LCMyUser mine].faceURL;
                    [QCShareResource shareResource].shareDescription = [NSString stringWithFormat:@"来自%@分享的视频",[LCMyUser mine].nickname];
                    if (isShareToZone) {
                        [weakself startShareWithZone];
                    } else {
                        [weakself startShareWithFriend];
                    }                }
            } withFailBlock:requestFailBlock];
        }else {
            
            [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"liveuid":roomUserId,@"vdoid":[LCMyUser mine].playVdoid?[LCMyUser mine].playVdoid:@"",@"type":@(_shareType),@"city":@"",@"pf":isShareToZone?QQ_SHARE_SUCC:QQ_ZONE_SHARE_SUCC}
                                                          withPath:@"share"
                                                       withRESTful:GET_REQUEST
                                                  withSuccessBlock:requestSuccessBlock
                                                     withFailBlock:requestFailBlock];
        }
    }
    
}

#pragma mark - 开始分享
- (void) startShareWithFriend
{
    QCShareResource *share = [QCShareResource shareResource];
    
    NSString *utf8String = !share.shareUrlString?QCShareUrlString:share.shareUrlString;
    NSString *title = !share.shareTitle?QCShareTitle:share.shareTitle;
    NSString *description = !share.shareDescription?QCShareDescription:share.shareDescription;
    NSString *previewImageUrl = !share.shareImgUrl?QCShareImageUrl:share.shareImgUrl;
    
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:utf8String]
                                title:title
                                description:description
                                previewImageURL:[NSURL URLWithString:previewImageUrl]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    
    //将内容分享到qq
    [QQApiInterface sendReq:req];
}

- (void) startShareWithZone
{
    QCShareResource *share = [QCShareResource shareResource];
    
    NSString *utf8String = !share.shareUrlString?QCShareUrlString:share.shareUrlString;
    NSString *title = !share.shareTitle?QCShareTitle:share.shareTitle;
    NSString *description = !share.shareDescription?QCShareDescription:share.shareDescription;
    NSString *previewImageUrl = !share.shareImgUrl?QCShareImageUrl:share.shareImgUrl;
    
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:utf8String]
                                title:title
                                description:description
                                previewImageURL:[NSURL URLWithString:previewImageUrl]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qq
    //QQApiSendRes ultCode sent = [QQApiInterface sendReq:req];
    //将内容分享到qzone
    [QQApiInterface SendReqToQZone:req];
}

@end
