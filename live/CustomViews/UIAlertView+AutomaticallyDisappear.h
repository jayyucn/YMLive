//
//  UIAlertView+AutomaticallyDisappear.h
//  KaiFang
//
//  Created by ztkztk on 14-1-10.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 UIAlertView 给定时间自动消失
 */
@interface UIAlertView (AutomaticallyDisappear)

-(void)automaticallyDisappearWithTime:(double)second;
-(void)performDismiss:(NSTimer*)timer;

@end
