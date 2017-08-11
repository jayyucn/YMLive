//
//  LCEditBirthdayPicker.m
//  XCLive
//
//  Created by ztkztk on 14-4-19.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "MMEditBirthdayPicker.h"

@implementation MMEditBirthdayPicker

+(id)editBirthdayPicker:(NSString *)dateString
{
    MMEditBirthdayPicker *datePicker=[[MMEditBirthdayPicker alloc] initWithFrame:CGRectMake(0, 0, 280.0f, 100.0f)];
    
    if(dateString)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd"];
        NSDate *destDate= [dateFormatter dateFromString:dateString];
        [datePicker setDate:destDate animated:YES];
    }
    
    return datePicker;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.datePickerMode=UIDatePickerModeDate;
           // self.maximumDate = [NSDate dateWithTimeIntervalSinceNow:180*24*60*60];
        
        self.maximumDate = [NSDate date];
        CALayer * layer = [self layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:5];
        [layer setBorderWidth:0.5];
        [layer setBorderColor:[UIColor grayColor].CGColor];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
