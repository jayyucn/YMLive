//
//  LCSinglePickerView.h
//  XCLive
//
//  Created by ztkztk on 14-4-19.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCMyUser.h"

typedef void(^LCSelectPickerBlock)(NSInteger selectRow);
@interface LCSinglePickerView : UIPickerView<UIPickerViewDelegate, UIPickerViewDataSource>

//@property (nonatomic)LCEditDetailType editType;
@property (nonatomic)NSArray *titleArray;
@property (nonatomic,strong)LCSelectPickerBlock selectBlock;
+(id)initWithEditType:(LCEditDetailType)editType;

@end
