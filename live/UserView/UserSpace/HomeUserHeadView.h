//
//  HomeUserHeadView.h
//  qianchuo
//
//  Created by jacklong on 16/8/4.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "CircleImageView.h"
#import "AttentFansSegView.h"

typedef  void(^BackActionBlock)();

@interface HomeUserHeadView : UIImageView

@property (nonatomic,weak) id<AttentFansSegViewDelegate> segDelegate;

@property (nonatomic,strong) UIButton           *backActionBtn;

@property (nonatomic,strong) CircleImageView    *avatarImg;
//@property (nonatomic,strong) CircleImageView    *avatar;
@property (nonatomic,strong) UIImageView        *levelFlagImg;

@property (nonatomic,strong) UILabel            *nickname;
@property (nonatomic,strong) UIImageView        *sexImage;
@property (nonatomic,strong) UILabel            *userGradeLabel;
@property (nonatomic,strong) UIImageView        *userLevelImg; 

//@property (nonatomic,strong) UILabel            *signLabel;
//@property (nonatomic,strong) UILabel            *tagLabel;
@property (nonatomic,strong) AttentFansSegView  *attentFansSegView;
@property (nonatomic,strong) UILabel            *IDLabel;

@property (nonatomic,strong) UIImageView        *sendDiamondBgImg;
@property (nonatomic,strong) UILabel            *sendDiamondLabel;

//@property (nonatomic,strong) UIScrollView       *rankScrollView;
//@property (nonatomic,strong) UIButton           *rankDetailBtn;

@property (nonatomic,strong) NSDictionary       *userInfoDict;

@property (nonatomic,copy)BackActionBlock    backActionBlock;
@end
