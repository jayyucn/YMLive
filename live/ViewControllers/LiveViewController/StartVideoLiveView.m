//
//  StartVideoLiveView.m
//  qianchuo
//
//  Created by jacklong on 16/4/29.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "StartVideoLiveView.h"
#import "WXPayManager.h"
//#import "QCSinaManager.h"
#import "QCTencentManager.h"

#import <AVFoundation/AVFoundation.h>

#define TITLE_LENGHT 32

@interface StartVideoLiveView()<UITextFieldDelegate>
{
    
    UIButton    *closeLiveBtn;

    UILabel *promptLabel;
    
    UIView *shareView;
    UIButton *sinaShareBtn;
    UIButton *wxShareBtn;
    UIButton *wxCircleShareBtn;
    UIButton *qqShareBtn;
    UIButton *qqZoneShareBtn;
    
    UIButton  *startLiveBtn;
    
    AVCaptureSession *session;
}

@end

@implementation StartVideoLiveView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
////        bgImgView.image = [UIImage imageNamed:@"image/liveroom/room_start_live_bg"];
//        [self addSubview:bgImgView];
        
        session = [[AVCaptureSession alloc] init];
        session.sessionPreset = AVCaptureSessionPresetInputPriority;
        CALayer *viewLayer = self.layer;
        NSLog(@"self.layer = %@", viewLayer);
        AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
        captureVideoPreviewLayer.frame = self.bounds;
        [self.layer addSublayer:captureVideoPreviewLayer];
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (!input) {
            //Hnadle the error appropriately.
            NSLog(@"ERROR: trying to open camera: %@", error);
        }
        [session addInput:input];
        [session startRunning];
        
        UIImage *roomShutImage = [UIImage imageNamed:@"image/liveroom/roomshut"];
        closeLiveBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - roomShutImage.size.width -5, 25, roomShutImage.size.width, roomShutImage.size.height)];
        [closeLiveBtn setImage:roomShutImage forState:UIControlStateNormal];
        [closeLiveBtn addTarget:self action:@selector(closeStartLiveAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeLiveBtn];
        
        //直播标题
//        promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/6, SCREEN_WIDTH, 50)];
//        promptLabel.text = ESLocalizedString(@"给直播写个标题吧");
//        promptLabel.shadowColor = ColorDark;
//        promptLabel.textAlignment = NSTextAlignmentCenter;
//        promptLabel.font = [UIFont systemFontOfSize:22];
//        promptLabel.textColor = [UIColor whiteColor];
//        [self addSubview:promptLabel];
        
        UIView * contentContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 94, SCREEN_WIDTH, 45)];
        //发送框容器
        contentContainerView.backgroundColor = [UIColor clearColor];
        [self addSubview:contentContainerView];
        
        _liveTitleTextView = [[UITextField alloc] initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH-60, contentContainerView.height)];
        _liveTitleTextView.text = @"";
        _liveTitleTextView.placeholder = ESLocalizedString(@"给直播写个标题吧");
        _liveTitleTextView.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:.5];
        _liveTitleTextView.textColor = [UIColor whiteColor];
        _liveTitleTextView.delegate = self;
        _liveTitleTextView.textAlignment = NSTextAlignmentCenter;
        [_liveTitleTextView setCornerRadius:8 borderWidth:0 borderColor:0];
        _liveTitleTextView.font = [UIFont systemFontOfSize:22.f];
        [_liveTitleTextView setReturnKeyType:UIReturnKeyDefault];
        [contentContainerView addSubview:_liveTitleTextView];
        [_liveTitleTextView becomeFirstResponder];
        
        shareView = [[UIView alloc] initWithFrame:CGRectMake(50, contentContainerView.bottom+10, SCREEN_WIDTH, 40)];
        [self addSubview:shareView];
        shareView.userInteractionEnabled = YES;
        
        
//        UIImage *sinaNormalImg = [UIImage imageNamed:@"image/liveroom/b_weibo_h"];
//        UIImage *sinaFocusImg = [UIImage imageNamed:@"image/liveroom/b_weibo_n"];
//        sinaShareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, sinaNormalImg.size.width, sinaNormalImg.size.height)];
//        sinaShareBtn.center = CGPointMake(20+(SCREEN_WIDTH-40)/10, shareView.top+25);
//        [sinaShareBtn setImage:sinaNormalImg forState:UIControlStateNormal];
//        [sinaShareBtn setImage:sinaFocusImg forState:UIControlStateSelected];
//        [self addSubview:sinaShareBtn];
//        [sinaShareBtn addTarget:self action:@selector(sinaShareAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIImage *wxNormalImg = [UIImage imageNamed:@"image/liveroom/b_weixin_h"];
        UIImage *wxFocusImg = [UIImage imageNamed:@"image/liveroom/b_weixin_n"];
        wxShareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, wxNormalImg.size.width, wxNormalImg.size.height)];
        wxShareBtn.center = CGPointMake((SCREEN_WIDTH-30)/8, shareView.top+25);
        [wxShareBtn setImage:wxNormalImg forState:UIControlStateNormal];
        [wxShareBtn setImage:wxFocusImg forState:UIControlStateSelected];
        [self addSubview:wxShareBtn];
        [wxShareBtn addTarget:self action:@selector(wxShareAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *wxCircleNormalImg = [UIImage imageNamed:@"image/liveroom/b_pengyouquan_h"];
        UIImage *wxCircleFocusImg = [UIImage imageNamed:@"image/liveroom/b_pengyouquan_n"];
        wxCircleShareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, wxNormalImg.size.width, wxNormalImg.size.height)];
        wxCircleShareBtn.center = CGPointMake(20+(SCREEN_WIDTH-30)*1/4 + (SCREEN_WIDTH-30)/8, shareView.top+25);
        [wxCircleShareBtn setImage:wxCircleNormalImg forState:UIControlStateNormal];
        [wxCircleShareBtn setImage:wxCircleFocusImg forState:UIControlStateSelected];
        [self addSubview:wxCircleShareBtn];
        [wxCircleShareBtn addTarget:self action:@selector(wxCircleShareAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIImage *qqNormalImg = [UIImage imageNamed:@"image/liveroom/b_qq_h"];
        UIImage *qqFocusImg = [UIImage imageNamed:@"image/liveroom/b_qq_n"];
        
        qqShareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, wxNormalImg.size.width, wxNormalImg.size.height)];
        qqShareBtn.center = CGPointMake(20+(SCREEN_WIDTH-30)*2/4 + (SCREEN_WIDTH-30)/8, shareView.top+25);
        [qqShareBtn setImage:qqNormalImg forState:UIControlStateNormal];
        [qqShareBtn setImage:qqFocusImg forState:UIControlStateSelected];
        [self addSubview:qqShareBtn];
        [qqShareBtn addTarget:self action:@selector(qqShareAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *qqZoneNormalImg = [UIImage imageNamed:@"image/liveroom/b_kongjian_h"];
        UIImage *qqZoneFocusImg = [UIImage imageNamed:@"image/liveroom/b_kongjian_n"];
        
        qqZoneShareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, wxNormalImg.size.width, wxNormalImg.size.height)];
        qqZoneShareBtn.center = CGPointMake(20+(SCREEN_WIDTH-30)*3/4 + (SCREEN_WIDTH-30)/8, shareView.top+25);
        [qqZoneShareBtn setImage:qqZoneNormalImg forState:UIControlStateNormal];
        [qqZoneShareBtn setImage:qqZoneFocusImg forState:UIControlStateSelected];
        [self addSubview:qqZoneShareBtn];
        [qqZoneShareBtn addTarget:self action:@selector(qqZoneShareAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIImage *startLiveNormalImg = [UIImage imageNamed:@"image/liveroom/room_button"];
        UIImage *startLiveFocusImg = [UIImage imageNamed:@"image/liveroom/room_button_p"];
        
        
        CGFloat left = 30; // 左端盖宽度
        CGFloat right = 30; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(0, left, 0, right);
        // 伸缩后重新赋值
        startLiveNormalImg = [startLiveNormalImg resizableImageWithCapInsets:insets];
        // 伸缩后重新赋值
        startLiveFocusImg = [startLiveFocusImg resizableImageWithCapInsets:insets];
        
        startLiveBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, shareView.bottom+10, SCREEN_WIDTH - 40, startLiveFocusImg.size.height)];
        [startLiveBtn setBackgroundImage:startLiveNormalImg forState:UIControlStateNormal];
        [startLiveBtn setBackgroundImage:startLiveFocusImg forState:UIControlStateHighlighted];
        [startLiveBtn setTitle:ESLocalizedString(@"开始直播") forState:UIControlStateNormal];
        startLiveBtn.titleLabel.text = ESLocalizedString(@"开始直播");
        startLiveBtn.titleLabel.textColor = [UIColor whiteColor];
        startLiveBtn.titleLabel.shadowColor = ColorDark;
        [startLiveBtn addTarget:self action:@selector(startLiveAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:startLiveBtn];
        
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"开始直播默认同意《直播用户协议》";
        label.shadowColor = ColorDark;
        label.textColor = [UIColor whiteColor];
        [label sizeToFit];
        label.centerX = startLiveBtn.centerX;
        label.centerY = startLiveBtn.centerY + 50;
        [self addSubview:label];
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint locationInView) {
            [self.delegate showWebView];
        }];
        [label addGestureRecognizer:tap];
        
        // 屏蔽微博分享
        sinaShareBtn.hidden = YES;
    }
    return self;
}

- (void)showView:(UIView*)superView
{
    [superView addSubview:self];
    self.alpha=0;
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha=1;
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - 分享到第三方
- (void)sinaShareAction
{
//    if (qqZoneShareBtn.isSelected) {
//        qqZoneShareBtn.selected = NO;
//        _isSharing = NO;
//    } else {
//        qqZoneShareBtn.selected = NO;
//        qqShareBtn.selected = NO;
//        wxShareBtn.selected = NO;
//        wxCircleShareBtn.selected = NO;
//        sinaShareBtn.selected = YES;
//        
//        _isSharing = YES;
//        
//        [QCSinaManager sinaManager].shareType = SHARE_START_LIVE;
//        [[QCSinaManager sinaManager] sinaDoShare];
//    }
}

- (void)wxShareAction
{
    if (qqZoneShareBtn.isSelected) {
        qqZoneShareBtn.selected = NO;
         _isSharing = NO;
    } else {
        qqZoneShareBtn.selected = NO;
        qqShareBtn.selected = NO;
        wxShareBtn.selected = YES;
        wxCircleShareBtn.selected = NO;
        sinaShareBtn.selected = NO;
        
        _isSharing = YES;
        [WXPayManager wxPayManager].shareType = SHARE_START_LIVE;
        [WXPayManager wxPayManager].scene = WXSceneSession;
        [[WXPayManager wxPayManager] sendLinkContent];
    }
}

- (void)wxCircleShareAction
{
    if (qqZoneShareBtn.isSelected) {
        qqZoneShareBtn.selected = NO;
        _isSharing = NO;
    } else {
        qqZoneShareBtn.selected = NO;
        qqShareBtn.selected = NO;
        wxShareBtn.selected = NO;
        wxCircleShareBtn.selected = YES;
        sinaShareBtn.selected = NO;
         _isSharing = YES;
        [WXPayManager wxPayManager].shareType = SHARE_START_LIVE;
        [WXPayManager wxPayManager].scene = WXSceneTimeline;
        [[WXPayManager wxPayManager] sendLinkContent];
    }
}

- (void) qqShareAction
{
    if (qqZoneShareBtn.isSelected) {
        qqZoneShareBtn.selected = NO;
         _isSharing = NO;
    } else {
        qqZoneShareBtn.selected = NO;
        qqShareBtn.selected = YES;
        wxShareBtn.selected = NO;
        wxCircleShareBtn.selected = NO;
        sinaShareBtn.selected = NO;
         _isSharing = YES;
        [QCTencentManager tencentManager].shareType = SHARE_START_LIVE;
        [[QCTencentManager tencentManager] shareWithFriend];
    }
}

- (void) qqZoneShareAction
{
    if (qqZoneShareBtn.isSelected) {
        qqZoneShareBtn.selected = NO;
        _isSharing = NO;
    } else {
        qqZoneShareBtn.selected = YES;
        qqShareBtn.selected = NO;
        wxShareBtn.selected = NO;
        wxCircleShareBtn.selected = NO;
        sinaShareBtn.selected = NO;
        _isSharing = YES;
        [QCTencentManager tencentManager].shareType = SHARE_START_LIVE;
        [[QCTencentManager tencentManager] shareInQzone];
    }
}

-(void)closeStartLiveAction
{
    [session stopRunning];
    if (self.delegate) {
        [_liveTitleTextView resignFirstResponder];
        [self.delegate closeLiveVC];
    }
}

- (void)startLiveAction
{
    [session stopRunning];
//    if ([_liveTitleTextView.text isEqualToString:@""]) {
//        [[HUDHelper sharedInstance] tipMessage:ESLocalizedString(@"给直播写个标题吧！")];
//        return;
//    }
    if(self.delegate)
    {
        self.alpha=1;
        [UIView animateWithDuration:0.1 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            self.hidden = YES;
            [_liveTitleTextView resignFirstResponder];
            [self.delegate startLivePush:_liveTitleTextView.text];
        }];
    } 
}

//#pragma mark - 设置标题
//- (void)textViewDidChange:(UITextView *)textView
//{
//    if (textView == _liveTitleTextView) {
//        if (textView.text.length > TITLE_LENGHT) {
//            textView.text = [textView.text substringToIndex:TITLE_LENGHT];
//        }
//        promptLabel.hidden = YES;
//    }
//}
//
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string
//{
//    if (textView == _liveTitleTextView) {
//        if (textView.text.length == 0) return YES;
//        
//        NSInteger existedLength = textView.text.length;
//        NSInteger selectedLength = range.length;
//        NSInteger replaceLength = string.length;
//        if (existedLength - selectedLength + replaceLength > TITLE_LENGHT) {
//            return NO;
//        }
//    }
//    
//    return YES;
//}


@end
