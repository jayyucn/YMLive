//
//  KFNoticeAlertView.m
//  KaiFang
//
//  Created by ztkztk on 14-1-6.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "LCNoticeAlertView.h"

#import "UIAlertView+AutomaticallyDisappear.h"


@implementation LCNoticeAlertView


+ (void)showMsg:(NSString *)msg
{

    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil,nil];
    alert.delegate=self;
    [alert show];
    [alert automaticallyDisappearWithTime:1.0];

}

+ (void)showClearBackgroundMsg:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil,nil];
    alert.backgroundColor = [UIColor clearColor];
    alert.delegate=self;
    [alert show];
    
    [alert automaticallyDisappearWithTime:1.0];
}

@end
