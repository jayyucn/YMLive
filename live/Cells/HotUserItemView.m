//  热门直播视图
//  HotUserItemView.m
//  qianchuo
//
//  Created by jacklong on 16/4/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "HotUserItemView.h"

#define CellAutoresizingMask UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin

@implementation HotUserItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _headInfoView = [[UIView alloc] initWithFrame:CGRectMake(cIntervalPixel, cIntervalPixel, cCell_Items_Width, 30)];
        _headInfoView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_headInfoView];
        
        // 注意，此位置是相对于_headInfoView，所以只需要考虑在单个cell内的布局
        UIImage *gradeFlagImg = [UIImage imageNamed:@"image/yonghu/grade_flag/grade_flag_1"];
        _gradeFlagImgView = [[UIImageView alloc] initWithFrame:CGRectMake(cIntervalPixel+2, cIntervalPixel+5, gradeFlagImg.size.width/1.5, gradeFlagImg.size.height/1.5)];
        // NSLog(@"JoyYouLive-gradeFlagImgView :: i = %d, x = %f, y = %f", i, _gradeFlagImgView.left, _gradeFlagImgView.top);
        _gradeFlagImgView.image = gradeFlagImg;
        [_headInfoView addSubview:_gradeFlagImgView];
        
        _nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_gradeFlagImgView.left+2, _gradeFlagImgView.top, SCREEN_WIDTH/cNum-cIntervalPixel-2-gradeFlagImg.size.width/1.5-40-20, 15)];
        // NSLog(@"JoyYouLive-nicknameLabel :: i = %d, x = %f, y = %f", i, _nicknameLabel.left, _nicknameLabel.top);
        _nicknameLabel.textAlignment = NSTextAlignmentLeft;
        _nicknameLabel.textColor = [UIColor blackColor];
        [_nicknameLabel setFont:[UIFont systemFontOfSize:12.f]];
        _nicknameLabel.backgroundColor = [UIColor clearColor];
        // _nicknameLabel.text = @"TEST_NAME";
        [_headInfoView addSubview:_nicknameLabel];
        
        _onlineUserCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nicknameLabel.right, _nicknameLabel.top, 40, 15)];
        // NSLog(@"JoyYouLive-onlineUserCountLabel :: i = %d, x = %f, y = %f", i, _onlineUserCountLabel.left, _onlineUserCountLabel.top);
        _onlineUserCountLabel.textAlignment = NSTextAlignmentRight;
        _onlineUserCountLabel.textColor = ColorPink;
        [_onlineUserCountLabel setFont:[UIFont systemFontOfSize:8.f]];
        _onlineUserCountLabel.backgroundColor = [UIColor clearColor];
        // _onlineUserCountLabel.text = @"1000";
        [_headInfoView addSubview:_onlineUserCountLabel];
        
        UILabel *lookPromptLabel = [[UILabel alloc] initWithFrame:CGRectMake(_onlineUserCountLabel.right, _nicknameLabel.top, 20, 15)];
        // NSLog(@"JoyYouLive-lookPromptLabel :: i = %d, x = %f, y = %f", i, lookPromptLabel.left, lookPromptLabel.top);
        lookPromptLabel.textAlignment = NSTextAlignmentRight;
        lookPromptLabel.textColor = [UIColor grayColor];
        [lookPromptLabel setFont:[UIFont boldSystemFontOfSize:8.f]];
        lookPromptLabel.backgroundColor = [UIColor clearColor];
        lookPromptLabel.text = ESLocalizedString(@" 在看");
        [_headInfoView addSubview:lookPromptLabel];
        
        _liveUserFaceImgView = [[UIImageView alloc] initWithFrame:CGRectMake(cIntervalPixel, _headInfoView.bottom, cCell_Items_Width, cCell_Items_Height)];
        _liveUserFaceImgView.image = [UIImage imageNamed:@"default_head"];
        [self addSubview:_liveUserFaceImgView];
        
        UIImage *liveTagImg = [UIImage imageNamed:@"image/liveroom/live_tag_live"];
        _liveStateImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/cNum-liveTagImg.size.width/1.5-5-cIntervalPixel, cCell_Items_Height*0.02, liveTagImg.size.width/1.5, liveTagImg.size.height/1.5)];
        _liveStateImgView.image = liveTagImg;
        [_liveUserFaceImgView addSubview:_liveStateImgView];
        
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(_liveUserFaceImgView.left, cCell_Items_Height*0.9, SCREEN_WIDTH/(cNum*2), 10)];
        _locationLabel.right = _liveStateImgView.right;
        // NSLog(@"JoyYouLive-locationLabel :: i = %d, x = %f, y = %f", i, _locationLabel.left, _locationLabel.top);
        _locationLabel.textAlignment = NSTextAlignmentRight;
        _locationLabel.textColor = [UIColor grayColor];
        [_locationLabel setFont:[UIFont boldSystemFontOfSize:8.f]];
        _locationLabel.backgroundColor = [UIColor clearColor];
        // _locationLabel.text = @"TEST_LOCATION";
        [_liveUserFaceImgView addSubview:_locationLabel];
        
        /*
        // 直播标题（主播设置）
        _memoLabel = [[UILabel alloc] initWithFrame:CGRectMake(cIntervalPixel, _liveUserFaceImgView.bottom, cCell_Items_Width, 30)];
        _memoLabel.backgroundColor = [UIColor whiteColor];
        _memoLabel.textAlignment = NSTextAlignmentLeft;
        _memoLabel.textColor = [UIColor grayColor];
        // _memoLabel.text = @"  TEST_TITLE";
        [_memoLabel setFont:[UIFont boldSystemFontOfSize:10.f]];
        [self addSubview:_memoLabel];
         */
        
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(singleTap)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [self addGestureRecognizer:singleRecognizer];
    }
    
    return self;
}

// 单击事件
- (void)singleTap
{
    if (_itemBlock)
    {
        _itemBlock(_userInfoDict);
    }
}

- (void)setUserInfoDict:(NSDictionary *)userInfoDict
{
    _userInfoDict = userInfoDict;
    
    NSString *faceString = [NSString faceURLString:userInfoDict[@"face"]];
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
    
    /*
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
     */
}

@end
