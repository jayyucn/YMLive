//
//  OTOItemView.h
//  qianchuo
//
//  Created by jacklong on 16/11/1.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OTOItemType) {
    BigType = 0,
    SmallType,
};

@interface OTOItemView : UIView


@property (nonatomic,strong)NSDictionary *otoItemDic;//主播数据

@property (nonatomic,strong)UIImageView *portraitView;//头像
@property (nonatomic,strong)UILabel     *setDiamondNumLabel;// 设置钻石数目
@property (nonatomic,strong)UIImageView *otoFlagView;   // 1v1标记
//@property (nonatomic,strong)UIView      *userInfoShadowView;//阴影
@property (nonatomic,strong)UILabel     *userNameLabel;//用户昵称
@property (nonatomic,strong)UILabel     *userSignLabel;// 用户昵称
@property (nonatomic,strong)UIImageView *maskView;// 遮罩


+(id)initWithType:(OTOItemType)itemType withFrame:(CGRect)frame;

-(void)initView;
-(void)upDateOfView;


@end
