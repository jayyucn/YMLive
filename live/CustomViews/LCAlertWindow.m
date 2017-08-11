//
//  KFAlertWindow.m
//  KaiFang
//
//  Created by Elf Sundae on 13-12-24.
//  Copyright (c) 2013年 www.0x123.com. All rights reserved.
//

#import "LCAlertWindow.h"
#import "LCCore.h"


@implementation LCAlertWindow

- (instancetype)initSharedWindow
{
        self = [super init];
        if (self) {
                self.windowLevel = UIWindowLevelAlert;
                self.backgroundColor = [UIColor clearColor];
                self.frame = [UIScreen mainScreen].bounds;
                
                self->_appKeyWindow = [LCCore keyWindow];
        }
        return self;
}

- (void)resignKeyWindow
{
        if (self.subviews.count == 0) {
                [super resignKeyWindow];
                [[LCCore keyWindow] makeKeyWindow];
                self.hidden = YES;
        }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

+ (instancetype)sharedWindow
{
        static LCAlertWindow *_sharedWindow = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                _sharedWindow = [[super alloc] initSharedWindow];
        });
        return _sharedWindow;
}

- (void)showView:(UIView *)view
{
        if ([view isKindOfClass:[UIView class]]) {
                [self addSubview:view];
                [self makeKeyAndVisible];
        }
}

- (void)dismissView:(UIView *)view
{
        if ([view isKindOfClass:[UIView class]]) {
                [view removeFromSuperview];
                [self resignKeyWindow];
        }
}

- (void)dismissAll
{
        [self removeAllSubviews];
        [self resignKeyWindow];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
        UIView *view = [super hitTest:point withEvent:event];
        if (view == self) {
                UIView *lastView = self.subviews.lastObject;
                if (lastView) {
                        return lastView;
                }
        }
        return view;
}

@end
