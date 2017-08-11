//
//  NSString+LCAppendString.h
//  XCLive
//
//  Created by ztkztk on 14-5-27.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LCAppendString)

+(NSString *)customAppendString:(NSString *)string1 string2:(NSString *)string2;

-(NSString *)getEmailAddress;
@end
