//
//  DriveDragonView.m
//  auvlive
//
//  Created by 林伟池 on 16/11/1.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "DriveDragonView.h"
#import "AnimationImageCache.h"
#import "LYRACDefine.h"

@interface DriveDragonView ()
@property (nonatomic , strong) UIImageView *mDriveDragonView;
@property (nonatomic , strong) UIImageView *mDriveEffectView;
@end


@implementation DriveDragonView


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
    
    
    self.mDriveDragonView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 - 125, -250, 250, 250)];
    [self addSubview:self.mDriveDragonView];
    
    [self startAnimation];
}


- (void)setMNickName:(NSString *)mNickName {
    UILabel* nameLabel = [[UILabel alloc] init];
    nameLabel.text = mNickName;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.shadowColor = [UIColor yellowColor];
    [nameLabel sizeToFit];
    nameLabel.center = CGPointMake(self.mDriveDragonView.width / 2, self.mDriveDragonView.height / 2 - 125);
    [self.mDriveDragonView addSubview:nameLabel];
}


#pragma mark - start


#define MOVE_TIME  3
#define STOP_TIME 0.5
#define EFFECT_TIME 3
#define WAVE_TIME 1.0
#define TOTOAL_TIME (MOVE_TIME + STOP_TIME  + EFFECT_TIME)

- (void)startAnimation {
    NSMutableArray<UIImage *> *images = [NSMutableArray<UIImage *> array];
    for (int i = 0; i < 36; ++i) {
        UIImage *img = [[AnimationImageCache shareInstance] getDriveImageWithName:[NSString stringWithFormat:@"drive_dragon_run%02d.png", i]];
        if (img) {
            [images addObject:img];
        }
    }
    self.mDriveDragonView.animationImages = images;
    self.mDriveDragonView.animationDuration = (MOVE_TIME - STOP_TIME) / 1.5;
    [self.mDriveDragonView startAnimating];
    
    
    self.mDriveDragonView.transform = CGAffineTransformMakeScale(0.3, 0.3);
    
    [UIView animateWithDuration:MOVE_TIME delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.mDriveDragonView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.mDriveDragonView.top = self.height / 2 - 125;
    } completion:^(BOOL finished) {
        [self playLightAnimation];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((MOVE_TIME - 0.3) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 前倾
        
        NSMutableArray<UIImage *> *images = [NSMutableArray<UIImage *> array];
        for (int i = 0; i < 5; ++i) {
            UIImage *img = [[AnimationImageCache shareInstance] getDriveImageWithName:[NSString stringWithFormat:@"drive_dragon_stop0%d.png", i]];
            if (img) {
                [images addObject:img];
            }
        }
        self.mDriveDragonView.image = [[AnimationImageCache shareInstance] getDriveImageWithName:@"drive_dragon_stop04.png"];
        self.mDriveDragonView.animationImages = images;
        self.mDriveDragonView.animationDuration = STOP_TIME;
        self.mDriveDragonView.animationRepeatCount = 1;
        [self.mDriveDragonView startAnimating];
    });
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((TOTOAL_TIME - 0.5) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 招手
        
        NSMutableArray<UIImage *> *images = [NSMutableArray<UIImage *> array];
        for (int i = 0; i < 2; ++i) {
            UIImage *img = [[AnimationImageCache shareInstance] getDriveImageWithName:[NSString stringWithFormat:@"drive_dragon_wave0%d.png", i]];
            if (img) {
                [images addObject:img];
            }
        }
        self.mDriveDragonView.animationImages = images;
        self.mDriveDragonView.animationDuration = WAVE_TIME / 3;
        self.mDriveDragonView.animationRepeatCount = 0;
        [self.mDriveDragonView startAnimating];
        
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((TOTOAL_TIME + WAVE_TIME) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 跑到外面
        
        NSMutableArray<UIImage *> *images = [NSMutableArray<UIImage *> array];
        for (int i = 0; i < 36; ++i) {
            UIImage *img = [[AnimationImageCache shareInstance] getDriveImageWithName:[NSString stringWithFormat:@"drive_dragon_run%02d.png", i]];
            if (img) {
                [images addObject:img];
            }
        }
        self.mDriveDragonView.animationImages = images;
        self.mDriveDragonView.animationDuration = (MOVE_TIME - STOP_TIME) / 2;
        self.mDriveDragonView.animationRepeatCount = 0;
        [self.mDriveDragonView startAnimating];
        
        
        @weakify(self);
        [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            @strongify(self);
            self.mDriveDragonView.top = self.height;
            self.mDriveDragonView.transform = CGAffineTransformMakeScale(1.3, 1.3);
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
    UIImageView *effectView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 400)];
    effectView.bottom = self.mDriveDragonView.bottom + 50;
    effectView.left = self.mDriveDragonView.left;
    
    effectView.animationImages = images;
    effectView.animationDuration = EFFECT_TIME;
    effectView.animationRepeatCount = 1;
    [effectView startAnimating];
    [self addSubview:effectView];
}


#pragma mark - end


@end
