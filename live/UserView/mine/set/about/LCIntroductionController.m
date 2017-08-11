//
//  LCIntroductionController.m
//  XCLive
//
//  Created by ztkztk on 14-5-28.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCIntroductionController.h"

@interface LCIntroductionController ()

@end

@implementation LCIntroductionController

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
    
    //webview
    CGRect advRect=CGRectMake(0,0,ScreenWidth,ScreenHeight-self.navigationController.navigationBar.height-20);
    _adWebView=[[UIWebView alloc] initWithFrame:advRect];
    [self.view addSubview:_adWebView];
    _adWebView.delegate=self;
    _adWebView.scalesPageToFit = YES;
    
    
    
    //正在加载风火轮
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    //[_activityIndicatorView setCenter: self.view.center] ;
    _activityIndicatorView.centerX=160;
    _activityIndicatorView.centerY=ScreenHeight/2-22;
    [self.view addSubview : _activityIndicatorView];
    
    
    _activityIndicatorView.hidesWhenStopped=YES;
    
    [_activityIndicatorView startAnimating];
    
    NSURL *url =[NSURL URLWithString:introductionURL()];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [_adWebView loadRequest:request];

}

#pragma mark webview delegagte

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_activityIndicatorView startAnimating] ;
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


#pragma mark end

@end
