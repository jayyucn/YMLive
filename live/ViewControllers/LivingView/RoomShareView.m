//
//  RoomShareView.m
//  qianchuo
//
//  Created by jacklong on 16/4/27.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "RoomShareView.h"
#import "QCShareResource.h"
#import "WXPayManager.h" 
#import "QCTencentManager.h"
//#import "QCSinaManager.h"

#define DISPLAY_AREA 200

@interface RoomShareView() {
    UIButton *wxShareBtn;
    UILabel  *wxLabel;
    UIButton *wxCircleShareBtn;
    UILabel  *wxCircleLabel;
    UIButton *qqShareBtn;
    UILabel  *qqLabel;
    UIButton *qqZoneShareBtn;
    UILabel  *qqZoneLabel;
    UIButton *sinaShareBtn;
    UILabel  *sinaLabel;
}
@end

@implementation RoomShareView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame=CGRectMake(0,0, ScreenWidth, ScreenHeight);
        
        _dispalyArea=[[UIView alloc] initWithFrame:CGRectMake(0,ScreenHeight - DISPLAY_AREA, ScreenWidth, DISPLAY_AREA)];
        _dispalyArea.backgroundColor = RGBA16(0xdfffffff);
        [self addSubview:_dispalyArea];
        _dispalyArea.userInteractionEnabled=YES;
        
        self.backgroundColor=[UIColor clearColor];
        
        UIImage *wxImageNormal = [UIImage imageNamed:@"image/liveroom/room_inshare_timeline_def_weixin"];
        UIImage *wxImageFocus = [UIImage imageNamed:@"image/liveroom/room_inshare_timeline_click_weixin"];
        wxShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        wxShareBtn.frame =  CGRectMake(0, 30, 50, 50);
        wxShareBtn.centerX = SCREEN_WIDTH/8;
        [wxShareBtn setImage:wxImageNormal forState:UIControlStateNormal];
        [wxShareBtn setImage:wxImageFocus forState:UIControlStateHighlighted];
        [_dispalyArea addSubview:wxShareBtn];
        [wxShareBtn addTarget:self action:@selector(wxShareAction) forControlEvents:UIControlEventTouchUpInside];
        
        wxLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, wxShareBtn.bottom+10, 50, 14)];
        wxLabel.text = @"微信";
        wxLabel.textAlignment = NSTextAlignmentCenter;
        wxLabel.textColor = [UIColor grayColor];
        wxLabel.font = [UIFont systemFontOfSize:14];
        wxLabel.centerX = wxShareBtn.centerX;
        [_dispalyArea addSubview:wxLabel];
        
        
        UIImage *wxCircleImageNormal = [UIImage imageNamed:@"image/liveroom/room_inshare_timeline_def_pengyouquan"];
        UIImage *wxCircelImageFocus = [UIImage imageNamed:@"image/liveroom/room_inshare_timeline_click_pengyouquan"];
    
        wxCircleShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        wxCircleShareBtn.frame =  CGRectMake(0, wxShareBtn.top, 50, 50);
        wxCircleShareBtn.centerX = SCREEN_WIDTH/8 + SCREEN_WIDTH/4;
        [wxCircleShareBtn setImage:wxCircleImageNormal forState:UIControlStateNormal];
        [wxCircleShareBtn setImage:wxCircelImageFocus forState:UIControlStateHighlighted];
        [_dispalyArea addSubview:wxCircleShareBtn];
        [wxCircleShareBtn addTarget:self action:@selector(wxCircleShareAction) forControlEvents:UIControlEventTouchUpInside];
        
        wxCircleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, wxCircleShareBtn.bottom+10, 50, 14)];
        wxCircleLabel.text = @"朋友圈";
        wxCircleLabel.textAlignment = NSTextAlignmentCenter;
        wxCircleLabel.textColor = [UIColor grayColor];
        wxCircleLabel.font = [UIFont systemFontOfSize:14];
        wxCircleLabel.centerX = wxCircleShareBtn.centerX;
        [_dispalyArea addSubview:wxCircleLabel];
        
        UIImage *qqImageNormal = [UIImage imageNamed:@"image/liveroom/room_inshare_timeline_def_qq"];
        UIImage *qqImageFocus = [UIImage imageNamed:@"image/liveroom/room_inshare_timeline_click_qq"];
        qqShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        qqShareBtn.frame =  CGRectMake(0, wxShareBtn.top, 50, 50);
        qqShareBtn.centerX = SCREEN_WIDTH/8 + SCREEN_WIDTH/2;
        [qqShareBtn setImage:qqImageNormal forState:UIControlStateNormal];
        [qqShareBtn setImage:qqImageFocus forState:UIControlStateHighlighted];
        [_dispalyArea addSubview:qqShareBtn];
        [qqShareBtn addTarget:self action:@selector(qqShareAction) forControlEvents:UIControlEventTouchUpInside];
        
        qqLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, qqShareBtn.bottom+10, 50, 14)];
        qqLabel.text = @"QQ";
        qqLabel.textAlignment = NSTextAlignmentCenter;
        qqLabel.textColor = [UIColor grayColor];
        qqLabel.font = [UIFont systemFontOfSize:14];
        qqLabel.centerX = qqShareBtn.centerX;
        [_dispalyArea addSubview:qqLabel];
        
        UIImage *qqZoneImageNormal = [UIImage imageNamed:@"image/liveroom/room_inshare_timeline_def_kongjian"];
        UIImage *qqZoneImageFocus = [UIImage imageNamed:@"image/liveroom/room_inshare_timeline_click_kongjian"];
        qqZoneShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        qqZoneShareBtn.frame =  CGRectMake(0, wxShareBtn.top, 50, 50);
        qqZoneShareBtn.centerX = SCREEN_WIDTH/8 + SCREEN_WIDTH*3/4;
        [qqZoneShareBtn setImage:qqZoneImageNormal forState:UIControlStateNormal];
        [qqZoneShareBtn setImage:qqZoneImageFocus forState:UIControlStateHighlighted];
        [_dispalyArea addSubview:qqZoneShareBtn];
        [qqZoneShareBtn addTarget:self action:@selector(qqzoneShareAction) forControlEvents:UIControlEventTouchUpInside];
        
        qqZoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, qqZoneShareBtn.bottom+10, 50, 14)];
        qqZoneLabel.text = @"QQ空间";
        qqZoneLabel.textAlignment = NSTextAlignmentCenter;
        qqZoneLabel.textColor = [UIColor grayColor];
        qqZoneLabel.font = [UIFont systemFontOfSize:14];
        qqZoneLabel.centerX = qqZoneShareBtn.centerX;
        [_dispalyArea addSubview:qqZoneLabel];
        
        
        UIImage *sinaImageNormal = [UIImage imageNamed:@"image/liveroom/room_inshare_timeline_def_weibo"];
        UIImage *sinaImageFocus = [UIImage imageNamed:@"image/liveroom/room_inshare_timeline_click_weibo"];
        sinaShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sinaShareBtn.frame =  CGRectMake(0, wxLabel.bottom + 15, 50, 50);
        sinaShareBtn.centerX = SCREEN_WIDTH/8;
        [sinaShareBtn setImage:sinaImageNormal forState:UIControlStateNormal];
        [sinaShareBtn setImage:sinaImageFocus forState:UIControlStateHighlighted];
        [_dispalyArea addSubview:sinaShareBtn];
        [sinaShareBtn addTarget:self action:@selector(sinaShareAction) forControlEvents:UIControlEventTouchUpInside];
        
        sinaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, sinaShareBtn.bottom+10, 50, 14)];
        sinaLabel.text = @"微博";
        sinaLabel.textAlignment = NSTextAlignmentCenter;
        sinaLabel.textColor = [UIColor grayColor];
        sinaLabel.font = [UIFont systemFontOfSize:14];
        sinaLabel.centerX = sinaShareBtn.centerX;
        sinaLabel.hidden = YES;
        [_dispalyArea addSubview:sinaLabel];
        
        // 屏蔽微博分享
        sinaShareBtn.hidden = YES;

    }
    return self;
}


#pragma mark - 分享
- (void) wxShareAction
{
    [WXPayManager wxPayManager].shareType = SHARE_TYPE_ROOM;
    [WXPayManager wxPayManager].scene = WXSceneSession;
    [[WXPayManager wxPayManager] sendLinkContent];
    [self hiddenShareView];
}

- (void) wxCircleShareAction
{
    [WXPayManager wxPayManager].shareType = SHARE_TYPE_ROOM;
    [WXPayManager wxPayManager].scene = WXSceneTimeline;
    [[WXPayManager wxPayManager] sendLinkContent];
    [self hiddenShareView];
}

- (void) sinaShareAction
{
//    [QCSinaManager sinaManager].shareType = SHARE_TYPE_ROOM;
//    [[QCSinaManager sinaManager] sinaDoShare];
//    [self hiddenShareView];
}

- (void) qqShareAction
{
    [QCTencentManager tencentManager].shareType = SHARE_TYPE_ROOM;
    [[QCTencentManager tencentManager] shareWithFriend];
    [self hiddenShareView];
}

- (void) qqzoneShareAction
{
    [QCTencentManager tencentManager].shareType = SHARE_TYPE_ROOM;
    [[QCTencentManager tencentManager] shareInQzone];
    [self hiddenShareView];
}

#pragma mark - 隐藏分享
- (void) hiddenShareView
{
    [UIView animateWithDuration:0.5f animations:^{
        self.top = SCREEN_HEIGHT;
        
    } completion:^(BOOL finish) {
        self.hidden = YES;
    }];
}

@end
