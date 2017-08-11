//
//  LCBlackListManager.h
//  XCLive
//
//  Created by ztkztk on 14-5-13.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LCBlackManagerBlock)(BOOL success);
@interface LCBlackListManager : NSObject

+(void)addBlack:(NSString *)userID withBlock:(LCBlackManagerBlock)blackBlock;
+(void)deleteBlack:(NSString *)userID withBlock:(LCBlackManagerBlock)blackBlock;
@end
