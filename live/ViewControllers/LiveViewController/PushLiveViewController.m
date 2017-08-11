//
//  MyLiveViewController.m
//  live
//
//  Created by jacklong on 15/12/7.
//  Copyright © 2015年 jacklong. All rights reserved.
//


#import "PushLiveViewController.h"

#import "DriveManager.h"
#import "ChatUtil.h"
#import "LivingView.h"
#import "ChatConversationsListViewController.h"
#import "LiveAlertView.h"
#import "FinishLiveView.h"
#import "TopsRankControlView.h"
#import "LuxuryManager.h"
#import "IMBridge.h"

#import "Reachability.h"
#import <MBProgressHUD.h>

#import "UserSpaceViewController.h"
#import "ManagerListViewController.h"
#import "RechargeViewController.h"
#import "RedPacketManager.h"
#import "StartVideoLiveView.h"
#import "CameraPopView.h"
#import "IPAddressUtil.h"
#import "GroupMsgCell.h"
#import "ParseContentCommon.h"
#import "LiveChatDetailViewController.h"
#import "LiveChatListViewController.h"
#import "WatchCutLiveViewController.h"
#import "ShowWebViewController.h"

#import <AVFoundation/AVFoundation.h>

#import "CocoaAsyncSocket.h"


static const float writeDataTimeOut     = 2.0f;
static const float readDataTimeOut      = 10.0f;
static const int commandBindTag         = 101;
static const int commandCreateTag       = 102;
static const int commandEneterTag       = 103;
static const int commandNewTag          = 104;
static const int commandLeaveTag        = 105;
static const int commandBetTag          = 106;
static const int commandCloseTag        = 107;

#import "PLMediaStreamingKit.h"




#define HIDEN_DISTANCE          50
#define SHOW_DISTANCE           20

#define HEART_TIME              18
#define STOP_CONNECT_VIDEO_TIME HEART_TIME*1000

// 主播非正常退出时间
#define LIVE_PLAY_FINISH 6

// 直播重联次数
#define LIVE_RECONNECT_COUNT 3

// 1秒处理5条消息
#define kSendingMessageMinInterval (0.220)

enum NETWORK_STATUS {
    NETWORK_CONN = 0,
    NETWORK_FAIL,
    NETWORK_DISCONN
};


@interface PushLiveViewController()<LivingViewDelegate, FinishLiveViewDelegate, StartVideoLiveViewDelegate, CameraPopViewDelegate, UIGestureRecognizerDelegate, CAAnimationDelegate,GCDAsyncSocketDelegate,GCDAsyncUdpSocketDelegate,PLMediaStreamingSessionDelegate>
{
    // BOOL isStartPushOkState;
    // BOOL isShowStartLiveDetail;
    
    BOOL isStopCall;
    BOOL isSendCall; // 避免重复呼叫
    BOOL isAlreadyRegister; // 是否已经注册过了
    BOOL isRegisterRTCSucc;
    BOOL isLoveEnd;
    BOOL isCountDownStopAnimation;
    BOOL isFirstLoad;
    BOOL isCreateRoom;
    BOOL isExitRoom;
    BOOL isLivingShowState;
    BOOL isFinishView;
    BOOL isHostLeaveRoom;
    BOOL connectLiveTimeOut; // 连接超时
    BOOL isCallSucc;
    BOOL isReqInvite;
    
    int roomAudienceCount; // 看过的人数
    int roomRecMoneyCount; // 收到钻石
    int roomPraiseCount; // 点亮
    
    int liveTimeCount; // 直播时间统计
    
    int livePushBreakCount; // 推流断开的统计（设置金山自身重连时间）
    int liveReconnectCount; // 视频流重联次数（自身重连）
    
    NSTimeInterval oldTime; // 直播退到后天时间
    
    NSTimer *liveCountTimer; // 直播计时
    
    // 推流地址，完整的URL
    NSURL *_hostURL;
    NSString *vdoidStr;
    NSString *token;
    LivingView         *_livingView;
    UIButton           *_closeBtn;
//    KSYStreamerBase    *streamerBase;
//    KSYRTCStreamerKit  *_kit;
//    GPUImageFilter     *_filter; // set this filter to kit
    
    UIImageView        *_faceFloatImgView;
    UIVisualEffectView *_effectview; // 模糊效果
    UIImageView        *_countDownImg;
    
//    // 播放直播
//    KSYMoviePlayerController *_player;
    PLMediaStreamingSession      *_streamingSession;
    
    // 直播开始页面
    StartVideoLiveView *startLiveView;
    
    UILabel *_statLabel;
    
    NSTimer *startPlayTimer;
    NSTimer *liveHeartTimer; // 推流心跳
    NSTimeInterval lastCheckTime;
    
    NSTimer *liveDataTimer; // 数据流监听计时器
    
    NSTimer *livePlayerTimer; // 播放计时器
    NSString *serverIp; // 播放端ip
    
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
    
    uint64_t startTime; // time
    NSString *ipURL;
    
    dispatch_queue_t __gSendingMessagesQueue;
    UserSpaceViewController *spaceViewController;
    
    UINavigationController *chatNavigationController;
    
    NSMutableArray *_datas;
}


// @property (nonatomic, strong) UILabel *statLabel;

@property (nonatomic, strong) NSMutableArray *pendingMessages;
@property (nonatomic) uint64_t lastSendingTime;
@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) Reachability  *reachablity;
@property (nonatomic, strong) MBProgressHUD *hubView;

@property (nonatomic, strong) NSDictionary  *upMikeUserInfoDict; // 上麦用户信息
@property (nonatomic, strong) NSDictionary  *inviteUserInfoDict; // 受邀请用户信息（只有注册成功后才能发送邀请）

@property (nonatomic, strong) NSMutableArray *advArray;//

@property (nonatomic, strong) GCDAsyncSocket *asyncSocket;
@property (nonatomic, strong) GCDAsyncUdpSocket *udpAsyncSocket;

@property (nonatomic, assign) CurrentGameType currentGameType;

@end


@implementation PushLiveViewController

- (void)dealloc
{
    NSLog(@"pushlive dealloc");
    
    _livingView.delegate = nil;
    [LuxuryManager luxuryManager].livingView = nil;
    [[DriveManager shareInstance] setContainerView:nil];
    
    [_livingView removeFromSuperview];
    _livingView = nil;
    [self.view removeFromSuperview];
    
    // 停止监听
    [self.reachablity stopNotifier];
}

- (id)init
{
    if(self = [super init])
    {
        [self setHidesBottomBarWhenPushed:YES];
        
        _datas = [NSMutableArray array];
        
        __gSendingMessagesQueue = dispatch_queue_create("com.qianchuo.ShowMessagesQueue", DISPATCH_QUEUE_SERIAL);
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
    
    [self initView];
    
    self.pendingMessages = [NSMutableArray array];
    
    // 添加监听器
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveGroupMsg:) name:IMBridgeDidReceiveRoomMessageNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCountOfTotalUnreadMessages:) name:IMBridgeCountOfTotalUnreadMessagesDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LCUserLiveRecDiamondDidChangeNotification:) name:LCUserLiveRecDiamondDidChangeNotification object:nil];
    
    // 从后台切回
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // 进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    
    // 分享成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareSuccToSend:) name:kUserShareSuccMsg object:nil];
    
    // 添加网络状态监控
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    // 获取Reachability对象
    self.reachablity = [Reachability reachabilityForInternetConnection];
    // 开始监控网络状态
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

#pragma mark- 连接socket
- (void)tcpConnectingToHost
{
    //connecting to socket server
    if (!self.asyncSocket) {
        self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    NSError *error = nil;
    if (![self.asyncSocket connectToHost:URL_SOCKET_HOST onPort:PORT_SOCKET_HOST withTimeout:2.0f error:&error]) {
        NSLog(@"connected to server host failed: %@", error);
    }
}
- (void)tcpDisconnectToHost
{
    //socket closed
    if (self.asyncSocket) {
        [self.asyncSocket disconnect];
    }
    
}
#pragma mark- GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"DidConnectToHost: %@ port: %d", host, port);
    [self commandBind];
    //保持读取的长连接
    
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"did write with tag: %ld", tag);
}
/**
 socket disconnected

 @param sock self.asyncSocket
 @param err error occurred when disconnecting to the host
 */
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    [self tcpConnectingToHost];
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
//    [self.asyncSocket readDataWithTimeout:-1 tag:tag];
    switch (tag) {
        case commandBindTag:
            [self commandCreate];
            break;
        case commandCreateTag:
            [self commandEnter];
            break;
        case commandEneterTag:
            NSLog(@"You have entered the game room!");
        case commandNewTag:
            NSLog(@"start a new game!");
            [self receiveTimeoutCountingData:data];
            break;
        default:
            break;
    }
    [self reciveData:data];
}

#pragma mark- 游戏


//接受数据
-(void)reciveData:(NSData*)recieveData
{
    //接收到的数据写入本地
    
    NSLog(@"接收到的数据:%@",[NSDictionary dictionaryWithRecievedData:recieveData]);
    NSDictionary *dict = [NSDictionary dictionaryWithRecievedData:recieveData];
    NSString *cmd = [dict objectForKey:@"type"];
    NSDictionary *body = [dict objectForKey:@"body"];
    NSNumber *status = [body objectForKey:@"status"];
    NSDictionary *data = [body objectForKey:@"data"];
    
    if ([cmd isEqualToString:@"game_new"] && [status isEqualToNumber:@(0)]) {
        [_livingView showGameViewWithType:self.currentGameType];
    }else if ([cmd isEqualToString:@"game_bet"] && [status isEqualToNumber:@(0)]) {
        id betObj = [data objectForKey:@"bet"];
        if ([betObj isKindOfClass:[NSArray class]]) {
            [_livingView showBetActionWithArray:betObj];
        }
    }
}

/**
 绑定uid
 */
- (void)commandBind
{
    if ([LCMyUser mine].liveUserId) {
        
        NSDictionary *bindDict = @{@"cmd":@"bind",@"uid":[LCMyUser mine].userID};
        
        [self.asyncSocket writeData:[bindDict socketData]
                        withTimeout:writeDataTimeOut
                                tag:commandBindTag];
        [self.asyncSocket readDataWithTimeout:readDataTimeOut tag:commandBindTag];
    }
}

/**
 创建房间
 */
- (void)commandCreate
{
    if ([LCMyUser mine].liveUserId) {
        
        NSDictionary *bindDict = @{@"cmd":@"create",@"roomId":[LCMyUser mine].liveUserId};
        
        
        [self.asyncSocket writeData:[bindDict socketData]
                        withTimeout:writeDataTimeOut
                                tag:commandCreateTag];
        [self.asyncSocket readDataWithTimeout:readDataTimeOut tag:commandCreateTag];
    }
}

/**
 进入房间
 */
- (void)commandEnter
{
    if ([LCMyUser mine].liveUserId) {
        
        NSDictionary *bindDict = @{@"cmd":@"enter",@"roomId":[LCMyUser mine].liveUserId, @"uid":[LCMyUser mine].userID};
        
        
        [self.asyncSocket writeData:[bindDict socketData]
                        withTimeout:writeDataTimeOut
                                tag:commandEneterTag];
        [self.asyncSocket readDataWithTimeout:readDataTimeOut tag:commandEneterTag];
    }
}

/**
 开始游戏
 */
- (void)commandNewWithGameType:(NSInteger)type
{
    self.currentGameType = type;
    if ([LCMyUser mine].liveUserId) {
        
        NSString *gameTypeString = nil;
        switch (type) {
            case 1:
                gameTypeString = @"niu";
                break;
                
            default:
                break;
        }
        NSDictionary *bindDict = @{@"cmd":@"new",@"roomId":[LCMyUser mine].liveUserId, @"game":gameTypeString,@"uid":[LCMyUser mine].userID};
        
        
        [self.asyncSocket writeData:[bindDict socketData]
                        withTimeout:writeDataTimeOut
                                tag:commandNewTag];
        [self.asyncSocket readDataWithTimeout:readDataTimeOut tag:commandNewTag];
    }
}

/**
 主播关闭游戏
 */
- (void)commandClose
{
    if ([LCMyUser mine].liveUserId) {
        
        NSDictionary *closeDict = @{@"cmd":@"close", @"roomId":[LCMyUser mine].liveUserId, @"uid":[LCMyUser mine].userID};
        [self.asyncSocket writeData:[closeDict socketData] withTimeout:writeDataTimeOut tag:commandCloseTag];
        [self.asyncSocket readDataWithTimeout:readDataTimeOut tag:commandCloseTag];
    }
}

- (void)receiveTimeoutCountingData:(NSData *)recieveData
{
    NSDictionary *dict = [NSDictionary dictionaryWithRecievedData:recieveData];
    NSLog(@"开始游戏：%@", dict);
    NSString *cmd = [dict objectForKey:@"type"];
    NSDictionary *body = [dict objectForKey:@"body"];
    NSNumber *status = [body objectForKey:@"status"];
    NSDictionary *data = [body objectForKey:@"data"];
    
    //处理倒计时
    if ([cmd isEqualToString:@"game_poll"] && [status isEqualToNumber:@(0)]) {
        NSInteger timecount = [[data objectForKey:@"timecount"] integerValue];
        [_livingView timeOutCounting:timecount];
    }
    //处理结果
    if ([cmd isEqualToString:@"game_result"] && [status isEqualToNumber:@(0)]) {
        NSDictionary *resultDict = [data objectForKey:@"result"];
        [_livingView showGameResultWithDict:resultDict];
    }
    [self.asyncSocket readDataWithTimeout:readDataTimeOut tag:commandNewTag];
}

- (void)livingViewDidChooseGameAtIndex:(NSNumber *)index
{
    if (1 == [index integerValue]) {
        [self commandNewWithGameType:[index integerValue]];
    }
}
- (void)livingViewDidCloseTheGame
{
    [self commandClose];
}
- (void)creatRoomWithRoomId:(NSInteger)roomId
{
    
}

#pragma mark - 初始化

- (void)initView
{
    // 初始化
    [LCMyUser mine].liveRecDiamond = 0;
    [LCMyUser mine].liveOnlineUserCount = 0;
    [[LCMyUser mine] removeAllGagUser];
    
    
    
    // 初始化显示红包状态
    [RobRedPacketViewController isCloseRedPacket];
    
    if(LIVE_DOING == [LCMyUser mine].liveType)
    {
        self.view.backgroundColor = [UIColor blackColor];
        
        [self showStartLiveView];
    }
    
    // 直播视图
    _livingView = [[[NSBundle mainBundle] loadNibNamed:@"LivingView" owner:self options:nil] lastObject];
    _livingView.frame = self.view.bounds;
    _livingView.delegate = self;
    _livingView.hidden = YES;
    _livingView.isHost = YES;
    [self.view addSubview:_livingView];
    
    UIImage *roomShutImage = [UIImage imageNamed:@"image/liveroom/roomshut"];
    
    float viewSize = roomShutImage.size.width;
    _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - viewSize - 10, SCREEN_HEIGHT - viewSize - 10, viewSize, viewSize)];
    _closeBtn.backgroundColor = [UIColor clearColor];
    [_closeBtn setImage:roomShutImage forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeRoomAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeBtn];
    
    UIPanGestureRecognizer *guestureR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    guestureR.delegate = self;
    [self.view addGestureRecognizer:guestureR];
    
    ESWeakSelf;
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{ @"liveuid":[LCMyUser mine].liveUserId} withPath:URL_LIVE_CLOSEMIKE withRESTful:GET_REQUEST withSuccessBlock:^(NSDictionary *responseDic) {
        ESStrongSelf;
        
        
        
        NSLog(@"res %@", responseDic);
        
    } withFailBlock:^(NSError *error) {
        ESStrongSelf;
        
        
        [LCNoticeAlertView showMsg:@"请求服务器连接失败"];
    }];

    
}


#pragma mark - 倒计时动画

- (void)showCountDownAnimation:(int)countDown
{
    isCountDownStopAnimation = NO;
    _countDownImg.hidden = NO;
    
    UIImage *countDownImage = [UIImage imageNamed:[NSString stringWithFormat:@"image/liveroom/room_start_%d", countDown]];
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
    [animation setValue:[NSString stringWithFormat:@"second%d", countDown] forKey:@"animationName"];
    
    [_countDownImg removeFromSuperview];
    [_countDownImg.layer addAnimation:animation forKey:[NSString stringWithFormat:@"second%d", countDown]];
    
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
        } else  if ([animationName isEqualToString:@"second1"]) {
            _countDownImg.hidden = YES;
            [_countDownImg removeFromSuperview];
            isCountDownStopAnimation = YES;
            
            [self showLiveFloatView];
        }
    }
}

- (void)sendMessage:(LivingView *)livingView
{
    if ([LCMyUser mine].isGag && ![LCMyUser mine].showManager) {
        // 用户已经被禁言
        return;
    }
    
    NSString *message = _livingView.contentTextField.text;
    if (![LCMyUser mine].showManager) {
        message = [[ChatUtil shareInstance] getFilterStringWithSrc:message];
    }
    
    NSLog(@"send message: %@", message);
    
    [self sendMsg:message];
}

// 摄像头切换界面
- (void)toggleCamera:(LivingView *)livingView
{
    [[CameraPopView cameraPopView] initPopViewData];
    [CameraPopView cameraPopView].delegate = self;
    
    [[CameraPopView cameraPopView] showPopoverWithView:self.view withTargetView:_closeBtn];
}


#pragma mark - 直播控制

// 开关闪光灯
- (void)onShanLightController:(int)state
{
    _streamingSession.torchOn = !_streamingSession.isTorchOn;
    
    NSArray *configs = nil;
    if (state == 1) {
        // 关
        configs = @[@{@"title":ESLocalizedString(@"开闪光"), @"icon":@"image/liveroom/room_pop_up_lamp", @"state":@"0"},
                    @{@"title":ESLocalizedString(@"翻转"), @"icon":@"image/liveroom/room_pop_up_camera", @"state":@"1"}, ];
    } else {
        // 开
        configs = @[@{@"title":ESLocalizedString(@"关闪光"), @"icon":@"image/liveroom/room_pop_up_lamp_p", @"state":@"1"},
                    @{@"title":ESLocalizedString(@"翻转"), @"icon":@"image/liveroom/room_pop_up_camera", @"state":@"1"}, ];
    }
    
    [[CameraPopView cameraPopView] setPopViewData:configs];
}

// 翻转控制(切换摄像头)
- (void)onCameraController:(int)state
{
//    if ( [_kit switchCamera ] == NO) {
//        [LCNoticeAlertView showMsg:ESLocalizedString(@"切换失败 当前采集参数 目标设备无法支持")];
//        return;
//    }
    [_streamingSession toggleCamera];
    
    BOOL backCam = (_streamingSession.captureDevicePosition == AVCaptureDevicePositionBack);
//    backCam = backCam && (_kit.captureState == KSYCaptureStateCapturing);
    
    NSArray *configs = nil;
    if (backCam) {
        // 后置
        configs = @[@{@"title":ESLocalizedString(@"开闪光"), @"icon":@"image/liveroom/room_pop_up_lamp", @"state":@"0"},
                     @{@"title":ESLocalizedString(@"翻转"), @"icon":@"image/liveroom/room_pop_up_camera", @"state":@"1"}, ];
    } else {
        // 前置
        configs = @[@{@"title":ESLocalizedString(@"开闪光"), @"icon":@"image/liveroom/room_pop_up_lamp", @"state":@"0"},
                    @{@"title":ESLocalizedString(@"翻转"), @"icon":@"image/liveroom/room_pop_up_camera_p", @"state":@"0"}, ];
    }
    
    [[CameraPopView cameraPopView] setPopViewData:configs];
}

// 美颜控制
- (void)onBeautyController:(int)state
{
    // if needed
}

- (void)openMike:(LivingView *)livingView
{
    // if needed
}


#pragma mark  拖动事件

- (void)handleSwipe:(UIPanGestureRecognizer *)recognizer
{
    if (_livingView.hidden || [LCMyUser mine].liveType == LIVE_DOING || !_livingView.giftView.isHidden) {
        return;
    }
    
    CGPoint translation = [recognizer translationInView:_livingView];
    
    if (isLivingShowState)
    {
        // 显示
        if (translation.x < 0) {
            return;
        }
        
        // 隐藏分享
        [_livingView hiddenShareView];
        
        if (UIGestureRecognizerStateEnded == recognizer.state || UIGestureRecognizerStateCancelled == recognizer.state)
        {
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
        }
        else
        {
            isLivingShowState = YES;
            _livingView.closeBtn.hidden = NO;
            _closeBtn.hidden = YES;
            _livingView.left += [_livingView convertPoint:translation fromView:recognizer.view].x;
            // NSLog(@"trans x: %f %f %f", [_livingView convertPoint:translation fromView:recognizer.view].x, translation.x, recognizer.view.left);
            
            [recognizer translationInView:_livingView];
        }
    }
    else
    {
        if (translation.x > 0) {
            return;
        }
        
        if (UIGestureRecognizerStateEnded == recognizer.state || UIGestureRecognizerStateCancelled == recognizer.state)
        {
            if (fabs(translation.x) >= SHOW_DISTANCE)
            {
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
        }
        else
        {
            if (_livingView.left + [_livingView convertPoint:translation fromView:recognizer.view].x <= 0) {
                return;
            }
            
            _livingView.left += translation.x;
            // NSLog(@"trans x: %f %f %f", [_livingView convertPoint:translation fromView:recognizer.view].x, translation.x, recognizer.view.left);
            
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


#pragma mark - 更新未读消息数量

- (void)updateCountOfTotalUnreadMessages:(NSNotification *)notification
{
    // 获取到传递的对象
    int unreadCount = [[notification object] intValue];
    
    [self updateUnReadCount:unreadCount];
}

- (void)updateUnReadCount:(int)unreadCount
{
    ESWeakSelf;
    
    ESDispatchOnMainThreadAsynchrony(^{
        ESStrongSelf;
        
        if (unreadCount > 0) {
            if (unreadCount >= 100) {
                _self->_livingView.badgeView.text = @"99+";
            } else {
                _self->_livingView.badgeView.text = [NSString stringWithFormat:@"%d", unreadCount];
            }
            _self->_livingView.badgeView.hidden = NO;
        } else {
            _self->_livingView.badgeView.hidden = YES;
        }
    });
}


#pragma mark - 关闭直播间

- (void)closeLivingView:(LivingView *)livingView
{
    
    [self closeRoomAction];
}

- (void)closeRoomAction
{
    // 隐藏键盘
    if (_livingView.contentTextField) {
        [_livingView.contentTextField resignFirstResponder];
    }
    
    ESWeakSelf;
    
    if(LIVE_DOING == [LCMyUser mine].liveType)
    {
        LiveAlertView *alert = [[[NSBundle mainBundle] loadNibNamed:@"LiveAlertView" owner:self options:nil] lastObject];
        NSInteger count = [LCMyUser mine].liveOnlineUserCount;
        NSString *title = [NSString stringWithFormat:ESLocalizedString(@"有%ld人正在观看您的直播，确定结束直播吗？"), (long)count];
        
        [alert showTitle:title confirmTitle:ESLocalizedString(@"结束直播") cancelTitle:ESLocalizedString(@"继续直播") confirm:^{
            ESStrongSelf;
            [self commandClose];
            [self tcpDisconnectToHost];
            [_self startLeaveRoom];
        } cancel:nil];
    }
    else
    {
        [self startLeaveRoom];
    }
}


#pragma mark - 开始退出房间

- (void)clearRoomInfo
{
    if (_streamingSession)
    {
        isAlreadyRegister = NO;
        
        // 切断连麦
//        if (_kit.rtcClient.authString) {
//            
//            if(_kit.rtcClient)
//            {
//                isStopCall = YES;
//                [_kit.rtcClient stopCall];
//            }
//        }
        if (_streamingSession) {
            if (_streamingSession.rtcState == PLRTCStateConferenceStarted) {
                isStopCall = YES;
                [_streamingSession stopConference];
            }
        }
    }
}

- (void)startLeaveRoom
{
    if (isCallSucc) {
        [self clearRoomInfo];
    } else {
        [self onHostExitRoom];
    }
}


#pragma mark - 显示会话列表界面

#define BACKGROUND_TAG 1001

- (void)closeChat
{
    ESWeakSelf;
    
    [UIView animateWithDuration:0.5 animations:^{
        ESStrongSelf;
        
        _self->chatNavigationController.view.top = CGRectGetHeight(self.view.bounds);
    } completion:^(BOOL finished) {
        ESStrongSelf;
        
        [_self->chatNavigationController removeFromParentViewController];
        [_self->chatNavigationController.view removeFromSuperview];
        
        UIView *backgroundView = [_self.view viewWithTag:BACKGROUND_TAG];
        [backgroundView removeFromSuperview];
        
        chatNavigationController = nil;
    }];
}


#pragma mark - 显示会话列表界面

- (void)showConversationVC
{
    if (!chatNavigationController)
    {
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
                // navigationController.navigationBar.height = 24;
            } completion:^(BOOL finished) {
                NSLog(@"over %@", [navigationController.view description]);
            }];
        });
        
        if (_livingView.giftView) {
            // 跳转到聊天页面后需要更新礼物列表
            _livingView.giftView.isUpdateGiftView = YES;
        }
    }
}


#pragma mark - 显示私聊

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
    
    if (!chatNavigationController)
    {
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
        
        if (_livingView.giftView) {
            // 跳转到聊天页面后需要更新礼物列表
            _livingView.giftView.isUpdateGiftView = YES;
        }
    }
    
    // [[[ChatViewController alloc] initWithUserInfoDictionary:userInfoDict] pushFromNavigationController:self.navigationController animated:YES];
}


#pragma mark - 显示排行榜

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

- (void)changeRoom:(NSDictionary *)userInfoDict
{
    [LCMyUser mine].roomInfoDict = userInfoDict;
    // [self changeRoomVC:userInfoDict];
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

- (WatchCutLiveViewController *)changeRoomVC:(NSDictionary *)userInfoDict
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
    
    return watchLiveViewController;
}


#pragma mark - 显示用户空间

- (void)showUserSpaceVC:(LiveUser *)liveUser
{
    liveUser.isInRoom = YES;
    
    UserSpaceViewController *onlineUserVC = [[UserSpaceViewController alloc] init];
    spaceViewController = onlineUserVC;
    onlineUserVC.liveUser = liveUser;
    
    if (_inviteUserInfoDict) {
        onlineUserVC.isInviteUpMike = NO;
    } else {
        onlineUserVC.isInviteUpMike = YES;
    }
    
    ESWeakSelf;
    
    onlineUserVC.reViewBlock = ^(NSDictionary *userInfoDict) {
        ESStrongSelf;
        
        [_self->_livingView reviewUser:userInfoDict];
    };
    
    onlineUserVC.privateChatBlock = ^(NSDictionary *userInfoDict) {
        ESStrongSelf;
        
        [_self showPrivChat:userInfoDict];
    };
    
    onlineUserVC.gagUserBlock = ^(NSDictionary *userInfoDict) {
        ESStrongSelf;
        
        NSMutableDictionary *socket = [NSMutableDictionary dictionary];
        socket[@"type"] = LIVE_GROUP_GAG;                           // 消息类型
        socket[@"uid"] = userInfoDict[@"uid"];                      // 用户id
        socket[@"nickname"] = userInfoDict[@"nickname"];            // 用户名称
        socket[@"send_name"] = [LCMyUser mine].nickname;            // 发送禁言的人
        [LiveMsgManager sendGagInfo:socket Succ:nil andFail:nil];
        
        [_self->_livingView addMessage:nil andUserInfo:socket];
    };
    
    onlineUserVC.unGagUserBlock = ^(NSDictionary *userInfoDict) {
        ESStrongSelf;
        
        NSMutableDictionary *socket = [NSMutableDictionary dictionary];
        socket[@"type"] = LIVE_GROUP_REMOVE_GAG;                    // 消息类型
        socket[@"uid"] = userInfoDict[@"uid"];                      // 用户id
        socket[@"nickname"] = userInfoDict[@"nickname"];            // 用户名称
        socket[@"send_name"] = [LCMyUser mine].nickname;            // 发送解除禁言的人
        [LiveMsgManager removeGagInfo:socket Succ:nil andFail:nil];
        
        [_self->_livingView addMessage:nil andUserInfo:socket];
    };
    
    onlineUserVC.addManagerBlock = ^(NSDictionary *userInfoDict) {
        ESStrongSelf;
        
        NSMutableDictionary *socket = [NSMutableDictionary dictionary];
        socket[@"type"] = LIVE_GROUP_MANAGER;                       // 消息类型
        socket[@"uid"] = userInfoDict[@"uid"];                      // 用户id
        socket[@"nickname"] = userInfoDict[@"nickname"];            // 用户名称
        [LiveMsgManager sendManagerInfo:socket Succ:nil andFail:nil];
        
        [_self->_livingView addMessage:nil andUserInfo:socket];
    };
    
    onlineUserVC.removeManagerBlock = ^(NSDictionary *userInfoDict) {
        ESStrongSelf;
        
        NSMutableDictionary *socket = [NSMutableDictionary dictionary];
        socket[@"type"] = LIVE_GROUP_REMOVE_MANAGER;                // 消息类型
        socket[@"uid"] = userInfoDict[@"uid"];                      // 用户id
        socket[@"nickname"] = userInfoDict[@"nickname"];            // 用户名称
        [LiveMsgManager sendRemoveManagerInfo:socket Succ:nil andFail:nil];
        
        [_self->_livingView addMessage:nil andUserInfo:socket];
    };
    
    onlineUserVC.showManagerListBlock = ^(){
        ESStrongSelf;
        
        [_self showManangerListVC];
    };
    
    onlineUserVC.changeLiveRoomBlock = ^(NSDictionary *userInfoDict) {
        ESStrongSelf;
        
        [_self changeRoom:userInfoDict];
    };
    
    onlineUserVC.showUserHomeBlock = ^(NSString *userId) {
        ESStrongSelf;
        
        HomeUserInfoViewController *userInfoVC = [[HomeUserInfoViewController alloc] init];
        userInfoVC.userId = userId;
        
        [_self.navigationController pushViewController:userInfoVC animated:YES];
    };
    
    onlineUserVC.inviteUpmikeBlock = ^(NSDictionary *userInfoDict) {
        ESStrongSelf;
        
        [_self inviteUpMike:userInfoDict];
    };
    
    [self.navigationController popupViewController:onlineUserVC completion:nil];
}

// 邀请上麦
- (void)inviteUpMike:(NSDictionary *)userInfoDict
{
    if (!userInfoDict || !userInfoDict[@"uid"])
    {
        return;
    }
    
    if (isReqInvite) {
        return;
    }
    
    isReqInvite = YES;
    
    ESWeakSelf;
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"live":userInfoDict[@"uid"], @"liveuid":[LCMyUser mine].liveUserId, @"user":userInfoDict[@"uid"]} withPath:URL_LIVE_CREATMIKE withRESTful:GET_REQUEST withSuccessBlock:^(NSDictionary *responseDic) {
        ESStrongSelf;
        
        _self->isReqInvite = NO;
        
        NSLog(@"res %@", responseDic);
        long state = [responseDic[@"stat"] integerValue];
        
        
        
        if (state == 200)
        {
            NSMutableDictionary *msgInfoDict = [NSMutableDictionary dictionary];
            
            msgInfoDict[@"type"] = LIVE_RTCLIVE_TYPE;
            msgInfoDict[@"upmike_type"] = @(RTCLIVE_INVITE_USER);
            msgInfoDict[@"uid"] = userInfoDict[@"uid"];
            msgInfoDict[@"nickname"] = userInfoDict[@"nickname"];

            
            token=responseDic[@"token"];
            _self->_inviteUserInfoDict = msgInfoDict;
            
            _self->_livingView.cancelInviteBtn.hidden = NO;
            
            
            [_self sendInviteUpMikeMsg];
            
        }
        else
        {
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
    } withFailBlock:^(NSError *error) {
        ESStrongSelf;
        
        _self->isReqInvite = NO;
        
        [LCNoticeAlertView showMsg:@"请求服务器连接失败"];
    }];
}

// 发送邀请
- (void)sendInviteUpMikeMsg
{
    if (!_inviteUserInfoDict || !_livingView.exitUpMikeBtn.isHidden) {
        // 已经上麦成功就不需要了
        return;
    }
    
    [LCNoticeAlertView showMsg:@"邀请已成功发出!"];
    isSendCall = NO;
    
    [LiveMsgManager sendRTCLiveInfo:_inviteUserInfoDict andMsgType:LIVE_RTCLIVE_TYPE Succ:nil andFail:nil];
}


#pragma mark - 显示聊天列表

- (void)showManangerListVC
{
    ManagerListViewController *managerVC = [[ManagerListViewController alloc] initWithStyle:UITableViewStylePlain hasRefreshControl:NO];
    ESWeakSelf;
    
    managerVC.removeManagerInfoDict = ^(NSDictionary *userInfoDict) {
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

// 发送聊天消息
- (void)sendMsg:(NSString*)message
{
    NSMutableDictionary *socket = [NSMutableDictionary dictionary];
    socket[@"type"] = LIVE_GROUP_CHAT_MSG;                                  // 消息类型
    socket[@"uid"] = [LCMyUser mine].userID;                                // 用户id
    socket[@"nickname"] = [LCMyUser mine].nickname;                         // 用户昵称
    socket[@"grade"] = [NSNumber numberWithInt:[LCMyUser mine].userLevel];  // 用户等级
    socket[@"face"] = [LCMyUser mine].faceURL;                              // 用户头像
    socket[@"chat_msg"] = message;
    socket[@"offical"] = @([LCMyUser mine].showManager ? 1 : 0);
    
    [_livingView addMessage:message andUserInfo:socket];
    
    [LiveMsgManager sendChatMsg:socket andSucc:^() {
        NSLog(@"发送消息成功！");
    } andFail:^() {
        NSLog(@"发送消息失败！");
    }];
}


#pragma mark - 显示活动页面

- (void)showActiveVC:(NSDictionary *)activeDict
{
    ShowWebViewController *showWebVC = [[ShowWebViewController alloc] init];
    showWebVC.hidesBottomBarWhenPushed = YES;
    showWebVC.isShowRightBtn = false;
    showWebVC.webTitleStr = activeDict[@"title"];
    showWebVC.webUrlStr = activeDict[@"url"];
    
    [self.navigationController pushViewController:showWebVC animated:YES];
}

// 展示Web页面
- (void)showWebView {
    ShowWebViewController *showWebVC = [[ShowWebViewController alloc] init];
    showWebVC.hidesBottomBarWhenPushed = YES;
    showWebVC.isShowRightBtn = false;
    showWebVC.webTitleStr = ESLocalizedString(@"社区公约");
    showWebVC.webUrlStr = [NSString stringWithFormat:@"%@other/treaty", URL_HEAD];
    
    [self.navigationController pushViewController:showWebVC animated:YES];
}


#pragma mark - 发送点亮消息

- (void)sendPraise:(NSInteger)praiseCount
{
    NSMutableDictionary *socket = [NSMutableDictionary dictionary];
    socket[@"type"] = LIVE_GROUP_USER_LOVE;                                     // 消息类型
    socket[@"uid"] = [LCMyUser mine].userID;                                    // 用户id
    socket[@"nickname"] = [LCMyUser mine].nickname;                             // 用户昵称
    socket[@"grade"] = [NSNumber numberWithInt:[LCMyUser mine].userLevel];      // 用户等级
    socket[@"face"] = [LCMyUser mine].faceURL;                                  // 用户头像
    int x = arc4random() % 7 + 1;
    socket[@"love_pos"] = [NSString stringWithFormat:@"%d", x];                 // 爱心的位置
    socket[@"offical"] = @([LCMyUser mine].showManager ? 1 : 0);
    
    [_livingView addMessage:nil andUserInfo:socket];
    
    [LiveMsgManager sendLightUp:socket UserLoveSucc:nil andFail:nil];
}


#pragma mark - 发送用户进入房间消息

// 发送删除用户消息
- (void)sendDelUser:(NSString *)userId result:(void(^)(NSString *))result
{
    NSMutableDictionary *socket = [NSMutableDictionary dictionary];
    socket[@"type"] = LIVE_GROUP_EXIT_ROOM;                                         // 消息类型
    socket[@"uid"] = [LCMyUser mine].userID;                                        // 用户id
    if ([[LCMyUser mine].liveUserId  isEqualToString:userId]) {
        socket[@"audience_count"] = [NSNumber numberWithInt:roomAudienceCount];     // 观众总数
        socket[@"praise_count"] = [NSNumber numberWithInt:roomPraiseCount];         // 点赞总数
    }
    
    [LiveMsgManager sendQuitRoom:socket andSucc:^{
        NSLog(@"send quit succ");
    } andFail:^{
        NSLog(@"send quit fail");
    }];
}


#pragma mark - 注册view监听器

- (void)showLivingView:(NSArray *)systeInfoArray
{
    // 添加键盘监听器
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHidden:)
                                                 name:UIKeyboardDidHideNotification object:nil];
    
    // 网络链接状态监听
    [LuxuryManager luxuryManager].livingView = _livingView;
    [DriveManager shareInstance].containerView = _livingView;
    
    if(LIVE_DOING == [LCMyUser mine].liveType)
    {
        [self startLiveCountTimer];
    }
    else
    {
        // 用户进入房间
        [LiveMsgManager sendEnterRoomSucc:^() {
            NSLog(@"enter room succ");
        } andFail:^() {
            NSLog(@"enter room fail");
        }];
    }
    
    if (systeInfoArray && systeInfoArray.count > 0)
    {
        for (NSString *systemInfoStr in systeInfoArray)
        {
            NSMutableDictionary *systemDict = [NSMutableDictionary dictionary];
            systemDict[@"type"] = LIVE_GROUP_SYSTEM_MSG;                        // 消息类型
            systemDict[@"system_content"] = systemInfoStr;                      // 消息内容
            
            [_livingView addMessage:systemInfoStr andUserInfo:systemDict];
        }
    }
    
    _livingView.mSuperManagerView.hidden = ![LCMyUser mine].showManager;
}

- (void)showLiveFloatView
{
    [UIView animateWithDuration:0.5 animations:^{
        _livingView.alpha = 1;
    } completion:^(BOOL finish) {
        _faceFloatImgView.hidden = YES;
        if (_effectview) {
            _effectview.hidden = YES;
        }
        _closeBtn.hidden = YES;
        
        _livingView.hidden = NO;
    }];
}


#pragma mark - 房间直播计时

- (void)startLiveCountTimer {
    liveCountTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(modLiveTime) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:liveCountTimer forMode:NSRunLoopCommonModes];
}

- (void)stopLiveCountTimer
{
    if (liveCountTimer) {
        [liveCountTimer invalidate];
        liveCountTimer = nil;
    }
}

// 时间累计
- (void)modLiveTime
{
    liveTimeCount++;
}


#pragma mark - 分享成功

- (void)shareSuccToSend:(NSNotification *)notfication {
    if (!_livingView.isHidden) {
        NSMutableDictionary *socket = [NSMutableDictionary dictionary];
        socket[@"type"] = LIVE_GROUP_SHARE;                             // 消息类型
        socket[@"msg"] = notfication.object;                            // 消息内容
        
        [_livingView addMessage:nil andUserInfo:socket];
        
        [LiveMsgManager sendMsg:socket andMsgType:LIVE_GROUP_SHARE Succ:nil andFail:nil];
    }
}


#pragma mark - 网络连接通知

- (void)reachabilityChanged:(NSNotification *)notfication {
    NSLog(@"网络状态发生了改变");
    
    [self checkNetworkState];
}

- (void)checkNetworkState
{
    if ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable) {
        NSLog(@"wifi网络");
        // [_kit.streamerBase stopStream];
        // [_kit.streamerBase startStream:_hostURL];
        // [self initStatData];
    } else if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable) {
        NSLog(@"3G网络");
        // [_kit.streamerBase stopStream];
        // [_kit.streamerBase startStream:_hostURL];
        // [self initStatData];
    } else {
        NSLog(@"没有网络");
    }
}


#pragma mark - 切换前后台

#define isIOS7() ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 8.0)

- (void)handleBecomeActive
{
    if (_livingView.allShowGiftView) {
        [_livingView.allShowGiftView startSendGiftViewAnimation];
    }
    
    if ([LCMyUser mine].liveType == LIVE_DOING && !_livingView.isHidden)
    {
        NSTimeInterval newTime = [[NSDate date] timeIntervalSince1970]*1000;
        
        // 心跳失联容忍时间
        if (newTime - oldTime > STOP_CONNECT_VIDEO_TIME) {
            [self closeLivingViewWhonHostLeave:YES];
        } else {
            NSMutableDictionary *socket = [NSMutableDictionary dictionary];
            socket[@"type"] = LIVE_GROUP_ROOM_ANCHOR_RESTORE;                   // 消息类型
            socket[@"msg"] = @"主播回来啦，视频即将恢复";                           // 消息内容
            
            [_livingView addMessage:nil andUserInfo:socket];
            
            [LiveMsgManager sendMsg:socket andMsgType:LIVE_GROUP_ROOM_ANCHOR_RESTORE Succ:nil andFail:nil];
            
            //[_kit.streamerBase startStream:_hostURL];
            [_streamingSession restartStreamingWithPushURL:_hostURL feedback:^(PLStreamStartStateFeedback feedback){
            
            }];
            
//            if (_upMikeUserInfoDict) {
//                // init with default filter
//                GPUImageOutput<GPUImageInput> *_curFilter = [[KSYGPUBeautifyExtFilter alloc] init];
//                // int val = (nalVal * 5) + 1;              // level 1~5
//                [(KSYGPUBeautifyExtFilter *)_curFilter setBeautylevel:5];
//                
//                [_kit setupRtcFilter:_curFilter];
//            } else {
//                GPUImageOutput<GPUImageInput> *_curFilter = [[KSYGPUBeautifyExtFilter alloc] init];
//                // int val = (nalVal * 5) + 1;              // level 1~5
//                [(KSYGPUBeautifyExtFilter *)_curFilter setBeautylevel:5];
//                [_kit setupFilter:_curFilter];
//            }
            
            [self initStatData];
            
            // 启动心跳
            [self startLiveHeartTimer];
            
            // 停止推流状态
            // [self startUpdateStreamStateTimer];
            
            [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"is_live":@(1)}
                                                          withPath:URL_LIVE_SYNC
                                                       withRESTful:GET_REQUEST
                                                  withSuccessBlock:nil
                                                     withFailBlock:nil];
        }
    }
}

- (void)handleResignActive
{
    if ([LCMyUser mine].liveType == LIVE_DOING && !_livingView.isHidden) {
        oldTime = [[NSDate date] timeIntervalSince1970]*1000;
        
        NSMutableDictionary *socket = [NSMutableDictionary dictionary];
        socket[@"type"] = LIVE_GROUP_ROOM_ANCHOR_LEAVE;                         // 消息类型
        socket[@"msg"] = @"主播离开一下，精彩不中断，不要走开哦";                     // 消息内容
        
        [_livingView addMessage:nil andUserInfo:socket];
        
        [LiveMsgManager sendMsg:socket andMsgType:LIVE_GROUP_ROOM_ANCHOR_LEAVE Succ:nil andFail:nil];
        
        [_streamingSession stopStreaming];
        
        // 停止心跳
        [self stopLiveHeartTimer];
        
        // 停止推流状态
//        [self stopUpdateStreamStateTimer];
        
        [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"is_live":@(0)}
                                                      withPath:URL_LIVE_SYNC
                                                   withRESTful:GET_REQUEST
                                              withSuccessBlock:nil
                                                 withFailBlock:nil];
    }
    
    if (_countDownImg && !_countDownImg.hidden) {
        _countDownImg.hidden = YES;
        [_countDownImg removeFromSuperview];
        
        [self showLiveFloatView];
    }
}


#pragma mark - 禁止直播截图

- (void)uploadScreen {
    [[LCHTTPClient sharedHTTPClient] upLoadImage:[self capture] withParam:nil withPath:nil progress:^(NSProgress *progress) {
        
    } withRESTful:POST_REQUEST withSuccessBlock:^(NSDictionary *responseDic) {
        
    } withFailBlock:^(NSError *error) {
        
    }];
}

// 截图
- (UIImage *)capture
{
    // 创建一个context
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    
    // 把当前的全部画面导入到栈顶context中，并进行渲染
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // 从当前context中创建一个新图片
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    // 把当前的context出栈
    UIGraphicsEndImageContext();
    
    return img;
}


#pragma mark - 键盘通知

- (void)keyboardWillShown:(NSNotification *)aNotification
{
//    NSDictionary *info = [aNotification userInfo];
//    
//    CGRect keyboardFrame;
//    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
//    
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
//    CGFloat distanceToMove = kbSize.height;
//    
//    [UIView animateWithDuration:0.2f animations:^{
//        if (_livingView) {
//            // NSLog("%@ %f", NSStringFromCGRect(_livingView.enterContentView.frame), distanceToMove);
//            _livingView.bottom = SCREEN_HEIGHT - distanceToMove;
//        }
//    }];
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
//    [UIView animateWithDuration:0.2f animations:^{
//        if (_livingView) {
//            NSLog("%@", NSStringFromCGRect(_livingView.enterContentView.frame));
//            _livingView.bottom = SCREEN_HEIGHT;
//            _livingView.bottomView.hidden = NO;
//            
//            _livingView.enterContentView.hidden = YES;
//        }
//    }];
}

- (void)keyboardDidHidden:(NSNotification *)aNotification
{
    // if needed
}


#pragma mark - 退出房间

- (void)avExitChat
{
    if (isExitRoom) {
        return;
    }
    isExitRoom = YES;
    
    if(LIVE_DOING == [LCMyUser mine].liveType)
    {
        [self stopLiveCountTimer];
        
        // 关闭房间
        [[Business sharedInstance] closeRoomTimer:liveTimeCount withVdoid:vdoidStr withTitle:_liveTitle withPraise:roomPraiseCount withAudience:roomAudienceCount succ:^(NSString *msg, id data) {
        } fail:^(NSString *error) {
        }];
        
        [self avExitRoom];
    }
}

- (void)avExitRoom
{
    if(LIVE_DOING == [LCMyUser mine].liveType) {
        // 退出心跳
        [self stopLiveHeartTimer];
        
        if ([LCMyUser mine].liveUserId) {
            // 退出聊天室
            [[IMBridge bridge] exitRoom:[LCMyUser mine].liveUserId completion:^(NSError *error) {
            }];
        }
        
        [self showFinishViewWithAudienceCount:roomAudienceCount withRecMoney:roomRecMoneyCount withPraiseCount:roomPraiseCount];
    }
}


#pragma mark - 主播离开

- (void)closeLivingViewWhonHostLeave:(BOOL)connectTimeOut
{
    // 注销监听器
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    
    // 隐藏键盘
    if (_livingView.contentTextField) {
        [_livingView.contentTextField resignFirstResponder];
    }
    
    // 直播结束通知
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Live_End object:nil];
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    if(LIVE_DOING == [LCMyUser mine].liveType)
    {
        if (connectTimeOut) {
            connectLiveTimeOut = connectTimeOut;
            if (isCallSucc) {
                [self clearRoomInfo];
            } else {
                [self onHostExitRoom];
            }
        } else {
            LiveAlertView *alert = [[[NSBundle mainBundle] loadNibNamed:@"LiveAlertView" owner:self options:nil] lastObject];
            NSString *title = [NSString stringWithFormat:ESLocalizedString(@"有%ld人正在看您的直播，确定结束直播吗？"), roomAudienceCount];
            
            ESWeakSelf;
            [alert showTitle:title confirmTitle:ESLocalizedString(@"结束直播") cancelTitle:ESLocalizedString(@"继续直播") confirm:^{
                ESStrongSelf;
                
                [_self onHostExitRoom];
            } cancel:nil];
        }
    }
    else
    {
        [self onHostExitRoom];
    }
    
    if (chatNavigationController) {
        // 正在聊天时主播退出直播
        [self closeChat];
    }
}

// 退出房间
- (void)onHostExitRoom
{
    // 注销连麦
//    if (_kit.rtcClient.authString) {
//        [_kit.rtcClient unRegisterRTC];
//    }
    if (_streamingSession && _streamingSession.rtcState == PLRTCStateConferenceStarted) {
        [_streamingSession stopConference];
    }
    
    // 停止推流
    if (_streamingSession) {
        [_streamingSession stopStreaming];
    }
    
//    [_kit stopPreview];
    [_streamingSession.previewView removeFromSuperview];
//    _kit = nil;
    _streamingSession = nil;
    
    // 注销监听器
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if ([LuxuryManager luxuryManager].luxuryArray && [LuxuryManager luxuryManager].luxuryArray.count > 0) {
        [[LuxuryManager luxuryManager].luxuryArray removeAllObjects];
    }
    
    [LuxuryManager luxuryManager].isShowAnimation = NO;
    [[DriveManager shareInstance] clearAnimation];
    
    if ([LCMyUser mine].liveType == LIVE_DOING) {
        [self stopUpdateStreamStateTimer];
    }
    
    [self sendDelUser:[LCMyUser mine].userID result:nil];
    
    [self avExitChat];
}
#pragma 直播结束

- (void)showFinishViewWithAudienceCount:(int)audienceCount withRecMoney:(int)recMoneyCount withPraiseCount:(int)praiseCount
{
    [_livingView.messageTextField resignFirstResponder];
    
    _livingView.hidden = YES;
    
    // 直播结束后不再接收消息
    FinishLiveView *fv = [[FinishLiveView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    fv.connectTimeout = connectLiveTimeOut;
    fv.delegate = self;
    
    ESWeakSelf;
    
    CGFloat lastTime = 0;
    [[Business sharedInstance] getHotLives:lastTime succ:^(NSString *msg, id data)
     {
         ESStrongSelf;
         
         if (lastTime == 0)
         {
             // 刷新，如果是加载更多则不用删除旧数据
             [_datas removeAllObjects];
             
         }
         
         if ([[data objectForKey:@"list"] isKindOfClass:[NSArray class]]) {
             [_datas addObjectsFromArray:[data objectForKey:@"list"]];
         }
         
         NSArray *dataArray = (NSArray *)[data objectForKey:@"list"];
         if (dataArray && [dataArray count] > 0)
         {
             NSString *url = [NSString stringWithFormat:@"%@", dataArray[0][@"url"]];
             if ([url rangeOfString:@"http:"].location != NSNotFound)
             {
                 if (dataArray && !dataArray.isEmpty)
                 {
                     for (NSDictionary *dict in dataArray)
                     {
                         NSLog(@"JoyYouLive-getLiveHotData :: dict = %@", dict);
                         
                         [_self preloadUrl:dict[@"url"]];
                     }
                 }
             }
         }
         
         NSLog(@"JoyYouLive-getLiveHotData :: _datas = %@", _datas);
         
         [fv showView:_self.view audience:audienceCount revMoney:recMoneyCount praise:praiseCount hotData:_datas];
         
         
         //         [_self reloadData];
         
         
         // [_self addHotHeadView];
     } fail:^(NSString *error) {
//         ESStrongSelf;
         
     }];
    
    
    
}
- (void)showFinishView:(FinishLiveView *)finishView withHotData:(long)lastTime
{
    
    
}
// 预加载
- (void)preloadUrl:(NSString *)url
{
    if (!url) {
        return;
    }
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:nil
                                                  withPath:url
                                               withRESTful:POST_REQUEST
                                          withSuccessBlock:nil
                                             withFailBlock:nil];
}

- (void)showStartLiveView
{
    
    if (!self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES];
    }
    oldTime = [[NSDate date] timeIntervalSince1970]*1000;
    
    startLiveView = [[StartVideoLiveView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    startLiveView.delegate = self;
    
    [startLiveView showView:self.view];
}


#pragma mark - finishview代理方法

- (void)finishViewClose:(FinishLiveView *)fv
{
    [self dismissController];
}


#pragma mark - 继续直播

- (void)onContinueLive
{
    [LCMyUser mine].isContinueLive = YES;
    
    [self dismissController];
}

// 头像操作
- (void)logoTap:(LivingView *)livingView
{
    // if needed
}

// 点亮操作
- (void)loveTap:(LivingView *)livingView
{
    if (chatNavigationController)
    {
        [self closeChat];
        
        return ;
    }
}


#pragma mark - dismiss view

- (void)dismissController
{
    // 音频输出修改为手机内置扬声器&&麦克风
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    // 开启自动锁屏
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    isFinishView = YES;
    
    [LCMyUser mine].liveUserId = nil;
    [LCMyUser mine].liveType = LIVE_NONE;
    __gSendingMessagesQueue = nil;
    
    [_livingView removeFromSuperview];
    [_pendingMessages removeAllObjects];
    
    if (self.displayLink)
    {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)isHeadsetPluggedIn
{
    AVAudioSessionRouteDescription *route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription *desc in [route outputs])
    {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones])
        {
            return YES;
        }
    }
    
    return NO;
}


#pragma mark - 房间创建成功

- (void)OnRoomCreateComplete
{
    if (isCreateRoom) {
        return;
    }
    
    isCreateRoom = YES;
    
    // 直播用户头像
    NSString *liveLogoPath = [LCMyUser mine].liveUserLogo;
    
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
    
    if(LIVE_DOING == [LCMyUser mine].liveType)
    {
        [self insertLivingData:@""];
        
        // 开启推流心跳检测
        [self startLiveHeartTimer];
        
        // connecting to the socket host
        [self tcpConnectingToHost];
    }
}


#pragma mark - 播放定时检查

#pragma mark - 插入直播数据

- (void)insertLivingData:(NSString *)addr
{
    if (!self.liveTitle) {
        self.liveTitle = @"";
    }
    
    ESWeakSelf;
    
    [[Business sharedInstance] insertLive:self.liveTitle
                                     addr:addr
                                withVdoid:vdoidStr
                                     succ:^(NSString *msg, id data) {
                                         NSLog(@"enter room: %@", data);
                                         ESStrongSelf;
                                         
                                         NSDictionary *info = (NSDictionary *)data;
                                         
                                         NSArray *sysInfoArray = info[@"sys_msg"];
                                         
                                         if ([info[@"recv_diamond"] intValue] > 0) {
                                             [LCMyUser mine].liveRecDiamond = [info[@"recv_diamond"] intValue];
                                         }
                                         
                                         [LCMyUser mine].liveAnchorMedalArray = info[@"anchor_medal"];
                                         
                                         NSLog(@"watch number: %d", [info[@"total"] intValue]);
                                         [LCMyUser mine].liveOnlineUserCount = [info[@"total"] intValue];
                                         
                                         _self->_livingView.userCountLabel.text = [NSString stringWithFormat:@"%d", [info[@"total"] intValue]];
                                         _self->_livingView.activeDict = info[@"act"];
                                         _self->_livingView.mActivtyImageUrl = info[@"act"][@"img"];
                                         
                                         [[IMBridge bridge] joinRoom:[LCMyUser mine].liveUserId completion:^(NSError *error) {
                                             ESStrongSelf;
                                             
                                             NSLogIf(error, @"join room error: %@", error);
                                             
                                             // 直播/观看时关闭自动锁屏
                                             [UIApplication sharedApplication].idleTimerDisabled = YES;
                                             [_self showLivingView:sysInfoArray];
                                             
                                             // 显示主播荣耀
                                             [_self->_livingView showAnchorMedal];
                                             [_self->_livingView connectChatFlag];
                                         }];
                                     } fail:^(NSString *error) {
                                         ESStrongSelf;
                                         
                                         if (!error) {
                                             error = @"";
                                         }
                                         
                                         UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:error preferredStyle:UIAlertControllerStyleAlert];
                                         ESWeakSelf
                                         
                                         UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertViewStyleDefault handler:^(UIAlertAction *_Nonnull action) {
                                             ESStrongSelf;
                                             
                                             [self closeLivingViewWhonHostLeave:YES];
                                             
                                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                 [self dismissViewControllerAnimated:YES completion:nil];
                                             });
                                         }];
                                         
                                         [controller addAction:action];
                                         [self presentViewController:controller animated:YES completion:nil];
                                     }];
}

- (void)toast:(NSString *)message {
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [toast show];
    
    // duration in seconds
    double duration = 0.3;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
}


#pragma mark - status monitor

- (void)initStatData {
    _lastByte    = 0;
    _lastSecond  = [[NSDate date] timeIntervalSince1970];
    _lastFrames  = 0;
    _netEventCnt = 0;
    _raiseCnt    = 0;
    _dropCnt     = 0;
    _startTime   = [[NSDate date] timeIntervalSince1970];
}



#pragma mark - 下麦的事件

- (void)exitUpMikeAction:(LivingView *)livingView
{
    if (!_upMikeUserInfoDict || !_upMikeUserInfoDict[@"uid"]) {
        return;
    }
    
    NSMutableDictionary *msgInfoDict = [NSMutableDictionary dictionary];
    msgInfoDict[@"type"] = LIVE_RTCLIVE_TYPE;
    msgInfoDict[@"upmike_type"] = @(RTCLIVE_EXIT);
    msgInfoDict[@"uid"] = _upMikeUserInfoDict[@"uid"];
    msgInfoDict[@"nickname"] = _upMikeUserInfoDict[@"nickname"];
    
    [LiveMsgManager sendRTCLiveInfo:msgInfoDict andMsgType:LIVE_RTCLIVE_TYPE Succ:nil andFail:nil];
    
    [_streamingSession stopConference];
//  [_kit stopRTCView];
//  if(_kit.rtcClient)
//  {
//      [_kit.rtcClient stopCall];
//      [_kit.rtcClient unRegisterRTC];
//  }
    
//    [_kit.rtcClient stopCall];
    
//    // init with default filter
//    GPUImageOutput<GPUImageInput> *_curFilter = [[KSYGPUBeautifyExtFilter alloc] init];
//    // int val = (nalVal * 5) + 1; // level 1~5
//    [(KSYGPUBeautifyExtFilter *)_curFilter setBeautylevel:5];
//    [_kit setupFilter:_curFilter];
    
    _livingView.exitUpMikeBtn.hidden = YES;
    
    _upMikeUserInfoDict = nil;
    _inviteUserInfoDict = nil;
    
    isSendCall = NO;
}


#pragma mark - 取消邀请

- (void)cancelInviteAction:(LivingView *)livingView
{
    NSMutableDictionary *msgInfoDict = [NSMutableDictionary dictionary];
    msgInfoDict[@"type"] = LIVE_RTCLIVE_TYPE;
    msgInfoDict[@"upmike_type"] = @(RTCLIVE_EXIT);
    msgInfoDict[@"uid"] = _inviteUserInfoDict[@"uid"];
    msgInfoDict[@"nickname"] = _inviteUserInfoDict[@"nickname"];
    
    [LiveMsgManager sendRTCLiveInfo:msgInfoDict andMsgType:LIVE_RTCLIVE_TYPE Succ:nil andFail:nil];
    
    _inviteUserInfoDict = nil;
    _livingView.cancelInviteBtn.hidden = YES;
}


#pragma mark - 处理聊天室消息

- (void)onReceiveGroupMsg:(NSNotification *)notification
{
    RCMessage *rcMessage = notification.object;
    NSString *targetId = [NSString stringWithFormat:@"%@", rcMessage.targetId];
    
    if ([targetId isEqualToString:@"10000"]) {
        // 系统消息
        [self addGroupMessageToQueue:rcMessage];
    }
    
    if (![targetId isEqualToString:[LCMyUser mine].liveUserId] || ![rcMessage.content isKindOfClass:[QCCustomMessage class]])
    {
        return;
    }
    
    [self addGroupMessageToQueue:rcMessage];
}

- (void)addGroupMessageToQueue:(RCMessage *)rcMessage {
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

- (void)dealRoomMsg
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

- (void)showMainThreadDealMsgType:(NSString *)msgType withMsgContent:(NSDictionary *)socketData
{
    if (!_livingView) {
        return;
    }
    
    if ([msgType isEqualToString:LIVE_RTCLIVE_TYPE])
    {
        int upMikeType = [socketData[@"upmike_type"] intValue];
        
        if (upMikeType == RTCLIVE_AGREE_INVITE) {
            // 同意上麦
            _upMikeUserInfoDict = socketData;
        } else if (upMikeType == RTCLIVE_REJECT_INVITE) {
            // 拒绝上麦
            _upMikeUserInfoDict = nil;
            _inviteUserInfoDict = nil;
            
            isSendCall = NO;
            _livingView.cancelInviteBtn.hidden = YES;
            [LCNoticeAlertView showMsg:[NSString stringWithFormat:@"%@ 拒绝上麦！", socketData[@"nickname"]]];
        } else if (upMikeType == RTCLIVE_REGISTER_FAIL) {
            // 注册失败
            _upMikeUserInfoDict = nil;
            _inviteUserInfoDict = nil;
            
            isSendCall = NO;
            [LCNoticeAlertView showMsg:[NSString stringWithFormat:@"%@ 上麦失败！", socketData[@"nickname"]]];
        } else if (upMikeType == RTCLIVE_REGISTER_SUCC) {
            // 注册成功，开始呼叫
            _upMikeUserInfoDict = socketData;
            [self startRTCCall];
            NSLog(@"123fds");
            
        } else if (upMikeType == RTCLIVE_CALL_SUCC) {
            // 呼叫成功
            // 更新livingView，允许玩家下麦
            _livingView.exitUpMikeBtn.hidden = NO;
            _livingView.cancelInviteBtn.hidden = YES;
            
            [_livingView updateShowMsgArea:YES withEixtUpMike:NO];
        } else if (upMikeType == RTCLIVE_CALL_FAIL) {
            // 呼叫失败
            _upMikeUserInfoDict = nil;
            _inviteUserInfoDict = nil;
            
            isSendCall = NO;
            [LCNoticeAlertView showMsg:[NSString stringWithFormat:@"%@ 上麦失败！", socketData[@"nickname"]]];
        } else if (upMikeType == RTCLIVE_EXIT) {
            // 下麦
            _upMikeUserInfoDict = nil;
            _inviteUserInfoDict = nil;
            
            isSendCall = NO;
            _livingView.exitUpMikeBtn.hidden = YES;
            
            [_livingView updateShowMsgArea:NO withEixtUpMike:YES];
            
            
        }
    } else {
        if ([msgType isEqualToString:LIVE_GROUP_ENTER_ROOM]) {
            if ([socketData[@"total"] intValue] > 0 && [socketData[@"total"] intValue] > [LCMyUser mine].liveOnlineUserCount) {
                [LCMyUser mine].liveOnlineUserCount = [socketData[@"total"] intValue];
                roomAudienceCount = [LCMyUser mine].liveOnlineUserCount;
            } else {
                [LCMyUser mine].liveOnlineUserCount++;
                roomAudienceCount = [LCMyUser mine].liveOnlineUserCount;
            }
        } else if([msgType isEqualToString:LIVE_GROUP_CHAT_MSG]) {
            // if needed
        } else if([msgType isEqualToString:LIVE_GROUP_EXIT_ROOM]) {
            NSString *userId = socketData[@"uid"];
            
            if ([LCMyUser mine].liveOnlineUserCount > 0) {
                [LCMyUser mine].liveOnlineUserCount--;
                // roomAudienceCount = [LCMyUser mine].liveOnlineUserCount;
            }
            
            // 主播离开
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
            // if needed
        } else if ([msgType isEqualToString:LIVE_GROUP_GIFT]) {
            int recvDiamond = [socketData[@"recv_diamond"] intValue];
            
            if (recvDiamond > [LCMyUser mine].liveRecDiamond) {
                [LCMyUser mine].liveRecDiamond = recvDiamond;
            }
            
            if ([socketData[@"gift_type"] intValue] == GIFT_TYPE_CONTINUE) {
                // 连续
                if ([LCMyUser mine].liveType == LIVE_DOING) {
                    int price = [socketData[@"price"] intValue];
                    roomRecMoneyCount += price;
                }
            } else if ([socketData[@"gift_type"] intValue] == GIFT_TYPE_REDPACKET) {
                // 红包
            } else if ([socketData[@"gift_type"] intValue] == GIFT_TYPE_LUXURY) {
                // 豪华礼物
                if ([LCMyUser mine].liveType == LIVE_DOING)
                {
                    int price = [socketData[@"price"] intValue];
                    
                    roomRecMoneyCount += price;
                }
            }
        }
        
        [_livingView showDealGroupMsgType:msgType withMsgContent:socketData];
    }
}


#pragma mark - 推流心跳

- (void)startLiveHeartTimer
{
    if (!liveHeartTimer)
    {
        [liveHeartTimer invalidate];
        liveHeartTimer = [NSTimer scheduledTimerWithTimeInterval:HEART_TIME target:self selector:@selector(commitLiveHeart) userInfo:nil repeats:YES];
    }
}

// 关闭定时器
- (void)stopLiveHeartTimer
{
    if (liveHeartTimer) {
        [liveHeartTimer invalidate];
        liveHeartTimer = nil;
    }
}

// 提交推流心跳
- (void)commitLiveHeart
{
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"total":@([LCMyUser mine].liveOnlineUserCount)}
                                                  withPath:URL_LIVE_HEART
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:nil
                                             withFailBlock:nil];
}


#pragma mark - 更新推流定时器

- (void)startUpdateStreamStateTimer
{
    if (!liveDataTimer) {
        liveDataTimer = [NSTimer scheduledTimerWithTimeInterval:1.2
                                                         target:self
                                                       selector:@selector(updateStat:)
                                                       userInfo:nil
                                                        repeats:YES];
    }
}

- (void)stopUpdateStreamStateTimer
{
    livePushBreakCount = 0;
    liveReconnectCount = 0;
    
    if (liveDataTimer) {
        [liveDataTimer invalidate];
        liveDataTimer = nil;
    }
}


#pragma mark - 推流监听

- (NSString*)sizeFormatted:(int)KB {
    if (KB > 1000)
    {
        double MB = KB / 1000.0;
        
        return [NSString stringWithFormat:@"%4.2f MB", MB];
    }
    else {
        return [NSString stringWithFormat:@"%d KB", KB];
    }
}

- (void)updateStat:(NSTimer *)theTimer
{
    if (_streamingSession.streamState == PLStreamStateConnected)
    {
        livePushBreakCount = 0;
        liveReconnectCount = 0;
        
        if (_netTimeOut == 0)
        {
            _netEventRaiseDrop = @" ";
        }
        else
        {
            _netTimeOut--;
        }
    } else {
        if (livePushBreakCount == 0) {
            livePushBreakCount = 1;
        } else {
            livePushBreakCount++;
        }
        
        if (livePushBreakCount >= 5) {
            livePushBreakCount = 0;
            
            if (liveReconnectCount == 0) {
                liveReconnectCount = 1;
            } else {
                liveReconnectCount ++;
            }
            
            NSLog(@"live reconnect count: %d", liveReconnectCount);
//            if (liveReconnectCount <= LIVE_RECONNECT_COUNT) {
//                // 开始重连
//                [_kit.streamerBase stopStream];
//                [_kit.streamerBase startStream:_hostURL];
//                [self initStatData];
//            } else {
//                // 重联3次未成功，退出重新开始
//                [self closeLivingViewWhonHostLeave:YES];
//            }
        }
        
        NSLog(@"livePushBreakCount: %d", livePushBreakCount);
    }
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}

#pragma mark - 连麦delegate

- (void)mediaStreamingSession:(PLMediaStreamingSession *)session userID:(NSString *)userID didAttachRemoteView:(UIView *)remoteView {
    remoteView.frame = CGRectMake(0, 0, 108, 192);
    remoteView.clipsToBounds = YES;
    [self.view addSubview:remoteView];
    
}
- (void)mediaStreamingSession:(PLMediaStreamingSession *)session userID:(NSString *)userID didDetachRemoteView:(UIView *)remoteView{
    [remoteView removeFromSuperview];
}
- (void)mediaStreamingSession:(PLMediaStreamingSession *)session rtcDidFailWithError:(NSError *)error{
    NSLog(@"%@",error);
    
}
- (void)mediaStreamingSession:(PLMediaStreamingSession *)session didJoinConferenceOfUserID:(NSString *)userID{
    NSLog(@"%@ enter room",userID);
    
    
}
- (void)mediaStreamingSession:(PLMediaStreamingSession *)session didLeaveConferenceOfUserID:(NSString *)userID{
    NSLog(@"%@ enter room",userID);
    
}

#pragma mark - 取消直播

/**
 StartVideoLiveView 代理方法
 */
- (void)closeLiveVC
{
    if (_streamingSession) {
        [_streamingSession.previewView removeFromSuperview];
    }
    
    [LCMyUser mine].liveType = LIVE_NONE;
    [LCMyUser mine].liveUserId = nil;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- 开始直播
- (void)startLivePush:(NSString *)title
{


    
    [self setStreamingConfigration];
    
    oldTime = [[NSDate date] timeIntervalSince1970] * 1000;
    PLVideoCaptureConfiguration *videoCaptureConfiguration = [PLVideoCaptureConfiguration defaultConfiguration];
    videoCaptureConfiguration.position=AVCaptureDevicePositionFront;
    PLAudioCaptureConfiguration *audioCaptureConfiguration = [PLAudioCaptureConfiguration defaultConfiguration];
    PLVideoStreamingConfiguration *videoStreamingConfiguration = [PLVideoStreamingConfiguration defaultConfiguration];
    PLAudioStreamingConfiguration *audioStreamingConfiguration = [PLAudioStreamingConfiguration defaultConfiguration];
    
    _streamingSession = [[PLMediaStreamingSession alloc] initWithVideoCaptureConfiguration:videoCaptureConfiguration audioCaptureConfiguration:audioCaptureConfiguration videoStreamingConfiguration:videoStreamingConfiguration audioStreamingConfiguration:audioStreamingConfiguration stream:nil];
    _streamingSession.delegate=self;
    _streamingSession.autoReconnectEnable=YES;
    //网络转换
    _streamingSession.monitorNetworkStateEnable=YES;
    
    _streamingSession.connectionChangeActionCallback = ^(PLNetworkStateTransition transition){
        if (transition == PLNetworkStateTransitionWWANToWiFi || transition == PLNetworkStateTransitionUnconnectedToWiFi) {
            return YES;
        }else {
            return NO;
        }
    };
    [_streamingSession enableAdaptiveBitrateControlWithMinVideoBitRate:200*1024];
    _streamingSession.dynamicFrameEnable=YES;
    //美颜
    [_streamingSession setBeautifyModeOn:YES];
    [_streamingSession setBeautify:1.0];
    [_streamingSession setWhiten:1.0];
    [_streamingSession setRedden:0.7];
    
    [self.view insertSubview:_streamingSession.previewView atIndex:0 ];
    
    self.liveTitle = title;
    
    [self OnRoomCreateComplete];
    
    [_streamingSession startStreamingWithPushURL:_hostURL feedback:^(PLStreamStartStateFeedback feedback) {
        if (feedback == PLStreamStartStateSuccess) {
            NSLog(@"Streaming started.");
        }
        else {
            NSLog(@"Oops.");
        }
    }];
    
    UIImage *countDownImage = [UIImage imageNamed:@"image/liveroom/room_start_3"];
    _countDownImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, countDownImage.size.width, countDownImage.size.height)];
    _countDownImg.image = countDownImage;
    _countDownImg.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    [self.view addSubview:_countDownImg];
    _countDownImg.hidden = YES;
    
    // 倒计时动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showCountDownAnimation:3];
    });
    
    [_livingView.audienceTableView loadAudienceData];
}


//#pragma mark - 采集参数设置

- (void) setCaptureCfg {
    // _kit.videoDimension = KSYVideoDimension_16_9__640x360;
    // KSYVideoDimension strDim = KSYVideoDimension_16_9__640x360;
    // if (_kit.videoDimension != strDim) {
    //     _kit.bCustomStreamDimension = YES;
    //     _kit.streamDimension = CGSizeMake(640, 360);
    // }
   /*
    _kit.streamDimension = CGSizeMake(640, 360);
    _kit.videoFPS = 15;
    _kit.cameraPosition = AVCaptureDevicePositionFront;
    // _kit.bInterruptOtherAudio = NO;
    // _kit.bDefaultToSpeaker = YES; // 没有耳机的话音乐播放从扬声器播放
    _kit.videoProcessingCallback = ^(CMSampleBufferRef buf) {
        // if needed
    };
    */
}


//#pragma mark - 推流参数设置

- (void)setStreamingConfigration
{
    
    NSString *rtmpSrv  = @"rtmp://live.hainandaocheng.com/live";
    if ([LCMyUser mine].uplive_url) {
        rtmpSrv = [LCMyUser mine].uplive_url;
    }
    NSString *url = [NSString stringWithFormat:@"%@/%@", rtmpSrv, [LCMyUser mine].liveUserId];
    // 时间戳
    vdoidStr = [NSString stringWithFormat:@"%ld", (long)time(NULL)];
    url = [url stringByAppendingFormat:@"?vdoid=%@", vdoidStr];
    _hostURL = [[NSURL alloc] initWithString:url];
    NSLog(@"%@",_hostURL.absoluteString);
    [self setVideoOrientation];
}


//#pragma mark - 连麦参数设置
#warning 连麦状态需要修改
- (void)setRtcSteamerCfg
{
    /*
    // 设置ak/sk鉴权信息，本demo从testAppServer获取，客户请从自己的appServer获取
    _kit.rtcClient.authString = nil;
    // 设定公司后缀
    _kit.rtcClient.uniqName = @"HuoWuLive";
    // 设置音频采样率
    _kit.rtcClient.sampleRate = 44100;
    // 设置视频帧率
    _kit.rtcClient.videoFPS = 15;
    // 是否打开rtc日志
    _kit.rtcClient.openRtcLog = YES;
    // 设置端对端视频的宽高
    _kit.rtcClient.videoWidth = 360;
    _kit.rtcClient.videoHeight = 640;
    // 设置rtc传输码率
    // _kit.rtcClient.AvgBps = 256000;
    _kit.rtcClient.MaxBps = 256000;
    // 设置消息传输模式，tls为推荐
    _kit.rtcClient.rtcMode = 1;
    // 设置小窗口的大小和显示
    _kit.winRect = CGRectMake(0.67, 0.61, 0.3, 0.3);
    _kit.rtcLayer = 4;
    
    ESWeakSelf;
    
    __weak KSYRTCStreamerKit *weak_kit = _kit;
    _kit.rtcClient.onRegister = ^(int status) {
        NSString *message = [NSString stringWithFormat:@"local sip account: %@", weak_kit.rtcClient.authUid];
        NSLog(@"register callback: %d \n message: %@", status, message);
        
        ESStrongSelf;
        
        ESDispatchOnMainThreadAsynchrony(^{
            ESStrongSelf;
            
            if (status == 200) {
                _self->isRegisterRTCSucc = YES;
                [_self sendInviteUpMikeMsg];
            } else {
                _self->isAlreadyRegister = NO;
                _self->isRegisterRTCSucc = NO;
                
                _self.inviteUserInfoDict = nil;
                _self->_livingView.cancelInviteBtn.hidden = YES;
                
                [LCNoticeAlertView showMsg:@"邀请失败，请重新邀请！"];
            }
        });
    };
    
    _kit.rtcClient.onUnRegister = ^(int status) {
        NSLog(@"unregister callback: %d", status);
    };
    
    _kit.rtcClient.onCallInComing = ^(char *remoteURI) {
        NSString *text = [NSString stringWithFormat:@"有呼叫到来，id: %s", remoteURI];
        NSLog(@"%@", text);
        
        [weak_self onRtcAnswerCall];
    };
    
    _kit.rtcClient.onEvent = ^(int type, void *detail) {
        // if needed
    };
    
    _kit.onCallStart = ^(int status) {
        ESStrongSelf;
        
        if (status == 200)
        {
            if ([UIApplication sharedApplication].applicationState != UIApplicationStateBackground)
            {
                _self->isCallSucc = YES;
                
                ESDispatchOnMainThreadAsynchrony(^{
                    ESStrongSelf;
                    
                    // init with default filter
                    GPUImageOutput<GPUImageInput> *_curFilter = [[KSYGPUBeautifyExtFilter alloc] init];
                    // int val = (nalVal * 5) + 1; // level 1~5
                    [(KSYGPUBeautifyExtFilter *)_curFilter setBeautylevel:5];
                    
                    [_self->_kit setupRtcFilter:_curFilter];
                    
                    // 更新livingView，允许玩家下麦
                    [_self->_livingView showExitUpMikeAction];
                    _self->_livingView.cancelInviteBtn.hidden = YES;
                    
                    NSMutableDictionary *msgInfoDict = [NSMutableDictionary dictionary];
                    msgInfoDict[@"type"] = LIVE_RTCLIVE_TYPE;
                    msgInfoDict[@"upmike_type"] = @(RTCLIVE_CALL_SUCC);
                    msgInfoDict[@"uid"] = _self.upMikeUserInfoDict[@"uid"];
                    msgInfoDict[@"nickname"] = _self.upMikeUserInfoDict[@"nickname"];
                    
                    [LiveMsgManager sendRTCLiveInfo:msgInfoDict andMsgType:LIVE_RTCLIVE_TYPE Succ:nil andFail:nil];
                    
                    [_self->_livingView updateShowMsgArea:YES withEixtUpMike:NO];
                });
                
                NSLog(@"建立连接: %d", status);
            }
        }
        else if (status == 408) {
            _self->isSendCall = NO;
            _self->isCallSucc = NO;
            
            ESStrongSelf;
            
            ESDispatchOnMainThreadAsynchrony(^{
                ESStrongSelf;
                
                _self.upMikeUserInfoDict = nil;
                _self.inviteUserInfoDict = nil;
                
                [LCNoticeAlertView showMsg:@"上麦失败！"];
            });
            
            NSLog(@"对方无应答: %d", status);
        }
        else if (status == 404) {
            _self->isSendCall = NO;
            _self->isCallSucc = NO;
            
            ESStrongSelf;
            
            ESDispatchOnMainThreadAsynchrony(^{
                ESStrongSelf;
                
                _self.upMikeUserInfoDict = nil;
                _self.inviteUserInfoDict = nil;
                
                [LCNoticeAlertView showMsg:@"上麦失败！"];
            });
            
            NSLog(@"呼叫未注册号码，主动停止: %d", status);
        } else {
            _self->isCallSucc = NO;
        }
        
        NSLog(@"call callback: %d", status);
    };
    
    _kit.onCallStop = ^(int status) {
        ESStrongSelf;
        
        if (status == 200)
        {
            ESDispatchOnMainThreadAsynchrony(^{
                ESStrongSelf;
                
                _self->isSendCall = NO;
                
                _self.upMikeUserInfoDict = nil;
                _self.inviteUserInfoDict = nil;
                
                _self->_livingView.exitUpMikeBtn.hidden = YES;
                _self->_livingView.cancelInviteBtn.hidden = YES;
                // [_self->_kit stopRTCView];
            });
            
            if ([UIApplication sharedApplication].applicationState != UIApplicationStateBackground)
            {
                NSLog(@"断开连接: %d", status);
            }
            
            if (_self->isStopCall) {
                [_self onHostExitRoom];
            } else {
                _self->isCallSucc = NO;
            }
        } else if (status == 408) {
            NSLog(@"408超时");
            if (_self->_kit) {
                // [_self->_kit.rtcClient stopCall];
            }
            
            ESStrongSelf;
            
            _self->isCallSucc = NO;
        }
        
        NSLog(@"oncallstop: %d", status);
    };
     */
}

- (void)onRtcAnswerCall {
//    int ret = [_kit.rtcClient answerCall];
    
//    NSLog(@"应答: %d", ret);
}


#pragma mark - 连麦

- (void)startRegister:(NSString *)authString withQueryDomainString:(NSString *)queryDomainString
{
//    if (isAlreadyRegister) {
//        return;
//    }
//    
//    isAlreadyRegister = YES;
//    isSendCall = NO;
//    _kit.rtcClient.authString = authString;
//    // _kit.rtcClient.queryDomainString = [NSString stringWithFormat:@"%@/%@", queryDomainString, @"querydomain"];
//    _kit.rtcClient.localId = [LCMyUser mine].liveUserId;
//    
//    int ret = [_kit.rtcClient registerRTC];
//    NSLog(@"start register: %@ return: %d", _kit.rtcClient.localId, ret);
}

- (void)startRTCCall {
    if (!_upMikeUserInfoDict || !_upMikeUserInfoDict[@"uid"]) {
        return;
    }
    
    if (isSendCall) {
        return;
    }
    
    isSendCall = YES;
    
    NSString *remoteID = _upMikeUserInfoDict[@"uid"];
    NSLog(@"%@",[PLStreamingSession versionInfo]);
    PLRTCConfiguration *configuration = [PLRTCConfiguration defaultConfiguration];
    [_streamingSession startConferenceWithRoomName:[LCMyUser mine].userID userID:[LCMyUser mine].userID roomToken:token rtcConfiguration:configuration];
    //如果是主播，需要推流，则需要设置连麦者在合流画面中的位置
     _streamingSession.rtcMixOverlayRectArray = [NSArray arrayWithObjects:[NSValue valueWithCGRect:CGRectMake(244, 448, 108, 192)], [NSValue valueWithCGRect:CGRectMake(244, 256, 108, 192)], nil];
    
    
}



- (UIImage *)imageFromString:(NSString *)string attributes:(NSDictionary *)attributes size:(CGSize)size
{
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    textLabel.text = string;
    textLabel.textColor = [UIColor whiteColor];
    textLabel.font = [UIFont boldSystemFontOfSize:20];
    
    UIGraphicsBeginImageContextWithOptions(textLabel.size, NO, 0);
    // [string drawInRect:CGRectMake(0, 0, size.width, size.height) withAttributes:attributes];
    [textLabel.layer drawInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)setVideoOrientation {
    UIInterfaceOrientation orien = [[UIApplication sharedApplication] statusBarOrientation];
    _streamingSession.videoOrientation = orien;
}

- (void)addObservers {
    // KSYStreamer state changes
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(onCaptureStateChange:)
//                                                 name:KSYCaptureStateDidChangeNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(onStreamStateChange:)
//                                                 name:KSYStreamStateDidChangeNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(onNetStateEvent:)
//                                                 name:KSYNetStateEventNotification
//                                               object:nil];
    
    ESWeakSelf;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:Notification_Live_Ban object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *_Nonnull note) {
        ESStrongSelf;
        
        [_self closeLivingViewWhonHostLeave:YES];
    }];
}

//- (void)rmObservers {
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:KSYCaptureStateDidChangeNotification
//                                                  object:nil];
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:KSYStreamStateDidChangeNotification
//                                                  object:nil];
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:KSYNetStateEventNotification
//                                                  object:nil];
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:Notification_Live_Ban];
//}


#pragma mark - state machine(state transition)

- (void)onCaptureStateChange:(NSNotification *)notification
{
//    if ( _kit.captureState == KSYCaptureStateIdle) {
//        // [_btnPreview setTitle:@"开始预览" forState:UIControlStateNormal];
//    }
//    else if (_kit.captureState == KSYCaptureStateCapturing) {
//        // [_btnPreview setTitle:@"停止预览" forState:UIControlStateNormal];
//        if (_kit.streamerBase.streamState != KSYStreamStateConnected)
//        {
//            // 采集开始后进行推流
//            NSLog(@"%@",_hostURL.absoluteString);
//            [_kit.streamerBase startStream:_hostURL];
//            
//            [self initStatData];
//        }
//    }
//    else if (_kit.captureState == KSYCaptureStateClosingCapture) {
//        // _statLabel.text = @"closing capture";
//    }
//    else if (_kit.captureState == KSYCaptureStateDevAuthDenied) {
//        // _statLabel.text = @"camera/mic Authorization Denied";
//    }
//    else if (_kit.captureState == KSYCaptureStateParameterError) {
//        // _statLabel.text = @"capture devices ParameterError";
//    }
//    else if (_kit.captureState == KSYCaptureStateDevBusy) {
//        // _statLabel.text = @"device busy, please try later";
//    }
//    
//    NSLog(@"newCapState: %lu", (unsigned long)_kit.captureState);
}



- (void)onNetStateEvent:(NSNotification *)notification {
//    KSYNetStateCode netEvent = _kit.streamerBase.netStateCode;
//    NSLog(@"net event: %ld", (unsigned long)netEvent);
//    
//    if (netEvent == KSYNetStateCode_SEND_PACKET_SLOW) {
//        _netEventCnt++;
//        
//        if (_netEventCnt % 10 == 9) {
//            // [self toast:@"bad network"];
//        }
//        
//        NSLog(@"bad network");
//    }
//    else if (netEvent == KSYNetStateCode_EST_BW_RAISE) {
//        _netEventRaiseDrop = @"raising";
//        _raiseCnt++;
//        _netTimeOut = 5;
//        
//        NSLog(@"bitrate raising");
//    }
//    else if (netEvent == KSYNetStateCode_EST_BW_DROP) {
//        _netEventRaiseDrop = @"dropping";
//        _dropCnt++;
//        _netTimeOut = 5;
//        
//        NSLog(@"bitrate dropping");
//    }
}

- (void)onStreamStateChange:(NSNotification *)notification {
//    NSString *stateChangeStr = nil;
//    // [_btnPreview setEnabled:NO];
//    // [_btnTStream setEnabled:NO];
//    if ( _kit.streamerBase.streamState == KSYStreamStateIdle) {
//        stateChangeStr = @"idle";
//        
//        // [_btnPreview setEnabled:TRUE];
//        // [_btnTStream setEnabled:TRUE];
//        // [_btnTStream setTitle:@"开始推流" forState:UIControlStateNormal];
//    }
//    else if (_kit.streamerBase.streamState == KSYStreamStateConnected) {
//        stateChangeStr = @"connected";
//        [self startUpdateStreamStateTimer];
//        [self OnRoomCreateComplete];
//        
//        // [_btnTStream setEnabled:TRUE];
//        // [_btnTStream setTitle:@"停止推流" forState:UIControlStateNormal];
//    }
//    else if (_kit.streamerBase.streamState == KSYStreamStateConnecting) {
//        stateChangeStr = @"kit connecting";
//    }
//    else if (_kit.streamerBase.streamState == KSYStreamStateDisconnecting) {
//        stateChangeStr = @"disconnecting";
//    }
//    else if (_kit.streamerBase.streamState == KSYStreamStateError) {
//        [self onStreamError:_kit.streamerBase.streamErrorCode];
//    }
//    
//    NSLog(@"newState: %lu [%@]", (unsigned long)_kit.streamerBase.streamState, stateChangeStr);
}

@end
