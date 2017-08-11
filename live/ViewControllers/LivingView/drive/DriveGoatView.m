//
//  DriveGoatView.m
//  qianchuo
//
//  Created by 林伟池 on 16/9/23.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "DriveGoatView.h"
#import "AnimationImageCache.h"
#import "LYRACDefine.h"

@interface DriveGoatView ()
@property (nonatomic , strong) UIImageView *mDriveGoatView;
@property (nonatomic , strong) UIImageView *mDriveEffectView;
@end


@implementation DriveGoatView


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
    
    
    self.mDriveGoatView = [[UIImageView alloc] initWithFrame:CGRectMake(-200, (self.height - 200) / 2, 200, 200)];
    [self addSubview:self.mDriveGoatView];
    
    [self startAnimation];
}


- (void)setMNickName:(NSString *)mNickName {
    UILabel* nameLabel = [[UILabel alloc] init];
    nameLabel.text = mNickName;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.shadowColor = [UIColor yellowColor];
    [nameLabel sizeToFit];
    nameLabel.center = CGPointMake(self.mDriveGoatView.width / 2, self.mDriveGoatView.height / 2 - 100);
    [self.mDriveGoatView addSubview:nameLabel];
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
        UIImage *img = [[AnimationImageCache shareInstance] getDriveImageWithName:[NSString stringWithFormat:@"drive_goat_run%02d.png", i]];
        if (img) {
            [images addObject:img];
        }
    }
    self.mDriveGoatView.animationImages = images;
    self.mDriveGoatView.animationDuration = (MOVE_TIME - RUB_TIME - STOP_TIME) / 4;
    [self.mDriveGoatView startAnimating];
    
    
    
    [UIView animateWithDuration:MOVE_TIME delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.mDriveGoatView.left = self.width / 2 - 100;
    } completion:^(BOOL finished) {
        [self playLightAnimation];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((MOVE_TIME - 0.3) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 前倾
        
        NSMutableArray<UIImage *> *images = [NSMutableArray<UIImage *> array];
        for (int i = 0; i < 6; ++i) {
            UIImage *img = [[AnimationImageCache shareInstance] getDriveImageWithName:[NSString stringWithFormat:@"drive_goat_stop0%d.png", i]];
            if (img) {
                [images addObject:img];
            }
        }
        self.mDriveGoatView.image = [[AnimationImageCache shareInstance] getDriveImageWithName:@"drive_goat_stop05.png"];
        self.mDriveGoatView.animationImages = images;
        self.mDriveGoatView.animationDuration = STOP_TIME;
        self.mDriveGoatView.animationRepeatCount = 1;
        [self.mDriveGoatView startAnimating];
    });
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((TOTOAL_TIME - 0.5) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 招手
        
        NSMutableArray<UIImage *> *images = [NSMutableArray<UIImage *> array];
        for (int i = 0; i < 2; ++i) {
            UIImage *img = [[AnimationImageCache shareInstance] getDriveImageWithName:[NSString stringWithFormat:@"drive_goat_wave0%d.png", i]];
            if (img) {
                [images addObject:img];
            }
        }
        self.mDriveGoatView.animationImages = images;
        self.mDriveGoatView.animationDuration = RUB_TIME / 2;
        self.mDriveGoatView.animationRepeatCount = 0;
        [self.mDriveGoatView startAnimating];
        
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((TOTOAL_TIME + WAVE_TIME) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 跑到外面
        
        NSMutableArray<UIImage *> *images = [NSMutableArray<UIImage *> array];
        for (int i = 0; i < 11; ++i) {
            UIImage *img = [[AnimationImageCache shareInstance] getDriveImageWithName:[NSString stringWithFormat:@"drive_goat_run%02d.png", i]];
            if (img) {
                [images addObject:img];
            }
        }
        self.mDriveGoatView.animationImages = images;
        self.mDriveGoatView.animationDuration = (MOVE_TIME - RUB_TIME - STOP_TIME) / 4;
        self.mDriveGoatView.animationRepeatCount = 0;
        [self.mDriveGoatView startAnimating];
        
        
        @weakify(self);
        [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            @strongify(self);
            self.mDriveGoatView.left = self.width;
        } completion:^(BOOL finished) {
            @strongify(self);
            [self endAnimation];
        }];
        
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
    UIImageView *effectView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 400)];
    effectView.bottom = self.mDriveGoatView.bottom + 50;
    effectView.left = self.mDriveGoatView.left;
    
    effectView.animationImages = images;
    effectView.animationDuration = EFFECT_TIME;
    effectView.animationRepeatCount = 1;
    [effectView startAnimating];
    [self addSubview:effectView];
}


#pragma mark - end


@end
