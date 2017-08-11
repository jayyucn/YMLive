//
//  KSYProgressToolBar.h
//  qianchuo
//
//  Created by jacklong on 16/8/8.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSYProgressToolBar : UIView

@property (nonatomic, copy)void (^playControlEventBlock)(BOOL isStop);

@property (nonatomic, copy)void (^seekToBlock)(double position);
@property (strong ,nonatomic) void (^userEventBlock)(NSInteger index);


@property (nonatomic, strong)UILabel *timeLabel;


- (void)updataSliderWithPosition:(NSInteger)position duration:(NSInteger)duration playableDuration:(NSInteger)playableduration;
- (void)playerIsStop:(BOOL)isStop;


@end
