//
//  LCMineHeaderCell.h
//  XCLive
//
//  Created by ztkztk on 14-4-21.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCMineHeaderCell : UITableViewCell
@property (nonatomic,strong)UIImageView *photoImageView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *IDLabel;
@property (nonatomic, strong) UIImageView *vipCapImageView;
-(void)showDataOfCell;

@end
