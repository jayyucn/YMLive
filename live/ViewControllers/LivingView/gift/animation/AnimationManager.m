//
//  AnimationManager.m
//  LearnAnimation
//
//  Created by 林伟池 on 16/5/5.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "AnimationManager.h"

@interface AnimationManager ()

@end

@implementation AnimationManager

static NSDictionary* classNameDict;

#pragma mark - init

+ (void)initialize {
    classNameDict = @{
                      @(LYAnimationFireworks):@"AnimationFireworksView",
                      @(LYAnimationBoat):@"AnimationBoatView",
             };
}

+ (instancetype)instance {
    static id test;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        test = [[[self class] alloc] init];
    });
    return test;
}


#pragma mark - animation

- (void)startAnimationWithView:(id)containerView Type:(LYAnimationType)type {
    id<BaseAnimation> animation = [self getAnimationByType:type];
    if (animation) {
        [animation setFrameWithContainer:containerView];
        [animation startAnimationWithDelegate:self];
    }
}


#pragma mark - get

- (id<BaseAnimation>)getAnimationByType:(LYAnimationType)type {
    id<BaseAnimation> ret;
    if (classNameDict[@(type)]) {
        NSString* className = classNameDict[@(type)];
        if (NSClassFromString(className)) {
            Class class = NSClassFromString(className);
            if ([class conformsToProtocol:@protocol(BaseAnimation)]) {
                ret = [[class alloc] init];
            }
        }
    }

    return ret;
}


#pragma mark - delegate
- (void)onAnimationEndWithView:(id<BaseAnimation>)view {
//    NSLog(@"%@ end", view);
}


@end
