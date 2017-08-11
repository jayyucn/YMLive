//
//  TimePickView.h
//  live
//
//  Created by hysd on 15/8/21.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TimePickView;
@protocol TimePickViewDelegate <NSObject>
- (void)datePickViewConfirm:(TimePickView*)datePickView;
@end;
@interface TimePickView : UIView
@property (weak, nonatomic) id<TimePickViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *sep1View;
@property (weak, nonatomic) IBOutlet UIView *sep2View;
- (IBAction)cancelAction:(id)sender;
- (IBAction)confirmAction:(id)sender;
- (NSString*)getLeftTime;
- (NSString*)getSelectTime;
- (void)showView:(UIView*)superView;
@end
