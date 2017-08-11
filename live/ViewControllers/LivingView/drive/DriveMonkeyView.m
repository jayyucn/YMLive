//
//  DriveMonkeyView.m
//  qianchuo
//
//  Created by 林伟池 on 16/9/20.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "DriveMonkeyView.h"
#import "AnimationImageCache.h"
#import "LYRACDefine.h"

@interface DriveMonkeyView ()
@property (nonatomic , strong) UIImageView *mDriveMonkeyView;
@end


@implementation DriveMonkeyView


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
    
    
    self.mDriveMonkeyView = [[UIImageView alloc] initWithFrame:CGRectMake(-200, -100, 200, 200)];
    [self addSubview:self.mDriveMonkeyView];
    
    [self startAnimation];
}


- (void)setMNickName:(NSString *)mNickName {
    UILabel* nameLabel = [[UILabel alloc] init];
    nameLabel.text = mNickName;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.shadowColor = [UIColor yellowColor];
    [nameLabel sizeToFit];
    nameLabel.center = CGPointMake(self.mDriveMonkeyView.width / 2, self.mDriveMonkeyView.height / 2 - 100);
    [self.mDriveMonkeyView addSubview:nameLabel];
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
    for (int i = 0; i < 15; ++i) {
        UIImage *img = [[AnimationImageCache shareInstance] getDriveImageWithName:[NSString stringWithFormat:@"drive_monkey_run%02d.png", i]];
        if (img) {
            [images addObject:img];
        }
    }
    self.mDriveMonkeyView.animationImages = images;
    self.mDriveMonkeyView.animationDuration = (MOVE_TIME - RUB_TIME - STOP_TIME) / 4;
    [self.mDriveMonkeyView startAnimating];
    
    
    self.mDriveMonkeyView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:MOVE_TIME delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.mDriveMonkeyView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.mDriveMonkeyView.left = self.width / 2 - 100;
        self.mDriveMonkeyView.top = self.height / 2 - 100;
    } completion:^(BOOL finished) {
        [self playLightAnimation];
    }];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((MOVE_TIME - 0.2) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 前倾
        
        NSMutableArray<UIImage *> *images = [NSMutableArray<UIImage *> array];
        for (int i = 0; i < 6; ++i) {
            UIImage *img = [[AnimationImageCache shareInstance] getDriveImageWithName:[NSString stringWithFormat:@"drive_monkey_stop0%d.png", i]];
            if (img) {
                [images addObject:img];
            }
        }
        self.mDriveMonkeyView.image = [[AnimationImageCache shareInstance] getDriveImageWithName:@"drive_monkey_stop05.png"];
        self.mDriveMonkeyView.animationImages = images;
        self.mDriveMonkeyView.animationDuration = STOP_TIME;
        self.mDriveMonkeyView.animationRepeatCount = 1;
        [self.mDriveMonkeyView startAnimating];
    });
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((TOTOAL_TIME - 0.5) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 招手
        
        NSMutableArray<UIImage *> *images = [NSMutableArray<UIImage *> array];
        for (int i = 0; i < 2; ++i) {
            UIImage *img = [[AnimationImageCache shareInstance] getDriveImageWithName:[NSString stringWithFormat:@"drive_monkey_wave0%d.png", i]];
            if (img) {
                [images addObject:img];
            }
        }
        self.mDriveMonkeyView.animationImages = images;
        self.mDriveMonkeyView.animationDuration = RUB_TIME / 2;
        self.mDriveMonkeyView.animationRepeatCount = 0;
        [self.mDriveMonkeyView startAnimating];
        
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((TOTOAL_TIME + WAVE_TIME) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 跑到外面
        
        NSMutableArray<UIImage *> *images = [NSMutableArray<UIImage *> array];
        for (int i = 0; i < 15; ++i) {
            UIImage *img = [[AnimationImageCache shareInstance] getDriveImageWithName:[NSString stringWithFormat:@"drive_monkey_run%02d.png", i]];
            if (img) {
                [images addObject:img];
            }
        }
        self.mDriveMonkeyView.animationImages = images;
        self.mDriveMonkeyView.animationDuration = (MOVE_TIME - RUB_TIME - STOP_TIME) / 4;
        self.mDriveMonkeyView.animationRepeatCount = 0;
        [self.mDriveMonkeyView startAnimating];
        
        
        @weakify(self);
        [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            @strongify(self);
            self.mDriveMonkeyView.transform = CGAffineTransformMakeScale(1.5, 1.5);
            self.mDriveMonkeyView.left = self.width;
            self.mDriveMonkeyView.top += 50;
            self.mDriveMonkeyView.alpha = 0.8;
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
    effectView.bottom = self.mDriveMonkeyView.bottom + 50;
    effectView.left = self.mDriveMonkeyView.left - 50;
    
    effectView.animationImages = images;
    effectView.animationDuration = EFFECT_TIME;
    effectView.animationRepeatCount = 1;
    [effectView startAnimating];
    [self addSubview:effectView];
}


#pragma mark - end


@end