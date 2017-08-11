//
//  LCSinglePickerView.m
//  XCLive
//
//  Created by ztkztk on 14-4-19.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "MMSinglePickerView.h"


@implementation MMSinglePickerView

+(id)initWithEditType:(LCEditDetailType)editType
{
    MMSinglePickerView *pickerView=[[MMSinglePickerView alloc] initWithFrame:CGRectMake(0, 0, 280.0f, 162.0f)];
    //pickerView.editType=editType;
    return pickerView;
}

-(void)setEditType:(LCEditDetailType)editType
{
    _editType=editType;
    
    if(_editType==LCEditsex)
    {
        _titleArray=@[@"男",@"女"];
        if([LCMyUser mine].sex!=0)
            [self selectRow:[LCMyUser mine].sex-1
                inComponent: 0
                   animated: NO];
    }
}

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
        
        _titleArray=@[@"男",@"女"];
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
    if(_editType==LCEditIthink)
    {
        _selectBlock(row);
    }
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
