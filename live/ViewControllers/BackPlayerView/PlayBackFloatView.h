//
//  PlayBackFloatView.h
//  qianchuo
//
//  Created by jacklong on 16/8/8.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "LiveGiftView.h"
#import "RoomAudienceTableView.h"
#import "LiveAllShowGiftView.h"
#import "BarrageAllMsgView.h"
#import "KSYProgressToolBar.h"

@class PlayBackFloatView;
@protocol PlayBackFloatViewDelegate <NSObject>
@optional

- (void)loveTap:(PlayBackFloatView*)livingView;
- (void)closeLivingView:(PlayBackFloatView*)livingView;


// 显示会话列表界面
- (void)showConversationVC;

// 显示私聊
- (void)showPrivChat:(NSDictionary *)userInfoDict;

// 显示排行榜
- (void)showRankVC;

// 显示用户
- (void)showUserSpaceVC:(LiveUser *)liveUser;

// 显示充值界面
- (void)showRechargeVC;

// 换房间
- (void)changeRoom:(NSDictionary *)userInfoDict;

@end

@interface PlayBackFloatView : UIView

@property (nonatomic, weak) id <PlayBackFloatViewDelegate> delegate;

@property (nonatomic, strong) KSYProgressToolBar *progressBar;

@property (nonatomic, strong)UIView         *myInfoBgView;
@property (nonatomic, strong)UIImageView    *userFaceImageView;
@property (nonatomic, strong)UIImageView    *gradeFlagImgView;
@property (nonatomic, strong)UILabel        *livingLabel;
@property (nonatomic, strong)UILabel        *userCountLabel;
@property (nonatomic, strong)UIButton       *attentBtn;
//@property (nonatomic, strong)OnlineUserScrollView  *onlineScrollerView;
@property (nonatomic, strong)RoomAudienceTableView  *audienceTableView;

//@property (nonatomic, strong)UIButton       *reportLiveBtn;

@property (nonatomic, strong)UIImageView    *recvBgImgView;
@property (nonatomic, strong)UILabel        *recvPromptLabel;
@property (nonatomic, strong)UILabel        *recvCountLabel;
@property (nonatomic, strong) UIView       *mSuperManagerView;


//@property (nonatomic, strong)UILabel        *livePlayStateLabel;

//@property (nonatomic, strong)
@property (nonatomic, strong)LiveAllShowGiftView            *allShowGiftView;// 送礼物view
@property (nonatomic, strong)BarrageAllMsgView              *barrageView; // 弹幕view
//@property (nonatomic, strong)EnterRoomAnimView              *enterRoomAnimView;// 进房动画

@property (nonatomic, strong)UIImageView    *connectFlagImgView;
//@property (nonatomic, strong)UIButton *msgBtn; //发送按钮
@property (nonatomic, assign) long mMsgCD;
@property (nonatomic, strong) NSTimer* mMsgTimer;
//@property (nonatomic, strong) UIButton *mRefreshBtn; //重新连接
@property (nonatomic, strong)ESBadgeView *badgeView;
@property (nonatomic, strong)UIButton *priChatBtn;
@property (nonatomic, strong)UIButton *showGiftAnimStateBtn;// 显示或关闭小礼物动画
@property (nonatomic, strong)UIButton *shareBtn;
@property (nonatomic, strong)UIButton *giftBtn;
@property (nonatomic, strong)UIButton *closeBtn;
@property (nonatomic, strong)UIButton *switchCameraBtn;
@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, strong)UILabel *timeLabel;

@property (nonatomic, strong)LiveGiftView *giftView;

// 消息输入view
//@property (nonatomic, strong) UIView        *enterContentView;
////@property (nonatomic, strong) UISwitch      *barrageSwitch;
////@property (nonatomic, strong) UISegmentedControl *switchSegmentedControl;
//@property (nonatomic, strong) UIButton      *brrageBtn;
//@property (nonatomic, strong) UIView        *contentContainerView;
//@property (nonatomic, strong) UITextField   *contentTextField;
//@property (nonatomic, strong) ESButton      *sendMsgBtn;

//@property (nonatomic, strong) UIScrollView  *msgScrollView;

//@property (weak, nonatomic) IBOutlet UILabel        *livingTimeLabel;
//@property (weak, nonatomic) IBOutlet UIView         *logoMessageContainer;
//@property (weak, nonatomic) IBOutlet UIImageView    *loveImageView;
//@property (weak, nonatomic) IBOutlet UILabel        *loveCountLabel;
//@property (weak, nonatomic) IBOutlet UIView         *loveView;

@property (nonatomic, assign) BOOL showAllUser;

//@property (nonatomic, strong)ShowGroupMsgView  *showGroupMsgView;


#pragma mark - 显示聊天历史消息
//添加信息
- (void)addMessage:(NSString *)message andUserInfo:(NSDictionary*)userInfoDict;
//添加用户
- (void)addUsers:(LiveUser *)users;
//删除用户
- (void)delUsers:(LiveUser *)user;
//增加点赞
//- (void)addLove:(NSInteger)count withLightPos:(int)lightPos;
//添加进房动画
//- (void)addEnterRoomAnim:(NSDictionary*)enterRoomDict;

#pragma mark - 显示用户总数
- (void) showUserCount:(NSString *)userCount;

#pragma mark - 更新收入
- (void) updateRecvDiamond:(NSString *)recDiamondStr;

//#pragma mark - 群聊回复
//- (void) reviewUser:(NSDictionary *)userInfo;

#pragma mark - 隐藏礼物
- (void) hiddenGiftView;


#pragma mark - 隐藏分享
- (void) hiddenShareView;

//#pragma mark - 链接聊天标志
//- (void) connectChatFlag;

#pragma mark - 显示群聊
- (void) showDealGroupMsgType:(NSString *)msgType withMsgContent:(NSDictionary *)socketData;

@end
