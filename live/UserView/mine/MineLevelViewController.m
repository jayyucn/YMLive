//
//  用户等级界面
//  MineLevelViewController.m
//  qianchuo
//
//  Created by jacklong on 16/4/18.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//


#import "MineLevelViewController.h"


@interface MineLevelViewController()
{
    UIWebView *webView;
}

@end


@implementation MineLevelViewController

- (void)dealloc
{
    // if needed
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // do any additional setup after loading the view
    self.title = @"我的等级";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//  UIButton *rightItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//  rightItemBtn.frame = CGRectMake(0, 0, 65.0f, 30.0f);
//  
//  [rightItemBtn setTitle:@"提现记录" forState:UIControlStateNormal];
//  rightItemBtn.titleLabel.textAlignment = NSTextAlignmentRight;
//  rightItemBtn.titleLabel.font = [UIFont systemFontOfSize:11.0];
//  [rightItemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//  rightItemBtn.backgroundColor = [UIColor clearColor];
//  
//  [rightItemBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
//  
//  UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemBtn];
//  self.navigationItem.rightBarButtonItem = rightItem;
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@profile/mygrade", URL_HEAD]]];
    [self.view addSubview: webView];
    [webView loadRequest:request];
}

- (void)rightAction
{
    // if needed
}

@end
