//
//  LCSelectSexAlert.m
//  XCLive
//
//  Created by ztkztk on 14-10-13.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "LCSelectSexAlert.h"

@implementation LCSelectSexAlert

+(id)selectSex:(int)sex withFinishBlock:(SelectSexBlock)selectSexBlock
{
    LCSelectSexAlert *instanceView=[[LCSelectSexAlert alloc] init];
    
    
    [instanceView createPicker:sex];
    instanceView.selectSexBlock=selectSexBlock;
    [instanceView showWithAnimated];
    
    return instanceView;

}

-(void)createPicker:(int)sex
{
    [self setTitle:@"请选择性别"];
    _singlePicker=[MMSinglePickerView initWithEditType:LCEditsex];
    
    [_singlePicker selectRow:sex
                 inComponent: 0
                    animated: NO];

    [self.backgroundView addSubview:_singlePicker];
    _singlePicker.width=LCAlertViewWidth;
    self.editView=_singlePicker;
    self.offsetY=0;
    
}


-(void)submitAction
{
    _selectSexBlock((int)[_singlePicker selectedRowInComponent:0]);
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
