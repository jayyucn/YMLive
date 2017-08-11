//
//  UploadProgressView.m
//  TaoHuaLive
//
//  Created by Jay on 2017/7/19.
//  Copyright © 2017年 上海七夕. All rights reserved.
//

#import "UploadProgressView.h"

@interface UploadProgressView ()

@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation UploadProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBAColor(0, 0, 0, 0.32);
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    CGFloat progressHeight = self.height - 10;
    self.progressView = [UIProgressView flatProgressViewWithTrackColor:[UIColor clearColor] progressColor:ColorPink];
    self.progressView.frame = CGRectMake(16, 5, self.width-32, progressHeight);
    [self.progressView resizedHeight:14];
    [self addSubview:self.progressView];
    
    UILabel *toastLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.width, progressHeight)];
    [toastLb setBackgroundColor:[UIColor clearColor]];
    [toastLb setTextColor:[UIColor whiteColor]];
    [toastLb setTextAlignment:NSTextAlignmentCenter];
    [toastLb setFont:[UIFont systemFontOfSize:12]];
    [toastLb setText:ESLocalizedString(@"正在生成视频，请稍后...")];
    [self addSubview:toastLb];
    
}
- (void)updateProgress:(CGFloat)progress
{
    if (self.progressView) {
        [self.progressView setProgress:progress];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
