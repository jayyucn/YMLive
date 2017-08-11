//
//  HomeUserHeadView.m
//  qianchuo
//
//  Created by jacklong on 16/8/4.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "HomeUserHeadView.h"

#import "UIImage+Blur.h"
#import "UIImage+Category.h"
#import "MyRankUserView.h"

@implementation HomeUserHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = ColorBackGround;
        
        UIImage * normalImg = [UIImage imageNamed:@"image/liveroom/me_back_ui"];
        
        _backActionBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        _backActionBtn.frame = CGRectMake(0, 5, 50, 50);
        _backActionBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:_backActionBtn];
        self.userInteractionEnabled = YES;
        _backActionBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
        _backActionBtn.hidden = NO;
        
        UIImageView *backImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, normalImg.size.width, normalImg.size.height)];
        backImgView.image = normalImg;
        [self addSubview:backImgView];
        self.userInteractionEnabled = YES;
        backImgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
        backImgView.hidden = NO;
        
        UIImage * headBgFrame = [UIImage imageNamed:@"me_head_frame"];
        _avatarImg = [[CircleImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/5-20, 75, 75)];
        _avatarImg.isNoShowBorder = NO;
        _avatarImg.image = headBgFrame;
        [self addSubview:_avatarImg];
        _avatarImg.centerX = frame.size.width/2;
        _avatarImg.userInteractionEnabled=YES;
        _avatarImg.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
        
//        _avatar = [[CircleImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
//        [self addSubview:_avatar];
//        _avatar.isNoShowBorder = YES;
//        _avatar.centerX = frame.size.width / 2;
//        _avatar.centerY = _avatarImg.top + headBgFrame.size.height/2;
//        _avatar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
        
        UIImage * flagImg  =  [UIImage imageNamed:@"image/liveroom/yonghu/grade_flag/grade_flag_1"];
        _levelFlagImg = [[UIImageView alloc] initWithFrame:CGRectMake(_avatarImg.right-flagImg.size.width+3, _avatarImg.bottom-flagImg.size.height-5, flagImg.size.width, flagImg.size.height)];
        _levelFlagImg.image = flagImg;
        [self addSubview:_levelFlagImg];
        _levelFlagImg.userInteractionEnabled=YES;
        _levelFlagImg.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
        _levelFlagImg.hidden = NO;
        
        
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
        
        _attentFansSegView = [[AttentFansSegView alloc] initWithFrame:CGRectMake(0, 0, 170, 30)];
        _attentFansSegView.isMySpaceUser = true;
        
        _attentFansSegView.items = [NSArray arrayWithObjects:
                              [NSString stringWithFormat:@"%@ %d", ESLocalizedString(@"关注"), 0],
                              [NSString stringWithFormat:@"%@ %d",ESLocalizedString(@"粉丝"), 0],  nil];
        _attentFansSegView.delegate = _segDelegate;
        _attentFansSegView.centerX = frame.size.width / 2;
        _attentFansSegView.top=_nickname.bottom+5;
        [self addSubview:_attentFansSegView];
        _attentFansSegView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
        
        _IDLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,20)];
        _IDLabel.textAlignment = NSTextAlignmentCenter;
        _IDLabel.textColor=[UIColor whiteColor];
        _IDLabel.shadowColor = [UIColor darkGrayColor];
        _IDLabel.shadowOffset = CGSizeMake(0, -.5);
        [_IDLabel setFont:[UIFont systemFontOfSize:13]];
        _IDLabel.backgroundColor =[UIColor clearColor];
        _IDLabel.centerX = frame.size.width / 2;
        _IDLabel.top=_attentFansSegView.bottom+5;
        [self addSubview:_IDLabel];
        _IDLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
        
//        _tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, _IDLabel.bottom+5, SCREEN_WIDTH - 40, 20.f)];
//        _tagLabel.textAlignment = NSTextAlignmentCenter;
//        _tagLabel.textColor = [UIColor yellowColor];
//        [_tagLabel setFont:[UIFont systemFontOfSize:13.f]];
//        [self addSubview:_tagLabel];
//        _tagLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
//        _tagLabel.hidden = YES;
//        
//        _signLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 40,20)];
//        _signLabel.textAlignment = NSTextAlignmentCenter;
//        _signLabel.textColor=[UIColor whiteColor];
//        _signLabel.shadowColor = [UIColor darkGrayColor];
//        _signLabel.shadowOffset = CGSizeMake(0, -.5);
//        _signLabel.font = [UIFont systemFontOfSize:12];
//        _signLabel.backgroundColor =[UIColor clearColor];
//        [self addSubview:_signLabel];
//        _signLabel.top=_tagLabel.bottom+5;
//        _signLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
//        _signLabel.hidden = NO;
        
        //        _honourImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, _accountLabel.bottom+5, sexImg.size.width, sexImg.size.height)];
        //        [self addSubview:_honourImg];
        //        _honourImg.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
        //        _honourImg.hidden = YES;
        //
        UIImage *sendDiamondBackImage = [UIImage imageNamed:@"image/liveroom/me_sendBg_"];
        _sendDiamondBgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, _IDLabel.bottom, SCREEN_WIDTH, 20)];
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
        
//        UIImage *promptIconImg = [UIImage imageNamed:@"image/liveroom/room_money_check"];
//        NSString *promptStr = ESLocalizedString(@"有美币贡献榜 d");
//        NSMutableAttributedString * promptAttributedString = [[NSMutableAttributedString alloc] initWithString:promptStr];
//        
//        NSTextAttachment *promptAttachment = [[NSTextAttachment alloc] init];
//        //        promptAttachment.image = [UIImage imageWithImage:promptIconImg scaleToSize:CGSizeMake(promptIconImg.size.width, promptIconImg.size.height)];
//        promptAttachment.image = promptIconImg;
//        promptAttachment.bounds = CGRectMake(0, -2, promptIconImg.size.width, promptIconImg.size.height);
//        NSAttributedString *proAttributedString = [NSAttributedString attributedStringWithAttachment:promptAttachment];
//        [promptAttributedString replaceCharactersInRange:NSMakeRange(promptAttributedString.string.length  - 1, 1) withAttributedString:proAttributedString];
        
//        _rankDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        //        [rankDetailBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
//        [_rankDetailBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
//        [_rankDetailBtn.titleLabel setTextColor:[UIColor whiteColor]];
//        _rankDetailBtn.titleLabel.shadowColor = [UIColor darkGrayColor];
//        _rankDetailBtn.titleLabel.shadowOffset = CGSizeMake(0, -.5);
//        _rankDetailBtn.titleLabel.text = ESLocalizedString(@"有美币贡献榜");
//        [_rankDetailBtn setTitle:ESLocalizedString(@"有美币贡献榜") forState:UIControlStateNormal];
////        [_rankDetailBtn setAttributedTitle:promptAttributedString forState:UIControlStateNormal];
//        _rankDetailBtn.frame =  CGRectMake(10, self.frame.size.height - ViewWidth/2-10, SCREEN_WIDTH - 10, 30);
//        [self addSubview:_rankDetailBtn];
//        _rankDetailBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
//        
//        _rankScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - ViewWidth - 40,self.frame.size.height - ViewWidth - 10, ViewWidth+20,ViewWidth)];
//        _rankScrollView.userInteractionEnabled = YES;
//        _rankScrollView.directionalLockEnabled = YES; //只能一个方向滑动
//        _rankScrollView.pagingEnabled = NO; //是否翻页
//        _rankScrollView.backgroundColor=[UIColor clearColor];
//        _rankScrollView.showsVerticalScrollIndicator =NO; //垂直方向的滚动指示
//        _rankScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
//        _rankScrollView.showsHorizontalScrollIndicator = YES;//水平方向的滚动指示
//        _rankScrollView.scrollEnabled = NO;
//        _rankScrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
//        [self addSubview:_rankScrollView];
    }
    return self;
}

-(void)setUserInfoDict:(NSDictionary *)dict
{
    _userInfoDict = dict;
    _attentFansSegView.delegate = _segDelegate;
    NSLog(@"showUserData:%@",dict);
    
    NSMutableArray *topArray = nil;
    NSArray * array = dict[@"tops"];
    if (!array || array.count <= 0) {
        topArray = [NSMutableArray array];
//        [topArray addObject:@{@"id":@"0",@"face":@"image/liveroom/me_qiudiamond"}];
//        [topArray addObject:@{@"id":@"0",@"face":@"image/liveroom/me_qiudiamond"}];
//        [topArray addObject:@{@"id":@"0",@"face":@"image/liveroom/me_qiudiamond"}];
    }
    else
    {
        topArray = [NSMutableArray arrayWithArray:array];
        if (array.count == 1) {
//            [topArray addObject:@{@"id":@"0",@"face":@"image/liveroom/me_qiudiamond"}];
//            [topArray addObject:@{@"id":@"0",@"face":@"image/liveroom/me_qiudiamond"}];
        } else if (array.count == 2) {
//            [topArray addObject:@{@"id":@"0",@"face":@"image/liveroom/me_qiudiamond"}];
        }
    }
    
    int attentTotal = [dict[@"atten_total"] intValue];
    float tempTotalFloat = 0.f;
    if (attentTotal >= 10000) {
        tempTotalFloat = attentTotal/10000;
    }
    
    NSString * attentTotalStr;
    if (tempTotalFloat > 0) {
        attentTotalStr = [NSString stringWithFormat:@"%@ %.2f%@",ESLocalizedString(@"关注"),tempTotalFloat, ESLocalizedString(@"万")];
    } else {
        attentTotalStr = [NSString stringWithFormat:@"%@ %d",ESLocalizedString(@"关注"),attentTotal];
    }
    
    int fansTotal = [dict[@"fans_total"] intValue];
    tempTotalFloat = 0.f;
    if (fansTotal >= 10000) {
        tempTotalFloat = fansTotal/10000;
    }
    
    NSString * fansTotalStr;
    if (tempTotalFloat > 0) {
        fansTotalStr = [NSString stringWithFormat:@"%@ %.2f%@",ESLocalizedString(@"粉丝"),tempTotalFloat, ESLocalizedString(@"万")];
    } else {
        fansTotalStr = [NSString stringWithFormat:@"%@ %d",ESLocalizedString(@"粉丝"),fansTotal];
    }
    
    _attentFansSegView.items = [NSArray arrayWithObjects:attentTotalStr,fansTotalStr,  nil];
    
    [self updateNickNameRect];
    
    [self showSendDiamond];
    
//    [self refleshUserView:topArray];
    
    NSString *faceString=[NSString faceURLString:dict[@"face"]];
    ESWeakSelf;
//    ESWeak(_avatar);
    ESWeak(_avatarImg);
    [_avatarImg sd_setImageWithURL:[NSURL URLWithString:faceString] placeholderImage:[UIImage imageNamed:@"image/globle/man"]
                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                          ESStrongSelf;
//                          ESStrong(_avatar);
                          ESStrong(_avatarImg);
                          __avatarImg.image = image;
//                          UIImage *cutImage = [image resizeImage:image withWidth:80 withHeight:80];
//                          UIImage *tempImage = [cutImage boxblurImageWithBlur:1.f];
//                          __avatarImg.image = tempImage;
                          //                          _self.image = tempImage;
                          _self.clipsToBounds = YES;
                      }];
    
    
    
    
    if ([[LCMyUser mine].userID isEqualToString:ESStringValue(dict[@"uid"])])
    {
        _backActionBtn.hidden = YES;
    }
    else
    {
        _backActionBtn.hidden = NO;
    }
    
    
    NSString *goodID = _userInfoDict[@"goodid"];
    if (goodID && goodID.length > 1) {
        _IDLabel.textColor = ColorPink;
        
        NSMutableAttributedString *mutableAttributedString = nil;
        NSString *goodIdInfoStr = [NSString stringWithFormat:@"d %@",goodID];
        mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:goodIdInfoStr];
        
        UIImage *goodIdImage = [UIImage imageNamed:@"image/liveroom/user_goodid"];
        
        NSTextAttachment *goodIdAttachment = [[NSTextAttachment alloc] init];
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
    
    NSString *tag = nil;
    ESStringVal(&tag, dict[@"tag"]);
    if (tag && tag.length > 0 && (sign && sign.length > 0))
    {
        NSMutableAttributedString *mutableAttributedString = nil;
        NSString *certInfoStr =  [NSString stringWithFormat:@"d %@:%@",ESLocalizedString(@"认证"),tag];
        mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:certInfoStr];
        
        UIImage *certImage = [UIImage imageNamed:@"image/liveroom/me_renzheng"];
        
        NSTextAttachment *certAttachment = [[NSTextAttachment alloc] init];
        certAttachment.image = [UIImage imageWithImage:certImage scaleToSize:CGSizeMake(certImage.size.width/2, certImage.size.height/2-2)];
        certAttachment.bounds = CGRectMake(0, -2, certImage.size.width/2, certImage.size.height/2-2);
        NSAttributedString *certAttributedString = [NSAttributedString attributedStringWithAttachment:certAttachment];
        [mutableAttributedString replaceCharactersInRange:NSMakeRange(0, 1) withAttributedString:certAttributedString];
//        _tagLabel.top = _IDLabel.bottom + 5;
//        _tagLabel.attributedText = mutableAttributedString;
//        _tagLabel.hidden = NO;
//        
//        _signLabel.text = sign;
//        _signLabel.hidden = NO;
//        _signLabel.top = _tagLabel.bottom + 5;
        _sendDiamondBgImg.top = _IDLabel.bottom+5;
    } else if (sign && sign.length > 0) {
//        _signLabel.text = sign;
//        _signLabel.top = _IDLabel.bottom +5;
        _sendDiamondBgImg.top = _IDLabel.bottom+5;
        
//        _signLabel.hidden = NO;
//        _tagLabel.hidden = YES;
    } else if (tag && tag.length > 0){
        NSMutableAttributedString *mutableAttributedString = nil;
        NSString *certInfoStr =  [NSString stringWithFormat:@"d %@:%@",ESLocalizedString(@"认证"),tag];
        mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:certInfoStr];
        
        UIImage *certImage = [UIImage imageNamed:@"image/liveroom/me_renzheng"];
        
        NSTextAttachment *certAttachment = [[NSTextAttachment alloc] init];
        certAttachment.image = [UIImage imageWithImage:certImage scaleToSize:CGSizeMake(certImage.size.width/2, certImage.size.height/2-2)];
        certAttachment.bounds = CGRectMake(0, -2, certImage.size.width/2, certImage.size.height/2-2);
        NSAttributedString *certAttributedString = [NSAttributedString attributedStringWithAttachment:certAttachment];
        [mutableAttributedString replaceCharactersInRange:NSMakeRange(0, 1) withAttributedString:certAttributedString];
//        _tagLabel.top = _IDLabel.bottom + 5;
//        _tagLabel.attributedText = mutableAttributedString;
//        _tagLabel.hidden = NO;
//        _signLabel.hidden = YES;
        _sendDiamondBgImg.top = _IDLabel.bottom+5;
    } else {
//        _signLabel.hidden = YES;
//        _tagLabel.hidden = YES;
        _sendDiamondBgImg.top = _IDLabel.bottom+5;
    }
}

- (void) updateNickNameRect
{
    if (!_userInfoDict) {
        return;
    }
    
    UIImage *sexImage;
    int sex = 0;
    ESIntVal(&sex, _userInfoDict[@"sex"]);
    
    if(sex==1)
    {
        sexImage=[UIImage imageNamed:@"global_male"];
    }
    else
    {
        sexImage=[UIImage imageNamed:@"global_female"];
    }
    
    int grade = 0;
    ESIntVal(&grade, _userInfoDict[@"grade"]);
    
    NSString *nicknameStr;
    ESStringVal(&nicknameStr, _userInfoDict[@"nickname"]);
    
    _nickname.text = nicknameStr;
    _nickname.width = [self getNicNameWidth:nicknameStr];
    _nickname.height = 20;
    _sexImage.image = sexImage;
    _sexImage.top = _nickname.top + 1;
    _sexImage.width = sexImage.size.width;
    _sexImage.height = sexImage.size.height;
    
    if (grade > 0) {
        _userLevelImg.hidden = NO;
        _userGradeLabel.hidden = NO;
        int officalType = 0;
        if (_userInfoDict[@"offical"]) {
            officalType = [_userInfoDict[@"offical"] intValue];
        }
        
        UIImage *levelImage = [UIImage createUserGradeImage:grade withIsManager:officalType == 1?true:false];
        CGFloat gradeWidth = 0;
        if (officalType != 1) {
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
        
        _levelFlagImg.image = [UIImage createUserGradeFlagImage:grade withIsManager:(_userInfoDict[@"offical"] &&[_userInfoDict[@"offical"] intValue] == 1)?true:false];
         _levelFlagImg.hidden = NO;
    } else {
        _levelFlagImg.hidden = YES;
        _userGradeLabel.hidden = YES;
        _userLevelImg.hidden = YES;
        _nickname.centerX = SCREEN_WIDTH/2 - sexImage.size.width/2;
        _sexImage.left = _nickname.right + 5;
    }
    
}

- (CGFloat) getNicNameWidth:(NSString *)nicknameStr
{
    NSMutableString *tempStr = [NSMutableString stringWithFormat:@"%@",nicknameStr];
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


//-(void)refleshUserView:(NSArray *)userArray
//{
//    [self.rankScrollView removeAllSubviews];
//    
//    NSUInteger arrayNum=[userArray count];
//    
//    CGSize newSize = CGSizeMake((ViewWidth+ViewPadding)*arrayNum, ViewWidth);
//    [self.rankScrollView setContentSize:newSize];
//    
//    
//    for(int i=0;i<arrayNum;i++)
//    {
//        CGRect itemRect=CGRectMake(ViewPadding+i*(ViewWidth+ViewPadding),0,ViewWidth,ViewWidth);
//        MyRankUserView *userView=[[MyRankUserView alloc] initWithFrame:itemRect];
//        ESWeakSelf;
//        userView.showRankDetail = ^() {
//            ESStrongSelf;
//        };
//        userView.userInfoDict = userArray[i];
//        [self.rankScrollView addSubview:userView];
//    }
//    
//}

- (void) showSendDiamond
{
    NSString *sendDiamondText = [NSString stringWithFormat:@"%@ %d d",ESLocalizedString(@"送出"),[_userInfoDict[@"send_diamond"] intValue]];
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
