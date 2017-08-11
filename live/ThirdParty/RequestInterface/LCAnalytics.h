//
//  LCAnalytics.h
//  XCLive
//
//  Created by ztkztk on 14-7-10.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCAnalytics : NSObject


+(void)analyticsWithType:(NSString *)type;
+(void)analyticsInWithType:(NSString *)type;
+(void)shareSuccessWithType:(NSString *)type;
@end
