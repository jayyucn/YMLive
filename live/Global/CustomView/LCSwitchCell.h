//
//  LCSwitchCell.h
//  XCLive
//
//  Created by ztkztk on 14-4-26.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LCSwitchCellBlock)(BOOL on);
@interface LCSwitchCell : UITableViewCell
@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UISwitch *switchView;
@property (nonatomic,strong)LCSwitchCellBlock switchCellBlock;

@end
