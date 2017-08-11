//
//  AnimationAngelView.m
//  qianchuo
//
//  Created by 林伟池 on 16/10/8.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//


#import "AnimationAngelView.h"
#import "LuxuryManager.h"
#import "AnimationImageCache.h"
#import "LYRACDefine.h"

/**
 1、黑暗背景；
 2、流星划过、月亮出现、云彩飘动；
 3、浮空岛出现；
 4、背光出现；
 5、天使出现、龙出现、星星闪烁；
 6、渐隐消失；
 */

@interface AnimationAngelView ()
@property (nonatomic , strong) UIImageView *mAngelBackgroundView;

@property (nonatomic , strong) UIImageView *mAngelMoonView;
@property (nonatomic , strong) UIImageView *mAngelCloudView0;
@property (nonatomic , strong) UIImageView *mAngelCloudView1;
@property (nonatomic , strong) UIImageView *mAngelCloudView2;
@property (nonatomic , strong) UIImageView *mAngelCloudView3;
@property (nonatomic , strong) UIImageView *mAngelCloudView4;
@property (nonatomic , strong) UIImageView *mAngelCloudView5;


@property (nonatomic , strong) UIView *mAngelMeteorView;

@property (nonatomic , strong) UIImageView *mAngelLightView;
@property (nonatomic , strong) UIImageView *mAngelWingView;

@property (nonatomic , strong) UIImageView *mAngelLandView0;
@property (nonatomic , strong) UIImageView *mAngelLandView1;
@property (nonatomic , strong) UIImageView *mAngelLandView2;

@property (nonatomic , strong) UIImageView *mAngelStarView0;
@property (nonatomic , strong) UIImageView *mAngelStarView1;

@property (nonatomic , strong) UIImageView *mAngelPhoenixView;
@end

@implementation AnimationAngelView

#define TOTAL_TIME 20


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
    
    self.mAngelBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.mAngelBackgroundView.image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_angel_background.png"];
    self.mAngelBackgroundView.alpha = 0;
    [self addSubview:self.mAngelBackgroundView];
    
    self.mAngelMeteorView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.mAngelMeteorView];
    
    UIImage *image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_angel_moon.png"];
    self.mAngelMoonView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width), -75, image.size.width / 2, image.size.height / 2)];
    [self.mAngelMoonView setImage:image];
    self.mAngelMoonView.hidden = YES;
    [self addSubview:self.mAngelMoonView];
    
    // Cloud
    image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_angel_cloud0.png"];
    self.mAngelCloudView0 = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2, 150, image.size.width / 2, image.size.height / 2)];
    [self.mAngelCloudView0 setImage:image];
    [self addSubview:self.mAngelCloudView0];
    image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_angel_cloud1.png"];
    self.mAngelCloudView1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 - 200, 125, image.size.width / 2, image.size.height / 2)];
    [self.mAngelCloudView1 setImage:image];
    [self addSubview:self.mAngelCloudView1];
    image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_angel_cloud2.png"];
    self.mAngelCloudView2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 + 20, 50, image.size.width / 2, image.size.height / 2)];
    [self.mAngelCloudView2 setImage:image];
    [self addSubview:self.mAngelCloudView2];
    image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_angel_cloud3.png"];
    self.mAngelCloudView3 = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 + 100, 100, image.size.width / 2, image.size.height / 2)];
    [self.mAngelCloudView3 setImage:image];
    [self addSubview:self.mAngelCloudView3];
    image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_angel_cloud4.png"];
    self.mAngelCloudView4 = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 - 50, 50, image.size.width / 2, image.size.height / 2)];
    [self.mAngelCloudView4 setImage:image];
    [self addSubview:self.mAngelCloudView4];
    image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_angel_cloud0.png"];
    self.mAngelCloudView5 = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 - 25 , 100, image.size.width / 2, image.size.height / 2)];
    [self.mAngelCloudView5 setImage:image];
    [self addSubview:self.mAngelCloudView5];
    
    // 90 270
    image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_angel_land1.png"];
    self.mAngelLandView1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 - 120 - image.size.width / 4, self.height - 260 - image.size.height / 4, image.size.width / 2, image.size.height / 2)];
    [self.mAngelLandView1 setImage:image];
    [self addSubview:self.mAngelLandView1];
    self.mAngelLandView1.alpha = 0.6;
    
    image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_angel_land2.png"];
    self.mAngelLandView2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 + 110 - image.size.width / 4, self.height - 280 - image.size.height / 4, image.size.width / 2, image.size.height / 2)];
    [self.mAngelLandView2 setImage:image];
    [self addSubview:self.mAngelLandView2];
    self.mAngelLandView2.alpha = 0.6;
    
    image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_angel_land0.png"];
    self.mAngelLandView0 = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 - image.size.width / 4, self.height, image.size.width / 2, image.size.height / 2)];
    [self.mAngelLandView0 setImage:image];
    self.mAngelStarView0.alpha = 0.6;
    [self addSubview:self.mAngelLandView0];
    
    
    image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_angel_light.png"];
    self.mAngelLightView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 - image.size.width / 4, -30, image.size.width / 2, image.size.height / 2)];
    [self.mAngelLightView setImage:image];
    [self addSubview:self.mAngelLightView];
    
    image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_angel_star.png"];
    self.mAngelStarView0 = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 - image.size.width / 4 - 100, 70, image.size.width / 2, image.size.height / 2)];
    [self.mAngelStarView0 setImage:image];
    [self addSubview:self.mAngelStarView0];
    
    image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_angel_star.png"];
    self.mAngelStarView1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 - image.size.width / 4 + 100, 200, image.size.width / 2, image.size.height / 2)];
    [self.mAngelStarView1 setImage:image];
    [self addSubview:self.mAngelStarView1];
    
    
    self.mAngelStarView0.hidden = YES;
    self.mAngelStarView1.hidden = YES;
    
    self.mAngelLightView.hidden = YES;
    
    self.mAngelLandView0.hidden = YES;
    self.mAngelLandView1.hidden = YES;
    self.mAngelLandView2.hidden = YES;
    
    self.mAngelCloudView0.hidden = YES;
    self.mAngelCloudView1.hidden = YES;
    self.mAngelCloudView2.hidden = YES;
    self.mAngelCloudView3.hidden = YES;
    self.mAngelCloudView4.hidden = YES;
    self.mAngelCloudView5.hidden = YES;
    
    
    
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
    [UIView animateWithDuration:1.5 animations:^{
        self.mAngelBackgroundView.alpha = 0.5;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self playMeteorAnimation];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self playLandAnimation];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self playLightAnimation];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self playStarAnimation];
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
 *   2、流星划过、月亮出现、云彩飘动
 */
- (void)playMeteorAnimation {
    self.mAngelMoonView.hidden = NO;
    [UIView animateWithDuration:2.0 animations:^{
        [self.mAngelMoonView setFrame:CGRectMake(self.width - 100, -30, 177, 140)];
    }];
    
    self.mAngelCloudView0.hidden = NO;
    self.mAngelCloudView1.hidden = NO;
    self.mAngelCloudView2.hidden = NO;
    self.mAngelCloudView3.hidden = NO;
    self.mAngelCloudView4.hidden = NO;
    self.mAngelCloudView5.hidden = NO;
    
    [UIView animateWithDuration:TOTAL_TIME + 5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.mAngelCloudView0.right += 250;
        self.mAngelCloudView1.right += 190;
        self.mAngelCloudView2.right += 150;
        self.mAngelCloudView3.right -= 180;
        self.mAngelCloudView4.right -= 230;
        self.mAngelCloudView5.right -= 200;
        
    } completion:nil];
    for (int i = 0; i < 20; ++i) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((i * 1.0) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self addOneMeteorWithSourcePoint:CGPointMake(arc4random_uniform(100) + (i % 2) * 200 + self.width, -170)];
        });
    }
}

- (void)addOneMeteorWithSourcePoint:(CGPoint)sourcePoint {
    UIImage *image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_angel_meteor.png"];
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width / 2, image.size.height / 2)];
    [imageView setImage:image];
    [self.mAngelMeteorView addSubview:imageView];
    imageView.center = sourcePoint;
    float scale = arc4random_uniform(5) * 0.1 + 0.5;
    imageView.transform = CGAffineTransformMakeScale(scale, scale);
    [UIView animateWithDuration:2 + scale delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        imageView.center = CGPointMake(-250, sourcePoint.x + 250 - 170);
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
    }];
    
}



/**
 *   3、浮空岛出现
 */
- (void)playLandAnimation {
    self.mAngelLandView0.hidden = NO;
    self.mAngelLandView1.hidden = NO;
    self.mAngelLandView2.hidden = NO;
    
    
    CAKeyframeAnimation *upDownAnimation;
    upDownAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
    upDownAnimation.values = @[@(self.mAngelLandView1.layer.position.y), @(self.mAngelLandView1.layer.position.y + 5), @(self.mAngelLandView1.layer.position.y)];
    upDownAnimation.duration = 2;
    upDownAnimation.fillMode = kCAFillModeBoth;
    upDownAnimation.calculationMode = kCAAnimationCubic;
    upDownAnimation.repeatCount = HUGE_VALF;
    [self.mAngelLandView1.layer addAnimation:upDownAnimation forKey:@"upDownAnimation"];
    
    upDownAnimation.values = @[@(self.mAngelLandView2.layer.position.y), @(self.mAngelLandView2.layer.position.y - 3), @(self.mAngelLandView2.layer.position.y)];
    [self.mAngelLandView2.layer addAnimation:upDownAnimation forKey:@"upDownAnimation"];
    
    [UIView animateWithDuration:3 animations:^{
        self.mAngelLandView0.top -= 270;
    } completion:^(BOOL finished) {
        upDownAnimation.values = @[@(self.mAngelLandView0.layer.position.y), @(self.mAngelLandView0.layer.position.y + 5), @(self.mAngelLandView0.layer.position.y)];
        [self.mAngelLandView0.layer addAnimation:upDownAnimation forKey:@"upDownAnimation"];
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.mAngelPhoenixView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 - 60, self.height - 370, 106, 126)];
            [self addSubview:self.mAngelPhoenixView];
            NSMutableArray<UIImage *> *images = [NSMutableArray<UIImage *> array];
            for (int i = 0; i < 15; ++i) {
                UIImage *img = [[AnimationImageCache shareInstance] getImageWithName:[NSString stringWithFormat:@"gift_angel_phoenix%02d.png", i]];
                if (img) {
                    [images addObject:img];
                }
            }
            self.mAngelPhoenixView.animationImages = images;
            self.mAngelPhoenixView.animationDuration = 3;
            self.mAngelPhoenixView.animationRepeatCount = 1;
            [self.mAngelPhoenixView startAnimating];
        });
        
//        UIImage *image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_angel_stone0.png"];
//        UIImageView *stoneImageView0 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, image.size.width / 2, image.size.height / 2)];
//        [stoneImageView0 setImage:image];
//        
//        
//        image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_angel_stone4.png"];
//        UIImageView *stoneImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, image.size.width / 2, image.size.height / 2)];
//        [stoneImageView1 setImage:image];
//        
//        image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_angel_stone3.png"];
//        UIImageView *stoneImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(200, 100, image.size.width / 2, image.size.height / 2)];
//        [stoneImageView1 setImage:image];
//        
//        
//        [self.mAngelLandView0 addSubview:stoneImageView0];
//        [self.mAngelLandView0 addSubview:stoneImageView1];
//        [self.mAngelLandView0 addSubview:stoneImageView2];
//        [UIView animateWithDuration:2.0 animations:^{
//            stoneImageView0.top += 100;
//            stoneImageView1.top += 100;
//        }];
    }];
}

/**
 *   4、背光出现；
 */
- (void)playLightAnimation {
    self.mAngelLightView.hidden = NO;
}


/**
 *  5、天使出现、龙出现、星星闪烁
 */
- (void)playStarAnimation {
    self.mAngelWingView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 - 100, -130, 203, 140)];
    [self addSubview:self.mAngelWingView];
    NSMutableArray<UIImage *> *images = [NSMutableArray<UIImage *> array];
    for (int i = 0; i < 10; ++i) {
        UIImage *img = [[AnimationImageCache shareInstance] getImageWithName:[NSString stringWithFormat:@"gift_angel_wing%d.png", i >= 5 ? 9 - i : i]];
        if (img) {
            [images addObject:img];
        }
    }
    self.mAngelWingView.animationImages = images;
    self.mAngelWingView.animationDuration = 1.3;
    [self.mAngelWingView startAnimating];
    
    
    UIImage *image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_angel_angel.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.mAngelWingView.width / 2 - image.size.width / 4 + 5, 60, image.size.width / 2, image.size.height / 2)];
    [imageView setImage:image];
    [self.mAngelWingView addSubview:imageView];
    
//    self.mAngelWingView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:4.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.mAngelWingView.top += 250;
        self.mAngelWingView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        
    }];
    
    self.mAngelStarView0.hidden = NO;
    self.mAngelStarView1.hidden = NO;
    
    CAKeyframeAnimation *opacityAnimation;
    opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.values = @[@(0), @(1), @(0)];
    opacityAnimation.duration = 1.5;
    opacityAnimation.fillMode = kCAFillModeBoth;
    opacityAnimation.calculationMode = kCAAnimationCubic;
    opacityAnimation.repeatCount = HUGE_VALF;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((0.75) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.mAngelStarView0.layer addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    });
    
    [self.mAngelStarView1.layer addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}

/**
 *  6、渐隐消失
 */
- (void)playFadeAnimation {
    
}

- (void)callBackManager {
    [LuxuryManager luxuryManager].isShowAnimation = NO;
    [[LuxuryManager luxuryManager] showLuxuryAnimation];
}

@end
