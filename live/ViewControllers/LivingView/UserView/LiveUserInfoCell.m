//
//  LiveUserInfoCell.m
//  qianchuo
//
//  Created by jacklong on 16/3/8.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "LiveUserInfoCell.h"

@interface LiveUserInfoCell()
{
    BOOL isLoading;
}

@end

@implementation LiveUserInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        
        _userHeadImg = [[UIImageView alloc] initWithFrame:CGRectMake(15.f, 10.f, 40.f, 40.f)];
        _userHeadImg.layer.cornerRadius = _userHeadImg.frame.size.width/2;
        _userHeadImg.clipsToBounds = YES;
        _userHeadImg.image = [UIImage imageNamed:@"default_head"];
        [self addSubview:_userHeadImg];
        
        UIImage *gradeFlagImg = [UIImage imageNamed:@"image/yonghu/grade_flag/grade_flag_1"];
        _gradeFlagImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_userHeadImg.right - gradeFlagImg.size.width, _userHeadImg.bottom - gradeFlagImg.size.height+2, gradeFlagImg.size.width, gradeFlagImg.size.height)];
        _gradeFlagImgView.image = gradeFlagImg;
        [self addSubview:_gradeFlagImgView];
        
        UIImage *stateImg = [UIImage imageNamed:@"image/liveroom/me_follow"];
        NSLog(@"%@",NSStringFromCGRect(self.frame));
        _attentStateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _attentStateBtn.frame = CGRectMake(0, 0, stateImg.size.width*3/4, stateImg.size.height *3/4);
        _attentStateBtn.center = CGPointMake(SCREEN_WIDTH- stateImg.size.width - 10 - 40, self.frame.size.height/2+10);
        [_attentStateBtn setImage:stateImg forState:UIControlStateNormal];
        [_attentStateBtn addTarget:self action:@selector(attentAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_attentStateBtn];
        _attentStateBtn.hidden = YES;
        
        
        NSLog(@"frame:%@",NSStringFromCGRect(self.frame));
        _nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userHeadImg.right+10, 10.f, SCREEN_WIDTH - _userHeadImg.right - 10 - stateImg.size.width - 60, 20.f)];
        _nickNameLabel.textAlignment = NSTextAlignmentLeft;
        _nickNameLabel.textColor = ColorPink;
        _nickNameLabel.text = @"nickname";
        _nickNameLabel.left = _userHeadImg.right+10;
        
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
        
        _userSignLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nickNameLabel.left, _nickNameLabel.bottom, _nickNameLabel.width, 14.f)];
        _userSignLabel.textAlignment = NSTextAlignmentLeft;
        _userSignLabel.textColor = [UIColor grayColor];
        _userSignLabel.numberOfLines = 1;
        [_userSignLabel setFont:[UIFont systemFontOfSize:12.f]];
        [self addSubview:_userSignLabel];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(15.f, _userSignLabel.bottom+10, self.frame.size.width-15.f, .5f)];
        _lineView.backgroundColor = RGBA16(0x10000000);
        [self addSubview:_lineView];
    }
    return self;
}

-(void)setUserInfoDict:(NSDictionary *)userInfoDict
{
    _userInfoDict = userInfoDict;
    [_userHeadImg sd_setImageWithURL:[NSURL URLWithString:[NSString faceURLString:userInfoDict[@"face"]]] placeholderImage:[UIImage imageNamed:@"image/liveroom/me_follow"]];
    
    int grade = ESIntValue(userInfoDict[@"grade"]);
    if (grade > 0) {
        _gradeFlagImgView.image = [UIImage createUserGradeFlagImage:grade withIsManager:(_userInfoDict[@"offical"] && [_userInfoDict[@"offical"] intValue] == 1)?true:false];
        _gradeFlagImgView.hidden = NO;
    } else {
        _gradeFlagImgView.hidden = YES;
    }
    
    if (_cellType == CELL_RECEIVER_TYPE) {
        NSString *recDiamondStr = [NSString stringWithFormat:@"贡献 %d 有美币",[userInfoDict[@"consume_diamond"] intValue]];
        
        NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:recDiamondStr];
        
        NSRange recRange  = [mutableAttributedString.string rangeOfString:[NSString stringWithFormat:@"%d",[userInfoDict[@"consume_diamond"] intValue]]];
        
        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:ColorPink range:recRange];
        
        _userSignLabel.attributedText = mutableAttributedString;
    } else {
        _userSignLabel.text = userInfoDict[@"signature"];
    }
    
    if ([[LCMyUser mine].userID isEqualToString:ESStringValue(_userInfoDict[@"uid"])]) {
        _attentStateBtn.hidden = YES;
    } else {
        _attentStateBtn.hidden = NO;
        if ([[LCMyUser mine] isAttentUser:_userInfoDict[@"uid"]]) {
            [_attentStateBtn setImage:[UIImage imageNamed:@"image/liveroom/me_following"] forState:UIControlStateNormal];
        } else {
            [_attentStateBtn setImage:[UIImage imageNamed:@"image/liveroom/me_follow"] forState:UIControlStateNormal];
        }
    }
    
    [self updateNickNameRect];
}

- (void) layoutSubviews
{
     [self updateNickNameRect];
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
        int officeType = 0;
        if (_userInfoDict[@"offical"]) {
            officeType = [_userInfoDict[@"offical"] intValue];
        }
        
        UIImage *levelImage = [UIImage createUserGradeImage:grade withIsManager: officeType == 1?true:false];
        CGFloat gradeWidth = 0;
        if (officeType != 1) {
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
        
        float allWidth = 0;
        if (_attentStateBtn.isHidden) {
            allWidth = SCREEN_WIDTH - _userHeadImg.right - 10 - 60;
        } else {
            UIImage *stateImg = [UIImage imageNamed:@"image/liveroom/me_follow"];
            allWidth = SCREEN_WIDTH - _userHeadImg.right - 10 - stateImg.size.width - 60;
        }
        
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



- (void)attentAction
{
    if (isLoading) {
        return;
    }
    
    isLoading = YES;
    
    if ([[LCMyUser mine] isAttentUser:_userInfoDict[@"uid"]]) {
        ESWeakSelf;
        LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
            
            isLoading = NO;
            
            ESStrongSelf;
            NSInteger code = [[responseDic objectForKey:@"stat"] integerValue];
            if (URL_REQUEST_SUCCESS == code)
            {
                [[LCMyUser mine] removeAttentUser:_userInfoDict[@"uid"]];
                [_self.attentStateBtn setImage:[UIImage imageNamed:@"image/liveroom/me_follow"] forState:UIControlStateNormal];
            }
            else
            {
                [LCNoticeAlertView showMsg:responseDic[@"msg"]];
            }
        };
        
        LCRequestFailResponseBlock failBlock=^(NSError *error){
            [LCNoticeAlertView showMsg:@"请求获取数据！"];
            isLoading = NO;
        };
        
        NSDictionary *paramter = @{@"u":_userInfoDict[@"uid"]};
        NSLog(@"paramter %@",paramter);
        
        [[LCHTTPClient sharedHTTPClient] requestWithParameters:paramter
                                                      withPath:URL_CANCEL_ATTENT
                                                   withRESTful:GET_REQUEST
                                              withSuccessBlock:successBlock
                                                 withFailBlock:failBlock];
    } else {
        ESWeakSelf;
        LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
            
            isLoading = NO;
            
            ESStrongSelf;
            NSInteger code = [[responseDic objectForKey:@"stat"] integerValue];
            if (URL_REQUEST_SUCCESS == code)
            {
                [[LCMyUser mine] addAttentUser:_userInfoDict[@"uid"]];
                [_self.attentStateBtn setImage:[UIImage imageNamed:@"image/liveroom/me_following"] forState:UIControlStateNormal];
            }
            else
            {
                [LCNoticeAlertView showMsg:responseDic[@"msg"]];
            }
        };
        
        LCRequestFailResponseBlock failBlock=^(NSError *error){
            [LCNoticeAlertView showMsg:@"请求获取数据！"];
            isLoading = NO;
        };
        
        NSDictionary *paramter = @{@"u":_userInfoDict[@"uid"]};
        NSLog(@"paramter %@",paramter);
        
        [[LCHTTPClient sharedHTTPClient] requestWithParameters:paramter
                                                      withPath:URL_ADD_ATTENT_USER
                                                   withRESTful:GET_REQUEST
                                              withSuccessBlock:successBlock
                                                 withFailBlock:failBlock];
    }
}

@end
