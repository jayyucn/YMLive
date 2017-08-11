//
//  LCLoginrequest.h
//  XCLive
//
//  Created by ztkztk on 14-4-28.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^LCLoginSuccessBlock)(NSDictionary *dic);
@interface LCLoginAndExitRequest : NSObject


+(void)login:(NSDictionary *)dic withBlock:(LCLoginSuccessBlock)resultBlock;
+(void)exitLC;
@end
