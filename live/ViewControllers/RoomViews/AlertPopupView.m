//
//  AlertPopupView.m
//  live
//
//  Created by AlexiChen on 15/10/21.
//  Copyright © 2015年 kenneth. All rights reserved.
//

#import "AlertPopupView.h"

@implementation AlertPopupViewBaseContentView
@end


@interface AlertPopupView ()
{
    AlertPopupViewBaseContentView   *_alertContent;
    UIWindow                        *_alertWindow;
}

@end

@implementation AlertPopupView

- (instancetype)initWithFrame:(CGRect)frame
{
    CGRect rect = [UIScreen mainScreen].bounds;
    if(self = [super initWithFrame:rect])
    {
        _alertWindow = [[UIWindow alloc] initWithFrame:rect];
        _alertWindow.windowLevel = UIWindowLevelAlert;
        
        self.alpha = 0.4;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = [UIColor blackColor];
        self.center = _alertWindow.center;
        
        [_alertWindow addSubview:self];
        [_alertWindow makeKeyAndVisible];
//        [_alertWindow resignKeyWindow];
    }
    return self;
}

- (void)showContent:(AlertPopupViewBaseContentView *)content
{
    
}

//- ()closeAction:(id)sender {
//    [UIView animateWithDuration:0.2 animations:^{
//        self.alpha=0;
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//        _alertWindow = nil;
//    }];
//}
//
//- (void)showTitle:(NSString*)title content:(NSString*)content{
//    self.titleLabel.text = title;
//    self.alpha=0;
//    [UIView animateWithDuration:0.2 animations:^{
//        self.alpha=1;
//    } completion:^(BOOL finished) {
//    }];
//}

@end