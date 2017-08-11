//
//  WatchCutLiveViewController.m
//  qianchuo
//
//  Created by jacklong on 16/8/14.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "WatchCutLiveViewController.h"
#import "WatchCutLiveViewController+GuesterPan.h"
#import "LiveChatView.h"

#import "DriveManager.h"
#import "ChatUtil.h"
#import "LivingView.h"
#import "LiveAlertView.h"
#import "FinishLiveView.h"
#import "TopsRankControlView.h"

#import <libksygpulive/libksygpuimage.h>
#import <libksygpulive/libksygpulive.h>

#import <PLPlayerKit/PLPlayerKit.h>
#import <PLMediaStreamingKit/PLMediaStreamingKit.h>

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
#import "LiveChatListViewController.h"
#import "LiveChatDetailViewController.h"
#import "AnimationFireworksView.h"
#import "ShowWebViewController.h"
#import "CaptureUtil.h"
#import "CaptureStreamUtil.h"
#import "RTCLiveViewController.h"

//录屏
#import "PlaybackView.h"
#import "UploadProgressView.h"
//小游戏（观众端）
#import "CocoaAsyncSocket.h"

static const float writeDataTimeOut     = 2.0f;
static const float readDataTimeOut      = 10.0f;
static const int commandBindTag         = 101;
//static const int commandCreateTag       = 102;
static const int commandEneterTag       = 103;
//static const int commandNewTag          = 104;
static const int commandLeaveTag        = 105;
static const int commandBetTag          = 106;
static const int commandCloseTag        = 107;



#define HIDEN_DISTANCE  50
#define SHOW_DISTANCE   20

#define HEART_TIME      15
#define STOP_CONNECT_VIDEO_TIME HEART_TIME*1000

#define LIVE_PLAY_FINISH 6 // 主播非正常退出时间

#define LIVE_RECONNECT_COUNT 3 // 直播重联次数

enum NETWORK_STATUS {
    NETWORK_CONN = 0,
    NETWORK_FAIL,
    NETWORK_DISCONN
};


@interface WatchCutLiveViewController ()<LivingViewDelegate,FinishLiveViewDelegate, UIGestureRecognizerDelegate,PlaybackViewDelegate,PLPlayerDelegate,PLMediaStreamingSessionDelegate,GCDAsyncSocketDelegate>

{
    //    BOOL isStartPushOkState;
    //    BOOL isShowStartLiveDetail;
    BOOL isPauseLive;// 正在看直播同时打开主播的点播 暂停直播
    BOOL isLivingShowState;
    BOOL isLoveEnd;
    BOOL isCountDownStopAnimation;
    BOOL isFirstLoad;
    BOOL isCreateRoom;
    BOOL isExitRoom;
    BOOL isFinishView;
    BOOL isHostLeaveRoom;
    BOOL connectLiveTimeOut;// 链接超时
    BOOL isAgreeUpMike;// 是否已经同意上麦了
    BOOL isCancelUpMike;// 取消玩家上麦（时间差）
    BOOL isExitUpMike;// 主播已经你取消上麦了
    int roomAudienceCount;// 看过的人数
    int roomRecMoneyCount;// 收到钻石
    int roomPraiseCount;  // 点亮
    
    int liveTimeCount;    // 直播时间统计
    
    int livePushBreakCount;// 推流断开的统计（设置金山自身重联时间）
    int liveReconnectCount;// 视频流重联次数（自身重联）
    
    NSTimeInterval oldTime;    // 直播退到后天时间
    
    NSTimer        *liveCountTimer;   //  直播计时
    
    // 推流地址 完整的URL
    NSURL          *_hostURL;
    
    
    UIImageView         *_faceFloatImgView;
    UIVisualEffectView  *_effectview;// 模糊效果
    
    // 播放直播
    KSYMoviePlayerController *_player;
//    PLPlayer                 *_plplayer;
    
    UILabel  *IDLabel;
    
    UILabel  *_statLabel;
    UIButton *_closeBtn;
    
    NSTimer *startPlayTimer;
    NSTimer *liveHeartTimer;// 推流心跳
    NSTimeInterval lastCheckTime;
    
    
    NSTimer     *liveDataTimer;// 数据流监听计时器
    
    NSTimer     *livePlayerTimer;// 播放计时器
    NSString    *serverIp;// 播放端ip
    
    NSDictionary    *roomInfoDict;// 房间信息
    
    FinishLiveView *anchorFinisLiveView;// 主播结束直播
    
    NSString *authString;
    NSString *queryDomainString;
    
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
    NSString    *ipURL;
    
    dispatch_queue_t __gSendingMessagesQueue;
    UserSpaceViewController *spaceViewController;
    
    UINavigationController *chatNavigationController;
    
    UIAlertView *alertInviteDialog;
    //录屏
    PlaybackView  *playbackView;
//    UIProgressView *progressView;
    UploadProgressView *progressView;
    NSString        *shareUrl;
    BOOL            statusBarHidden;
}


//@property (nonatomic, strong) UILabel *statLabel;

@property (nonatomic, strong) NSMutableArray *pendingMessages;
@property (nonatomic) uint64_t lastSendingTime;
@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic , strong) MBProgressHUD*hubView;


//小游戏
@property (nonatomic, strong) GCDAsyncSocket *asyncSocket;

@property (nonatomic, strong) PLPlayer  *plplayer;
@property (nonatomic, strong) PLMediaStreamingSession *streamingSession;
@property (nonatomic, strong) NSString *token;

@end

@implementation WatchCutLiveViewController


+ (void) ShowWatchLiveViewController:(UINavigationController *)navController withInfoDict:(NSDictionary *)userInfoDict withArray:(NSMutableArray *)arrayInfo withPos:(int)pos
{
    if (!arrayInfo || arrayInfo.count <= 0) {
        arrayInfo = [NSMutableArray array];
        [arrayInfo addObject:userInfoDict];
    }
    
    WatchCutLiveViewController *watchLiveViewController = [[WatchCutLiveViewController alloc ] init];
    [LCMyUser mine].liveUserId = userInfoDict[@"uid"];
    [LCMyUser mine].liveUserName = userInfoDict[@"nickname"];
    [LCMyUser mine].liveUserLogo = userInfoDict[@"face"];
    [LCMyUser mine].liveTime = @"0";
    [LCMyUser mine].liveType = LIVE_WATCH;
    [LCMyUser mine].liveUserGrade = [userInfoDict[@"grade"] intValue];
    watchLiveViewController.playerUrl = userInfoDict[@"url"];
    watchLiveViewController.liveArray = arrayInfo;
    watchLiveViewController.pos = pos;
    [navController pushViewController:watchLiveViewController animated:YES];
}

- (void)dealloc
{
    NSLog(@"mylive dealloc");
    playbackView.delegate = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    __gSendingMessagesQueue = nil;
    if (self.displayLink) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
    _livingView.delegate = nil;
    [LuxuryManager luxuryManager].livingView = nil;
    [DriveManager shareInstance].containerView = nil;
    [_livingView removeFromSuperview];
    _livingView = nil;
    
    _plplayer.delegate=nil;
    _plplayer=nil;
    self.streamingSession=nil;
    [self.view removeFromSuperview];
}

- (id) init
{
    if(self=[super init])
    {
        [self setHidesBottomBarWhenPushed:YES];
        statusBarHidden = NO;
        __gSendingMessagesQueue = dispatch_queue_create("com.qianchuo.ShowMessagesQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initRoomView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveGroupMsg:) name:IMBridgeDidReceiveRoomMessageNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCountOfTotalUnreadMessages:) name:IMBridgeCountOfTotalUnreadMessagesDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LCUserLiveRecDiamondDidChangeNotification:) name:LCUserLiveRecDiamondDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    
    // 分享成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareSuccToSend:) name:kUserShareSuccMsg object:nil];
    
    // 暂停直播
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(liveOnPause) name:HuoWuLive_PAUSE_NOTIFION object:nil];
    
    
    [self enableAudioToSpeaker];
    
    UIPanGestureRecognizer *guestureR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panedView:)];
    guestureR.delegate = self;
    [self.view addGestureRecognizer:guestureR];
    
    //连接socket
    [self tcpConnectingToHost];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([self.livingView.mDrawGiftView isSubview:touch.view]) {
        return NO;
    }
    return YES;
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
    
    if (_livingView.giftView) {// 跳转到聊天页面后需要更新礼物列表
        _livingView.giftView.isUpdateGiftView = YES;
    }
    
    int totalUnread = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
    [self updateUnReadCount:totalUnread];
    
    if (![LuxuryManager luxuryManager].livingView && _livingView) {// 从点播回来重新赋值view
        [LuxuryManager luxuryManager].livingView = _livingView;
    }
    
    isAgreeUpMike = NO;
    
    if (isPauseLive) {
        isPauseLive = NO;
        
        if (_player) {
            [_player reload:_hostURL flush:YES];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self shouldHideStatusBar:NO];
    if (isFinishView)
    {
        if ([LuxuryManager luxuryManager].luxuryArray && [LuxuryManager luxuryManager].luxuryArray.count > 0) {
            [[LuxuryManager luxuryManager].luxuryArray removeAllObjects];
        }
        
        [LuxuryManager luxuryManager].isShowAnimation = NO;
        
        [[DriveManager shareInstance] clearAnimation];
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
        [self.asyncSocket readDataWithTimeout:writeDataTimeOut tag:tag];

    [self reciveData:data];
}
#pragma mark- 游戏


//接受数据
-(void)reciveData:(NSData*)recieveData
{
    //接收到的数据写入本地
    NSDictionary *dict = [NSDictionary dictionaryWithRecievedData:recieveData];
    NSString *cmd = [dict objectForKey:@"type"];
    NSDictionary *body = [dict objectForKey:@"body"];
    NSNumber *status = [body objectForKey:@"status"];
    NSDictionary *data = [body objectForKey:@"data"];
    
    if ([cmd isEqualToString:@"bind"] && [status isEqualToNumber:@(0)]) {
        [self commandEnter];
    }else if ([cmd isEqualToString:@"game_new"] && [status isEqualToNumber:@(0)]) {
        _livingView.gameState = LivingViewShowGameStateReady;
        [_livingView showGameViewWithType:CurrentGameTypeNiuniu];
    }else if ([cmd isEqualToString:@"game_poll"] && [status isEqualToNumber:@(0)]) {
        if (_livingView.gameState != LivingViewShowGameStateReady) {
            _livingView.gameState = LivingViewShowGameStateCounting;
        }
        ESWeakSelf
        [_livingView showGameViewWithType:CurrentGameTypeNiuniu];
        NSInteger timecount = [[data objectForKey:@"timecount"] integerValue];
        [_livingView timeOutCounting:timecount];
        [_livingView betActionWithCompletionHander:^(NSInteger amount, NSInteger index) {
            [weak_self commandBetWithAmount:amount atIndex:index];
        }];
        
    }else if ([cmd isEqualToString:@"game_result"] && [status isEqualToNumber:@(0)]) {
        NSDictionary *resultDict = [data objectForKey:@"result"];
        [_livingView showGameResultWithDict:resultDict];
    }else if ([cmd isEqualToString:@"game_bet"] && [status isEqualToNumber:@(0)]) {
        id betObj = [data objectForKey:@"bet"];
        if ([betObj isKindOfClass:[NSArray class]]) {
            [_livingView showBetActionWithArray:betObj];
        }
    }else if ([cmd isEqualToString:@"bet"] && [status isEqualToNumber:@(0)]) {
        id betObj = [data objectForKey:@"bet"];
        if ([betObj isKindOfClass:[NSArray class]]) {
            [_livingView showMyBetActionWithArray:betObj];
        }
    }
    NSLog(@"接收到的数据:%@",[NSDictionary dictionaryWithRecievedData:recieveData]);
    [self.asyncSocket readDataWithTimeout:readDataTimeOut tag:commandBindTag];
}

/**
 绑定uid
 */
- (void)commandBind
{
    NSLog(@"liveUserId = %@", [LCMyUser mine].liveUserId);
    if ([LCMyUser mine].liveUserId) {
        
        NSDictionary *bindDict = @{@"cmd":@"bind",@"uid":[LCMyUser mine].userID};
        
        [self.asyncSocket writeData:[bindDict socketData]
                        withTimeout:writeDataTimeOut
                                tag:0];
        [self.asyncSocket readDataWithTimeout:readDataTimeOut tag:0];
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
                                tag:0];
//        [self.asyncSocket readDataWithTimeout:readDataTimeOut tag:commandEneterTag];
    }
}

/**
 下注

 @param amount 金额
 @param index 下注点
 */
- (void)commandBetWithAmount:(NSInteger)amount atIndex:(NSInteger)index
{
//    {"cmd":"bet","roomId":房间ID（主播UID）,"uid":用户UID,"coin":"下注金额 整数","pos":"下注位置 0 1 2 三个位置"}
    if ([LCMyUser mine].liveUserId) {
        NSDictionary *betDict = @{@"cmd":@"bet",@"roomId":[LCMyUser mine].liveUserId,@"uid":[LCMyUser mine].userID,@"coin":@(amount),@"pos":@(index)};
        [self.asyncSocket writeData:[betDict socketData] withTimeout:writeDataTimeOut tag:0];
    }
}

/**
 充值
 */
- (void)livingViewDiamondRecharge
{
    RechargeViewController *rechargeVC = [[RechargeViewController alloc] init];
    [self.navigationController pushViewController:rechargeVC animated:YES];
}

/**
 显示历史记录
 */
- (void)livingViewShowHistory
{
//    liveuid=主播ID gid=游戏标识 1=牛牛
    NSDictionary *dict = @{@"liveuid":[LCMyUser mine].liveUserId, @"gid":@(1)};
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:dict withPath:URL_BET_HISTORY withRESTful:GET_REQUEST withSuccessBlock:^(NSDictionary *responseDic) {
        NSLog(@"show history: %@", responseDic);
        [_livingView showHistoryWithData:[responseDic objectForKey:@"data"]];
    } withFailBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 开始直播
- (void)initView
{
    
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
    //#ifdef DEBUG
    //    livePlayerTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updatePlayerStat:) userInfo:nil repeats:YES];
    //#endif
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

#pragma mark - 判断黑名单
- (void) isExitAnchorBlackList
{
    if (![LCMyUser mine].liveUserId) {
        return;
    }
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        if (URL_REQUEST_SUCCESS == [[responseDic objectForKey:@"code"] integerValue])
        {
            NSArray* data = [responseDic objectForKey:@"users"];
            
            NSLog(@"blacklist %@",data);
        }
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        NSLog(@"error :%@",error);
    };
    
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"userId":[LCMyUser mine].liveUserId}
                                                  withPath:@"https://api.cn.ronghub.com/user/blacklist/query.json"
                                               withRESTful:POST_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}

#pragma mark  拖动事件
- (void) handleSwipe:(UIPanGestureRecognizer*) recognizer
{
    if (_livingView.hidden || [LCMyUser mine].liveType == LIVE_DOING || !_livingView.giftView.isHidden) {
        return;
    }
    
    CGPoint translation = [recognizer translationInView:_livingView];
    
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
                    _livingView.closeBtn.hidden = YES;
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
            _livingView.left += translation.x;
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
    [self closeRoomAction];
}

- (void) closeRoomAction
{
    isHostLeaveRoom = NO;
    
    if (_livingView.contentTextField) {
        [_livingView.contentTextField resignFirstResponder];
    }
    
    [self startLeaveRoom];
}

#pragma mark - 开始退出房间
- (void) startLeaveRoom
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    // 直播结束通知
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Live_End object:nil];
    [self onHostExitRoom];
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
    if (isLoveEnd) {
        [_livingView addLove:1 withLightPos:0];
        return;
    }
    isLoveEnd = YES;
    
    [self sendPraise:1];
}


#pragma mark - 请求上麦
- (void) upMikeAction:(LivingView *)livingView
{
    ESWeakSelf;
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"live":[LCMyUser mine].userID} withPath:URL_LIVE_UPMIKE withRESTful:GET_REQUEST withSuccessBlock:^(NSDictionary *responseDic) {
        ESStrongSelf;
        NSLog(@"res %@", responseDic);
        _self->authString = [responseDic objectForKey:@"url"];
        _self->queryDomainString = [responseDic objectForKey:@"domain_url"];
        if (_self->authString && _self->queryDomainString)
        {
            [self startUpMike];
        }
        else
        {
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
    } withFailBlock:^(NSError *error) {
        [LCNoticeAlertView showMsg:@"请求服务器失败"];
    }];
}



- (void) startUpMike
{
    
    PLVideoCaptureConfiguration *videoCaptureConfiguration = [PLVideoCaptureConfiguration defaultConfiguration];
    videoCaptureConfiguration.position=AVCaptureDevicePositionFront;
    PLAudioCaptureConfiguration *audioCaptureConfiguration = [PLAudioCaptureConfiguration defaultConfiguration];
   
//    PLVideoStreamingConfiguration *videoStreamingConfiguration = [PLVideoStreamingConfiguration defaultConfiguration];
//    PLAudioStreamingConfiguration *audioStreamingConfiguration = [PLAudioStreamingConfiguration defaultConfiguration];
    
    if(!self.streamingSession)
    self.streamingSession = [[PLMediaStreamingSession alloc] initWithVideoCaptureConfiguration:videoCaptureConfiguration audioCaptureConfiguration:audioCaptureConfiguration videoStreamingConfiguration:nil audioStreamingConfiguration:nil stream:nil];
    NSLog(@"%@ %@ %@",[LCMyUser mine].liveUserId,[LCMyUser mine].userID,self.token);
    PLRTCConfiguration *configuration = [PLRTCConfiguration defaultConfiguration];
    

    
    
    
    ESWeakSelf;
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"live":[LCMyUser mine].liveUserId , @"liveuid":[LCMyUser mine].liveUserId , @"user":[LCMyUser mine].userID} withPath:URL_LIVE_SIGNMIKE withRESTful:GET_REQUEST withSuccessBlock:^(NSDictionary *responseDic) {
        ESStrongSelf;
        
       
        
        NSLog(@"res %@", responseDic);
        long state = [responseDic[@"stat"] integerValue];
        
        
        
        if (state == 200)
        {
            self.token=responseDic[@"token"];
            NSLog(@"%@ %@ %@",[LCMyUser mine].liveUserId,[LCMyUser mine].userID,self.token);
            NSLog(@"%@",self.streamingSession);
            [self.streamingSession startConferenceWithRoomName:[LCMyUser mine].liveUserId userID:[LCMyUser mine].userID roomToken:self.token rtcConfiguration:configuration];
            
        }
        else
        {
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
    } withFailBlock:^(NSError *error) {
        ESStrongSelf;
        
        
        
        [LCNoticeAlertView showMsg:@"请求服务器连接失败"];
    }];
    
    

//    [self liveOnPause];
//    
//    RTCLiveViewController *rtcLiveVC = [[RTCLiveViewController alloc] init];
//    [LCMyUser mine].liveType = LIVE_UPMIKE;
//    rtcLiveVC.authString = authString;
//    rtcLiveVC.queryDomainString = queryDomainString;
//    rtcLiveVC.upMikeInfoDict = roomInfoDict;
//    
//    [self.navigationController pushViewController:rtcLiveVC animated:YES];
}
#pragma mark - 连麦delegate
/// @abstract 连麦状态已变更的回调
- (void)mediaStreamingSession:(PLMediaStreamingSession *)session rtcStateDidChange:(PLRTCState)state{

}
/// @abstract 被 userID 从房间踢出
- (void)mediaStreamingSession:(PLMediaStreamingSession *)session didKickoutByUserID:(NSString *)userID{

}
/// @abstract  userID 加入房间
- (void)mediaStreamingSession:(PLMediaStreamingSession *)session didJoinConferenceOfUserID:(NSString *)userID{

}

/// @abstract userID 离开房间
- (void)mediaStreamingSession:(PLMediaStreamingSession *)session didLeaveConferenceOfUserID:(NSString *)userID{

}

#pragma mark - 录屏操作
- (BOOL)prefersStatusBarHidden
{
    return statusBarHidden;
}

- (void)shouldHideStatusBar:(BOOL)hidden
{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        statusBarHidden = hidden;
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}
- (void)recordShouldBegin //录制即将开始
{
    //隐藏状态栏和直播id
    [self shouldHideStatusBar:YES];
    [IDLabel setHidden:YES];
    
    //隐藏livingView显示录制页面
    [self.livingView setHidden:YES];
    [self.livingView setUserInteractionEnabled:NO];
    if (![self.view findViewWithClassInSubviews:[PlaybackView class]]) {
        
        playbackView = [[PlaybackView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        playbackView.delegate = self;
        [self.view addSubview:playbackView];
        
    }
    [playbackView recordShouldBegin];
    [playbackView setHidden:NO];
    
}
//- (void)recordDidBegin
- (void)playbackViewRecordDidBegin
{
    //开始录屏
    [[CaptureStreamUtil shareInstance] startCapture];
}
//- (void)recordShouldEnd
- (void)playbackViewRecordShouldEnd
{
    if (!progressView) {
        progressView = [[UploadProgressView alloc] initWithFrame:CGRectMake(40, ScreenHeight-150, ScreenWidth-80, 30)];
        
        [self.view addSubview:progressView];
    }
    
    [progressView setHidden:NO];
    [progressView updateProgress:0];
    ESWeakSelf
    [[CaptureStreamUtil shareInstance] stopCaptureWithCompletionHandler:^(NSString *videoUrl) {
        ESStrongSelf
        [_self recordDidEnd];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUIWithProgress:) name:@"UploadProgressNotification" object:nil];
}
- (void)recordDidEnd
{
    [self shouldHideStatusBar:NO];
    [IDLabel setHidden:NO];
    [playbackView recordDidEnd]; //录制结束上传成功
    [self.livingView setHidden:NO];
    //        [self.livingView captureViewClose];
}

/**
 PlaybackViewDelegate代理方法
 取消录制时调用
 */
- (void)playbackViewRecordDidCancel
{
    playbackView.hidden = YES;
    self.livingView.hidden = NO;
    [self.livingView setUserInteractionEnabled:YES];
}
- (void)recordDidCancelled
{
    //显示直播id 和状态栏
    [IDLabel setHidden:NO];
    [self shouldHideStatusBar:NO];
    //打开手势
    [self.livingView setUserInteractionEnabled:YES];
    //关闭progressview
    if (progressView && !progressView.isHidden) {
        [progressView setHidden:YES];
    }
}
/*- (void)captureShortVideo:(int)isstart
{
    NSLog(@"========= capture video %d",_closeBtn.hidden);
    if (!isstart) {
        //        [[CaptureUtil shareInstance] startCapture];
        [[CaptureStreamUtil shareInstance] startCapture];
        
        //[button setTitle:@"结束" forState:UIControlStateNormal];
    }
    else {
        //        [[CaptureUtil shareInstance] stopCapture];
        
        if (!progressView) {
            progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(40, ScreenHeight-140, ScreenWidth-80, 80)];
            progressView.progressTintColor = RGB16(COLOR_BG_BLUE);
            [self.view addSubview:progressView];
        }
        [progressView setHidden:NO];
        [progressView setProgress:0];
        ESWeakSelf
        [[CaptureStreamUtil shareInstance] stopCaptureWithCompletionHandler:^(NSString *videoUrl) {
            ESStrongSelf
            [self shouldHideStatusBar:NO];
            shareUrl = videoUrl;
            
            [_livingView captureViewClose];
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUIWithProgress:) name:@"UploadProgressNotification" object:nil];
        //[button setTitle:@"录制" forState:UIControlStateNormal];
    }
}*/
- (void)updateUIWithProgress:(NSNotification *)notification
{
    
//    ESWeakSelf;
    CGFloat progress = [notification.object floatValue];
    if (progress >= 1) {
        [progressView setHidden:YES];
        if (!playbackView) {
            
            playbackView = [[PlaybackView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            
            

        }
        [playbackView setHidden:NO];
//        PlaybackView * __weak pbView = playbackView;
        [self.livingView recordFinished];
//        [playbackView cancelActionWithBlock:^(UIButton *sender) {
//            ESStrongSelf
//            [pbView setHidden:YES];
//        }];
        [self.view addSubview:playbackView];
        
    }
    [progressView updateProgress:progress];
//    [progressView setProgress:progress animated:YES];
    [progressView setNeedsDisplay];
}


#pragma amrk - ChatList

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
    [_liveArray addObject:userInfoDict];
    
    WatchCutLiveViewController *watchLiveViewController = [[WatchCutLiveViewController alloc ] init];
    
    watchLiveViewController.liveArray = _liveArray;
    watchLiveViewController.pos = _liveArray.count - 1;
    watchLiveViewController.playerUrl = userInfoDict[@"url"];
    
    [LCMyUser mine].liveUserId = userInfoDict[@"uid"];
    [LCMyUser mine].liveUserName = userInfoDict[@"nickname"];
    [LCMyUser mine].liveUserLogo = userInfoDict[@"face"];
    [LCMyUser mine].liveTime = @"0";
    [LCMyUser mine].liveType = LIVE_WATCH;
    [LCMyUser mine].liveUserGrade = [userInfoDict[@"grade"] intValue];
    
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
        socket[@"type"] = LIVE_GROUP_REMOVE_GAG;                // 消息类型
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
    
    if ([LCMyUser mine].userLevel >= LIVE_USER_GRADE *2) {// 进房特效
        NSMutableDictionary *enterRoomDict = [NSMutableDictionary dictionary];
        enterRoomDict[@"type"] = LIVE_GROUP_ENTER_ROOM;                      // 消息类型
        enterRoomDict[@"uid"] = [LCMyUser mine].userID;        // 用户id
        enterRoomDict[@"nickname"] = [LCMyUser mine].nickname; // 用户昵称
        enterRoomDict[@"grade"] = [NSNumber numberWithInt:[LCMyUser mine].userLevel];  // 用户级别
        
        [_livingView addEnterRoomAnim:enterRoomDict];
    }
    
    if ([LCMyUser mine].zuojia) {// 座驾
        [[DriveManager shareInstance] showDriveAnimation:@{@"zuojia":@([LCMyUser mine].zuojia),
                                                           @"uid":[LCMyUser mine].userID,
                                                           @"nickname":[LCMyUser mine].nickname}];
    }
    
    // 用户进入房间
    [LiveMsgManager sendEnterRoomSucc:^() {
        NSLog();
    } andFail:^() {
    }];
    
    
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



#pragma mark - 分享成功
- (void) shareSuccToSend:(NSNotification*)notficatio {
    if (!_livingView.isHidden) {
        NSMutableDictionary *socket = [NSMutableDictionary dictionary];
        socket[@"type"] = LIVE_GROUP_SHARE;            // 消息类型
        socket[@"msg"] = notficatio.object;
        if (!playbackView.isHidden) {
            [playbackView setHidden:YES];
        }
        _livingView.userInteractionEnabled = YES;
        [_livingView addMessage:nil andUserInfo:socket];
        
        [LiveMsgManager sendMsg:socket andMsgType:LIVE_GROUP_SHARE Succ:nil andFail:nil];
    }
//    [playbackView removeFromSuperview];
}

#pragma mark 切换前后台
#define isIOS7() ([[UIDevice currentDevice].systemVersion doubleValue]>= 7.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 8.0)
- (void)enableAudioToSpeaker
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    });
}


- (void)handleBecomeActive
{
    [self enableAudioToSpeaker];
    
    if (_livingView.allShowGiftView) {
        [_livingView.allShowGiftView startSendGiftViewAnimation];
    }
}

- (void)handleResignActive
{
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
    [[Business sharedInstance] leaveRoom:[LCMyUser mine].liveRoomId
                                   phone:[LCMyUser mine].userID
                                    succ:^(NSString *msg, id data) {
                                        NSLog(@"观众开始退直播 [Business sharedInstance] leaveRoom succ");
                                    }
     
                                    fail:^(NSString *error) {
                                        NSLog(@"观众开始退直播 [Business sharedInstance] leaveRoom失败-->avExitRoom");
                                    }];
    [self avExitRoom];
}

- (void)avExitRoom
{
    if ([LCMyUser mine].liveUserId) {
        //观众退出聊天室
        [[IMBridge bridge] exitRoom:[LCMyUser mine].liveUserId completion:^(NSError *error) {
            [LCMyUser mine].isInChatRoom = NO;
        }];
    }
    
    [self onStopVideo];
    
    if (isHostLeaveRoom) {
        _effectview.hidden = YES;
        _faceFloatImgView.hidden = YES;
        [self releaseOldView];
        [self showFinishViewWithAudienceCount:roomAudienceCount withRecMoney:roomRecMoneyCount withPraiseCount:roomPraiseCount];
    } else {
        [self dismissController];
    }
    
}

#pragma mark - 主播离开
- (void)closeLivingViewWhonHostLeave:(BOOL)connectTimeOut
{
    //删除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    
    
    if (_livingView.contentTextField) {
        [_livingView.contentTextField resignFirstResponder];
    }
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    [self onHostExitRoom];
    
    if (chatNavigationController) {// 正在聊天结果主播退出直播
        [self closeChat];
    }
}

// 退出房间
- (void)onHostExitRoom
{
    [self sendDelUser:[LCMyUser mine].userID
               result:nil];
    [self avExitChat];
}

- (void) showFinishViewWithAudienceCount:(int)audienceCount withRecMoney:(int)recMoneyCount withPraiseCount:(int)praiseCount
{
    [_livingView.messageTextField resignFirstResponder];
    _livingView.hidden = YES;
    // 结束不收消息
    anchorFinisLiveView = [[FinishLiveView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    anchorFinisLiveView.connectTimeout = connectLiveTimeOut;
    anchorFinisLiveView.delegate = self;
    [anchorFinisLiveView showView:self.view audience:audienceCount revMoney:recMoneyCount praise:praiseCount hotData:nil];
}

#pragma mark - finishview 代理
- (void)finishViewClose:(FinishLiveView *)fv
{
    isHostLeaveRoom = NO;
    [self dismissController];
}

#pragma mark - 继续直播
- (void) onContinueLive
{
    [LCMyUser mine].isContinueLive = YES;
    isHostLeaveRoom = NO;
    [self dismissController];
}

#pragma mark - dismiss view
- (void)dismissController
{

    [UIApplication sharedApplication].idleTimerDisabled = NO;// 自动锁屏
    isFinishView = YES;
    
    if (!isHostLeaveRoom) {
        [LCMyUser mine].liveUserId = nil;
    }
    
    [_livingView removeFromSuperview];
    _livingView = nil;
    [_pendingMessages removeAllObjects];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    __gSendingMessagesQueue = nil;
    if (self.displayLink)
    {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
    
    chatNavigationController = nil;
    
//    if ([LCMyUser mine].liveType == LIVE_WATCH) {
        // 关闭直播，弹幕仍然滚动bug
        if (_livingView && _livingView.barrageView) {
            [_livingView.barrageView.barrageFirstView.layer removeAllAnimations];
            [_livingView.barrageView.barrageSecondView.layer removeAllAnimations];
            [_livingView.barrageView.barrageThreeView.layer removeAllAnimations];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        if (self.mFromPush) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }
//    } else {
//        [self dismissViewControllerAnimated:YES
//                                 completion:nil];
//    }
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
        _livingView.gradeFlagImgView.image = [UIImage createUserGradeFlagImage:[LCMyUser mine].liveUserGrade  withIsManager:false];
        _livingView.gradeFlagImgView.hidden = NO;
    } else {
        _livingView.gradeFlagImgView.hidden = YES;
    }
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
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMovieNaturalSizeAvailableNotification)
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
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMovieNaturalSizeAvailableNotification
                                                 object:nil];
}

-(void)handlePlayerNotify:(NSNotification*)notify
{
    if (!_player) {
        return;
    }
    
    if ([MPMediaPlaybackIsPreparedToPlayDidChangeNotification isEqualToString:notify.name]) {
        NSLog(@"player prepared");
        serverIp = [_player serverAddress];
        NSLog(@"%@ -- ip:%@", _hostURL, serverIp);
        [self StartPlayerStatTimer];
        
        uint64_t endTime = mach_absolute_time();
        mach_timebase_info_data_t timebaseInfo;
        (void) mach_timebase_info(&timebaseInfo);
        uint64_t elapsedNano = (endTime - startTime) * timebaseInfo.numer / timebaseInfo.denom;
        double elapsedSeconds = (double)elapsedNano / 1000000000.0;
        NSLog(@"%@ 播放请求时间：%f", ipURL, elapsedSeconds);
    }
    
    if ([MPMoviePlayerPlaybackStateDidChangeNotification isEqualToString:notify.name]) {
        NSLog(@"player playback state: %ld", (long)_player.playbackState);
    }
    
    if ([MPMoviePlayerLoadStateDidChangeNotification isEqualToString:notify.name]) {
        NSLog(@"player load state: %ld", (long)_player.loadState);
        if (_player.loadState == MPMovieLoadStatePlaythroughOK) {
            NSLog(@"playthrough ok");
        } else if (_player.loadState == MPMovieLoadStatePlayable) {
            NSLog(@"load state playable ");
            
        } else if (_player.loadState == MPMovieLoadStateStalled) {
            NSLog(@"load state stalled");
            [_player reload:_hostURL flush:NO];
        } else {
            NSLog(@"load state unknow");
            //            _livingView.livePlayStateLabel.hidden = YES;
            //            [self OnRoomCreateComplete];
            [self showLiveFloatView];
        }
        
        if (MPMovieLoadStateStalled & _player.loadState) {
            NSLog(@"player start caching");
            //            _livingView.livePlayStateLabel.hidden = NO;
        }
        
        if (_player.bufferEmptyCount &&
            (MPMovieLoadStatePlayable & _player.loadState ||
             MPMovieLoadStatePlaythroughOK & _player.loadState)){
                NSLog(@"player finish caching");
            }
    }
    
    if ([MPMoviePlayerPlaybackDidFinishNotification isEqualToString:notify.name]) {
        NSLog(@"player finish state: %ld", (long)_player.playbackState);
        NSLog(@"player download flow size: %f MB", _player.readSize);
        NSLog(@"buffer monitor  result: \n   empty count: %d, lasting: %f seconds",
              (int)_player.bufferEmptyCount,
              _player.bufferEmptyDuration);
        NSLog(@"player finish");
        
        
        int reason = [[[notify userInfo] valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
        if (reason ==  MPMovieFinishReasonPlaybackEnded) {
            NSLog(@"player finish");
        }else if (reason == MPMovieFinishReasonPlaybackError){
            NSLog(@"player Error : %@", [[notify userInfo] valueForKey:@"error"]);
        }else if (reason == MPMovieFinishReasonUserExited){
            NSLog(@"player userExited");
        }else {
            NSLog(@"player error MPMoviePlayerPlaybackDidFinishNotification info:%@",notify);
        }
        
        NSLog(@"MPMoviePlayerPlaybackDidFinishNotification player finish");
        //        isHostLeaveRoom = YES;
        //        if (_livingView.contentTextField) {
        //            [_livingView.contentTextField resignFirstResponder];
        //        }
        //        [self avExitChat];
        //
        //        [self StopPlayerStatTimer];
    }
    
    if ([MPMovieNaturalSizeAvailableNotification isEqualToString:notify.name])
    {
        NSLog(@"video size %.0f-%.0f", _player.naturalSize.width, _player.naturalSize.height);
    }
}




#pragma mark - <PLPlayerDelegate>

/**
 回调将要渲染的帧数据
 该功能只支持直播
 
 @param player 调用该方法的 PLPlayer 对象
 @param frame 将要渲染帧 YUV 数据。
 CVPixelBufferGetPixelFormatType 获取 YUV 的类型。
 软解为 kCVPixelFormatType_420YpCbCr8Planar.
 硬解为 kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange.
 @param pts 显示时间戳 单位ms
 @param sarNumerator 视频流的显示比例
 @param sarDenominator
 其中sar 表示 storage aspect ratio
 视频流的显示比例 sarNumerator sarDenominator
 @discussion sarNumerator = 0 表示该参数无效
 
 @since v2.4.3
 */
- (void)player:(PLPlayer *)player willRenderFrame:(nullable CVPixelBufferRef)frame pts:(int64_t)pts sarNumerator:(int)sarNumerator sarDenominator:(int)sarDenominator
{
    
    NSLog(@"=======================================pts: %lld", pts);
    [[CaptureStreamUtil shareInstance] appendVideoSample:frame presentTimeStamp:pts];
}
- (AudioBufferList *)player:(PLPlayer *)player willAudioRenderBuffer:(nonnull AudioBufferList *)audioBufferList asbd:(AudioStreamBasicDescription)audioStreamDescription pts:(int64_t)pts sampleFormat:(PLPlayerAVSampleFormat)sampleFormat
{
    
    [[CaptureStreamUtil shareInstance] appendAudioSampleWithRenderBuffer:audioBufferList asbd:audioStreamDescription presentTimeStamp:pts];
    return audioBufferList;
}
- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state {
    NSLog(@"%ld",(long)state);
    
}

- (void)player:(nonnull PLPlayer *)player stoppedWithError:(nullable NSError *)error {
//    [self.activityIndicatorView stopAnimating];
//    [self tryReconnect:error];
}
//
//- (void)tryReconnect:(nullable NSError *)error {
//    if (self.reconnectCount < 3) {
//        _reconnectCount ++;
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:[NSString stringWithFormat:@"错误 %@，播放器将在%.1f秒后进行第 %d 次重连", error.localizedDescription,0.5 * pow(2, self.reconnectCount - 1), _reconnectCount] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * pow(2, self.reconnectCount) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.player play];
//        });
//    }else {
//        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
//                                                                           message:error.localizedDescription
//                                                                    preferredStyle:UIAlertControllerStyleAlert];
//            __weak typeof(self) wself = self;
//            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK"
//                                                             style:UIAlertActionStyleCancel
//                                                           handler:^(UIAlertAction *action) {
//                                                               __strong typeof(wself) strongSelf = wself;
//                                                               [strongSelf.navigationController performSelectorOnMainThread:@selector(popViewControllerAnimated:) withObject:@(YES) waitUntilDone:NO];
//                                                           }];
//            [alert addAction:cancel];
//            [self presentViewController:alert animated:YES completion:nil];
//        }
//        else {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//        }
//        [UIApplication sharedApplication].idleTimerDisabled = NO;
//        NSLog(@"%@", error);
//    }
//}

- (void) onPlayVideo
{
    [self showPlayerStatLabel];
    

    
    
    
    if(_plplayer) {
        [_plplayer play];
        [self StartPlayerStatTimer];
        return ;
    }
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    [option setOptionValue:@15 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
    [option setOptionValue:@3 forKey:PLPlayerOptionKeyLogLevel];
    //_plplayer = [PLPlayer in:[NSURL URLWithString:_hostURL] option:option];
    NSLog(@"%@ ||| %@",_playerUrl,[_hostURL absoluteString]);
    NSLog(@"%@",playerVersion());
    _plplayer = [[PLPlayer alloc] initWithURL:_hostURL option:option];
    
    [self.view addSubview:_plplayer.playerView];
    //[self.view sendSubviewToBack:_plplayer.playerView];
    _plplayer.delegate=self;
    _plplayer.delegateQueue=dispatch_get_main_queue();
    [_plplayer play];

}

- (void) liveOnPause
{
    if (_plplayer) {
        isPauseLive = YES;
        [_plplayer pause];
    }
}

- (void)onStopVideo
{
//    if (_player) {
//        NSLog(@"player download flow size: %f MB", _player.readSize);
//        NSLog(@"buffer monitor  result: \n   empty count: %d, lasting: %f seconds",
//              (int)_player.bufferEmptyCount,
//              _player.bufferEmptyDuration);
//        
//        [_player stop];
//        if (_player.view && _player.view.subviews && _player.view.subviews.count > 0) {
//            [_player.view removeFromSuperview];
//        }
//        
//        [self releaseObservers];
//        _player = nil;
//        
//        [self StopPlayerStatTimer];
//        NSLog(@"stop video finish");
//    }
    
        if (_plplayer) {
            
    
            [_plplayer stop];
            if (_player.view && _player.view.subviews && _player.view.subviews.count > 0) {
                [_player.view removeFromSuperview];
            }
    
            
            _plplayer = nil;
    
            [self StopPlayerStatTimer];
            NSLog(@"stop video finish");
        }

}

#pragma mark - 处理聊天室消息
- (void)onReceiveGroupMsg:(NSNotification *)notification
{
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
        if (_self.pendingMessages.isEmpty || !_self->_livingView) {
            return;
        }
        QCCustomMessage *msg = _self.pendingMessages.firstObject;
        [_self.pendingMessages removeObjectAtIndex:0];
        
        if ([msg isKindOfClass:[RCTextMessage class]]) {
            return;
        }
        
        if (!msg || !msg.type || !msg.data) {
            return;
        }
        
        ESDispatchOnMainThreadAsynchrony(^{
            ESStrongSelf;
            [_self showMainThreadDealMsgType:msg.type withMsgContent:msg.data];
        });
    });
}

- (void) showMainThreadDealMsgType:(NSString *)msgType withMsgContent:(NSDictionary *)socketData
{
    if (!_livingView) {
        return;
    }
    
    if ([msgType isEqualToString:LIVE_RTCLIVE_TYPE]) {
        
        int upMikeType = [socketData[@"upmike_type"] intValue];
        
        if (upMikeType == RTCLIVE_INVITE_USER && [socketData[@"uid"] isEqualToString:[LCMyUser mine].userID] && !isAgreeUpMike) {// 主播邀请我上麦
            if ([LCCore globalCore].inviteChatUser) {// 正在1v1不能连麦
                isAgreeUpMike = NO;
                [self rejectInviteUpMike];
                return;
            }
            
            ESWeakSelf;
            alertInviteDialog =  [UIAlertView alertViewWithTitle:ESLocalizedString(@"提示") message:ESLocalizedString(@"主播邀请您上麦，是否同意？") cancelButtonTitle:@"拒绝" didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                ESStrongSelf;
                if (buttonIndex == 0) {
                    if (_self->isCancelUpMike) {
                        [LCNoticeAlertView showMsg:@"您已被主播取消邀请！"];
                        _self->isCancelUpMike = NO;
                    } else {
                        [_self agreeInviteUpMike];
                        _self->authString = socketData[@"url"];
                        _self->queryDomainString = socketData[@"domain_url"];
                        [_self startUpMike];
                        
                        _self->isAgreeUpMike = YES;
                    }
                    alertInviteDialog = nil;
                } else  {// 拒绝上麦
                    if (_self->isCancelUpMike) {
                        [LCNoticeAlertView showMsg:@"您已被主播取消邀请！"];
                        _self->isCancelUpMike = NO;
                    } else {
                        _self->isAgreeUpMike = NO;
                        [_self rejectInviteUpMike];
                    }
                    alertInviteDialog = nil;
                }
            } otherButtonTitles:ESLocalizedString(@"同意"), nil];
            [alertInviteDialog show];
        } else if (upMikeType == RTCLIVE_EXIT) {// 下麦
            NSString *exitUserId = [NSString stringWithFormat:@"%@",socketData[@"uid"]];
           [[NSNotificationCenter defaultCenter] postNotificationName:kUserCancelInviteUpMike object:exitUserId];
            if ([exitUserId isEqualToString:[LCMyUser mine].userID]) {
                if (alertInviteDialog) {
                    [LCNoticeAlertView showMsg:@"您已被主播取消邀请！"];
                    [alertInviteDialog dismissWithAnimated:YES];
                }
            }
            
           [_livingView updateShowMsgArea:NO withEixtUpMike:YES];;
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
                
                if (_livingView.contentTextField) {
                    [_livingView.contentTextField resignFirstResponder];
                }
                
                [self closeLivingViewWhonHostLeave:NO];
            }
        } else if ([msgType isEqualToString:LIVE_GROUP_USER_LOVE]) {
            if ([LCMyUser mine].liveType == LIVE_DOING) {
                roomPraiseCount++;
            }
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
                
                
            }  else if ([socketData[@"gift_type"] intValue] == GIFT_TYPE_LUXURY) {//豪华礼物
                if ([LCMyUser mine].liveType == LIVE_DOING) {
                    int price = [socketData[@"price"] intValue];
                    roomRecMoneyCount += price;
                }
                
            }
        }
        
        [_livingView showDealGroupMsgType:msgType withMsgContent:socketData];
    }
}

- (void) rejectInviteUpMike
{
    NSMutableDictionary *msgInfoDict = [NSMutableDictionary dictionary];
    msgInfoDict[@"type"] = LIVE_RTCLIVE_TYPE;
    msgInfoDict[@"upmike_type"] = @(RTCLIVE_REJECT_INVITE);
    msgInfoDict[@"uid"] = [LCMyUser mine].userID;
    msgInfoDict[@"nickname"] = [LCMyUser mine].nickname;
    
    [LiveMsgManager sendRTCLiveInfo:msgInfoDict andMsgType:LIVE_RTCLIVE_TYPE Succ:nil andFail:nil];
}

- (void) agreeInviteUpMike
{
    NSMutableDictionary *msgInfoDict = [NSMutableDictionary dictionary];
    msgInfoDict[@"type"] = LIVE_RTCLIVE_TYPE;
    msgInfoDict[@"upmike_type"] = @(RTCLIVE_REGISTER_SUCC);
    msgInfoDict[@"uid"] = [LCMyUser mine].userID;
    msgInfoDict[@"nickname"] = [LCMyUser mine].nickname;
    
    [LiveMsgManager sendRTCLiveInfo:msgInfoDict andMsgType:LIVE_RTCLIVE_TYPE Succ:nil andFail:nil];
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

#pragma mark - 换房间

#pragma mark 初始化
- (void) initRoomView
{
    [self showBeforeAnchorBG];
    [self showNextAnchorBG];
    
    self.pendingMessages = [NSMutableArray array];
    
    isLoveEnd = NO;
    
    isExitRoom = NO;
    
    isFirstLoad = YES;
    isLivingShowState = YES;
    isCountDownStopAnimation = YES;
    isHostLeaveRoom = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSLog(@"livetype:%d",(int)[LCMyUser mine].liveType);
    
    // 初始化
    [LCMyUser mine].liveRecDiamond = 0;
    [LCMyUser mine].liveOnlineUserCount = 0;
    [[LCMyUser mine] removeAllGagUser];
    
    // 初始化显示红包状态
    [RobRedPacketViewController isCloseRedPacket];
    
    // 自己观看直播
    self.view.backgroundColor = [UIColor whiteColor];
    startTime = mach_absolute_time();
    if (!_playerUrl) {
        NSString *rtmpSrv  = @"rtmp://play.hainandaocheng.com/live";
        _hostURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/%@", rtmpSrv, [LCMyUser mine].liveUserId]];
        ipURL = [_hostURL absoluteString];
    } else {
        NSLog(@"_playerUrl:%@",_playerUrl);
        NSString  *urlStr = [NSString stringWithFormat:@"%@",_playerUrl];
        NSMutableString* url = [NSMutableString stringWithString:urlStr];
        // NSLog(@"拉流 url：%@", url);
        
        NSRange range = [url rangeOfString:@"sign="];
        NSString *sign = [url substringFromIndex:range.location];
        // NSLog(@"sign url: %@", sign);
        NSString *pureSign = [sign substringWithRange:NSMakeRange(5, 32)];
        // NSLog(@"pure sign url: %@", pureSign);
        NSString *signBlock1 = [pureSign substringWithRange:NSMakeRange(0, 8)];
        NSString *signBlock2 = [pureSign substringWithRange:NSMakeRange(8, 8)];
        NSString *signBlock3 = [pureSign substringWithRange:NSMakeRange(16, 8)];
        NSString *signBlock4 = [pureSign substringWithRange:NSMakeRange(24, 8)];
        NSString *modifiedSign = [NSString stringWithFormat:@"%@%@%@%@", signBlock2, signBlock4, signBlock3, signBlock1];
        // NSLog(@"modified sign url: %@", modifiedSign);
        modifiedSign = [sign stringByReplacingOccurrencesOfString:pureSign withString:modifiedSign];
        NSString *modifiedUrl = [url stringByReplacingOccurrencesOfString:sign withString:modifiedSign];
        // NSLog(@"modified url: %@", modifiedUrl);
        
        _hostURL = [[NSURL alloc] initWithString:modifiedUrl];
        
        ipURL = modifiedUrl;
    }
    
    //[self setupObservers];
    
    if (!_faceFloatImgView) {
        _faceFloatImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:_faceFloatImgView];
    }
    _faceFloatImgView.hidden = NO;
    [_faceFloatImgView sd_setImageWithURL:[NSURL URLWithString:[NSString faceURLString:[LCMyUser mine].liveUserLogo]]];
    
    if (!_effectview) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        _effectview.frame = CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT);
        [self.view addSubview:_effectview];
    }
    _effectview.hidden = NO;
    
    ESWeakSelf;
    [[Business sharedInstance] enterRoomSucc:^(NSString *msg, id data) {
        ESStrongSelf;
        NSLog(@"watch enter room %@",data);
        NSDictionary *info = (NSDictionary *)data;
        _self->roomInfoDict = data;
        if ([info[@"is_gag"] intValue] == 1) {
            [LCMyUser mine].isGag = YES;
        } else {
            [LCMyUser mine].isGag = NO;
        }
        
        if ([info[@"recv_diamond"] intValue] > 0) {
            [LCMyUser mine].liveRecDiamond = [info[@"recv_diamond"] intValue];
        } else {
            [LCMyUser mine].liveRecDiamond = 0;
        }
        
        if ([info[@"is_manager"] intValue] == 1) {
            [LCMyUser mine].isManager = YES;
        } else {
            [LCMyUser mine].isManager = NO;
        }
        
        if ([info[@"show_manager"] intValue] == 1) {
            [LCMyUser mine].showManager = YES;
        }
        else {
            [LCMyUser mine].showManager = NO;
        }
        
        _livingView.mActivtyImageUrl = info[@"act"][@"img"];
        
        [LCMyUser mine].zuojia = [info[@"zuojia"] intValue];
        
        if ([info[@"sendmsg_grade"] intValue] > 0) {
            [LCMyUser mine].sendMsgGrade = [info[@"sendmsg_grade"] intValue];
        } else {
            [LCMyUser mine].sendMsgGrade = 0;
        }
        
        if ([info[@"gag_grade"] intValue] > 0) {
            [LCMyUser mine].gag_grade = [info[@"gag_grade"] intValue];
        } else {
            [LCMyUser mine].gag_grade = 0;
        }
        
        // 玩家荣耀
        [LCMyUser mine].wanjiaMedalArray = info[@"wanjia_medal"];
        // 主播荣耀
        [LCMyUser mine].liveAnchorMedalArray = info[@"anchor_medal"];
        
        NSLog(@"watch enter room:%d",[info[@"total"] intValue]);
        [LCMyUser mine].liveOnlineUserCount = [info[@"total"] intValue];
        roomAudienceCount = [LCMyUser mine].liveOnlineUserCount;
        self->_livingView.userCountLabel.text = [NSString stringWithFormat:@"%d", [LCMyUser mine].liveOnlineUserCount];
        self->_livingView.activeDict = info[@"act"];
        
        if ([info[@"is_live"] intValue] == 0) {
            isHostLeaveRoom = YES;
            roomPraiseCount = [info[@"zan_total"] intValue];
            roomAudienceCount = [info[@"visitor_total"] intValue];
            [self avExitRoom];
            return ;
        }
        
        [[IMBridge bridge] joinRoom:[LCMyUser mine].liveUserId completion:^(NSError *error) {
            NSLogIf(error, @"watch join error %@", error);
            if (error.code == 30001 || error.code == 30002 || error.code == 30003) {
                
            }
            
            if (error)
            {
                NSLog(@"连接聊天服务器失败");
            }
            else
            {
                NSLog(@"聊天服务器连接成功");
            }
            
            //不自动锁屏
            [UIApplication sharedApplication].idleTimerDisabled=YES;
            ESStrongSelf;
            [_self showLivingView:info[@"sys_msg"]];
            [_self->_livingView connectChatFlag];
            // 主播荣耀
            [_self->_livingView showAnchorMedal];
            
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
                _livingView.gradeFlagImgView.image = [UIImage createUserGradeFlagImage:[LCMyUser mine].liveUserGrade withIsManager:false];
                _livingView.gradeFlagImgView.hidden = NO;
            } else {
                _livingView.gradeFlagImgView.hidden = YES;
            }
        }];
        
        [_livingView.audienceTableView loadAudienceData];
        _livingView.hidden = NO;
    } fail:^(NSString *error) {
        ESStrongSelf;
        [_self avExitRoom];
    }];
    
    [self onPlayVideo];
    
    //直播视图
    _livingView = [[[NSBundle mainBundle] loadNibNamed:@"LivingView" owner:self options:nil] lastObject];
    _livingView.frame = self.view.bounds;
    _livingView.delegate = self;
    _livingView.hidden = YES;
    [self.view addSubview:_livingView];
    
    if (![LCCore globalCore].shouldShowPayment && [LCMyUser mine].liveType == LIVE_WATCH) {
        // IDLabel
        if (!IDLabel) {
            IDLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, self.livingView.reportLiveBtn.bottom - 10, 100, 20)];
            IDLabel.textAlignment = NSTextAlignmentCenter;
            IDLabel.textColor = [UIColor whiteColor];
            IDLabel.font = [UIFont systemFontOfSize:11.f];
            IDLabel.shadowColor = [UIColor blackColor];
            IDLabel.shadowOffset = CGSizeMake(0, -1.0);
            [self.view addSubview:IDLabel];
        }
        IDLabel.text = [NSString stringWithFormat:@"ID:%@",[LCMyUser mine].liveUserId];
        IDLabel.hidden = NO;
    } else {
        if (!IDLabel) {
            // IDLabel
            IDLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, self.livingView.myInfoBgView.bottom+10, 100, 20)];
            IDLabel.textAlignment = NSTextAlignmentCenter;
            IDLabel.textColor = [UIColor whiteColor];
            IDLabel.font = [UIFont systemFontOfSize:11.f];
            IDLabel.shadowColor = [UIColor blackColor];
            IDLabel.shadowOffset = CGSizeMake(0, -1.0);
            [self.view addSubview:IDLabel];
        }
        IDLabel.text = [NSString stringWithFormat:@"ID:%@",[LCMyUser mine].liveUserId];
        IDLabel.hidden = NO;
    }
    
    UIImage *roomShutImage = [UIImage imageNamed:@"image/liveroom/roomshut"];
    
    float viewSize = roomShutImage.size.width;
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH- viewSize - 10,SCREEN_HEIGHT - viewSize - 10, viewSize, viewSize)];
        _closeBtn.backgroundColor = [UIColor clearColor];
        [_closeBtn setImage:roomShutImage forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeRoomAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_closeBtn];
    }
        _closeBtn.hidden = YES;
    
    self.panedView = self.view;
    
    if (anchorFinisLiveView) {
        anchorFinisLiveView.hidden = YES;
    }
}

#pragma mark 销毁
- (void) releaseOldView
{
    //离开房间
    NSLog(@"观众开始退直播 [Business sharedInstance] leaveRoom");
    [[Business sharedInstance] leaveRoom:[LCMyUser mine].liveRoomId
                                   phone:[LCMyUser mine].userID
                                    succ:^(NSString *msg, id data) {
                                        NSLog(@"观众开始退直播 [Business sharedInstance] leaveRoom succ");
                                    }
     
                                    fail:^(NSString *error) {
                                        NSLog(@"观众开始退直播 [Business sharedInstance] leaveRoom失败-->avExitRoom");
                                    }];
    
    if ([LCMyUser mine].liveUserId) {
        //观众退出聊天室
        [[IMBridge bridge] exitRoom:[LCMyUser mine].liveUserId completion:^(NSError *error) {
            [LCMyUser mine].isInChatRoom = NO;
        }];
    }
    
    [self onStopVideo];
    
    if ([LuxuryManager luxuryManager].luxuryArray && [LuxuryManager luxuryManager].luxuryArray.count > 0) {
        [[LuxuryManager luxuryManager].luxuryArray removeAllObjects];
    }
    
    [LuxuryManager luxuryManager].isShowAnimation = NO;
    
    [[DriveManager shareInstance] clearAnimation];
    
    if (!isHostLeaveRoom) {
        [LCMyUser mine].liveUserId = nil;
    }
    [_livingView removeFromSuperview];
    _livingView = nil;
    
    [_pendingMessages removeAllObjects];
    
    chatNavigationController = nil;
    
    IDLabel.hidden = YES;
}


#pragma mark - 手指滑动切换主播

///滑动的时候要切换背景
- (void)showNextAnchorBG
{
    if (!_liveArray || _liveArray.count < 2) {
        return;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:view];
    
    NSDictionary *userInfoDict = nil;
    if (_pos == _liveArray.count - 1) {
        userInfoDict = _liveArray[0];
    } else {
        userInfoDict = _liveArray[_pos + 1];
    }
    
    
    UIImageView *faceFloatImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [view addSubview:faceFloatImgView];
    [faceFloatImgView sd_setImageWithURL:[NSURL URLWithString:[NSString faceURLString:userInfoDict[@"face"]]]];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT);
    [view addSubview:effectview];
    NSLog(@"nextface:%@",userInfoDict[@"face"]);
    if (chatNavigationController) {
        [self closeChat];
    }
}

- (void)showBeforeAnchorBG
{
    if (!_liveArray || _liveArray.count < 2) {
        return;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:view];
    
    NSDictionary *userInfoDict = nil;
    if (_pos == 0) {
        userInfoDict = _liveArray[_liveArray.count - 1];
    } else {
        userInfoDict = _liveArray[_pos - 1];
    }
    
    NSLog(@"beforeface:%@",userInfoDict[@"face"]);
    
    UIImageView *faceFloatImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [view addSubview:faceFloatImgView];
    [faceFloatImgView sd_setImageWithURL:[NSURL URLWithString:[NSString faceURLString:userInfoDict[@"face"]]]];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT);
    [view addSubview:effectview];
    
    if (chatNavigationController) {
        [self closeChat];
    }
}

///没有达到预定的阈值，需要还原
- (void)showCurrentAnchorBG
{
    
}

///超过预定的阈值，展示上一个或者下一个主播
- (void)showNextAnchor
{
    if (!_liveArray || _liveArray.count < 2) {
        return;
    }
    [self releaseOldView];
    _pos ++;
    if (_pos >= [_liveArray count]) {
        _pos = 0;
    }
    
    [self showRoomInfo];
    
    [self initRoomView];
}

- (void)showBeforeAnchor
{
    if (!_liveArray || _liveArray.count < 2) {
        return;
    }
    [self releaseOldView];
    _pos --;
    if (_pos < 0) {
        _pos = _liveArray.count -1;
    }
    
    [self showRoomInfo];
    
    [self initRoomView];
}

- (void) showRoomInfo
{
    NSDictionary *userInfoDict = _liveArray[_pos];
    
    self.playerUrl = userInfoDict[@"url"];
    
    [LCMyUser mine].liveUserId = userInfoDict[@"uid"];
    [LCMyUser mine].liveUserName = userInfoDict[@"nickname"];
    [LCMyUser mine].liveUserLogo = userInfoDict[@"face"];
    [LCMyUser mine].liveTime = @"0";
    [LCMyUser mine].liveType = LIVE_WATCH;
    [LCMyUser mine].liveUserGrade = [userInfoDict[@"grade"] intValue];
    
    NSLog(@"currface:%@",[LCMyUser mine].liveUserLogo);
}

@end
