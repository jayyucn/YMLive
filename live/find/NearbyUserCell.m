//
//  NearbyUserCell.m
//  TaoHuaLive
//
//  Created by garsonge on 17/3/27.
//  Copyright © 2017年 上海七夕. All rights reserved.
//

#import "NearbyUserCell.h"

@implementation NearbyUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 设置cell的属性
- (void)setupCell
{
    _loginLabel.textColor = ColorDark;
    _disLabel.textColor = ColorDark;
    
    _nameLabel.textColor = ColorPink;
}

@end
