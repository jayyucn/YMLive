//
//  XCHeadDetailView.m
//  XCLive
//
//  Created by jacklong on 16/1/14.
//  Copyright © 2016年 www.yuanphone.com. All rights reserved.
//

#import "XCHeadDetailView.h"

#import "UIImage+Blur.h"
#import "UIImage+Category.h"
#import "MyRankUserView.h"

@implementation XCHeadDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = ColorBackGround;
     
//        _blurImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth,self.frame.size.height)];
//        
//        [self addSubview:_blurImageView];
//        _blurImageView.userInteractionEnabled=YES;
//        _blurImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
        
        UIImage * normalImg = [UIImage imageNamed:@"navbar_btn"];
        
        _backImg = [[UIImageView alloc] initWithImage:normalImg];
        _backImg.frame = CGRectMake(10, 5, normalImg.size.width, normalImg.size.height);
        [self addSubview:_backImg];
        self.userInteractionEnabled = YES;
        _backImg.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
        
        UIImage * msgImg  =  [UIImage imageNamed:@"image/liveroom/live_sixin_icon"];
        
        _msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_msgBtn setImage:msgImg forState:UIControlStateNormal];
        _msgBtn.frame = CGRectMake(ScreenWidth - 50, 13, msgImg.size.width, msgImg.size.height);
        [self addSubview:_msgBtn];
        self.userInteractionEnabled = YES;
         _msgBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
        
        _badgeView = [ESBadgeView badgeViewWithText:@"0"];
        _badgeView.size = CGSizeMake(20, 20);
        _badgeView.top = 0;
        _badgeView.font = [UIFont systemFontOfSize:8];
        _badgeView.left = _msgBtn.right - _badgeView.width/2;
        [self addSubview:_badgeView];
        _badgeView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
        if ([IMBridge bridge].countOfTotalUnreadMessages > 0) {
            _badgeView.hidden = NO;
            if ([IMBridge bridge].countOfTotalUnreadMessages >= 100) {
                _badgeView.text = @"99+";
            } else {
                _badgeView.text = [NSString stringWithFormat:@"%d",[IMBridge bridge].countOfTotalUnreadMessages];
            }
        } else {
            _badgeView.hidden = YES;
        }
        
        // 检索
        UIImage *searchImage = [UIImage imageNamed:@"image/liveroom/search_"];
        UIButton *searchBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        [searchBtn setImage:searchImage forState:UIControlStateNormal];
        [searchBtn setFrame:CGRectMake(20, 11, searchImage.size.width, searchImage.size.height)];
        [searchBtn addTarget:self action:@selector(showSearchAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:searchBtn];
        searchBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
        
        
        UIImage *editImg = [UIImage imageNamed:@"image/liveroom/home_edit"];
        _editUserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editUserBtn.frame = CGRectMake(20,  12,  15,  15);
        [_editUserBtn setImage:editImg forState:UIControlStateNormal];
        [self addSubview:_editUserBtn];
        _editUserBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
        
        UIImage * headBgFrame = [UIImage imageNamed:@"image/liveroom/me_head_frame"];
        _avatarImg = [[CircleImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/6-20, headBgFrame.size.width, headBgFrame.size.height)];
        _avatarImg.isNoShowBorder = YES;
        _avatarImg.image = headBgFrame;
        [self addSubview:_avatarImg];
        _avatarImg.centerX = frame.size.width/2;
        _avatarImg.userInteractionEnabled=YES;
        _avatarImg.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
        
        _avatar = [[CircleImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
        [self addSubview:_avatar];
        _avatar.isNoShowBorder = YES;
        _avatar.centerX = frame.size.width / 2;
        _avatar.centerY = _avatarImg.top + headBgFrame.size.height/2;
        _avatar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
        
        UIImage * flagImg  =  [UIImage imageNamed:@"msg_normal"];
        _levelFlagImg = [[UIImageView alloc] initWithFrame:CGRectMake(_avatarImg.right-flagImg.size.width+3, _avatarImg.bottom-flagImg.size.height-5, flagImg.size.width, flagImg.size.height)];
        _levelFlagImg.image = flagImg;
        [self addSubview:_levelFlagImg];
        _levelFlagImg.userInteractionEnabled=YES;
        _levelFlagImg.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
        _levelFlagImg.hidden = YES;
        
        _nickname = [[UILabel alloc] initWithFrame:CGRectMake(0,0,20,20)];
        _nickname.textAlignment = NSTextAlignmentCenter;
        _nickname.textColor=[UIColor whiteColor];
        _nickname.shadowColor = [UIColor darkGrayColor];
        _nickname.shadowOffset = CGSizeMake(0, -.5);
        [_nickname setFont:[UIFont boldSystemFontOfSize:14.f]];
        _nickname.backgroundColor =[UIColor clearColor];
        [self addSubview:_nickname];
        _nickname.top= _avatarImg.bottom + 10;
        _nickname.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
        
        
        _sexImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _sexImage.top = _nickname.top;
        [self addSubview:_sexImage];
        _sexImage.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
        
        _userLevelImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _userLevelImg.bottom = _nickname.bottom;
        
        [self addSubview:_userLevelImg];
        _userLevelImg.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
        _userLevelImg.hidden = YES;
        
        _userGradeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _userGradeLabel.bottom = _nickname.bottom;
        _userGradeLabel.textColor = [UIColor whiteColor]; 
        _userGradeLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_userGradeLabel];
        _userGradeLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
        _userGradeLabel.hidden = YES;
        
     
        _IDLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,20)];
        _IDLabel.textAlignment = NSTextAlignmentCenter;
        _IDLabel.textColor=[UIColor whiteColor];
        _IDLabel.shadowColor = [UIColor darkGrayColor];
        _IDLabel.shadowOffset = CGSizeMake(0, -.5);
        [_IDLabel setFont:[UIFont systemFontOfSize:13]];
        _IDLabel.backgroundColor =[UIColor clearColor];
        _IDLabel.centerX = frame.size.width / 2;
        _IDLabel.top=_nickname.bottom+5;
        [self addSubview:_IDLabel];
        _IDLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
        
        _tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, _IDLabel.bottom+5, SCREEN_WIDTH - 40, 20.f)];
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.textColor = [UIColor yellowColor];
        [_tagLabel setFont:[UIFont systemFontOfSize:13.f]];
        [self addSubview:_tagLabel];
        _tagLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
        _tagLabel.hidden = YES;
        
        _signLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 40,20)];
        _signLabel.textAlignment = NSTextAlignmentCenter;
        _signLabel.textColor=[UIColor whiteColor];
        _signLabel.shadowColor = [UIColor darkGrayColor];
        _signLabel.shadowOffset = CGSizeMake(0, -.5);
        _signLabel.font = [UIFont systemFontOfSize:12];
        _signLabel.backgroundColor =[UIColor clearColor];
        [self addSubview:_signLabel];
        _signLabel.top=_tagLabel.bottom+5;
        _signLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
        _signLabel.hidden = NO;
        
//        _honourImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, _accountLabel.bottom+5, sexImg.size.width, sexImg.size.height)];
//        [self addSubview:_honourImg];
//        _honourImg.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
//        _honourImg.hidden = YES;
//
        UIImage *sendDiamondBackImage = [UIImage imageNamed:@"image/liveroom/me_sendBg_"];
        _sendDiamondBgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, _IDLabel.bottom, SCREEN_WIDTH,sendDiamondBackImage.size.height)];
        _sendDiamondBgImg.image = sendDiamondBackImage;
        [self addSubview:_sendDiamondBgImg];
        _sendDiamondBgImg.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
        
        
        _sendDiamondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,_sendDiamondBgImg.width,_sendDiamondBgImg.height)];
        _sendDiamondLabel.textAlignment = NSTextAlignmentCenter;
        _sendDiamondLabel.textColor=[UIColor whiteColor];
        _sendDiamondLabel.font = [UIFont systemFontOfSize:11];;
        _sendDiamondLabel.backgroundColor =[UIColor clearColor];
        [_sendDiamondBgImg addSubview:_sendDiamondLabel];
        _sendDiamondLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
     
        
        _rankScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,self.frame.size.height - ViewWidth - 10, ScreenWidth * 3/5,ViewWidth)];
        _rankScrollView.userInteractionEnabled = YES;
        _rankScrollView.directionalLockEnabled = YES; //只能一个方向滑动
        _rankScrollView.pagingEnabled = NO; //是否翻页
        _rankScrollView.backgroundColor=[UIColor clearColor];
        _rankScrollView.showsVerticalScrollIndicator =NO; //垂直方向的滚动指示
        _rankScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
        _rankScrollView.showsHorizontalScrollIndicator = YES;//水平方向的滚动指示
        _rankScrollView.scrollEnabled = NO;
        _rankScrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
        [self addSubview:_rankScrollView];
        
        
        UIImage *promptIconImg = [UIImage imageNamed:@"image/liveroom/room_money_check"];
        NSString *promptStr = ESLocalizedString(@"有美币贡献榜 d");
        NSMutableAttributedString * promptAttributedString = [[NSMutableAttributedString alloc] initWithString:promptStr];
        
        NSTextAttachment *promptAttachment = [[NSTextAttachment alloc] init];
//        promptAttachment.image = [UIImage imageWithImage:promptIconImg scaleToSize:CGSizeMake(promptIconImg.size.width, promptIconImg.size.height)];
        promptAttachment.image = promptIconImg;
        promptAttachment.bounds = CGRectMake(0, -2, promptIconImg.size.width, promptIconImg.size.height);
        NSAttributedString *proAttributedString = [NSAttributedString attributedStringWithAttachment:promptAttachment];
        [promptAttributedString replaceCharactersInRange:NSMakeRange(promptAttributedString.string.length  - 1, 1) withAttributedString:proAttributedString];
        
        _rankDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [rankDetailBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
        [_rankDetailBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_rankDetailBtn.titleLabel setTextColor:[UIColor whiteColor]];
        _rankDetailBtn.titleLabel.shadowColor = [UIColor darkGrayColor];
        _rankDetailBtn.titleLabel.shadowOffset = CGSizeMake(0, -.5);

//        rankDetailBtn.titleLabel.textAlignment = NSTextAlign;
//        rankDetailBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
//        rankDetailBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        [_rankDetailBtn setAttributedTitle:promptAttributedString forState:UIControlStateNormal];
        _rankDetailBtn.frame =  CGRectMake(ScreenWidth-120, self.frame.size.height - ViewWidth/2-promptIconImg.size.height/2-5, 120, 30);
        [self addSubview:_rankDetailBtn];
        _rankDetailBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
    }
    return self;
}

-(void)showData:(NSDictionary *)dict
{
    NSLog(@"showUserData:%@",dict);
    
    NSMutableArray *topArray = nil;
    NSArray * array = dict[@"tops"];
    if (!array || array.count <= 0) {
        topArray = [NSMutableArray array];
        [topArray addObject:@{@"id":@"0",@"face":@"image/liveroom/me_qiudiamond"}];
        [topArray addObject:@{@"id":@"0",@"face":@"image/liveroom/me_qiudiamond"}];
        [topArray addObject:@{@"id":@"0",@"face":@"image/liveroom/me_qiudiamond"}];
    }
    else
    {
        topArray = [NSMutableArray arrayWithArray:array];
        if (array.count == 1) {
            [topArray addObject:@{@"id":@"0",@"face":@"image/liveroom/me_qiudiamond"}];
            [topArray addObject:@{@"id":@"0",@"face":@"image/liveroom/me_qiudiamond"}];
        } else if (array.count == 2) {
            [topArray addObject:@{@"id":@"0",@"face":@"image/liveroom/me_qiudiamond"}];
        }
    }
    
    [self updateNickNameRect];
    
    [self showSendDiamond];
    
    [self refleshUserView:topArray];
    
    NSString *faceString=[NSString faceURLString:dict[@"face"]];
    ESWeakSelf;
    ESWeak(_avatar);
    ESWeak(_avatarImg);
    [_avatar sd_setImageWithURL:[NSURL URLWithString:faceString] placeholderImage:[UIImage imageNamed:@"image/globle/man"]
                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                          ESStrongSelf;
                          if (image) {
                              ESStrong(_avatar);
                              ESStrong(_avatarImg);
                              __avatar.image = image;
                              UIImage *cutImage = [image resizeImage:image withWidth:80 withHeight:80];
                              UIImage *tempImage = [cutImage boxblurImageWithBlur:1.f];
                              __avatarImg.image = tempImage;
                              _self.image = tempImage;
                              _self.clipsToBounds = YES;
                          }
                      }];
    
  
    
    
    if ([[LCMyUser mine].userID isEqualToString:ESStringValue(dict[@"uid"])])
    {
        _editUserBtn.hidden = NO;
        _msgBtn.hidden = NO;
        _backImg.hidden = YES;
    }
    else
    {
        _editUserBtn.hidden = YES;
        _msgBtn.hidden = YES;
        _backImg.hidden = NO;
    }
    
    if ([LCMyUser mine].goodID && [LCMyUser mine].goodID.length > 1) {
        _IDLabel.textColor = ColorPink;
        
        NSMutableAttributedString *mutableAttributedString = nil;
        NSString *goodIdInfoStr = [NSString stringWithFormat:@"d %@",[LCMyUser mine].goodID];
        mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:goodIdInfoStr];
        
        UIImage *goodIdImage = [UIImage imageNamed:@"image/liveroom/user_goodid"];
        
        NSTextAttachment *goodIdAttachment = [[NSTextAttachment alloc] init];
//        goodIdAttachment.image = [UIImage imageWithImage:goodIdImage scaleToSize:goodIdImage.size];
        goodIdAttachment.image = goodIdImage;
        goodIdAttachment.bounds = CGRectMake(0, -2, goodIdImage.size.width, goodIdImage.size.height);
        NSAttributedString *goodIdAttributedString = [NSAttributedString attributedStringWithAttachment:goodIdAttachment];
        [mutableAttributedString replaceCharactersInRange:NSMakeRange(0, 1) withAttributedString:goodIdAttributedString];
        _IDLabel.attributedText = mutableAttributedString;
    } else {
        _IDLabel.textColor = [UIColor whiteColor];
        _IDLabel.text = [NSString stringWithFormat:@"ID:%@",dict[@"uid"]];
    }
    
    NSString *sign = nil;
    ESStringVal(&sign, dict[@"signature"]);
    
    NSString *tag = [LCMyUser mine].tagFlag;
    if (tag && tag.length > 0 && (sign && sign.length > 0))
    {
        NSMutableAttributedString *mutableAttributedString = nil;
        NSString *certInfoStr =  [NSString stringWithFormat:@"d 认证:%@",tag];
        mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:certInfoStr];
        
        UIImage *certImage = [UIImage imageNamed:@"image/liveroom/me_renzheng"];
        
        NSTextAttachment *certAttachment = [[NSTextAttachment alloc] init];
        certAttachment.image = [UIImage imageWithImage:certImage scaleToSize:CGSizeMake(certImage.size.width/2, certImage.size.height/2-2)];
        certAttachment.bounds = CGRectMake(0, -2, certImage.size.width/2, certImage.size.height/2-2);
        NSAttributedString *certAttributedString = [NSAttributedString attributedStringWithAttachment:certAttachment];
        [mutableAttributedString replaceCharactersInRange:NSMakeRange(0, 1) withAttributedString:certAttributedString];
        _tagLabel.top = _IDLabel.bottom + 5;
        _tagLabel.attributedText = mutableAttributedString;
        _tagLabel.hidden = NO;
        
        _signLabel.text = sign;
        _signLabel.hidden = NO;
        _signLabel.top = _tagLabel.bottom + 5;
        _sendDiamondBgImg.top = _signLabel.bottom + 5;
    } else if (sign && sign.length > 0) {
        _signLabel.text = sign;
        _signLabel.top = _IDLabel.bottom +5;
        _sendDiamondBgImg.top = _signLabel.bottom + 5;
        
        _signLabel.hidden = NO;
        _tagLabel.hidden = YES;
    } else if (tag && tag.length > 0){
        NSMutableAttributedString *mutableAttributedString = nil;
        NSString *certInfoStr =  [NSString stringWithFormat:@"d 认证:%@",tag];
        mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:certInfoStr];
        
        UIImage *certImage = [UIImage imageNamed:@"image/liveroom/me_renzheng"];
        
        NSTextAttachment *certAttachment = [[NSTextAttachment alloc] init];
        certAttachment.image = [UIImage imageWithImage:certImage scaleToSize:CGSizeMake(certImage.size.width/2, certImage.size.height/2-2)];
        certAttachment.bounds = CGRectMake(0, -2, certImage.size.width/2, certImage.size.height/2-2);
        NSAttributedString *certAttributedString = [NSAttributedString attributedStringWithAttachment:certAttachment];
        [mutableAttributedString replaceCharactersInRange:NSMakeRange(0, 1) withAttributedString:certAttributedString];
        _tagLabel.top = _IDLabel.bottom + 5;
        _tagLabel.attributedText = mutableAttributedString;
        _tagLabel.hidden = NO;
        _signLabel.hidden = YES;
        _sendDiamondBgImg.top = _tagLabel.bottom + 5;
    } else {
        _signLabel.hidden = YES;
        _tagLabel.hidden = YES;
        _sendDiamondBgImg.top = _IDLabel.bottom + 5;
    }
    return ;
}

- (void) showSearchAction
{
    if (self.showSearchBlock) {
        self.showSearchBlock();
    }
}

- (void) updateNickNameRect
{
    
    UIImage *sexImage;
    int sex = [LCMyUser mine].sex;
    
    if(sex==1)
    {
        sexImage=[UIImage imageNamed:@"global_male"];
    }
    else
    {
        sexImage=[UIImage imageNamed:@"global_female"];
    }
 
    int grade = [LCMyUser mine].userLevel;

    _nickname.top = _avatarImg.bottom + 10;
    _nickname.text = [LCMyUser mine].nickname;
    _nickname.width = [self getNicNameWidth];
    _nickname.height = 20;
    _sexImage.image = sexImage;
    _sexImage.top = _nickname.top + 1;
    _sexImage.width = sexImage.size.width;
    _sexImage.height = sexImage.size.height;
    
    if (grade > 0) {
        _userLevelImg.hidden = NO;
        _userGradeLabel.hidden = NO;
        
        UIImage *levelImage = [UIImage createUserGradeImage:grade withIsManager:[LCMyUser mine].showManager];
        
        CGFloat gradeWidth = 0;
        if (![LCMyUser mine].showManager) {
            UIEdgeInsets insets = UIEdgeInsetsMake(0, levelImage.size.width - 10, 0, 5);
            // 伸缩后重新赋值
            levelImage = [levelImage resizableImageWithCapInsets:insets];
            gradeWidth = [self getGradeSize:grade];
        } else {
            _userGradeLabel.hidden = YES;
        }
        
        _userLevelImg.width = levelImage.size.width+gradeWidth;
        _userLevelImg.height = levelImage.size.height;
        _userLevelImg.left = _sexImage.right + 5;
        _userLevelImg.image = levelImage;
        _userLevelImg.bottom = _nickname.bottom-3;
        
        _userGradeLabel.top = _nickname.top;
        _userGradeLabel.width = _userLevelImg.width;
        _userGradeLabel.height = _userLevelImg.height;
        _userGradeLabel.text = [NSString stringWithFormat:@"%d",grade];
        _nickname.centerX = SCREEN_WIDTH/2 - sexImage.size.width/2 - levelImage.size.width/2;
        _sexImage.left = _nickname.right + 5;
        _userLevelImg.left = _sexImage.right + 5;
        _userGradeLabel.left = _userLevelImg.left+levelImage.size.width*4/5;
        _editUserBtn.left = _userLevelImg.right + 6;
        _editUserBtn.centerY = _userLevelImg.centerY;
        
    } else {
        _userGradeLabel.hidden = YES;
        _userLevelImg.hidden = YES;
        _nickname.centerX = SCREEN_WIDTH/2 - sexImage.size.width/2;
        _sexImage.left = _nickname.right + 5;
        _editUserBtn.left = _sexImage.right + 6;
        _editUserBtn.centerY = _sexImage.centerY;
    }
    
    return;
}

- (CGFloat) getNicNameWidth
{
    NSMutableString *tempStr = [NSMutableString stringWithFormat:@"%@",[LCMyUser mine].nickname];
    CGSize size = [tempStr boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]} context:nil].size;
    
    return size.width;
}

#pragma mark - 获取等级宽度
- (CGFloat) getGradeSize:(int)grade
{
    NSMutableString *tempStr = [NSMutableString stringWithFormat:@"%d",grade];
    CGSize size = [tempStr boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size;
    
    return size.width;
}


-(void)refleshUserView:(NSArray *)userArray
{
    [self.rankScrollView removeAllSubviews];
    
    NSUInteger arrayNum=[userArray count];
    
    CGSize newSize = CGSizeMake((ViewWidth+ViewPadding)*arrayNum, ViewWidth);
    [self.rankScrollView setContentSize:newSize];
    
    
    for(int i=0;i<arrayNum;i++)
    {
        CGRect itemRect=CGRectMake(ViewPadding+i*(ViewWidth+ViewPadding),0,ViewWidth,ViewWidth);
        MyRankUserView *userView=[[MyRankUserView alloc] initWithFrame:itemRect];
        ESWeakSelf;
        userView.showRankDetail = ^() {
            ESStrongSelf;
        };
        userView.userInfoDict = userArray[i];
        [self.rankScrollView addSubview:userView];
    }
    
}

- (void)updateUserInfo
{
    
}

#pragma mark - 修改用户头像
- (void)modifyFace
{
    NSString *faceString= [LCMyUser mine].faceURL;
    ESWeakSelf;
    ESWeak(_avatar);
    ESWeak(_avatarImg);
    [_avatar sd_setImageWithURL:[NSURL URLWithString:faceString] placeholderImage:[UIImage imageNamed:@"image/globle/man"]
                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                          ESStrongSelf;
                          ESStrong(_avatar);
                          ESStrong(_avatarImg);
                          __avatar.image = image;
                          UIImage *cutImage = [image resizeImage:image withWidth:80 withHeight:80];
                          UIImage *tempImage = [cutImage boxblurImageWithBlur:1.f];
                          __avatarImg.image = tempImage;
                          _self.image = tempImage;
                          _self.clipsToBounds = YES;
//                          [_self sizeToFit];
                      }];
    

}

#pragma mark 修改用户昵称
- (void)modifyNickname
{
    if ([LCMyUser mine].nickname) {
        [self updateNickNameRect];
    } 
}

#pragma mark 修改用户签名
- (void)modifySign
{
    if ([LCMyUser mine].signature && [[LCMyUser mine].signature length] > 0) {
        _signLabel.text = [LCMyUser mine].signature;
        
        _signLabel.hidden = NO;
        _sendDiamondBgImg.top = _signLabel.bottom + 5;
    }
}

- (void) showSendDiamond
{
    NSString *sendDiamondText = [NSString stringWithFormat:@"%@ %d d", ESLocalizedString(@"送出"), [LCMyUser mine].send_diamond];
    NSMutableAttributedString * mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:sendDiamondText];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    UIImage *image = [UIImage imageNamed:@"image/liveroom/me_myaccount_reddiamond"];
    
    textAttachment.image = image;
//    textAttachment.image = [UIImage imageWithImage:image scaleToSize:CGSizeMake(image.size.width, image.size.height)];
    textAttachment.bounds = CGRectMake(0, -3, image.size.width, image.size.height);
    
    NSAttributedString *iconAttributedString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [mutableAttributedString replaceCharactersInRange:NSMakeRange(sendDiamondText.length-1, 1) withAttributedString:iconAttributedString];
    
    self.sendDiamondLabel.attributedText = mutableAttributedString;
}

@end

