//
//  MyAppTableViewCell.m
//  live
//
//  Created by hysd on 15/8/28.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import "MyAppTableViewCell.h"
#import "Macro.h"
@implementation MyAppTableViewCell

- (void)awakeFromNib
{
    
    //选中背景不发生改变
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = RGB16(0xf3f3f3);
    self.logoutButton.backgroundColor = [UIColor clearColor];
    self.logoutButton.layer.cornerRadius = self.logoutButton.frame.size.height/2;
    [self.logoutButton setTitleColor:RGB16(COLOR_FONT_RED) forState:UIControlStateNormal];
    self.logoutButton.layer.borderWidth = 1;
    self.logoutButton.layer.borderColor = RGB16(COLOR_BG_RED).CGColor;
    
    self.aboutView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aboutTap:)];
    [self.aboutView addGestureRecognizer:tap];
    self.aboutView.userInteractionEnabled = YES;
    
}

- (void)aboutTap:(UITapGestureRecognizer*)recognizer{
    if(self.delegate){
        [self.delegate about];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)logoutAction:(id)sender {
    if(self.delegate){
        [self.delegate logout];
    }
}

//去掉section上下边框
-(void)addSubview:(UIView *)view
{
    NSString* className = NSStringFromClass([view class]);
    if (![className isEqualToString:@"UITableViewCellContentView"]){
        return;
    }
    [super addSubview:view];
}
@end
