//
//  LCSelectSexAlert.h
//  XCLive
//
//  Created by ztkztk on 14-10-13.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "LCCancelAndOKView.h"
#import "MMSinglePickerView.h"
typedef void(^SelectSexBlock)(int sex);
@interface LCSelectSexAlert : LCCancelAndOKView
@property (nonatomic,strong)MMSinglePickerView *singlePicker;
@property (nonatomic,strong)SelectSexBlock selectSexBlock;

+(id)selectSex:(int)sex withFinishBlock:(SelectSexBlock)selectSexBlock;
@end
