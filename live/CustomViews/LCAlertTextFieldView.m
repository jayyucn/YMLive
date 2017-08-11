//
//  LCAlertTextFieldView.m
//  XCLive
//
//  Created by ztkztk on 14-4-25.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCAlertTextFieldView.h"
#import "LCDefines.h"

@implementation LCAlertTextFieldView


+(void)showAlertTextFieldView:(NSString *)title
                textFieldText:(NSString *)text
                   ploderText:(NSString *)ploderText
              withEditedBlock:(LCAlertTextFieldOKBlock)okBlock
{
    LCAlertTextFieldView *instanceView=[[LCAlertTextFieldView alloc] init];
    [instanceView setTitle:title];
    instanceView.textField.text=text;
    instanceView.textField.placeholder=ploderText;
    instanceView.oKBlock=okBlock;
    [instanceView showWithAnimated];
    
    //instanceView.centerY=ScreenHeight/2-80;
    
}




+(instancetype)showAlertTextFieldView:(NSString *)title
                textFieldText:(NSString *)text
              withEditedBlock:(LCAlertTextFieldOKBlock)okBlock
{
    LCAlertTextFieldView *instanceView=[[LCAlertTextFieldView alloc] init];
    [instanceView setTitle:title];
    instanceView.textField.text=text;
    instanceView.oKBlock=okBlock;
    [instanceView showWithAnimated];
    
    [instanceView performSelector:@selector(becameFirst) withObject:nil afterDelay:0.2f];
    //instanceView.centerY=ScreenHeight/2-80;
        return instanceView;
}


-(void)becameFirst
{
    
    [self.textField becomeFirstResponder];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        _textField=[[UITextField alloc] initWithFrame:CGRectMake(0,0,LCAlertViewWidth,40)];
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.adjustsFontSizeToFitWidth = YES;
        _textField.font=[UIFont systemFontOfSize:18.0f];
        _textField.borderStyle=UITextBorderStyleRoundedRect;
        _textField.returnKeyType=UIReturnKeyDone;
        _textField.delegate=self;
        [self.backgroundView addSubview:_textField];
        
        self.editView=_textField;
        //self.offsetY=80;
        
        [self addKeyboardNotification];

    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self okAction];
    return YES;
}


-(void)addKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}


- (void)handleKeyboardDidShow:(NSNotification *)notification
{
    //[self.rootViewController.contentView bringSubviewToFront:self];
    [UIView animateWithDuration:0.3f animations:^{
        //_rootView.top=UserInterfaceShowTop;
        self.centerY=ScreenHeight/2-80;
    }];
    
}

- (void)handleKeyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3f animations:^{
        self.centerY=ScreenHeight/2+30;
    }];
    
}



-(void)submitAction
{
    [_textField resignFirstResponder];
    _oKBlock(_textField.text);
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
