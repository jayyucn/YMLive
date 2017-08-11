//
//  AnimationCastleView.m
//  qianchuo
//
//  Created by 林伟池 on 16/10/19.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "AnimationCastleView.h"
#import "LYRACDefine.h"
#import "LuxuryManager.h"
#import "AnimationImageCache.h"

/*
 1、飞小气球、转花；
 2、大气球出现、云朵出现；
 3、上下云出现，城堡出现；
 4、热气球出现、小花出现；
 */

@interface AnimationCastleView ()

@end

@implementation AnimationCastleView

#define TOTAL_TIME 25
#define BOTTOM_CLOUD_LEFT_TAG 10
#define BOTTOM_CLOUD_RIGHT_TAG 20
#define CASTLE_VIEW_TAG 30


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
    
    
    
    [self startAnimation];
}

- (void)setMNickName:(NSString *)mNickName {
    UILabel* nameLabel = [[UILabel alloc] init];
    nameLabel.text = mNickName;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.shadowColor = [UIColor yellowColor];
    [nameLabel sizeToFit];
    nameLabel.center = CGPointMake(self.width / 2, self.height / 2 + 100);
    [self addSubview:nameLabel];
}


#pragma mark - start

- (void)startAnimation {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self playBalloonAnimation];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self playHotAirBalloonAnimation];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(9.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self playBallonFadeAnimation];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self playCastleAnimation];
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

/**
 *   飞小气球、转花；
 */
- (void)playBalloonAnimation {
    UIImageView *castleAnimationFlowerGreenView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 + 50, 150, 100, 100)];
    UIImageView *castleAnimationFlowerGreenView1 = [[UIImageView alloc] initWithFrame:castleAnimationFlowerGreenView.frame];
    [self addSubview:castleAnimationFlowerGreenView];
    [self addSubview:castleAnimationFlowerGreenView1];
    NSMutableArray<UIImage *> *images = [NSMutableArray<UIImage *> array];
    for (int i = 0; i < 15; ++i) {
        UIImage *img = [[AnimationImageCache shareInstance] getImageWithName:[NSString stringWithFormat:@"gift_castle_animation_flower_green%02d.png", i]];
        if (img) {
            [images addObject:img];
        }
    }
    castleAnimationFlowerGreenView1.animationImages = castleAnimationFlowerGreenView.animationImages = images;
    castleAnimationFlowerGreenView1.animationDuration = castleAnimationFlowerGreenView.animationDuration = 2;
    castleAnimationFlowerGreenView1.animationRepeatCount = castleAnimationFlowerGreenView.animationRepeatCount = 1;
    
    UIImageView *castleAnimationFlowerPurpleView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 - 150, 200, 100, 100)];
    UIImageView *castleAnimationFlowerPurpleView1 = [[UIImageView alloc] initWithFrame:castleAnimationFlowerPurpleView.frame];
    [self addSubview:castleAnimationFlowerPurpleView];
    [self addSubview:castleAnimationFlowerPurpleView1];
    images = [NSMutableArray<UIImage *> array];
    for (int i = 0; i < 15; ++i) {
        UIImage *img = [[AnimationImageCache shareInstance] getImageWithName:[NSString stringWithFormat:@"gift_castle_animation_flower_purple%02d.png", i]];
        if (img) {
            [images addObject:img];
        }
    }
    castleAnimationFlowerPurpleView1.animationImages = castleAnimationFlowerPurpleView.animationImages = images;
    castleAnimationFlowerPurpleView1.animationDuration = castleAnimationFlowerPurpleView.animationDuration = 2;
    castleAnimationFlowerPurpleView1.animationRepeatCount = castleAnimationFlowerPurpleView.animationRepeatCount = 1;

    castleAnimationFlowerGreenView1.left = castleAnimationFlowerPurpleView.left + 20;
    castleAnimationFlowerGreenView1.top = castleAnimationFlowerPurpleView.top + 200;
    castleAnimationFlowerPurpleView1.left = castleAnimationFlowerGreenView.left + 50;
    castleAnimationFlowerPurpleView1.top = castleAnimationFlowerGreenView.top + 220;
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [castleAnimationFlowerGreenView startAnimating];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [castleAnimationFlowerPurpleView startAnimating];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [castleAnimationFlowerGreenView1 startAnimating];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [castleAnimationFlowerPurpleView1 startAnimating];
    });
    
    UIImage *image = [[AnimationImageCache shareInstance] getImageWithName:[NSString stringWithFormat:@"gift_castle_balloon%d.png", arc4random_uniform(5)]];
    UIImageView *balloonView0 = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2, self.height, image.size.width / 2, image.size.height / 2)];
    [balloonView0 setImage:image];
    [self addSubview:balloonView0];
    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        balloonView0.bottom = 0;
        balloonView0.right = 0;
    } completion:^(BOOL finished) {
        [balloonView0 removeFromSuperview];
    }];
    
    image = [[AnimationImageCache shareInstance] getImageWithName:[NSString stringWithFormat:@"gift_castle_balloon%d.png", arc4random_uniform(5)]];
    UIImageView *balloonView1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 - 40, self.height, image.size.width / 2, image.size.height / 2)];
    [balloonView1 setImage:image];
    [self addSubview:balloonView1];
    [UIView animateWithDuration:2.0 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        balloonView1.bottom = 0;
        balloonView1.left = self.width;
    } completion:^(BOOL finished) {
        [balloonView1 removeFromSuperview];
    }];
    
    image = [[AnimationImageCache shareInstance] getImageWithName:[NSString stringWithFormat:@"gift_castle_balloon%d.png", arc4random_uniform(5)]];
    UIImageView *balloonView2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 - 50, self.height, image.size.width / 2, image.size.height / 2)];
    [balloonView2 setImage:image];
    [self addSubview:balloonView2];
    [UIView animateWithDuration:2.0 delay:2.0 options:UIViewAnimationOptionCurveLinear animations:^{
        balloonView2.bottom = 0;
        balloonView2.left = self.width / 2 + 50;
    } completion:^(BOOL finished) {
        [balloonView2 removeFromSuperview];
    }];
}





/**
 *   大气球出现、云朵出现；
 */
- (void)playHotAirBalloonAnimation {
    UIImageView *middleCloudView0 = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 - 110, self.height / 2 - 106, 221, 106)];
    middleCloudView0.alpha = 0;
    [middleCloudView0 setImage:[[AnimationImageCache shareInstance] getImageWithName:@"gift_castle_cloud_middle0.png"]];
    [self addSubview:middleCloudView0];
    [UIView animateWithDuration:2.0 animations:^{
        middleCloudView0.alpha = 1;
    }];
    
    UIImageView *centerAirHotBalloonView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 - 92, self.height, 185, 261)];
    [centerAirHotBalloonView setImage:[[AnimationImageCache shareInstance] getImageWithName:@"gift_castle_hot_air_balloon0.png"]];
    [self addSubview:centerAirHotBalloonView];
    [UIView animateWithDuration:1.5 delay:2.0 options:UIViewAnimationOptionCurveLinear animations:^{
        centerAirHotBalloonView.center = CGPointMake(self.width / 2, self.height / 2 - 100);
    } completion:nil];
    
    UIImageView *middleCloudView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 223, 113)];
    middleCloudView1.top = middleCloudView0.bottom;
    middleCloudView1.centerX = middleCloudView0.left;
    middleCloudView1.alpha = 0;
    [middleCloudView1 setImage:[[AnimationImageCache shareInstance] getImageWithName:@"gift_castle_cloud_middle1.png"]];
    [self addSubview:middleCloudView1];
    [UIView animateWithDuration:1.3 animations:^{
        middleCloudView1.alpha = 1;
    }];
    
    UIView *castleView = [[UIView alloc] initWithFrame:self.bounds];
    castleView.tag = CASTLE_VIEW_TAG;
    [self addSubview:castleView];
    
    UIImageView *middleCloudView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 223, 113)];
    middleCloudView2.top = middleCloudView0.bottom;
    middleCloudView2.centerX = middleCloudView0.right;
    middleCloudView2.alpha = 0;
    [middleCloudView2 setImage:[[AnimationImageCache shareInstance] getImageWithName:@"gift_castle_cloud_middle2.png"]];
    [self addSubview:middleCloudView2];
    [UIView animateWithDuration:1.3 animations:^{
        middleCloudView2.alpha = 1;
    }];
    
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            centerAirHotBalloonView.bottom += 5;
        } completion:^(BOOL finished) {
        }];
    });
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            centerAirHotBalloonView.bottom = 0;
        } completion:^(BOOL finished) {
            [centerAirHotBalloonView removeFromSuperview];
        }];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:20.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            middleCloudView0.left += 40;
            middleCloudView1.left += 45;
            middleCloudView2.left -= 50;
        } completion:^(BOOL finished) {
//            [middleCloudView0 removeFromSuperview];
//            [middleCloudView1 removeFromSuperview];
//            [middleCloudView2 removeFromSuperview];
        }];
    });
}

/**
 *   上下云出现，城堡出现；
 */
- (void)playBallonFadeAnimation {
    UIImageView *topCloudView0 = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, 115, 72)];
    topCloudView0.top = 40;
    topCloudView0.right = self.width - 10;
    topCloudView0.alpha = 0;
    [topCloudView0 setImage:[[AnimationImageCache shareInstance] getImageWithName:@"gift_castle_cloud_top0.png"]];
    [self addSubview:topCloudView0];
    [UIView animateWithDuration:1.0 animations:^{
        topCloudView0.alpha = 1;
    }];
    
    UIImageView *topCloudView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, 358, 117)];
    topCloudView1.top = topCloudView0.bottom - 20;
    topCloudView1.left = 10;
    topCloudView1.alpha = 0;
    [topCloudView1 setImage:[[AnimationImageCache shareInstance] getImageWithName:@"gift_castle_cloud_top1.png"]];
    [self addSubview:topCloudView1];
    [UIView animateWithDuration:1.5 animations:^{
        topCloudView1.alpha = 1;
    }];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:20.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            topCloudView0.left -= 50;
            topCloudView1.right += 50;
        } completion:^(BOOL finished) {
            
        }];
    });
    
    
    
    UIImageView *bottomCloudView0 = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, 185, 80)];
    bottomCloudView0.bottom = self.height - 130;
    bottomCloudView0.right = 0;
    [bottomCloudView0 setImage:[[AnimationImageCache shareInstance] getImageWithName:@"gift_castle_cloud_bottom0.png"]];
    [self addSubview:bottomCloudView0];
    bottomCloudView0.tag = BOTTOM_CLOUD_LEFT_TAG;
    
    UIImageView *bottomCloudView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, 231, 95)];
    bottomCloudView1.bottom = self.height - 100;
    bottomCloudView1.left = self.width;
    [bottomCloudView1 setImage:[[AnimationImageCache shareInstance] getImageWithName:@"gift_castle_cloud_bottom1.png"]];
    [self addSubview:bottomCloudView1];
    bottomCloudView1.tag = BOTTOM_CLOUD_RIGHT_TAG;
    
    
    [UIView animateWithDuration:1.0 animations:^{
        bottomCloudView0.right = self.width / 2 + 20;
        bottomCloudView1.left = self.width / 2 - 50;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:9.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            bottomCloudView0.top += 9;
            bottomCloudView1.top -= 8;
        } completion:^(BOOL finished) {
            
        }];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:8.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            bottomCloudView0.top -= 7;
            bottomCloudView1.top += 5;
        } completion:^(BOOL finished) {
            
        }];
    });
    
    
    
    
    UIImageView *castleView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 - 131, 0, 263, 301)];
    castleView.bottom = self.height - 150;
    castleView.alpha = 0;
    [castleView setImage:[[AnimationImageCache shareInstance] getImageWithName:@"gift_castle_castle.png"]];
    [[self viewWithTag:CASTLE_VIEW_TAG] addSubview:castleView];
    
    [UIView animateWithDuration:1.0 delay:1.5 options:UIViewAnimationOptionCurveLinear animations:^{
        castleView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}


/**
 *  热气球出现、小花出现；
 */
- (void)playCastleAnimation {
    UIImageView *bottomFlowerView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 - 170, self.height, 201, 78)];
    [bottomFlowerView setImage:[[AnimationImageCache shareInstance] getImageWithName:@"gift_castle_flower_bottom.png"]];
    [self addSubview:bottomFlowerView];
    
    [UIView animateWithDuration:2.0 delay:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        bottomFlowerView.bottom = self.height;
    } completion:^(BOOL finished) {
    }];
    
    UIImageView *cloudFlowerView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 15, 82, 54)];
    [cloudFlowerView setImage:[[AnimationImageCache shareInstance] getImageWithName:@"gift_castle_flower_blue.png"]];
    cloudFlowerView.alpha = 0;
    [[self viewWithTag:BOTTOM_CLOUD_LEFT_TAG] addSubview:cloudFlowerView];
    
    UIImageView *cloudFlowerView1 = [[UIImageView alloc] initWithFrame:CGRectMake(35, 15, 135, 56)];
    [cloudFlowerView1 setImage:[[AnimationImageCache shareInstance] getImageWithName:@"gift_castle_flower_purple.png"]];
    cloudFlowerView1.alpha = 0;
    [[self viewWithTag:BOTTOM_CLOUD_RIGHT_TAG] addSubview:cloudFlowerView1];
    
    [UIView animateWithDuration:1.0 delay:3.5 options:UIViewAnimationOptionCurveLinear animations:^{
        cloudFlowerView.alpha = 1;
        cloudFlowerView.top -= 5;
    } completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:1.0 delay:2.5 options:UIViewAnimationOptionCurveLinear animations:^{
        cloudFlowerView1.alpha = 1;
        cloudFlowerView1.top -= 5;
    } completion:^(BOOL finished) {
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIImage *image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_castle_hot_air_balloon3.png"];
        UIImageView *hotAirBalloonView0 = [[UIImageView alloc] initWithFrame:CGRectMake(50, 100, image.size.width / 2, image.size.height / 2)];
        [self addSubview:hotAirBalloonView0];
        [hotAirBalloonView0 setImage:image];
        // 飘动
        CGPoint position = CGPointMake(self.width, hotAirBalloonView0.top);
        CGFloat duration = 5;
        CAKeyframeAnimation *positionAnimate = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        positionAnimate.repeatCount = 1;
        positionAnimate.duration = duration;
        positionAnimate.fillMode = kCAFillModeForwards;
        positionAnimate.removedOnCompletion = NO;
        UIBezierPath *sPath = [UIBezierPath bezierPath];
        [sPath moveToPoint:position];
        [sPath addCurveToPoint:CGPointMake(-image.size.width / 2, position.y) controlPoint1:CGPointMake(self.width / 3 * 2, position.y - 60) controlPoint2:CGPointMake(self.width / 3, position.y + 60)];
        positionAnimate.path = sPath.CGPath;
        [hotAirBalloonView0.layer addAnimation:positionAnimate forKey:@"positionAnimate"];
        

    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIImage *image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_castle_hot_air_balloon1.png"];
        UIImageView *hotAirBalloonView1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - 150, 130, image.size.width / 2, image.size.height / 2)];
        [hotAirBalloonView1 setImage:image];
        [self addSubview:hotAirBalloonView1];
        // 飘动
        CGPoint position = CGPointMake(-image.size.width / 2, hotAirBalloonView1.top);
        CAKeyframeAnimation *positionAnimate = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        positionAnimate.repeatCount = 1;
        positionAnimate.duration = 5;
        positionAnimate.fillMode = kCAFillModeForwards;
        positionAnimate.removedOnCompletion = NO;
        UIBezierPath *sPath = [UIBezierPath bezierPath];
        [sPath moveToPoint:position];
        [sPath addCurveToPoint:CGPointMake(self.width + image.size.width / 2, position.y) controlPoint1:CGPointMake(self.width / 3, position.y - 60) controlPoint2:CGPointMake(self.width / 3 * 2, position.y + 60)];
        positionAnimate.path = sPath.CGPath;
        [hotAirBalloonView1.layer addAnimation:positionAnimate forKey:@"positionAnimate"];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIImage *image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_castle_hot_air_balloon2.png"];
        UIImageView *hotAirBalloonView2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 + 50, 200, image.size.width / 2, image.size.height / 2)];
        [hotAirBalloonView2 setImage:image];
        [self addSubview:hotAirBalloonView2];
        // 飘动
        CGPoint position = CGPointMake(self.width + image.size.width / 2, hotAirBalloonView2.top);
        CAKeyframeAnimation *positionAnimate = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        positionAnimate.repeatCount = 1;
        positionAnimate.duration = 4;
        positionAnimate.fillMode = kCAFillModeForwards;
        positionAnimate.removedOnCompletion = NO;
        UIBezierPath *sPath = [UIBezierPath bezierPath];
        [sPath moveToPoint:position];
        [sPath addCurveToPoint:CGPointMake(-image.size.width / 2, position.y) controlPoint1:CGPointMake(self.width / 4 * 3, position.y - 80) controlPoint2:CGPointMake(self.width / 4, position.y + 80)];
        positionAnimate.path = sPath.CGPath;
        [hotAirBalloonView2.layer addAnimation:positionAnimate forKey:@"positionAnimate"];
        

    });
    
    UIImage *image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_castle_rainbow0.png"];
    UIImageView *rainbowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.height / 2 - image.size.height / 2, self.width, image.size.height / 2)];
    rainbowView.image = image;
    [self addSubview:rainbowView];
    rainbowView.alpha = 0;
    [UIView animateWithDuration:1.0 delay:4.0 options:UIViewAnimationOptionCurveLinear animations:^{
        rainbowView.alpha = 1;
    } completion:nil];
    
    
    image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_castle_rainbow1.png"];
    UIImageView *rainbowView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width / 2, image.size.height / 2)];
    rainbowView1.right = [self viewWithTag:BOTTOM_CLOUD_RIGHT_TAG].right - 50;
    rainbowView1.bottom = [self viewWithTag:BOTTOM_CLOUD_RIGHT_TAG].top + 35;
    [rainbowView1 setImage:image];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(11.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addSubview:rainbowView1];
        UIBezierPath *maskStartPath = [UIBezierPath bezierPathWithRect:CGRectMake(CGRectGetWidth(rainbowView1.bounds), 0, CGRectGetWidth(rainbowView1.bounds), CGRectGetHeight(rainbowView1.bounds))];
        UIBezierPath *maskFinalPath = [UIBezierPath bezierPathWithRect:rainbowView1.bounds];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        rainbowView1.layer.mask = maskLayer;
        maskLayer.path = maskFinalPath.CGPath;
        CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        maskLayerAnimation.fromValue = (__bridge id)maskStartPath.CGPath;
        maskLayerAnimation.toValue = (__bridge id)maskFinalPath.CGPath;
        maskLayerAnimation.removedOnCompletion = NO;
        maskLayerAnimation.duration = 2.0;
        maskLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [maskLayer addAnimation:maskLayerAnimation forKey:@"maskLayerAnimation"];
    });
}


- (void)callBackManager {
    [LuxuryManager luxuryManager].isShowAnimation = NO;
    [[LuxuryManager luxuryManager] showLuxuryAnimation];
}

@end
