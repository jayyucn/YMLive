//
//  LCNoticeView.h
//  XCLive
//
//  Created by ztkztk on 14-5-30.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCAlertView.h"

@interface LCNoticeView : LCAlertView

@property (nonatomic,strong)UILabel *titleLabel;

+ (void)showMsg:(NSString *)msg;

@end
