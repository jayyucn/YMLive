//
//  MyInfoTableViewCell.m
//  live
//
//  Created by hysd on 15/8/28.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import "MyInfoTableViewCell.h"
#import "Macro.h"
@implementation MyInfoTableViewCell

- (id)init{
    self = [[[NSBundle mainBundle] loadNibNamed:@"MyInfoTableViewCell" owner:self options:nil] lastObject];
    if(self){
        //选中背景不发生改变
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.valueLabel.textColor = RGB16(COLOR_FONT_GRAY);
    }
    return self;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
