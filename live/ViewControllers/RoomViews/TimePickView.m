//
//  TimePickView.m
//  live
//
//  Created by hysd on 15/8/21.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import "TimePickView.h"
#import "Macro.h"
@interface TimePickView()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray *days;
    NSMutableArray *hours;
    NSMutableArray *minutes;
    NSString* leftTime;
    UIView* bgView;
}
@end
@implementation TimePickView

- (void)awakeFromNib
{
    self.backgroundColor = RGB16(COLOR_BG_WHITE);
    self.sep1View.backgroundColor = RGB16(COLOR_BG_GRAY);
    self.sep2View.backgroundColor = RGB16(COLOR_BG_GRAY);
    
    self.frame = CGRectMake(0, SCREEN_HEIGHT-200, SCREEN_WIDTH, 200);
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgView.backgroundColor = [UIColor clearColor];
    [bgView addSubview:self];
    
    [self initPickViewData];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self setDefaultPickView];
}

- (IBAction)cancelAction:(id)sender {
    [self hideView];
}

- (IBAction)confirmAction:(id)sender {
    if(self.delegate){
        [self.delegate datePickViewConfirm:self];
    }
    [self hideView];
}
- (void)showView:(UIView*)superView{
    self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200);
    [bgView addSubview:self];
    [superView addSubview:bgView];
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT-200, SCREEN_WIDTH, 200);
    }];
}
- (void)hideView{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH,200);
    } completion:^(BOOL finished) {
        [bgView removeFromSuperview];
    }];
}
#pragma mark pick view
- (void)initPickViewData{
    days = [[NSMutableArray alloc] initWithObjects:@"今天",@"明天", nil];
    hours = [[NSMutableArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",
             @"5",@"6",@"7",@"8",@"9",
             @"10",@"11",@"12",@"13",@"14",
             @"15",@"16",@"17",@"18",@"19",
             @"20",@"21",@"22",@"23",nil];
    minutes = [[NSMutableArray alloc] initWithObjects:@"0",@"10",@"20",@"30",@"40",@"50", nil];
}
- (void)setDefaultPickView{
    NSDateComponents* comps = [self getNowDateComponents];
    NSInteger dayRow = 0;
    NSInteger hourRow = [comps hour];
    NSInteger minuteRow = [comps minute] / 10 + 1;
    if(60 == minuteRow*10){
        hourRow += 1;
        minuteRow = 0;
        if(24 == hourRow){
            dayRow += 1;
            hourRow = 0;
        }
    }
    [self.pickerView selectRow:dayRow inComponent:0 animated:YES];
    [self.pickerView selectRow:hourRow inComponent:1 animated:YES];
    [self.pickerView selectRow:minuteRow inComponent:2 animated:YES];
    [self setLeftTime];
}
- (void)setLeftTime{
    NSDateComponents* comps = [self getNowDateComponents];
    NSInteger dayCur = 0;
    NSInteger hourCur = [comps hour];
    NSInteger minuteCur = [comps minute];
    //选择时间
    NSInteger dayRow = [self.pickerView selectedRowInComponent:0];
    NSInteger hourRow = [self.pickerView selectedRowInComponent:1];
    NSInteger minuteRow = [self.pickerView selectedRowInComponent:2];
    if((dayRow > dayCur) ||
       (dayRow == dayCur && hourRow > hourCur) ||
       (dayRow == dayCur && hourRow == hourCur && minuteRow*10 > minuteCur)){
        NSInteger dayLeft = dayRow - dayCur;
        NSInteger hourLeft = (hourRow - hourCur) + dayLeft * 24;
        NSInteger minuteLeft = minuteRow*10 - minuteCur;
        NSString* leftStr = @"";
        if(hourLeft < 0){
            dayLeft -= 1;
            hourLeft += 24;
        }
        if(minuteLeft < 0){
            hourLeft -= 1;
            minuteLeft += 60;
        }
        if(0 != hourLeft){
            leftStr = [leftStr stringByAppendingString:[NSString stringWithFormat:@"%ld小时",(long)hourLeft]];
        }
        if(0 != minuteLeft){
            leftStr = [leftStr stringByAppendingString:[NSString stringWithFormat:@"%ld分钟后",(long)minuteLeft]];
        }
        else{
            leftStr = [leftStr stringByAppendingString:@"后"];
        }
        leftTime = leftStr;
    }
    else{
        [self setDefaultPickView];
    }
}
- (NSDateComponents*)getNowDateComponents{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *now = [NSDate date];
//    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:now];
    return comps;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(0 == component){
        return days.count;
    }
    else if(1 == component){
        return hours.count;
    }
    else{
        return minutes.count;
    }
}
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString* title;
    if(0 == component){
        title = days[row];
    }
    else if(1 == component){
        title = hours[row];
    }
    else{
        title = minutes[row];
    }
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:RGB16(COLOR_FONT_BLACK)}];
    return attString;
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [self setLeftTime];
}

- (NSString*)getLeftTime{
    return leftTime;
}
- (NSString*)getSelectTime{
    //选择时间
    NSInteger dayRow = [self.pickerView selectedRowInComponent:0];
    NSInteger hourRow = [self.pickerView selectedRowInComponent:1];
    NSInteger minuteRow = [self.pickerView selectedRowInComponent:2];
    
    NSDateComponents* comps = [self getNowDateComponents];
    NSInteger secodes = ((dayRow * 24 + hourRow - comps.hour) * 60 + minuteRow * 10 - comps.minute) * 60;
    NSDate *date = [NSDate dateWithTimeInterval:secodes sinceDate:[NSDate date]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [formatter stringFromDate:date];
}
@end

