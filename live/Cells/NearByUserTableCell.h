//
//  NearByUserTableCell.h
//  qianchuo
//
//  Created by jacklong on 16/8/26.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearByUserTableCell : UITableViewCell

@property (nonatomic, strong) UIImageView     *userHeadImg;
@property (nonatomic, strong) UIImageView     *gradeFlagImgView;

@property (nonatomic, strong) UILabel         *nickNameLabel;
@property (nonatomic, strong) UIImageView     *sexImage;
@property (nonatomic, strong) UILabel         *userGradeLabel;
@property (nonatomic, strong) UIImageView     *userLevelImg;

@property (nonatomic, strong) UILabel         *userSignLabel;
@property (nonatomic, strong) UIView          *lineView;

@property (nonatomic, strong) UILabel         *loginTimeLabel;
@property (nonatomic, strong) UILabel         *distanceLabel;
//@property (nonatomic, strong) UIButton        *attentStateBtn;

@property (nonatomic, strong) NSDictionary    *userInfoDict;

@end
