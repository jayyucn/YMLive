//
//  LCConFirmEmailViewController.m
//  XCLive
//
//  Created by ztkztk on 14-4-28.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCConFirmEmailViewController.h"
#import "LCEnterEmailViewController.h"
#import "LCAuthEmailViewController.h"

@interface LCConFirmEmailViewController ()

@end

@implementation LCConFirmEmailViewController

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
    
    
    self.introLabel.text=@"邮箱绑定账号可用于登录有美直播及取回密码；未经允许，有美直播将不会在任何地方泄露您的邮箱账号及其他个人信息。";

    
    
    [self customUpdateView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(emailAuthSuccess)
                                                 name:NotificationMsg_EmailAuthSuccess
                                               object:nil];

 
}


-(void)emailAuthSuccess
{
    [self customUpdateView];
}

-(void)customUpdateView
{
//    
//    
//    if([LCSet mineSet].email_auth)
//    {
//        //已经绑定邮箱
//        [self.confirmBtn setTitle:@"更换邮箱"
//                         forState:UIControlStateNormal];
//        
//        [self.confirmBtn addTarget:self
//                            action:@selector(change)
//                  forControlEvents:UIControlEventTouchUpInside];
//        self.changeBtn.hidden=YES;
//        
//    }else{
//        
//        if([[LCSet mineSet].email isEqualToString:@""])
//        {
//            //未绑定
//            [self.confirmBtn setTitle:@"绑定邮箱"
//                             forState:UIControlStateNormal];
//            
//            [self.confirmBtn addTarget:self
//                                action:@selector(change)
//                      forControlEvents:UIControlEventTouchUpInside];
//            self.changeBtn.hidden=YES;
//            
//            
//            
//        }else
//        {
//            //有邮箱 未认证
//            [self.confirmBtn setTitle:@"验证邮箱"
//                             forState:UIControlStateNormal];
//            
//            [self.confirmBtn addTarget:self
//                                action:@selector(confirmAuth)
//                      forControlEvents:UIControlEventTouchUpInside];
//            
//            [self.changeBtn setTitle:@"更换邮箱"
//                            forState:UIControlStateNormal];
//            [self.changeBtn addTarget:self
//                               action:@selector(change)
//                     forControlEvents:UIControlEventTouchUpInside];
//            
//            
//        }
//        
//    }
//
    
}



-(void)confirmAuth
{
//    if (ESIsStringWithAnyText([LCSet mineSet].openID))
//    {
//        [self pushNextViewController:LCAuthEmail];
//    }
//    else
//    {
//        LCInputPassworkController *passwordController=[LCInputPassworkController inputPasswordViewWithAuthType:LCAuthEmail];
//        [self.navigationController pushViewController:passwordController animated:YES];
//    }
}

-(void)change
{
//    if (ESIsStringWithAnyText([LCSet mineSet].openID))
//    {
//        [self pushNextViewController:LCAuthChangeEmail];
//    }
//    else
//    {
//        LCInputPassworkController *passwordController=[LCInputPassworkController inputPasswordViewWithAuthType:LCAuthChangeEmail];
//        [self.navigationController pushViewController:passwordController animated:YES];
//    }
    
}

-(void)pushNextViewController:(LCAuthType) authType
{
        if(authType == LCAuthEmail)
        {
            LCAuthEmailViewController *authEmailController=[[LCAuthEmailViewController alloc] init];
            [self.navigationController pushViewController:authEmailController animated:YES];
        }
        else if(authType == LCAuthChangeEmail)
        {
            LCEnterEmailViewController *enterEmailController=[[LCEnterEmailViewController alloc] init];
            [self.navigationController pushViewController:enterEmailController animated:YES];
        }
}

@end
