//
//  EditTableViewCell.m
//  live
//
//  Created by hysd on 15/8/28.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import "EditTableViewCell.h"
#import "Macro.h"
@implementation EditTableViewCell

- (void)awakeFromNib
{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = RGB16(COLOR_BG_WHITE);
    self.editTextField.borderStyle = UITextBorderStyleNone;
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
    self.editTextField.inputAccessoryView = toolbar;
    
}
- (void)completeInput{
    [self.editTextField resignFirstResponder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
