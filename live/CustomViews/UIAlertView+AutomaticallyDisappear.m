//
//  UIAlertView+AutomaticallyDisappear.m
//  KaiFang
//
//  Created by ztkztk on 14-1-10.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "UIAlertView+AutomaticallyDisappear.h"

@implementation UIAlertView (AutomaticallyDisappear)

-(void)automaticallyDisappearWithTime:(double)second
{
    [NSTimer scheduledTimerWithTimeInterval:second
                                     target:self
                                   selector:@selector(performDismiss:)
                                   userInfo:nil
                                    repeats:NO];
}

-(void)performDismiss:(NSTimer*)timer
{
    [self dismissWithClickedButtonIndex:1
                               animated:YES];
 
}

@end
