//
//  直播界面视图
//  LivingView.h
//  live
//
//  Created by hysd on 15/7/18.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "OnlineUserScrollView.h"
#import "LiveGiftView.h"
#import "BarrageAllMsgView.h"
#import "LiveAllShowGiftView.h"
#import "ShowGroupMsgView.h"
#import "RoomAudienceTableView.h"
#import "DrawGiftView.h"
#import "EnterRoomAnimView.h"
#import "CaptureView.h"

#import "LCGameView.h"

@class LivingView;

typedef NS_ENUM(NSInteger, LivingViewShowGameState) {
    LivingViewShowGameStateReady,
    LivingViewShowGameStateCounting
};

@protocol LivingViewDelegate <NSObject>

@optional

- (void)sendMessage:(LivingView *)livingView;

- (void)openMike:(LivingView *)livingView;
- (void)toggleCamera:(LivingView *)livingView;

- (void)logoTap:(LivingView *)livingView;
- (void)loveTap:(LivingView *)livingView;

- (void)upMikeAction:(LivingView *)livingView;          // 上麦
- (void)exitUpMikeAction:(LivingView *)livingView;      // 下麦
- (void)cancelInviteAction:(LivingView *)livingView;    // 取消邀请

- (void)closeLivingView:(LivingView *)livingView;

//小游戏
- (void)livingViewDidChooseGameAtIndex:(NSNumber *)index;
- (void)livingViewDidCloseTheGame;
- (void)livingViewDiamondRecharge;
- (void)livingViewShowHistory;

//录制小视频
- (void)captureShortVideo:(int)isstart;
- (void)recordShouldBegin;//录制界面
- (void)recordDidBegin;//录制开始
- (void)recordShouldEnd;//点击结束录制
- (void)recordDidCancelled;//录制取消

// 显示会话列表界面
- (void)showConversationVC;

// 显示排行榜界面
- (void)showRankVC;

// 显示用户界面
- (void)showUserSpaceVC:(LiveUser *)liveUser;

// 显示充值界面
- (void)showRechargeVC;

// 显示私聊
- (void)showPrivChat:(NSDictionary *)userInfoDict;

// 换房间
- (void)changeRoom:(NSDictionary *)userInfoDict;

// 显示主页
- (void)showHomePage:(NSString *)userId;

// 显示活动页面
- (void)showActiveVC:(NSDictionary *)activeDict;

// - (void)clickAudienceLogo:(LivingView *)livingView withUserInfo:(NSDictionary *)phone;

// - (BOOL)onClickPanel:(LivingView *)panel userInfo:(LiveUser *)dic isNormal:(BOOL)isNormalUser;

- (void)onClickPanel:(LivingView *)panel showAllUser:(NSArray *)array;

- (void)pushHLS:(LivingView *)livingView;
- (void)pushRTMP:(LivingView *)livingView;
- (void)liveREC:(LivingView *)livingView;
- (void)livePAR:(LivingView *)livingView;


@end



@interface LivingView : UIView

@property (nonatomic, weak) id <LivingViewDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIButton *sendMessageButton;
@property (nonatomic, weak) IBOutlet UITextField *messageTextField;
@property (nonatomic, weak) IBOutlet UIImageView *userLogoImageView;

@property (nonatomic, strong) UIView      *myInfoBgView;
@property (nonatomic, strong) UIImageView *userFaceImageView;
@property (nonatomic, strong) UIImageView *gradeFlagImgView;
@property (nonatomic, strong) UILabel     *livingLabel;
@property (nonatomic, strong) UILabel     *userCountLabel;
@property (nonatomic, strong) UIButton    *attentBtn;
// @property (nonatomic, strong) OnlineUserScrollView *onlineScrollerView;
@property (nonatomic, strong) RoomAudienceTableView *audienceTableView;

@property (nonatomic, strong) UIButton    *reportLiveBtn;

@property (nonatomic, strong) UIImageView *recvBgImgView;
@property (nonatomic, strong) UILabel     *recvPromptLabel;
@property (nonatomic, strong) UILabel     *recvCountLabel;
@property (nonatomic, strong) UIView      *mSuperManagerView;
@property (nonatomic, strong) UIView      *mAlertView;

@property (nonatomic, strong) LiveAllShowGiftView           *allShowGiftView; // 送礼物view
@property (nonatomic, strong) BarrageAllMsgView             *barrageView; // 弹幕view
@property (nonatomic, strong) EnterRoomAnimView             *enterRoomAnimView; // 进入房间动画
@property (nonatomic, strong) DrawGiftView                  *mDrawGiftView;
@property (nonatomic, strong) UIView                        *medalView; // 荣耀view
@property (nonatomic, strong) UIImageView                   *medalFirstView;
@property (nonatomic, strong) UIImageView                   *medalSecondView;
@property (nonatomic, strong) UIImageView                   *medalThreeView;
@property (nonatomic, strong) UIImageView                   *medalFourView;

@property (nonatomic, strong) UIImageView                   *connectFlagImgView;
@property (nonatomic, strong) UIButton *msgBtn;                     // 发送按钮
@property (nonatomic, assign) long mMsgCD;
@property (nonatomic, strong) NSTimer *mMsgTimer;
@property (nonatomic, strong) UIButton *mRefreshBtn;                // 重新连接
@property (nonatomic, strong) ESBadgeView *badgeView;
@property (nonatomic, strong) UIButton *priChatBtn;                 //私聊按钮
@property (nonatomic, strong) UIButton *captureBtn;                 //录制视频按钮
@property (nonatomic, strong) UIButton *showGiftAnimStateBtn;       // 显示或关闭小礼物动画
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *giftBtn;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *mDrawBtn;
@property (nonatomic, strong) UIButton *switchCameraBtn;
@property (nonatomic, strong) UIButton *activeBtn;                  // 显示活动
@property (nonatomic, strong) UIButton *exitUpMikeBtn;              // 下麦
@property (nonatomic, strong) UIButton *cancelInviteBtn;            // 取消邀请
@property (nonatomic, strong) NSString *mActivtyImageUrl;           // 活动图片
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *mTrumpetView;

@property (nonatomic, strong)LiveGiftView *giftView;
@property (nonatomic, strong)CaptureView *captureView;

// 消息输入view
@property (nonatomic, strong) UIView        *enterContentView;
// @property (nonatomic, strong) UISwitch           *barrageSwitch;
// @property (nonatomic, strong) UISegmentedControl *switchSegmentedControl;
@property (nonatomic, strong) UIButton      *brrageBtn;
@property (nonatomic, strong) UIView        *contentContainerView;
@property (nonatomic, strong) UITextField   *contentTextField;
@property (nonatomic, strong) ESButton      *sendMsgBtn;

// @property (nonatomic, strong) UIScrollView       *msgScrollView;

@property (nonatomic, weak) IBOutlet UILabel        *livingTimeLabel;
@property (nonatomic, weak) IBOutlet UIView         *logoMessageContainer;
@property (nonatomic, weak) IBOutlet UIImageView    *loveImageView;
@property (nonatomic, weak) IBOutlet UILabel        *loveCountLabel;
@property (nonatomic, weak) IBOutlet UIView         *loveView;

@property (nonatomic, weak) IBOutlet UIButton *userCountButton;
// @property (nonatomic, weak) IBOutlet UILabel *userCountLabel;
// @property (nonatomic, weak) IBOutlet UICollectionView *userCollectionView;

@property (nonatomic, weak) IBOutlet UIImageView *netImageView;

@property (nonatomic, weak) IBOutlet UIView   *liveStatusView;
@property (nonatomic, weak) IBOutlet UILabel  *liveStatusLabel;
@property (nonatomic, weak) IBOutlet UIButton *pushButton;
@property (nonatomic, weak) IBOutlet UIButton *mikeButton;
@property (nonatomic, weak) IBOutlet UIButton *closeButton;
@property (nonatomic, weak) IBOutlet UIButton *reportButton;

// 发送消息和消息展示的滚动窗口，用于键盘弹出时滚动
@property (nonatomic, weak) IBOutlet UIScrollView *messageScrollView;
// 发送消息和消息展示的内容视图
@property (nonatomic, weak) IBOutlet UIView       *messageContentView;
// 消息展示的容器视图
@property (nonatomic, weak) IBOutlet UIView       *messageContainerView;

@property (nonatomic, weak) IBOutlet UIView *videoParamView;

@property (nonatomic, weak) IBOutlet UIButton *flashButton;
@property (nonatomic, weak) IBOutlet UIButton *cameraButton;
@property (nonatomic, weak) IBOutlet UIView   *logoContainerView;
@property (nonatomic, weak) IBOutlet UIView   *netContainerView;

@property (nonatomic, assign) BOOL showAllUser;

@property (nonatomic, weak) IBOutlet UIView *buttonContainer;
@property (nonatomic, weak) IBOutlet UITextView *paramTextView;

// @property (nonatomic, strong) NSMutableArray *invitedUsers;
@property (nonatomic, strong) ShowGroupMsgView  *showGroupMsgView;
@property (nonatomic, assign) CGFloat tempShowGroupMsgViewBottom;

@property (nonatomic, strong) NSDictionary      *activeDict; // 活动详情

@property (nonatomic, assign) CurrentGameType currentGameType;

@property (nonatomic, assign) LivingViewShowGameState gameState;
@property (nonatomic, strong) NSArray<NSNumber *> *betArray;
@property (nonatomic, assign) BOOL isHost;//是否为主播视图
@property (nonatomic, assign) BOOL isInGame;//是否在游戏界面

- (IBAction)closeLivingView:(id)sender;
- (IBAction)openMike:(id)sender;
- (IBAction)toggleCamera:(id)sender;

// 添加信息
- (void)addMessage:(NSString *)message andUserInfo:(NSDictionary *)userInfoDict;
// 添加用户
- (void)addUsers:(LiveUser *)users;
// 删除用户
- (void)delUsers:(LiveUser *)user;
// 点赞
- (void)addLove:(NSInteger)count withLightPos:(int)lightPos;
// 添加进房动画
- (void)addEnterRoomAnim:(NSDictionary *)enterRoomDict;



// - (NSInteger)invitedUserCount;
- (NSInteger)allUserCount;
// - (void)addUserToInvite:(NSString *)sender;
// - (void)removeUserFrmoInvite:(NSString *)sender;

// - (LiveUser *)getUserOf:(NSString *)sender;
// - (LiveUser *)getInvitedUserOf:(NSString *)sender;

- (void)hideCamera;

// 更新收入
- (void)updateRecvDiamond;

#pragma mark - 群聊回复

- (void)reviewUser:(NSDictionary *)userInfo;

#pragma mark - 隐藏礼物

- (void)hiddenGiftView;

//- (void)hiddenDrawView;

#pragma mark - 隐藏分享

- (void)hiddenShareView;

#pragma mark - 链接聊天标识

- (void)connectChatFlag;

#pragma mark - 显示主播荣耀

- (void)showAnchorMedal;

#pragma mark - 显示群聊

- (void)showDealGroupMsgType:(NSString *)msgType withMsgContent:(NSDictionary *)socketData;

#pragma mark - 显示下麦

- (void)showExitUpMikeAction;

#pragma mark - 上麦成功或退出上麦时更新聊天区域显示范围

- (void)updateShowMsgArea:(BOOL)isUpMikeSucc withEixtUpMike:(BOOL)isExitUpMike;

- (IBAction)pushHLS:(id)sender;
- (IBAction)liveREC:(id)sender;
- (IBAction)livePAR:(id)sender;
- (IBAction)pushRTMP:(id)sender;

// 旋转
- (void)netRotateStart;
- (void)netRotateStop;

// 录屏
- (void)startRec;
- (void)stopRec;
- (void)captureViewClose;
- (void)recordFinished;
#pragma mark-游戏
- (void)showGameViewWithType:(CurrentGameType)type;
- (void)timeOutCounting:(NSInteger)counting;
- (void)betActionWithCompletionHander:(void(^)(NSInteger amount, NSInteger index))completionHandler; //only for audience
- (void)showBetActionWithArray:(NSArray *)betArray;
- (void)showMyBetActionWithArray:(NSArray *)betArray;
- (void)showGameResultWithDict:(NSDictionary *)dict;

- (void)showHistoryWithData:(NSArray *)history;


@end
