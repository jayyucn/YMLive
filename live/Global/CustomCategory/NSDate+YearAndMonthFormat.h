//
//  NSDate+YearAndMonthFormat.h
//  KaiFang
//
//  Created by ztkztk on 13-10-17.
//  Copyright (c) 2013年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (YearAndMonthFormat)
+(NSString *)formateDateToYearAndMonth:(NSDate *)date;
+(NSString *)formateDateToYearAndMonthAndDay:(NSDate *)date;


@end
