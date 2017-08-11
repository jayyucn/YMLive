//
//  LCIntroductionController.h
//  XCLive
//
//  Created by ztkztk on 14-5-28.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCViewController.h"

@interface LCIntroductionController : LCViewController<UIWebViewDelegate>

@property (nonatomic,strong)UIActivityIndicatorView *activityIndicatorView;//正在加载图标
@property (nonatomic,strong)UIWebView *adWebView;//ad webview

@end
