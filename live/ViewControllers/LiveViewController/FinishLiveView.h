//
//  FinishLiveView.h
//  qianchuo
//
//  Created by jacklong on 16/4/25.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FinishLiveView;

@protocol FinishLiveViewDelegate <NSObject>
- (void)finishViewClose:(FinishLiveView*)fv;


// 继续直播
- (void)onContinueLive;
@end

@interface FinishLiveView : UIView

@property (weak, nonatomic) id<FinishLiveViewDelegate> delegate;

@property (assign, nonatomic) BOOL connectTimeout;
/**
 *  showView
 *  @param superView  父视图
 *  @param audience   观众数量
 *  @param praise     点赞数量
 */
- (void)showView:(UIView*)superView audience:(int)audience revMoney:(int)money praise:(int)praise hotData:(NSMutableArray *)hotArray;

@end
