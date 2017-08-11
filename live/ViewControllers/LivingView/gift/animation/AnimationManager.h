//
//  AnimationManager.h
//  LearnAnimation
//
//  Created by 林伟池 on 16/5/5.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationProtocal.h"


@interface AnimationManager : NSObject <AnimationCallBackDelegate>

+ (instancetype)instance;

- (void)startAnimationWithView:(id)containerView Type:(LYAnimationType)type;

@end
