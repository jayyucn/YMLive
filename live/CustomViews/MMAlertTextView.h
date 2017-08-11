//
//  MMAlertTextView.h
//  MaMaTao
//
//  Created by ztkztk on 14-9-11.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCCancelAndOKView.h"
typedef void(^LCAlertTextViewOKBlock)(NSString *text);
@interface MMAlertTextView : LCCancelAndOKView<UITextViewDelegate>

@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,strong)NSString *holderText;
@property (nonatomic,copy)LCAlertTextViewOKBlock oKBlock;

+(void)showAlertTextView:(NSString *)title
                textViewText:(NSString *)text
              holderText:(NSString *)holderText
              withEditedBlock:(LCAlertTextViewOKBlock)okBlock;
@end
