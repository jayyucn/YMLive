//
//  KFDefines1.m
//  KaiFang
//
//  Created by Elf Sundae on 13-11-21.
//  Copyright (c) 2013年 www.0x123.com. All rights reserved.
//

#import "LCDefines.h"

LCRange LCRangeMake(int left, int right)
{
        LCRange range;
        range.left = left;
        range.right = right;
        return range;
}

LCRange const LCRangeZero = {0, 0};

BOOL LCRangeIsZero(LCRange range)
{
        return range.left == 0 && range.right == 0;
}

NSString *LCRangeToString(LCRange range)
{
        return NSStringWith(@"%d,%d", range.left, range.right);
}

LCRange LCRangeFromString(NSString *string)
{
        LCRange range;
        if ([string isKindOfClass:[NSString class]] && [string contains:@","]) {
                NSArray *array = [string componentsSeparatedByString:@","];
                if (2 == array.count) {
                        int left,right;
                        ESIntVal(&left, array[0]);
                        ESIntVal(&right, array[1]);
                        range.left = left;
                        range.right = right;
                }
        }
        return range;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Functions
void KFLog(NSString *format, ...)
{
#if DEBUG
        va_list args;
        va_start(args, format);
        NSString *log = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
        
        static NSDateFormatter *dateFormatter = nil;
        if (nil == dateFormatter) {
                dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
                dateFormatter.locale = [NSLocale currentLocale];
        }
        NSString *nowDateString = [dateFormatter stringFromDate:[NSDate date]];
        
        printf("%s [KFLog] : %s\n",
               [nowDateString UTF8String],
               [log UTF8String] );
#endif
}

