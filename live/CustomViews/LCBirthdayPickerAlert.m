//
//  LCBirthdayPickerAlert.m
//  XCLive
//
//  Created by ztkztk on 14-10-13.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "LCBirthdayPickerAlert.h"
#import "NSDate+YearAndMonthFormat.h"

@implementation LCBirthdayPickerAlert

+(id)birthdayPicker:(NSString *)dateString withFinishBlock:(BrithdayPickerBlock)brithdayPickerBlock
{
    LCBirthdayPickerAlert *instanceView=[[LCBirthdayPickerAlert alloc] init];
    [instanceView createPicker:dateString];
    instanceView.brithdayPickerBlock=brithdayPickerBlock;
    [instanceView showWithAnimated];

    return instanceView;
}


-(void)createPicker:(NSString *)dateString
{
    [self setTitle:@"请选择生日"];
    _birthdayPicker=[MMEditBirthdayPicker editBirthdayPicker:dateString];
    [self.backgroundView addSubview:_birthdayPicker];
    _birthdayPicker.width=LCAlertViewWidth;
    self.editView=_birthdayPicker;
    self.offsetY=0;

}

-(void)submitAction
{
   
    NSDate *pickerDate=_birthdayPicker.date;
    NSString *dateString=[NSDate formateDateToYearAndMonthAndDay:pickerDate];
  //  NSDictionary *parameters=@{@"birthday":dateString};

    _brithdayPickerBlock(dateString);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
