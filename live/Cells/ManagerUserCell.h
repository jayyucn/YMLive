//
//  ManagerUserCell.h
//  qianchuo
//
//  Created by jacklong on 16/4/20.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//
#import "SWTableViewCell.h"
#import "MyAttentAndFansCell.h"

#define CELL_HEIGHT  60
#define CELL_ITIFIER @"manager_cell"

typedef void(^TapManagerCellBlock)(NSDictionary *dic);

@interface ManagerUserCell : SWTableViewCell

@property (nonatomic,strong)MyAttentAndFansCell *myCell;
@property (nonatomic,copy)TapManagerCellBlock tapCellBlock;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
             height:(CGFloat)height
 leftUtilityButtons:(NSArray *)leftUtilityButtons
rightUtilityButtons:(NSArray *)rightUtilityButtons;

@end
