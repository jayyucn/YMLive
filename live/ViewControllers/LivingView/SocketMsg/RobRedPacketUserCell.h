//
//  RobRedPacketUserCell.h
//  qianchuo
//
//  Created by jacklong on 16/3/26.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLabel.h"

@interface RobRedPacketUserCell : UITableViewCell

@property (nonatomic, strong) UIImageView    *userHeadImg;
@property (nonatomic, strong) UIImageView    *gradeFlagImgView;
@property (nonatomic, strong) MyLabel        *nickNameLabel;
@property (nonatomic,strong) UIImageView     *sexImage;
@property (nonatomic,strong) UILabel         *userGradeLabel;
@property (nonatomic,strong) UIImageView     *userLevelImg;

@property (nonatomic, strong) UIView         *robDiamondView;
@property (nonatomic, strong) UILabel        *robDiamondLabel;
@property (nonatomic, strong) UIImageView    *luckKingImg;
@property (nonatomic, strong) UIView         *lineView;

@property (nonatomic, strong) NSDictionary   *userInfoDict;

@end
