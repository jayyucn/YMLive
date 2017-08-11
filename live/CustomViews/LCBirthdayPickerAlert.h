//
//  LCBirthdayPickerAlert.h
//  XCLive
//
//  Created by ztkztk on 14-10-13.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "LCCancelAndOKView.h"
#import "MMEditBirthdayPicker.h"

typedef void(^BrithdayPickerBlock)(NSString *bridayString);
@interface LCBirthdayPickerAlert : LCCancelAndOKView
@property (nonatomic,strong)MMEditBirthdayPicker *birthdayPicker;
@property (nonatomic,strong)BrithdayPickerBlock brithdayPickerBlock;

+(id)birthdayPicker:(NSString *)dateString withFinishBlock:(BrithdayPickerBlock)brithdayPickerBlock;
@end
