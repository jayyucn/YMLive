//  已关注直播视图单元
//  MyAttentCell.h
//  qianchuo
//
//  Created by jacklong on 16/4/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAttentHallCell : UITableViewCell

@property(nonatomic, strong) UIView         *headInfoView;
@property(nonatomic, strong) UIImageView    *faceImgView;
@property(nonatomic, strong) UIImageView    *gradeFlagImgView;
@property(nonatomic, strong) UILabel        *nicknameLabel;
@property(nonatomic, strong) UILabel        *locationLabel;
@property(nonatomic, strong) UILabel        *onlineUserCountLabel;

@property(nonatomic, strong) UIImageView    *liveUserFaceImgView;
@property(nonatomic, strong) UIImageView    *liveStateImgView;

@property(nonatomic, strong) UILabel        *memoLabel;

@property(nonatomic, strong) UIView         *seperateView;

@property(nonatomic, strong) NSDictionary   *userInfoDict;

@end
