//
//  QCEditLocalView.m
//  qianchuo
//
//  Created by jacklong on 16/6/13.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "QCEditLocalView.h"
#import "QCEditLocalPicker.h"

@implementation QCEditLocalView
+(void)showEditViewAndEditedBlock:(QCEditedBlock)editedBlock
{
    QCEditLocalView *instanceView=[[QCEditLocalView alloc] init];
    instanceView.editedBlock = editedBlock;
    [instanceView editLocalView];
    [instanceView showWithAnimated];
}



-(void)submitAction
{
    QCEditLocalPicker *localPicker=(QCEditLocalPicker *)self.editView;
    _editedBlock([localPicker getSelectLocal]);
}


#pragma mark show edit detail view

//修改
-(void)editLocalView
{
    [self setTitle:ESLocalizedString(@"请选择定位地区")];
    QCEditLocalPicker *localPicker=[QCEditLocalPicker localPicker];
    [self.backgroundView addSubview:localPicker];
    [localPicker showCurrentLocal:[LCMyUser mine].city city:[LCMyUser mine].city];
    self.editView=localPicker;
    self.offsetY=0;
}

@end
