//
//  RobRedPacketUserCell.m
//  qianchuo
//
//  Created by jacklong on 16/3/26.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "RobRedPacketUserCell.h"

@implementation RobRedPacketUserCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        
        _userHeadImg = [[UIImageView alloc] initWithFrame:CGRectMake(15.f, 7.f, 35.f, 35.f)];
        _userHeadImg.layer.cornerRadius = _userHeadImg.frame.size.width/2;
        _userHeadImg.clipsToBounds = YES;
        _userHeadImg.image = [UIImage imageNamed:@"default_head"];
        [self addSubview:_userHeadImg];
        
        UIImage *gradeFlagImg = [UIImage imageNamed:@"image/yonghu/grade_flag/grade_flag_1"];
        _gradeFlagImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_userHeadImg.right - gradeFlagImg.size.width, _userHeadImg.bottom - gradeFlagImg.size.height+2, gradeFlagImg.size.width, gradeFlagImg.size.height)];
        _gradeFlagImgView.image = gradeFlagImg;
        [self addSubview:_gradeFlagImgView];
        
        _nickNameLabel = [[MyLabel alloc] initWithFrame:CGRectMake(_userHeadImg.right+10.f, 15, SCREEN_WIDTH - _userHeadImg.right-10-SCREEN_WIDTH/5-65, 20)];
        _nickNameLabel.textAlignment = NSTextAlignmentLeft;
        _nickNameLabel.textColor = [UIColor blackColor];
        _nickNameLabel.text = @"nickname";
        _nickNameLabel.numberOfLines = 1;
        [_nickNameLabel setFont:[UIFont boldSystemFontOfSize:14.f]];
        [self addSubview:_nickNameLabel];
        
        _sexImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _sexImage.bottom = _nickNameLabel.bottom;
        [self addSubview:_sexImage];
        _sexImage.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
        
        _userLevelImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _userLevelImg.bottom = _nickNameLabel.bottom;
        
        [self addSubview:_userLevelImg];
        _userLevelImg.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
        _userLevelImg.hidden = YES;
        
        _userGradeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _userGradeLabel.bottom = _nickNameLabel.bottom;
        _userGradeLabel.textColor = [UIColor whiteColor];
        _userGradeLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_userGradeLabel];
        _userGradeLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
        _userGradeLabel.hidden = YES;

        
 
        _robDiamondView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-65-SCREEN_WIDTH/5, 10, 65, self.frame.size.height)];
        [self addSubview:_robDiamondView];
    
        _robDiamondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        _robDiamondLabel.textAlignment = NSTextAlignmentRight;
        _robDiamondLabel.textColor = [UIColor redColor];
//        _robDiamondLabel.backgroundColor = [UIColor blueColor];
        _robDiamondLabel.text = @"20";
        _robDiamondLabel.numberOfLines = 1;
        [_robDiamondLabel setFont:[UIFont boldSystemFontOfSize:12.f]];
        [_robDiamondView addSubview:_robDiamondLabel];
        
        UIImage *luckKingImg = [UIImage imageNamed:@"image/liveroom/live_redpacket_bestluck"];
        _luckKingImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, _robDiamondLabel.bottom, luckKingImg.size.width/3, luckKingImg.size.height/3)];
        _luckKingImg.image = luckKingImg;
        [_robDiamondView addSubview:_luckKingImg];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(15.f, _userHeadImg.bottom+7., self.frame.size.width-25.f, .5f)];
        _lineView.backgroundColor = RGBA16(0x10000000);
        [self addSubview:_lineView];
    }
    return self;
}

- (void) layoutSubviews
{
    [self updateNickNameRect];
}

- (void)setUserInfoDict:(NSDictionary *)userInfoDict
{
    _userInfoDict = userInfoDict;
    [_userHeadImg sd_setImageWithURL:[NSURL URLWithString:[NSString faceURLString:userInfoDict[@"face"]]] placeholderImage:[UIImage imageNamed:@"image/liveroom/me_follow"]];
    
    int grade = ESIntValue(userInfoDict[@"grade"]);
    if (grade > 0) {
        _gradeFlagImgView.image = [UIImage createUserGradeFlagImage:grade withIsManager:(_userInfoDict[@"offical"] && [_userInfoDict[@"offical"] intValue] ==1)?true:false];
        _gradeFlagImgView.hidden = NO;
    } else {
        _gradeFlagImgView.hidden = YES;
    }
    
    [self updateNickNameRect];
    
    
    int sendDiamond;
    ESIntVal(&sendDiamond, userInfoDict[@"grab"]);
    
    NSString *sendDiamondInfoStr = [NSString stringWithFormat:@"%d d",sendDiamond];
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:sendDiamondInfoStr];
    
    UIImage *diamondIcon = [UIImage imageNamed:@"image/liveroom/me_myaccount_reddiamond"];
    
    NSTextAttachment *diamondAttachment = [[NSTextAttachment alloc] init];
    diamondAttachment.image = [UIImage imageWithImage:diamondIcon scaleToSize:CGSizeMake(diamondIcon.size.width*3/5, diamondIcon.size.height*3/5)];
    NSAttributedString *diamondAttributedString = [NSAttributedString attributedStringWithAttachment:diamondAttachment];
    [mutableAttributedString replaceCharactersInRange:NSMakeRange(sendDiamondInfoStr.length-1, 1) withAttributedString:diamondAttributedString];
    _robDiamondLabel.attributedText = mutableAttributedString;

}

#pragma mark - 更新用户等级信息
- (void) updateNickNameRect
{
    UIImage *sexImage;
    int sex=0;
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
    
    NSString *nickname=@"";
    
    ESStringVal(&nickname, _userInfoDict[@"nickname"]);
    
    _nickNameLabel.text = nickname;
    _nickNameLabel.height = 20;
    
    _sexImage.image = sexImage;
    _sexImage.bottom = _nickNameLabel.bottom-4;
    _sexImage.left = _nickNameLabel.right + 5;
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
        _userLevelImg.bottom = _nickNameLabel.bottom-3;
        
        _userGradeLabel.bottom = _nickNameLabel.bottom-3;
        _userGradeLabel.left = _userLevelImg.left+levelImage.size.width*4/5;
        _userGradeLabel.width = _userLevelImg.width;
        _userGradeLabel.height = _userLevelImg.height;
        _userGradeLabel.text = [NSString stringWithFormat:@"%d",grade];
         
        float allWidth = SCREEN_WIDTH - _userHeadImg.right-10-SCREEN_WIDTH/5-65;
        float nameWidth = [self getNicNameWidth:nickname withFont:_nickNameLabel.font];
        if (nameWidth >= (allWidth - sexImage.size.width - (levelImage.size.width+gradeWidth) - 10 - 10)) {
            _nickNameLabel.width = (allWidth - sexImage.size.width - (levelImage.size.width+gradeWidth) - 10 - 10);
        } else {
            _nickNameLabel.width = nameWidth;
        }
    } else {
        _nickNameLabel.width = [self getNicNameWidth:nickname withFont:_nickNameLabel.font];
        _userGradeLabel.hidden = YES;
        _userLevelImg.hidden = YES;
    }
    
}

- (CGFloat) getNicNameWidth:(NSString *)nickName withFont:(UIFont *)font
{
    NSMutableString *tempStr = [NSMutableString stringWithFormat:@"%@",nickName];
    CGSize size = [tempStr boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    return size.width;
}

#pragma mark - 获取等级宽度
- (CGFloat) getGradeSize:(int)grade
{
    NSMutableString *tempStr = [NSMutableString stringWithFormat:@"%d",grade];
    CGSize size = [tempStr boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size;
    
    return size.width;
}

@end
