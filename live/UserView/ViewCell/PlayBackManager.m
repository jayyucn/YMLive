//
//  PlayBackManager.m
//  qianchuo
//
//  Created by jacklong on 16/8/8.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "PlayBackManager.h"

@implementation PlayBackManager

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
             height:(CGFloat)height
 leftUtilityButtons:(NSArray *)leftUtilityButtons
rightUtilityButtons:(NSArray *)rightUtilityButtons {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier height:height leftUtilityButtons:leftUtilityButtons rightUtilityButtons:rightUtilityButtons];
    if (self)
    {
        _myCell =[[PlayBackCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:CELL_ITIFIER];
        // 取消选择模式
        _myCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _myCell.height=CELL_HEIGHT;
        
        [self.contentView addSubview:_myCell];
    }
    
    return self;
}


@end
