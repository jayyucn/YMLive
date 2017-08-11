//
//  AnimationMoonView.m
//  qianchuo
//
//  Created by 林伟池 on 16/8/30.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "AnimationMoonView.h"
#import "LuxuryManager.h"
#import "AnimationImageCache.h"
#import "LYRACDefine.h"

@interface AnimationMoonView ()
@property (nonatomic , strong) UIImageView *mMoonLandView;
@property (nonatomic , strong) UIImageView *mMoonLightView;
@property (nonatomic , strong) UIImageView *mMoonChairView;
@property (nonatomic , strong) UIImageView *mMoonLotusView;
@property (nonatomic , strong) UIImageView *mMoonBlinkView;
@property (nonatomic , strong) UIImageView *mMoonTreeView;
@property (nonatomic , strong) UIImageView *mMoonMoonView;
@property (nonatomic , strong) UIImageView *mMoonCloud0View;
@property (nonatomic , strong) UIImageView *mMoonCloud1View;
@property (nonatomic , strong) UIView *mMoonBackgroundView;

@property (nonatomic , strong) UIImageView *mMoonHead0View;
@property (nonatomic , strong) UIImageView *mMoonHead1View;
@end

@implementation AnimationMoonView

#define TOTAL_TIME 150
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
    
    self.mMoonBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.mMoonBackgroundView.backgroundColor = [UIColor blueColor];
    self.mMoonBackgroundView.alpha = 0;
    [self addSubview:self.mMoonBackgroundView];
    
    UIImage *image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_moon_land.png"];
    self.mMoonLandView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - image.size.width / 2) / 2, (self.height - image.size.height / 2) / 2, image.size.width / 2, image.size.height / 2)];
    [self.mMoonLandView setImage:image];
    self.mMoonLandView.hidden = YES;
    [self addSubview:self.mMoonLandView];
    
    image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_moon_chair.png"];
    self.mMoonChairView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 + 30, self.height / 2 - 35, image.size.width / 2, image.size.height / 2)];
    [self.mMoonChairView setImage:image];
    self.mMoonChairView.hidden = YES;
    [self addSubview:self.mMoonChairView];
    
    
    image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_moon_light.png"];
    self.mMoonLightView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 - 30, self.height / 2 - 35, image.size.width / 2, image.size.height / 2)];
    [self.mMoonLightView setImage:image];
    self.mMoonLightView.hidden = YES;
    [self addSubview:self.mMoonLightView];
    
    image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_moon_lotus.png"];
    self.mMoonLotusView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 - image.size.width / 2 - 40, self.height / 2 + 40, image.size.width / 2, image.size.height / 2)];
    [self.mMoonLotusView setImage:image];
    self.mMoonLotusView.hidden = YES;
    [self addSubview:self.mMoonLotusView];
    
    image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_moon_blink.png"];
    self.mMoonBlinkView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 - image.size.width / 2, self.height / 2, image.size.width / 2, image.size.height / 2)];
    [self.mMoonBlinkView setImage:image];
    self.mMoonBlinkView.hidden = YES;
    [self addSubview:self.mMoonBlinkView];
    
    image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_moon_moon.png"];
    self.mMoonMoonView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 - image.size.width / 4, self.height / 2, image.size.width / 2, image.size.height / 2)];
    [self.mMoonMoonView setImage:image];
    self.mMoonMoonView.bottom = self.mMoonLandView.top - 50;
    self.mMoonMoonView.hidden = YES;
    [self addSubview:self.mMoonMoonView];
    
    
    image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_moon_cloud0.png"];
    self.mMoonCloud0View = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 - image.size.width / 4 - 50, self.height / 2, image.size.width / 2, image.size.height / 2)];
    [self.mMoonCloud0View setImage:image];
    self.mMoonCloud0View.bottom = self.mMoonLandView.top - 30;
    self.mMoonCloud0View.hidden = YES;
    [self addSubview:self.mMoonCloud0View];
    
    image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_moon_cloud1.png"];
    self.mMoonCloud1View = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 - image.size.width / 4 + 50, self.height / 2, image.size.width / 2, image.size.height / 2)];
    [self.mMoonCloud1View setImage:image];
    self.mMoonCloud1View.bottom = self.mMoonCloud0View.top + 30;
    self.mMoonCloud1View.hidden = YES;
    [self addSubview:self.mMoonCloud1View];
    
    image = [[AnimationImageCache shareInstance] getImageWithName:@"gift_moon_tree.png"];
    self.mMoonTreeView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 - image.size.width / 2, self.height / 2, image.size.width / 2, image.size.height / 2)];
    [self.mMoonTreeView setImage:image];
    self.mMoonTreeView.right = self.mMoonLandView.right;
    self.mMoonTreeView.bottom = self.mMoonLandView.top + 40;
    self.mMoonTreeView.hidden = YES;
    [self addSubview:self.mMoonTreeView];

    
    self.mMoonHead0View = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.mMoonHead0View.center = CGPointMake(self.mMoonChairView.center.x - 30, self.mMoonChairView.center.y - 10);
    self.mMoonHead0View.layer.cornerRadius = 15;
    self.mMoonHead0View.layer.masksToBounds = YES;
    self.mMoonHead0View.hidden = YES;
    [self addSubview:self.mMoonHead0View];
    
    self.mMoonHead1View = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.mMoonHead1View.center = CGPointMake(self.mMoonChairView.center.x + 30, self.mMoonChairView.center.y - 10);
    self.mMoonHead1View.layer.cornerRadius = 15;
    self.mMoonHead1View.layer.masksToBounds = YES;
    self.mMoonHead1View.hidden = YES;
    [self addSubview:self.mMoonHead1View];
    
    [self startAnimation];
}

- (void)setMFace0:(NSString *)mFace0 {
    NSURL *url = [[NSURL alloc] initWithString:mFace0];
    [self.mMoonHead0View sd_setImageWithURL:url];
}

- (void)setMFace1:(NSString *)mFace1 {
    NSURL *url = [[NSURL alloc] initWithString:mFace1];
    [self.mMoonHead1View sd_setImageWithURL:url];
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
        self.mMoonBackgroundView.alpha = 0.1;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.mMoonLandView.hidden = NO;
        [self playLandAnimation];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self playLightAnimation];
    });
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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

- (void)playLandAnimation {
    UIBezierPath *maskStartPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 0, CGRectGetHeight(self.mMoonLandView.bounds))];
    UIBezierPath *maskFinalPath = [UIBezierPath bezierPathWithRect:self.mMoonLandView.bounds];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    self.mMoonLandView.layer.mask = maskLayer;
    maskLayer.path = maskFinalPath.CGPath;
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id)maskStartPath.CGPath;
    maskLayerAnimation.toValue = (__bridge id)maskFinalPath.CGPath;
    maskLayerAnimation.removedOnCompletion = NO;
    maskLayerAnimation.duration = 2.0;
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"maskLayerAnimation"];
}

- (void)playLightAnimation {
    self.mMoonChairView.alpha = .1;
    self.mMoonLightView.alpha = .1;
    self.mMoonLotusView.alpha = .1;
    self.mMoonBlinkView.alpha = .1;
    self.mMoonTreeView.alpha = .1;
    self.mMoonMoonView.alpha = .1;
    self.mMoonCloud0View.alpha = .1;
    self.mMoonCloud1View.alpha = .1;
    self.mMoonHead0View.alpha = .1;
    self.mMoonHead1View.alpha = .1;
    
    [UIView animateWithDuration:1.5 animations:^{
        self.mMoonChairView.alpha = 1;
        self.mMoonLightView.alpha = 1;
        self.mMoonLotusView.alpha = 1;
        self.mMoonBlinkView.alpha = 1;
        self.mMoonTreeView.alpha = 1;
        self.mMoonMoonView.alpha = 1;
        self.mMoonCloud0View.alpha = 1;
        self.mMoonCloud1View.alpha = 1;
        self.mMoonHead0View.alpha = 1;
        self.mMoonHead1View.alpha = 1;
        
        self.mMoonChairView.hidden = NO;
        self.mMoonLightView.hidden = NO;
        self.mMoonLotusView.hidden = NO;
        self.mMoonBlinkView.hidden = NO;
        self.mMoonTreeView.hidden = NO;
        self.mMoonMoonView.hidden = NO;
        self.mMoonCloud0View.hidden = NO;
        self.mMoonCloud1View.hidden = NO;
        self.mMoonHead0View.hidden = NO;
        self.mMoonHead1View.hidden = NO;
    } completion:^(BOOL finished) {
        [self  playCloudAnimation];
    }];
    
  
  
}

- (void)addStarAnimation {
}

- (void)playCloudAnimation {
    [UIView animateWithDuration:10.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.mMoonCloud0View.right += 100;
        self.mMoonCloud1View.right -= 150;
    } completion:nil];
    
}

- (void)callBackManager {
    [LuxuryManager luxuryManager].isShowAnimation = NO;
    [[LuxuryManager luxuryManager] showLuxuryAnimation];
}

@end