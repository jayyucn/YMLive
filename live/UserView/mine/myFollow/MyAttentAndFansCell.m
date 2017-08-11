//
//  MyAttentCell.m
//  qianchuo
//
//  Created by jacklong on 16/3/31.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "MyAttentAndFansCell.h"

@interface MyAttentAndFansCell()
{
    BOOL isLoading;
}
@end

@implementation MyAttentAndFansCell


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
//        NSLog(@"%@",NSStringFromCGRect(self.frame));
        _attentStateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _attentStateBtn.frame = CGRectMake(0, 0, stateImg.size.width*3/4, stateImg.size.height *3/4);
        _attentStateBtn.center = CGPointMake(SCREEN_WIDTH - stateImg.size.width/2 - 10, self.frame.size.height/2+10);
        [_attentStateBtn setImage:stateImg forState:UIControlStateNormal];
        [_attentStateBtn addTarget:self action:@selector(attentAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_attentStateBtn];
        _attentStateBtn.hidden = YES;
        
        UIButton *eventBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        eventBtn.frame = CGRectMake(0, 0, stateImg.size.width, stateImg.size.height);
        eventBtn.center = CGPointMake(SCREEN_WIDTH - stateImg.size.width/2, self.frame.size.height/2);
        [eventBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [eventBtn addTarget:self action:@selector(attentAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:eventBtn];
        
        _nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userHeadImg.right+10.f, 10.f,SCREEN_WIDTH - _userHeadImg.right-10-stateImg.size.width- 10, 20.f)];
        _nickNameLabel.textAlignment = NSTextAlignmentLeft;
        _nickNameLabel.textColor = ColorPink;
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
        
        
        _userSignLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nickNameLabel.left, _nickNameLabel.bottom, _nickNameLabel.width, 20.f)];
        _userSignLabel.textAlignment = NSTextAlignmentLeft;
        _userSignLabel.textColor = [UIColor grayColor];
        _userSignLabel.numberOfLines = 1;
        [_userSignLabel setFont:[UIFont systemFontOfSize:12.f]];
        [self addSubview:_userSignLabel];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _userSignLabel.bottom+9, SCREEN_WIDTH, 1)];
        _lineView.backgroundColor = (UIColorWithRGBA(232.f, 232.f, 232.f, 1.f));
        [self addSubview:_lineView];
        _lineView.hidden = NO;
    }
    return self;
}

- (void) layoutSubviews
{
     [self updateNickNameRect];
}

-(void)setUserInfoDict:(NSDictionary *)userInfoDict
{
    _userInfoDict = userInfoDict;
    [_userHeadImg sd_setImageWithURL:[NSURL URLWithString:[NSString faceURLString:userInfoDict[@"face"]]] placeholderImage:[UIImage imageNamed:@"default_head"]];
    
    int grade = ESIntValue(userInfoDict[@"grade"]);
    if (grade > 0) {
        _gradeFlagImgView.image = [UIImage createUserGradeFlagImage:grade withIsManager:(_userInfoDict[@"offical"] && [_userInfoDict[@"offical"] intValue] == 1)?true:false];
        _gradeFlagImgView.hidden = NO;
    } else {
        _gradeFlagImgView.hidden = YES;
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
    
    _userSignLabel.text = userInfoDict[@"signature"];

    [self updateNickNameRect];
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
//        NSLog(@"paramter %@",paramter);
        
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
//        NSLog(@"paramter %@",paramter);
        
        [[LCHTTPClient sharedHTTPClient] requestWithParameters:paramter
                                                      withPath:URL_ADD_ATTENT_USER
                                                   withRESTful:GET_REQUEST
                                              withSuccessBlock:successBlock
                                                 withFailBlock:failBlock];
    }
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
        CGFloat gradeWidth = 0;
        UIImage *levelImage = [UIImage createUserGradeImage:grade withIsManager:officeType == 1?true:false];
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
        
        UIImage *stateImg = [UIImage imageNamed:@"image/liveroom/me_follow"];
        float allWidth = SCREEN_WIDTH - _userHeadImg.right-10-stateImg.size.width- 10;
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
