//
//  MyLogoTableViewCell.m
//  live
//
//  Created by hysd on 15/8/28.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import "MyLogoTableViewCell.h"

@implementation MyLogoTableViewCell

- (id)init{
    self = [[[NSBundle mainBundle] loadNibNamed:@"MyLogoTableViewCell" owner:self options:nil] lastObject];
    if(self){
        self.isModLogo = NO;
        //选中背景不发生改变
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.valueImageView.layer.cornerRadius = 5;
        self.valueImageView.clipsToBounds = YES;
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
