//
//  LCGameView.h
//  TaoHuaLive
//
//  Created by Jay on 2017/7/25.
//  Copyright © 2017年 上海七夕. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const kGameViewHeight;
extern NSNotificationName const kGameResultDidShowNotification;

@protocol LCGameViewDelegate <NSObject>

- (void)gameShouldClose;

- (void)gameShouldRechargeDiamond;

- (void)showHistory;

@end

typedef NS_ENUM(NSInteger, CurrentGameType) {
    CurrenGameTypeNone,
    CurrentGameTypeNiuniu
};


@interface LCGameView : UIView

@property (nonatomic, weak) id<LCGameViewDelegate> delegate;
@property (nonatomic, readonly) CurrentGameType type;

@property (nonatomic, assign) BOOL isShowing;

@property (nonatomic, readonly) BOOL isHost;

- (void)showWithGameType:(CurrentGameType)type isHost:(BOOL)isHost;

//- (void)startWithCompletionHandler:(void(^)())completionHandler; //发牌动画
- (void)startWithAnimation:(BOOL)animated;//发牌动画
- (void)timeoutCounting:(NSInteger)counting;
- (void)showBetActionWithArray:(NSArray *)array;
- (void)showMyBetActionWithArray:(NSArray *)array;
- (void)betActionWithCompletionHander:(void(^)(NSInteger amount, NSInteger index))completionHandler;
- (void)showResultWithDict:(NSDictionary *)dict;

@end
