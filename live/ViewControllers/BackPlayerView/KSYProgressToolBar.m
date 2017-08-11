//
//  KSYProgressToolBar.m
//  qianchuo
//
//  Created by jacklong on 16/8/8.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "KSYProgressToolBar.h"

@interface KSYProgressToolBar()

//@property (strong, nonatomic) UIButton  *controCommentButton;
//@property (strong, nonatomic) UIButton  *shareButton;
@property (strong, nonatomic) UIButton  *playControlButton;
@property (strong, nonatomic) UISlider  *slider;
@property (strong, nonatomic) UIProgressView *progrossView;
//@property (strong, nonatomic) UILabel   *timeLabel;

@end

@implementation KSYProgressToolBar


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
//        [self addSubview:self.controCommentButton];
//        [self addSubview:self.shareButton];
        [self addSubview:self.playControlButton];
        [self addSubview:self.progrossView];
        [self addSubview:self.slider];
//        [self addSubview:self.timeLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.controCommentButton.frame = CGRectMake(10, 5, 34, 34);
    self.playControlButton.frame = CGRectMake(10, 3, 34, 34);
    self.progrossView.frame= CGRectMake(_playControlButton.right + 6, 5, self.frame.size.width - (_playControlButton.right + 6 + 15), 30);
    self.slider.frame = CGRectMake(_playControlButton.right + 6, 5, self.frame.size.width - (_playControlButton.right + 6 + 5), 30);
    self.progrossView.center = self.slider.center;
//    self.shareButton.frame = CGRectMake(_slider.right + 10, 5, 34, 34);
//    self.timeLabel.frame = CGRectMake(self.slider.right+5,self.slider.centerY - 10, 85, 20);
}
//- (UIButton *)controCommentButton
//{
//    if (!_controCommentButton) {
//        _controCommentButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _controCommentButton.tag = 331;
//        [_controCommentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _controCommentButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
//        [_controCommentButton setBackgroundImage:[UIImage imageNamed:@"interactiveOn"] forState:UIControlStateNormal];
//        [_controCommentButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//        
//    }
//    return _controCommentButton;
//}
//- (UIButton *)shareButton
//{
//    if (!_shareButton) {
//        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _shareButton.tag = 332;
//        [_shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _shareButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
//        [_shareButton setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
//        [_shareButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//        
//    }
//    return _shareButton;
//}

- (UIButton *)playControlButton
{
    if (!_playControlButton) {
        _playControlButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playControlButton setBackgroundImage:[UIImage imageNamed:@"image/liveroom/pause"] forState:UIControlStateNormal];
        [_playControlButton addTarget:self action:@selector(playControlButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playControlButton;
}

- (UIProgressView *)progrossView
{
    if (!_progrossView) {
        _progrossView = [UIProgressView new];
        _progrossView.progressTintColor=[UIColor whiteColor];
    }
    return _progrossView;
}

- (UISlider *)slider
{
    if (!_slider) {
        _slider = [UISlider new];
        //        [_slider addTarget:self action:@selector(progressDidBegin:) forControlEvents:UIControlEventTouchDown];
        [_slider addTarget:self action:@selector(progressChanged:) forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self action:@selector(progressChangeEnd:) forControlEvents:(UIControlEventTouchUpOutside | UIControlEventTouchCancel|UIControlEventTouchUpInside)];
        _slider.value = 0.0;
        
        _slider.maximumTrackTintColor = [UIColor clearColor];
        _slider.minimumTrackTintColor = ColorPink;
//        [[KSYThemeManager sharedInstance] changeTheme:@"red"];
        
//        UIImage *dotImg = [[KSYThemeManager sharedInstance] imageInCurThemeWithName:@"img_dot"];
        
        [_slider setThumbImage:[UIImage imageNamed:@"image/liveroom/img_dot"] forState:UIControlStateNormal];
        
    }
    
    return _slider;
}

//- (UILabel *)timeLabel
//{
//    if (!_timeLabel) {
//        _timeLabel = [UILabel new];
//        _timeLabel.textAlignment = NSTextAlignmentRight;
//        _timeLabel.font = [UIFont systemFontOfSize:12.0];
//        _timeLabel.textColor = [UIColor whiteColor];
//    }
//    return _timeLabel;
//}
- (void)updataSliderWithPosition:(NSInteger)position duration:(NSInteger)duration playableDuration:(NSInteger)playableduration
{
    self.slider.value = position;
    self.slider.maximumValue = duration;
    self.progrossView.progress = (CGFloat)playableduration/duration;
    int iDuraMin  = (int)(duration / 60);
    int iDuraSec  = (int)(duration % 3600 % 60);
    
    int iPosMin  = (int)(position / 60);
    int iPosSec  = (int)(position % 3600 % 60);
    
    if (self.timeLabel) {
       _timeLabel.text = [NSString stringWithFormat:@"%02d:%02d / %02d:%02d ",iPosMin,iPosSec, iDuraMin, iDuraSec];
    }
}

- (void)playControlButtonEvent:(UIButton *)button
{
    button.selected = !button.selected;
    
    if (self.playControlEventBlock) {
        self.playControlEventBlock(button.selected);
    }
    if (!button.selected) {
        [button setBackgroundImage:[UIImage imageNamed:@"image/liveroom/pause"] forState:UIControlStateNormal];
        
    }else{
        [button setBackgroundImage:[UIImage imageNamed:@"image/liveroom/play"] forState:UIControlStateNormal];
        
    }
}

- (void)playerIsStop:(BOOL)isStop
{
    self.playControlButton.selected = isStop;
    if (isStop) {
        [self.playControlButton setBackgroundImage:[UIImage imageNamed:@"image/liveroom/play"] forState:UIControlStateNormal];
    }else {
        [self.playControlButton setBackgroundImage:[UIImage imageNamed:@"image/liveroom/pause"] forState:UIControlStateNormal];
    }
}


- (void)buttonAction:(UIButton *)button
{
    if (button.tag == 331) {
//        if (!button.selected) {
//            [_controCommentButton setBackgroundImage:[UIImage imageNamed:@"interactiveOff"] forState:UIControlStateNormal];
//            
//            if (self.userEventBlock) {
//                self.userEventBlock(button.tag - 330);
//            }
//            
//        }else {
//            [_controCommentButton setBackgroundImage:[UIImage imageNamed:@"interactiveOn"] forState:UIControlStateNormal];
//            
//            
//            if (self.userEventBlock) {
//                self.userEventBlock(button.tag - 331);
//            }
//            
//        }
//        button.selected = !button.selected;
        
    }else {
        if (self.userEventBlock) {
            self.userEventBlock(button.tag - 330);
        }
    }
}


//- (void)progressDidBegin:(UISlider *)slider
//{
//
//    if (self.playControlEventBlock) {
//        self.playControlEventBlock(YES);
//    }
//}
- (void)progressChanged:(UISlider *)slider
{
    int iDuraMin  = (int)(self.slider.maximumValue / 60);
    int iDuraSec  = (int)((int)self.slider.maximumValue % 3600 % 60);
    
    int iPosMin  = (int)(self.slider.value / 60);
    int iPosSec  = (int)((int)self.slider.value % 3600 % 60);
    
    if (_timeLabel) {
       _timeLabel.text = [NSString stringWithFormat:@"%02d:%02d / %02d:%02d ",iPosMin,iPosSec, iDuraMin, iDuraSec];
    }
}
- (void)progressChangeEnd:(UISlider *)slider
{
    
    if (self.seekToBlock) {
        self.seekToBlock(slider.value);
    }
}


@end
