//
//  KFRegisterFirstController.m
//  CaoLiu
//
//  Created by jacklong on 15/9/10.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import "KFRegisterFirstController.h"
#import "LCRegDoneController.h"
#import "LCCore.h"
#import "LCNoticeAlertView.h"

@implementation KFRegisterFirstController

- (void)dealloc
{
    //    [[LCHTTPClient sharedHTTPClient] cancelAllHTTPOperationsWithMethod:nil path:getLivePhoneSendSmsURL()];
    //    [[LCHTTPClient sharedHTTPClient] cancelAllHTTPOperationsWithMethod:nil path:getLivePhoneRegURL()];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title= ESLocalizedString(@"注册(1/2)");
    
    self.rightItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightItemBtn.frame=CGRectMake(0, 0, 50, 65.0/2);
    
    [self.rightItemBtn setTitle:ESLocalizedString(@"下一步")
                       forState:UIControlStateNormal];
    
    [self.rightItemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.rightItemBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    
    [self.rightItemBtn addTarget:self
                          action:@selector(rightAction)
                forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithCustomView:self.rightItemBtn];
    
    self.navigationItem.rightBarButtonItem=rightItem;
    
    
    
    self.view.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.view.backgroundColor = ColorBackGround;
    
    
    _accountField=[[LCCustomTextField alloc] initWithFrame:CGRectMake(0.0f,5.0f,ScreenWidth,50)];
    _accountField.placeholder = ESLocalizedString(@"请输入手机号码");
    _accountField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _accountField.font=[UIFont systemFontOfSize:15.0f];
    _accountField.delegate=self;
    _accountField.returnKeyType=UIReturnKeySend;
    _accountField.keyboardType=UIKeyboardTypeNumberPad;
    [self.view addSubview:_accountField];
    
    _password=[[LCCustomTextField alloc] initWithFrame:CGRectMake(0.0f,_accountField.bottom+1.0f,ScreenWidth,50)];
    _password.placeholder = ESLocalizedString(@"请输入6到16位密码");
    _password.secureTextEntry = YES;
    _password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _password.font=[UIFont systemFontOfSize:15.0f];
    _password.delegate=self;
    _password.returnKeyType=UIReturnKeySend;
    [self.view addSubview:_password];
    
    _authCode =[[LCCustomTextField alloc] initWithFrame:CGRectMake(0.0f,self.password.bottom+5,ScreenWidth,50)];
    _authCode.placeholder = ESLocalizedString(@"请输入验证码");
    _authCode.secureTextEntry = NO;
    _authCode.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _authCode.font=[UIFont systemFontOfSize:20.0f];
    _authCode.delegate=self;
    _authCode.returnKeyType=UIReturnKeyDone;
    [self.view addSubview:_authCode];
    _authCode.keyboardType=UIKeyboardTypeNumberPad;
    
    
    UIImage * btnBgImg = [UIImage createImageWithColor:ColorPink];
    _getAuthCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_getAuthCodeBtn setBackgroundImage:btnBgImg
                               forState:UIControlStateNormal];
    [_getAuthCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_getAuthCodeBtn.layer setMasksToBounds:YES];
    [_getAuthCodeBtn.layer setCornerRadius:3.0]; //设置矩形四个圆角半径
    
    
    _getAuthCodeBtn.frame=CGRectMake(ScreenWidth - 160, self.password.bottom +12.0f,150,36);
    [_getAuthCodeBtn setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateNormal];
    [_getAuthCodeBtn setTitle:ESLocalizedString(@"获取验证码")
                     forState:UIControlStateNormal];
    
    [_getAuthCodeBtn addTarget:self
                        action:@selector(againSendIdentifyingCode)
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_getAuthCodeBtn];
    
    
    LCInsetsLabel *sectionFooterLabel=[[LCInsetsLabel alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,50) andInsets:UIEdgeInsetsMake(3,12,0,12)];
    
    sectionFooterLabel.top=_authCode.bottom+10;
    sectionFooterLabel.textAlignment = NSTextAlignmentCenter;
    sectionFooterLabel.textColor=[UIColor grayColor];
    sectionFooterLabel.font=[UIFont systemFontOfSize:16];
    sectionFooterLabel.backgroundColor =[UIColor clearColor];
    sectionFooterLabel.numberOfLines = 0;
    
    NSString *labelString=ESLocalizedString(@"为保护你的账号安全，请勿设置过于简单的密码，我们不会在任何地方泄露你的手机号码");
    
    NSDictionary *attrs = @{NSFontAttributeName : sectionFooterLabel.font};
    CGSize size = [labelString boundingRectWithSize:CGSizeMake(sectionFooterLabel.width-sectionFooterLabel.insets.left*2, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
    sectionFooterLabel.height = size.height+12;
    sectionFooterLabel.text = labelString;
    [self.view addSubview:sectionFooterLabel];
}

- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightAction
{
    //参数判断
    if(![[LCCore globalCore] isValidateMobile:self.accountField.text])
    {
        [[LCCore globalCore] shakeView:self.accountField];
        return;
    }
    
    if([_password.text length]<6||[_password.text length]>16)
    {
        [[LCCore globalCore] shakeView:self.accountField];
        return;
    }
    
    if([_authCode.text length] != 4)
    {
        [[LCCore globalCore] shakeView:self.authCode];
        return;
    }
    [_accountField resignFirstResponder];
    [_password resignFirstResponder];
    [_authCode resignFirstResponder];
    
    if(_Loading)
        return;
    
    _Loading=YES;
    
    [self registerToSever];
    
}

-(void)againSendIdentifyingCode
{
    [self requestVerifying];
}

-(void)showVerify
{
    self.rightItemBtn.userInteractionEnabled=YES;
    //self.authBtn.userInteractionEnabled=YES;
    
    //_againBtn.userInteractionEnabled=NO;
    [self setMessageText];
    
    [self fireMyTimer];
}

-(void)fireMyTimer
{
    
    if(!self.myTimer)
    {
        self.myTimer=[NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(countDown)
                                                    userInfo:nil
                                                     repeats:YES];
        
    }
    
    [self.myTimer fire];
}


-(void)countDown
{
    if(_phoneTimeCounter<=0)
    {
        [self.myTimer invalidate];
        self.myTimer=nil;
        [self.getAuthCodeBtn setTitle:ESLocalizedString(@"获取验证码")
                             forState:UIControlStateNormal];
        self.rightItemBtn.userInteractionEnabled=YES;
        //self.authBtn.userInteractionEnabled=NO;
        self.getAuthCodeBtn.userInteractionEnabled=YES;
        return;
    } else{
        
        [self.getAuthCodeBtn setTitle:[NSString stringWithFormat:@"%@(%d)", ESLocalizedString(@"重新获取"),_phoneTimeCounter--]
                             forState:UIControlStateNormal];
    }
    
}


-(void)setMessageText
{
    //    [KFNoticeAlertView showMsg:@"短信发送成功！"];
    //    NSString *msg=[NSString stringWithFormat:@"<font size=15 color='#aba9a9'>验证短信已经发送至</font><font size=15 color='#f61aaa'>+86 %@</font>",[LCSet mineSet].account];
    //    [self.message setText:msg];
}


-(void)startRequestCode
{
    [LCNoticeAlertView showMsg: ESLocalizedString(@"正在请求服务器验证，请稍后...")];
    [self.getAuthCodeBtn setTitle:ESLocalizedString(@"验证码获取中")
                         forState:UIControlStateNormal];
    self.rightItemBtn.userInteractionEnabled=NO;
    self.getAuthCodeBtn.userInteractionEnabled=NO;
    
}

-(void)failedRequest
{
    [self.getAuthCodeBtn setTitle:ESLocalizedString(@"重新获取验证码")
                         forState:UIControlStateNormal];
    self.getAuthCodeBtn.userInteractionEnabled=YES;
}

-(void)requestVerifying
{
    if(![[LCCore globalCore] isValidateMobile:self.accountField.text])
    {
        [[LCCore globalCore] shakeView:self.accountField];
        return;
    }
    
    
    [self startRequestCode];
    ESWeakSelf;
//    [[Business sharedInstance] requestParameters:@{
//                                                   @"area":@"086",
//                                                   @"phone" : _accountField.text,
//                                                   @"udid" : [UIDevice openUDID]
//                                                   } withRequestUrl:URL_LIVE_PHONE_SENDSMS withRequestStat:POST_REQUEST succ:^(NSString *msg, id data) {
//                                                       NSLog(@"requestVerifying result = %@",data);
//                                                       ESStrongSelf;
//                                                       int stat=[data[@"stat"] intValue];
//                                                       if(stat == URL_REQUEST_SUCCESS)
//                                                       {
//                                                           self.phoneTimeCounter=60;
//                                                           [_self showVerify];
//                                                       }
//                                                       else
//                                                       {
//                                                           [LCNoticeAlertView showMsg:msg];
//                                                           [_self failedRequest];
//                                                       }
//                                                   } fail:^(NSString *error) {
//                                                       ESStrongSelf;
//                                                       [LCNoticeAlertView showMsg:error];
//                                                       [_self failedRequest];
//                                                   }];
    
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        NSLog(@"requestVerifying result = %@",responseDic);
        ESStrongSelf;
        int stat=[responseDic[@"stat"] intValue];
        if(stat == URL_REQUEST_SUCCESS)
        {
            self.phoneTimeCounter=60;
            [_self showVerify];
        }
        else
        {
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
            [_self failedRequest];
        }
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        ESStrongSelf;
        [LCNoticeAlertView showMsg:ESLocalizedString(@"请求失败！")];
        [_self failedRequest];
    };
    
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{
                                                             @"area":@"086",
                                                             @"phone" : _accountField.text,
                                                             @"udid" : [UIDevice openUDID]
                                                             }
                                                  withPath:URL_LIVE_PHONE_SENDSMS
                                               withRESTful:POST_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}


-(void)registerToSever
{
    NSDictionary *parameters = @{
                                 @"area":@"086",
                                 @"account" : _accountField.text,
                                 @"pwd" : [_password.text es_md5HashString],
                                 @"udid":[UIDevice openUDID],
                                 @"code":_authCode.text
                                 };
    ESWeakSelf;
//    [[Business sharedInstance] requestParameters:parameters withRequestUrl:URL_LIVE_PHONE_REG withRequestStat:POST_REQUEST succ:^(NSString *msg, id data) {
//        ESStrongSelf;
//        NSLog(@"reg phone result = %@",data);
//        int stat=[data[@"stat"] intValue];
//        if(stat ==200)
//        {
//            
//            [[LCMyUser mine] fillWithDictionary:data[@"userinfo"]];
//            [[LCMyUser mine] save];
//            
//            LCRegDoneController *regSecondViewController =
//            [[LCRegDoneController alloc] initWithStyle:UITableViewStyleGrouped hasRefreshControl:NO];
//            
//            [self.navigationController pushViewController:regSecondViewController animated:YES];
//        }
//        else
//        {
//            [LCNoticeAlertView showMsg:msg];
//        }
//        
//        _self.Loading=NO;
//        
//    } fail:^(NSString *error) {
//        ESStrongSelf;
//        _self.Loading=NO;
//        [LCNoticeAlertView showMsg:error];
//    }];
    
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        ESStrongSelf;
        NSLog(@"reg phone result = %@",responseDic);
        int stat=[responseDic[@"stat"] intValue];
        if(stat == URL_REQUEST_SUCCESS)
        {
            [[LCMyUser mine] fillWithDictionary:responseDic[@"userinfo"]]; 
            [[LCMyUser mine] save];
            
            LCRegDoneController *regSecondViewController =
            [[LCRegDoneController alloc] initWithStyle:UITableViewStyleGrouped hasRefreshControl:NO];
            
            [self.navigationController pushViewController:regSecondViewController animated:YES];
        }
        else
        {
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
        
        _self.Loading=NO;
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        ESStrongSelf;
        [LCNoticeAlertView showMsg:ESLocalizedString(@"请求失败！")];
        _self.Loading=NO;
    };
    
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameters
                                                  withPath:URL_LIVE_PHONE_REG
                                               withRESTful:POST_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
