//
//  ShowAdView.h
//  qianchuo
//
//  Created by jacklong on 16/6/28.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

// 显示用户详情
typedef void(^ShowAdDetailBlock)();
typedef void(^AdCallbackBlock)();

@interface ShowAdView : UIView

@property (nonatomic,strong)NSDictionary    *advDict;

@property (nonatomic, copy) ShowAdDetailBlock adDetailBlock;
@property (nonatomic, copy) ShowAdDetailBlock callbackBlock;

#pragma mark - 显示view
- (void)showView:(UIView*)superView;

@end
