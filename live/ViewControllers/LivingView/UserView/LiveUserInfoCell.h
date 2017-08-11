//
//  LiveUserInfoCell.h
//  qianchuo
//
//  Created by jacklong on 16/3/8.
//  Copyright © 2016年 kenneth. All rights reserved.
//

typedef NS_OPTIONS(NSUInteger, CELL_TYPE) {
    CELL_ATTENT_TYPE                     = 0,
    CELL_FANS_TYPE                       = 1 << 0,
    CELL_RECEIVER_TYPE                   = 1 << 1,
};

@interface LiveUserInfoCell : UITableViewCell

@property (nonatomic, strong) UIImageView    *userHeadImg;
@property (nonatomic, strong) UIImageView    *gradeFlagImgView;
@property (nonatomic, strong) UILabel        *nickNameLabel;
@property (nonatomic,strong) UIImageView     *sexImage;
@property (nonatomic,strong) UILabel         *userGradeLabel;
@property (nonatomic,strong) UIImageView     *userLevelImg;

@property (nonatomic, strong) UILabel        *userSignLabel;
@property (nonatomic, strong) UIView         *lineView;

@property (nonatomic, strong) UIButton       *attentStateBtn;

@property (nonatomic, assign) CELL_TYPE      cellType;

@property (nonatomic, strong) NSDictionary   *userInfoDict;
@end
