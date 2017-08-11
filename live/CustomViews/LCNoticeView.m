//
//  LCNoticeView.m
//  XCLive
//
//  Created by ztkztk on 14-5-30.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCNoticeView.h"


@implementation LCNoticeView

+ (void)showMsg:(NSString *)msg
{
    LCNoticeView *alertView=[[LCNoticeView alloc] init];
    alertView.titleLabel.text=msg;
    [alertView showWithAnimated];
    
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.shouldDismissWhenTouchsAnywhere=NO;
        self.autoDismissTimeInterval=1;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,200,30)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor=[UIColor blackColor];
        _titleLabel.font=[UIFont boldSystemFontOfSize:20];
        _titleLabel.backgroundColor =[UIColor clearColor];
        [self.backgroundView addSubview:_titleLabel];
        _titleLabel.centerX=LCAlertViewWidth/2;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.numberOfLines = 1;

    }
    return self;
}


- (void)layoutSubviews
{
    
    
    
    self.backgroundView.height=_titleLabel.bottom;
    
    const CGFloat padding = 5.0;
    CGRect backgroundFrame = self.backgroundView.frame;
    CGRect frame = backgroundFrame;
    frame.size.width = 2 * padding + backgroundFrame.size.width;
    frame.size.height = 2 * padding + backgroundFrame.size.height;
    frame.origin.x = floorf((self.screenSize.width - frame.size.width) / 2.0);
    frame.origin.y = floorf((self.screenSize.height - frame.size.height) / 2.0) - 30.0;
    self.frame = frame;
    backgroundFrame.origin.x = backgroundFrame.origin.y = padding;
    self.backgroundView.frame = backgroundFrame;
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
