//
//  微信兑换界面
//  WXExchangeViewController.m
//
//  Created by garsonge on 17/2/21.
//


#import "WXExchangeViewController.h"


@interface WXExchangeViewController()
{
    UIWebView *webView;
}

@end


@implementation WXExchangeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
     * do any additional setup after loading the view
     */
    self.title = @"微信兑换";
    self.view.backgroundColor = [UIColor whiteColor];
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@weixin/bind?uid=%@", URL_HEAD, [LCMyUser mine].userID]]];
    
    [self.view addSubview:webView];
    
    [webView loadRequest:request];
}

- (void)dealloc
{
    // if needed
}


- (void)rightAction
{
    // if needed
}

@end
