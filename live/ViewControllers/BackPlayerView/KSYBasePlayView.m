//
//  KSYBasePlayView.m
//  qianchuo
//
//  Created by jacklong on 16/8/8.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "KSYBasePlayView.h"

@interface KSYBasePlayView ()<UIAlertViewDelegate>

@property (nonatomic, strong)   NSTimer *timer;
@property (nonatomic, assign)   BOOL isLivePlay;
@property (nonatomic, copy)     NSString *urlString;
@property (nonatomic)           Reachability *hostReachability;
@property (nonatomic)           NetworkStatus networkStatus;
@property (nonatomic) BOOL      isShowFinishAlert;
@property (nonatomic) BOOL      isShowErrorAlert;
@property (nonatomic) BOOL      isNetShowAlert;
@property (nonatomic) BOOL      isWifiShowAlert;
@property (nonatomic, assign) BOOL isResignActive;
@property (nonatomic, assign) BOOL isError;
@property (nonatomic, assign) NSInteger curentTime;
@end

@implementation KSYBasePlayView

- (void)dealloc
{
    NSLog(@"dealloc %@",NSStringFromClass(self.class));
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self releaseObservers];
    [self unregisterApplicationObservers];
}

- (instancetype)initWithFrame:(CGRect)frame urlString:(NSString *)urlString
{
    self = [super initWithFrame:frame];
    if (self) {
        self.urlString = urlString;
        self.curentTime = 0;
        self.backgroundColor = [UIColor blackColor];
        if ([urlString hasPrefix:@"http"]) {
            self.isLivePlay = NO;
        } else if ([urlString hasPrefix:@"rtmp"]) {
            self.isLivePlay = YES;
        }
        
        [self addSubview:self.player.view];
        [self addSubview:self.indicator];
        [self bringSubviewToFront:_indicator];
        [self setupObservers];
        
        [self registerApplicationObservers];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkStateChanged:) name:@"netWorkStateChanged" object:nil];
        NSString *remoteHostName = @"phone.hainandaocheng.com";
        
        self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
        [self.hostReachability startNotifier];
        
    }
    return self;
}

- (KSYMoviePlayerController *)player
{
    if (_player == nil) {
        _player = [[KSYMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:_urlString]];
        [_player.view setFrame:self.bounds];
        _player.controlStyle = MPMovieControlStyleNone;
        self.autoresizesSubviews = TRUE;
        _player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _player.shouldAutoplay = TRUE;
        _player.scalingMode = MPMovieScalingModeAspectFit;
        [self sendSubviewToBack:_player.view];
        if (_networkStatus != ReachableViaWWAN) {
            [_player prepareToPlay];
            [self.indicator startAnimating];
        }
    }
    return _player;
}
- (UIActivityIndicatorView *)indicator
{
    if (_indicator == nil) {
        _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        _indicator.backgroundColor = [UIColor clearColor];
        _indicator.layer.cornerRadius = 6;
        _indicator.layer.masksToBounds = YES;
        [_indicator setCenter:CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0)];
        
    }
    
    return _indicator;
}

#pragma mark - 重新加载播放地址
- (void) setPlayerUrl:(NSString *)playerUrl
{
    _playerUrl = playerUrl;
    _urlString = playerUrl;
    [self replay];
}

#pragma mark- playerControl

- (void)replay
{
    [self play];
    [self moviePlayerSeekTo:0.0];
    
    if (self.progressToolBar) {
       [self.progressToolBar playerIsStop:NO];
    }
}

- (void)play
{
    if (self.player) {
        [self.player play];
        [self startTimer];
    }
    
}


- (void)pause
{
    if (self.player) {
        [self.player pause];
    }
    
}

- (void)stop
{
    if (self.player) {
        [self.player stop];
    }
    
}

- (void)shutDown
{
    
    if (_player) {
        [_player stop];
        [_player.view removeFromSuperview];
        _player = nil;
    }
    [self stopTimer];
    
}
- (NSTimeInterval)currentPlaybackTime
{
    if (self.player) {
        if (self.player.currentPlaybackTime > self.duration) { //临时解决底层currentPlaybackTime有时候返回多一秒的问题
            return self.duration;
        }
        return self.player.currentPlaybackTime;
    }
    return 0;
}

- (NSTimeInterval)duration
{
    if (self.player) {
        return self.player.duration;
    }
    return 0;
}

- (BOOL)isPlaying
{
    return [self.player isPlaying];
}
- (void)startTimer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCurrentTime) userInfo:nil repeats:YES];
        
    }
    _isShowFinishAlert = NO;
}

- (void)stopTimer
{
    if (nil == _timer) {
        return;
    }
    [_timer invalidate];
    _timer = nil;
}

- (void)updateCurrentTime
{
    NSLog(@"currentTime is %f",self.currentPlaybackTime);
    
//    NSInteger position = (NSInteger)self.currentPlaybackTime;
//    int iMin  = (int)(position / 60);
//    int iSec  = (int)(position % 60);
    if (self.progressToolBar) {
//        self.progressToolBar.curentTimeLab.text = [NSString stringWithFormat:@"%02d:%02d", iMin, iSec];
        
        [self.progressToolBar updataSliderWithPosition:self.currentPlaybackTime duration:self.duration playableDuration:self.player.playableDuration]; 
    }
}

//播放错误之后的重试播放
- (void)tautologyToPlay
{
    if (self.isLivePlay || _curentTime == 0) {
        [self addSubview:self.player.view];
        [self sendSubviewToBack:self.player.view];
        
    }else {
        [self.player prepareToPlay];
        [self moviePlayerSeekTo:_curentTime];
        [self.indicator startAnimating];
        
    }
    self.isError = NO;
}
- (void)moviePlayerSeekTo:(NSTimeInterval)position
{
    if (self.player) {
        self.player.currentPlaybackTime = position;
    }
}

#pragma mark- playerState

- (void)moviePlayerPlaybackState:(MPMoviePlaybackState)playbackState
{
    NSLog(@"player playback state: %ld", (long)playbackState);
    
}

- (void)moviePlayerLoadState:(MPMovieLoadState)loadState
{
    NSLog(@"player load state: %ld", (long)loadState);
    
    if (loadState == MPMovieLoadStateStalled) {
        [_indicator startAnimating];
        
    } else {
        [_indicator stopAnimating];
    }
}

- (void)moviePlayerReadSize:(double)readSize
{
    NSLog(@"player download flow size: %f MB", readSize);
}

- (void)moviePlayerFinishState:(MPMoviePlaybackState)finishState
{
    NSLog(@"player finish state: %ld", (long)finishState);
    if (finishState == MPMoviePlaybackStateStopped) {
        [self stopTimer];
        if (!_isShowFinishAlert) {
            UIAlertView *finishAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"播放完成，是否重新播放？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"播放", nil];
            finishAlertView.tag = 104;
            [finishAlertView show];
            _isShowFinishAlert = YES;
        }
        
        if (_progressToolBar) {
            [_progressToolBar playerIsStop:YES];
        }
    }
    
}

- (void)moviePlayerFinishReson:(MPMovieFinishReason)finishReson
{
    NSLog(@"player finish reson is %ld",(long)finishReson);
    if (finishReson == MPMovieFinishReasonPlaybackError) {
        [self.indicator stopAnimating];
        UIAlertView *finishAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"播放出错了,是否重试？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
        finishAlertView.tag = 105;
        [finishAlertView show];
        _isShowFinishAlert = YES;
        _curentTime = [self currentPlaybackTime];
        self.isError = YES;
    }
}


#pragma mark -alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101 ) {//错误提示弹框
        _isShowErrorAlert = NO;
        if (buttonIndex != alertView.cancelButtonIndex) {
            [self shutDown];
            [self addSubview:self.player.view];
            [self sendSubviewToBack:self.player.view];
            
        }else {
            [_indicator stopAnimating];
        }
        
    }else if (alertView.tag == 103 && buttonIndex != alertView.cancelButtonIndex){
        _isNetShowAlert=NO;
        if ([self.player isPreparedToPlay]) {
            [self play];
        }else {
            [self.player prepareToPlay];
        }
        
    }else if (alertView.tag == 104 && buttonIndex != alertView.cancelButtonIndex){//完成提示弹框
        _isShowFinishAlert = NO;
        [self replay];
    }else if (alertView.tag == 105 && buttonIndex != alertView.cancelButtonIndex){//错误提示弹框
        if (self.isLivePlay || self.curentTime == 0) {
            [self shutDown];
        }
        
        _isShowFinishAlert = NO;
        [self tautologyToPlay];
    }
}


#pragma mark- setNotifis
//播放器状态通知
- (void)setupObservers
{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMediaPlaybackIsPreparedToPlayDidChangeNotification)
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerPlaybackStateDidChangeNotification)
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerPlaybackDidFinishNotification)
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerLoadStateDidChangeNotification)
                                              object:nil];
}

- (void)releaseObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerPlaybackDidFinishNotification
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerLoadStateDidChangeNotification
                                                 object:nil];
}

//应用状态通知
- (void)registerApplicationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
}

- (void)unregisterApplicationObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillResignActiveNotification
                                                  object:nil];
}


#pragma mark- notifyControl

-(void)handlePlayerNotify:(NSNotification*)notify
{
    
    if (!_player) {
        return;
    }
    if (MPMediaPlaybackIsPreparedToPlayDidChangeNotification ==  notify.name) {
        [self.indicator stopAnimating];
        [self startTimer];
    }
    if (MPMoviePlayerPlaybackStateDidChangeNotification ==  notify.name) {
        
        [self moviePlayerPlaybackState:self.player.playbackState];
    }
    if (MPMoviePlayerLoadStateDidChangeNotification ==  notify.name) {
        
        [self moviePlayerLoadState:self.player.loadState];
        
    }
    if (MPMoviePlayerPlaybackDidFinishNotification ==  notify.name) {
        
        [self moviePlayerFinishState:self.player.playbackState];
        
        NSNumber *reason = [[notify userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
        [self moviePlayerFinishReson:[reason integerValue]];
    }
}

- (void)netWorkStateChanged:(NSNotification *)note
{
    NSString *stateString = [note object];
    
    [self updateInterfaceWithReachability:[stateString integerValue]];
}

- (void)updateInterfaceWithReachability:(NSInteger)netState
{
    switch (netState)
    {
        case NotReachable:
        {
            if (_networkStatus == NotReachable && _isNetShowAlert == NO) {
                UIAlertView *networkAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"网络似乎已经断开，请检查网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"我知道了", nil];
                networkAlertView.tag = 102;
                [networkAlertView show];
                _isNetShowAlert = YES;
                
            }
            _networkStatus = NotReachable;
            break;
        }
            
        case ReachableViaWiFi:
        {
            if (_networkStatus == ReachableViaWiFi) {
                [self play];
            }
            _networkStatus = ReachableViaWiFi;
            
            NSLog(@"wifi");
            
            break;
        }
        case ReachableViaWWAN:
        {
            if (_networkStatus == ReachableViaWWAN && _isWifiShowAlert == NO) {
                
                if ([self.player isPreparedToPlay]) {
                    [self pause];
                    
                }
                UIAlertView *wifiAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"wifi已经断开，继续播放将产生流量费用，是否继续？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
                wifiAlertView.tag = 103;
                [wifiAlertView show];
                _isWifiShowAlert = YES;
                
            }
            _networkStatus = ReachableViaWWAN;
            
            NSLog(@"3G");
            
            break;
        }
        default:
            break;
    }
}

- (void)applicationDidBecomeActive
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.isLivePlay || self.isBackGroundReleasePlayer) {
            [self addSubview:self.player.view];
            [self sendSubviewToBack:self.player.view];
            
        }else if (self.isResignActive){
            if (!self.isError) {
                [self play];
            }
            self.isResignActive = NO;
        }
    });
}

- (void)applicationWillResignActive
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (([self.player isPlaying] && self.isBackGroundReleasePlayer ) || self.isLivePlay) {
            [self shutDown];
        }else if ( !self.isLivePlay && [self.player isPlaying]){
            [self pause];
            self.isResignActive = YES;
        }else if (![self.player isPlaying] && !self.isLivePlay){
            self.isResignActive = NO;
            
        };
    });
}


@end
