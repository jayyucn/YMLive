//
//  LCAlertTextFieldView.h
//  XCLive
//
//  Created by ztkztk on 14-4-25.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCCancelAndOKView.h"

typedef void(^LCAlertTextFieldOKBlock)(NSString *text);
@interface LCAlertTextFieldView : LCCancelAndOKView<UITextFieldDelegate>
@property (nonatomic,strong)UITextField *textField;
@property (nonatomic,strong)LCAlertTextFieldOKBlock oKBlock;

+(void)showAlertTextFieldView:(NSString *)title
                textFieldText:(NSString *)text
                   ploderText:(NSString *)ploderText
              withEditedBlock:(LCAlertTextFieldOKBlock)okBlock;
+(instancetype)showAlertTextFieldView:(NSString *)title
                textFieldText:(NSString *)text
              withEditedBlock:(LCAlertTextFieldOKBlock)okBlock;

@end
