//
//  MyRankUserView.h
//  qianchuo
//
//  Created by jacklong on 16/3/30.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#define ViewWidth  40
#define ViewPadding 8

typedef void(^ShowRankDetail)();

@interface MyRankUserView : UIView

@property (nonatomic,strong)NSDictionary *userInfoDict;// 用户数据

@property (nonatomic, strong)UIImageView     *portraitView;// 头像
@property (nonatomic, strong)UIImageView     *gradeFlagImgView;

@property (nonatomic,strong)ShowRankDetail showRankDetail;

@end
