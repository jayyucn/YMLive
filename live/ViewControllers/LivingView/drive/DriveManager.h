//
//  DriveManager.h
//  auvlive
//
//  Created by 林伟池 on 16/8/9.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DriveAnimationType) {
    DriveAnimationPig,
    DriveAnimationCount,
};

@interface DriveManager : NSObject

@property (nonatomic , strong) UIView *containerView;


#pragma mark - init
+ (instancetype)shareInstance;


#pragma mark - update

- (void)showDriveAnimation:(NSDictionary *)dict;

- (void)onAnimationFinish;

- (void)clearAnimation;

#pragma mark - get




#pragma mark - message


@end
