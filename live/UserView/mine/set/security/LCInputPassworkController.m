//
//  LCInputPassworkController.m
//  XCLive
//
//  Created by ztkztk on 14-4-28.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCInputPassworkController.h"

#import "LCLoginAndExitRequest.h"

#import "LCAuthPhoneViewController.h"
#import "LCEnterEmailViewController.h"
#import "LCAuthEmailViewController.h"
#import "LCEnterPhoneViewController.h"

@interface LCInputPassworkController ()

@end

@implementation LCInputPassworkController

+(id)inputPasswordViewWithAuthType:(LCAuthType)authType
{
    LCInputPassworkController *viewController=[[LCInputPassworkController alloc] init];
    viewController.authType=authType;
    return viewController;
    
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
    
    self.navigationItem.rightBarButtonItem.customView.hidden=NO;
    
    self.title=LCIThinkName(_authType);
    
    self.inputText.placeholder = @"请输入有美直播登录密码";
    self.inputText.secureTextEntry = YES;
    
    
    // Do any additional setup after loading the view.
}


-(void)rightAction
{
//    [self.inputText resignFirstResponder];
//    
//    if(self.inputText.text && [LCSet mineSet].account)
//    {
//        ESWeakSelf;
//        NSDictionary *loginDic=@{@"account":[LCSet mineSet].account,@"pwd":[self.inputText.text es_md5Hash]};
//        [LCLoginAndExitRequest login:loginDic
//                    withBlock:^(NSDictionary *dic){
//                        //跳转页面：
//                        ESStrongSelf;
//                        [_self pushNextViewController];
//                    }];
//
//    }
    
}

-(void)pushNextViewController
{
    if(_authType == LCAuthPhone)
    {
        LCAuthPhoneViewController *authController=[[LCAuthPhoneViewController alloc] init];
        [self.navigationController pushViewController:authController animated:YES];
    }else if(_authType == LCAuthChangePhone)
    {
        LCEnterPhoneViewController *enterController=[[LCEnterPhoneViewController alloc] init];
        [self.navigationController pushViewController:enterController animated:YES];
        
    }else if(_authType == LCAuthEmail)
    {
        LCAuthEmailViewController *authEmailController=[[LCAuthEmailViewController alloc] init];
        [self.navigationController pushViewController:authEmailController animated:YES];
    }
    else if(_authType == LCAuthChangeEmail)
    {
        LCEnterEmailViewController *enterEmailController=[[LCEnterEmailViewController alloc] init];
        [self.navigationController pushViewController:enterEmailController animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark login request

#pragma mark 
@end
