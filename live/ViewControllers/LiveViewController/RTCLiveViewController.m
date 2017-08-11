//
//  RTCLiveViewController.m
//  qianchuo 上麦
//
//  Created by jacklong on 16/9/29.
//  Copyright © 2016年 jacklong. All rights reserved.
//

#import "RTCLiveViewController.h"
#import "DriveManager.h"
#import "ChatUtil.h"
#import "LivingView.h"
#import "ChatConversationsListViewController.h"
#import "LiveAlertView.h"
#import "FinishLiveView.h"
#import "TopsRankControlView.h"
#import "LuxuryManager.h"
#import "IMBridge.h"
 
#import "UserSpaceViewController.h"
#import "ManagerListViewController.h"
#import "RechargeViewController.h"
#import "Reachability.h"
#import "RedPacketManager.h"
#import "StartVideoLiveView.h"
#import "CameraPopView.h"
#import "IPAddressUtil.h"
#import <MBProgressHUD.h>
#import "GroupMsgCell.h"
#import "ParseContentCommon.h"
#import "LiveChatDetailViewController.h"
#import "LiveChatListViewController.h"
#import "WatchCutLiveViewController.h"
#import "ShowWebViewController.h"

#import <libksyrtclivedy/KSYRTCAecModule.h>
#import <libksyrtclivedy/KSYRTCClient.h>
#import <libksygpulive/libksygpulive.h>
#import <libksygpulive/libksygpuimage.h>
#import <libksygpulive/KSYGPUStreamerKit.h>
#import "KSYRTCStreamerKit.h"

#define HIDEN_DISTANCE  50
#define SHOW_DISTANCE   20

#define HEART_TIME      18
#define STOP_CONNECT_VIDEO_TIME HEART_TIME*1000

#define LIVE_PLAY_FINISH 6 // 主播非正常退出时间

#define LIVE_RECONNECT_COUNT 3 // 直播重联次数

/// 一秒处理5条消息。
#define kSendingMessageMinInterval (0.220)

enum NETWORK_STATUS {
    NETWORK_CONN = 0,
    NETWORK_FAIL,
    NETWORK_DISCONN
};

@interface RTCLiveViewController ()<LivingViewDelegate,FinishLiveViewDelegate,CameraPopViewDelegate,UIGestureRecognizerDelegate>
{
    //    BOOL isStartPushOkState;
    //    BOOL isShowStartLiveDetail;
    BOOL isStopCall;
    BOOL isSendCall;
    BOOL isCancelUpMike;
    BOOL isLoveEnd;
    BOOL isCountDownStopAnimation;
    BOOL isFirstLoad;
    BOOL isCreateRoom;
    BOOL isExitRoom;
    BOOL isLivingShowState;
    BOOL isFinishView;
    BOOL isHostLeaveRoom;
    BOOL connectLiveTimeOut;// 链接超时
    
    int roomAudienceCount;// 看过的人数
    int roomRecMoneyCount;// 收到钻石
    int roomPraiseCount;  // 点亮
    
    int liveTimeCount;    // 直播时间统计
    
    int livePushBreakCount;// 推流断开的统计（设置金山自身重联时间）
    int liveReconnectCount;// 视频流重联次数（自身重联）
    
    NSTimeInterval oldTime;    // 直播退到后天时间
    
    NSTimer* liveCountTimer;   //  直播计时
    
    // 推流地址 完整的URL
    NSURL *_hostURL;
    NSString *vdoidStr;
    
    KSYStreamerBase     *streamBase;
    LivingView          *_livingView;
    UIButton            *_closeBtn;
    KSYRTCStreamerKit   *_kit;
    // set this filter to kit
    GPUImageFilter      *_filter;
    
    UIImageView         *_faceFloatImgView;
    UIVisualEffectView  *_effectview;// 模糊效果
    UIImageView         *_countDownImg;
    
    // 播放直播
    KSYMoviePlayerController *_player;
    
    // 直播开始页面
    StartVideoLiveView *startLiveView;
    
    UILabel *_statLabel;
    
    NSTimer *startPlayTimer;
    NSTimer *liveHeartTimer;// 推流心跳
    NSTimeInterval lastCheckTime;
    
    
    NSTimer *liveDataTimer;// 数据流监听计时器
    
    NSTimer *livePlayerTimer;// 播放计时器
    NSString* serverIp;// 播放端ip
    double lastSize;
    
    // status monitor
    double    _lastSecond;
    int       _lastByte;
    int       _lastFrames;
    int       _lastDroppedF;
    int       _netEventCnt;
    
    NSString *_netEventRaiseDrop;
    int       _netTimeOut;
    int       _raiseCnt;
    int       _dropCnt;
    double    _startTime;
    
    // time
    uint64_t startTime;
    NSString* ipURL;
    
    dispatch_queue_t __gSendingMessagesQueue;
    UserSpaceViewController *spaceViewController;
    
    UINavigationController *chatNavigationController;
}


//@property (nonatomic, strong) UILabel *statLabel;

@property (nonatomic, strong) NSMutableArray *pendingMessages;
@property (nonatomic) uint64_t lastSendingTime;
@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) Reachability  *reachablity;
@property (nonatomic , strong) MBProgressHUD* hubView;

@end

@implementation RTCLiveViewController

- (void)dealloc
{
    NSLog(@"mylive dealloc");
    
    [self.view removeFromSuperview];
    //停止监听
    [self.reachablity stopNotifier];
}

- (id) init
{
    if(self=[super init])
    {
        [self setHidesBottomBarWhenPushed:YES];
        
        __gSendingMessagesQueue = dispatch_queue_create("com.qianchuo.rtclive.ShowMessagesQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isFirstLoad = YES;
    isLivingShowState = YES;
    isCountDownStopAnimation = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSLog(@"livetype:%d",(int)[LCMyUser mine].liveType);
    
    [self initView];
    
    self.pendingMessages = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveGroupMsg:) name:IMBridgeDidReceiveRoomMessageNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCountOfTotalUnreadMessages:) name:IMBridgeCountOfTotalUnreadMessagesDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LCUserLiveRecDiamondDidChangeNotification:) name:LCUserLiveRecDiamondDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    
    // 主播取消邀请
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelInviteUpMike:) name:kUserCancelInviteUpMike object:nil];
    
    // 暂停直播
    [[NSNotificationCenter defaultCenter] postNotificationName:HuoWuLive_PAUSE_NOTIFION object:nil];
    
    // 暂停回放
    [[NSNotificationCenter defaultCenter] postNotificationName:AUCALLBACKPLAY_PAUSE_NOTIFITION object:nil];
    
    // 分享成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareSuccToSend:) name:kUserShareSuccMsg object:nil];
    
    //添加网络监控
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    //获取Reachability对象
    self.reachablity = [Reachability reachabilityForInternetConnection];
    //开始监控网络
    [self.reachablity startNotifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.navigationController.isNavigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    
    if (_livingView.allShowGiftView) {
        [_livingView.allShowGiftView startSendGiftViewAnimation];
    }
    
    if (_livingView) {
        [_livingView.giftView.giftScrollView selectTag:0];
    }
    
    if (startLiveView && !startLiveView.isHidden && startLiveView.isSharing) {
        [startLiveView startLiveAction];
    }
    
    int totalUnread = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
    [self updateUnReadCount:totalUnread];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_countDownImg && !_countDownImg.hidden) {
        [_countDownImg removeFromSuperview];
        _countDownImg.hidden = YES;
        
        [self showLiveFloatView];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - 开始直播
- (void)initView
{
    // 初始化
    [LCMyUser mine].liveRecDiamond = 0;
    [LCMyUser mine].liveOnlineUserCount = 0;
    [[LCMyUser mine] removeAllGagUser];
    
    // 初始化显示红包状态
    [RobRedPacketViewController isCloseRedPacket];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    //直播视图
    _livingView = [[[NSBundle mainBundle] loadNibNamed:@"LivingView" owner:self options:nil] lastObject];
    _livingView.frame = self.view.bounds;
    _livingView.delegate = self;
    _livingView.hidden = YES;
    [self.view addSubview:_livingView];
    
    UIImage *roomShutImage = [UIImage imageNamed:@"image/liveroom/roomshut"];
    
    float viewSize = roomShutImage.size.width;
    _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH- viewSize - 10,SCREEN_HEIGHT - viewSize - 10, viewSize, viewSize)];
    _closeBtn.backgroundColor = [UIColor clearColor];
    [_closeBtn setImage:roomShutImage forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(stopCallAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeBtn];
    
    
    UIPanGestureRecognizer *guestureR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    guestureR.delegate = self;
    [self.view addGestureRecognizer:guestureR];
    
    [self startLivePush];
}



#pragma mark - 打印播放视频流日志
- (void) showPlayerStatLabel
{
    if (!_statLabel) {
        _statLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, SCREEN_WIDTH - 10,250)];
        _statLabel.backgroundColor = [UIColor clearColor];
        _statLabel.textColor = [UIColor whiteColor];
        _statLabel.font = [UIFont systemFontOfSize:11];
        _statLabel.numberOfLines = -1;
        _statLabel.shadowColor = [UIColor blackColor];
        _statLabel.shadowOffset = CGSizeMake(0, -1.0);
        _statLabel.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:_statLabel];
        _statLabel.hidden = YES;
    }
}

- (void)StartPlayerStatTimer
{
#ifdef DEBUG
    livePlayerTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updatePlayerStat:) userInfo:nil repeats:YES];
#endif
}

- (void)StopPlayerStatTimer
{
    if (!livePlayerTimer) {
        return;
    }
    
    [livePlayerTimer invalidate];
    livePlayerTimer = nil;
}

- (void)updatePlayerStat:(NSTimer *)t
{
    if ( 0 == lastCheckTime) {
        lastCheckTime = [self getCurrentTime];
        return;
    }
    if (nil == _player) {
        return;
    }
    
    if (_statLabel) {
        _statLabel.hidden = NO;
    }
    
    double flowSize = [_player readSize];
    
    _statLabel.text = [NSString stringWithFormat:@"%@\nip:%@ (w-h: %.0f-%.0f)\nplay time:%.1fs - %.1fs - %.1fs\ncached time:%.1fs/%d - %.1fs\nspeed: %0.1f kbps",
                       _hostURL,
                       serverIp, _player.naturalSize.width, _player.naturalSize.height,
                       _player.currentPlaybackTime, _player.playableDuration, _player.duration,
                       _player.bufferEmptyDuration, (int)_player.bufferEmptyCount, _player.bufferTimeMax,
                       8*1024.0*(flowSize - lastSize)/([self getCurrentTime] - lastCheckTime)];
    lastCheckTime = [self getCurrentTime];
    lastSize = flowSize;
}

- (NSTimeInterval) getCurrentTime{
    return [[NSDate date] timeIntervalSince1970];
}


#pragma mark - 关闭开始直播界面
- (void)closeLiveVC
{
}

#pragma mark - 倒计时动画
- (void) showCountDownAnimation:(int)countDown
{
    isCountDownStopAnimation = NO;
    _countDownImg.hidden = NO;
    UIImage *countDownImage = [UIImage imageNamed:[NSString stringWithFormat:@"image/liveroom/room_start_%d",countDown]];
    _countDownImg.image = countDownImage;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(8, 8, 20)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(5, 5, 15)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(3, 3, 10)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(2, 2, 8)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(.3, .3, 5)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 2)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 2)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 2)]];
    animation.duration = .8;
    animation.removedOnCompletion = YES;
    animation.delegate = self;
    [animation setValue:[NSString stringWithFormat:@"second%d",countDown] forKey:@"animationName"];
    
    [_countDownImg removeFromSuperview];
    [_countDownImg.layer addAnimation:animation forKey:[NSString stringWithFormat:@"second%d",countDown]];
    [self.view addSubview:_countDownImg];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag)
    {
        NSString *animationName = [anim valueForKey:@"animationName"];
        if ([animationName isEqualToString:@"second3"])
        {
            [self showCountDownAnimation:2];
        }  else if ([animationName isEqualToString:@"second2"]) {
            [self showCountDownAnimation:1];
        } else  if ([animationName isEqualToString:@"second1"]){
            _countDownImg.hidden = YES;
            [_countDownImg removeFromSuperview];
            isCountDownStopAnimation = YES;
            
            [self showLiveFloatView];
        }
    }
}


- (void)sendMessage:(LivingView*)livingView
{
    if ([LCMyUser mine].isGag && ![LCMyUser mine].showManager) {// 用户已经被禁言
        return;
    }
    NSString* message = _livingView.contentTextField.text;
    if (![LCMyUser mine].showManager) {
        message = [[ChatUtil shareInstance] getFilterStringWithSrc:message];
    }
    
    NSLog(@"send message:%@",message);
    [self sendMsg:message];
}

- (void)toggleCamera:(LivingView*)livingView
{
    [[CameraPopView cameraPopView] initPopViewData];
    [CameraPopView cameraPopView].delegate = self;
    [[CameraPopView cameraPopView] showPopoverWithView:self.view withTargetView:_closeBtn];
}

#pragma mark - 直播控制
// 开关闪光灯
- (void)onShanLightController:(int)state
{
    [_kit toggleTorch];
    NSArray *configs = nil;
    if (state == 1) {// 关
        configs = @[@{@"title":ESLocalizedString(@"开闪光"),@"icon":@"image/liveroom/room_pop_up_lamp",@"state":@"0"},
                    @{@"title":ESLocalizedString(@"翻转"),@"icon":@"image/liveroom/room_pop_up_camera",@"state":@"1"}, ];
    } else {// 开
        configs = @[@{@"title":ESLocalizedString(@"关闪光"),@"icon":@"image/liveroom/room_pop_up_lamp_p",@"state":@"1"},
                    @{@"title":ESLocalizedString(@"翻转"),@"icon":@"image/liveroom/room_pop_up_camera",@"state":@"1"}, ];
    }
    [[CameraPopView cameraPopView] setPopViewData:configs];
}

// 翻转控制
- (void)onCameraController:(int)state
{
    if ( [_kit switchCamera ] == NO) {
        [LCNoticeAlertView showMsg:ESLocalizedString(@"切换失败 当前采集参数 目标设备无法支持")];
        return;
    }
    BOOL backCam = (_kit.cameraPosition == AVCaptureDevicePositionBack);
    backCam = backCam && (_kit.captureState == KSYCaptureStateCapturing);
    
    NSArray *configs = nil;
    if (backCam) {// 后置
        configs  = @[@{@"title":ESLocalizedString(@"开闪光"),@"icon":@"image/liveroom/room_pop_up_lamp",@"state":@"0"},
                     @{@"title":ESLocalizedString(@"翻转"),@"icon":@"image/liveroom/room_pop_up_camera",@"state":@"1"}, ];
    } else {// 前置
        configs = @[@{@"title":ESLocalizedString(@"开闪光"),@"icon":@"image/liveroom/room_pop_up_lamp",@"state":@"0"},
                    @{@"title":ESLocalizedString(@"翻转"),@"icon":@"image/liveroom/room_pop_up_camera_p",@"state":@"0"},];
    }
    
    [[CameraPopView cameraPopView] setPopViewData:configs];
}

// 美颜控制
- (void)onBeautyController:(int)state
{
    
}

- (void)openMike:(LivingView*)livingView
{
    
}

#pragma mark  拖动事件
- (void) handleSwipe:(UIPanGestureRecognizer*) recognizer
{
    if (_livingView.hidden || [LCMyUser mine].liveType == LIVE_DOING || !_livingView.giftView.isHidden) {
        return;
    }
    
    CGPoint translation = [recognizer translationInView:_livingView];
    //    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,);
    //    NSLog(@"trans before x:%f %f %f",[_livingView convertPoint:translation fromView:recognizer.view].x, translation.x,recognizer.view.left);
    //    NSLog(@"trans before toview:x:%f %f %f",[_livingView convertPoint:translation toView:recognizer.view].x, translation.x,recognizer.view.left);
    
    if (isLivingShowState) {// 显示
        if (translation.x < 0) {
            return;
        }
        
        // 隐藏分享
        [_livingView hiddenShareView];
        if (UIGestureRecognizerStateEnded == recognizer.state
            || UIGestureRecognizerStateCancelled == recognizer.state) {
            if (translation.x >= HIDEN_DISTANCE) {
                [UIView animateWithDuration:0.2 animations:^{
                    _livingView.left = _livingView.superview.width;
                } completion:^(BOOL finished) {
                    isLivingShowState = NO;
                    _closeBtn.hidden = NO;
                }];
            } else {
                [UIView animateWithDuration:0.2 animations:^{
                    _livingView.left = 0;
                } completion:^(BOOL finished) {
                    isLivingShowState = YES;
                    _livingView.closeBtn.hidden = NO;
                    _closeBtn.hidden = YES;
                }];
            }
        } else {
            isLivingShowState = YES;
            _livingView.closeBtn.hidden = NO;
            _closeBtn.hidden = YES;
            _livingView.left += [_livingView convertPoint:translation fromView:recognizer.view].x;
            //            NSLog(@"trans x:%f %f %f",[_livingView convertPoint:translation fromView:recognizer.view].x, translation.x,recognizer.view.left);
            [recognizer translationInView:_livingView];
        }
    } else {
        if (translation.x > 0) {
            return;
        }
        
        if (UIGestureRecognizerStateEnded == recognizer.state || UIGestureRecognizerStateCancelled == recognizer.state) {
            if (fabs(translation.x) >= SHOW_DISTANCE) {
                [UIView animateWithDuration:0.2 animations:^{
                    _livingView.left = 0;
                } completion:^(BOOL finished) {
                    isLivingShowState = YES;
                    _livingView.closeBtn.hidden = NO;
                    _closeBtn.hidden = YES;
                }];
            } else {
                [UIView animateWithDuration:0.2 animations:^{
                    _livingView.left = _livingView.superview.width;
                } completion:^(BOOL finished) {
                    isLivingShowState = NO;
                    _livingView.closeBtn.hidden = YES;
                    _closeBtn.hidden = NO;
                }];
            }
        } else {
            if (_livingView.left + [_livingView convertPoint:translation fromView:recognizer.view].x <= 0) {
                return;
            }
            _livingView.left  += translation.x;
            //            NSLog(@"trans x:%f %f %f",[_livingView convertPoint:translation fromView:recognizer.view].x, translation.x,recognizer.view.left);
            [recognizer translationInView:recognizer.view];
        }
    }
}

#pragma mark - 观察主播收到的钻石
- (void)LCUserLiveRecDiamondDidChangeNotification:(NSNotification *)notification
{
    if (notification.object != [LCMyUser mine]) {
        return;
    }
    
    if (_livingView) {
        [_livingView updateRecvDiamond];
    }
}

#pragma mark - 未读取消息
- (void) updateCountOfTotalUnreadMessages:(NSNotification*) notification
{
    int unreadCount = [[notification object] intValue];//获取到传递的对象
    [self updateUnReadCount:unreadCount];
}


- (void) updateUnReadCount:(int)unreadCount
{
    ESWeakSelf;
    ESDispatchOnMainThreadAsynchrony(^{
        ESStrongSelf;
        if (unreadCount > 0) {
            if (unreadCount >= 100) {
                _self->_livingView.badgeView.text =  @"99+";
            } else {
                _self->_livingView.badgeView.text = [NSString stringWithFormat:@"%d",unreadCount];
            }
            _self->_livingView.badgeView.hidden = NO;
        } else {
            _self->_livingView.badgeView.hidden = YES;
        }
        
    });
}

#pragma mark - 关闭直播间
- (void)closeLivingView:(LivingView*)livingView
{
    [self stopCallAction];
}

- (void) stopCallAction
{
    if(_kit)
    {
        if (_kit.callstarted) {
            isStopCall = YES;
            [_kit.rtcClient stopCall];
        } else {
            [self closeRoomAction];
        }
    }
}

- (void) closeRoomAction
{
    if (_kit)
    {
        if(_kit.rtcClient)
        {
            [_kit.rtcClient unRegisterRTC];
            _kit.rtcClient = nil;
        }
        
        [_kit stopPreview];
        
        [self rmObservers];  // need remove observers to dealloc
        
        _kit = nil;
        
        NSMutableDictionary *msgInfoDict = [NSMutableDictionary dictionary];
        msgInfoDict[@"type"] = LIVE_RTCLIVE_TYPE;
        msgInfoDict[@"upmike_type"] = @(RTCLIVE_EXIT);
        msgInfoDict[@"uid"] = [LCMyUser mine].userID;
        msgInfoDict[@"nickname"] = [LCMyUser mine].nickname;
        
        [LiveMsgManager sendRTCLiveInfo:msgInfoDict andMsgType:LIVE_RTCLIVE_TYPE Succ:nil andFail:nil];
    }
    
    if (!_livingView) {
        return;
    }
    
    if (_livingView.contentTextField) {
        [_livingView.contentTextField resignFirstResponder];
    }
    
    _livingView.delegate = nil;
    [_livingView removeFromSuperview];
    _livingView = nil;
    
    
    [self downMikeReqServer];
    
    [self startLeaveRoom];
}

#pragma mark - 开始推出房间
- (void) startLeaveRoom
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self onHostExitRoom];
}


#pragma mark - 显示会话列表界面

#define BACKGROUND_TAG 1001

- (void)closeChat {
    ESWeakSelf;
    [UIView animateWithDuration:0.5 animations:^{
        ESStrongSelf;
        _self->chatNavigationController.view.top = CGRectGetHeight(self.view.bounds);
    } completion:^(BOOL finished) {
        ESStrongSelf;
        [_self->chatNavigationController removeFromParentViewController];
        [_self->chatNavigationController.view removeFromSuperview];
        UIView* backgroundView = [_self.view viewWithTag:BACKGROUND_TAG];
        [backgroundView removeFromSuperview];
        chatNavigationController = nil;
    }];
}

#pragma mark - 显示会话列表界面
- (void)showConversationVC
{
    if (!chatNavigationController) {
        
        LiveChatListViewController *chatController = [[LiveChatListViewController alloc] init];
        chatController.mNavigationController = self.navigationController;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:chatController];
        chatNavigationController = navigationController;
        
        navigationController.view.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
        
        
        ESWeakSelf;
        chatController.lyLeftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:ESLocalizedString(@"关闭") style:UIBarButtonItemStylePlain handler:^(UIBarButtonItem *barButtonItem) {
            ESStrongSelf;
            [_self closeChat];
        }];
        
        [self addChildViewController:navigationController];
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) / 3)];
        backgroundView.tag = BACKGROUND_TAG;
        [self.view addSubview:navigationController.view];
        [self.view addSubview:backgroundView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint locationInView) {
            ESStrongSelf;
            [_self closeChat];
            [backgroundView removeGestureRecognizer:tap];
        }];
        [backgroundView addGestureRecognizer:tap];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            navigationController.navigationBar.top = CGRectGetHeight(self.view.bounds) / 3 - navigationController.navigationBar.height;
            [UIView animateWithDuration:0.25 animations:^{
                navigationController.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
                //                navigationController.navigationBar.height = 24;
            } completion:^(BOOL finished) {
                NSLog(@"over %@", [navigationController.view description]);
            }];
            
        });
        
        if (_livingView.giftView) {// 跳转到聊天页面后需要更新礼物列表
            _livingView.giftView.isUpdateGiftView = YES;
        }
    }
}

#pragma mark 显示私聊
- (void)showPrivChat:(NSDictionary *)userInfoDict
{
    if (![LCMyUser mine].priChatTag || ![[LCMyUser mine].priChatTag isEqualToString:@"0"])
    {
        // 弹出提示
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"很抱歉，您没有私信的权限"
                                   delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil] show];
        
        return;
    }
    
    if (!chatNavigationController) {
        LiveChatDetailViewController *chatController = [[LiveChatDetailViewController alloc] initWithUserInfoDictionary:userInfoDict];
        chatController.viewFrame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
        chatController.mNavigationController = self.navigationController;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:chatController];
        chatNavigationController = navigationController;
        navigationController.navigationBarHidden = YES;
        
        navigationController.view.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
        ESWeakSelf;
        chatController.lyLeftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:ESLocalizedString(@"关闭") style:UIBarButtonItemStylePlain handler:^(UIBarButtonItem *barButtonItem) {
            ESStrongSelf;
            [_self closeChat];
        }];
        
        [self addChildViewController:navigationController];
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) / 3)];
        backgroundView.tag = BACKGROUND_TAG;
        [self.view addSubview:navigationController.view];
        [self.view addSubview:backgroundView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint locationInView) {
            ESStrongSelf;
            [_self closeChat];
            [backgroundView removeGestureRecognizer:tap];
        }];
        [backgroundView addGestureRecognizer:tap];
        
        [UIView animateWithDuration:0.25 animations:^{
            navigationController.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
        }];
        
        if (_livingView.giftView) {// 跳转到聊天页面后需要更新礼物列表
            _livingView.giftView.isUpdateGiftView = YES;
        }
    }
    //    [[[ChatViewController alloc] initWithUserInfoDictionary:userInfoDict] pushFromNavigationController:self.navigationController animated:YES];
}


#pragma mark 显示排行榜
- (void)showRankVC
{
    TopsRankControlView *topsRankVC = [[TopsRankControlView alloc] initWithStyle:UITableViewStylePlain hasRefreshControl:YES];
    topsRankVC.isLiveUser = YES;
    [self.navigationController pushViewController:topsRankVC animated:YES];
}

#pragma mark - 显示充值界面
- (void)showRechargeVC
{
    RechargeViewController *rechargeVC = [[RechargeViewController alloc] init];
    [self.navigationController pushViewController:rechargeVC animated:YES];
}

#pragma mark - 换房间
- (void) changeRoom:(NSDictionary *)userInfoDict
{
    [LCMyUser mine].roomInfoDict = userInfoDict;
    //    [self changeRoomVC:userInfoDict];
    [self startLeaveRoom];
}

// 显示主页
- (void)showHomePage:(NSString *)userId
{
    HomeUserInfoViewController *userInfoVC = [[HomeUserInfoViewController alloc] init];
    userInfoVC.userId = userId;
    [self.navigationController pushViewController:userInfoVC animated:YES];
}

#pragma mark - 换房间
- (WatchCutLiveViewController *) changeRoomVC:(NSDictionary *)userInfoDict
{
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:userInfoDict];
    
    WatchCutLiveViewController *watchLiveViewController = [[WatchCutLiveViewController alloc ] init];
    
    [LCMyUser mine].liveUserId = userInfoDict[@"uid"];
    [LCMyUser mine].liveUserName = userInfoDict[@"nickname"];
    [LCMyUser mine].liveUserLogo = userInfoDict[@"face"];
    [LCMyUser mine].liveTime = @"0";
    [LCMyUser mine].liveType = LIVE_WATCH;
    [LCMyUser mine].liveUserGrade = [userInfoDict[@"grade"] intValue];
    watchLiveViewController.playerUrl = userInfoDict[@"url"];
    watchLiveViewController.liveArray = array;
    watchLiveViewController.pos = 0;
    return  watchLiveViewController;
}

#pragma mark 显示用户空间
- (void) showUserSpaceVC:(LiveUser *)liveUser
{
    liveUser.isInRoom = YES;
    UserSpaceViewController *onlineUserVC = [[UserSpaceViewController alloc] init];
    spaceViewController = onlineUserVC;
    onlineUserVC.liveUser = liveUser;
    ESWeakSelf;
    onlineUserVC.reViewBlock = ^(NSDictionary * userInfoDict) {
        ESStrongSelf;
        [_self->_livingView reviewUser:userInfoDict];
    };
    
    onlineUserVC.privateChatBlock = ^(NSDictionary * userInfoDict) {
        ESStrongSelf;
        [_self showPrivChat:userInfoDict];
    };
    onlineUserVC.gagUserBlock = ^(NSDictionary * userInfoDict) {
        ESStrongSelf;
        NSMutableDictionary *socket = [NSMutableDictionary dictionary];
        socket[@"type"] = LIVE_GROUP_GAG;                       // 消息类型
        socket[@"uid"] = userInfoDict[@"uid"];                  // 用户id
        socket[@"nickname"] = userInfoDict[@"nickname"];        // 用户名称
        socket[@"send_name"] = [LCMyUser mine].nickname;        // 发送禁言的人
        [LiveMsgManager sendGagInfo:socket Succ:nil andFail:nil];
        [_self->_livingView addMessage:nil andUserInfo:socket];
    };
    onlineUserVC.unGagUserBlock = ^(NSDictionary * userInfoDict) {
        ESStrongSelf;
        NSMutableDictionary *socket = [NSMutableDictionary dictionary];
        socket[@"type"] = LIVE_GROUP_REMOVE_GAG;                       // 消息类型
        socket[@"uid"] = userInfoDict[@"uid"];                  // 用户id
        socket[@"nickname"] = userInfoDict[@"nickname"];        // 用户名称
        socket[@"send_name"] = [LCMyUser mine].nickname;        // 发送解除禁言的人
        [LiveMsgManager removeGagInfo:socket Succ:nil andFail:nil];
        [_self->_livingView addMessage:nil andUserInfo:socket];
    };
    
    onlineUserVC.addManagerBlock = ^(NSDictionary * userInfoDict) {
        ESStrongSelf;
        NSMutableDictionary *socket = [NSMutableDictionary dictionary];
        socket[@"type"] = LIVE_GROUP_MANAGER;                      // 消息类型
        socket[@"uid"] = userInfoDict[@"uid"];                  // 用户id
        socket[@"nickname"] = userInfoDict[@"nickname"];        // 用户名称
        
        [LiveMsgManager sendManagerInfo:socket Succ:nil andFail:nil];
        [_self->_livingView addMessage:nil andUserInfo:socket];
        
    };
    onlineUserVC.removeManagerBlock = ^(NSDictionary * userInfoDict) {
        ESStrongSelf;
        NSMutableDictionary *socket = [NSMutableDictionary dictionary];
        socket[@"type"] = LIVE_GROUP_REMOVE_MANAGER;            // 消息类型
        socket[@"uid"] = userInfoDict[@"uid"];                  // 用户id
        socket[@"nickname"] = userInfoDict[@"nickname"];        // 用户名称
        
        [LiveMsgManager sendRemoveManagerInfo:socket Succ:nil andFail:nil];
        [_self->_livingView addMessage:nil andUserInfo:socket];
    };
    onlineUserVC.showManagerListBlock = ^(){
        ESStrongSelf;
        [_self showManangerListVC];
    };
    onlineUserVC.changeLiveRoomBlock = ^(NSDictionary * userInfoDict) {
        ESStrongSelf;
        [_self changeRoom:userInfoDict];
    };
    onlineUserVC.showUserHomeBlock = ^(NSString *userId){
        ESStrongSelf;
        HomeUserInfoViewController *userInfoVC = [[HomeUserInfoViewController alloc] init];
        userInfoVC.userId = userId;
        [_self.navigationController pushViewController:userInfoVC animated:YES];
    };
    
    [self.navigationController popupViewController:onlineUserVC completion:nil];
}

#pragma mark 显示聊天列表
- (void) showManangerListVC
{
    ManagerListViewController *managerVC = [[ManagerListViewController alloc] initWithStyle:UITableViewStylePlain hasRefreshControl:NO];
    ESWeakSelf;
    managerVC.removeManagerInfoDict  = ^(NSDictionary * userInfoDict) {
        ESStrongSelf;
        NSMutableDictionary *socket = [NSMutableDictionary dictionary];
        socket[@"type"] = LIVE_GROUP_REMOVE_MANAGER;            // 消息类型
        socket[@"uid"] = userInfoDict[@"uid"];                  // 用户id
        socket[@"nickname"] = userInfoDict[@"nickname"];        // 用户名称
        
        [LiveMsgManager sendRemoveManagerInfo:socket Succ:nil andFail:nil];
        [_self->_livingView addMessage:nil andUserInfo:socket];
    };
    [self.navigationController pushViewController:managerVC animated:NO];
}

#pragma mark - 聊天消息

#pragma mark 发送聊天消息
- (void)sendMsg:(NSString*)message
{
    NSMutableDictionary *socket = [NSMutableDictionary dictionary];
    socket[@"type"] = LIVE_GROUP_CHAT_MSG;                      // 消息类型
    socket[@"uid"] = [LCMyUser mine].userID;        // 用户id
    socket[@"nickname"] = [LCMyUser mine].nickname; // 用户昵称
    socket[@"grade"] = [NSNumber numberWithInt:[LCMyUser mine].userLevel];  // 用户级别
    socket[@"face"] = [LCMyUser mine].faceURL;      // 用户头像
    socket[@"chat_msg"] = message;
    socket[@"offical"] = @([LCMyUser mine].showManager?1:0);
    
    [_livingView addMessage:message andUserInfo:socket];
    
    [LiveMsgManager sendChatMsg:socket andSucc:^() {
        NSLog(@"发送消息成功！");
    } andFail:^() {
        NSLog(@"发送消息失败！");
    }];
}

#pragma mark - 显示活动页面
- (void) showActiveVC:(NSDictionary *)activeDict
{
    ShowWebViewController *showWebVC = [[ShowWebViewController alloc] init];
    showWebVC.hidesBottomBarWhenPushed = YES;
    showWebVC.isShowRightBtn = false;
    showWebVC.webTitleStr = activeDict[@"title"];
    showWebVC.webUrlStr = activeDict[@"url"];
    [self.navigationController pushViewController:showWebVC animated:YES];
}

#pragma mark 发送点亮消息
- (void)sendPraise:(NSInteger)praiseCount
{
    NSMutableDictionary *socket = [NSMutableDictionary dictionary];
    socket[@"type"] = LIVE_GROUP_USER_LOVE;                    // 消息类型
    socket[@"uid"] = [LCMyUser mine].userID;        // 用户id
    socket[@"nickname"] = [LCMyUser mine].nickname; // 用户昵称
    socket[@"grade"] = [NSNumber numberWithInt:[LCMyUser mine].userLevel];
    socket[@"face"] = [LCMyUser mine].faceURL;      // 用户头像
    int x = arc4random() % 7 + 1;
    socket[@"love_pos"] = [NSString stringWithFormat:@"%d",x];     // 爱心的位置
    socket[@"offical"] = @([LCMyUser mine].showManager?1:0);
    [_livingView addMessage:nil andUserInfo:socket];
    [LiveMsgManager sendLightUp:socket UserLoveSucc:nil andFail:nil];
}


#pragma mark 发送用户进入房间消息

#pragma mark 发送删除用户消息
- (void)sendDelUser:(NSString*)userId result:(void(^)(NSString*))result
{
    NSMutableDictionary *socket = [NSMutableDictionary dictionary];
    socket[@"type"] = LIVE_GROUP_EXIT_ROOM;                      // 消息类型
    socket[@"uid"] = [LCMyUser mine].userID;                     // 用户id
    if ([[LCMyUser mine].liveUserId  isEqualToString:userId]) {
        socket[@"audience_count"] = [NSNumber numberWithInt:roomAudienceCount]; // 观众总数
        socket[@"praise_count"]   = [NSNumber numberWithInt:roomPraiseCount];   // 点赞总数
    }
    
    [LiveMsgManager sendQuitRoom:socket andSucc:^{
        NSLog(@"send quit succ");
    } andFail:^{
        NSLog(@"send quit fail");
    }];
}

#pragma mark - 显示view监听
- (void)showLivingView:(NSArray *)systeInfoArray
{
    //添加键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHidden:)
                                                 name:UIKeyboardDidHideNotification object:nil];
    //网络链接状态监听
    
    [LuxuryManager luxuryManager].livingView = _livingView;
    [DriveManager shareInstance].containerView = _livingView;
    
    
    
    if (systeInfoArray  && systeInfoArray.count > 0) {
        for (NSString *systemInfoStr in systeInfoArray) {
            NSMutableDictionary *systemDict = [NSMutableDictionary dictionary];
            systemDict[@"type"] = LIVE_GROUP_SYSTEM_MSG;                    // 消息类型
            systemDict[@"system_content"] = systemInfoStr;                  // 系统消息
            
            [_livingView addMessage:systemInfoStr andUserInfo:systemDict];
        }
    }
    
    _livingView.mSuperManagerView.hidden = ![LCMyUser mine].showManager;
}

- (void) showLiveFloatView
{
    [UIView animateWithDuration:0.5 animations:^{
        _livingView.alpha = 1;
    }completion:^(BOOL finish){
        _faceFloatImgView.hidden = YES;
        if (_effectview) {
            _effectview.hidden = YES;
        }
        _closeBtn.hidden = YES;
        
        _livingView.hidden = NO;
    }];
}

#pragma mark - 房间直播记时
- (void) startLiveCountTimer {
    liveCountTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(modLiveTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:liveCountTimer forMode:NSRunLoopCommonModes];
}

- (void) stopLiveCountTimer
{
    if (liveCountTimer) {
        [liveCountTimer invalidate];
        liveCountTimer = nil;
    }
}

// 时间累积
- (void) modLiveTime
{
    liveTimeCount++;
}

#pragma mark - 取消邀请上麦
- (void) cancelInviteUpMike:(NSNotification*)notyfication
{
    NSString *userId = notyfication.object;
    if ([userId isEqualToString:[LCMyUser mine].userID]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self stopCallAction];
        });
    }
}

#pragma mark - 分享成功
- (void) shareSuccToSend:(NSNotification*)notficatio {
    if (!_livingView.isHidden) {
        NSMutableDictionary *socket = [NSMutableDictionary dictionary];
        socket[@"type"] = LIVE_GROUP_SHARE;            // 消息类型
        socket[@"msg"] = notficatio.object;
        
        [_livingView addMessage:nil andUserInfo:socket];
        [LiveMsgManager sendMsg:socket andMsgType:LIVE_GROUP_SHARE Succ:nil andFail:nil];
    }
}

#pragma mark - 网络连接通知
- (void)reachabilityChanged:(NSNotification*)notfication {
    NSLog(@"网络状态发生了改变");
    [self checkNetworkState];
}

- (void)checkNetworkState{
    
    if ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable) {
        NSLog(@"wifi-环境");
        //        [_kit.streamerBase stopStream];
        //        [_kit.streamerBase startStream:_hostURL];
        //        [self initStatData];
    } else if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable){
        NSLog(@"3G网络");
        //        [_kit.streamerBase stopStream];
        //        [_kit.streamerBase startStream:_hostURL];
        //        [self initStatData];
    }else{
        //
        NSLog(@"没有网络");
    }
}

#pragma mark 切换前后台
#define isIOS7() ([[UIDevice currentDevice].systemVersion doubleValue]>= 7.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 8.0)


- (void)handleBecomeActive
{
    if (_livingView.allShowGiftView) {
        [_livingView.allShowGiftView startSendGiftViewAnimation];
    }
}

- (void)handleResignActive
{
    // 对后台直接退出上麦
    [self stopCallAction];
}



#pragma mark - 禁止直播截图

- (void)uploadScreen {
    [[LCHTTPClient sharedHTTPClient] upLoadImage:[self capture] withParam:nil withPath:nil progress:^(NSProgress *progress) {
        
    } withRESTful:POST_REQUEST withSuccessBlock:^(NSDictionary *responseDic) {
        
    } withFailBlock:^(NSError *error) {
        
    }];
}

- (UIImage *)capture
{
    // 创建一个context
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    
    //把当前的全部画面导入到栈顶context中并进行渲染
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // 从当前context中创建一个新图片
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return img;
}


#pragma mark - 键盘通知

- (void)keyboardWillShown:(NSNotification*)aNotification
{
//    NSDictionary *info=[aNotification userInfo];
//    CGRect keyboardFrame;
//    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
//    CGFloat distanceToMove = kbSize.height;
//    
//    [UIView animateWithDuration:0.2f animations:^{
//        if (_livingView) {
//            //            NSLog("%@ %f",NSStringFromCGRect(_livingView.enterContentView.frame),distanceToMove);
//            _livingView.bottom = SCREEN_HEIGHT - distanceToMove;
//        }
//    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
//    [UIView animateWithDuration:0.2f animations:^{
//        if (_livingView) {
//            NSLog("%@",NSStringFromCGRect(_livingView.enterContentView.frame));
//            _livingView.bottom = SCREEN_HEIGHT;
//            _livingView.bottomView.hidden = NO;
//            
//            _livingView.enterContentView.hidden = YES;
//        }
//    }];
}

- (void)keyboardDidHidden:(NSNotification*)aNotification
{
    
}

#pragma mark - 退出房间
- (void)avExitChat
{
    if (isExitRoom) {
        return;
    }
    isExitRoom = YES;
    
    //离开房间
    NSLog(@"观众开始退直播 [Business sharedInstance] leaveRoom");
    
    [self avExitRoom];
}

- (void)avExitRoom
{
    
    [self dismissController];
}

#pragma mark - 主播离开
- (void)closeLivingViewWhonHostLeave:(BOOL)connectTimeOut
{
    //删除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    
    if (_livingView.contentTextField) {
        [_livingView.contentTextField resignFirstResponder];
    }
    
    // 直播结束通知
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Live_End object:nil];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    //    if(LIVE_DOING == [LCMyUser mine].liveType)
    //    {
    //        if (connectTimeOut) {
    //            connectLiveTimeOut = connectTimeOut;
    //            [self onHostExitRoom];
    //        } else {
    //            LiveAlertView* alert = [[[NSBundle mainBundle] loadNibNamed:@"LiveAlertView" owner:self options:nil] lastObject];
    //            NSString* title = [NSString stringWithFormat:ESLocalizedString(@"有%ld人正在看您的直播,确定结束直播吗？"),roomAudienceCount];
    //            ESWeakSelf;
    //            [alert showTitle:title confirmTitle:ESLocalizedString(@"结束直播") cancelTitle:ESLocalizedString(@"继续直播") confirm:^{
    //                ESStrongSelf;
    //                [_self onHostExitRoom];
    //            } cancel:nil];
    //        }
    //    }
    //    else
    //    {
    // 上麦者退出
    
    if (chatNavigationController) {// 正在聊天结果主播退出直播
        [self closeChat];
    }
    
    [self onHostExitRoom];
    //    }
}

// 退出房间
- (void)onHostExitRoom
{
    //    if ([LCMyUser mine].liveType == LIVE_DOING) {
    
    [self stopUpdateStreamStateTimer];
    [self dismissController];
    //    }
    
    //    [self sendDelUser:[LCMyUser mine].userID
    //               result:nil];
    //    [self avExitChat];
}

//- (void) showFinishViewWithAudienceCount:(int)audienceCount withRecMoney:(int)recMoneyCount withPraiseCount:(int)praiseCount
//{
//    [_livingView.messageTextField resignFirstResponder];
//    _livingView.hidden = YES;
//    // 结束不收消息
//    FinishLiveView* fv = [[FinishLiveView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    fv.connectTimeout = connectLiveTimeOut;
//    fv.delegate = self;
//    [fv showView:self.view audience:audienceCount revMoney:recMoneyCount praise:praiseCount];
//}


//- (void) showStartLiveView
//{
//    oldTime = [[NSDate date] timeIntervalSince1970]*1000;
//
//    startLiveView = [[StartVideoLiveView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    startLiveView.delegate = self;
//    [startLiveView showView:self.view];
//}

#pragma mark - finishview 代理
- (void)finishViewClose:(FinishLiveView *)fv
{
    [self dismissController];
}

#pragma mark - 继续直播
- (void) onContinueLive
{
    [LCMyUser mine].isContinueLive = YES;
    [self dismissController];
}


// 头像操作
- (void)logoTap:(LivingView*)livingView
{
    
}

// 点亮操作
- (void)loveTap:(LivingView*)livingView
{
    if (chatNavigationController) {
        [self closeChat];
        return ;
    }
}

#pragma mark - dismiss view
- (void)dismissController
{
    isFinishView = YES;
    
    [LCMyUser mine].liveType = LIVE_WATCH;
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 房间创建成功
- (void)OnRoomCreateComplete
{
    if (isCreateRoom) {
        return;
    }
    isCreateRoom = YES;
    
    //直播用户头像
    NSString* liveLogoPath = [LCMyUser mine].liveUserLogo;
    
    if([liveLogoPath isEqualToString:@""])
    {
        _livingView.userFaceImageView.image = [UIImage imageNamed:@"default_head"];
    }
    else
    {
        [_livingView.userFaceImageView sd_setImageWithURL:[NSURL URLWithString:[NSString faceURLString:liveLogoPath]] placeholderImage:[UIImage imageWithColor:RGB16(COLOR_FONT_WHITE) andSize:_livingView.userFaceImageView.frame.size]];
    }
    
    if ([LCMyUser mine].liveUserGrade > 0) {
        _livingView.gradeFlagImgView.image = [UIImage createUserGradeFlagImage:[LCMyUser mine].liveUserGrade withIsManager:[LCMyUser mine].showManager];
        _livingView.gradeFlagImgView.hidden = NO;
    } else {
        _livingView.gradeFlagImgView.hidden = YES;
    }
    
    [self startRTCRegister];
    
    [self insertLivingData:_upMikeInfoDict];
}

#pragma mark - 播放定时检查

#pragma mark - 插入直播数据
- (void)insertLivingData:(NSDictionary*)info
{
    // 开始直播
    NSArray *sysInfoArray  = info[@"sys_msg"];
    
    if ([info[@"recv_diamond"] intValue] > 0) {
        [LCMyUser mine].liveRecDiamond = [info[@"recv_diamond"] intValue];
    }
    
    [LCMyUser mine].liveAnchorMedalArray = info[@"anchor_medal"];
    
    NSLog(@"watch enter room:%d",[info[@"total"] intValue]);
    [LCMyUser mine].liveOnlineUserCount = [info[@"total"] intValue];
    _livingView.userCountLabel.text = [NSString stringWithFormat:@"%d",[info[@"total"] intValue]];
    _livingView.activeDict = info[@"act"];
    
    _livingView.mActivtyImageUrl = info[@"act"][@"img"];
    
    //不自动锁屏
    [UIApplication sharedApplication].idleTimerDisabled=YES;
    [self showLivingView:sysInfoArray];
    // 显示主播荣耀
    [_livingView showAnchorMedal];
    [_livingView connectChatFlag];
    
}




- (void) toast:(NSString*)message{
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [toast show];
    double duration = 0.3; // duration in seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
}

#pragma mark - status monitor
- (void) initStatData {
    _lastByte    = 0;
    _lastSecond  = [[NSDate date]timeIntervalSince1970];
    _lastFrames  = 0;
    _netEventCnt = 0;
    _raiseCnt    = 0;
    _dropCnt     = 0;
    _startTime   = [[NSDate date]timeIntervalSince1970];
}

#pragma mark -  观看直播
//

#pragma mark - 处理聊天室消息
- (void)onReceiveGroupMsg:(NSNotification *)notification
{
    if (!_livingView) {
        return;
    }
    RCMessage *rcMessage = notification.object;
    NSString *targetId = [NSString stringWithFormat:@"%@",rcMessage.targetId];
    if ([targetId isEqualToString:@"10000"]) {// 系统消息
        [self addGroupMessageToQueue:rcMessage];
    }
    
    if (![targetId isEqualToString:[LCMyUser mine].liveUserId] ||
        ![rcMessage.content isKindOfClass:[QCCustomMessage class]]
        ) {
        return;
    }
    
    [self addGroupMessageToQueue:rcMessage];
}

- (void) addGroupMessageToQueue:(RCMessage *)rcMessage {
    if (!__gSendingMessagesQueue) {
        return;
    }
    
    QCCustomMessage *msg = (QCCustomMessage *)rcMessage.content;
    if (!msg) {
        return;
    }
    ESWeakSelf;
    if (__gSendingMessagesQueue) {
        dispatch_async(__gSendingMessagesQueue, ^{
            ESStrongSelf;
            [_self.pendingMessages addObject:msg];
            
            ESDispatchOnMainThreadAsynchrony(^{
                ESStrongSelf;
                if (!_self.displayLink) {
                    _self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateUI:)];
                    _self.displayLink.frameInterval = 10;
                    [_self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
                }
            });
        });
    }
}

- (void)updateUI:(CADisplayLink *)displayLink
{
    if (!__gSendingMessagesQueue) {
        return;
    }
    
    ESWeakSelf;
    dispatch_async(__gSendingMessagesQueue, ^{
        ESStrongSelf;
        [_self dealRoomMsg];
    });
}

- (void) dealRoomMsg
{
    if (self.pendingMessages.isEmpty) {
        return;
    }
    
    QCCustomMessage *msg = self.pendingMessages.firstObject;
    [self.pendingMessages removeObjectAtIndex:0];
    
    if ([msg isKindOfClass:[RCTextMessage class]]) {
        return;
    }
    
    if (!msg || !msg.type || !msg.data) {
        return;
    }
    
    ESWeakSelf;
    ESDispatchOnMainThreadAsynchrony(^{
        ESStrongSelf;
        [_self showMainThreadDealMsgType:msg.type withMsgContent:msg.data];
    });
}

- (void) showMainThreadDealMsgType:(NSString *)msgType withMsgContent:(NSDictionary *)socketData
{
    if ([msgType isEqualToString:LIVE_RTCLIVE_TYPE]) {
        
        int upMikeType = [socketData[@"upmike_type"] intValue];
        if (upMikeType == RTCLIVE_EXIT) {// 下麦
            
            //            // 告诉主播收到下麦通知
            //            NSMutableDictionary *msgInfoDict = [NSMutableDictionary dictionary];
            //            msgInfoDict[@"type"] = LIVE_RTCLIVE_TYPE;
            //            msgInfoDict[@"upmike_type"] = @(RTCLIVE_EXIT);
            //            msgInfoDict[@"uid"] = [LCMyUser mine].userID;
            //            msgInfoDict[@"nickname"] = [LCMyUser mine].nickname;
            //
            //            [LiveMsgManager sendRTCLiveInfo:msgInfoDict andMsgType:LIVE_RTCLIVE_TYPE Succ:nil andFail:nil];
            
            //            [self closeRoomAction];
        } else if (upMikeType == RTCLIVE_CALL_SUCC){
            [_livingView updateShowMsgArea:YES withEixtUpMike:NO];
        }
    } else {
        if ([msgType isEqualToString:LIVE_GROUP_ENTER_ROOM]) {
            if ([socketData[@"total"] intValue] > 0 &&  [socketData[@"total"] intValue] > [LCMyUser mine].liveOnlineUserCount) {
                [LCMyUser mine].liveOnlineUserCount = [socketData[@"total"] intValue];
                roomAudienceCount = [LCMyUser mine].liveOnlineUserCount;
            } else {
                [LCMyUser mine].liveOnlineUserCount++;
                roomAudienceCount = [LCMyUser mine].liveOnlineUserCount;
            }
            
        } else if([msgType isEqualToString:LIVE_GROUP_CHAT_MSG]) {
            
            
        } else if([msgType isEqualToString:LIVE_GROUP_EXIT_ROOM]) {
            NSString *userId = socketData[@"uid"];
            if ([LCMyUser mine].liveOnlineUserCount > 0) {
                [LCMyUser mine].liveOnlineUserCount--;
                //                roomAudienceCount = [LCMyUser mine].liveOnlineUserCount;
            }
            
            //主播离开
            if([userId isEqualToString:[LCMyUser mine].liveUserId])
            {
                if ([LCMyUser mine].liveType != LIVE_DOING) {
                    isHostLeaveRoom = YES;
                    
                    roomAudienceCount = [socketData[@"audience_count"] intValue];
                    roomPraiseCount = [socketData[@"praise_count"] intValue];
                }
                
                [self closeLivingViewWhonHostLeave:NO];
            }
        } else if ([msgType isEqualToString:LIVE_GROUP_USER_LOVE]) {
        } else if ([msgType isEqualToString:LIVE_GROUP_GIFT]) {
            
            int recvDiamond = [socketData[@"recv_diamond"] intValue];
            
            if (recvDiamond > [LCMyUser mine].liveRecDiamond) {
                [LCMyUser mine].liveRecDiamond = recvDiamond;
            }
            
            if ([socketData[@"gift_type"] intValue] == GIFT_TYPE_CONTINUE) {// 连续
                if ([LCMyUser mine].liveType == LIVE_DOING) {
                    int price = [socketData[@"price"] intValue];
                    roomRecMoneyCount += price;
                }
            } else if ([socketData[@"gift_type"] intValue] == GIFT_TYPE_REDPACKET) {// 红包
            } else if ([socketData[@"gift_type"] intValue] == GIFT_TYPE_LUXURY) {//豪华礼物
                if ([LCMyUser mine].liveType == LIVE_DOING) {
                    int price = [socketData[@"price"] intValue];
                    roomRecMoneyCount += price;
                }
            }
        }
        
        [_livingView showDealGroupMsgType:msgType withMsgContent:socketData];
    }
}


#pragma mark - 推流心跳
//

#pragma mark - 更新推流定时器
- (void) startUpdateStreamStateTimer
{
    if (!liveDataTimer) {
        liveDataTimer =  [NSTimer scheduledTimerWithTimeInterval:1.2
                                                          target:self
                                                        selector:@selector(updateStat:)
                                                        userInfo:nil
                                                         repeats:YES];
    }
}

- (void) stopUpdateStreamStateTimer
{
    livePushBreakCount = 0;
    liveReconnectCount = 0;
    
    if (liveDataTimer) {
        [liveDataTimer invalidate];
        liveDataTimer = nil;
    }
}

#pragma mark - 推流监听

- (NSString*) sizeFormatted : (int )KB {
    if ( KB > 1000 ) {
        double MB   =  KB / 1000.0;
        return [NSString stringWithFormat:@" %4.2f MB", MB];
    }
    else {
        return [NSString stringWithFormat:@" %d KB", KB];
    }
}

- (void)updateStat:(NSTimer *)theTimer
{
    
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}


#pragma mark - 金山云视频

#pragma mark - 开始直播监听
- (void)startLivePush
{
    oldTime = [[NSDate date] timeIntervalSince1970]*1000;
    
    // 自己直播
    _kit = [[KSYRTCStreamerKit alloc] initWithDefaultCfg];
    
    
    [self setCaptureCfg];
    // 开始推流
    [self setStreamerCfg];
    [self addObservers];
    //设置rtc参数
    [self setRtcSteamerCfg];
    
    // init with default filter
    GPUImageOutput<GPUImageInput> *_curFilter = [[KSYGPUBeautifyExtFilter alloc] init];
    //        int val = (nalVal*5) + 1; // level 1~5
    [(KSYGPUBeautifyExtFilter *)_curFilter setBeautylevel: 5];
    [_kit setupFilter:_curFilter];
    [_kit startPreview:self.view];
    
    
    UIImage *countDownImage = [UIImage imageNamed:@"image/liveroom/room_start_3"];
    _countDownImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, countDownImage.size.width, countDownImage.size.height)];
    _countDownImg.image = countDownImage;
    _countDownImg.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    [self.view addSubview:_countDownImg];
    _countDownImg.hidden = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showCountDownAnimation:3];
    });
    
    [_livingView.audienceTableView loadAudienceData];
    
    [self upMikeReqServer];

    [self OnRoomCreateComplete];
}

#pragma mark - 上麦通知服务端
- (void) upMikeReqServer
{
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"liveuid":[LCMyUser mine].liveUserId,@"user":[LCMyUser mine].userID}  withPath:URL_LIVE_UPMIKE withRESTful:GET_REQUEST withSuccessBlock:^(NSDictionary *responseDic) {
    } withFailBlock:^(NSError *error) {
        [LCNoticeAlertView showMsg:@"请求服务器失败"];
    }];
}


#pragma mark - 下麦通知服务端
- (void) downMikeReqServer
{
    if (![LCMyUser mine].userID || ![LCMyUser mine].liveUserId) {
        return;
    }
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"liveuid":[LCMyUser mine].liveUserId,@"user":[LCMyUser mine].userID}  withPath:URL_LIVE_DOWNMIKE withRESTful:GET_REQUEST withSuccessBlock:^(NSDictionary *responseDic) {
    } withFailBlock:^(NSError *error) {
        [LCNoticeAlertView showMsg:@"请求服务器失败"];
    }];
}

#pragma mark - stream setup (采集推流参数设置)
- (void) setCaptureCfg
{
    _kit.streamDimension = CGSizeMake(640, 360);
    _kit.videoFPS       = 15;
    _kit.cameraPosition = AVCaptureDevicePositionFront;
    //    _kit.bInterruptOtherAudio = NO;
    //    _kit.bDefaultToSpeaker    = YES; // 没有耳机的话音乐播放从扬声器播放
    _kit.videoProcessingCallback = ^(CMSampleBufferRef buf){
    };
}


- (void) setStreamerCfg
{
    streamBase = _kit.streamerBase;
    _kit.streamerBase.videoCodec = KSYVideoCodec_X264;
    _kit.streamerBase.videoInitBitrate = 480; // k bit ps
    _kit.streamerBase.videoMaxBitrate  = 800; // k bit ps
    _kit.streamerBase.videoMinBitrate  = 0; // k bit ps
    _kit.streamerBase.audiokBPS        = 32; // k bit ps
//    _kit.streamerBase.enAutoApplyEstimateBW = YES;
    _kit.streamerBase.shouldEnableKSYStatModule = YES;
    _kit.streamerBase.videoFPS = 15;
    _kit.streamerBase.logBlock = ^(NSString* str){
        NSLog(@"%@", str);
    };
    
    NSString *rtmpSrv  = @"rtmp://live.hainandaocheng.com/live";
    if ([LCMyUser mine].uplive_url) {
        rtmpSrv = [LCMyUser mine].uplive_url;
    }
    NSString *url      = [NSString stringWithFormat:@"%@/%@", rtmpSrv, [LCMyUser mine].userID];
    _hostURL = [[NSURL alloc] initWithString:url];
    
    [self setVideoOrientation];
}

- (void) setRtcSteamerCfg {
    //设置ak/sk鉴权信息,本demo从testAppServer取，客户请从自己的appserver获取。
    _kit.rtcClient.authString = nil;
    //设定公司后缀
    _kit.rtcClient.uniqName = @"HuoWuLive";
    //设置音频采样率
    _kit.rtcClient.sampleRate = 44100;
    //设置视频帧率
    _kit.rtcClient.videoFPS = 15;
    //是否打开rtc的日志
    _kit.rtcClient.openRtcLog = YES;
    //设置对端视频的宽高
    _kit.rtcClient.videoWidth = 360;
    _kit.rtcClient.videoHeight = 640;
    //设置rtc传输的码率
//    _kit.rtcClient.AvgBps = 256000;
    _kit.rtcClient.MaxBps = 256000;
    //设置信令传输模式,tls为推荐
    _kit.rtcClient.rtcMode = 1;
    //设置小窗口的大小和显示
    _kit.winRect = CGRectMake(0.67, 0.61, 0.3, 0.3);
    _kit.rtcLayer = 4;
    //    //辅播小窗口看到的是自己
    _kit.selfInFront = YES;
     
    ESWeakSelf;
    __weak KSYRTCStreamerKit *weak_kit = _kit;
    _kit.rtcClient.onRegister= ^(int status){
        NSString * message = [NSString stringWithFormat:@"local sip account:%@",weak_kit.rtcClient.authUid];
        NSLog(@"register callback %d \n message: %@", status, message);
        ESStrongSelf;
        ESDispatchOnMainThreadAsynchrony(^{
            ESStrongSelf;
            if (status == 200) {// 注册成功
                NSMutableDictionary *msgInfoDict = [NSMutableDictionary dictionary];
                msgInfoDict[@"type"] = LIVE_RTCLIVE_TYPE;
                msgInfoDict[@"upmike_type"] = @(RTCLIVE_REGISTER_SUCC);
                msgInfoDict[@"uid"] = [LCMyUser mine].userID;
                msgInfoDict[@"nickname"] = [LCMyUser mine].nickname;
                
                [LiveMsgManager sendRTCLiveInfo:msgInfoDict andMsgType:LIVE_RTCLIVE_TYPE Succ:nil andFail:nil]; 
            } else {
                NSMutableDictionary *msgInfoDict = [NSMutableDictionary dictionary];
                msgInfoDict[@"type"] = LIVE_RTCLIVE_TYPE;
                msgInfoDict[@"upmike_type"] = @(RTCLIVE_REGISTER_FAIL);
                msgInfoDict[@"uid"] = [LCMyUser mine].userID;
                msgInfoDict[@"nickname"] = [LCMyUser mine].nickname;
                
                [LiveMsgManager sendRTCLiveInfo:msgInfoDict andMsgType:LIVE_RTCLIVE_TYPE Succ:nil andFail:nil];
                
                [LCNoticeAlertView showMsg:@"上麦失败！"];
                
                [_self stopCallAction];
            }
        });
    };
    _kit.rtcClient.onUnRegister= ^(int status){
        NSLog(@"unregister callback %d", status);
        if (status == 200) {
            
        }
    };
    _kit.rtcClient.onCallInComing =^(char* remoteURI){
        NSString *text = [NSString stringWithFormat:@"有呼叫到来,id:%s",remoteURI];
        NSLog(@"%@", text);
        [weak_self onRtcAnswerCall];
    };
    
    _kit.onCallStart =^(int status){
        ESStrongSelf;
        if(status == 200)
        {
            if([UIApplication sharedApplication].applicationState !=UIApplicationStateBackground)
            {
                NSLog(@"建立连接,%d",status);
                ESDispatchOnMainThreadAsynchrony(^{
                    // init with default filter
                    GPUImageOutput<GPUImageInput> *_curFilter = [[KSYGPUBeautifyExtFilter alloc] init];
                    //        int val = (nalVal*5) + 1; // level 1~5
                    [(KSYGPUBeautifyExtFilter *)_curFilter setBeautylevel: 5];
                    [_self->_kit setupRtcFilter:_curFilter];
                });
                
            }
        }
        else if(status == 408){
            NSLog(@"对方无应答,%d", status);
            [LCNoticeAlertView showMsg:@"上麦失败！"];
            
            [_self stopCallAction];
            NSLog(@"呼叫失败%d", status);
        }
        else if(status == 404){
            NSLog(@"呼叫未注册号码,主动停止%d", status);
            [LCNoticeAlertView showMsg:@"上麦失败！"];
            
            [_self stopCallAction];
            NSLog(@"呼叫失败%d", status);
        }
        NSLog(@"call callback:%d",status);
    };
    _kit.onCallStop = ^(int status){
        if(status == 200)
        {
            if([UIApplication sharedApplication].applicationState !=UIApplicationStateBackground)
            {
                NSLog(@"断开连接, %d", status);
            }
        }
        
        ESStrongSelf;
        ESDispatchOnMainThreadAsynchrony(^{
            ESStrongSelf;
            [_self closeRoomAction];
        });
        NSLog(@"oncallstop:%d",status);
    };
}

- (void)onRtcAnswerCall{
    int ret = [_kit.rtcClient answerCall];
    NSLog(@"应答%d",ret);
}

#pragma mark-连麦
- (void)startRTCRegister {
    _kit.rtcClient.authString = _authString;
//    _kit.rtcClient.queryDomainString = [NSString stringWithFormat:@"%@/%@",_queryDomainString,@"querydomain"];;
    _kit.rtcClient.localId = [LCMyUser mine].userID;
    int ret = [_kit.rtcClient registerRTC];
    NSLog(@"start register %@ return %d", _kit.rtcClient.localId, ret);
}


- (void)startRTCCall
{
    if (isSendCall && [LCMyUser mine].liveUserId) {
        return;
    }
    isSendCall = YES;
    NSString *remoteID = [LCMyUser mine].liveUserId;
    int ret = [_kit.rtcClient startCall:remoteID];
    NSLog(@"call callback %@ return %d", remoteID, ret);
}


- (UIImage *)imageFromString:(NSString *)string attributes:(NSDictionary *)attributes size:(CGSize)size
{
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    textLabel.text = string;
    textLabel.textColor = [UIColor whiteColor];
    textLabel.font = [UIFont boldSystemFontOfSize:20];
    
    
    UIGraphicsBeginImageContextWithOptions(textLabel.size, NO, 0);
    //    [string drawInRect:CGRectMake(0, 0, size.width, size.height) withAttributes:attributes];
    [textLabel.layer drawInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (void) setVideoOrientation {
    UIInterfaceOrientation orien = [[UIApplication sharedApplication] statusBarOrientation];
    [_kit setVideoOrientation:orien];
}

- (void) addObservers {
    //KSYStreamer state changes
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onCaptureStateChange:)
                                                 name:KSYCaptureStateDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onStreamStateChange:)
                                                 name:KSYStreamStateDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onNetStateEvent:)
                                                 name:KSYNetStateEventNotification
                                               object:nil];
    ESWeakSelf;
    [[NSNotificationCenter defaultCenter] addObserverForName:Notification_Live_Ban object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        ESStrongSelf;
        [_self closeLivingViewWhonHostLeave:YES];
    }];
}

- (void) rmObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:KSYCaptureStateDidChangeNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:KSYStreamStateDidChangeNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:KSYNetStateEventNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:Notification_Live_Ban];
}

#pragma mark - state machine (state transition)
- (void) onCaptureStateChange:(NSNotification *)notification {
    
    if ( _kit.captureState == KSYCaptureStateIdle){
        //        [_btnPreview setTitle:@"开始预览" forState:UIControlStateNormal];
    }
    else if (_kit.captureState == KSYCaptureStateCapturing ) {
        //        [_btnPreview setTitle:@"停止预览" forState:UIControlStateNormal];
//        if (_kit.streamerBase.streamState != KSYStreamStateConnected) {
//            [_kit.streamerBase startStream:_hostURL];
//            [self initStatData];
//        }
    }
    else if (_kit.captureState == KSYCaptureStateClosingCapture ) {
        //        _statLabel.text = @"closing capture";
    }
    else if (_kit.captureState == KSYCaptureStateDevAuthDenied ) {
        //        _statLabel.text = @"camera/mic Authorization Denied";
    }
    else if (_kit.captureState == KSYCaptureStateParameterError ) {
        //        _statLabel.text = @"capture devices ParameterError";
    }
    else if (_kit.captureState == KSYCaptureStateDevBusy ) {
        //        _statLabel.text = @"device busy, try later";
    }
    NSLog(@"newCapState: %lu", (unsigned long)_kit.captureState);
}

- (void) onStreamError:(KSYStreamErrorCode) errCode {
    if (errCode == KSYStreamErrorCode_CONNECT_BREAK) {
        // Reconnect
        //        dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
        //        dispatch_after(delay, dispatch_get_main_queue(), ^{
        //            _kit.streamerBase.bWithVideo = YES;
        //            [_kit.streamerBase startStream:_hostURL];
        //        });
    }
}

- (void) onNetStateEvent:(NSNotification *)notification {
    KSYNetStateCode netEvent = _kit.streamerBase.netStateCode;
    //NSLog(@"net event : %ld", (unsigned long)netEvent );
    if (netEvent == KSYNetStateCode_SEND_PACKET_SLOW ) {
        _netEventCnt++;
        if (_netEventCnt % 10 == 9) {
            //            [self toast:@"bad network"];
        }
        NSLog(@"bad network" );
    }
    else if ( netEvent == KSYNetStateCode_EST_BW_RAISE ) {
        _netEventRaiseDrop = @"raising";
        _raiseCnt++;
        _netTimeOut = 5;
        NSLog(@"bitrate raising" );
    }
    else if ( netEvent == KSYNetStateCode_EST_BW_DROP ) {
        _netEventRaiseDrop = @"dropping";
        _dropCnt++;
        _netTimeOut = 5;
        NSLog(@"bitrate dropping" );
    }
}

- (void) onStreamStateChange:(NSNotification *)notification {
    NSString *stateChangeStr = nil;
    //    [_btnPreview setEnabled:NO];
    //    [_btnTStream setEnabled:NO];
    if ( _kit.streamerBase.streamState == KSYStreamStateIdle) {
        stateChangeStr = @"idle";
        //        [_btnPreview setEnabled:TRUE];
        //        [_btnTStream setEnabled:TRUE];
        //        [_btnTStream setTitle:@"开始推流" forState:UIControlStateNormal];
    }
    else if ( _kit.streamerBase.streamState == KSYStreamStateConnected) {
        stateChangeStr = @"connected";
//        [self startUpdateStreamStateTimer];
//        [self OnRoomCreateComplete];
        //        [_btnTStream setEnabled:TRUE];
        //        [_btnTStream setTitle:@"停止推流" forState:UIControlStateNormal];
    }
    else if (_kit.streamerBase.streamState == KSYStreamStateConnecting) {
        stateChangeStr = @"kit connecting";
    }
    else if (_kit.streamerBase.streamState == KSYStreamStateDisconnecting ) {
        stateChangeStr = @"disconnecting";
    }
    else if (_kit.streamerBase.streamState == KSYStreamStateError) {
        [self onStreamError:_kit.streamerBase.streamErrorCode];
    }
    NSLog(@"newState: %lu [%@]", (unsigned long)_kit.streamerBase.streamState, stateChangeStr);
}

@end

