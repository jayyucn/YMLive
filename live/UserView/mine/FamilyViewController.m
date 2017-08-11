//
//  家族管理界面
//  FamilyViewController.m
//
//  Created by garsonge on 17/2/21.
//


#import "FamilyViewController.h"


@interface FamilyViewController()
{
    UIWebView *webView;
}

@end


@implementation FamilyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
     * do any additional setup after loading the view
     */
    self.title = @"家族管理";
    self.view.backgroundColor = [UIColor whiteColor];
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@family", URL_HEAD]]];
    
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
