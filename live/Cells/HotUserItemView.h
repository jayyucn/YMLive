//  热门直播视图
//  HotUserItemView.h
//  qianchuo
//
//  Created by jacklong on 16/4/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define cNum 2 // 每行分布列数量

#define cIntervalPixel 2.0

#define cCell_Items_Width  (ScreenWidth-cIntervalPixel*(cNum+1))/cNum
#define cCell_Items_Height (ScreenWidth-cIntervalPixel*(cNum+1))/cNum

typedef void(^OnItemBlock)(NSDictionary *userInfoDict);

@interface HotUserItemView : UIView

@property(nonatomic, strong) UIView         *headInfoView;
@property(nonatomic, strong) UIImageView    *gradeFlagImgView;
@property(nonatomic, strong) UILabel        *nicknameLabel;
@property(nonatomic, strong) UILabel        *locationLabel;

@property(nonatomic, strong) UILabel        *onlineUserCountLabel;

@property(nonatomic, strong) UIImageView    *liveUserFaceImgView;

@property(nonatomic, strong) UIImageView    *liveStateImgView;

@property(nonatomic, strong) UILabel        *memoLabel;

@property(nonatomic, strong) NSDictionary   *userInfoDict;

@property(nonatomic, copy) OnItemBlock itemBlock;

@end
