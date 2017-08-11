//
//  LiveView.m
//  live
//
//  Created by hysd on 15/8/20.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import "LiveView.h"
#import "Macro.h"
@implementation LiveView
- (void)awakeFromNib
{
    
        self.titleLabel.text = @"直播标题";
        self.titleLabel.textColor = RGB16(COLOR_FONT_BLACK);
        
        [self.titleTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"取个好名字更加吸引人哦..." attributes:@{NSForegroundColorAttributeName:RGB16(COLOR_FONT_LIGHTGRAY)}]];
        self.titleTextField.borderStyle = UITextBorderStyleNone;
        self.titleTextField.textColor = RGB16(COLOR_FONT_GRAY);
        
#if DEBUG
        self.titleTextField.text = @"这是一个测试";
#endif
        
        self.coverLabel.text = @"封面图片";
        self.coverLabel.textColor = RGB16(COLOR_FONT_BLACK);
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getCover:)];
        self.coverImageView.userInteractionEnabled = YES;
        [self.coverImageView addGestureRecognizer:tap];
        
        [self.liveButton setTitle:@"开始直播" forState:UIControlStateNormal];
        [self.liveButton setTitleColor:RGB16(COLOR_FONT_RED) forState:UIControlStateNormal];
        self.liveButton.layer.cornerRadius = self.liveButton.frame.size.height/2;
        self.liveButton.layer.borderWidth = 1;
        self.liveButton.layer.borderColor = RGB16(COLOR_BG_RED).CGColor;
        self.liveButton.backgroundColor = RGB16(COLOR_BG_WHITE);
        
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

- (void)completeInput{
    [self.titleTextField resignFirstResponder];
}

- (IBAction)liveAction:(id)sender {
    if(self.delegate){
        [self.delegate liveVIewStartLive:self];
    }
}

- (void)getCover:(UITapGestureRecognizer*)recognizer{
    if(self.delegate){
        [self.delegate liveViewTakeCover:self];
    }
}
@end
