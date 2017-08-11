//
//  LCGameNiuniu.h
//  TaoHuaLive
//
//  Created by Jay on 2017/7/26.
//  Copyright © 2017年 上海七夕. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCGameView;

@interface LCGameNiuniu : UIView

@property (nonatomic, readonly) BOOL isHost;

@property (nonatomic, assign) NSInteger selectedSegmentIndex;

- (instancetype)initWithFrame:(CGRect)frame isHost:(BOOL)isHost;

- (void)resetUI;

- (void)startWithAnimation:(BOOL)animated;
- (void)timeoutCounting:(NSInteger)counting;
- (void)showBetActionWithArray:(NSArray *)array;

- (void)showMyBetActionWithArray:(NSArray *)array;

- (void)showResultWithDict:(NSDictionary *)dict;

- (void)betActionWithCompletionHandler:(void(^)(NSInteger amount, NSInteger index))completionHandler;


@end
