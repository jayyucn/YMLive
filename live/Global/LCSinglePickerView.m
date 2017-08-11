//
//  LCSinglePickerView.m
//  XCLive
//
//  Created by ztkztk on 14-4-19.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCSinglePickerView.h"


@implementation LCSinglePickerView

+(id)initWithEditType:(LCEditDetailType)editType
{
    LCSinglePickerView *pickerView=[[LCSinglePickerView alloc] initWithFrame:CGRectMake(0, 0, 280.0f, 162.0f)];
//    pickerView.editType=editType;
    return pickerView;
}

//-(void)setEditType:(LCEditDetailType)editType
//{
//    _editType=editType;
//    
//    if(_editType==LCEditsex)
//    {
//        _titleArray=@[@"男",@"女"];
//        if([LCMyUser mine].sex!=0)
//            [self selectRow:[LCMyUser mine].sex-1
//                inComponent: 0
//                   animated: NO];
//    }else if(_editType==LCEditHeight)
//    {
//        NSMutableArray *heightArray=[NSMutableArray array];
//        for(int i=140;i<250;i++)
//        {
//            [heightArray addObject:[NSString stringWithFormat:@"%d厘米",i]];
//        }
//        
//        _titleArray=heightArray;
////        if([LCMyUser mine].height!=0)
////            [self selectRow:[LCMyUser mine].height-140
////                inComponent: 0
////                   animated: NO];
//        
//    }
//    else if(_editType==LCEditDegree)
//    {
////        NSMutableArray *degreeArray=[NSMutableArray array];
////        for(int i=0;i<=7;i++)
////        {
////            [degreeArray addObject:LCDegreeName(i)];
////        }
////        _titleArray=degreeArray;
////        [self selectRow:/*[LCMyUser mine].degree*/LCDegreeTypeFromString([LCMyUser mine].degree)
////            inComponent: 0
////               animated: NO];
//
//    }
//    else if(_editType==LCEditMarriage)
//    {
//        NSMutableArray *marriageArray=[NSMutableArray array];
//        for(int i=0;i<4;i++)
//        {
//            [marriageArray addObject:LCMarriageName(i)];
//        }
//        _titleArray=marriageArray;
//        
////        [self selectRow:[LCMyUser mine].marry
////            inComponent: 0
////               animated: NO];
//        
//    }
//    else if(_editType==LCEditWage)
//    {
//        NSMutableArray *wageArray=[NSMutableArray array];
//        for(int i=0;i<100;i++)
//        {
//            [wageArray addObject:[NSString stringWithFormat:@"%d",1000+i*1000]];
//        }
//        _titleArray=wageArray;
////        if([LCMyUser mine].wage>=1000)
////            [self selectRow:(int)[LCMyUser mine].wage/1000-1
////                inComponent: 0
////                   animated: NO];
//        
//    }else if(_editType==LCEditIthink)
//    {
//        _titleArray=iThinkList();
//        
//        [self selectRow:selectIThink()
//            inComponent: 0
//               animated: NO];
//        
//    }else if(_editType==LCJob)
//    {
//        _titleArray=jobList();
//        [self selectRow:selectJob()
//            inComponent: 0
//               animated: NO];
//        
//    }else if(_editType==LCStature)
//    {
//        _titleArray=statureList();
//        [self selectRow:selectStature()
//            inComponent: 0
//               animated: NO];
//     }
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.dataSource = self;
        self.delegate = self;
        CALayer * layer = [self layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:5];
        [layer setBorderWidth:0.5];
        [layer setBorderColor:[UIColor grayColor].CGColor];
    }
    return self;
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_titleArray count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component;
{
    return self.width;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0f;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _titleArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    if(_editType==LCEditIthink)
//    {
//        _selectBlock(row);
//    }
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
