//
//  LCLiveViewController.m
//  TaoHuaLive
//
//  Created by Jay on 2017/8/8.
//  Copyright © 2017年 上海七夕. All rights reserved.
//

#import "LCLiveViewController.h"
#import <AVFoundation/AVFoundation.h>

#import <PLMediaStreamingKit/PLMediaStreamingKit.h>

#import "CocoaAsyncSocket.h"

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

#import "LCLiveMessageModel.h"

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

typedef NS_ENUM(NSInteger, NETWORK_STATUS) {
    NETWORK_CONN = 0,
    NETWORK_FAIL,
    NETWORK_DISCONN
};

@interface LCLiveViewController ()<LivingViewDelegate, FinishLiveViewDelegate, StartVideoLiveViewDelegate, CameraPopViewDelegate, UIGestureRecognizerDelegate,GCDAsyncSocketDelegate>
{
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
    
    LivingView                  *_livingView; //live view
    UIButton                    *_closeBtn;// close the live stream
    
    StartVideoLiveView          *startLiveView; //view that ready to live
    
    dispatch_queue_t            __gSendingMessagesQueue;
    UserSpaceViewController     *spaceViewController;
    
    UINavigationController      *chatNavigationController;

    NSMutableArray              *_datas;
}

@property (nonatomic, strong) PLMediaStreamingSession *session;

@property (nonatomic, strong) LCLiveMessageModel *messageModel;

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

@implementation LCLiveViewController

- (void)dealloc
{
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
    
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
        _messageModel = [[LCLiveMessageModel alloc] init];
        __gSendingMessagesQueue = dispatch_queue_create("com.qianchuo.ShowMessagesQueue", DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isCountDownStopAnimation =YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initSubViews];
    
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

#pragma mark- 监听事件

/**
 聊天室消息

 @param notification notification description
 */
- (void)onReceiveGroupMsg:(NSNotification *)notification
{
    if (!_livingView) {
        return;
    }
    ESWeakSelf
    [self.messageModel onReceiveGroupMsg:notification withHandler:^(LiveMessageEvent event, NSDictionary *messageDict) {
        ESStrongSelf
        [_self showMessageWithEvent:event andMessage:messageDict];
    }];
}
#pragma mark- 处理聊天室消息
- (void)showMessageWithEvent:(LiveMessageEvent)event andMessage:(NSDictionary *)message
{
    switch (event) {
        case LiveMessageEventInvitationGranted:// 同意上麦
            _upMikeUserInfoDict = message;
            break;
        case LiveMessageEventInvitationDeclined:// 拒绝上麦
        {
            _upMikeUserInfoDict = nil;
            _inviteUserInfoDict = nil;
            isSendCall = NO;
            _livingView.cancelInviteBtn.hidden = YES;
        }
            break;
        case LiveMessageEventRegisterFailed:// 注册失败
        {
            _upMikeUserInfoDict = nil;
            _inviteUserInfoDict = nil;
            isSendCall = NO;
        }
            break;
        case LiveMessageEventRegisterSucceed:// 注册成功，开始呼叫
        {
            _upMikeUserInfoDict = message;
//            [self startRTCCall];
        }
            break;
        case LiveMessageEventCallSucceed:// 呼叫成功
        {
            // 更新livingView，允许玩家下麦
            _livingView.exitUpMikeBtn.hidden = NO;
            _livingView.cancelInviteBtn.hidden = YES;
            [_livingView updateShowMsgArea:YES withEixtUpMike:NO];
        }
            break;
        case LiveMessageEventCallFailed:// 呼叫失败
        {
            _upMikeUserInfoDict = nil;
            _inviteUserInfoDict = nil;
            isSendCall = NO;
        }
            break;
        case LiveMessageEventDisconnected:// 下麦
        {
            _upMikeUserInfoDict = nil;
            _inviteUserInfoDict = nil;
            isSendCall = NO;
            _livingView.exitUpMikeBtn.hidden = YES;
            [_livingView updateShowMsgArea:NO withEixtUpMike:YES];
        }
            break;
        case LiveMessageEventEnterTheRoom://进入房间
        {
            roomAudienceCount = [LCMyUser mine].liveOnlineUserCount;
            
        }
            break;
        case LiveMessageEventChatMessage:// if needed
        {
            
        }
            break;
        case LiveMessageEventLeaveTheRoom:// leave the room
        {
            NSString *userId = message[@"uid"];
            if ([LCMyUser mine].liveOnlineUserCount > 0) {
                [LCMyUser mine].liveOnlineUserCount--;
                roomAudienceCount = [LCMyUser mine].liveOnlineUserCount;
            }
            // 主播离开
            if([userId isEqualToString:[LCMyUser mine].liveUserId])
            {
                if ([LCMyUser mine].liveType != LIVE_DOING) {
                    isHostLeaveRoom = YES;
                    
                    roomAudienceCount = [message[@"audience_count"] intValue];
                    roomPraiseCount = [message[@"praise_count"] intValue];
                }
                
                [self closeLivingViewWhonHostLeave:NO];
            }
        }
            break;
        case LiveMessageEventLove://
        {
            
        }
            break;
        case LiveMessageEventGift:// 注册成功，开始呼叫
        {
            int recvDiamond = [message[@"recv_diamond"] intValue];
            
            if (recvDiamond > [LCMyUser mine].liveRecDiamond) {
                [LCMyUser mine].liveRecDiamond = recvDiamond;
            }
            
            if ([message[@"gift_type"] intValue] == GIFT_TYPE_CONTINUE) {
                // 连续
                if ([LCMyUser mine].liveType == LIVE_DOING) {
                    int price = [message[@"price"] intValue];
                    roomRecMoneyCount += price;
                }
            } else if ([message[@"gift_type"] intValue] == GIFT_TYPE_REDPACKET) {
                // 红包
            } else if ([message[@"gift_type"] intValue] == GIFT_TYPE_LUXURY) {
                // 豪华礼物
                if ([LCMyUser mine].liveType == LIVE_DOING)
                {
                    int price = [message[@"price"] intValue];
                    
                    roomRecMoneyCount += price;
                }
            }

        }
            break;
            
        default:
            break;
    }
}

#pragma mark-

#pragma mark- Private methods
- (void)initSubViews
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
        
        if (!self.navigationController.navigationBarHidden) {
            [self.navigationController setNavigationBarHidden:YES];
        }
//        oldTime = [[NSDate date] timeIntervalSince1970]*1000;
        
        startLiveView = [[StartVideoLiveView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        startLiveView.delegate = self;
        
        [startLiveView showView:self.view];
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
    [_closeBtn addTarget:self action:@selector(roomClosingAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeBtn];
    
//    UIPanGestureRecognizer *guestureR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
//    guestureR.delegate = self;
//    [self.view addGestureRecognizer:guestureR];
}

#pragma mark-

#pragma mark- 直播
#pragma mark-

/**
 关闭直播间
 */
- (void)roomClosingAction
{
    
}
#pragma mark- 主播离开房间

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
                //[self clearRoomInfo];
            } else {
                //[self onHostExitRoom];
            }
        } else {
            LiveAlertView *alert = [[[NSBundle mainBundle] loadNibNamed:@"LiveAlertView" owner:self options:nil] lastObject];
            NSString *title = [NSString stringWithFormat:ESLocalizedString(@"有%ld人正在看您的直播，确定结束直播吗？"), roomAudienceCount];
            
            ESWeakSelf;
            [alert showTitle:title confirmTitle:ESLocalizedString(@"结束直播") cancelTitle:ESLocalizedString(@"继续直播") confirm:^{
                ESStrongSelf;
                
                //[_self onHostExitRoom];
            } cancel:nil];
        }
    }
    else
    {
        //[self onHostExitRoom];
    }
    
    if (chatNavigationController) {
        // 正在聊天时主播退出直播
        //[self closeChat];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
