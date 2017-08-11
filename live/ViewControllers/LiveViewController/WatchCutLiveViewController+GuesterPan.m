//
//  WatchCutLiveViewController+GuesterPan.m
//  qianchuo
//
//  Created by jacklong on 16/8/14.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "WatchCutLiveViewController+GuesterPan.h"

@implementation WatchCutLiveViewController (GuesterPan)

- (void)panedView:(UIPanGestureRecognizer *)pan
{
    static CGPoint benginPanPoint;
    static CGFloat panViewY;
    static SLPanGestureDirection panDirection;
    
    [self handleSwipe:pan];
    
    if (!self.liveArray || self.liveArray.count < 2) {
        return;
    }
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            benginPanPoint = [pan locationInView:self.view.window];
            panViewY = self.panedView.frame.origin.y;
            panDirection = SLPanGestureDirectionUnKnown;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            //没有锁定方向时，就锁定，一旦锁定就不在变化！如果变化，有可能会导致跳跃，以至于误认为是卡顿的尴尬！
            if(SLPanGestureDirectionUnKnown == panDirection){
                
                CGPoint translation =  [pan translationInView:self.view.window];
                
                CGFloat tx = fabs(translation.x);
                CGFloat ty = fabs(translation.y);
                
                if (tx > ty) {
                    //左右滑动
                    if (translation.x > 0) {
                        //向右滑动；
                        panDirection = SLPanGestureDirectionRight;
                    }else{
                        //向左滑动；
                        panDirection = SLPanGestureDirectionLeft;
                    }
                }else{
                    if(translation.y > 0){
                        //向下滑动；
                        panDirection = SLPanGestureDirectionDown;
                        [self showNextAnchorBG];
                    }else{
                        //向上滑动；
                        panDirection = SLPanGestureDirectionUp;
                        [self showBeforeAnchorBG];
                    }
                }
            }
            
            switch (panDirection) {
                case SLPanGestureDirectionUp:
                case SLPanGestureDirectionDown:
                {
                    CGPoint endPanPoint = [pan locationInView:self.view.window];
                    //偏移量
                    CGFloat detaly = endPanPoint.y - benginPanPoint.y;
                    //目标x
                    CGFloat destY = panViewY + detaly;
                    
                    CGRect frame = self.panedView.frame;
                    frame.origin.y = destY;
                    self.panedView.frame = frame;
                    
                    ///更新手势方向
                    //说明下滑了；
                    if (destY > 0) {
                        //如果此时锁定的方向是UP，那么就需要更新！
                        if(SLPanGestureDirectionUp == panDirection){
                            panDirection = SLPanGestureDirectionDown;
                            [self showNextAnchorBG];
                        }
                    }else{
                        if (SLPanGestureDirectionDown == panDirection) {
                            panDirection = SLPanGestureDirectionUp;
                            [self showBeforeAnchorBG];
                        }
                    }
                }
                default:
                    break;
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        {
            CGFloat needPanHeight = 120;
            
            switch (panDirection) {
                case SLPanGestureDirectionUp:
                {
                    //向上滑动；
                    BOOL isNeedSwitch = NO;
                    CGFloat descY = 0;
                    
                    if (self.panedView.frame.origin.y < -needPanHeight) {
                        descY = -self.panedView.frame.size.height;
                        isNeedSwitch = YES;
                    }
                    
                    [UIView animateWithDuration:0.25 animations:^{
                        CGRect frame = self.panedView.frame;
                        frame.origin.y = descY;
                        self.panedView.frame = frame;
                    }completion:^(BOOL finished) {
                        CGRect frame = self.panedView.frame;
                        frame.origin.y = 0;
                        self.panedView.frame = frame;
                        if (isNeedSwitch) {
                            [self showNextAnchor];
                        }else{
                            [self showCurrentAnchorBG];
                        }
                    }];
                    
                }
                    break;
                case SLPanGestureDirectionDown:
                {
                    BOOL isNeedSwitch = NO;
                    CGFloat descY = 0;
                    
                    if (self.panedView.frame.origin.y > needPanHeight) {
                        descY = self.panedView.frame.size.height;
                        isNeedSwitch = YES;
                    }
                    
                    [UIView animateWithDuration:0.25 animations:^{
                        CGRect frame = self.panedView.frame;
                        frame.origin.y = descY;
                        self.panedView.frame = frame;
                    }completion:^(BOOL finished) {
                        CGRect frame = self.panedView.frame;
                        frame.origin.y = 0;
                        self.panedView.frame = frame;
                        if (isNeedSwitch) {
                            [self showBeforeAnchor];
                        }else{
                            [self showCurrentAnchorBG];
                        }
                    }];
                    
                }
                    break;
                default:
                    break;
            }
            //重置
            panDirection = SLPanGestureDirectionUnKnown;
        }
            break;
        default:{}
            break;
    }
}


@end
