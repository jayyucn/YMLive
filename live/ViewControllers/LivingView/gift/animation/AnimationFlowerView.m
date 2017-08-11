//
//  AnimationFlowerView.m
//  qianchuo
//
//  Created by 林伟池 on 16/7/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "AnimationFlowerView.h"
#import "LuxuryManager.h"
#import "AnimationImageCache.h"
#import "LYRACDefine.h"

@interface AnimationFlowerView ()
@property (nonatomic , strong) UIImageView *mFlowerBunchView;
@property (nonatomic , strong) UIImageView *mFlowerLightView;
@end


@implementation AnimationFlowerView


#pragma mark - init

- (instancetype)init {
    self = [super init];
    [self customInit];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self customInit];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self customInit];
    return self;
}

- (void)dealloc {
    NSLog(@"dealloc");
}


- (void)customInit {
    self.userInteractionEnabled = NO;
    
    
    self.mFlowerLightView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - 351) / 2, (self.height - 120) / 2, 351, 120)];
    [self.mFlowerLightView setImage:[[AnimationImageCache shareInstance] getImageWithName:@"gift_flower_light.png"]];
    [self addSubview:self.mFlowerLightView];
    
    UIImage *flowerImage = [[AnimationImageCache shareInstance] getImageWithName:@"five521_red_rose.png"];
    self.mFlowerBunchView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - 178) / 2, (self.height - 160) / 2, 178, 160)];
    [self.mFlowerBunchView setImage:flowerImage];
    [self addSubview:self.mFlowerBunchView];
    
    self.mFlowerLightView.layer.opacity = 0;
    
    [self startAnimation];
}


- (void)setMNickName:(NSString *)mNickName {
    UILabel* nameLabel = [[UILabel alloc] init];
    nameLabel.text = mNickName;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.shadowColor = [UIColor yellowColor];
    [nameLabel sizeToFit];
    nameLabel.center = CGPointMake(self.width / 2, self.height / 2 - 100);
    [self addSubview:nameLabel];
}


#pragma mark - start

- (void)startAnimation {
    self.mFlowerBunchView.transform = CGAffineTransformMakeScale(0.3, 0.3);
    [UIView animateWithDuration:1.0 animations:^{
        self.mFlowerBunchView.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self playLightAnimation];
    });
    
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(FLOWER_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @weakify(self);
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            @strongify(self);
            [self removeFromSuperview];
            [self callBackManager];
        }];
    });
}

- (void)playLightAnimation {
    CAKeyframeAnimation *opacityAnimation;
    opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.values = @[@(0), @(1), @(0)];
    opacityAnimation.duration = 1.5;
    opacityAnimation.fillMode = kCAFillModeBoth;
    opacityAnimation.calculationMode = kCAAnimationCubic;
    opacityAnimation.repeatCount = HUGE_VALF;
    [self.mFlowerLightView.layer addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    
    
}


#pragma mark - end
- (void)callBackManager {
    [LuxuryManager luxuryManager].isShowAnimation = NO;
    [[LuxuryManager luxuryManager] showLuxuryAnimation];
}

@end
