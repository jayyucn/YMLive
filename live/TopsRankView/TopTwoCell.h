//
//  TopTwoCell.h
//  qianchuo
//
//  Created by jacklong on 16/3/30.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "UserRankModel.h"

@interface TopTwoCell : UITableViewCell

@property (nonatomic, strong)UIView     *topLabelView;
@property (nonatomic, strong)UILabel    *topLabel;

@property (nonatomic, strong)UIImageView    *topImg;
@property (nonatomic, strong)UIImageView    *faceImg;
@property (nonatomic, strong)UIImageView    *gradeFlagImgView;

@property (nonatomic, strong)UILabel        *numRankLabel;
@property (nonatomic, strong)UILabel        *nickNameLabel;
@property (nonatomic, strong) UIImageView     *sexImage;
@property (nonatomic, strong) UILabel         *userGradeLabel;
@property (nonatomic, strong) UIImageView     *userLevelImg;

@property (nonatomic, strong)UILabel        *recvDiamondLabel;
@property (nonatomic, strong)UIView         *lineView;


@property (nonatomic, strong) UserRankModel     *userModel;

@end
