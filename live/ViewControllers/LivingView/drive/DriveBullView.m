//
//  DriveBullView.m
//  qianchuo
//
//  Created by 林伟池 on 16/10/8.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "DriveBullView.h"
#import "AnimationImageCache.h"
#import "LYRACDefine.h"

@interface DriveBullView ()
@property (nonatomic , strong) UIImageView *mDriveBullView;
@end


@implementation DriveBullView

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
    
    
    self.mDriveBullView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 - 100, self.height / 2 - 100, 200, 200)];
    [self addSubview:self.mDriveBullView];
    
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


#define MOVE_TIME  3
#define RUB_TIME 0.5
#define STOP_TIME 0.5
#define EFFECT_TIME 3
#define WAVE_TIME 1.0
#define TOTOAL_TIME (MOVE_TIME + STOP_TIME  + EFFECT_TIME)

- (void)startAnimation {
    NSMutableArray<UIImage *> *images = [NSMutableArray<UIImage *> array];
    for (int i = 0; i < 12; ++i) {
        UIImage *img = [[AnimationImageCache shareInstance] getDriveImageWithName:[NSString stringWithFormat:@"drive_bull_run%02d.png", i]];
        if (img) {
            [images addObject:img];
        }
    }
    self.mDriveBullView.animationImages = images;
    self.mDriveBullView.animationDuration = (MOVE_TIME - RUB_TIME - STOP_TIME) / 4;
    [self.mDriveBullView startAnimating];
    
    
    self.mDriveBullView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:MOVE_TIME delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.mDriveBullView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [self playLightAnimation];
    }];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((MOVE_TIME - 0.2) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 前倾
        
        NSMutableArray<UIImage *> *images = [NSMutableArray<UIImage *> array];
        for (int i = 0; i < 6; ++i) {
            UIImage *img = [[AnimationImageCache shareInstance] getDriveImageWithName:[NSString stringWithFormat:@"drive_bull_stop0%d.png", i]];
            if (img) {
                [images addObject:img];
            }
        }
        self.mDriveBullView.image = [[AnimationImageCache shareInstance] getDriveImageWithName:@"drive_bull_stop05.png"];
        self.mDriveBullView.animationImages = images;
        self.mDriveBullView.animationDuration = STOP_TIME;
        self.mDriveBullView.animationRepeatCount = 1;
        [self.mDriveBullView startAnimating];
    });
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((TOTOAL_TIME - 0.5) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 招手
        
        NSMutableArray<UIImage *> *images = [NSMutableArray<UIImage *> array];
        for (int i = 0; i < 2; ++i) {
            UIImage *img = [[AnimationImageCache shareInstance] getDriveImageWithName:[NSString stringWithFormat:@"drive_bull_wave0%d.png", i]];
            if (img) {
                [images addObject:img];
            }
        }
        self.mDriveBullView.animationImages = images;
        self.mDriveBullView.animationDuration = RUB_TIME / 2;
        self.mDriveBullView.animationRepeatCount = 0;
        [self.mDriveBullView startAnimating];
        
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((TOTOAL_TIME + WAVE_TIME) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 跑到外面
        
        NSMutableArray<UIImage *> *images = [NSMutableArray<UIImage *> array];
        for (int i = 0; i < 12; ++i) {
            UIImage *img = [[AnimationImageCache shareInstance] getDriveImageWithName:[NSString stringWithFormat:@"drive_bull_run%02d.png", i]];
            if (img) {
                [images addObject:img];
            }
        }
        self.mDriveBullView.animationImages = images;
        self.mDriveBullView.animationDuration = (MOVE_TIME - RUB_TIME - STOP_TIME) / 4;
        self.mDriveBullView.animationRepeatCount = 0;
        [self.mDriveBullView startAnimating];
        
        
        @weakify(self);
        [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            @strongify(self);
            self.mDriveBullView.transform = CGAffineTransformMakeScale(1.3, 1.3);
            self.mDriveBullView.alpha = 0.0;
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
    UIImageView *effectView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
    effectView.bottom = self.mDriveBullView.bottom + 50;
    effectView.left = self.mDriveBullView.left - 50;
    
    effectView.animationImages = images;
    effectView.animationDuration = EFFECT_TIME;
    effectView.animationRepeatCount = 1;
    [effectView startAnimating];
    [self addSubview:effectView];
}


#pragma mark - end

@end
