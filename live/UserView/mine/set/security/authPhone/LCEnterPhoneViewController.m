//
//  LCEnterPhoneViewController.m
//  XCLive
//
//  Created by ztkztk on 14-4-29.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCEnterPhoneViewController.h"
#import "LCAuthPhoneViewController.h"




@interface LCEnterPhoneViewController ()

@end

@implementation LCEnterPhoneViewController

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
    self.title=@"手机号码";
    self.inputText.placeholder = @"请输入新的手机号码";
    self.inputText.keyboardType=UIKeyboardTypeNumberPad;
       
}




-(void)rightAction
{
    [self.inputText resignFirstResponder];
    
    if(self.inputText.text)
    {
        [self requestModify:@{@"account":self.inputText.text}];
    }
    
}


-(void)nextAction
{
    LCAuthPhoneViewController *authController=[[LCAuthPhoneViewController alloc] init];
    [self.navigationController pushViewController:authController animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
