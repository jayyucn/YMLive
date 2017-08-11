//
//  WXPayManager.m
//  qianchuo 微信支付
//
//  Created by jacklong on 16/5/1.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "WXPayManager.h" 
#import "payRequsestHandler.h"
#import "QCShareResource.h"

@interface WXPayManager(){
    BOOL isRequestContent;
}
@end

@implementation WXPayManager

ES_SINGLETON_IMP(wxPayManager);

-(id)init
{
    if(self=[super init])
    {
        [WXApi registerApp:APP_ID];
    }
    return self;
}


- (BOOL) isWXAppInstall
{
    if ([WXApi isWXAppInstalled]) {
        //判断是否有微信
        return true;
    }
    
    return false;
}

- (void) sendLinkContent
{
    [self requestShareContent];
}

// 微信登录
- (void) sendAuthReq
{
    if (_showWxView == nil) {
        return;
    }
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo"; // @"post_timeline,sns"
    req.state = @"123" ;
    [WXApi sendAuthReq:req viewController:_showWxView delegate:self];
}

- (void)sendPay:(NSMutableDictionary *)goods
{
    if (goods == nil || [goods count] < 2) {
        [LCNoticeAlertView showMsg:@"请选择支付的元宝"];
    }
    
    NSMutableDictionary *goodsParam = [NSMutableDictionary dictionaryWithDictionary:goods];
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000 * 1000;
    
    _out_trade_no = [NSString stringWithFormat:@"%d%@%llu", arc4random() % 10000,[LCMyUser mine].userID,recordTime];
    
    [goodsParam setObject:_out_trade_no forKey:@"out_trade_no"];
    [goodsParam setObject:[NSString stringWithFormat:@"%d",[goods[@"money"] intValue]] forKey:@"money"];
    [goodsParam setObject:[NSString stringWithFormat:@"%d",[goods[@"diamond"] intValue]] forKey:@"diamond"];
    [goodsParam setObject:@"ios" forKey:@"pf"];
    
    [self requestPayOrder:goodsParam];
}

-(void)requestPayOrder:(NSMutableDictionary *)goods {
    LCRequestSuccessResponseBlock requestSuccessBlock=^(NSDictionary *responseDic){
        
        NSLog(@"gagresponseDic=%@",responseDic);
        
        int stat=[responseDic[@"stat"] intValue];
        
        if(stat==200)
        {
            [self sendWxPay:goods];
        }
        else{
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
            
        }
    };
    
    LCRequestFailResponseBlock requestFailBlock=^(NSError *error){
        NSLog(@"gagerror=%@",error);
    };
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:goods
                                                    withPath:@"pay/wxorder"
                                                 withRESTful:POST_REQUEST
                                            withSuccessBlock:requestSuccessBlock
                                               withFailBlock:requestFailBlock];
}

-(void)sendWxPay:(NSMutableDictionary *)goods
{
    //{{{
    //本实例只是演示签名过程， 请将该过程在商户服务器上实现
    
    //创建支付签名对象
    payRequsestHandler *req = [payRequsestHandler alloc];
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req setKey:PARTNER_ID];
    
    int showMoney = [goods[@"money"] intValue] * 100;
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPay:[NSString stringWithFormat:@"购买%@钻石",goods[@"diamond"]] withMoney:[NSString stringWithFormat:@"%d",showMoney] withOrderId:_out_trade_no withIsWebPay:NO];
    
    if(dict == nil) {
        //错误提示
        NSString *debug = [req getDebugifo];
        
        //        [self alert:@"提示信息" msg:debug];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"微信支付异常，请稍后再试，或者使用其他支付方式" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        NSLog(@"%@\n\n",debug);
    } else {
        NSLog(@"%@\n\n",[req getDebugifo]);
        //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        
        [WXApi sendReq:req];
    }
}

+ (NSString *)jumpToBizPay {
    
    //============================================================
    // V3&V4支付流程实现
    // 注意:参数配置请查看服务器端Demo
    // 更新时间：2015年11月20日
    //============================================================
    NSString *urlString   = @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios";
    //解析服务端返回json数据
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ( response != nil) {
        NSMutableDictionary *dict = NULL;
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        
        NSLog(@"url:%@",urlString);
        if(dict != nil){
            NSMutableString *retcode = [dict objectForKey:@"retcode"];
            if (retcode.intValue == 0){
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.partnerId           = [dict objectForKey:@"partnerid"];
                req.prepayId            = [dict objectForKey:@"prepayid"];
                req.nonceStr            = [dict objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [dict objectForKey:@"package"];
                req.sign                = [dict objectForKey:@"sign"];
                [WXApi sendReq:req];
                //日志输出
                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                return @"";
            }else{
                return [dict objectForKey:@"retmsg"];
            }
        }else{
            return @"服务器返回错误，未获取到json对象";
        }
    }else{
        return @"服务器返回错误";
    }
}


- (void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
        
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n\n", msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
}

-(void) onResp:(BaseResp*)resp
{
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        if(resp.errCode==0)
        {
            NSLog(@"resp share succ type:%d ",resp.type);
            [LCCore shareSucc:self.scene==WXSceneSession?WEIXIN_SHARE_SUCC:WEIXIN_CIRCLE_SHARE_SUCC];
        }
        else
        {
            if([resp isKindOfClass:[SendMessageToWXResp class]])
            {
                strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
            }
        }
    }
    else if([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp *temp = (SendAuthResp*)resp;
        
        if (temp.errCode == 0) {
            [self reqWXAccessToken:temp.code];
        }else{
            [LCNoticeAlertView showMsg:[NSString stringWithFormat:@"授权失败 errorCode=%d",temp.errCode]];
        }
        
    }else if([resp isKindOfClass:[PayResp class]]) {
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                [self purchaseSuccess];
                break;
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                [LCNoticeAlertView showMsg:resp.errStr];
                break;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)purchaseSuccess
{
    
    LCRequestSuccessResponseBlock requestSuccessBlock=^(NSDictionary *responseDic){
        
        NSLog(@"purchaseSuccess=%@",responseDic);
        
        int stat=[responseDic[@"stat"] intValue];
        
        if(stat==200)
        {
                if(responseDic[@"diamond"])
                {
                    NSLog(@"purchase success:%d",[LCMyUser mine].diamond);
                    [LCMyUser mine].diamond = [responseDic[@"diamond"] intValue];
                    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_UpdateMoney
                                                                        object:nil
                                                                      userInfo:nil];
                }
        }
        else{
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
    };
    
    LCRequestFailResponseBlock requestFailBlock=^(NSError *error){
        NSLog(@"purchaseSuccess error=%@",error);
        
    };
    
    if (_out_trade_no) {
        NSDictionary *parameters=@{@"out_trade_no":_out_trade_no};
        [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameters
                                                      withPath:@"pay/success"
                                                   withRESTful:POST_REQUEST
                                              withSuccessBlock:requestSuccessBlock
                                                 withFailBlock:requestFailBlock];
    }
    
}


// request wx access_token
-(void)reqWXAccessToken:(NSString *)code
{
    ESWeakSelf
    LCRequestSuccessResponseBlock requestSuccessBlock=^(NSDictionary *responseDic){
        
        NSLog(@"reqWXAccessToken=%@",responseDic);
        
        NSString * access_token = responseDic[@"access_token"];
        
        if (access_token != nil && [access_token length] > 0) {
            ESStrongSelf
            [_self reqWXUserInfo:access_token];
        }
    };
    
    LCRequestFailResponseBlock requestFailBlock=^(NSError *error){
        NSLog(@"reqWXAccessToken error=%@",error);
    };
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"appid":APP_ID,@"secret":APP_SECRET,@"code":code,@"grant_type":@"authorization_code"}
                                                    withPath:@"https://api.weixin.qq.com/sns/oauth2/access_token"
                                                 withRESTful:POST_REQUEST
                                            withSuccessBlock:requestSuccessBlock
                                               withFailBlock:requestFailBlock];
}

// request weixin userinfo
-(void)reqWXUserInfo:(NSString *)accessToken{
    ESWeakSelf
    LCRequestSuccessResponseBlock requestSuccessBlock=^(NSDictionary *responseDic){
        
        NSLog(@"reqWXUserInfo=%@",responseDic);
        if (responseDic[@"openid"]) {
            NSMutableDictionary * userinfo = [NSMutableDictionary dictionary];
            [userinfo setObject:responseDic[@"openid"] forKey:@"openid"];
            [userinfo setObject:accessToken forKey:@"access_token"];
            [userinfo setObject:@"weixin" forKey:@"pf"];
            [userinfo setObject:responseDic[@"sex"] forKey:@"sex"];
            [userinfo setObject:responseDic[@"nickname"] forKey:@"nickname"];
            [userinfo setObject:responseDic[@"headimgurl"] forKey:@"face"];
            
            
            ESStrongSelf
            [_self loginQC:userinfo];
        }
    };
    
    LCRequestFailResponseBlock requestFailBlock=^(NSError *error){
        NSLog(@"reqWXUserInfo error=%@",error);
    };
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"openid":APP_ID,@"access_token":accessToken}
                                                    withPath:@"https://api.weixin.qq.com/sns/userinfo"
                                                 withRESTful:POST_REQUEST
                                            withSuccessBlock:requestSuccessBlock
                                               withFailBlock:requestFailBlock];
}

-(void)loginQC:(NSDictionary *)userInfo{
    NSMutableDictionary *loginInfo = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    [loginInfo setObject:[UIDevice openUDID] forKey:@"udid"];
    [loginInfo setObject:@"1" forKey:@"app_type"];
    [loginInfo setObject:@"1" forKey:@"ry"];
    NSLog(@"device:udid:%@",[UIDevice openUDID]);
    
    LCRequestSuccessResponseBlock requestSuccessBlock=^(NSDictionary *responseDic){
        NSLog(@"wx login %@",responseDic);
        
        int stat = [responseDic[@"stat"] intValue];
        if(stat == URL_REQUEST_SUCCESS)
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
    
    NSLog(@"oauth login parameter:%@",loginInfo);
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:loginInfo
                                                    withPath:URL_THIRD_LOGIN
                                                 withRESTful:POST_REQUEST
                                            withSuccessBlock:requestSuccessBlock
                                               withFailBlock:requestFailBlock];
    
}

#pragma mark - 分享
- (void) requestShareContent
{
    if (isRequestContent) {
        return;
    }
    isRequestContent = YES;
    
    ESWeakSelf;
    LCRequestSuccessResponseBlock requestSuccessBlock=^(NSDictionary *responseDic){
//        NSLog(@"request share content %@",responseDic);
        ESStrongSelf;
        isRequestContent = NO;
        
        int stat = [responseDic[@"stat"] intValue];
        if(stat == URL_REQUEST_SUCCESS)
        {
            [QCShareResource shareResource].shareUrlString = responseDic[@"url"];
            [QCShareResource shareResource].shareTitle = responseDic[@"title"];
            [QCShareResource shareResource].shareImgUrl = responseDic[@"img"];
            [QCShareResource shareResource].shareDescription = responseDic[@"desc"];
            
            [_self startShareContent];
        }
        else
        {
            [QCShareResource shareResource].shareUrlString = [NSString stringWithFormat:@"http://web.hainandaocheng.com/play?uid=%@&liveid=%@&share_from=qq&share_uid=%@",[LCMyUser mine].userID,[LCMyUser mine].playVdoid?[LCMyUser mine].playVdoid:[LCMyUser mine].liveUserId,[LCMyUser mine].userID];
            [_self startShareContent];
        }
        
    };
    
    LCRequestFailResponseBlock requestFailBlock=^(NSError *error)
    {
        ESStrongSelf;
        isRequestContent = NO;
        
        [QCShareResource shareResource].shareUrlString = [NSString stringWithFormat:@"http://web.hainandaocheng.com/play?uid=%@&liveid=%@&share_from=qq&share_uid=%@",[LCMyUser mine].userID,[LCMyUser mine].playVdoid?[LCMyUser mine].playVdoid:[LCMyUser mine].liveUserId,[LCMyUser mine].userID];
        [_self startShareContent];
    };
    
    NSString *roomUserId;
    
    if ([LCMyUser mine].playBackUserId) {
        roomUserId = [LCMyUser mine].playBackUserId;
    } else if ([LCMyUser mine].liveUserId){
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
                    [weakself startShareContent];
                }
            } withFailBlock:requestFailBlock];
        }else {
            
            [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"no_compress":@(1), @"liveuid":roomUserId,@"vdoid":[LCMyUser mine].playVdoid?[LCMyUser mine].playVdoid:@"",@"type":@(_shareType),@"city":@"",@"pf":(self.scene==WXSceneSession?WEIXIN_SHARE_SUCC:WEIXIN_CIRCLE_SHARE_SUCC)}
                                                          withPath:@"share"
                                                       withRESTful:GET_REQUEST
                                                  withSuccessBlock:requestSuccessBlock
                                                     withFailBlock:requestFailBlock];
        }
    }
}


- (void) startShareContent
{
    QCShareResource *share = [QCShareResource shareResource];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[QCShareResource shareResource].shareImgUrl]]; // 用本地头像，服务器的头像有延迟
    if (data) {
        UIImage *img = [[UIImage alloc] initWithData:data];
        data = [self imageWithImage:img scaledToSize:CGSizeMake(150, 150)]; // 压缩
        WXMediaMessage *message = [WXMediaMessage message];
        if (_scene == WXSceneTimeline) {
            message.title = share.shareDescription?share.shareDescription:QCShareDescription;
        }else{
            message.title = share.shareTitle?share.shareTitle:QCShareTitle;
        }
        
        NSString *description = share.shareDescription?share.shareDescription:QCShareDescription;
        message.description = description;
        [message setThumbImage:[UIImage imageWithData:data]];
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = share.shareUrlString?share.shareUrlString:QCShareUrlString;
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = self.scene;
        
        [WXApi sendReq:req];
    }
}

- (NSData *)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.8);
}

@end
