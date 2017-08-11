//
//  GenderTableViewCell.m
//  live
//
//  Created by hysd on 15/8/28.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import "GenderTableViewCell.h"
#import "Macro.h"
@implementation GenderTableViewCell

- (id)init{
    self = [[[NSBundle mainBundle] loadNibNamed:@"GenderTableViewCell" owner:self options:nil] lastObject];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = RGB16(COLOR_BG_WHITE);
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
