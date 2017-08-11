//
//  TopsRankCell.m
//  qianchuo
//
//  Created by jacklong on 16/3/30.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "TopsRankCell.h"

@interface TopsRankCell()
{
    BOOL isFirstChange;
    BOOL isSecondChange;
    BOOL isThreeChange;
}
@end
@implementation TopsRankCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
//        _topLabelView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, 40, 20)];
//        _topLabelView.backgroundColor = ColorPink;
//        UIBezierPath *showPath = [UIBezierPath bezierPathWithRoundedRect:_topLabelView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(10,10)];
//        CAShapeLayer *showLayer = [[CAShapeLayer alloc] init];
//        showLayer.frame = _topLabelView.bounds;
//        showLayer.path = showPath.CGPath;
//        _topLabelView.layer.mask = showLayer;
//        [self addSubview:_topLabelView];
//        
//        _topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
//        _topLabel.textColor = [UIColor whiteColor];
//        _topLabel.font = [UIFont systemFontOfSize:12.f];
//        _topLabel.textAlignment = NSTextAlignmentRight;
//        [_topLabelView addSubview:_topLabel]; 
        _intervalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        _intervalView.backgroundColor = head_bg;
        [self addSubview:_intervalView];
        _intervalView.hidden = YES;
        
        
        _numRankLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 31-8+_intervalView.height, 50,16)];
        _numRankLabel.textAlignment = NSTextAlignmentCenter;
        _numRankLabel.textColor = [UIColor blackColor];
        _numRankLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_numRankLabel];
        
        _faceImg = [[UIImageView alloc] initWithFrame:CGRectMake(_numRankLabel.right+5, 9+_intervalView.height, 42, 42)];
        // 圆形背景
        _faceImg.layer.borderWidth = 0.5f;
        _faceImg.layer.borderColor = ColorPink.CGColor;
        _faceImg.layer.cornerRadius = _faceImg.frame.size.width/2;
        _faceImg.clipsToBounds = YES; 
        [self addSubview:_faceImg];
        
        _nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_faceImg.right + 15, _faceImg.top+3, SCREEN_WIDTH - _faceImg.right,20)];
        _nickNameLabel.textColor = [UIColor blackColor];
        _nickNameLabel.font = [UIFont systemFontOfSize:13];
        _nickNameLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_nickNameLabel];
        
        _sexImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _sexImage.bottom = _nickNameLabel.bottom;
        [self addSubview:_sexImage];
        
        _userLevelImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _userLevelImg.bottom = _nickNameLabel.bottom; 
        [self addSubview:_userLevelImg];
        _userLevelImg.hidden = YES;
        
        _userGradeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _userGradeLabel.bottom = _nickNameLabel.bottom;
        _userGradeLabel.textColor = [UIColor whiteColor];
        _userGradeLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_userGradeLabel]; 
        _userGradeLabel.hidden = YES;

        
        _recvDiamondLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nickNameLabel.left, _nickNameLabel.bottom, _nickNameLabel.width, 15)];
        _recvDiamondLabel.textAlignment = NSTextAlignmentLeft;
        _recvDiamondLabel.textColor = [UIColor blackColor];
        _recvDiamondLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_recvDiamondLabel];
        
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(10, self.frame.size.height-.5f, SCREEN_WIDTH - 20, .5f)];
        _lineView.backgroundColor = [UIColor blackColor];
        [self addSubview:_lineView];
        _lineView.top = _recvDiamondLabel.bottom+10;
        _lineView.hidden = YES;
        
        UIImage *gradeFlagImg = [UIImage imageNamed:@"image/yonghu/grade_flag/grade_flag_1"];
        _gradeFlagImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_faceImg.right - gradeFlagImg.size.width,0, gradeFlagImg.size.width, gradeFlagImg.size.height)];
        _gradeFlagImgView.image = gradeFlagImg;
        [self addSubview:_gradeFlagImgView];
        _gradeFlagImgView.hidden = YES;
        [self updateNickNameRect];
    }
    return self;
}

- (void) setUserModel:(UserRankModel *)userModel
{
    _userModel = userModel;
    
    NSString *faceString=[NSString faceURLString:_userModel.face];
    [_faceImg sd_setImageWithURL:[NSURL URLWithString:faceString]
                             placeholderImage:[UIImage imageNamed:@"default_head"]];
    int grade = userModel.grade;
    if (grade > 0) {
        _gradeFlagImgView.image = [UIImage createUserGradeFlagImage:grade withIsManager:userModel.offical==1?true:false];
        _gradeFlagImgView.hidden = NO;
    } else {
        _gradeFlagImgView.hidden = YES;
    }
    
    NSString *recDiamondStr = [NSString stringWithFormat:ESLocalizedString(@"贡献 %d 有美币"),_userModel.consume_diamond];
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:recDiamondStr];
    
    NSRange recRange  = [mutableAttributedString.string rangeOfString:[NSString stringWithFormat:@"%d",_userModel.consume_diamond]];
    
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:ColorPink range:recRange];
    
    _recvDiamondLabel.attributedText = mutableAttributedString;
    
    _numRankLabel.top = 31-8+_intervalView.height;
    _faceImg.top = 9+_intervalView.height;
    _nickNameLabel.top = _faceImg.top+3;
    _recvDiamondLabel.top = _nickNameLabel.bottom;
    
    [self updateNickNameRect];
}
 

- (void) updateNickNameRect
{
    
    UIImage *sexImage;
    int sex = _userModel.sex;
    
    if(sex==1)
    {
        sexImage=[UIImage imageNamed:@"global_male"];
    }
    else
    {
        sexImage=[UIImage imageNamed:@"global_female"];
    }
    
    int grade = _userModel.grade;
    float nameWidth = [self getNickNameWidthWithName:_userModel.nickname withFont:_nickNameLabel.font];
    _nickNameLabel.text = _userModel.nickname;
    
    float allWidth = SCREEN_WIDTH - _faceImg.right;
    
   
    UIImage *levelImage = [UIImage createUserGradeImage:grade withIsManager:_userModel.offical==1?true:false];
    if (grade > 0) {
        _userLevelImg.hidden = NO;
        _userGradeLabel.hidden = NO;
        
        CGFloat gradeWidth = 0;
        if (_userModel.offical != 1) {
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
        
        _userGradeLabel.top = _userLevelImg.top;
        _userGradeLabel.left = _userLevelImg.left+levelImage.size.width*4/5;
        _userGradeLabel.width = _userLevelImg.width;
        _userGradeLabel.height = _userLevelImg.height;
        _userGradeLabel.text = [NSString stringWithFormat:@"%d",grade];
        
        if (nameWidth >= (allWidth - _sexImage.width - _userLevelImg.width - 30)) {
            _nickNameLabel.width = (allWidth - _sexImage.width - _userLevelImg.width - 30);
        } else {
            _nickNameLabel.width = nameWidth;
        }
    } else {
        _userGradeLabel.hidden = YES;
        _userLevelImg.hidden = YES;
        
        if (nameWidth >= (allWidth - _sexImage.width - 5)) {
            _nickNameLabel.width = (allWidth - _sexImage.width - 5);
        } else {
            _nickNameLabel.width = nameWidth;
        }
    }
    
    _nickNameLabel.height = 20;
    _sexImage.image = sexImage;
    _sexImage.bottom = _nickNameLabel.bottom-4;
    _sexImage.left = _nickNameLabel.right+5;
    _userLevelImg.left = _sexImage.right+5;
    
    _userGradeLabel.top = _userLevelImg.top;
    _userGradeLabel.left = _userLevelImg.left+levelImage.size.width*4/5;
    _sexImage.width = sexImage.size.width;
    _sexImage.height = sexImage.size.height;
    
}

- (CGFloat) getNickNameWidthWithName:(NSString *)nickName withFont:(UIFont *)font
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
