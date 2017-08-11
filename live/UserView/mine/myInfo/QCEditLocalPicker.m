//
//  QCEditLocalPicker.m
//  qianchuo
//
//  Created by jacklong on 16/6/13.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "QCEditLocalPicker.h"

@implementation QCEditLocalPicker

+(id)localPicker
{
    QCEditLocalPicker *localPicker=[[QCEditLocalPicker alloc] initWithFrame:CGRectMake(0, 0, 280.0f, 100.0f)];
    
    return localPicker;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        NSString *localPath=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"local.json"];
        
        NSData *jsonData = [[NSFileManager defaultManager] contentsAtPath:localPath];
        
        _localArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];
        
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


-(void)showCurrentLocal:(NSString *)province city:(NSString *)city
{
    
    for(int i=0;i<[_localArray count];i++)
    {
        if([_localArray[i][@"prov"] isEqualToString:province])
        {
            [self selectRow:i inComponent: PROVINCE_COMPONENT animated: NO];
            [self reloadComponent: PROVINCE_COMPONENT];
            NSArray *cityArray=_localArray[i][@"city"];
            for(int j=0;j<[cityArray count];j++)
            {
                if([cityArray[j] isEqualToString:city])
                {
                    [self selectRow:j inComponent: CITY_COMPONENT animated: NO];
                    [self reloadComponent: CITY_COMPONENT];
                    break;
                }
            }
            break;
        }
    }
    
}


-(NSDictionary *)getSelectLocal
{
    NSInteger provinceIndex = [self selectedRowInComponent: PROVINCE_COMPONENT];
    NSInteger cityIndex = [self selectedRowInComponent: CITY_COMPONENT];
    
    NSString *provinceStr = _localArray[provinceIndex][@"prov"];
    NSString *cityStr = _localArray[provinceIndex][@"city"][cityIndex];
    
    NSDictionary *selectedLocal=@{@"prov":provinceStr,@"city":cityStr};
    return selectedLocal;
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        
        return [_localArray count];
    }
    else if (component == CITY_COMPONENT) {
        
        NSInteger provinceIndex = [pickerView selectedRowInComponent: PROVINCE_COMPONENT];
        NSArray *cityArray=_localArray[provinceIndex][@"city"];
        return [cityArray count];
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component;
{
    return self.width/2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return _localArray[row][@"prov"];
    }
    else if (component == CITY_COMPONENT) {
        NSInteger provinceIndex = [pickerView selectedRowInComponent: PROVINCE_COMPONENT];
        NSArray *cityArray=_localArray[provinceIndex][@"city"];
        if (row < cityArray.count) {
            return cityArray[row];
        }
    }
    return @"";
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT)
    {
        [pickerView selectRow:0 inComponent: CITY_COMPONENT animated: YES];
        [pickerView reloadComponent: CITY_COMPONENT];
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
