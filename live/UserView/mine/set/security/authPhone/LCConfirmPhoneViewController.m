//
//  LCConfirmViewController.m
//  XCLive
//
//  Created by ztkztk on 14-4-28.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCConfirmPhoneViewController.h"
#import "LCAuthPhoneViewController.h"
#import "LCEnterPhoneViewController.h"

@interface LCConfirmPhoneViewController ()

@end

@implementation LCConfirmPhoneViewController

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
    
    
    
    self.introLabel.text=@"绑定手机号码可用于登录有美直播及取回密码；未经允许，有美直播将不会在任何地方泄露您的手机号码及其他个人信息。";
    
    
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self customUpdateView];
}

-(void)customUpdateView
{
//    if([LCSet mineSet].phone_auth)
//    {
//        //已经绑定邮箱
//        [self.changeBtn setTitle:@"更改手机号"
//                        forState:UIControlStateNormal];
//        
//        [self.changeBtn addTarget:self
//                           action:@selector(change)
//                 forControlEvents:UIControlEventTouchUpInside];
//        self.confirmBtn.hidden=YES;
//        
//    }else{
//        
//        //有邮箱 未认证
//        [self.confirmBtn setTitle:@"验证手机"
//                         forState:UIControlStateNormal];
//        
//        [self.confirmBtn addTarget:self
//                            action:@selector(confirmAuth)
//                  forControlEvents:UIControlEventTouchUpInside];
//        
//        [self.changeBtn setTitle:@"更改手机号"
//                        forState:UIControlStateNormal];
//        [self.changeBtn addTarget:self
//                           action:@selector(change)
//                 forControlEvents:UIControlEventTouchUpInside];
//        
//    }

}

-(void)confirmAuth
{
//    if (ESIsStringWithAnyText([LCSet mineSet].openID))
//    {
//        [self pushNextViewController:LCAuthChangePhone];
//    }
//    else
//    {
//        LCInputPassworkController *passwordController=[LCInputPassworkController inputPasswordViewWithAuthType:LCAuthPhone];
//        [self.navigationController pushViewController:passwordController animated:YES];
//    }

}

-(void)change
{
//    if (ESIsStringWithAnyText([LCSet mineSet].openID)) {
//        [self pushNextViewController:LCAuthChangePhone];
//    }
//    else
//    {
//        LCInputPassworkController *passwordController=[LCInputPassworkController inputPasswordViewWithAuthType:LCAuthChangePhone];
//        [self.navigationController pushViewController:passwordController animated:YES];
//    }
}


-(void)pushNextViewController:(LCAuthType) authType
{
    if(authType == LCAuthPhone)
    {
        LCAuthPhoneViewController *authController=[[LCAuthPhoneViewController alloc] init];
        [self.navigationController pushViewController:authController animated:YES];
    }else if(authType == LCAuthChangePhone)
    {
        LCEnterPhoneViewController *enterController=[[LCEnterPhoneViewController alloc] init];
        [self.navigationController pushViewController:enterController animated:YES];
        
    }
    
    //    else if(_authType == LCAuthEmail)
    //    {
    //        LCAuthEmailViewController *authEmailController=[[LCAuthEmailViewController alloc] init];
    //        [self.navigationController pushViewController:authEmailController animated:YES];
    //    }
    //    else if(_authType == LCAuthChangeEmail)
    //    {
    //        LCEnterEmailViewController *enterEmailController=[[LCEnterEmailViewController alloc] init];
    //        [self.navigationController pushViewController:enterEmailController animated:YES];
    //    }
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
