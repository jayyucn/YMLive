//
//  LCEmailViewController.m
//  XCLive
//
//  Created by ztkztk on 14-4-29.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCEmailViewController.h"

#import "LCConfirmViewController.h"

@interface LCEmailViewController ()

@end

@implementation LCEmailViewController


+(id)loadEmailWithAddress:(NSString *)emailAddress
{
    LCEmailViewController *emailController=[[LCEmailViewController alloc] init];
    emailController.emailAddress=emailAddress;
    return emailController;
}

-(void)setEmailAddress:(NSString *)emailAddress
{
    _emailAddress=emailAddress;
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //webview
    CGRect advRect=CGRectMake(0,0,ScreenWidth,ScreenHeight-self.navigationController.navigationBar.height-20);
    _emailView=[[UIWebView alloc] initWithFrame:advRect];
    [self.view addSubview:_emailView];
    _emailView.delegate=self;
    _emailView.scalesPageToFit = YES;
    
    
    
    //正在加载风火轮
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    //[_activityIndicatorView setCenter: self.view.center] ;
    _activityIndicatorView.centerX=ScreenWidth/2;
    _activityIndicatorView.centerY=ScreenHeight/2-22;
    [self.view addSubview : _activityIndicatorView];
    
    
    _activityIndicatorView.hidesWhenStopped=YES;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(emailAuthSuccess)
                                                 name:NotificationMsg_EmailAuthSuccess
                                               object:nil];

    
}


-(void)emailAuthSuccess
{
    [LCNoticeAlertView showMsg:@"邮箱激活成功"];
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[LCConfirmViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
            return;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_activityIndicatorView startAnimating];
    
    NSURL *url =[NSURL URLWithString:_emailAddress];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [_emailView loadRequest:request];

}

#pragma mark webview delegagte

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_activityIndicatorView startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_activityIndicatorView stopAnimating];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_activityIndicatorView stopAnimating];
    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@""
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
    [alterview show];
    
}

@end
