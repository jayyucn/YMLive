//
//  AnimationProtocal.h
//  LearnAnimation
//
//  Created by 林伟池 on 16/5/5.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#ifndef AnimationProtocal_h
#define AnimationProtocal_h

#define ESWeak_(var, weakVar)                   __weak __typeof(&*var) weakVar = var;
#define ESWeak(var)                             ESWeak_(var, weak_##var);
#define ESWeakSelf                              ESWeak(self);

#define ESStrong_DoNotCheckNil(weakVar, var)    __typeof(&*weakVar) var = weakVar;
#define ESStrong_(weakVar, var)                 ESStrong_DoNotCheckNil(weakVar, var); if (!var) return;
#define ESStrong(var)                           ESStrong_(weak_##var, _##var);
#define ESStrongSelf                            ESStrong(self);


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LYAnimationStatus) {
    LYAnimationNotStart,
    LYAnimationPlaying,
    LYAnimationEnd,
};

typedef NS_ENUM(NSUInteger, LYAnimationType) {
    LYAnimationFireworks,
    LYAnimationBoat,
    LYAnimationCar,
};

/**
 *  1、播放完动画回调
 *  2、
 */
@protocol BaseAnimation;
@protocol AnimationCallBackDelegate <NSObject>

- (void)onAnimationEndWithView:(id<BaseAnimation>)view;

@end

@protocol BaseAnimation <NSObject>

- (void)startAnimationWithDelegate:(id<AnimationCallBackDelegate>)delegate;

//- (LYAnimationType)getAnimationType;

- (void)setFrameWithContainer:(id)containerView;

@end



#endif /* AnimationProtocal_h */
