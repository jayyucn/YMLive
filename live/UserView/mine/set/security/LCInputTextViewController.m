//
//  LCInputTextViewController.m
//  XCLive
//
//  Created by ztkztk on 14-4-28.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCInputTextViewController.h"

@interface LCInputTextViewController ()

@end

@implementation LCInputTextViewController

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
    _inputText=[[UITextField alloc] initWithFrame:CGRectMake(20.0f,30,280,30)];
    
    _inputText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _inputText.font=[UIFont systemFontOfSize:20.0f];
    _inputText.delegate=self;
    _inputText.returnKeyType=UIReturnKeyDone;
    [self.view addSubview:_inputText];
    
    [_inputText becomeFirstResponder];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self rightAction];
    return YES;
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
