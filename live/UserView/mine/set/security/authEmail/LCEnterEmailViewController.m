//
//  LCEnterEmailViewController.m
//  XCLive
//
//  Created by ztkztk on 14-4-28.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCEnterEmailViewController.h"
#import "LCAuthEmailViewController.h"

@interface LCEnterEmailViewController ()

@end

@implementation LCEnterEmailViewController

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
    self.title=@"邮箱地址";
    self.inputText.placeholder = @"请输入邮箱地址";
    
    self.inputText.keyboardType=UIKeyboardTypeEmailAddress;
   
}


-(void)rightAction
{
    [self.inputText resignFirstResponder];
    
    if(self.inputText.text)
    {
        [self requestModify:@{@"email":self.inputText.text}];
    }
    
}


-(void)nextAction
{
     LCAuthEmailViewController *authController=[[LCAuthEmailViewController alloc] init];
    [self.navigationController pushViewController:authController animated:YES];
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
