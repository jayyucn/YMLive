//  主播人气周榜视图
//  HotRankItemView.m
//
//  Created by garsonge on 17/7/3.
//  Copyright © 2017年 上海七夕. All rights reserved.
//

#import "HotRankItemView.h"

@implementation HotRankItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        _titleLabelUp = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH/3, 15)];
        _titleLabelUp.textAlignment = NSTextAlignmentLeft;
        _titleLabelUp.textColor = [UIColor blackColor];
        [_titleLabelUp setFont:[UIFont systemFontOfSize:12.f]];
        _titleLabelUp.backgroundColor = [UIColor clearColor];
        _titleLabelUp.text = @"主播人气榜周榜";
        [self addSubview:_titleLabelUp];
        
        _titleLabelDown = [[UILabel alloc] initWithFrame:CGRectMake(10, _titleLabelUp.bottom + 10, SCREEN_WIDTH/3, 15)];
        _titleLabelDown.textAlignment = NSTextAlignmentLeft;
        _titleLabelDown.textColor = ColorPink;
        [_titleLabelDown setFont:[UIFont systemFontOfSize:12.f]];
        _titleLabelDown.backgroundColor = [UIColor clearColor];
        _titleLabelDown.text = @"观众最喜爱的主播排行";
        [self addSubview:_titleLabelDown];
        
        // _firstUserFaceImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-5-20-5-40-5-40-5-40, 10, 40, 40)];
        _firstUserFaceImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-5-40-5-40-5-40, 10, 40, 40)];
        _firstUserFaceImgView.image = [UIImage imageNamed:@"default_head"];
        // The radius to use when drawing rounded corners for the layer’s background
        _firstUserFaceImgView.layer.cornerRadius = _firstUserFaceImgView.frame.size.width/2; // 圆形头像
        _firstUserFaceImgView.layer.borderWidth = 2.f;
        _firstUserFaceImgView.layer.borderColor = ColorPink.CGColor;
        // subviews to be clipped to the bounds of the receiver
        _firstUserFaceImgView.clipsToBounds = YES;
        [self addSubview:_firstUserFaceImgView];
        
        // _secondUserFaceImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-5-20-5-40-5-40, 10, 40, 40)];
        _secondUserFaceImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-5-40-5-40, 10, 40, 40)];
        _secondUserFaceImgView.image = [UIImage imageNamed:@"default_head"];
        // The radius to use when drawing rounded corners for the layer’s background
        _secondUserFaceImgView.layer.cornerRadius = _secondUserFaceImgView.frame.size.width/2; // 圆形头像
        _secondUserFaceImgView.layer.borderWidth = 2.f;
        _secondUserFaceImgView.layer.borderColor = ColorPink.CGColor;
        // subviews to be clipped to the bounds of the receiver
        _secondUserFaceImgView.clipsToBounds = YES;
        [self addSubview:_secondUserFaceImgView];
        
        // _thirdUserFaceImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-5-20-5-40, 10, 40, 40)];
        _thirdUserFaceImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-5-40, 10, 40, 40)];
        _thirdUserFaceImgView.image = [UIImage imageNamed:@"default_head"];
        // The radius to use when drawing rounded corners for the layer’s background
        _thirdUserFaceImgView.layer.cornerRadius = _thirdUserFaceImgView.frame.size.width/2; // 圆形头像
        _thirdUserFaceImgView.layer.borderWidth = 2.f;
        _thirdUserFaceImgView.layer.borderColor = ColorPink.CGColor;
        // subviews to be clipped to the bounds of the receiver
        _thirdUserFaceImgView.clipsToBounds = YES;
        [self addSubview:_thirdUserFaceImgView];
        
        /*
        _loadMoreImagView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-5-20, 20, 20, 20)];
        _loadMoreImagView.image = [UIImage imageNamed:@"image/liveroom/me_go_ui"];
        [self addSubview:_loadMoreImagView];
        _loadMoreImagView.hidden = YES;
         */
        
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(singleTap)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [self addGestureRecognizer:singleRecognizer];
        
        /*
        UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(singleTap:)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        
        // 添加图片点击事件
        [_firstUserFaceImgView setUserInteractionEnabled:YES];
        [_firstUserFaceImgView addGestureRecognizer:singleRecognizer];
        
        [_secondUserFaceImgView setUserInteractionEnabled:YES];
        [_secondUserFaceImgView addGestureRecognizer:singleRecognizer];
        
        [_thirdUserFaceImgView setUserInteractionEnabled:YES];
        [_thirdUserFaceImgView addGestureRecognizer:singleRecognizer];
        
        [_loadMoreImagView setUserInteractionEnabled:YES];
        [_loadMoreImagView addGestureRecognizer:singleRecognizer];
         */
    }
    
    return self;
}

- (void)singleTap
{
    NSLog(@"JoyYouLive :: hot rank view clicked");
    
    if (_itemBlock)
    {
        _itemBlock(nil);
    }
}

// 单击事件
- (void)singleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    NSLog(@"JoyYouLive :: hot rank view clicked");
    
    UIView *viewClicked = [gestureRecognizer view];
    if (viewClicked == _loadMoreImagView)
    {
        NSLog(@"JoyYouLive :: load more users clicked");
        // 弹出排行榜
    }
    else
    {
        if (_itemBlock)
        {
            if (viewClicked == _firstUserFaceImgView)
            {
                NSLog(@"JoyYouLive :: top 1 user clicked");
                
                _itemBlock(_firstUserInfoDict);
            }
            else if (viewClicked == _secondUserFaceImgView)
            {
                NSLog(@"JoyYouLive :: top 2 user clicked");
                
                _itemBlock(_secondUserInfoDict);
            }
            else if (viewClicked == _thirdUserFaceImgView)
            {
                NSLog(@"JoyYouLive :: top 3 user clicked");
                
                _itemBlock(_thirdUserInfoDict);
            }
        }
    }
}

- (void)setFirstUserInfoDict:(NSDictionary *)firstUserInfoDict
{
    if (!firstUserInfoDict)
    {
        _firstUserFaceImgView.hidden = YES;
        NSLog(@"JoyYouLive :: top 1 user info is null");
    }
    else
    {
        _firstUserInfoDict = firstUserInfoDict;
        
        NSString *faceString = [NSString faceURLString:firstUserInfoDict[@"face"]];
        // 下载网络图片并缓存
        [_firstUserFaceImgView sd_setImageWithURL:[NSURL URLWithString:faceString] placeholderImage:[UIImage imageNamed:@"default_head"]];
    }
}

- (void)setSecondUserInfoDict:(NSDictionary *)userInfoDict
{
    if (!userInfoDict)
    {
        _secondUserFaceImgView.hidden = YES;
        NSLog(@"JoyYouLive :: top 2 user info is null");
    }
    else
    {
        _secondUserInfoDict = userInfoDict;
        
        NSString *faceString = [NSString faceURLString:userInfoDict[@"face"]];
        // 下载网络图片并缓存
        [_secondUserFaceImgView sd_setImageWithURL:[NSURL URLWithString:faceString] placeholderImage:[UIImage imageNamed:@"default_head"]];
    }
}

- (void)setThirdUserInfoDict:(NSDictionary *)userInfoDict
{
    if (!userInfoDict)
    {
        _thirdUserFaceImgView.hidden = YES;
        NSLog(@"JoyYouLive :: top 3 user info is null");
    }
    else
    {
        _thirdUserInfoDict = userInfoDict;
        
        NSString *faceString = [NSString faceURLString:userInfoDict[@"face"]];
        // 下载网络图片并缓存
        [_thirdUserFaceImgView sd_setImageWithURL:[NSURL URLWithString:faceString] placeholderImage:[UIImage imageNamed:@"default_head"]];
    }
}

@end
