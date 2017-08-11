//
//  NSDate+YearAndMonthFormat.m
//  KaiFang
//
//  Created by ztkztk on 13-10-17.
//  Copyright (c) 2013年 www.0x123.com. All rights reserved.
//

#import "NSDate+YearAndMonthFormat.h"

@implementation NSDate (YearAndMonthFormat)

//日期转换年月
+(NSString *)formateDateToYearAndMonth:(NSDate *)date
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM"];//@"yyyy-MM-dd HH:mm:ss"
    
    return [dateFormatter stringFromDate:date];
    
}


//日期转换年月
+(NSString *)formateDateToYearAndMonthAndDay:(NSDate *)date
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];//@"yyyy-MM-dd HH:mm:ss"
    
    return [dateFormatter stringFromDate:date];
    
}





@end
