//
//  LCAuthViewController.m
//  XCLive
//
//  Created by ztkztk on 14-4-28.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCAuthViewController.h"


@interface LCAuthViewController ()

@end

@implementation LCAuthViewController


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
    
    
    //self.navigationItem.rightBarButtonItem.customView.hidden=NO;
    [self setRightItemTitle:@"绑定"];
    
    _message = [[RTLabel alloc] initWithFrame:CGRectMake(20,20,ScreenWidth - 40,30)];
	//[label setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20]];
    [_message setParagraphReplacement:@""];
    //_message.lineSpacing = 3.0;
    [self.view addSubview:_message];
    // Do any additional setup after loading the view.
    
    // Custom initialization
    self.againBtn=[ESButton button];
    //_againBtn.buttonColor=ESButtonColorCoffee;
        _againBtn.color = ESButtonColorCoffee;
    
    _againBtn.frame=CGRectMake(10, 0,ScreenWidth - 20,40);
    [_againBtn setTitleColor:[UIColor whiteColor]
                    forState:UIControlStateNormal];
    
    [_againBtn addTarget:self
                  action:@selector(againSendIdentifyingCode)
        forControlEvents:UIControlEventTouchUpInside];
    _againBtn.userInteractionEnabled=NO;
    [self.view addSubview:_againBtn];
    
    
    // Custom initialization
    self.authBtn=[ESButton button];
    _authBtn.color=ESButtonColorBlue;
    _authBtn.frame=CGRectMake(10,_againBtn.bottom+5,ScreenWidth - 20,40);
    [_authBtn setTitleColor:[UIColor whiteColor]
                        forState:UIControlStateNormal];
    
    [_authBtn setTitle:@"登录邮箱"
                   forState:UIControlStateNormal];
    
    [_authBtn addTarget:self
                      action:@selector(rightAction)
            forControlEvents:UIControlEventTouchUpInside];
    _authBtn.userInteractionEnabled=YES;
    
    [self.view addSubview:_authBtn];



}

-(void)startRequestCode
{
    self.rightItemBtn.userInteractionEnabled=NO;
    
    //_againBtn.userInteractionEnabled=YES;
}

-(void)showVerify
{
    self.rightItemBtn.userInteractionEnabled=YES;
    //_againBtn.userInteractionEnabled=NO;
    [self setMessageText];
    [self fireMyTimer];
}

-(void)failedRequest
{
    _againBtn.userInteractionEnabled=YES;
}




-(void)fireMyTimer
{
    _timeNumber=60;
    if(!self.myTimer)
    {
        _myTimer=[NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(countDown)
                                                userInfo:nil
                                                 repeats:YES];
        
    }
    
    [self.myTimer fire];
}

-(void)countDown
{
    
    
}

-(void)setMessageText
{
    
   
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self rightAction];
    return YES;
}


-(void)againSendIdentifyingCode
{
    [self requestVerifying];
}

-(void)requestVerifying
{
    
}



@end
