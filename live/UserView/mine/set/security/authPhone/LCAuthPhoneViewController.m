//
//  LCAuthPhoneViewController.m
//  XCLive
//
//  Created by ztkztk on 14-4-26.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCAuthPhoneViewController.h"
#import "LCAuthPhoneViewController+NetWork.h"

#import "LCSecurityViewController.h"


@interface LCAuthPhoneViewController ()

@end

@implementation LCAuthPhoneViewController


-(void)dealloc
{
//    [[LCHTTPClient sharedHTTPClient] cancelAllHTTPOperationsWithMethod:nil path:requestVerifyingCodeURL()];
//    [[LCHTTPClient sharedHTTPClient] cancelAllHTTPOperationsWithMethod:nil path:verifyPhoneURL()];
    
}



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
    self.title=@"手机号验证";
    
    _codeText=[[LCCustomTextField alloc] initWithFrame:CGRectMake(0.0f,self.message.bottom+5,ScreenWidth,40)];
    _codeText.placeholder = @"请输入验证码";
    _codeText.secureTextEntry = NO;
    _codeText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _codeText.font=[UIFont systemFontOfSize:20.0f];
    _codeText.delegate=self;
    _codeText.returnKeyType=UIReturnKeyDone;
    [self.view addSubview:_codeText];
    _codeText.keyboardType=UIKeyboardTypeNumberPad;
       
    self.againBtn.top=_codeText.bottom+10;
    self.authBtn.top=self.againBtn.bottom+5;
    
    [self.authBtn setTitle:@"绑定手机号"
              forState:UIControlStateNormal];
    
    
    [self.againBtn setTitle:@"获取验证码"
                   forState:UIControlStateNormal];
    
    //[self requestVerifying];
    
    
        
    
  
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    int timeIntervalLast=[self timeIntervalSinceLastTime];
    if(timeIntervalLast>60)
    {
        [self requestVerifying];
        
    }else{
        
        _phoneTimeCounter=60-timeIntervalLast;
        [self showVerify];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
   
}


-(void)savePhoneCodeTime
{
    NSDate *currentDate =[NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:currentDate forKey:@"PhoneCodeTime"];
    
}

-(int)timeIntervalSinceLastTime
{
    NSDate *currentDate =[NSDate date];
    
    NSDate *LastTime= [[NSUserDefaults standardUserDefaults] objectForKey:@"PhoneCodeTime"];
    
    
    int timeInterval;
    if(LastTime)
        timeInterval=(int)[currentDate timeIntervalSinceDate:LastTime];
    else{
        timeInterval=61;
    }
    
    return timeInterval;
}



-(void)showVerify
{
    self.rightItemBtn.userInteractionEnabled=YES;
    //self.authBtn.userInteractionEnabled=YES;
    
    self.authBtn.hidden=NO;
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
    if(_phoneTimeCounter<0)
    {
        [self.myTimer invalidate];
        self.myTimer=nil;
        [self.againBtn setTitle:@"重新获取验证码"
                   forState:UIControlStateNormal];
        self.rightItemBtn.userInteractionEnabled=YES;
        //self.authBtn.userInteractionEnabled=NO;
        
        self.authBtn.hidden=YES;
        self.againBtn.userInteractionEnabled=YES;
        return;
    }
    [self.againBtn setTitle:[NSString stringWithFormat:@"重新获取验证码(%d)",_phoneTimeCounter--]
               forState:UIControlStateNormal];
}


-(void)setMessageText
{
//    NSString *msg=[NSString stringWithFormat:@"<font size=15 color='#aba9a9'>验证短信已经发送至</font><font size=15 color='#f61aaa'>+86 %@</font>",[LCSet mineSet].account];
//    [self.message setText:msg];
}



-(void)rightAction
{
    
    
    if(self.codeText.text&&[self.codeText.text length]>0)
    {
        NSDictionary *code=@{@"code":self.codeText.text};
        [self verifyingPhone:code];
    }else{
        [LCNoticeAlertView showMsg:@"请输入手机验证码"];
    }
       
}

-(void)startRequestCode
{
    [super startRequestCode];
    [self.message setText:@"正在请求服务器验证，请稍后..."];
    [self.againBtn setTitle:@"验证码获取中"
               forState:UIControlStateNormal];
    self.rightItemBtn.userInteractionEnabled=NO;
    self.authBtn.hidden=YES;
    self.againBtn.userInteractionEnabled=NO;
    
}


-(void)failedRequest
{
    [super failedRequest];
    [self.message setText:@"获取验证码失败, 请重新获取..."];
    [self.againBtn setTitle:@"重新获取验证码"
               forState:UIControlStateNormal];
    self.againBtn.userInteractionEnabled=YES;
    
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
