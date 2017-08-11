//
//  LCEmailViewController.h
//  XCLive
//
//  Created by ztkztk on 14-4-29.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCViewController.h"

@interface LCEmailViewController : LCViewController<UIWebViewDelegate>
@property (nonatomic,strong)NSString *emailAddress;
@property (nonatomic,strong)UIWebView *emailView;
@property (nonatomic,strong)UIActivityIndicatorView *activityIndicatorView;//正在加载图标


+(id)loadEmailWithAddress:(NSString *)emailAddress;

@end
