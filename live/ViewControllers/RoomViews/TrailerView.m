//
//  TrailerView.m
//  live
//
//  Created by hysd on 15/8/20.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import "TrailerView.h"
#import "Macro.h"
@interface TrailerView() <UITextFieldDelegate>
{
    
}
@end
@implementation TrailerView

- (void)awakeFromNib
{
        self.titleLabel.text = @"直播预告标题";
        self.titleLabel.textColor = RGB16(COLOR_FONT_BLACK);
        
        [self.titleTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"取个好名字更加吸引人哦..." attributes:@{NSForegroundColorAttributeName:RGB16(COLOR_FONT_LIGHTGRAY)}]];
        self.titleTextField.borderStyle = UITextBorderStyleNone;
        self.titleTextField.textColor = RGB16(COLOR_FONT_GRAY);
        
        self.coverLabel.text = @"封面图片";
        self.coverLabel.textColor = RGB16(COLOR_FONT_BLACK);
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getCover:)];
        self.coverImageView.userInteractionEnabled = YES;
        [self.coverImageView addGestureRecognizer:tap];
        
        self.timeLabel.text = @"直播时间";
        self.timeLabel.textColor = RGB16(COLOR_FONT_BLACK);
        
        [self.timeTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"选一个直播时间吧..." attributes:@{NSForegroundColorAttributeName:RGB16(COLOR_FONT_LIGHTGRAY)}]];
        self.timeTextField.borderStyle = UITextBorderStyleNone;
        self.timeTextField.delegate = self;
        self.timeTextField.textColor = RGB16(COLOR_FONT_GRAY);
        
        self.leftTimeLabel.textColor = RGB16(COLOR_FONT_GRAY);
        self.leftTimeLabel.text = @"";
        
        [self.publishButton setTitle:@"立即发布" forState:UIControlStateNormal];
        [self.publishButton setTitleColor:RGB16(COLOR_FONT_RED) forState:UIControlStateNormal];
        self.publishButton.layer.cornerRadius = self.publishButton.frame.size.height/2;
        self.publishButton.backgroundColor = RGB16(COLOR_BG_WHITE);
        self.publishButton.layer.borderWidth = 1;
        self.publishButton.layer.borderColor = RGB16(COLOR_BG_RED).CGColor;
        
        self.timeSepView.backgroundColor = RGB16(COLOR_BG_GRAY);
        self.titleSepView.backgroundColor = RGB16(COLOR_BG_GRAY);
        

        //为TextField添加inputAccessoryView
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-55, 5, 50.0f, 30.0f)];
        button.layer.cornerRadius = 4;
        [button setBackgroundColor:RGB16(COLOR_FONT_RED)];
        button.titleLabel.font = [UIFont systemFontOfSize: 15.0];
        [button setTitle:@"完成" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(completeInput) forControlEvents:UIControlEventTouchUpInside];
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40.0f)];
        [toolbar addSubview:button];
        toolbar.backgroundColor = RGB16(COLOR_BG_LIGHTGRAY);
        self.titleTextField.inputAccessoryView = toolbar;
        
        self.contentHeight.constant = SCREEN_HEIGHT;

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(self.delegate){
        [self.delegate trailerViewTime:self];
    }
    return NO;
}
- (void)completeInput{
    [self.titleTextField resignFirstResponder];
}

- (IBAction)publishAction:(id)sender {
    if(self.delegate){
        [self.delegate trailerViewPublish:self];
    }
}

- (void)getCover:(UITapGestureRecognizer*)recognizer{
    if(self.delegate){
        [self.delegate trailerViewTakeCover:self];
    }
}
@end
