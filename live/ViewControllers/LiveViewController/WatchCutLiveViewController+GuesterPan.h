//
//  WatchCutLiveViewController+GuesterPan.h
//  qianchuo
//
//  Created by jacklong on 16/8/14.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "WatchCutLiveViewController.h"

typedef NS_ENUM(NSUInteger, SLPanGestureDirection) {
    SLPanGestureDirectionUnKnown,
    SLPanGestureDirectionLeft,
    SLPanGestureDirectionRight,
    SLPanGestureDirectionUp,
    SLPanGestureDirectionDown
};

@interface WatchCutLiveViewController (GuesterPan)

- (void)panedView:(UIPanGestureRecognizer *)pan;

@end
