//
//  LCAuthEmailViewController.m
//  XCLive
//
//  Created by ztkztk on 14-4-28.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCAuthEmailViewController.h"
#import "LCEmailViewController.h"
#import "LCAuthEmailViewController+Email.h"

@interface LCAuthEmailViewController ()

@end

@implementation LCAuthEmailViewController

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
    
    self.title=@"绑定邮箱";
    self.message.height=self.message.height*2;
    
    self.navigationItem.rightBarButtonItem.customView.hidden=YES;
    
    
    self.againBtn.top=self.message.bottom+5;
    self.authBtn.top=self.againBtn.bottom+5;
    
    [self.authBtn setTitle:@"登录邮箱"
                  forState:UIControlStateNormal];
    
    
    [self.againBtn setTitle:@"邮箱认证"
                   forState:UIControlStateNormal];
    
    //self.authBtn.hidden=YES;
    
    
    
    
//    self.emailSeverUrl=[[LCSet mineSet].email getEmailAddress];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(emailAuthSuccess)
                                                 name:NotificationMsg_EmailAuthSuccess
                                               object:nil];

    

}


-(void)emailAuthSuccess
{
    [LCNoticeAlertView showMsg:@"邮箱激活成功"];
    
    [self backAction];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    int timeIntervalLast=[self timeIntervalSinceLastTime];
    if(timeIntervalLast>60)
    {
        [self requestVerifying];
        
    }else{
        
        _emailTimeCounter=60-timeIntervalLast;
        [self showVerify];
    }
    
}


-(void)saveEmailAuthTime
{
    NSDate *currentDate =[NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:currentDate forKey:@"EmailAuthTime"];
    
}

-(int)timeIntervalSinceLastTime
{
    NSDate *currentDate =[NSDate date];
    NSDate *LastTime= [[NSUserDefaults standardUserDefaults] objectForKey:@"EmailAuthTime"];
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
    [self setLandEmailHidden:NO];
    //self.authBtn.hidden=NO;
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

-(void)setLandEmailHidden:(BOOL)hidden
{
    if(self.emailSeverUrl)
    {
        //self.authBtn.hidden=hidden;
        
        self.authBtn.hidden=NO;
    }
}

-(void)countDown
{
    
    if(self.emailTimeCounter<0)
    {
        [self.myTimer invalidate];
        self.myTimer=nil;
        [self.againBtn setTitle:@"重新发送验证邮件"
                       forState:UIControlStateNormal];
        self.rightItemBtn.userInteractionEnabled=NO;
        //self.authBtn.hidden=YES;
        
        [self setLandEmailHidden:YES];
        self.againBtn.userInteractionEnabled=YES;
        return;
    }
    [self.againBtn setTitle:[NSString stringWithFormat:@"重新发送验证邮箱(%d)",self.emailTimeCounter--]
                   forState:UIControlStateNormal];
}


-(void)setMessageText
{
    
//    NSString *msg=[NSString stringWithFormat:@"<font size=15 color='#aba9a9'>验证邮件已发送至</font><font size=15 color='#f61aaa'>%@</font><font size=15 color='#aba9a9'>请前往邮箱进行验证，验证后点击完成。</font>",[LCSet mineSet].email];
//    [self.message setText:msg];
}



-(void)rightAction
{
   // [self landEmail];
    
   // [self openEmailWithAddress:[LCSet mineSet].email];
    
    
    if(self.emailSeverUrl)
    {
        LCEmailViewController *emailController=[LCEmailViewController loadEmailWithAddress:self.emailSeverUrl];
        [self.navigationController pushViewController:emailController animated:YES];
    }
}

-(void)startRequestCode
{
    [super startRequestCode];
    [self.message setText:@"正在请求服务器验证，请稍后..."];
    [self.againBtn setTitle:@"请求服务器中..."
                   forState:UIControlStateNormal];
    //self.authBtn.hidden=YES;
    
    [self setLandEmailHidden:YES];
    self.rightItemBtn.userInteractionEnabled=NO;
    self.againBtn.userInteractionEnabled=NO;
    
}


-(void)failedRequest
{
    [super failedRequest];
    [self.message setText:@"验证邮件发送失败, 请重新发送"];
    [self.againBtn setTitle:@"重新发送验证邮件"
                   forState:UIControlStateNormal];
    self.againBtn.userInteractionEnabled=YES;
    
}

-(void)requestVerifying
{
    
//    [self startRequestCode];
//    ESWeakSelf;
//    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
//        ESStrongSelf;
//        NSLog(@"gagresponseDic=%@",responseDic);
//        int stat=[responseDic[@"stat"] intValue];
//        if(stat==200)
//        {
//            _self.emailTimeCounter=60;
//            [_self saveEmailAuthTime];
//            [_self showVerify];
//            
//            if(!_self.emailSeverUrl)
//                [LCNoticeAlertView showMsg:@"请前往邮箱激活"];
//                
//        }
//        else{
//            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
//            [_self failedRequest];
//            
//        }
//        
//    };
//    
//    LCRequestFailResponseBlock failBlock=^(NSError *error){
//        NSLog(@"gagerror=%@",error);
//        ESStrongSelf;
//        [LCNoticeAlertView showMsg:@"请检查网络状态"];
//        [_self failedRequest];
//    };
//    
//    //NSDictionary *dic=@{@"phone":@"18621759057"};
//    [[LCHTTPClient sharedHTTPClient] requestWithParameters:nil
//                                                  withPath:requestVerifyEmailURL()
//                                               withRESTful:GET_REQUEST
//                                          withSuccessBlock:successBlock
//                                             withFailBlock:failBlock];
    
}


-(void)landEmail
{
//    
//    /*
//    LCEmailViewController *emailController=[[LCEmailViewController alloc] init];
//    [self.navigationController pushViewController:emailController animated:YES];
//     */
//    NSString *recipients =[NSString stringWithFormat:@"mailto:%@",[LCSet mineSet].email];
//    NSString *email =recipients;
//    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
    
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
