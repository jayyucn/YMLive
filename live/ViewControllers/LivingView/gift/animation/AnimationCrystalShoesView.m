//
//  AnimationCrystalShoesView.m
//  qianchuo
//
//  Created by 林伟池 on 16/7/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "AnimationCrystalShoesView.h"
#import "LuxuryManager.h"
#import "AnimationImageCache.h"
#import "LYRACDefine.h"

@interface AnimationCrystalShoesView ()
@property (nonatomic , strong) UIImageView *mCrystalShoesImageView;
@property (nonatomic , strong) UIImageView *mCrystalAngleWhiteView;
@property (nonatomic , strong) UIImageView *mCrystalAngleYellowView;
@property (nonatomic , strong) UIImageView *mCrystalAnglePurpleView;

@property (nonatomic , strong) UIImageView *mCrystalLightShoesView;
@end


@implementation AnimationCrystalShoesView


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

#define const_shoes_width       150
#define const_shoes_height      150



- (void)customInit {
    
    self.mCrystalShoesImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - const_shoes_width) / 2, (self.height - const_shoes_height) / 2, const_shoes_width, const_shoes_height)]; // 居中鞋子
    [self.mCrystalShoesImageView setImage:[[AnimationImageCache shareInstance] getImageWithName:@"gift_crystal_shoes.png"]];
    [self addSubview:self.mCrystalShoesImageView];

    
    self.mCrystalAngleYellowView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 60, 120, 120)];
    [self.mCrystalAngleYellowView setImage:[[AnimationImageCache shareInstance] getImageWithName:@"gift_crystal_angle_yellow.png"]];
    [self addSubview:self.mCrystalAngleYellowView];
    
    self.mCrystalAnglePurpleView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 165, 100)];
    [self.mCrystalAnglePurpleView setImage:[[AnimationImageCache shareInstance] getImageWithName:@"gift_crystal_angle_purple.png"]];
    [self addSubview:self.mCrystalAnglePurpleView];
    
    self.mCrystalAngleWhiteView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 70, 207, 160)];
    [self.mCrystalAngleWhiteView setImage:[[AnimationImageCache shareInstance] getImageWithName:@"gift_crystal_angle_white.png"]];
    [self addSubview:self.mCrystalAngleWhiteView];
    
    
    self.mCrystalLightShoesView = [[UIImageView alloc] initWithFrame:CGRectMake(120, 80, 50, 50)];
    [self.mCrystalLightShoesView setImage:[[AnimationImageCache shareInstance] getImageWithName:@"gift_crystal_light_shoes.png"]];
    [self.mCrystalShoesImageView addSubview:self.mCrystalLightShoesView];
    
    self.mCrystalShoesImageView.alpha = 0;
    self.mCrystalAnglePurpleView.alpha = 0;
    self.mCrystalAngleYellowView.alpha = 0;
    self.mCrystalAngleWhiteView.alpha = 0;
    
    
    [self startAnimation];
}


- (void)setMNickName:(NSString *)mNickName {
    UILabel* nameLabel = [[UILabel alloc] init];
    nameLabel.text = mNickName;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.shadowColor = [UIColor yellowColor];
    [nameLabel sizeToFit];
    nameLabel.center = CGPointMake(self.width / 2, -10);
    [self addSubview:nameLabel];
}


- (void)addRandomStarWithRect:(CGRect)rect {
    int randTime = arc4random_uniform(100);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((randTime / 100.0) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 总共四个灯光，随机选择一个
        int randID = arc4random_uniform(4);
        int randX = arc4random_uniform(rect.size.width) + rect.origin.x;
        int randY = arc4random_uniform(rect.size.height) + rect.origin.y;
        
        UIImage *image = [[AnimationImageCache shareInstance] getImageWithName:[NSString stringWithFormat:@"gift_crystal_star%d.png", randID]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(randX, randY, image.size.width / 2, image.size.height / 2)];
        imageView.image = image;
        [self addSubview:imageView];
        
        CAKeyframeAnimation* opacityAnimation;
        opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.values = @[@(0), @(1), @(0)];
        opacityAnimation.duration = 1.0;
        opacityAnimation.fillMode = kCAFillModeBoth;
        opacityAnimation.calculationMode = kCAAnimationCubic;
        opacityAnimation.repeatCount = HUGE_VALF;
        
        [imageView.layer addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    });
}


#pragma mark - start

- (void)startAnimation {
    [UIView animateWithDuration:0.5 animations:^{
        self.mCrystalShoesImageView.alpha = 1;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.0 animations:^{
            self.mCrystalAnglePurpleView.alpha = 1;
        }];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.0 animations:^{
            self.mCrystalAngleYellowView.alpha = 1;
        }];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.0 animations:^{
            self.mCrystalAngleWhiteView.alpha = 1;
        }];
    });
    
        [self playStarAnimation];
        [self playShoesLightAnimation];

    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CRYSTAL_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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

- (void)playShoesLightAnimation {
    CAKeyframeAnimation *opacityAnimation;
    opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.values = @[@(0.5), @(1), @(0.5)];
    opacityAnimation.duration = 1.0;
    opacityAnimation.fillMode = kCAFillModeBoth;
    opacityAnimation.calculationMode = kCAAnimationCubic;
    opacityAnimation.repeatCount = HUGE_VALF;
    [self.mCrystalLightShoesView.layer addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    
    CAKeyframeAnimation *scaleAnimation;
    scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.values = @[@(0.8), @(1.2), @(0.8)];
    scaleAnimation.duration = 1.0;
    scaleAnimation.fillMode = kCAFillModeBoth;
    scaleAnimation.calculationMode = kCAAnimationCubic;
    scaleAnimation.repeatCount = HUGE_VALF;
    [self.mCrystalLightShoesView.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    
}


- (void)playStarAnimation {
    for (int i = 0; i < 10; ++i) {
        [self addRandomStarWithRect:CGRectMake(10, 10, 50, 50)];
        [self addRandomStarWithRect:CGRectMake(CRYSTAL_SHOES_WIDTH - 60, 40, 50, 50)];
    }
}

#pragma mark - end
- (void)callBackManager {
    [LuxuryManager luxuryManager].isShowAnimation = NO;
    [[LuxuryManager luxuryManager] showLuxuryAnimation];
}

@end
