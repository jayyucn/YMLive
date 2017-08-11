//
//  AnimationCrownView.m
//  qianchuo
//
//  Created by 林伟池 on 16/8/5.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "AnimationCrownView.h"
#import "LuxuryManager.h"
#import "AnimationImageCache.h"
#import "LYRACDefine.h"

@interface AnimationCrownView ()
@property (nonatomic , strong) UIImageView *mCrownBackgroundView;
@property (nonatomic , strong) UIImageView *mCrownWingLeftView;
@property (nonatomic , strong) UIImageView *mCrownWingRightView;
@property (nonatomic , strong) UIImageView *mCrownView;
@property (nonatomic , strong) UIImageView *mCrownLightView0;
@property (nonatomic , strong) UIImageView *mCrownLightView1;
@property (nonatomic , strong) UIImageView *mCrownLightView2;
@property (nonatomic , strong) UIImageView *mCrownLightView3;
@end


@implementation AnimationCrownView


#define BACKGROUND_TIME 10

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
    
    UIImage *image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_crown_background.png"];
    self.mCrownBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 - image.size.width / 4, self.height / 2 - image.size.height / 4, image.size.width / 2, image.size.height / 2)];
    [self.mCrownBackgroundView setImage:image];
    [self addSubview:self.mCrownBackgroundView];
    self.mCrownBackgroundView.alpha = 0;
    
    image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_crown_wing_left.png"];
    self.mCrownWingLeftView = [[UIImageView alloc] init];
    self.mCrownWingLeftView.layer.anchorPoint = CGPointMake(1.0, 0.5);
    self.mCrownWingLeftView.frame = CGRectMake(self.width / 2 - image.size.width * 3 / 4, self.height / 2 - image.size.height / 4, image.size.width / 2, image.size.height / 2);
    [self.mCrownWingLeftView setImage:image];
    [self addSubview:self.mCrownWingLeftView];
    self.mCrownWingLeftView.alpha = 0;
    
    
    image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_crown_wing_right.png"];
    self.mCrownWingRightView = [[UIImageView alloc] init];
    self.mCrownWingRightView.layer.anchorPoint = CGPointMake(0, 0.5);
    self.mCrownWingRightView.frame = CGRectMake(self.width / 2 + image.size.width / 4, self.height / 2 - image.size.height / 4, image.size.width / 2, image.size.height / 2);
    [self.mCrownWingRightView setImage:image];
    [self addSubview:self.mCrownWingRightView];
    self.mCrownWingRightView.alpha = 0;
    
    
    image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_crown.png"];
    self.mCrownView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 - image.size.width / 4, self.height / 2 - image.size.height / 4, image.size.width / 2, image.size.height / 2)];
    [self.mCrownView setImage:image];
    [self addSubview:self.mCrownView];
    
    
    image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_crown_light0.png"];
    self.mCrownLightView0 = [[UIImageView alloc] initWithFrame:CGRectMake(10, -20, image.size.width / 2, image.size.height / 2)];
    self.mCrownLightView0.center = CGPointMake(90, 10);
    [self.mCrownLightView0 setImage:image];
    [self.mCrownView addSubview:self.mCrownLightView0];
    self.mCrownLightView0.alpha = 0;
    
    
    
    image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_crown_light1.png"];
    self.mCrownLightView1 = [[UIImageView alloc] initWithFrame:CGRectMake(-40, 10, image.size.width / 2, image.size.height / 2)];
    self.mCrownLightView1.center = CGPointMake(50, 30);
    [self.mCrownLightView1 setImage:image];
    [self.mCrownView addSubview:self.mCrownLightView1];
    self.mCrownLightView1.alpha = 0;
    
    image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_crown_light2.png"];
    self.mCrownLightView2 = [[UIImageView alloc] initWithFrame:CGRectMake(100, 50, image.size.width / 2, image.size.height / 2)];
    self.mCrownLightView2.center = CGPointMake(150, 50);
    [self.mCrownLightView2 setImage:image];
    [self.mCrownView addSubview:self.mCrownLightView2];
    self.mCrownLightView2.alpha = 0;
    
    image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_crown_light3.png"];
    self.mCrownLightView3 = [[UIImageView alloc] initWithFrame:CGRectMake(150, 100, image.size.width / 2, image.size.height / 2)];
    self.mCrownLightView3.center = CGPointMake(170, 75);
    [self.mCrownLightView3 setImage:image];
    [self.mCrownView addSubview:self.mCrownLightView3];
    self.mCrownLightView3.alpha = 0;
    
    
    
    
    [self startAnimation];
}


- (void)setMNickName:(NSString *)mNickName {
    UILabel* nameLabel = [[UILabel alloc] init];
    nameLabel.text = mNickName;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.shadowColor = [UIColor yellowColor];
    [nameLabel sizeToFit];
    nameLabel.center = CGPointMake(self.width / 2, self.height / 2 - 150);
    [self addSubview:nameLabel];
}


#pragma mark - start

- (void)startAnimation {
    CGRect frame = self.mCrownView.frame;
    self.mCrownView.transform = CGAffineTransformMakeScale(0.3, 0.3);
    self.mCrownView.left = self.width;
    self.mCrownView.top = self.mCrownView.top - 50;
    [UIView animateWithDuration:1.5 animations:^{
        self.mCrownView.transform = CGAffineTransformMakeScale(1, 1);
        self.mCrownView.frame = frame;
    } completion:^(BOOL finished) {
        [self moveBackgroundAnimation];
        [self showLightAnimation];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showWingAnimation];
    });
    
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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

- (void)showLightAnimation {
    self.mCrownLightView0.alpha = 1;
    self.mCrownLightView1.alpha = 1;
    self.mCrownLightView2.alpha = 1;
    self.mCrownLightView3.alpha = 1;

    
    CAKeyframeAnimation *opacityAnimation;
    opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.values = @[@(0), @(1), @(0)];
    opacityAnimation.duration = 1.5;
    opacityAnimation.fillMode = kCAFillModeBoth;
    opacityAnimation.calculationMode = kCAAnimationCubic;
    opacityAnimation.repeatCount = HUGE_VALF;
    [self.mCrownLightView0.layer addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    opacityAnimation.beginTime = ESRandomNumber(1, 10) / 10.0;
    [self.mCrownLightView1.layer addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    opacityAnimation.beginTime = ESRandomNumber(1, 10) / 10.0;
    [self.mCrownLightView2.layer addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    opacityAnimation.beginTime = ESRandomNumber(1, 10) / 10.0;
    [self.mCrownLightView3.layer addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    
    
    
//    CABasicAnimation* rotationAnimation;
//    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
//    rotationAnimation.duration = 1;
//    rotationAnimation.cumulative = YES;
//    rotationAnimation.repeatCount = HUGE_VALF;
//    
//    [self.mCrownLightView0.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}


- (void)moveBackgroundAnimation {
    self.mCrownBackgroundView.alpha = 1;
    [UIView animateWithDuration:BACKGROUND_TIME animations:^{
        self.mCrownBackgroundView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    }];
    
    CAKeyframeAnimation *opacityAnimation;
    opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.values = @[@(1), @(0.5), @(1)];
    opacityAnimation.duration = 1;
    opacityAnimation.fillMode = kCAFillModeBoth;
    opacityAnimation.calculationMode = kCAAnimationCubic;
    opacityAnimation.repeatCount = HUGE_VALF;
    [self.mCrownBackgroundView.layer addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    

}

- (void)showWingAnimation {
    [UIView animateWithDuration:1 animations:^{
        self.mCrownWingRightView.alpha = self.mCrownWingLeftView.alpha = 1;
    }];
    [self playWingAnimation];
}

- (void)playWingAnimation {
    CAKeyframeAnimation *scaleAnimation;
    scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.values = @[@(1), @(1.1), @(1)];
    scaleAnimation.duration = 3;
    scaleAnimation.fillMode = kCAFillModeBoth;
    scaleAnimation.calculationMode = kCAAnimationCubic;
    scaleAnimation.repeatCount = HUGE_VALF;
    [self.mCrownWingLeftView.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    [self.mCrownWingRightView.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}


#pragma mark - end
- (void)callBackManager {
    [LuxuryManager luxuryManager].isShowAnimation = NO;
    [[LuxuryManager luxuryManager] showLuxuryAnimation];
}

@end