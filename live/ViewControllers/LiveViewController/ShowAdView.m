//
//  ShowAdView.m
//  qianchuo 广告view
//
//  Created by jacklong on 16/6/28.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ShowAdView.h"

@interface ShowAdView()
{
    UIButton        *skipAdBtn;
    UIImageView     *adImg;
    
    NSTimer         *_skipTimer;
    int             countTimer;
}

@end

@implementation ShowAdView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        adImg = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:adImg];
        adImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickImage)];
        [adImg addGestureRecognizer:singleTap];
        
        skipAdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        skipAdBtn.frame = CGRectMake(SCREEN_WIDTH - 90, 25, 80, 30);
        skipAdBtn.backgroundColor = RGBA16(0x7f000000);
        skipAdBtn.titleLabel.font = [UIFont systemFontOfSize:14.];
        skipAdBtn.titleLabel.textColor = [UIColor whiteColor];
        skipAdBtn.layer.cornerRadius = 15;
        [skipAdBtn setTitle:@"点击跳过 5" forState:UIControlStateNormal];
        [self addSubview:skipAdBtn];
        [skipAdBtn addTarget:self action:@selector(skipAdAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void) skipAdAction
{
    [self hiddenAdView];
}

- (void)onClickImage
{
//    [ESStoreHelper openAppStoreWithAppID:kAppStoreID storeCountryCode:ESAppStoreCountryCodeChina];
    if (_adDetailBlock) {
        _adDetailBlock();
    }
    [self hiddenAdView];
}

- (void) hiddenAdView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
        skipAdBtn.hidden = YES;
        [self stopSkipTimer];
    }];
}

// 开启定时器
- (void)startSkipTimer
{
    if (!_skipTimer) {
        _skipTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshTimer) userInfo:nil repeats:YES];
    }
}

// 关闭定时器
- (void)stopSkipTimer
{
    if (_skipTimer) {
        [_skipTimer invalidate];
        _skipTimer = nil;
    }
}

- (void) refreshTimer
{   countTimer --;
    if (countTimer > 0) {
         [skipAdBtn setTitle:[NSString stringWithFormat:@"跳过广告 %d",countTimer] forState:UIControlStateNormal];
    } else {
        skipAdBtn.hidden = YES;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha=0;
        } completion:^(BOOL finished) {
            self.hidden = YES;
            [self removeFromSuperview];
            if (self.callbackBlock) {
                self.callbackBlock();
            }
            [self stopSkipTimer];
        }];
    }
}

- (void) setAdvDict:(NSDictionary *)advDict
{
    if (!advDict[@"pic"]) {
        [self hiddenAdView];
        return;
    }
    
    countTimer = 5;
    NSString *imageURL=[NSString faceURLString:advDict[@"pic"]];
    [adImg sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"AdLoadImage"]];
}

#pragma mark - 显示view
- (void)showView:(UIView*)view
{
    [view addSubview:self];
    self.alpha=0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=1;
    } completion:^(BOOL finished) {
        [self startSkipTimer];
    }];
}

@end
