//
//  ReportAlert.m
//  live
//
//  Created by AlexiChen on 15/11/5.
//  Copyright © 2015年 kenneth. All rights reserved.
//

#import "ReportAlert.h"

@interface ReportAlert ()
{
    UIWindow *_alertWindow;
    
    UIView *_backgroundView;
    
    UIButton *_closeButton;
}
@end

@implementation ReportAlert

- (void)awakeFromNib
{
    self.layer.cornerRadius = 5;
    self.backgroundColor = RGB16(COLOR_BG_WHITE);
    
    CGRect rect = [UIScreen mainScreen].bounds;
    
    _alertWindow = [[UIWindow alloc] initWithFrame:rect];
    _alertWindow.windowLevel = UIWindowLevelAlert;
//        _alertWindow.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];

    //关闭按钮
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeButton.frame = CGRectMake(self.frame.size.width-30, -10, 40, 40);
    [_closeButton setImage:[UIImage imageNamed:@"close_red_circle"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeButton];

    _backgroundView  = [[UIView alloc] initWithFrame:rect];
    _backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [_backgroundView addSubview:self];
    
    self.center = _backgroundView.center;
    
    [_alertWindow addSubview:_backgroundView];
    [_alertWindow makeKeyAndVisible];
}

- (void)closeView:(id)sender
{
    [UIView animateWithDuration:0.2 animations:^{
        _backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [_backgroundView removeFromSuperview];
        [[AppDelegate sharedAppDelegate] makeSelfVisible];
        _alertWindow = nil;
    }];
}

- (void)show
{
    _backgroundView.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        _backgroundView.alpha = 1;
    }];
}

- (IBAction)onClick:(UIButton *)sender
{
    if (_selectButton == sender)
    {
        _selectButton.selected = !_selectButton.selected;
        _selectButton = nil;
    }
    else
    {
        _selectButton.selected = NO;
        _selectButton = sender;
        _selectButton.selected = YES;
    }
    _commit.enabled = _selectButton != nil;
}


- (IBAction)onCommit:(id)sender
{
    if (_selectButton && _action)
    {
        _action([_selectButton titleForState:UIControlStateNormal]);
    }
    
    [self closeView:nil];
}

@end
