//
//  常见问题界面
//  FAQViewController.m
//
//  Created by garsonge on 17/2/21.
//


#import "FAQViewController.h"


@interface FAQViewController()
{
    UIWebView *webView;
}

@end


@implementation FAQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
     * do any additional setup after loading the view
     */
    self.title = @"常见问题";
    self.view.backgroundColor = [UIColor whiteColor];
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@faq/index", URL_HEAD]]];
    
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
