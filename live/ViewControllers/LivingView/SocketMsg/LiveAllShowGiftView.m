//
//  LiveAllSendGiftView.m
//  qianchuo
//
//  Created by jacklong on 16/3/14.
//  Copyright © 2016年 kenneth. All rights reserved.
//

//#define GIFT_FIRST_
#define GIFT_SEG_HEIGHT 10

#import "LiveAllShowGiftView.h"

@implementation LiveAllShowGiftView

- (void)dealloc
{
    NSLog(@"dealloc %@",NSStringFromClass(self.class));
    
    [self removeFromSuperview];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _firstShowGiftView = [[LiveUserSendGiftView alloc] initWithFrame:CGRectMake(0, 0,290.f, 55.f)];
        [self addSubview:_firstShowGiftView];
        _firstShowGiftView.right = 0;
        _firstShowGiftView.hidden = YES;
        
        _secondShowGiftView = [[LiveUserSendGiftView alloc] initWithFrame:CGRectMake(0, _firstShowGiftView.bottom+GIFT_SEG_HEIGHT, 290, 55.f)];
        [self addSubview:_secondShowGiftView];
        _secondShowGiftView.right = 0;
        _secondShowGiftView.hidden = YES;
    }
    return self;
}

#pragma mark - 开始赠送礼物动画
- (void) startSendGiftViewAnimation
{
    if (!_firstShowGiftView.hidden) {
        if (_firstContinousArray && _firstContinousArray.count > 0) {// 连续动画
            _firstShowGiftDict = _firstContinousArray[0];
            
            if (_firstContinousArray && _firstContinousArray.count > 0) {
                [_firstContinousArray removeObjectAtIndex:0];
            }
            
            self.firstShowGiftView.sendGiftDict = _firstShowGiftDict;
            [self showFirstGiftNumAnimation:_firstShowGiftDict];
        } else {// 切换动画
            [self upMoveView:_firstShowGiftView withIsFirstView:YES];
        }
    }
    
    if (!_secondShowGiftView.hidden) {
        if (_secondContinousArray && _secondContinousArray.count > 0) {// 连续动画
            _secondShowGiftDict = _secondContinousArray[0];
            
            if (_secondContinousArray && _secondContinousArray.count > 0)
            {
                [_secondContinousArray removeObjectAtIndex:0];
            }
            self.secondShowGiftView.sendGiftDict = _secondShowGiftDict;
            [self showSecondGiftNumAnimation:_secondShowGiftDict];
        } else {// 切换动画
            [self upMoveView:_secondShowGiftView withIsFirstView:NO];
        }
    }
}

#pragma mark - 隐藏礼物动画
- (void) hiddenGiftView
{
    if (_firstContinousArray) {
        [_firstContinousArray removeAllObjects];
    }
    
    if (_secondContinousArray) {
        [_secondContinousArray removeAllObjects];
    }
    
    if (_allGiftDict) {
        [_allGiftDict removeAllObjects];
    }
    
    if (_allKeyArray) {
        [_allKeyArray removeAllObjects];
    }
    
    _firstShowGiftView.hidden = YES;
    _secondShowGiftView.hidden = YES;
}


#pragma mark - 显示礼物动画
- (void) showGiftView:(NSDictionary *)giftDict
{
    if (!_firstShowGiftView) {
        _firstShowGiftView = [[LiveUserSendGiftView alloc] initWithFrame:CGRectMake(0, 0,290.f, 55.f)];
        [self addSubview:_firstShowGiftView];
        _firstShowGiftView.right = 0;
        _firstShowGiftView.hidden = YES;
    }
    
    if (!_secondShowGiftView) {
        _secondShowGiftView = [[LiveUserSendGiftView alloc] initWithFrame:CGRectMake(0, _firstShowGiftView.bottom+GIFT_SEG_HEIGHT, 290, 55.f)];
        [self addSubview:_secondShowGiftView];
        _secondShowGiftView.right = 0;
        _secondShowGiftView.hidden = YES;
    }
    
    if (self.firstShowGiftView.hidden && self.secondShowGiftView.hidden)
    {
//        if (_allShowGiftArray && _allShowGiftArray.count > 0) {
//            [_allShowGiftArray removeAllObjects];
//        }
        if (_allGiftDict && _allGiftDict.count > 0) {
            [_allGiftDict removeAllObjects];
        }
        
        if (_firstContinousArray && _firstContinousArray.count > 0) {
            [_firstContinousArray removeAllObjects];
        }
        
        if (_secondContinousArray && _secondContinousArray.count > 0) {
            [_secondContinousArray removeAllObjects];
        }
        
        _firstShowGiftDict = giftDict;
        [self showFirstViewAnimation:_firstShowGiftDict];
    }
    else
    {
        if ([self isContinuous:_firstShowGiftDict withNewGift:giftDict])
        {// 第一个显示礼物view正在连续
            if (!_firstContinousArray) {
                _firstContinousArray = [NSMutableArray array];
            }
            
            if (self.firstShowGiftView.hidden) {
                _firstShowGiftDict = giftDict;
                [self showFirstViewAnimation:giftDict];
            } else {
                [_firstContinousArray addObject:giftDict];
            }
        }
        else if ([self isContinuous:_secondShowGiftDict withNewGift:giftDict])
        {// 第二个显示礼物view正在连续
            if (!_secondContinousArray) {
                _secondContinousArray = [NSMutableArray array];
            }
            
            if (self.secondShowGiftView.hidden) {
                _secondShowGiftDict = giftDict;
                [self showSecondViewAnimation:giftDict];
            } else {
                [_secondContinousArray addObject:giftDict];
            }
        }
        else
        {// 没有连续的礼物
            if (!_allGiftDict) {
                _allGiftDict = [NSMutableDictionary dictionary];
             }
            
            if (self.firstShowGiftView.hidden) {
                _firstShowGiftDict = giftDict;
                [self showFirstViewAnimation:giftDict];
            } else if (self.secondShowGiftView.hidden){
                _secondShowGiftDict = giftDict;
                [self showSecondViewAnimation:giftDict];
            } else {
                [self addGiftObjIntoDict:giftDict];
            }
        }
    }
}

- (void) addGiftObjIntoDict:(NSDictionary *)giftDict
{
    if (!giftDict) {
        return;
    }
    
    NSString *uid = giftDict[@"uid"];
    int  giftId = [giftDict[@"gift_id"] intValue];
    
    NSString *key = [NSString stringWithFormat:@"%@%d",uid,giftId];
    
    if (_allGiftDict[key]) {
        NSLog(@"gift dict exit array");
         NSMutableArray *array = _allGiftDict[key];
        [array addObject:giftDict];
    } else {
        NSLog(@"gift not exit array");
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:giftDict];
        
        [_allGiftDict setObject:array forKey:key];
    }
    
    [self addKeyToArray:key];
}

- (void) addKeyToArray:(NSString *)key
{
    if (!_allKeyArray) {
        _allKeyArray= [NSMutableArray array];
        
        [_allKeyArray addObject:key];
    }
    
    if (![self isContainerKey:key]) {
         NSLog(@"is not exit key");
        [_allKeyArray addObject:key];
    } else {
        NSLog(@"is exit key");
    }
}

- (BOOL) isContainerKey:(NSString *)key
{
    for (NSString *keyStr in _allKeyArray) {
        if ([keyStr isEqualToString:key]) {
            return  YES;
        }
    }
    
    return NO;
}

- (BOOL) isContinuous:(NSDictionary *)oldGiftDict withNewGift:(NSDictionary *)newGiftDict
{
    if (!oldGiftDict) {
        return NO;
    }
    
    int oldGiftID = [oldGiftDict[@"gift_id"] intValue];
    int newGiftID = [newGiftDict[@"gift_id"] intValue];
    
    if ([oldGiftDict[@"uid"] isEqualToString:newGiftDict[@"uid"]] && oldGiftID == newGiftID)
    {
        return  YES;
    }
    
    return NO;
}


#pragma  mark - 显示礼物动画
- (void) showFirstViewAnimation:(NSDictionary *)giftDict
{
    self.firstShowGiftView.sendGiftDict = giftDict;
    self.firstShowGiftView.hidden = NO;
    self.firstShowGiftView.alpha = 1;
    ESWeakSelf;
    [UIView animateWithDuration:0.3f animations:^{
        ESStrongSelf;
        _self.firstShowGiftView.right = 290;
    } completion:^(BOOL finish) {
        ESStrongSelf;
        [_self showFirstGiftNumAnimation:giftDict];
    }];
}

- (void) showSecondViewAnimation:(NSDictionary *)giftDict
{
    self.secondShowGiftView.sendGiftDict = giftDict;
    self.secondShowGiftView.hidden = NO;
    self.secondShowGiftView.alpha = 1;
    ESWeakSelf;
    [UIView animateWithDuration:0.3f animations:^{
        ESStrongSelf;
        _self.secondShowGiftView.right = 290;
    } completion:^(BOOL finish) {
        ESStrongSelf;
        [_self showSecondGiftNumAnimation:giftDict];
    }];
}

#pragma  mark - 显示礼物数目的缩放
- (void) showFirstGiftNumAnimation:(NSDictionary *)giftDict
{
    [self.firstShowGiftView showGiftNum:giftDict];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(7, 7, 13)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(6, 6, 12)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(5, 5, 10)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(3, 3, 8)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(.3, .3, 5)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 2)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 2)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 2)]];
    animation.duration = .5;
    animation.removedOnCompletion = YES;
    animation.delegate = self;
    [animation setValue:@"first" forKey:@"animationName"];
    
    [self.firstShowGiftView.giftNumLabel removeFromSuperview];
    [self.firstShowGiftView.giftNumLabel.layer addAnimation:animation forKey:@"first"];
    [self.firstShowGiftView addSubview:self.firstShowGiftView.giftNumLabel];
}

- (void) showSecondGiftNumAnimation:(NSDictionary *)giftDict
{
    [self.secondShowGiftView showGiftNum:giftDict];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(7, 7, 13)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(6, 6, 12)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(5, 5, 10)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(3, 3, 8)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(.3, .3, 5)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 2)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 2)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 2)]];
    animation.duration = .5;
    animation.removedOnCompletion = YES;
    animation.delegate = self;
    [animation setValue:@"second" forKey:@"animationName"];
    
    [self.secondShowGiftView.giftNumLabel removeFromSuperview];
    [self.secondShowGiftView.giftNumLabel.layer addAnimation:animation forKey:@"second"];
    [self.secondShowGiftView addSubview:self.secondShowGiftView.giftNumLabel];
}

- (void) upMoveView:(LiveUserSendGiftView *)view withIsFirstView:(BOOL)isFirstFlag
{
    ESWeakSelf;
    //上移动画
    [UIView animateWithDuration:1.0f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        view.top -= GIFT_SEG_HEIGHT;
        view.alpha = 0;
    } completion:^(BOOL finish){
        ESStrongSelf;
        view.top += GIFT_SEG_HEIGHT;
        view.right = 0;
        view.alpha = 1;
        // 结束上移动画
        if (isFirstFlag)
        {
            if (_self.firstContinousArray && _self.firstContinousArray.count > 0) {// 连续动画
                _self.firstShowGiftDict = _self.firstContinousArray[0];
                
                if (_self.firstContinousArray && _self.firstContinousArray.count > 0) {
                    [_self.firstContinousArray removeObjectAtIndex:0];
                }
                _self.firstShowGiftView.sendGiftDict = _self.firstShowGiftDict;
                [_self showFirstViewAnimation:_self.firstShowGiftDict];
            }
            else if (_self.allGiftDict && _self.allGiftDict.count > 0 && _self.allKeyArray && _self.allKeyArray.count > 0) {
                NSString *key = [_self.allKeyArray firstObject];
                [_self.allKeyArray removeObject:key];
                NSMutableArray *giftArray = _self.allGiftDict[key];
                [_self.allGiftDict removeObjectForKey:key];
                
                if (giftArray && giftArray.count > 0) {
                    NSDictionary *giftDict = [giftArray firstObject];
                    _self.firstShowGiftDict = giftDict;
                    [giftArray removeObject:giftDict];
                    [_self showFirstViewAnimation:_self.firstShowGiftDict];
                    
                    
                    if (giftArray && giftArray.count > 0) {
                        NSLog(@"gift array is not empty");
                        [_self.firstContinousArray addObjectsFromArray:giftArray];
                    } else {
                        NSLog(@"gift array isempty");
                    }
                }
               
                
//                if (_self.allShowGiftArray.count > 0) {
//                    NSMutableArray *delGift = [NSMutableArray array];
//                    for (int i = 0; i < _self.allShowGiftArray.count; i++) {
//                        NSDictionary * tempShowGift = _self.allShowGiftArray[i];
//                        if ([self isContinuous:_self.firstShowGiftDict withNewGift:tempShowGift])
//                        {// 第一个显示礼物view正在连续
//                            if (!_firstContinousArray) {
//                                _firstContinousArray = [NSMutableArray array];
//                            }
//                            [_firstContinousArray addObject:tempShowGift];
//                            [delGift addObject:tempShowGift];
//                        }
//                    }
//                    
//                    if (delGift.count > 0) {
//                        for (int i = 0; i < delGift.count; i++) {
//                            [_allShowGiftArray removeObject:delGift[i]];
//                        }
//                    }
//                }
            } else {
                _self.firstShowGiftView.hidden = YES;
                [_self.firstShowGiftView.giftNumLabel removeFromSuperview];
                [_self.firstShowGiftView removeFromSuperview];
                _self.firstShowGiftView = nil;
                _self.firstShowGiftDict = nil;
            }
        }
        else
        {
            if (_self.secondContinousArray && _self.secondContinousArray.count > 0) {// 连续动画
                _self.secondShowGiftDict = _self.secondContinousArray[0];
                
                if (_self.secondContinousArray && _self.secondContinousArray.count > 0) {
                    [_self.secondContinousArray removeObjectAtIndex:0];
                }
                _self.secondShowGiftView.sendGiftDict = _self.secondShowGiftDict;
                [_self showSecondViewAnimation:_self.secondShowGiftDict];
            }
            else if (_self.allGiftDict && _self.allGiftDict.count > 0 && _self.allKeyArray && _self.allKeyArray.count > 0) {
                
                NSString *key = [_self.allKeyArray firstObject];
                [_self.allKeyArray removeObject:key];
                NSMutableArray *giftArray = _self.allGiftDict[key];
                [_self.allGiftDict removeObjectForKey:key];
                
                if (giftArray && giftArray.count > 0) {
                    NSDictionary *giftDict = [giftArray firstObject];
                    _self.secondShowGiftDict = giftDict;
                    [giftArray removeObject:giftDict];
                    [_self showSecondViewAnimation:_self.secondShowGiftDict];
                    
                    
                    if (giftArray && giftArray.count > 0) {
                        NSLog(@"gift array is not empty");
                        [_self.secondContinousArray addObjectsFromArray:giftArray];
                    } else {
                        NSLog(@"gift array isempty");
                    }
                }
            } else {
                _self.secondShowGiftView.hidden = YES;
                [_self.secondShowGiftView.giftNumLabel removeFromSuperview];
                [_self.secondShowGiftView removeFromSuperview];
                _self.secondShowGiftView = nil;
            }
        }
     }];
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag)
    {
        NSString *animationName = [anim valueForKey:@"animationName"];
        if ([animationName isEqualToString:@"first"])
        {
            if (_firstContinousArray && _firstContinousArray.count > 0) {// 连续动画
                _firstShowGiftDict = _firstContinousArray[0];
                
                if (_firstContinousArray && _firstContinousArray.count > 0) {
                    [_firstContinousArray removeObjectAtIndex:0];
                }
                
                self.firstShowGiftView.sendGiftDict = _firstShowGiftDict;
                [self showFirstGiftNumAnimation:_firstShowGiftDict];
            } else {// 切换动画
//                ESWeakSelf
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    ESStrongSelf
                    [self upMoveView:_firstShowGiftView withIsFirstView:YES];
//                });
            }
        }  else if ([animationName isEqualToString:@"second"]) {
            if (_secondContinousArray && _secondContinousArray.count > 0) {// 连续动画
                _secondShowGiftDict = _secondContinousArray[0];
                
                if (_secondContinousArray && _secondContinousArray.count > 0)
                {
                    [_secondContinousArray removeObjectAtIndex:0];
                }
                self.secondShowGiftView.sendGiftDict = _secondShowGiftDict;
                [self showSecondGiftNumAnimation:_secondShowGiftDict];
            } else {// 切换动画
//                ESWeakSelf
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    ESStrongSelf
                    [self upMoveView:_secondShowGiftView withIsFirstView:NO];
//                });
            }
        }
          NSLog(@"allShowGiftArray:%ld _firstContinousArray:%ld  _secondContinousArray:%ld ",_allGiftDict?_allGiftDict.count:0,_firstContinousArray?_firstContinousArray.count:0,_secondContinousArray?_secondContinousArray.count:0);
    } else {
        NSLog(@"animationDidStop %d",flag);
    }
}


@end
