//
//  MyAttentCell.h
//  qianchuo
//
//  Created by jacklong on 16/3/31.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//
@interface MyAttentAndFansCell : UITableViewCell

@property (nonatomic, strong) UIImageView     *userHeadImg;
@property (nonatomic, strong) UIImageView     *gradeFlagImgView;

@property (nonatomic, strong) UILabel         *nickNameLabel;
@property (nonatomic, strong) UIImageView     *sexImage;
@property (nonatomic, strong) UILabel         *userGradeLabel;
@property (nonatomic, strong) UIImageView     *userLevelImg;

@property (nonatomic, strong) UILabel         *userSignLabel;
@property (nonatomic, strong) UIView          *lineView;

@property (nonatomic, strong) UIButton        *attentStateBtn;

@property (nonatomic, strong) NSDictionary    *userInfoDict;

@end
