//
//  DriveDogView.m
//  qianchuo
//
//  Created by 林伟池 on 16/10/8.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "DriveDogView.h"
#import "AnimationImageCache.h"
#import "LYRACDefine.h"

@interface DriveDogView ()
@property (nonatomic , strong) UIImageView *mDriveDogView;
@end


@implementation DriveDogView


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
    
    
    self.mDriveDogView = [[UIImageView alloc] initWithFrame:CGRectMake(-200, -100, 200, 200)];
    [self addSubview:self.mDriveDogView];
    
    [self startAnimation];
}


- (void)setMNickName:(NSString *)mNickName {
    UILabel* nameLabel = [[UILabel alloc] init];
    nameLabel.text = mNickName;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.shadowColor = [UIColor yellowColor];
    [nameLabel sizeToFit];
    nameLabel.center = CGPointMake(self.mDriveDogView.width / 2, self.mDriveDogView.height / 2 - 100);
    [self.mDriveDogView addSubview:nameLabel];
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
    for (int i = 0; i < 11; ++i) {
        UIImage *img = [[AnimationImageCache shareInstance] getDriveImageWithName:[NSString stringWithFormat:@"drive_dog_run%02d.png", i]];
        if (img) {
            [images addObject:img];
        }
    }
    self.mDriveDogView.animationImages = images;
    self.mDriveDogView.animationDuration = (MOVE_TIME - RUB_TIME - STOP_TIME) / 4;
    [self.mDriveDogView startAnimating];
    
    
    self.mDriveDogView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:MOVE_TIME delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.mDriveDogView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.mDriveDogView.left = self.width / 2 - 100;
        self.mDriveDogView.top = self.height / 2 - 100;
    } completion:^(BOOL finished) {
        [self playLightAnimation];
    }];
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((MOVE_TIME - 0.2) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 前倾
        
        NSMutableArray<UIImage *> *images = [NSMutableArray<UIImage *> array];
        for (int i = 0; i < 6; ++i) {
            UIImage *img = [[AnimationImageCache shareInstance] getDriveImageWithName:[NSString stringWithFormat:@"drive_dog_stop0%d.png", i]];
            if (img) {
                [images addObject:img];
            }
        }
        self.mDriveDogView.image = [[AnimationImageCache shareInstance] getDriveImageWithName:@"drive_dog_stop05.png"];
        self.mDriveDogView.animationImages = images;
        self.mDriveDogView.animationDuration = STOP_TIME;
        self.mDriveDogView.animationRepeatCount = 1;
        [self.mDriveDogView startAnimating];
    });
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((TOTOAL_TIME - 0.5) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 招手
        
        NSMutableArray<UIImage *> *images = [NSMutableArray<UIImage *> array];
        for (int i = 0; i < 4; ++i) {
            UIImage *img = [[AnimationImageCache shareInstance] getDriveImageWithName:[NSString stringWithFormat:@"drive_dog_wave0%d.png", i]];
            if (img) {
                [images addObject:img];
            }
        }
        self.mDriveDogView.animationImages = images;
        self.mDriveDogView.animationDuration = RUB_TIME / 2;
        self.mDriveDogView.animationRepeatCount = 0;
        [self.mDriveDogView startAnimating];
        
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((TOTOAL_TIME + WAVE_TIME) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 跑到外面
        
        NSMutableArray<UIImage *> *images = [NSMutableArray<UIImage *> array];
        for (int i = 0; i < 11; ++i) {
            UIImage *img = [[AnimationImageCache shareInstance] getDriveImageWithName:[NSString stringWithFormat:@"drive_dog_run%02d.png", i]];
            if (img) {
                [images addObject:img];
            }
        }
        self.mDriveDogView.animationImages = images;
        self.mDriveDogView.animationDuration = (MOVE_TIME - RUB_TIME - STOP_TIME) / 4;
        self.mDriveDogView.animationRepeatCount = 0;
        [self.mDriveDogView startAnimating];
        
        
        @weakify(self);
        [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            @strongify(self);
            self.mDriveDogView.transform = CGAffineTransformMakeScale(1.5, 1.5);
            self.mDriveDogView.left = self.width;
            self.mDriveDogView.top += 50;
            self.mDriveDogView.alpha = 0.8;
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
    UIImageView *effectView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
    effectView.bottom = self.mDriveDogView.bottom + 50;
    effectView.left = self.mDriveDogView.left - 50;
    
    effectView.animationImages = images;
    effectView.animationDuration = EFFECT_TIME;
    effectView.animationRepeatCount = 1;
    [effectView startAnimating];
    [self addSubview:effectView];
}


#pragma mark - end


@end