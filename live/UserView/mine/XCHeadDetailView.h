//
//  XCHeadDetailView.h
//  XCLive
//
//  Created by jacklong on 16/1/14.
//  Copyright © 2016年 www.yuanphone.com. All rights reserved.
//

#import "CircleImageView.h"


typedef  void(^XLBackActionBlock)();
typedef  void(^XLShowMsgBlock)();
typedef  void(^XLEditUserInfoBlock)();
typedef void (^ShowSearchBlock)();

@interface XCHeadDetailView : UIImageView<UIScrollViewDelegate>

@property (nonatomic,strong) UIImageView        *backImg;

@property (nonatomic,strong) ESBadgeView        *badgeView;
@property (nonatomic,strong) UIButton           *msgBtn;


//@property (nonatomic,strong) UIImageView        *blurImageView;

@property (nonatomic,strong) CircleImageView    *avatarImg;
@property (nonatomic,strong) CircleImageView    *avatar;
@property (nonatomic,strong) UIImageView        *levelFlagImg;

@property (nonatomic,strong) UILabel            *nickname;
@property (nonatomic,strong) UIImageView        *sexImage;
@property (nonatomic,strong) UILabel            *userGradeLabel;
@property (nonatomic,strong) UIImageView        *userLevelImg;
@property (nonatomic,strong) UIButton           *editUserBtn;

@property (nonatomic,strong) UILabel            *signLabel;
@property (nonatomic,strong) UILabel            *tagLabel;
//@property (nonatomic,strong) UILabel            *accountLabel;
@property (nonatomic,strong) UILabel            *IDLabel;

//@property (nonatomic,strong) UIImageView        *honourImg;

@property (nonatomic,strong) UIImageView        *sendDiamondBgImg;
@property (nonatomic,strong) UILabel            *sendDiamondLabel;

@property (nonatomic,strong) UIScrollView       *rankScrollView;
@property (nonatomic,strong) UIButton           *rankDetailBtn;
//@property (nonatomic,strong) UILabel            *promptLabel;
//@property (nonatomic,strong) UIImageView        *promptIconImg;

@property (nonatomic,copy)XLBackActionBlock    backActionBlock;
@property (nonatomic , copy) ShowSearchBlock showSearchBlock;


- (void)showData:(NSDictionary *)dict;

- (void)modifyFace;

- (void)modifyNickname;

- (void)modifySign;

- (void) showSendDiamond;

@end
