//
//  LCCustomCell.h
//  XCLive
//
//  Created by ztkztk on 14-5-21.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCInsetsLabel.h"

@interface LCCustomCell : UITableViewCell

@property (nonatomic,strong)NSDictionary *infoDic;
@property (nonatomic,strong)UIImageView *photoView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)LCInsetsLabel *oldLabel;
@property (nonatomic,strong)UILabel *otherInfo;
@property (nonatomic,strong)UILabel *signLabel;
@property (nonatomic, strong)UIImageView *videoView;
@property (nonatomic, strong) UIImageView *vipCapImageView;
@property (nonatomic, strong) UILabel *creditLabel;
@end
