//
//  KFResetPwdVC.m
//  CaoLiu
//
//  Created by jacklong on 15/9/15.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import "KFResetPwdVC.h"
#import "LCCore.h"

#import "LCNoticeAlertView.h"

@interface KFResetPwdVC ()

@end

@implementation KFResetPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"重置密码";
    
    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    
    
    self.view.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    
    _accountField=[[LCCustomTextField alloc] initWithFrame:CGRectMake(0.0f,5.0f,ScreenWidth,50)];
    _accountField.placeholder = @"请输入手机号码";
    _accountField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _accountField.font=[UIFont systemFontOfSize:15.0f];
    _accountField.delegate=self;
    _accountField.returnKeyType=UIReturnKeySend;
    _accountField.keyboardType=UIKeyboardTypeNumberPad;
    [self.view addSubview:_accountField];
    
    _password=[[LCCustomTextField alloc] initWithFrame:CGRectMake(0.0f,_accountField.bottom+1.0f,ScreenWidth,50)];
    _password.placeholder = @"设置密码(6-16位数字或英文)";
    _password.secureTextEntry = YES;
    _password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _password.font=[UIFont systemFontOfSize:15.0f];
    _password.delegate=self;
    _password.returnKeyType=UIReturnKeySend;
    [self.view addSubview:_password];
    
    _authCode =[[LCCustomTextField alloc] initWithFrame:CGRectMake(0.0f,self.password.bottom+5,ScreenWidth,50)];
    _authCode.placeholder = @"请输入验证码";
    _authCode.secureTextEntry = NO;
    _authCode.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _authCode.font=[UIFont systemFontOfSize:20.0f];
    _authCode.delegate=self;
    _authCode.returnKeyType=UIReturnKeyDone;
    [self.view addSubview:_authCode];
    _authCode.keyboardType=UIKeyboardTypeNumberPad;
    
    
    UIImage * btnBgImg = [UIImage createImageWithColor:ColorPink];
    _getAuthCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //        _sendBtn.backgroundColor = UIColorFromRGB(248, 113, 198);
    
    [_getAuthCodeBtn setBackgroundImage:btnBgImg
                         forState:UIControlStateNormal];
    [_getAuthCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_getAuthCodeBtn.layer setMasksToBounds:YES];
    [_getAuthCodeBtn.layer setCornerRadius:3.0]; //设置矩形四个圆角半径
    
    _getAuthCodeBtn.frame=CGRectMake(ScreenWidth - 160, self.password.bottom +12.0f,150,36);
    [_getAuthCodeBtn setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateNormal];
    [_getAuthCodeBtn setTitle:@"获取验证码"
                     forState:UIControlStateNormal];
    
    [_getAuthCodeBtn addTarget:self
                        action:@selector(againSendIdentifyingCode)
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_getAuthCodeBtn];
    
    _resetPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //        _sendBtn.backgroundColor = UIColorFromRGB(248, 113, 198);
    
    [_resetPwdBtn setBackgroundImage:btnBgImg
                               forState:UIControlStateNormal];
    [_resetPwdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_resetPwdBtn.layer setMasksToBounds:YES];
    [_resetPwdBtn.layer setCornerRadius:3.0]; //设置矩形四个圆角半径
     
    _resetPwdBtn.frame=CGRectMake(10, self.authCode.bottom +10.0f,ScreenWidth - 20,36);
    [_resetPwdBtn setTitleColor:[UIColor whiteColor]
                    forState:UIControlStateNormal];
    [_resetPwdBtn setTitle:@"重置密码"
               forState:UIControlStateNormal];
    
    [_resetPwdBtn addTarget:self
                  action:@selector(resetPwdAction)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_resetPwdBtn];
    
}


- (void)leftAction
{
    [LCCore presentLandController];
}

-(void)resetPwdAction
{
    //参数判断
    if(![[LCCore globalCore] isValidateMobile:self.accountField.text])
    {
        [[LCCore globalCore] shakeView:self.accountField];
        return;
    }
    

    
    if([_password.text length]<6||[_password.text length]>16)
    {
        [[LCCore globalCore] shakeView:self.password];
        return;
    }
    
    if([_authCode.text length] != 4){
        [[LCCore globalCore] shakeView:self.authCode];
        return;
    }
    
    [_accountField resignFirstResponder];
    [_password resignFirstResponder];
    [_authCode resignFirstResponder];
    
    if(_Loading)
        return;
    
    _Loading=YES;
    
    [self resetPwdReq];
    
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
        [self.getAuthCodeBtn setTitle:@"获取验证码"
                             forState:UIControlStateNormal];
        self.rightItemBtn.userInteractionEnabled=YES;
        //self.authBtn.userInteractionEnabled=NO;
        self.getAuthCodeBtn.userInteractionEnabled=YES;
        return;
    } else{
        
        [self.getAuthCodeBtn setTitle:[NSString stringWithFormat:@"重新获取(%d)",_phoneTimeCounter--]
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
    [self.getAuthCodeBtn setTitle:@"验证码获取中"
                         forState:UIControlStateNormal];
    self.rightItemBtn.userInteractionEnabled=NO;
    self.getAuthCodeBtn.userInteractionEnabled=NO;
    
}

-(void)failedRequest
{
    [self.getAuthCodeBtn setTitle:@"获取验证码"
                         forState:UIControlStateNormal];
    self.getAuthCodeBtn.userInteractionEnabled=YES;
}

-(void)requestVerifying
{
    //参数判断
    if(![[LCCore globalCore] isValidateMobile:self.accountField.text])
    {
        [[LCCore globalCore] shakeView:self.accountField];
        return;
    }
    
    [self startRequestCode];
    ESWeakSelf
//    [[Business sharedInstance] requestParameters:@{
//                                                   @"area":@"086",
//                                                   @"phone" : _accountField.text,
//                                                   @"udid" : [UIDevice openUDID]
//                                                   }
//                                  withRequestUrl:URL_LIVE_FIND_PWD_RESET_SENDSMS withRequestStat:POST_REQUEST succ:^(NSString *msg, id data) {
//                                      NSLog(@"requestVerifying responseDic=%@",data);
//                                      ESStrongSelf
//                                      int stat=[data[@"stat"] intValue];
//                                      if(stat==200)
//                                      {
//                                          self.phoneTimeCounter=60;
//                                          
//                                          [_self showVerify];
//                                      }
//                                      else
//                                      {
//                                          [LCNoticeAlertView showMsg:msg];
//                                          [_self failedRequest];
//                                      }
//                                  } fail:^(NSString *error) {
//                                      ESStrongSelf;
//                                      [LCNoticeAlertView showMsg:error];
//                                      [_self failedRequest];
//                                  }];
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        NSLog(@"requestVerifying responseDic=%@",responseDic);
        ESStrongSelf
        int stat=[responseDic[@"stat"] intValue];
        if(stat==200)
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
        [LCNoticeAlertView showMsg:@"请求数据失败！"];
        [_self failedRequest];
    };
    
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{
                                                             @"area":@"086",
                                                             @"phone" : _accountField.text,
                                                             @"udid" : [UIDevice openUDID]
                                                             }
                                                  withPath:URL_LIVE_FIND_PWD_RESET_SENDSMS
                                               withRESTful:POST_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
    
}

//-(void)savePhoneCodeTime
//{
//    NSDate *currentDate =[NSDate date];
//    [[NSUserDefaults standardUserDefaults] setObject:currentDate forKey:@"PhoneCodeTime"];
//
//}
//
//-(int)timeIntervalSinceLastTime
//{
//    NSDate *currentDate =[NSDate date];
//
//    NSDate *LastTime= [[NSUserDefaults standardUserDefaults] objectForKey:@"PhoneCodeTime"];
//
//
//    int timeInterval;
//    if(LastTime)
//        timeInterval=(int)[currentDate timeIntervalSinceDate:LastTime];
//    else{
//        timeInterval=0;
//    }
//
//    return timeInterval;
//}


-(void)resetPwdReq
{
    
    
   
    
    NSDictionary *parameters = @{
                                 @"area":@"086",
                                 @"account" : _accountField.text,
                                 @"pwd" :[self.password.text es_md5HashString],
                                 @"udid":[UIDevice openUDID],
                                 @"code":_authCode.text
                                 };
    ESWeakSelf;
//    [[Business sharedInstance] requestParameters:parameters withRequestUrl:URL_LIVE_FIND_PWD withRequestStat:POST_REQUEST succ:^(NSString *msg, id data) {
//        ESStrongSelf;
//        NSLog(@"reset pwd result %@",data);
//        int stat=[data[@"stat"] intValue];
//        if(stat == URL_REQUEST_SUCCESS)
//        {
//            [_self showResetPwdPrompt];
//        }
//        else
//        {
//            [LCNoticeAlertView showMsg:msg];
//        }
//        _self.Loading=NO;
//    } fail:^(NSString *error) {
//        NSLog(@"reset passowrd fail %@",error);
//        
//        ESStrongSelf;
//        _self.Loading=NO;
//    }];
    
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        ESStrongSelf;
        NSLog(@"reset pwd result %@",responseDic);
        int stat=[responseDic[@"stat"] intValue];
        if(stat == URL_REQUEST_SUCCESS)
        {
            [_self showResetPwdPrompt];
        }
        else
        {
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
        _self.Loading=NO;
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        [LCNoticeAlertView showMsg:@"请求数据失败！"];
        ESStrongSelf;
        _self.Loading=NO;
    };
    
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameters
                                                  withPath:URL_LIVE_FIND_PWD
                                               withRESTful:POST_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
    
}

-(void)showResetPwdPrompt{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒"
                                                    message:@"重置密码成功，请重新登录"
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    alert.delegate=self;
    alert.tag=3;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self leftAction];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    return YES;
}




@end
