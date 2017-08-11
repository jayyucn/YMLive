//
//  PlayBackManager.h
//  qianchuo
//
//  Created by jacklong on 16/8/8.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//
#import "SWTableViewCell.h"
#import "PlayBackCell.h"

#define CELL_HEIGHT  60
#define CELL_ITIFIER @"playback_cell"
 

@interface PlayBackManager : SWTableViewCell
 
@property (nonatomic,strong)PlayBackCell *myCell;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
             height:(CGFloat)height
 leftUtilityButtons:(NSArray *)leftUtilityButtons
rightUtilityButtons:(NSArray *)rightUtilityButtons;

@end
