//  已关注直播视图单元
//  MyAttentCell.m
//  qianchuo
//
//  Created by jacklong on 16/4/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "MyAttentHallCell.h"

@implementation MyAttentHallCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        _headInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _headInfoView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_headInfoView];
        
        _faceImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
        _faceImgView.image = [UIImage imageNamed:@"default_head"];
        // The radius to use when drawing rounded corners for the layer’s background
        _faceImgView.layer.cornerRadius = _faceImgView.frame.size.width/2; // 圆形头像
        _faceImgView.layer.borderWidth = 2.f;
        _faceImgView.layer.borderColor = ColorPink.CGColor;
        // subviews to be clipped to the bounds of the receiver
        _faceImgView.clipsToBounds = YES;
        [_headInfoView addSubview:_faceImgView];
        
        UIImage *gradeFlagImg = [UIImage imageNamed:@"image/yonghu/grade_flag/grade_flag_1"];
        _gradeFlagImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_faceImgView.right-gradeFlagImg.size.width, _faceImgView.bottom-gradeFlagImg.size.height+2, gradeFlagImg.size.width, gradeFlagImg.size.height)];
        _gradeFlagImgView.image = gradeFlagImg;
        [self addSubview:_gradeFlagImgView];
        
        _nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_faceImgView.right+10, 5, SCREEN_WIDTH-_faceImgView.right-10, 20)];
        _nicknameLabel.textAlignment = NSTextAlignmentLeft;
        _nicknameLabel.textColor = [UIColor blackColor];
        [_nicknameLabel setFont:[UIFont systemFontOfSize:16.f]];
        _nicknameLabel.backgroundColor = [UIColor clearColor];
        [_headInfoView addSubview:_nicknameLabel];
        
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nicknameLabel.left, _nicknameLabel.bottom, SCREEN_WIDTH/2, 20)];
        _locationLabel.textAlignment = NSTextAlignmentLeft;
        _locationLabel.textColor = [UIColor grayColor];
        [_locationLabel setFont:[UIFont boldSystemFontOfSize:12.f]];
        _locationLabel.backgroundColor = [UIColor clearColor];
        [_headInfoView addSubview:_locationLabel];
        
        _onlineUserCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-120-35, _locationLabel.top+5, 120, 20)];
        _onlineUserCountLabel.textAlignment = NSTextAlignmentRight;
        _onlineUserCountLabel.textColor = ColorPink;
        [_onlineUserCountLabel setFont:[UIFont systemFontOfSize:16.f]];
        _onlineUserCountLabel.backgroundColor = [UIColor clearColor];
        [_headInfoView addSubview:_onlineUserCountLabel];
        
        UILabel *lookPromptLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-35, _locationLabel.top+10, 25, 10)];
        lookPromptLabel.textAlignment = NSTextAlignmentRight;
        lookPromptLabel.textColor = [UIColor grayColor];
        [lookPromptLabel setFont:[UIFont boldSystemFontOfSize:10.f]];
        lookPromptLabel.backgroundColor = [UIColor clearColor];
        lookPromptLabel.text = ESLocalizedString(@" 在看");
        [_headInfoView addSubview:lookPromptLabel];
        
        _liveUserFaceImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _headInfoView.bottom, SCREEN_WIDTH, SCREEN_WIDTH)];
        _liveUserFaceImgView.image = [UIImage imageNamed:@"default_head"];
        [self addSubview:_liveUserFaceImgView];
        
        UIImage *liveTagImg = [UIImage imageNamed:@"image/liveroom/live_tag_live"];
        _liveStateImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-liveTagImg.size.width-10, 10, liveTagImg.size.width, liveTagImg.size.height)];
        _liveStateImgView.image = liveTagImg;
        [_liveUserFaceImgView addSubview:_liveStateImgView];
        
        // 直播标题
        _memoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _liveUserFaceImgView.bottom, SCREEN_WIDTH, 40)];
        _memoLabel.backgroundColor = [UIColor whiteColor];
        _memoLabel.textAlignment = NSTextAlignmentLeft;
        _memoLabel.textColor = [UIColor grayColor];
        [_memoLabel setFont:[UIFont boldSystemFontOfSize:14.f]];
        [self addSubview:_memoLabel];
    }
    
    return self;
}

- (void)setUserInfoDict:(NSDictionary *)userInfoDict
{
    _userInfoDict = userInfoDict;
    
    NSString *faceString = [NSString faceURLString:userInfoDict[@"face"]];
    // 下载网络图片并缓存
    [_faceImgView sd_setImageWithURL:[NSURL URLWithString:faceString] placeholderImage:[UIImage imageNamed:@"default_head"]];
    [_liveUserFaceImgView sd_setImageWithURL:[NSURL URLWithString:faceString] placeholderImage:[UIImage imageNamed:@"default_head"]];
    
    int grade = ESIntValue(userInfoDict[@"grade"]);
    if (grade > 0)
    {
        _gradeFlagImgView.image = [UIImage createUserGradeFlagImage:grade withIsManager:(userInfoDict[@"offical"] && [userInfoDict[@"offical"] intValue] == 1) ? true : false];
        _gradeFlagImgView.hidden = NO;
    }
    else
    {
        _gradeFlagImgView.hidden = YES;
    }
    
    NSString *nicknameStr = ESStringValue(userInfoDict[@"nickname"]);
    _nicknameLabel.text = nicknameStr;
    
    NSString *cityStr = ESStringValue(userInfoDict[@"city"]);
    NSMutableAttributedString *mutableAttributedString = nil; // 富文本
    if (cityStr && cityStr.length > 0)
    {
        NSString *locationInfoStr = [NSString stringWithFormat:@"d %@", userInfoDict[@"city"]];
        mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:locationInfoStr];
        
        UIImage *locationImage = [UIImage imageNamed:@"image/liveroom/live_map"];
        NSTextAttachment *locationAttachment = [[NSTextAttachment alloc] init];
        // locationAttachment.image = [UIImage imageWithImage:locationImage scaleToSize:locationImage.size];
        locationAttachment.image = locationImage;
        
        NSAttributedString *locationAttributedString = [NSAttributedString attributedStringWithAttachment:locationAttachment];
        [mutableAttributedString replaceCharactersInRange:NSMakeRange(0, 1) withAttributedString:locationAttributedString];
    }
    else
    {
        NSString *locationInfoStr = [NSString stringWithFormat:@"d 难道在火星"];
        mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:locationInfoStr];
        
        UIImage *locationImage = [UIImage imageNamed:@"image/liveroom/live_map"];
        NSTextAttachment *locationAttachment = [[NSTextAttachment alloc] init];
        // locationAttachment.image = [UIImage imageWithImage:locationImage scaleToSize:locationImage.size];
        locationAttachment.image = locationImage;
        
        NSAttributedString *locationAttributedString = [NSAttributedString attributedStringWithAttachment:locationAttachment];
        [mutableAttributedString replaceCharactersInRange:NSMakeRange(0, 1) withAttributedString:locationAttributedString];
    }
    _locationLabel.attributedText = mutableAttributedString;
    
    _onlineUserCountLabel.text = [NSString stringWithFormat:@"%d", [userInfoDict[@"total"] intValue]];
    if (ESBoolValue(userInfoDict[@"is_live"]))
    {
        _liveStateImgView.hidden = NO;
    }
    else
    {
        _liveStateImgView.hidden = YES;
    }
    
    NSString *titleStr = ESStringValue(userInfoDict[@"title"]);
    if (titleStr && titleStr.length > 0)
    {
        _memoLabel.text = [NSString stringWithFormat:@"  %@", titleStr];
        _memoLabel.hidden = NO;
    }
    else
    {
        _memoLabel.hidden = YES;
    }
}

@end
