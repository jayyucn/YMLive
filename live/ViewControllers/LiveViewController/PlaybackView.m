//
//  PlaybackView.m
//  TaoHuaLive
//
//  Created by Jay on 2017/7/13.
//  Copyright © 2017年 上海七夕. All rights reserved.
//

#import "PlaybackView.h"
#import <AVFoundation/AVFoundation.h>
#import "WXPayManager.h"
#import "QCTencentManager.h"
#import "CaptureView.h"

@interface PlaybackView ()<CaptureDelegate>
{
    UIView              *containerView;
    
    AVPlayer            *avPlayer;
    AVPlayerLayer       *avPlayerLayer;
    UIView              *_playerView;
    UILabel             *lineLb;
    
    UIView              *shareView;
    UIButton            *wxShareBtn;
    UIButton            *wxCircleShareBtn;
    UIButton            *qqShareBtn;
    UIButton            *qqZoneShareBtn;
    
//    UIButton            *_shareButton;
    UIButton            *shareCancelBtn;
    UIButton            *cancelBtn;
    
}

@property (nonatomic, strong) CaptureView *captureView;


@end

static const int padding = 16;

@implementation PlaybackView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
        
    }
    return self;
}

- (void)initialization
{
    self.backgroundColor = [UIColor clearColor];
    containerView = [[UIView alloc] initWithFrame:CGRectMake(24, 80, CGRectGetWidth(self.bounds)-48, CGRectGetHeight(self.bounds)*2/3)];
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.layer.cornerRadius = 8;
    [containerView.layer setMasksToBounds:YES];
    CGFloat width = containerView.frame.size.width;
    [self addSubview:containerView];
    containerView.hidden = YES;
//    CGFloat height = self.frame.size.height;
    //player view
    _playerView = [[UIView alloc] init];
    CGFloat playerViewSide = containerView.width - padding * 2;
    _playerView.frame = CGRectMake(padding, padding, playerViewSide, playerViewSide);
    _playerView.backgroundColor = [UIColor lightGrayColor];
    
    
    [containerView addSubview:_playerView];
    //third part sharing
    lineLb = [[UILabel alloc] initWithFrame:CGRectMake(0, _playerView.bottom+10, width, 30)];
    lineLb.backgroundColor = RGB16(COLOR_BG_LIGHTGRAY);
    lineLb.textColor = [UIColor darkGrayColor];
    lineLb.text = @"分享到";
    lineLb.textAlignment = NSTextAlignmentCenter;
    [containerView addSubview:lineLb];
    
    UIImage *wxNormalImg = [UIImage imageNamed:@"image/liveroom/room_inshare_timeline_def_weixin"];
    UIImage *wxFocusImg = [UIImage imageNamed:@"image/liveroom/room_inshare_timeline_click_weixin"];
    shareView = [[UIView alloc] initWithFrame:CGRectMake(0, lineLb.bottom+10, width, wxNormalImg.size.height)];
    [containerView addSubview:shareView];
    
    wxShareBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, wxNormalImg.size.width, wxNormalImg.size.height)];
    wxShareBtn.center = CGPointMake(20+(width-30)/8, shareView.top+25);
    [wxShareBtn setImage:wxNormalImg forState:UIControlStateNormal];
    [wxShareBtn setImage:wxFocusImg forState:UIControlStateSelected];
    [containerView addSubview:wxShareBtn];
    [wxShareBtn addTarget:self action:@selector(wxShareAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *wxCircleNormalImg = [UIImage imageNamed:@"image/liveroom/room_inshare_timeline_def_pengyouquan"];
    UIImage *wxCircleFocusImg = [UIImage imageNamed:@"image/liveroom/room_inshare_timeline_click_pengyouquan"];
    wxCircleShareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, wxNormalImg.size.width, wxNormalImg.size.height)];
    wxCircleShareBtn.center = CGPointMake(20+(width-30)*1/4 + (width-30)/8, shareView.top+25);
    [wxCircleShareBtn setImage:wxCircleNormalImg forState:UIControlStateNormal];
    [wxCircleShareBtn setImage:wxCircleFocusImg forState:UIControlStateSelected];
    [containerView addSubview:wxCircleShareBtn];
    [wxCircleShareBtn addTarget:self action:@selector(wxCircleShareAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImage *qqNormalImg = [UIImage imageNamed:@"image/liveroom/room_inshare_timeline_def_qq"];
    UIImage *qqFocusImg = [UIImage imageNamed:@"image/liveroom/room_inshare_timeline_click_qq"];
    
    qqShareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, wxNormalImg.size.width, wxNormalImg.size.height)];
    qqShareBtn.center = CGPointMake(20+(width-30)*2/4 + (width-30)/8, shareView.top+25);
    [qqShareBtn setImage:qqNormalImg forState:UIControlStateNormal];
    [qqShareBtn setImage:qqFocusImg forState:UIControlStateSelected];
    [containerView addSubview:qqShareBtn];
    [qqShareBtn addTarget:self action:@selector(qqShareAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *qqZoneNormalImg = [UIImage imageNamed:@"image/liveroom/room_inshare_timeline_def_kongjian"];
    UIImage *qqZoneFocusImg = [UIImage imageNamed:@"image/liveroom/room_inshare_timeline_click_kongjian"];
    
    qqZoneShareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, wxNormalImg.size.width, wxNormalImg.size.height)];
    qqZoneShareBtn.center = CGPointMake(20+(width-30)*3/4 + (width-30)/8, shareView.top+25);
    [qqZoneShareBtn setImage:qqZoneNormalImg forState:UIControlStateNormal];
    [qqZoneShareBtn setImage:qqZoneFocusImg forState:UIControlStateSelected];
    [containerView addSubview:qqZoneShareBtn];
    [qqZoneShareBtn addTarget:self action:@selector(qqZoneShareAction) forControlEvents:UIControlEventTouchUpInside];
    
//    //share button
//    _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_shareButton setTitle:ESLocalizedString(@"完成") forState:UIControlStateNormal];
//    [_shareButton setBackgroundColor:RGB16(COLOR_BG_BLUE)];
//    [_shareButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_shareButton];
    shareCancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *shareCancelImg = [UIImage imageNamed:@"image/liveroom/room_record_share"];
    [shareCancelBtn setImage:shareCancelImg forState:UIControlStateNormal];
    CGFloat shareCancelBtnW = shareCancelImg.size.width;
    CGFloat shareCancelBtnH = shareCancelImg.size.height;
    shareCancelBtn.frame = CGRectMake(containerView.right -shareCancelBtnW/2, containerView.bottom -shareCancelBtnW/2, shareCancelBtnW, shareCancelBtnH);
    [shareCancelBtn addTarget:self action:@selector(recordShareCancelled:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shareCancelBtn];
    shareCancelBtn.hidden = YES;
    //加载提示
    
    //录制界面
    self.captureView = [[CaptureView alloc] initWithFrame:CGRectMake(0, self.height, self.width, 140)];
    self.captureView.delegate = self;
    [self addSubview:self.captureView];
    
    [self setTapGestureRecognizerEnable:YES];
    
//    //取消按钮
//    cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIImage *cancelImg = [UIImage imageNamed:@"adClose"];
//    [cancelBtn setImage:cancelImg forState:UIControlStateNormal];
//    CGFloat cancelBtnW = cancelImg.size.width;
//    CGFloat cancelBtnH = cancelImg.size.height;
//    cancelBtn.frame = CGRectMake(self.width -cancelBtnW, self.height -cancelBtnH, cancelBtnW, cancelBtnH);
//    [cancelBtn addTarget:self action:@selector(recordDidCancel) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:cancelBtn];
    
}
#pragma mark-是否设置点击事件
- (void)setTapGestureRecognizerEnable:(BOOL)enable
{
    [self removeAllTapGestureRecognizers];
    if (enable) {
        ESWeakSelf
        [self addTapGestureHandler:^(UITapGestureRecognizer *gestureRecognizer, UIView *view, CGPoint locationInView) {
            ESStrongSelf
            if (locationInView.y < _captureView.top) {
                
                [_self recordDidCancel];
            }
        }];
    }
}

#pragma mark-准备录制
- (void)recordShouldBegin
{
    //隐藏分享页面和它的关闭按钮
    containerView.hidden = YES;
    shareCancelBtn.hidden = YES;
    self.captureView.hidden = NO;
    [self setTapGestureRecognizerEnable:YES];
    ESWeakSelf
    [UIView animateWithDuration:0.5f
                     animations:^{
                         ESStrongSelf
                         _self.captureView.bottom= _self.height;
                     }
                     completion:^(BOOL finished){
                        
                     }];
    [self.captureView recordVideoWhenBegin:^(UIButton *beginBtn) {
        ESStrongSelf
        [_self recordDidBegin];
    } end:^(UIButton *EndBtn) {
        ESStrongSelf
        [_self recordShouldEnd];
    } andCancel:^(UIButton *cancelBtn) {
        
    }];
}
#pragma mark-开始录制
- (void)recordDidBegin
{
    //1.禁止点击事件
    [self setTapGestureRecognizerEnable:NO];
    //2.传递事件给WatchCutLiveViewController:开始录制
    if (self.delegate && [self.delegate respondsToSelector:@selector(playbackViewRecordDidBegin)]) {
        [self.delegate performSelector:@selector(playbackViewRecordDidBegin)];
    }
}
#pragma mark-停止录制
- (void)recordShouldEnd
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playbackViewRecordShouldEnd)]) {
        [self.delegate performSelector:@selector(playbackViewRecordShouldEnd)];
    }
    ESWeakSelf
    [UIView animateWithDuration:0.5f animations:^{
        ESStrongSelf
        _self.captureView.top = _self.height;
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark-上传成功
- (void)recordDidEnd
{
    containerView.hidden = NO;
    shareCancelBtn.hidden = NO;
    //player view
    self.videoURL = [NSString stringWithFormat:@"%@/Documents/output.mp4", NSHomeDirectory()];
    if (self.videoURL.length > 0) {
        NSURL *urlPathOfVideo = [NSURL fileURLWithPath:self.videoURL];
        avPlayer = [AVPlayer playerWithURL:urlPathOfVideo];
        
        avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        
        avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:avPlayer];
        
        avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [_playerView.layer addSublayer:avPlayerLayer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[avPlayer currentItem]];
    }
    avPlayerLayer.frame = _playerView.bounds;
    [avPlayer play];

}
#pragma mark-取消录制
- (void)recordDidCancel
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playbackViewRecordDidCancel)]) {
        [self.delegate performSelector:@selector(playbackViewRecordDidCancel)];
    }
    containerView.hidden = YES;
    shareCancelBtn.hidden = YES;
    [self setTapGestureRecognizerEnable:YES];
}


//- (void)cancelActionWithBlock:(CancelActionBlock)cancelAction
//{
////    self.cancelActionBlock = cancelAction;
//    [self removeFromSuperview];
//}


- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}
#pragma mark- <---第三方分享
- (void)wxShareAction
{
    if (qqZoneShareBtn.isSelected) {
        qqZoneShareBtn.selected = NO;

    } else {
        qqZoneShareBtn.selected = NO;
        qqShareBtn.selected = NO;
        wxShareBtn.selected = YES;
        wxCircleShareBtn.selected = NO;
        
        [WXPayManager wxPayManager].shareType = SHARE_RECORD_VIDEO;
        [WXPayManager wxPayManager].scene = WXSceneSession;
        [[WXPayManager wxPayManager] sendLinkContent];
    }
    
}

- (void)wxCircleShareAction
{
    if (qqZoneShareBtn.isSelected) {
        qqZoneShareBtn.selected = NO;

    } else {
        qqZoneShareBtn.selected = NO;
        qqShareBtn.selected = NO;
        wxShareBtn.selected = NO;
        wxCircleShareBtn.selected = YES;
        

        [WXPayManager wxPayManager].shareType = SHARE_RECORD_VIDEO;
        [WXPayManager wxPayManager].scene = WXSceneTimeline;
        [[WXPayManager wxPayManager] sendLinkContent];
    }
    
}

- (void) qqShareAction
{
    if (qqZoneShareBtn.isSelected) {
        qqZoneShareBtn.selected = NO;

    } else {
        qqZoneShareBtn.selected = NO;
        qqShareBtn.selected = YES;
        wxShareBtn.selected = NO;
        wxCircleShareBtn.selected = NO;
        

        [QCTencentManager tencentManager].shareType = SHARE_RECORD_VIDEO;
        [[QCTencentManager tencentManager] shareWithFriend];
    }
    
}

- (void) qqZoneShareAction
{
    if (qqZoneShareBtn.isSelected) {
        qqZoneShareBtn.selected = NO;

    } else {
        qqZoneShareBtn.selected = YES;
        qqShareBtn.selected = NO;
        wxShareBtn.selected = NO;
        wxCircleShareBtn.selected = NO;
        

        [QCTencentManager tencentManager].shareType = SHARE_RECORD_VIDEO;
        [[QCTencentManager tencentManager] shareInQzone];
    }
    
}
#pragma mark-第三方分享 --->
#pragma mark-取消分享
- (void)recordShareCancelled:(UIButton *)sender
{
//    self.cancelActionBlock(sender);
    [self removeFromSuperview];
    [self recordDidCancel];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.layer.cornerRadius = 8;
    [self.layer masksToBounds];
}


@end
