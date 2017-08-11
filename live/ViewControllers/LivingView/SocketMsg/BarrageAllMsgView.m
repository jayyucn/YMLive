//
//  BarrageAllMsgView.m
//  qianchuo
//
//  Created by jacklong on 16/3/14.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "BarrageAllMsgView.h"

@implementation BarrageAllMsgView

- (void)dealloc
{
    NSLog(@"dealloc %@",NSStringFromClass(self.class));
    [self removeFromSuperview];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _barrageFirstView = [[BarrageMsgView alloc] initWithFrame:CGRectMake(ScreenWidth,0, SCREEN_WIDTH, 35.f)];
        [self addSubview:_barrageFirstView];
        _barrageFirstView.hidden = YES;
        
        
        _barrageSecondView = [[BarrageMsgView alloc] initWithFrame:CGRectMake(ScreenWidth, _barrageFirstView.bottom+5, ScreenWidth, 35.f)];
        [self addSubview:_barrageSecondView];
        _barrageSecondView.hidden = YES;
        
        _barrageThreeView = [[BarrageMsgView alloc] initWithFrame:CGRectMake(ScreenWidth, _barrageSecondView.bottom+5, ScreenWidth, 35.f)];
        [self addSubview:_barrageThreeView];
        _barrageThreeView.hidden = YES;
    }
    return self;
}

-(void) showBarrageAnimation
{
    if (self.barrageInfoArray.count <= 0)
    {
        return;
    }
    
    if (_barrageFirstView.hidden) {
      
        NSDictionary *firstDict = self.barrageInfoArray[0];
        [self.barrageInfoArray removeObject:firstDict];
        _barrageFirstView.hidden = NO;
        _barrageFirstView.barrageInfoDict = firstDict;
        _barrageFirstView.width = _barrageFirstView.sendFaceImg.width + [_barrageFirstView getContentWidth] + 10;
        self.barrageFirstView.left = ScreenWidth;
        
        ESWeakSelf;
        [UIView animateWithDuration:10.f delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             ESStrongSelf;
                             _self.barrageFirstView.right = -20;
                         } completion:^(BOOL finished) {
                             ESStrongSelf;
                             NSLog(@" finish %d", finished);
                             _self.barrageFirstView.left = ScreenWidth;
                              _self.barrageFirstView.hidden = YES;
                             if (_self.barrageInfoArray && _self.barrageInfoArray.count > 0) {
                                 [_self showBarrageAnimation];
                             }
                        }];
    } else if (_barrageSecondView.hidden) {
        NSDictionary *secondDict = self.barrageInfoArray[0];
        [self.barrageInfoArray removeObject:secondDict];
        _barrageSecondView.hidden = NO;
        _barrageSecondView.barrageInfoDict = secondDict;
        _barrageSecondView.width = _barrageSecondView.sendFaceImg.width + [_barrageSecondView getContentWidth] + 10;
        self.barrageSecondView.left = ScreenWidth;
        ESWeakSelf;
        [UIView animateWithDuration:10.f delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             ESStrongSelf;
                             _self.barrageSecondView.right = -20;
                         } completion:^(BOOL finished) {
                             ESStrongSelf;
                             _self.barrageSecondView.left = ScreenWidth;
                             _self.barrageSecondView.hidden = YES;
                             
                             if (_self.barrageInfoArray && _self.barrageInfoArray.count > 0) {
                                 [_self showBarrageAnimation];
                             }
                         }];
    } else if (_barrageThreeView.hidden) {
        NSDictionary *threeDict = self.barrageInfoArray[0];
        [self.barrageInfoArray removeObject:threeDict];
        _barrageThreeView.hidden = NO;
        _barrageThreeView.barrageInfoDict = threeDict;
        _barrageThreeView.width = _barrageThreeView.sendFaceImg.width + [_barrageThreeView getContentWidth] + 10;
        self.barrageThreeView.left = ScreenWidth;
        
        ESWeakSelf;
        [UIView animateWithDuration:10.f delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             ESStrongSelf;
                             _self.barrageThreeView.right = -20;
                         } completion:^(BOOL finished) {
                             ESStrongSelf;
                             _self.barrageThreeView.left = ScreenWidth;
                             _self.barrageThreeView.hidden = YES;
                             
                             if (_self.barrageInfoArray && _self.barrageInfoArray.count > 0) {
                                 [_self showBarrageAnimation];
                             }
                         }];
    } 
}

@end
