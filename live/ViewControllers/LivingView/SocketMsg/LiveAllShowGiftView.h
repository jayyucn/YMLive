//
//  LiveAllSendGiftView.h
//  qianchuo 显示礼物
//
//  Created by jacklong on 16/3/14.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "LiveUserSendGiftView.h"

@interface LiveAllShowGiftView : UIView

@property (nonatomic, strong) LiveUserSendGiftView  *firstShowGiftView;
@property (nonatomic, strong) LiveUserSendGiftView  *secondShowGiftView;

@property (nonatomic, strong) NSDictionary          *firstShowGiftDict;
@property (nonatomic, strong) NSDictionary          *secondShowGiftDict;

@property (nonatomic, strong) NSMutableArray        *firstContinousArray;// 优先考虑连续礼物显示
@property (nonatomic, strong) NSMutableArray        *secondContinousArray;

//@property (nonatomic, strong) NSMutableArray        *allShowGiftArray;
@property (nonatomic, strong) NSMutableDictionary   *allGiftDict;
@property (nonatomic, strong) NSMutableArray        *allKeyArray;

// 显示礼物动画
- (void) showGiftView:(NSDictionary *)giftDict;

// 隐藏礼物动画
- (void) hiddenGiftView;

#pragma mark - 开始赠送礼物动画
- (void) startSendGiftViewAnimation;

@end
