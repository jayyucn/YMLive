//
//  DriveHorseView.m
//  qianchuo
//
//  Created by 林伟池 on 16/9/20.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "DriveHorseView.h"
#import "AnimationImageCache.h"
#import "LYRACDefine.h"

@interface DriveHorseView ()
@property (nonatomic , strong) UIImageView *mDriveHorseView;
@property (nonatomic , strong) UIImageView *mDriveEffectView;
@end


@implementation DriveHorseView


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
    
    
    self.mDriveHorseView = [[UIImageView alloc] initWithFrame:CGRectMake(-200, (self.height - 200) / 2, 200, 200)];
    [self addSubview:self.mDriveHorseView];
    
    [self startAnimation];
}


- (void)setMNickName:(NSString *)mNickName {
    UILabel* nameLabel = [[UILabel alloc] init];
    nameLabel.text = mNickName;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.shadowColor = [UIColor yellowColor];
    [nameLabel sizeToFit];
    nameLabel.center = CGPointMake(self.mDriveHorseView.width / 2, self.mDriveHorseView.height / 2 - 100);
    [self.mDriveHorseView addSubview:nameLabel];
}


#pragma mark - start


#define MOVE_TIME  3
#define RUB_TIME 0.7
#define STOP_TIME 0.5
#define EFFECT_TIME 3
#define WAVE_TIME 1.0
#define TOTOAL_TIME (MOVE_TIME + STOP_TIME  + EFFECT_TIME)

- (void)startAnimation {
    NSMutableArray<UIImage *> *images = [NSMutableArray<UIImage *> array];
    for (int i = 0; i < 11; ++i) {
        UIImage *img = [[AnimationImageCache shareInstance] getDriveImageWithName:[NSString stringWithFormat:@"drive_horse_run%02d.png", i]];
        if (img) {
            [images addObject:img];
        }
    }
    self.mDriveHorseView.animationImages = images;
    self.mDriveHorseView.animationDuration = (MOVE_TIME - RUB_TIME - STOP_TIME) / 4;
    [self.mDriveHorseView startAnimating];
    
    
    
    [UIView animateWithDuration:MOVE_TIME delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.mDriveHorseView.left = self.width / 2 - 100;
    } completion:^(BOOL finished) {
        [self playLightAnimation];
    }];
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((MOVE_TIME - RUB_TIME) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 刹车
        
        NSMutableArray<UIImage *> *images = [NSMutableArray<UIImage *> array];
        for (int i = 0; i < 2; ++i) {
            UIImage *img = [[AnimationImageCache shareInstance] getDriveImageWithName:[NSString stringWithFormat:@"drive_horse_rub0%d.png", i]];
            if (img) {
                [images addObject:img];
            }
        }
        self.mDriveHorseView.animationImages = images;
        self.mDriveHorseView.animationDuration = RUB_TIME / 2;
        [self.mDriveHorseView startAnimating];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((MOVE_TIME - 0.3) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 前倾
        
        NSMutableArray<UIImage *> *images = [NSMutableArray<UIImage *> array];
        for (int i = 0; i < 6; ++i) {
            UIImage *img = [[AnimationImageCache shareInstance] getDriveImageWithName:[NSString stringWithFormat:@"drive_horse_stop0%d.png", i]];
            if (img) {
                [images addObject:img];
            }
        }
        self.mDriveHorseView.image = [[AnimationImageCache shareInstance] getDriveImageWithName:@"drive_horse_stop05.png"];
        self.mDriveHorseView.animationImages = images;
        self.mDriveHorseView.animationDuration = STOP_TIME;
        self.mDriveHorseView.animationRepeatCount = 1;
        [self.mDriveHorseView startAnimating];
    });
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((TOTOAL_TIME - 0.5) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 招手
        
        NSMutableArray<UIImage *> *images = [NSMutableArray<UIImage *> array];
        for (int i = 0; i < 2; ++i) {
            UIImage *img = [[AnimationImageCache shareInstance] getDriveImageWithName:[NSString stringWithFormat:@"drive_horse_wave0%d.png", i]];
            if (img) {
                [images addObject:img];
            }
        }
        self.mDriveHorseView.animationImages = images;
        self.mDriveHorseView.animationDuration = RUB_TIME / 2;
        self.mDriveHorseView.animationRepeatCount = 0;
        [self.mDriveHorseView startAnimating];
        
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((TOTOAL_TIME + WAVE_TIME) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 跑到外面
        
        NSMutableArray<UIImage *> *images = [NSMutableArray<UIImage *> array];
        for (int i = 0; i < 11; ++i) {
            UIImage *img = [[AnimationImageCache shareInstance] getDriveImageWithName:[NSString stringWithFormat:@"drive_horse_run%02d.png", i]];
            if (img) {
                [images addObject:img];
            }
        }
        self.mDriveHorseView.animationImages = images;
        self.mDriveHorseView.animationDuration = (MOVE_TIME - RUB_TIME - STOP_TIME) / 4;
        self.mDriveHorseView.animationRepeatCount = 0;
        [self.mDriveHorseView startAnimating];
        
        
        @weakify(self);
        [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            @strongify(self);
            self.mDriveHorseView.left = self.width;
        } completion:^(BOOL finished) {
            @strongify(self);
            [self endAnimation];
        }];
        
        //        @weakify(self);
        //        [UIView animateWithDuration:0.5 animations:^{
        //            self.alpha = 0;
        //        } completion:^(BOOL finished) {
        //            @strongify(self);
        //            [self removeFromSuperview];
        //            [self callBackManager];
        //        }];
    });
    
}

- (void)playLightAnimation {
    
    NSMutableArray<UIImage *> *images = [NSMutableArray<UIImage *> array];
    for (int i = 0; i < 24; ++i) {
        UIImage *img = [[AnimationImageCache shareInstance] getDriveImageWithName:[NSString stringWithFormat:@"drive_effect%02d.png", i]];
        if (img) {
            [images addObject:img];
        }
    }
    //    self.mDriveHorseView.image = [[AnimationImageCache shareInstance] getDriveImageWithName:@"drive_horse_stop05.png"];
    UIImageView *effectView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 400)];
    effectView.bottom = self.mDriveHorseView.bottom + 50;
    effectView.left = self.mDriveHorseView.left;
    
    effectView.animationImages = images;
    effectView.animationDuration = EFFECT_TIME;
    effectView.animationRepeatCount = 1;
    [effectView startAnimating];
    [self addSubview:effectView];    
}


#pragma mark - end


@end