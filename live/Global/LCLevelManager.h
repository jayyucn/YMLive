//
//  LCLevelManager.h
//  XCLive
//
//  Created by jacklong on 15/10/31.
//  Copyright © 2015年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCLevelManager : NSObject

+ (LCLevelManager *)sharedDegreeManage;
// 魅力等级
-(int)getCharmDegreeByIncome:(double)income;

//获取魅力升级进度
-(float)getCharmDegreeProgress:(double)income;

// 消费等级

-(int)getConsumeDegreeByConsume:(double)consume;

//获取玩家升级进度

-(float)getConsumeDegreeProgress:(double)consume;


@end
