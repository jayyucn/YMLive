//
//  ManagerUserCell.m
//  qianchuo
//
//  Created by jacklong on 16/4/20.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ManagerUserCell.h"

@implementation ManagerUserCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
             height:(CGFloat)height
 leftUtilityButtons:(NSArray *)leftUtilityButtons
rightUtilityButtons:(NSArray *)rightUtilityButtons {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier height:height leftUtilityButtons:leftUtilityButtons rightUtilityButtons:rightUtilityButtons];
    if (self)
    {
        _myCell =[[MyAttentAndFansCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:CELL_ITIFIER];
        // 取消选择模式
        _myCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _myCell.attentStateBtn.hidden = YES;
        
        _myCell.height=CELL_HEIGHT;
        
        [self.contentView addSubview:_myCell];
    }
    
    return self;
}

@end
