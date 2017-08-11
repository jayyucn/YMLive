//
//  TrailerAlertView.m
//  live
//
//  Created by hysd on 15/8/21.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import "TrailerAlertView.h"
#import "Macro.h"
#import "UIImage+Category.h"

@interface TrailerAlertView(){
    UIView* mBackgroundView;
    UIWindow *mOriginalWindow;
    NSTimer* leftTimer;
    NSString* startTime;
}
@end
@implementation TrailerAlertView

- (void)awakeFromNib
{
    self.layer.cornerRadius = 5;
    self.backgroundColor = RGB16(COLOR_BG_WHITE);
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH-40, self.frame.size.height);
    
    self.hourLLabel.textColor = RGB16(COLOR_FONT_LIGHTGRAY);
    //self.hourLLabel.layer.borderWidth = 1;
    //self.hourLLabel.layer.borderColor = RGB16(COLOR_BG_LIGHTGRAY).CGColor;
    self.hourRLabel.textColor = RGB16(COLOR_FONT_LIGHTGRAY);
    //self.hourRLabel.layer.borderWidth = 1;
    //self.hourRLabel.layer.borderColor = RGB16(COLOR_BG_LIGHTGRAY).CGColor;
    
    self.timeSepLLaebl.textColor = RGB16(COLOR_FONT_LIGHTGRAY);
    
    self.minuteLLabel.textColor = RGB16(COLOR_FONT_LIGHTGRAY);
    //self.minuteLLabel.layer.borderWidth = 1;
    //self.minuteLLabel.layer.borderColor = RGB16(COLOR_BG_LIGHTGRAY).CGColor;
    self.minuteRLabel.textColor = RGB16(COLOR_FONT_LIGHTGRAY);
    //self.minuteRLabel.layer.borderWidth = 1;
    //self.minuteRLabel.layer.borderColor = RGB16(COLOR_BG_LIGHTGRAY).CGColor;
    
    self.timeSepRLabel.textColor = RGB16(COLOR_FONT_LIGHTGRAY);
    
    self.secondLLabel.textColor = RGB16(COLOR_FONT_LIGHTGRAY);
    //self.secondLLabel.layer.borderWidth = 1;
    //self.secondLLabel.layer.borderColor = RGB16(COLOR_BG_LIGHTGRAY).CGColor;
    self.secondRLabel.textColor = RGB16(COLOR_FONT_LIGHTGRAY);
    //self.secondRLabel.layer.borderWidth = 1;
    //self.secondRLabel.layer.borderColor = RGB16(COLOR_BG_LIGHTGRAY).CGColor;
    
    self.logoImageView.layer.cornerRadius = self.logoImageView.frame.size.height/2;
    self.logoImageView.clipsToBounds = YES;
    self.logoImageView.layer.borderColor = RGB16(COLOR_BG_RED).CGColor;
    self.logoImageView.layer.borderWidth = 2;
    
    self.nameLabel.textColor = RGB16(COLOR_FONT_BLACK);
    self.praiseLabel.textColor = RGB16(COLOR_FONT_GRAY);
    
    UIButton* closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(self.frame.size.width-30, -10, 40, 40);
    [closeButton setImage:[UIImage imageNamed:@"close_red_circle"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    
    CGRect rect = [UIScreen mainScreen].bounds;
    mOriginalWindow = [[UIWindow alloc] initWithFrame:rect];
    mOriginalWindow.windowLevel = UIWindowLevelAlert;
    
    mBackgroundView  = [[UIView alloc] initWithFrame:rect];
    mBackgroundView.alpha = 0.4;
    mBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    mBackgroundView.backgroundColor = [UIColor blackColor];
    mBackgroundView.center = mOriginalWindow.center;
    self.center = mOriginalWindow.center;
    
    [mOriginalWindow addSubview:mBackgroundView];
    [mOriginalWindow addSubview:self];
    [mOriginalWindow makeKeyAndVisible];
    
}

- (void)showTime:(NSString*)time logo:(NSString*)logo name:(NSString*)name praise:(NSString*)praise{
    leftTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    startTime = time;
    [self setTimeFromNow:time];
    self.nameLabel.text = name;
    self.praiseLabel.text = praise;
    if([logo isEqualToString:@""]){
        self.logoImageView.image = [UIImage imageNamed:@"default_head"];
    }
    else{
//        NSInteger width = self.logoImageView.frame.size.width*SCALE;
//        NSInteger height = width;
//        NSString *logoUrl = [NSString stringWithFormat:URL_IMAGE,logo,width,height];
        [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString faceURLString:logo]] placeholderImage:[UIImage imageWithColor:RGB16(COLOR_FONT_WHITE) andSize:self.logoImageView.frame.size]];
    }
    self.alpha=0;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha=1;
    } completion:^(BOOL finished) {
    }];
}

- (void)closeView:(id)sender {
    if(leftTimer){
        [leftTimer invalidate];
        leftTimer = nil;
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha=0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [mBackgroundView removeFromSuperview];
        [[AppDelegate sharedAppDelegate] makeSelfVisible];
        mOriginalWindow = nil;
    }];
}

- (void)updateTime{
    [self setTimeFromNow:startTime];
}

#pragma mark 设置时间
- (void)setTimeFromNow:(NSString*)time{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *to = [formatter dateFromString:time];
    NSDate *from = [NSDate date];
    NSTimeInterval aTimer = [to timeIntervalSinceDate:from];
    int hour = (int)(aTimer/3600);
    int minute = (int)(aTimer - hour*3600)/60;
    int second = aTimer - hour*3600 - minute*60;
    
    if(hour < 0 || minute < 0 || second < 0){
        self.hourLLabel.textColor = RGB16(COLOR_FONT_RED);
        self.hourRLabel.textColor = RGB16(COLOR_FONT_RED);
        self.timeSepLLaebl.textColor = RGB16(COLOR_FONT_RED);
        self.minuteLLabel.textColor = RGB16(COLOR_FONT_RED);
        self.minuteRLabel.textColor = RGB16(COLOR_FONT_RED);
        self.timeSepRLabel.textColor = RGB16(COLOR_FONT_RED);
        self.secondLLabel.textColor = RGB16(COLOR_FONT_RED);
        self.secondRLabel.textColor = RGB16(COLOR_FONT_RED);
        return;
    }
    self.hourLLabel.text = [NSString stringWithFormat:@"%d",hour/10];
    self.hourRLabel.text = [NSString stringWithFormat:@"%d",hour%10];
    self.minuteLLabel.text = [NSString stringWithFormat:@"%d",minute/10];
    self.minuteRLabel.text = [NSString stringWithFormat:@"%d",minute%10];
    self.secondLLabel.text = [NSString stringWithFormat:@"%d",second/10];
    self.secondRLabel.text = [NSString stringWithFormat:@"%d",second%10];
    if(hour == 0){
        self.hourLLabel.textColor = RGB16(COLOR_FONT_RED);
        self.hourRLabel.textColor = RGB16(COLOR_FONT_RED);
    }
    if(minute == 0){
        self.timeSepLLaebl.textColor = RGB16(COLOR_FONT_RED);
        self.minuteLLabel.textColor = RGB16(COLOR_FONT_RED);
        self.minuteRLabel.textColor = RGB16(COLOR_FONT_RED);
    }
}

@end

