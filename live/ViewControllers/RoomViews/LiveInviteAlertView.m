//
//  LiveInviteAlertView.m
//  live
//
//  Created by AlexiChen on 15/10/21.
//  Copyright © 2015年 kenneth. All rights reserved.
//

#import "LiveInviteAlertView.h"

@interface LiveInviteAlertView ()

@property (nonatomic, strong) LiveUser *userInfo;

@end

@implementation LiveInviteAlertView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib
{
//    self.backgroundColor = [UIColor whiteColor];
//    self.clipsToBounds = YES;
    _container.layer.cornerRadius = 10;
    
    UIColor *clearColor = [UIColor clearColor];
    
    _headIcon.backgroundColor = clearColor;
    _headIcon.layer.cornerRadius = _headIcon.bounds.size.width/2;
    _headIcon.layer.masksToBounds = YES;
    
    _nickName.backgroundColor = clearColor;
    _nickName.textColor = [UIColor darkGrayColor];
    
    _interactButton.backgroundColor = clearColor;
    _interactButton.layer.cornerRadius = _interactButton.bounds.size.height/2;
    _interactButton.layer.borderColor = [UIColor redColor].CGColor;
    _interactButton.layer.borderWidth = 1;
    
    _actionsView.backgroundColor = clearColor;
    _speaker.backgroundColor = clearColor;
    
//    [_speaker setImage:[UIImage imageNamed:@"invite_voice_gray"] forState:UIControlStateSelected];
//    [_camera setImage:[UIImage imageNamed:@"invite_camera_gray"] forState:UIControlStateSelected];
    
    _camera.backgroundColor = clearColor;
    _switchWindow.backgroundColor = clearColor;
    _hangUp.backgroundColor = clearColor;
    
    _statusTip.backgroundColor = clearColor;
    _statusTip.textColor = [UIColor grayColor];
    
    _closeButton.backgroundColor = clearColor;
    _closeButton.layer.cornerRadius = _closeButton.bounds.size.width/2;
    _closeButton.layer.borderColor = [UIColor whiteColor].CGColor;;
    _closeButton.layer.borderWidth = 2;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserLeave:) name:@"UserLeaveNotification" object:nil];
}

- (void)onUserLeave:(NSNotification *)notify
{
    NSString *userId = [notify.object description];
    if ([self.userInfo.userId isEqualToString:userId])
    {
        [self onClose:nil];
    }
}

- (instancetype)initInviteView:(LiveUser *)dic normale:(BOOL)normal
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"LiveInviteAlertView" owner:self options:nil] lastObject];
    
    if (self)
    {
        _interactButton.hidden = NO;
        _interactButton.selected = normal;
        
        if (normal)
        {
            [_interactButton setTitle:@"与TA进行互动" forState:UIControlStateNormal];
            [_interactButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        else
        {
            [_interactButton setTitle:@"关闭与TA的互动" forState:UIControlStateNormal];
            [_interactButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            
        }
        
        
        _actionsView.hidden = YES;
        self.userInfo = dic;
        [self configOwnViews];
    }
    
    
    return self;
        
}

- (void)disableInteract
{
    _interactButton.enabled = NO;
    [_interactButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _interactButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
}


//{
//    userLogo = "18681537580/head-1442307053.jpg";
//    userName = alexi;
//    userPhone = 18681537580;
//}

- (void)configOwnViews
{
    _nickName.text = _userInfo.userName;
    
//    NSInteger width = _headIcon.frame.size.width;
    NSString *logo = _userInfo.userLogo;

    if(!logo)
    {
        _headIcon.image = [UIImage imageNamed:@"default_head"];
    }
    else
    {
        [_headIcon sd_setImageWithURL:[NSURL URLWithString:[NSString faceURLString:logo]] placeholderImage:[UIImage imageWithColor:RGB16(COLOR_FONT_WHITE) andSize:_headIcon.frame.size]];
    }
}

- (void)show
{
    CGRect rect = [UIScreen mainScreen].bounds;
    _alertWindow = [[UIWindow alloc] initWithFrame:rect];
    _alertWindow.windowLevel = UIWindowLevelAlert;
    
    
    _backgroundView = [[UIView alloc] init];
    _backgroundView.frame = _alertWindow.bounds;
    _backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [_backgroundView addSubview:self];
    
    [_alertWindow addSubview:_backgroundView];
    [_alertWindow makeKeyAndVisible];
//    [_alertWindow resignKeyWindow];
    
    self.alpha = 0;
    self.center = _backgroundView.center;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
}

- (instancetype)initAtionView:(LiveUser *)dic
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"LiveInviteAlertView" owner:self options:nil] lastObject];
    
    if (self)
    {
        _interactButton.hidden = YES;
        _actionsView.hidden = NO;
        self.userInfo = dic;
//        [self show];
        
//        _speaker.selected = _userInfo.hasAudio;
//        _camera.selected = _userInfo.hasVideo;
        
        _statusTip.text = @"互动直接中...";
        [self configOwnViews];
    }
    return self;
}

- (void)showSelfAction
{
    [_speaker removeFromSuperview];
    _speaker = nil;
    

    [_camera removeFromSuperview];
    _camera = nil;
    

    [_hangUp removeFromSuperview];
    _hangUp = nil;
    
    
    [_actionsView addConstraint:[NSLayoutConstraint constraintWithItem:_switchWindow attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_actionsView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [_actionsView addConstraint:[NSLayoutConstraint constraintWithItem:_switchWindow attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_actionsView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [_switchWindow addTarget:self action:@selector(onClickSwitchWindow:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (IBAction)onClickInvite:(UIButton *)sender
{
    // TODO: 检查是否可以继续邀请
    if ([_delegate respondsToSelector:@selector(onInviteView:invite:inviteOrClose:)])
    {
        [_delegate onInviteView:self invite:self.userInfo inviteOrClose:sender.selected];
        
        [self onClose:nil];
    }
}

- (void)close:(BOOL)fromOuter
{
    [self onClose:nil];
}

- (IBAction)onClose:(UIButton *)sender
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [_backgroundView removeFromSuperview];
        [[AppDelegate sharedAppDelegate] makeSelfVisible];
        _alertWindow = nil;
    }];

}
- (IBAction)onClickSpeaker:(UIButton *)sender
{
    // TODO: 检查是否可以继续邀请
    if ([_delegate respondsToSelector:@selector(onInviteView:user:enableMic:)])
    {
        _userInfo.hasAudio = !_userInfo.hasAudio;
        [_delegate onInviteView:self user:_userInfo enableMic:!sender.selected];
        
        [self onClose:nil];
    }
}

- (IBAction)onClickCamera:(UIButton *)sender {
    // TODO: 检查是否可以继续邀请
    if ([_delegate respondsToSelector:@selector(onInviteView:user:enableCamera:)])
    {
        _userInfo.hasVideo = !_userInfo.hasVideo;
        [_delegate onInviteView:self user:_userInfo enableCamera:!sender.selected];
        
        [self onClose:nil];
    }
}


- (IBAction)onClickSwitchWindow:(UIButton *)sender {
    // TODO: 检查是否可以继续邀请
    if ([_delegate respondsToSelector:@selector(onInviteView:switchUserToMain:)])
    {
        [_delegate onInviteView:self switchUserToMain:_userInfo];
        
        [self onClose:nil];
    }
}


- (IBAction)onClickHangUp:(UIButton *)sender {
    // TODO: 检查是否可以继续邀请
    if ([_delegate respondsToSelector:@selector(onInviteView:hangupUser:)])
    {
        [_delegate onInviteView:self hangupUser:self.userInfo];
        
        [self onClose:nil];
    }
}




@end
