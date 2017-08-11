//
//  LCLandViewController.m
//  XCLive
//
//  Created by ztkztk on 14-4-29.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCLandViewController.h"
#import "MMAlertTextView.h" 
#import "LCInsetsLabel.h"
#import "KFRegisterFirstController.h"
#import "KFResetPwdVC.h"
#import "LCMyUser.h"
#import "LCCore.h"
#import "CustomNotification.h"
#import "LCNoticeAlertView.h"
#import "WXPayManager.h"
#import "QCTencentManager.h"
//#import "FBSDKGraphRequest.h"
//#import "QCSinaManager.h"
//#import "FacebookManager.h"
//#import <FBSDKLoginKit/FBSDKLoginKit.h>
@import CoreTelephony;

@interface LCLandViewController () // <FBSDKLoginButtonDelegate>


@property (nonatomic, strong)NSMutableArray *userInfos;
@end

@implementation LCLandViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=ESLocalizedString(@"登 录");
    
    _userInfos = [NSMutableArray array];
    
    UIButton *rightItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItemBtn.frame=CGRectMake(0, 0, 65.0, 30.0);
    
    [rightItemBtn setTitle:ESLocalizedString(@"注册")
                  forState:UIControlStateNormal];
    rightItemBtn.backgroundColor=[UIColor clearColor];
    
    [rightItemBtn addTarget:self
                     action:@selector(rightAction)
           forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithCustomView:rightItemBtn];
    self.navigationItem.rightBarButtonItem=rightItem;

    
    self.confirmPassword.hidden=YES;
    
   // NSLog(@"=====%@",[[NSUserDefaults standardUserDefaults] objectForKey:PreAccount]);
    self.accountField.text=[[NSUserDefaults standardUserDefaults] objectForKey:PreAccount];
    _forgetPassword = [UIButton buttonWithType:UIButtonTypeCustom];
    _forgetPassword.frame=CGRectMake(220, 0, 80, 30);
    _forgetPassword.left =  ScreenWidth - 80 - 20;
    _forgetPassword.top = self.password.bottom+5.0f;
    
    [_forgetPassword setTitle:NSLocalizedString(@"忘记密码", nil)
                  forState:UIControlStateNormal];
    
    
    [_forgetPassword setTitleColor:[UIColor colorWithRed:175.0/255 green:142.0/255 blue:93.0/255 alpha:1.0]
                          forState:UIControlStateNormal];
    
    [_forgetPassword addTarget:self
                     action:@selector(forgetPasswordAction)
           forControlEvents:UIControlEventTouchUpInside];
    
    
    _forgetPassword.titleLabel.font = [UIFont systemFontOfSize:15];
    
    
    _forgetPassword.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:_forgetPassword];
    
    self.registerBtn.top = self.forgetPassword.bottom +5.0f;
    self.registerBtn.width = ScreenWidth - self.registerBtn.left * 2;
    [self.registerBtn setTitle:ESLocalizedString(@"登录")
                  forState:UIControlStateNormal];
    
    [self.registerBtn addTarget:self
                     action:@selector(btnAction)
           forControlEvents:UIControlEventTouchUpInside];
//    _locationManager=[LocationManager locationManager];
    
    /*
    if ([[LCCore globalCore] shouldShowPayment]) {
        NSLog(@"landviewcontroller %d",[[LCCore globalCore] shouldRequestSync]);
        LCInsetsLabel *sectionFooterLabel=[[LCInsetsLabel alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,50) andInsets:UIEdgeInsetsMake(3,12,0,12)];
        
        sectionFooterLabel.top=self.registerBtn.bottom+10;
        sectionFooterLabel.textAlignment = NSTextAlignmentCenter;
        sectionFooterLabel.textColor=[UIColor grayColor];
        sectionFooterLabel.font=[UIFont systemFontOfSize:16];
        sectionFooterLabel.backgroundColor =[UIColor clearColor];
        sectionFooterLabel.numberOfLines = 0;
        
        NSString *labelString= [NSString stringWithFormat:@"----------  %@  ----------", NSLocalizedString(@"第三方合作账号", nil)];
        
        NSDictionary *attrs = @{NSFontAttributeName : sectionFooterLabel.font};
        CGSize size = [labelString boundingRectWithSize:CGSizeMake(sectionFooterLabel.width-sectionFooterLabel.insets.left*2, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
        
        sectionFooterLabel.height = size.height+12;
        sectionFooterLabel.text = labelString;
        [self.view addSubview:sectionFooterLabel];
        
        UIImage *qqImage=[UIImage imageNamed:@"image/reg/login_new_qq"];
        UIButton * qqLoginBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        qqLoginBtn.frame=CGRectMake(0, sectionFooterLabel.bottom +10.0f,50,50);
        qqLoginBtn.centerX = SCREEN_WIDTH/4;
        [qqLoginBtn setBackgroundImage:qqImage forState:UIControlStateNormal];
        [qqLoginBtn addTarget:self
                       action:@selector(qqLoginAction)
             forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:qqLoginBtn];
    
        UIImage *wxImage=[UIImage imageNamed:@"image/reg/login_new_weixin"];
        UIButton * wxLoginBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        wxLoginBtn.frame=CGRectMake(0, sectionFooterLabel.bottom +10.0f,qqLoginBtn.width,qqLoginBtn.height);
        wxLoginBtn.centerX = SCREEN_WIDTH/4 * 3;
        [wxLoginBtn setBackgroundImage:wxImage forState:UIControlStateNormal];
        [wxLoginBtn addTarget:self
                       action:@selector(wxLoginAction)
             forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:wxLoginBtn];
        
        UIImage *sinaImage = [UIImage imageNamed:@"image/reg/login_new_weibo"];
        UIButton *sinaLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sinaLoginBtn.frame=CGRectMake(0, sectionFooterLabel.bottom +10.0f,qqLoginBtn.width,qqLoginBtn.height);
        sinaLoginBtn.centerX = SCREEN_WIDTH/2;
        [sinaLoginBtn setBackgroundImage:sinaImage forState:UIControlStateNormal];
        [sinaLoginBtn addTarget:self
                       action:@selector(sinaLoginAction)
             forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:sinaLoginBtn];

    } else {
         NSLog(@"landviewcontroller no %d",[[LCCore globalCore] shouldRequestSync]);
    }
     */
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self showWifiInfo];
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


//- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)loginResult error:(NSError *)error {
//    if ([loginResult token]) {
//        [FacebookManager shareInstance].token = loginResult.token;
//        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"picture.type(large), gender, name"}]
//         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//             if (!error) {
//                 [FacebookManager shareInstance].sex = @"1";
//                 if ([result[@"gender"] isKindOfClass:[NSString class]] && [result[@"gender"] isEqualToString:@"female"]) {
//                     [FacebookManager shareInstance].sex = @"2";
//                 }
//                 [FacebookManager shareInstance].face = result[@"picture"][@"data"][@"url"];
//                 [FacebookManager shareInstance].nickname = result[@"name"];
//                 
//                 [[FacebookManager shareInstance] requestLogin];
//             }
//         }];
//    }
//}

//- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
//    
//}

-(void)rightAction
{
    [LCCore globalCore].isThirdLogin = false;
    
    KFRegisterFirstController *registerController = [[KFRegisterFirstController alloc] init];
    [self.navigationController  pushViewController:registerController animated:YES];
}

-(void)forgetPasswordAction
{
    UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                                    initWithTitle:nil
                                    delegate:self
                                    cancelButtonTitle:ESLocalizedString(@"取消")
                                    destructiveButtonTitle:nil
                                    otherButtonTitles:ESLocalizedString(@"手机找回密码"),ESLocalizedString(@"联系客服"),nil];
    [myActionSheet showInView:self.view];
}



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            KFResetPwdVC *controller = [[KFResetPwdVC alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 1:
        {
            ESWeakSelf;
            [MMAlertTextView showAlertTextView:ESLocalizedString(@"联系客服")
                                  textViewText:@""
                                    holderText:ESLocalizedString(@"请输入账号以及其他信息，以便审核人员确认是否正确，别忘了留下您的联系方式")
                               withEditedBlock:^(NSString *textString){
                                   
                                   ESStrongSelf;
                                   [_self contractSever:textString];
                                   
                                   
                               }];
        }
            break;
        default:
            break;
    }
}


-(void)contractSever:(NSString *)memo
{
    NSDictionary *dic=@{@"memo":memo,@"udid":[UIDevice openUDID]};
    
    ESWeakSelf;
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic)
    {
        ESStrongSelf;
        NSLog(@"contact server %@",responseDic);
        int stat=[responseDic[@"stat"] intValue];
        if(stat == URL_REQUEST_SUCCESS)
        {
            [LCNoticeAlertView showMsg:ESLocalizedString(@"已经联系客服人员，请等待审核！")];
        }
        else
        {
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        NSLog(@"contact server =%@",error);
        
        [LCNoticeAlertView showMsg:ESLocalizedString(@"请求网络失败！")];
    };
    
    NSLog(@"parameter dict%@",dic);
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:dic
                                                  withPath:URL_LIVE_CONTACT_SERVER
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}

-(void)btnAction
{
    if(self.accountField.text&&self.password.text)
    {

        NSMutableDictionary *loginDic=[NSMutableDictionary dictionary];
        [loginDic setObject:self.accountField.text forKey:@"account"];
        [loginDic setObject:[self.password.text es_md5HashString] forKey:@"pwd"];
        
        [self login:loginDic];
    }
}


-(void)login:(NSDictionary *)loginDic
{
    
    ESWeakSelf;
    NSMutableDictionary *paramDict=[NSMutableDictionary dictionaryWithDictionary:loginDic];
    
    [paramDict setObject:[UIDevice openUDID] forKey:@"udid"];
    [paramDict setObject:@"1" forKey:@"ry"];
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic)
    {
        NSLog(@"login result %@",responseDic);
        
        int stat = [responseDic[@"stat"] intValue];
        if(stat == URL_REQUEST_SUCCESS)
        {
            ESStrongSelf;
            [[LCCore globalCore] sendPushToken:responseDic[@"userinfo"][@"device_token"]];
            
            [[LCMyUser mine] fillWithDictionary:responseDic[@"userinfo"]]; 
            [[LCMyUser mine] save];
            
            [LCCore globalCore].isThirdLogin = false;
            [[NSUserDefaults standardUserDefaults] setObject:_self.accountField.text
                                                      forKey:PreAccount];
            
            [LCCore presentMainViewController];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_Land_Sucess object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_EditInfo_Success object:nil];//更新设置页面显示内容
        }
        else
        {
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }

    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        NSLog(@"login fail =%@",error);
        
        [LCNoticeAlertView showMsg:ESLocalizedString(@"请求网络失败！")];
    };
    
    
    NSLog(@"parameter login %@",paramDict);
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:paramDict
                                                  withPath:URL_LIVE_LOGIN
                                               withRESTful:POST_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}

#pragma mark - third login
- (void) wxLoginAction
{
    [LCCore globalCore].isThirdLogin = true;
    
    [WXPayManager wxPayManager].showWxView = self;
    [[WXPayManager wxPayManager] sendAuthReq];
}

- (void) qqLoginAction
{
    [LCCore globalCore].isThirdLogin = true;
    
    [[QCTencentManager tencentManager] tencentOAuthWithoutSafari];
//    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
//           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
//     {
//         if (state == SSDKResponseStateSuccess)
//         {
//             
//             NSLog(@"uid=%@",user.uid);
//             NSLog(@"%@",user.credential);
//             NSLog(@"token=%@",user.credential.token);
//             NSLog(@"nickname=%@",user.nickname);
//            [LCCore presentMainViewController];
//         }
//         
//         else
//         {
//             NSLog(@"qqLoginAction error%@",error);
//         }
//         
//     }];
    
//    ESWeakSelf;
//    [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeQQ
//                                   onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
//                                       
//                                       //在此回调中可以将社交平台用户信息与自身用户系统进行绑定，最后使用一个唯一用户标识来关联此用户信息。
//                                       //在此示例中没有跟用户系统关联，则使用一个社交用户对应一个系统用户的方式。将社交用户的uid作为关联ID传入associateHandler。
//                                       associateHandler (user.uid, user, user);
//                                       NSLog(@"qq user SYNC");
//                                       NSLog(@"qq dd%@",user.rawData);
//                                       NSLog(@"qq dd%@",user.credential);
//                                       
//                                       NSLog(@"sex:%ld openid:%@ nickname:%@ icon:%@ birthday:%@ uid:%@",user.gender,user.credential.uid,user.nickname,user.icon,user.birthday,user.uid);
//                                       NSLog(@"gender:%@",[user.rawData[@"gender"] URLDecode]);
//                                       NSMutableDictionary * userinfo = [NSMutableDictionary dictionary];
//                                       [userinfo setObject:user.uid forKey:@"openid"];
//                                       [userinfo setObject:@"qq" forKey:@"pf"];
//                                       if ([[user.rawData[@"gender"] URLDecode] isEqualToString:@"男"]) {
//                                           [userinfo setObject:[NSNumber numberWithInt:1] forKey:@"sex"];
//                                       } else {
//                                           [userinfo setObject:[NSNumber numberWithInt:2] forKey:@"sex"];
//                                       }
//                                       [userinfo setObject:user.nickname forKey:@"nickname"];
//                                       [userinfo setObject:user.icon forKey:@"face"];
//                                       if (user.birthday) {
//                                         [userinfo setObject:user.birthday forKey:@"birthday"];
//                                       }
//                                       
//                                       
//                                       ESStrongSelf
//                                       [_self loginThird:userinfo];
//                                   }
//                                onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
//                                    if (state == SSDKResponseStateSuccess)
//                                    {
//                                        
//                                        
////                                        [_userInfos addObject:user];
////                                        ThirdPartyUserInfo *userInfo = _userInfos[0];
////                                        NSLog(@"qq login succ:%@  linkedid:%@ ",userInfo.socialUsers,userInfo.linkId);
//                                    }
//                                    else
//                                    {
//                                        NSLog(@"QQ login fail %@",error);
//                                    }
//                                    
//                                }];
}

- (void)fackbookLogin {
    NSLog(@"login");
}

- (void) sinaLoginAction
{
//    [LCCore globalCore].isThirdLogin = true;
//    [[QCSinaManager sinaManager] ssoAuthSina];
}

- (void) loginThird:(NSDictionary *)userInfo
{
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
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:loginInfo
                                                  withPath:URL_THIRD_LOGIN
                                               withRESTful:POST_REQUEST
                                          withSuccessBlock:requestSuccessBlock
                                             withFailBlock:requestFailBlock];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
