//
//  MMAlertTextView.m
//  MaMaTao
//
//  Created by ztkztk on 14-9-11.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "MMAlertTextView.h"
#import "LCDefines.h"

@implementation MMAlertTextView

+(void)showAlertTextView:(NSString *)title
            textViewText:(NSString *)text
              holderText:(NSString *)holderText
         withEditedBlock:(LCAlertTextViewOKBlock)okBlock
{
    MMAlertTextView *instanceView=[[MMAlertTextView alloc] init];
    [instanceView setTitle:title];
    instanceView.textView.text=holderText;
    instanceView.holderText=holderText;
    instanceView.textView.textColor=[UIColor grayColor];
    instanceView.oKBlock=okBlock;
    [instanceView showWithAnimated];
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
        
        
        _textView=[[UITextView alloc] initWithFrame:CGRectMake(0,0,LCAlertViewWidth,100)];
        //_textView.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        //_textView.adjustsFontSizeToFitWidth = YES;
        _textView.font=[UIFont systemFontOfSize:14.0f];
       // _textView.borderStyle=UITextBorderStyleRoundedRect;
        _textView.returnKeyType=UIReturnKeyDone;
        _textView.delegate=self;
        [self.backgroundView addSubview:_textView];
        //[_textView becomeFirstResponder];
        self.editView=_textView;
        //self.offsetY=80;
        
        _textView.layer.cornerRadius = 2;
        _textView.layer.masksToBounds = YES;
        
        [self addKeyboardNotification];
        
    }
    return self;
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
        self.centerY=ScreenHeight/2-120;
     }];
    
}

- (void)handleKeyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3f animations:^{
        self.centerY=ScreenHeight/2+30;
    }];
}



- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([_textView.text isEqualToString:_holderText])
    {
        _textView.textColor=[UIColor blackColor];
        _textView.text=@"";
    }
    
}

/*
- (void)textViewDidChange:(UITextView *)textView
{
    if([_textView.text isEqualToString:@""])
    {
        _textView.text=_holderText;
        _textView.textColor=[UIColor grayColor];
    }else if([_textView.text isEqualToString:_holderText])
    {
        _textView.textColor=[UIColor blackColor];
        _textView.text=@"";
    }


}
*/


-(void)submitAction
{
    [_textView resignFirstResponder];
    _oKBlock(_textView.text);
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
