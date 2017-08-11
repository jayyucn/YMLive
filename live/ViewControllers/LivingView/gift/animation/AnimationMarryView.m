//
//  AnimationMarryView.m
//  qianchuo
//
//  Created by 林伟池 on 16/5/13.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "AnimationMarryView.h"
#import "LuxuryManager.h"

@interface AnimationMarryView ()
@property (nonatomic , strong) UIImageView* mLightHeadView;
@property (nonatomic , strong) UIView* mFlowerView;
@property (nonatomic , strong) UIImageView* mHeartView;
@property (nonatomic , strong) UIImageView* mHeartBorderView;
@property (nonatomic , strong) UIImageView* mLightLeftView;
@property (nonatomic , strong) UIImageView* mLightRightView;
@property (nonatomic , strong) UIImageView* mMarryPeopleView;
@property (nonatomic , strong) UIImageView* mMarryStarView;

@property (nonatomic , strong) NSTimer* mTimer;
@end

#define const_total_time 20.0
#define const_flower_height 900
#define const_bubble_offset 100
#define const_light_offset 50


@implementation AnimationMarryView


- (void)setMNickName:(NSString *)mNickName {
    UILabel* nameLabel = [[UILabel alloc] init];
    nameLabel.text = mNickName;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.shadowColor = [UIColor yellowColor];
    [nameLabel sizeToFit];
    nameLabel.center = CGPointMake(ScreenWidth / 2, 100);
    [self addSubview:nameLabel];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.mLightHeadView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 2275 / 3,  2275 / 3)];
    self.mLightHeadView.center = CGPointMake(ScreenWidth / 2, -50);
    NSString *mainBundle = [[NSBundle mainBundle] bundlePath];
    NSString *light_head =  [mainBundle stringByAppendingString:@"/image/animation/gift_marry_light_head.png"];
    [self.mLightHeadView setImage:[UIImage imageWithContentsOfFile:light_head]];
    [self addSubview:self.mLightHeadView];
    self.mFlowerView = [[UIView alloc] initWithFrame:CGRectMake(0, -const_flower_height * 2, ScreenWidth, const_flower_height * 2)];
    UIImageView* flowerImageView0 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, const_flower_height)];
    UIImageView* flowerImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, const_flower_height, ScreenWidth, const_flower_height)];
    [flowerImageView0 setImage:[UIImage imageWithContentsOfFile:[mainBundle stringByAppendingString:@"/image/animation/gift_marry_flower"]]];
    [flowerImageView1 setImage:[UIImage imageWithContentsOfFile:[mainBundle stringByAppendingString:@"/image/animation/gift_marry_flower"]]];
    [self addSubview:self.mFlowerView];
    [self.mFlowerView addSubview:flowerImageView0];
    [self.mFlowerView addSubview:flowerImageView1];
    
    self.mHeartView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - 680 / 6, ScreenHeight / 2 - 605 / 6, 680 / 3, 605 / 3)];
    self.mHeartView.hidden = YES;
    [self.mHeartView setImage:[UIImage imageWithContentsOfFile:[mainBundle stringByAppendingString:@"/image/animation/gift_marry_heart0"]]];
    [self addSubview:self.mHeartView];
    
    self.mHeartBorderView = [[UIImageView alloc] initWithFrame:self.mHeartView.bounds];
    self.mHeartBorderView.hidden = YES;
    self.mHeartBorderView.animationImages = @[[UIImage imageWithContentsOfFile:[mainBundle stringByAppendingString:@"/image/animation/gift_marry_heart1"]],
                                              [UIImage imageWithContentsOfFile:[mainBundle stringByAppendingString:@"/image/animation/gift_marry_heart2"]],
                                              [UIImage imageWithContentsOfFile:[mainBundle stringByAppendingString:@"/image/animation/gift_marry_heart3"]]];
    self.mHeartBorderView.animationRepeatCount = -1;
    self.mHeartBorderView.animationDuration = 1.0;
    [self.mHeartBorderView startAnimating];
    [self.mHeartView addSubview:self.mHeartBorderView];
    
    // marry people
    self.mMarryPeopleView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - 685 / 6, ScreenHeight / 2 - 835 / 6, 685 / 3, 835 / 3)];
    [self.mMarryPeopleView setImage:[UIImage imageWithContentsOfFile:[mainBundle stringByAppendingString:@"/image/animation/gift_marry_people"]]];
    self.mMarryPeopleView.hidden = YES;
    [self addSubview:self.mMarryPeopleView];
    
    self.mMarryStarView = [[UIImageView alloc] initWithFrame:self.mMarryPeopleView.bounds];
    self.mMarryStarView.hidden = YES;
    self.mMarryStarView.animationImages = @[[UIImage imageWithContentsOfFile:[mainBundle stringByAppendingString:@"/image/animation/gift_marry_star1"]],
                                              [UIImage imageWithContentsOfFile:[mainBundle stringByAppendingString:@"/image/animation/gift_marry_star2"]]];
    self.mMarryStarView.animationRepeatCount = -1;
    self.mMarryStarView.animationDuration = 0.8;
    [self.mMarryStarView startAnimating];
    [self.mMarryPeopleView addSubview:self.mMarryStarView];
    
    // left light
    self.mLightLeftView = [[UIImageView alloc] init];
    self.mLightLeftView.layer.anchorPoint = CGPointMake(0.5, 1);
    self.mLightLeftView.frame = CGRectMake(- ScreenWidth / 2 - 10, -const_light_offset, ScreenWidth / 2, ScreenHeight + const_light_offset);
    [self.mLightLeftView setImage:[UIImage imageWithContentsOfFile:[mainBundle stringByAppendingString:@"/image/animation/gift_marry_light_blue"]]];
    self.mLightLeftView.hidden = YES;
    [self addSubview:self.mLightLeftView];
    
    // right light
    self.mLightRightView = [[UIImageView alloc] init];
    self.mLightRightView.layer.anchorPoint = CGPointMake(0.5, 1);
    self.mLightRightView.frame = CGRectMake(ScreenWidth / 4 * 5 + 10, -const_light_offset, ScreenWidth / 2, ScreenHeight + const_light_offset);
    [self.mLightRightView setImage:[UIImage imageWithContentsOfFile:[mainBundle stringByAppendingString:@"/image/animation/gift_marry_light_purple"]]];
    self.mLightRightView.hidden = YES;
    [self addSubview:self.mLightRightView];
    
    
    [self startAnimation];
    return self;
}

- (void)dealloc
{
    NSLog(@"gift dealloc %@",NSStringFromClass(self.class));
}

- (void)startAnimation {
    [self headLightRotate];
    [self flowerFly];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(const_total_time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self.mTimer invalidate];
            [self removeFromSuperview];
            [LuxuryManager luxuryManager].isShowAnimation = NO;
            [[LuxuryManager luxuryManager] showLuxuryAnimation];
        }];
    });
}

- (void)headLightRotate {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = const_total_time / 4;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    
    [self.mLightHeadView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)flowerFly {
    [UIView animateWithDuration:8.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.mFlowerView.top = 0;
    } completion:^(BOOL finished) {
        self.mFlowerView.hidden = YES;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:2.0 animations:^{
            self.mFlowerView.alpha = 0;
        }];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self heartAppear];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self bubbleFly];
        });
    });
}

- (void)heartAppear {
    self.mHeartView.transform = CGAffineTransformMakeScale(0, 0);
    self.mHeartView.hidden = NO;
    [UIView animateWithDuration:1.5 animations:^{
        self.mHeartView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        self.mHeartBorderView.hidden = NO;
        [self leftLightAnimation];
        [self rightLightAnimation];
        // 灯光出现后等会出现人放大的动画
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.mMarryPeopleView.hidden = NO;
            self.mMarryPeopleView.transform = CGAffineTransformMakeScale(0, 0);
            [UIView animateWithDuration:1.0 animations:^{
                self.mMarryPeopleView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                self.mMarryStarView.hidden = NO;
            }];
        });
    }];
}

- (void)leftLightAnimation {
    self.mLightLeftView.hidden = NO;
    CAKeyframeAnimation* rotationAnimation;
    rotationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.values = @[@(M_PI / 12), @(M_PI / 3), @(M_PI / 12)];
    rotationAnimation.duration = 2.5;
    rotationAnimation.fillMode = kCAFillModeBoth;
    rotationAnimation.calculationMode = kCAAnimationCubic;
    //    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    
    [self.mLightLeftView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)rightLightAnimation {
    self.mLightRightView.hidden = NO;
    CAKeyframeAnimation* rotationAnimation;
    rotationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.values = @[@(-M_PI / 12), @(-M_PI / 3), @(-M_PI / 12)];
    rotationAnimation.duration = 2.3;
    rotationAnimation.fillMode = kCAFillModeBoth;
    rotationAnimation.calculationMode = kCAAnimationCubic;
    //    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    
    [self.mLightRightView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)bubbleFly {
    if (self.mTimer == nil) {
        self.mTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(bubbleFly) userInfo:nil repeats:YES];
    }
    
    NSString* imageName = [NSString stringWithFormat:@"gift_marry_bubble%ld",random() % 7 + 1];
    UIImageView* animateView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 49, 48)];
    
    CGPoint centerPoint;
    static int count = 0;
    if (++count % 2) { // 左
        centerPoint = CGPointMake(const_bubble_offset, ScreenHeight - const_bubble_offset);
    }
    else { // 右
        centerPoint = CGPointMake(ScreenWidth - const_bubble_offset, ScreenHeight - const_bubble_offset);
    }
//    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:imageName];
    animateView.image = [UIImage imageNamed:imageName];
    animateView.center = centerPoint;
    [self addSubview:animateView];
    
    [UIView animateWithDuration:3 animations:^{
        int x = arc4random() % 10 + 3;
        int t = 0;
        if (x % 2 == 0) {
            t = x * 5;
        } else {
            t = - (x * 5);
        }
        animateView.center = CGPointMake(animateView.center.x + t, ScreenHeight / 4);
        animateView.alpha = 0;
    } completion:^(BOOL finish) {
        [animateView removeFromSuperview];
    }];
}

@end
