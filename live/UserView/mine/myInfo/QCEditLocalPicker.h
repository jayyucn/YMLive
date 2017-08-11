//
//  QCEditLocalPicker.h
//  qianchuo
//
//  Created by jacklong on 16/6/13.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2
@interface QCEditLocalPicker : UIPickerView<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic,strong)NSArray *localArray;
+(id)localPicker;
-(void)showCurrentLocal:(NSString *)province city:(NSString *)city;
-(NSDictionary *)getSelectLocal;
@end