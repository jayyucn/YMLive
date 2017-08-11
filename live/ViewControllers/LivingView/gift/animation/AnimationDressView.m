//
//  AnimationDressView.m
//  qianchuo
//
//  Created by 林伟池 on 16/8/15.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "AnimationDressView.h"
#import "LuxuryManager.h"
#import "AnimationImageCache.h"
#import "LYRACDefine.h"

@interface AnimationDressView ()
@property (nonatomic , strong) UIImageView *mDressDressView;
@property (nonatomic , strong) UIImageView *mDressBottomView;
@property (nonatomic , strong) UIImageView *mDressLightView;

@property (nonatomic , strong) UIView *mDressBackgroundView;


@end

@implementation AnimationDressView


#define TOTAL_TIME 15
#define DARK_TIME 2
#define LIGHT_SHOW_TIME 0
#define FEATHER_TIME 5
#define START_FEATHER_TIME 3.5


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
    
    self.mDressBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.mDressBackgroundView.backgroundColor = [UIColor blackColor];
    self.mDressBackgroundView.alpha = 0;
    [self addSubview:self.mDressBackgroundView];
    
    UIImage *image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_dress_dress.png"];
    self.mDressDressView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - image.size.width / 2) / 2, (self.height - image.size.height / 2) / 2, image.size.width / 2, image.size.height / 2)];
    [self.mDressDressView setImage:image];
    self.mDressDressView.alpha = 0.0;
    [self addSubview:self.mDressDressView];
    
    
    image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_dress_bottom.png"];
    self.mDressBottomView = [[UIImageView alloc] initWithFrame:CGRectMake((self.mDressDressView.width - image.size.width / 2) / 2, self.mDressDressView.height - image.size.height / 4, image.size.width / 2, image.size.height / 2)];
    [self.mDressBottomView setImage:image];
    [self.mDressDressView addSubview:self.mDressBottomView];
    self.mDressBottomView.hidden = YES;
    
    
    image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_dress_light.png"];
     self.mDressLightView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - image.size.width / 2) / 2, 0, image.size.width / 2, image.size.height / 2)];
    [self.mDressLightView setImage:image];
    [self addSubview:self.mDressLightView];
    self.mDressLightView.hidden = YES;
    
    [self startAnimation];
}


- (void)setMNickName:(NSString *)mNickName {
    UILabel* nameLabel = [[UILabel alloc] init];
    nameLabel.text = mNickName;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.shadowColor = [UIColor yellowColor];
    [nameLabel sizeToFit];
    nameLabel.center = CGPointMake(self.width / 2, self.height / 2 + 150);
    [self addSubview:nameLabel];
}


#pragma mark - start

- (void)startAnimation {
    [UIView animateWithDuration:2.0 animations:^{
        self.mDressBackgroundView.alpha = 0.5;
    }];
    [UIView animateWithDuration:1.0 animations:^{
        self.mDressDressView.alpha = 0.1;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self playLightAnimation];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(START_FEATHER_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i = 0; i < (TOTAL_TIME - START_FEATHER_TIME - FEATHER_TIME) / 0.5; ++i) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self playFeatherAnimation];
            });
        }
    });
    

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(TOTAL_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
    self.mDressLightView.hidden = NO;
    self.mDressBottomView.hidden = NO;
    self.mDressDressView.alpha = 1;
    for (int i = 0; i < 3; ++i) {
        [self addStarAnimation];
    }
}

- (void)addStarAnimation {
    UIImage *leftImage = [[AnimationImageCache shareInstance] getImageWithName:[NSString stringWithFormat:@"gift_dress_star%d.png", arc4random_uniform(4)]]; // 选择一个star
    UIImage *rightImage = [[AnimationImageCache shareInstance] getImageWithName:[NSString stringWithFormat:@"gift_dress_star%d.png", arc4random_uniform(4)]]; // 选择一个star
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, leftImage.size.width / 2, leftImage.size.height / 2)];
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rightImage.size.width / 2, rightImage.size.height / 2)];
    leftImageView.left = self.mDressDressView.left - arc4random_uniform(50);
    leftImageView.top = self.mDressDressView.top - arc4random_uniform(50);
    rightImageView.left = self.mDressDressView.right - 40 + arc4random_uniform(50);
    rightImageView.top = self.mDressDressView.top - arc4random_uniform(50);
    leftImageView.image = leftImage;
    rightImageView.image = rightImage;
    leftImageView.layer.opacity = 0;
    rightImageView.layer.opacity = 0;
    [self addSubview:leftImageView];
    [self addSubview:rightImageView];
    CAKeyframeAnimation *opacityAnimation;
    opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.values = @[@(0), @(1), @(0)];
    opacityAnimation.duration = 1.5;
    opacityAnimation.fillMode = kCAFillModeBoth;
    opacityAnimation.calculationMode = kCAAnimationCubic;
    opacityAnimation.repeatCount = HUGE_VALF;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((arc4random_uniform(50) / 50.0) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [leftImageView.layer addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((arc4random_uniform(50) / 50.0) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [rightImageView.layer addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    });
}

- (void)playFeatherAnimation {
    
    UIImage *image = [[AnimationImageCache shareInstance] getImageWithName:[NSString stringWithFormat:@"gift_dress_feather%d.png", arc4random_uniform(6)]]; // 选择一个羽毛
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - image.size.width / 2) / 2, 0, image.size.width / 2, image.size.height / 2)];
    [imageView setImage:image];
    [self addSubview:imageView];
    
    CGPoint position = CGPointMake(self.width / 2, 10);
    
//    imageView.transform = CGAffineTransformMakeScale(0.01, 0.01);
//    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        imageView.transform = CGAffineTransformIdentity;
//    } completion:nil];
    
    CGFloat duration = 5 + arc4random() % 5;
    CAKeyframeAnimation *positionAnimate = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimate.repeatCount = 1;
    positionAnimate.duration = duration;
    positionAnimate.fillMode = kCAFillModeForwards;
    positionAnimate.removedOnCompletion = NO;
    
    UIBezierPath *sPath = [UIBezierPath bezierPath];
    [sPath moveToPoint:position];
    CGFloat sign = arc4random()%2 == 1 ? 1 : -1;
    CGFloat controlPointValue = (arc4random() % 50 + arc4random() % 100) * sign;
    [sPath addCurveToPoint:CGPointMake(ESRandomNumber(self.mDressDressView.left, self.mDressDressView.right), self.mDressDressView.bottom - 20) controlPoint1:CGPointMake(position.x - controlPointValue, position.y + 150) controlPoint2:CGPointMake(position.x + controlPointValue, position.y + 150)];
    positionAnimate.path = sPath.CGPath;
    [imageView.layer addAnimation:positionAnimate forKey:@"positionAnimate"];
    
    
    [UIView animateWithDuration:duration animations:^{
        imageView.layer.opacity = 0.5;
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
    }];
}

#pragma mark - end
- (void)callBackManager {
    [LuxuryManager luxuryManager].isShowAnimation = NO;
    [[LuxuryManager luxuryManager] showLuxuryAnimation];
}

@end