//
//  DriveTigerView.m
//  qianchuo
//
//  Created by 林伟池 on 16/8/31.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "DriveTigerView.h"
#import "AnimationImageCache.h"
#import "LYRACDefine.h"

@interface DriveTigerView ()
@property (nonatomic , strong) UIImageView *mDriveTigerView;
@end


@implementation DriveTigerView

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
    
    
    self.mDriveTigerView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 - 100, self.height / 2 - 100, 200, 200)];
    [self addSubview:self.mDriveTigerView];
    
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
    for (int i = 0; i < 11; ++i) {
        UIImage *img = [[AnimationImageCache shareInstance] getDriveImageWithName:[NSString stringWithFormat:@"drive_tiger_run%02d.png", i]];
        if (img) {
            [images addObject:img];
        }
    }
    self.mDriveTigerView.animationImages = images;
    self.mDriveTigerView.animationDuration = (MOVE_TIME - RUB_TIME - STOP_TIME) / 4;
    [self.mDriveTigerView startAnimating];
    
    
    self.mDriveTigerView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:MOVE_TIME delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.mDriveTigerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [self playLightAnimation];
    }];
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((MOVE_TIME - RUB_TIME) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 刹车
        
        NSMutableArray<UIImage *> *images = [NSMutableArray<UIImage *> array];
        for (int i = 0; i < 2; ++i) {
            UIImage *img = [[AnimationImageCache shareInstance] getDriveImageWithName:[NSString stringWithFormat:@"drive_tiger_rub0%d.png", i]];
            if (img) {
                [images addObject:img];
            }
        }
        self.mDriveTigerView.animationImages = images;
        self.mDriveTigerView.animationDuration = RUB_TIME / 2;
        [self.mDriveTigerView startAnimating];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((MOVE_TIME - 0.2) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 前倾
        
        NSMutableArray<UIImage *> *images = [NSMutableArray<UIImage *> array];
        for (int i = 0; i < 6; ++i) {
            UIImage *img = [[AnimationImageCache shareInstance] getDriveImageWithName:[NSString stringWithFormat:@"drive_tiger_stop0%d.png", i]];
            if (img) {
                [images addObject:img];
            }
        }
        self.mDriveTigerView.image = [[AnimationImageCache shareInstance] getDriveImageWithName:@"drive_tiger_stop05.png"];
        self.mDriveTigerView.animationImages = images;
        self.mDriveTigerView.animationDuration = STOP_TIME;
        self.mDriveTigerView.animationRepeatCount = 1;
        [self.mDriveTigerView startAnimating];
    });
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((TOTOAL_TIME - 0.5) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 招手
        
        NSMutableArray<UIImage *> *images = [NSMutableArray<UIImage *> array];
        for (int i = 0; i < 2; ++i) {
            UIImage *img = [[AnimationImageCache shareInstance] getDriveImageWithName:[NSString stringWithFormat:@"drive_tiger_wave0%d.png", i]];
            if (img) {
                [images addObject:img];
            }
        }
        self.mDriveTigerView.animationImages = images;
        self.mDriveTigerView.animationDuration = RUB_TIME / 2;
        self.mDriveTigerView.animationRepeatCount = 0;
        [self.mDriveTigerView startAnimating];
        
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((TOTOAL_TIME + WAVE_TIME) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 跑到外面
        
        NSMutableArray<UIImage *> *images = [NSMutableArray<UIImage *> array];
        for (int i = 0; i < 11; ++i) {
            UIImage *img = [[AnimationImageCache shareInstance] getDriveImageWithName:[NSString stringWithFormat:@"drive_tiger_run%02d.png", i]];
            if (img) {
                [images addObject:img];
            }
        }
        self.mDriveTigerView.animationImages = images;
        self.mDriveTigerView.animationDuration = (MOVE_TIME - RUB_TIME - STOP_TIME) / 4;
        self.mDriveTigerView.animationRepeatCount = 0;
        [self.mDriveTigerView startAnimating];
        
        
        @weakify(self);
        [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            @strongify(self);
            self.mDriveTigerView.transform = CGAffineTransformMakeScale(1.3, 1.3);
            self.mDriveTigerView.alpha = 0.0;
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
    effectView.bottom = self.mDriveTigerView.bottom + 50;
    effectView.left = self.mDriveTigerView.left - 50;
    
    effectView.animationImages = images;
    effectView.animationDuration = EFFECT_TIME;
    effectView.animationRepeatCount = 1;
    [effectView startAnimating];
    [self addSubview:effectView];
}


#pragma mark - end

@end
