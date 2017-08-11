//
//  GiftModel.h
//  presentAnimation
//
//  Created by jacklong on 16/7/15.
//  Copyright © 2016年 jacklong. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface GiftModel : NSObject
@property (nonatomic,strong) NSString *headUrl; // 头像
@property (nonatomic,assign) int giftId; // 礼物
@property (nonatomic,copy) NSString *name; // 送礼物者
@property (nonatomic,copy) NSString *giftName; // 礼物名称
@property (nonatomic,assign) NSInteger giftCount; // 礼物个数
@end
