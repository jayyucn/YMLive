//
//  直播界面视图
//  LivingView.m
//  live
//
//  Created by hysd on 15/7/18.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//


#import "LivingView.h"

#import "UserLogoCell.h"
#import "Macro.h"
#import "UIImage+Category.h"
#import "ReportAlert.h"
#import "Business.h"
#import "TranslucentToolbar.h"
#import "AudienceUserCell.h"
#import "UserSpaceViewController.h"
#import "LuxuryManager.h"
#import "RoomShareView.h"
#import "RedPacketManager.h"
#import "ChatUtil.h"
#import "GroupMsgCell.h"
#import "ParseContentCommon.h"
#import "ADSUtil.h"
#import "AnimationFireworksView.h"
#import "GSPChatMessage.h"
#import "DriveManager.h"
#import "GiftModel.h"
#import "AnimOperationManager.h"
#import "CaptureView.h"

#import "LiveGameListView.h"
#import "LCGameView.h"
#import "LEEAlert.h"
#import "LCBetHistoryView.h"
#import "LCGameSuccessView.h"

// #define kReturn return;

#define MESSAGE_SURVIVAL_TIME 20

#define ChatControlHeight (155.0/2 - 35.f)

#define UPDATE_ONLINE_USER_TIME .2

#define ADD_ENTER_ANIM_TIME 5


@interface LivingView () <UITextFieldDelegate, UIGestureRecognizerDelegate, DrawGiftViewDelegate,CaptureDelegate, LCGameViewDelegate>
{
    int  insertMsgHeight;
    BOOL isRequesstUserDetailInfo;
    BOOL isBarrageState;
    BOOL isAttentLiveUser;
    // 是否显示礼物动画
    BOOL isShowGiftAnim;
    
    // NSMutableArray *messageViewArray;
    // NSMutableArray *_userArray;
    // NSTimer *delMsgViewTimer;
    
    CGPoint beginpoint;
    
    RoomShareView *shareView;
    
    NSMutableArray<UIView *> *shouldHidenViewArray;
}

@property (nonatomic, weak) IBOutlet UIButton *recButton;

@property (nonatomic, weak) IBOutlet UIButton *shareButton;
@property (nonatomic, strong) UIButton *gameBtn;
@property (nonatomic, strong) UIButton *startBtn;
@property (nonatomic, strong) UIButton *hideGameBtn;
@property (nonatomic, strong) LCGameView *gameView;
@property (nonatomic, strong) UIView *betSuccView;
@property (nonatomic, strong) UIImageView *betFailView;

@property (nonatomic, strong) NSMutableDictionary *addAnimTimerDict;

@property (nonatomic, strong) NSMutableDictionary *addZuoJiaTimerDict;

@property (nonatomic, strong) NSMutableArray *addTrumpets;

@end


@implementation LivingView

- (void)dealloc
{
    NSLog(@"%@ dealloc", NSStringFromClass(self.class));
    
    self.giftView.giftScrollView.scrollView.delegate = nil;
    self.showGroupMsgView.contentTable.delegate = nil;
    self.audienceTableView.delegate = nil;
    self.gameView.delegate = nil;
    
    
    if (self.showGroupMsgView) {
        [self.showGroupMsgView removeFromSuperview];
        
        self.showGroupMsgView = nil;
    }
    
    if (self.pushButton) {
      self.pushButton = nil;
    }
    
    if (self.flashButton) {
      self.flashButton = nil;
    }
    
    if (self.logoContainerView) {
       self.logoContainerView = nil;
    }
    
    if (self.loveView) {
        self.loveView = nil;
    }
    
    if (self.myInfoBgView) {
        self.myInfoBgView = nil;
    }
    
    if (self.giftView) {
       self.giftView = nil;
    }
    
    if (self.allShowGiftView) {
        self.allShowGiftView = nil;
    }
    
    if (self.barrageView) {
        self.barrageView = nil;
    }
    
    if (self.enterRoomAnimView) {
        self.enterRoomAnimView.enterInfoArray = nil;
        
        self.enterRoomAnimView = nil;
    }
    if (self.gameView) {
        [self.gameView removeFromSuperview];
        self.gameView = nil;
    }
    
    // self.onlineScrollerView = nil;
    // __gShowGiftMessagesQueue = nil;
    
    [self removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib
{
#if 0
    {
        ESWeakSelf;
        
        ESButton *button = [ESButton buttonWithTitle:@"Close" buttonColor:[UIColor redColor]];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:40];
        [button sizeToFit];
        button.center = self.center;
        
        [button addEventHandler:^(id sender, UIControlEvents controlEvent) {
            ESStrongSelf;
            
            [_self closeLiveView];
        } forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
    }
#endif
    shouldHidenViewArray = [[NSMutableArray alloc] init];
    // 隐藏没做功能
    self.pushButton.hidden = YES;
    self.flashButton.hidden = YES;
    
    // 背景透明
    self.backgroundColor = [UIColor clearColor];
    
    self.reportButton.hidden = YES;
    self.mikeButton.hidden = YES;
    self.cameraButton.hidden = YES;
    self.closeButton.hidden = YES;
    self.videoParamView.hidden = YES;
    
    // 容器
    self.messageScrollView.backgroundColor = [UIColor clearColor];
    self.messageScrollView.hidden = NO;
    self.messageContentView.backgroundColor = [UIColor clearColor];
    self.messageContentView.userInteractionEnabled = YES;
    self.messageContentView.hidden = NO;
    self.messageContainerView.backgroundColor = [UIColor clearColor];
    self.messageContainerView.hidden = NO;
    
    // 测试按钮
    // self.buttonContainer.backgroundColor = RGBA16(COLOR_BG_ALPHAWHITE);
    // self.buttonContainer.layer.cornerRadius = 5;
    // self.buttonContainer.clipsToBounds = YES;
    self.buttonContainer.hidden = YES;
    
    // 视频参数
    // self.paramTextView.layoutManager.allowsNonContiguousLayout = NO;
    // self.paramTextView.backgroundColor = RGBA16(COLOR_BG_ALPHAWHITE);
    // self.paramTextView.layer.cornerRadius = 5;
    // self.paramTextView.clipsToBounds = YES;
    self.paramTextView.hidden = YES;
    
    // 头像容器
    self.logoContainerView.hidden = YES;
    
    // 网络连接容器
    self.netContainerView.hidden = YES;
    
    // 圆形头像
    self.logoContainerView.hidden = YES;
    
    // self.userLogoImageView.size = CGSizeMake(35.f, 35.f);
    self.userLogoImageView.hidden = YES;
    
    // self.userLogoImageView.layer.borderWidth = 1;
    // self.userLogoImageView.layer.borderColor = RGB16(COLOR_BG_WHITE).CGColor;
    // self.userLogoImageView.layer.cornerRadius = self.userLogoImageView.frame.size.width / 2;
    // self.userLogoImageView.clipsToBounds = YES;
    // self.userLogoImageView.image = [UIImage imageNamed:@"default_head"];
    // self.userLogoImageView.userInteractionEnabled = YES;
    
    // [self.logoContainerView bringSubviewToFront:self.userLogoImageView];
    
    // 直播时间
    self.livingTimeLabel.textColor = RGB16(COLOR_FONT_WHITE);
    self.livingTimeLabel.text = @"00:00:00";
    self.livingTimeLabel.hidden = YES;
    
    // 直播状态
    self.liveStatusLabel.textColor = RGB16(COLOR_FONT_WHITE);
    self.liveStatusLabel.text = ESLocalizedString(@"直播中");
    self.liveStatusLabel.hidden = YES;
    
    // self.liveStatusView.backgroundColor = RGB16(COLOR_BG_RED);
    // self.liveStatusView.layer.cornerRadius = 5;
    self.liveStatusView.hidden = YES;
    
    // CGRect statusFrame = self.liveStatusView.frame;
    // UIBezierPath *statusPath = [UIBezierPath bezierPath];
    // [statusPath moveToPoint:CGPointMake(0.0, 0.0)];
    // [statusPath addLineToPoint:CGPointMake(statusFrame.size.width - 8, 0.0)];
    // [statusPath addLineToPoint:CGPointMake(statusFrame.size.width, statusFrame.size.height)];
    // [statusPath addLineToPoint:CGPointMake(0.0, statusFrame.size.height)];
    // [statusPath closePath];
    // CAShapeLayer *statusShape = [CAShapeLayer layer];
    // statusShape.path = [statusPath CGPath];
    // self.liveStatusView.layer.mask = statusShape;
    
    // 消息编辑框
    // self.messageTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"说点什么吧" attributes:@{NSForegroundColorAttributeName:RGB16(COLOR_BG_WHITE)}];
    // self.messageTextField.borderStyle = UITextBorderStyleNone;
    // self.messageTextField.textColor = [UIColor whiteColor];
    // self.messageTextField.delegate = self;
    // [self.messageTextField setReturnKeyType:UIReturnKeySend];
    self.messageTextField.hidden = YES;
    
    // 发送框容器
    // self.logoMessageContainer.backgroundColor = RGBA16(COLOR_BG_ALPHAWHITE);
    // self.logoMessageContainer.layer.cornerRadius = 5;
    // self.logoMessageContainer.clipsToBounds = YES;
    self.logoMessageContainer.hidden = YES;
    
    // self.userCountButton.layer.borderColor = RGB16(COLOR_BG_WHITE).CGColor;
    // self.userCountButton.layer.borderWidth = 1;
    // [self.userCountButton setTitleColor:RGB16(COLOR_FONT_WHITE) forState:UIControlStateNormal];
    // self.userCountButton.layer.cornerRadius = self.userCountButton.frame.size.height / 2;
    // self.userCountButton.clipsToBounds = YES;
    self.userCountButton.hidden = YES;
    
    // 点赞view
    // self.loveView.backgroundColor = RGBA16(COLOR_BG_ALPHAWHITE);
    // self.loveView.layer.cornerRadius = 5;
    // self.loveView.clipsToBounds = YES;
    // self.loveView.userInteractionEnabled = YES;
    // UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loveTap:)];
    // [self.loveView addGestureRecognizer:tap];
    self.loveView.hidden = YES;
    
    // 点赞人数
    self.loveCountLabel.textColor = RGB16(COLOR_FONT_WHITE);
    
    self.myInfoBgView = [[UIView alloc] initWithFrame:CGRectMake(10, STATUS_HEIGHT + 10, 130.f, ViewWidth)];
    self.myInfoBgView.layer.cornerRadius = 20;
    self.myInfoBgView.backgroundColor = RGBA16(0x30000000);
    [self addSubview:self.myInfoBgView];
    
    self.userFaceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.f, 5.f, 30, 30)];
    // self.userFaceImageView.layer.borderWidth = 1;
    // self.userFaceImageView.layer.borderColor = RGB16(COLOR_BG_WHITE).CGColor;
    self.userFaceImageView.layer.cornerRadius = self.userFaceImageView.frame.size.width / 2;
    self.userFaceImageView.clipsToBounds = YES;
    self.userFaceImageView.image = [UIImage imageNamed:@"default_head"];
    self.userFaceImageView.userInteractionEnabled = YES;
    [self.myInfoBgView addSubview:self.userFaceImageView];
    
    UIImage *gradeFlagImg = [UIImage imageNamed:@"image/yonghu/grade_flag/grade_flag_1"];
    _gradeFlagImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_userFaceImageView.right - gradeFlagImg.size.width, _userFaceImageView.bottom - gradeFlagImg.size.height + 2, gradeFlagImg.size.width, gradeFlagImg.size.height)];
    _gradeFlagImgView.image = gradeFlagImg;
    [self.myInfoBgView addSubview:_gradeFlagImgView];
    
    UITapGestureRecognizer *logoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoTap:)];
    [self.myInfoBgView addGestureRecognizer:logoTap];
    
    self.livingLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.userFaceImageView.right + 5, 4, 60, 15)];
    self.livingLabel.right = self.userFaceImageView.right + self.userFaceImageView.size.width + 25.f;
    self.livingLabel.textAlignment = NSTextAlignmentCenter;
    self.livingLabel.textColor = RGB16(COLOR_FONT_WHITE);
    self.livingLabel.font = [UIFont systemFontOfSize:11.f];
    self.livingLabel.text = ESLocalizedString(@"直播Live");
    [self.myInfoBgView addSubview:self.livingLabel];
    
    self.userCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.livingLabel.frame.origin.x, self.livingLabel.frame.origin.y + 15, 60, 15)];
    self.userCountLabel.textAlignment = NSTextAlignmentCenter;
    self.userCountLabel.textColor = RGB16(COLOR_FONT_WHITE);
    self.userCountLabel.font = [UIFont systemFontOfSize:10.f];
    [self.myInfoBgView addSubview:self.userCountLabel];
    
    self.attentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.attentBtn.left = _livingLabel.right;
    self.attentBtn.centerY = self.myInfoBgView.height / 2 - 10;
    self.attentBtn.size = CGSizeMake(35, 20);
    [self.attentBtn.layer setMasksToBounds:YES];
    [self.attentBtn.layer setCornerRadius:10.0]; // 设置矩形四个圆角半径
    [self.attentBtn setBackgroundImage:[UIImage createImageWithColor:ColorPink] forState:UIControlStateNormal];
    [self.attentBtn setTitle:ESLocalizedString(@"关注") forState:UIControlStateNormal];
    self.attentBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.attentBtn.titleLabel.textColor = [UIColor whiteColor];
    [self.attentBtn addTarget:self action:@selector(attentLiveUserAction) forControlEvents:UIControlEventTouchUpInside];
    [self.myInfoBgView addSubview:self.attentBtn];
    
    if (![LCCore globalCore].shouldShowPayment && [LCMyUser mine].liveType == LIVE_WATCH) {
        self.reportLiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.reportLiveBtn.backgroundColor = [UIColor clearColor];
        self.reportLiveBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        self.reportLiveBtn.titleLabel.textColor = ColorPink;
        self.reportLiveBtn.frame = CGRectMake(SCREEN_WIDTH - 80, self.myInfoBgView.top + 40, 80, 40);
        [self.reportLiveBtn setTitle:ESLocalizedString(@"举报") forState:UIControlStateNormal];
        [self.reportLiveBtn setTitleColor:ColorPink forState:UIControlStateNormal];
        [self.reportLiveBtn addTarget:self action:@selector(reportAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.reportLiveBtn];
        
        // IDLabel
        // UILabel *IDLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, self.reportLiveBtn.bottom - 10, 100, 20)];
        // IDLabel.textAlignment = NSTextAlignmentCenter;
        // IDLabel.textColor = [UIColor whiteColor];
        // IDLabel.font = [UIFont systemFontOfSize:11.f];
        // IDLabel.shadowColor = [UIColor blackColor];
        // IDLabel.shadowOffset = CGSizeMake(0, -1.0);
        // IDLabel.text = [NSString stringWithFormat:@"ID:%@", [LCMyUser mine].liveUserId];
        // [self addSubview:IDLabel];
    } else {
        if ([LCMyUser mine].liveType == LIVE_DOING) {
            UIImage *userIdImg = [UIImage imageNamed:@"image/liveroom/me_ub_bg"];
            UIEdgeInsets insetsHead = UIEdgeInsetsMake(0, 5, 0, 20);
            
            // 指定为拉伸模式，伸缩后重新赋值
            userIdImg = [userIdImg resizableImageWithCapInsets:insetsHead resizingMode:UIImageResizingModeStretch];
            UIImageView *userIdImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 5 - userIdImg.size.width, self.myInfoBgView.bottom + 15, userIdImg.size.width, userIdImg.size.height)];
            userIdImgView.image = userIdImg;
            [userIdImgView setTag:101];
            [self addSubview:userIdImgView];
            
            
            // IDLabel
            // 播主可见
            UILabel *IDLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, userIdImgView.height)];
            IDLabel.textAlignment = NSTextAlignmentCenter;
            IDLabel.textColor = [UIColor whiteColor];
            IDLabel.font = [UIFont systemFontOfSize:11.f];
            IDLabel.shadowColor = [UIColor blackColor];
            IDLabel.shadowOffset = CGSizeMake(0, -1.0);
            IDLabel.text = [NSString stringWithFormat:@"ID:%@", [LCMyUser mine].liveUserId];
            
            [userIdImgView addSubview:IDLabel];
        }
    }
    
    self.audienceTableView = [[RoomAudienceTableView alloc] initWithFrame:CGRectMake(self.myInfoBgView.right + ViewPadding, self.myInfoBgView.top + 5, ViewWidth + ViewPadding, ViewWidth)];
    // self.audienceTableView.size = CGSizeMake(SCREEN_WIDTH - self.myInfoBgView.right, ViewWidth);
    ESWeakSelf;
    
    self.audienceTableView.reViewBlock = ^(NSDictionary *userInfoDict) {
        ESStrongSelf;
        
        [_self reviewUser:userInfoDict];
    };
    
    self.audienceTableView.privateChatBlock = ^(NSDictionary *userInfoDict) {
        ESStrongSelf;
        
        [_self.delegate showPrivChat:userInfoDict];
    };
    
    self.audienceTableView.showUserBlock = ^(LiveUser *liveUser) {
        ESStrongSelf;
        
        [_self.delegate showUserSpaceVC:liveUser];
    };
    
    self.audienceTableView.gagUserBlock = ^(NSDictionary *userInfoDict) {
        ESStrongSelf;
        
        NSMutableDictionary *socket = [NSMutableDictionary dictionary];
        socket[@"type"] = LIVE_GROUP_GAG;                       // 消息类型
        socket[@"uid"] = userInfoDict[@"uid"];                  // 用户id
        socket[@"nickname"] = userInfoDict[@"nickname"];        // 用户昵称
        socket[@"send_name"] = [LCMyUser mine].nickname;        // 发送被禁言用户昵称
        
        [LiveMsgManager sendGagInfo:socket Succ:nil andFail:nil];
        [_self addMessage:nil andUserInfo:socket];
    };
    
    self.audienceTableView.addManagerBlock = ^(NSDictionary *userInfoDict) {
        ESStrongSelf;
        
        NSMutableDictionary *socket = [NSMutableDictionary dictionary];
        socket[@"type"] = LIVE_GROUP_MANAGER;                   // 消息类型
        socket[@"uid"] = userInfoDict[@"uid"];                  // 用户id
        socket[@"nickname"] = userInfoDict[@"nickname"];        // 用户昵称
        
        [LiveMsgManager sendManagerInfo:socket Succ:nil andFail:nil];
        [_self addMessage:nil andUserInfo:socket];
    };
    
    self.audienceTableView.removeManagerBlock = ^(NSDictionary *userInfoDict) {
        ESStrongSelf;
        
        NSMutableDictionary *socket = [NSMutableDictionary dictionary];
        socket[@"type"] = LIVE_GROUP_REMOVE_MANAGER;            // 消息类型
        socket[@"uid"] = userInfoDict[@"uid"];                  // 用户id
        socket[@"nickname"] = userInfoDict[@"nickname"];        // 用户昵称
        
        [LiveMsgManager sendRemoveManagerInfo:socket Succ:nil andFail:nil];
        [_self addMessage:nil andUserInfo:socket];
    };
    
    [self addSubview:self.audienceTableView];
    self.audienceTableView.userInteractionEnabled = YES;
    
    if ([LCMyUser mine].liveUserId && ([[LCMyUser mine].userID isEqualToString:[LCMyUser mine].liveUserId] || [[LCMyUser mine] isAttentUser:[LCMyUser mine].liveUserId]))
    {
        _attentBtn.hidden = YES;
        
        self.myInfoBgView.width = 90;
        self.audienceTableView.left = self.myInfoBgView.right + 10;
        self.audienceTableView.width = SCREEN_WIDTH - self.myInfoBgView.right - 10;
    }
    else
    {
        _attentBtn.hidden = NO;
        
        self.myInfoBgView.width = 130;
        self.audienceTableView.left = self.myInfoBgView.right + 10;
        self.audienceTableView.width = SCREEN_WIDTH - self.myInfoBgView.right - 10;
        [self showAttentDelayHiddenAnimation];
    }
    
    UIImage *recBgImg = [UIImage imageNamed:@"image/liveroom/me_ub_bg"];
    UIEdgeInsets insetsHead = UIEdgeInsetsMake(0, 5, 0, 40);
    
    // 指定为拉伸模式，伸缩后重新赋值
    recBgImg = [recBgImg resizableImageWithCapInsets:insetsHead resizingMode:UIImageResizingModeStretch];
    self.recvBgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, self.myInfoBgView.bottom + 15, recBgImg.size.width, recBgImg.size.height)];
    self.recvBgImgView.image = recBgImg;
    [self addSubview:self.recvBgImgView];
    
    self.recvPromptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 35, self.recvBgImgView.height)];
    self.recvPromptLabel.textAlignment = NSTextAlignmentCenter;
    self.recvPromptLabel.textColor = ColorPink;
    self.recvPromptLabel.font = [UIFont systemFontOfSize:10.f];
    self.recvPromptLabel.text = ESLocalizedString(@"有美币");
    self.recvPromptLabel.textColor = [UIColor redColor];
    [self.recvBgImgView addSubview:self.recvPromptLabel];
    
    self.recvCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.recvPromptLabel.right, 0, 24, self.recvBgImgView.height)];
    self.recvCountLabel.textAlignment = NSTextAlignmentCenter;
    self.recvCountLabel.textColor = [UIColor whiteColor];
    self.recvCountLabel.font = [UIFont systemFontOfSize:11.f];
    self.recvCountLabel.text = @"0";
    [self.recvBgImgView addSubview:self.recvCountLabel];
    
    // 更新收入
    [self updateRecvDiamond];
    
    self.medalView = [[UIView alloc] initWithFrame:CGRectMake(10, self.recvBgImgView.bottom + 10, SCREEN_WIDTH - 20, 40)];
    [self addSubview:self.medalView];
    self.medalView.hidden = YES;
    
    self.medalFirstView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.medalView.height, self.medalView.height)];
    [self.medalView addSubview:self.medalFirstView];
    self.medalFirstView.hidden = YES;
    
    self.medalSecondView = [[UIImageView alloc] initWithFrame:CGRectMake(self.medalFirstView.right + 10, 0, self.medalView.height, self.medalView.height)];
    [self.medalView addSubview:self.medalSecondView];
    self.medalSecondView.hidden = YES;
    
    self.medalThreeView = [[UIImageView alloc] initWithFrame:CGRectMake(self.medalSecondView.right + 10, 0, self.medalView.height, self.medalView.height)];
    [self.medalView addSubview:self.medalThreeView];
    self.medalThreeView.hidden = YES;
    
    self.medalFourView = [[UIImageView alloc] initWithFrame:CGRectMake(self.medalThreeView.right + 10, 0, self.medalView.height, self.medalView.height)];
    [self.medalView addSubview:self.medalFourView];
    self.medalFourView.hidden = YES;
    
    // 弹幕
    self.barrageView = [[BarrageAllMsgView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT / 2 - 70, SCREEN_WIDTH, 120.f)];
    [self addSubview:self.barrageView];
    
    self.allShowGiftView = [[LiveAllShowGiftView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT / 2 - 50, 290.f, 130.f)];
    [self addSubview:self.allShowGiftView];
    
    self.showGroupMsgView = [[ShowGroupMsgView alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT - 140 - 50, SCREEN_WIDTH - 70, 140)];
    self.showGroupMsgView.showUserSpaceBlock = ^(LiveUser *liveUser) {
        ESStrongSelf;
        
        [_self.delegate showUserSpaceVC:liveUser];
    };
    
    self.showGroupMsgView.reviewUserBlock = ^(LiveUser *liveUser) {
        ESStrongSelf;
        
        [_self reviewUser:@{@"nickname":liveUser.userName}];
    };
    
    [self addSubview:self.showGroupMsgView];
    self.showGroupMsgView.contentTable.contentInset = UIEdgeInsetsMake(self.showGroupMsgView.height, 0, 0, 0);
    
    UIImage *roomEnterImg = [UIImage imageNamed:@"image/liveroom/room_enter_2"];
    
    self.enterRoomAnimView = [[EnterRoomAnimView alloc] initWithFrame:CGRectMake(0, self.showGroupMsgView.top - roomEnterImg.size.height - 10, SCREEN_WIDTH, roomEnterImg.size.height)];
    [self addSubview:self.enterRoomAnimView];
    
    if ([LCMyUser mine].liveType == LIVE_DOING) {
        // 主播
        // 送红包按钮
        UIImage *sendPacketImg = [UIImage imageNamed:@"image/liveroom/send_redpacket"];
        UIButton *sendPacketBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendPacketBtn setImage:sendPacketImg forState:UIControlStateNormal];
        [sendPacketBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        sendPacketBtn.frame = CGRectMake(SCREEN_WIDTH - sendPacketImg.size.width, self.audienceTableView.bottom + 35, sendPacketImg.size.width, sendPacketImg.size.height);
        
        [sendPacketBtn addTarget:self action:@selector(sendPacketAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sendPacketBtn];
    }
    
    self.enterContentView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 35)];
    [self addSubview:self.enterContentView];
    self.enterContentView.backgroundColor = UIColorWithRGBA(222, 222, 222, 0.8);
//    self.enterContentView.hidden = YES;
    
    UIImage *switchCloseImg = [UIImage imageNamed:@"image/liveroom/switch_barrage_close"];
    self.brrageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.brrageBtn setImage:switchCloseImg forState:UIControlStateNormal];
    [self.brrageBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    self.brrageBtn.frame = CGRectMake(0, 4, switchCloseImg.size.width/3, switchCloseImg.size.height/3);
    
    [self.brrageBtn addTarget:self action:@selector(barrageAction) forControlEvents:UIControlEventTouchUpInside];
    [self.enterContentView addSubview:self.brrageBtn];
    
    self.sendMsgBtn = [ESButton buttonWithTitle:ESLocalizedString(@"发送")];
    self.sendMsgBtn.buttonColor = [UIColor clearColor];
    [self.sendMsgBtn setTitleColor:ColorPink forState:UIControlStateNormal];
    self.sendMsgBtn.backgroundColor = [UIColor clearColor];
    self.sendMsgBtn.frame = CGRectMake(SCREEN_WIDTH - 60, 0, 60, self.enterContentView.height);
    
    [self.sendMsgBtn addTarget:self action:@selector(sendMsgAction) forControlEvents:UIControlEventTouchUpInside];
    [self.enterContentView addSubview:self.sendMsgBtn];
    
    self.contentContainerView = [[UIView alloc] initWithFrame:CGRectMake(self.brrageBtn.right + 4, 0, SCREEN_WIDTH - self.brrageBtn.right- 4 - self.sendMsgBtn.width - 4, 35)];
    // 发送框容器
    self.contentContainerView.backgroundColor = RGBA16(COLOR_BG_ALPHAWHITE);
    self.contentContainerView.layer.cornerRadius = 5;
    self.contentContainerView.clipsToBounds = YES;
    self.contentContainerView.hidden = YES;
    [self.enterContentView addSubview:self.contentContainerView];
    
    // 消息编辑框
    self.contentTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.brrageBtn.right + 14, 0, SCREEN_WIDTH - self.brrageBtn.right - 14 - self.sendMsgBtn.width - 4, 35)];
    self.contentTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:ESLocalizedString(@"说点什么吧") attributes:@{NSForegroundColorAttributeName:RGB16(COLOR_BG_WHITE)}];
    self.contentTextField.backgroundColor = [UIColor clearColor];
    self.contentTextField.borderStyle = UITextBorderStyleNone;
    self.contentTextField.textColor = [UIColor whiteColor];
    self.contentTextField.delegate = self;
    self.contentTextField.font = [UIFont systemFontOfSize:14.f];
    [self.contentTextField setReturnKeyType:UIReturnKeySend];
    [self.enterContentView addSubview:self.contentTextField];
    
    [self.contentTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.mTrumpetView = [[UIView alloc] initWithFrame:CGRectMake(0, 130, ScreenWidth, 25)];
    self.mTrumpetView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.mTrumpetView];
    self.mTrumpetView.hidden = YES;
    
    UIView *trumpetBackgroundView = [[UIView alloc] initWithFrame:self.mTrumpetView.bounds];
    trumpetBackgroundView.backgroundColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:0.3];
    [self.mTrumpetView addSubview:trumpetBackgroundView];
    
    UIImageView *trumpetImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image/liveroom/room_trumpet"]];
    trumpetImageView.center = CGPointMake(35, self.mTrumpetView.height / 2);
    [self.mTrumpetView addSubview:trumpetImageView];
    
    UIView *trumpetClipView = [[UIView alloc] initWithFrame:CGRectMake(trumpetImageView.right, 0, self.mTrumpetView.width - trumpetImageView.right, self.mTrumpetView.height)];
    trumpetClipView.clipsToBounds = YES;
    [self.mTrumpetView addSubview:trumpetClipView];
    
    UILabel *trumpetLabel = [[UILabel alloc] init];
    trumpetLabel.left = self.mTrumpetView.width + 10;
    trumpetLabel.top = self.mTrumpetView.height / 2 - trumpetLabel.height / 2;
    trumpetLabel.textColor = [UIColor whiteColor];
    trumpetLabel.tag = 10;
    trumpetLabel.font = [UIFont systemFontOfSize:15];
    [trumpetClipView addSubview:trumpetLabel];
    
#ifdef DEBUG
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // [self playTrumpetWithDict:@{@"system_content":@"阿火送了 一个 梦幻城堡 给小龙", @"sender":@"阿火", @"target":@"小龙", @"gift_name":@"梦幻城堡"}];
    });
#endif
    
    UIImage *msgImage = [UIImage imageNamed:@"image/liveroom/roommsg"];
    UIImage *gameImage = [UIImage imageNamed:@"image/games/ic_live_bottom_plugins"];
//    UIImage *startImage = [UIImage imageNamed:@"image/games/ic_bottom_start"];
    UIImage *waitImage = [UIImage imageNamed:@"image/games/ic_bottom_waiting"];
    UIImage *hideGameImage = [UIImage imageNamed:@"image/games/ic_live_hide_plugin"];
//    UIImage *showGameImage = [UIImage imageNamed:@"image/games/ic_live_show_plugin"];
    
    UIImage *roomShutImage = [UIImage imageNamed:@"image/liveroom/roomshut"];
    UIImage *drawImage = [UIImage imageNamed:@"image/liveroom/draw_gift"];
    UIImage *cameraNormalImage = [UIImage imageNamed:@"image/liveroom/room_btn_shan_h"];
    UIImage *cameraFocusImage = [UIImage imageNamed:@"image/liveroom/room_btn_shan_n"];
    
    UIImage *roomGiftImage = [UIImage imageNamed:@"image/liveroom/roomgift"];
    UIImage *roomChatImage = [UIImage imageNamed:@"image/liveroom/roomchat"];
    UIImage *roomshareImage = [UIImage imageNamed:@"image/liveroom/roomshare"];
//    UIImage *captureImage = [UIImage imageNamed:@"image/liveroom/short_record"];
    
    UIImage *connectChatImage = [UIImage imageNamed:@"image/liveroom/room_up_voice"];
    
    UIImage *giftAnimNoImage = [UIImage imageNamed:@"image/liveroom/room_gift_anim_yes"];
    UIImage *activeImage = [UIImage imageNamed:@"image/liveroom/roomactive"];
    
    float viewSize = msgImage.size.width;
    self.badgeView = [ESBadgeView badgeViewWithText:@"0"];
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - viewSize - 10 - self.badgeView.height / 2, SCREEN_WIDTH, viewSize + 10 + self.badgeView.height / 2)];
    [self addSubview:self.bottomView];
    
    self.msgBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, self.badgeView.height / 2, viewSize, viewSize)];
    self.msgBtn.backgroundColor = [UIColor clearColor];
    [self.msgBtn setImage:msgImage forState:UIControlStateNormal];
    [self.msgBtn addTarget:self action:@selector(showMsgAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.msgBtn];
    self.msgBtn.hidden = NO;
    
    if ([LCMyUser mine].liveType == LIVE_DOING)
    {
        // 观众可以有上麦功能
        UIImage *closeUpMike = [UIImage imageNamed:@"image/liveroom/close_upmike_icon"];
        
        self.exitUpMikeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.msgBtn.right + 10, self.badgeView.height / 2, closeUpMike.size.width, closeUpMike.size.height)];
        [self.exitUpMikeBtn setImage:closeUpMike forState:UIControlStateNormal];
        [self.exitUpMikeBtn addTarget:self action:@selector(exitUpMikeAction) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.exitUpMikeBtn];
        self.exitUpMikeBtn.hidden = YES;
        
        UIImage *cancelUpMike = [UIImage imageNamed:@"image/liveroom/cancel_upmike_icon"];
        self.cancelInviteBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.msgBtn.right + 10, self.badgeView.height / 2, cancelUpMike.size.width, cancelUpMike.size.height)];
        [self.cancelInviteBtn setImage:cancelUpMike forState:UIControlStateNormal];
        [self.cancelInviteBtn addTarget:self action:@selector(cancelInviteAction) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.cancelInviteBtn];
        self.cancelInviteBtn.hidden = YES;
    }
    
    self.mRefreshBtn = [[UIButton alloc] initWithFrame:self.msgBtn.bounds];
    [self.mRefreshBtn setBackgroundImage:[UIImage imageNamed:@"image/liveroom/room_pop_up_camera_p"] forState:UIControlStateNormal];
    self.mRefreshBtn.backgroundColor = [UIColor clearColor];
    [self.mRefreshBtn addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventTouchUpInside];
    self.mRefreshBtn.left = self.msgBtn.right;
    self.mRefreshBtn.bottom = self.msgBtn.bottom;
    // [self.bottomView addSubview:self.mRefreshBtn];
    
    self.connectFlagImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, connectChatImage.size.width, connectChatImage.size.height)];
    self.connectFlagImgView.image = connectChatImage;
    self.connectFlagImgView.centerY = _bottomView.centerY;
    [self.bottomView addSubview:_connectFlagImgView];
    
    self.closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - viewSize - 10, self.badgeView.height / 2, viewSize, viewSize)];
    [self.closeBtn setImage:roomShutImage forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closeLiveView) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.closeBtn];
    
    float leftX = 0.f;
    if ([LCMyUser mine].liveType == LIVE_DOING || [LCMyUser mine].liveType == LIVE_WATCH) {
        self.gameView = [[LCGameView alloc] initWithFrame:CGRectMake(0, ScreenHeight, self.width, kGameViewHeight)];
        self.gameView.delegate = self;
        [self addSubview:self.gameView];
        
        CGFloat width = 100;
        CGFloat height = 100;
        self.betSuccView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2-width/2, ScreenHeight/2-height/2, width, height)];
        self.betSuccView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.betSuccView];
        self.betSuccView.hidden = YES;
        
        UIImage *failImage = [UIImage imageNamed:@"image/games/toast_jy"];
        CGFloat imgWidth = failImage.size.width;
        CGFloat imgHeight = failImage.size.height;
        self.betFailView = [[UIImageView alloc] initWithImage:failImage];
        self.betFailView.frame = CGRectMake(ScreenWidth/2-imgWidth/2, ScreenHeight/2-imgHeight/2, imgWidth, imgHeight);
        [self.betFailView setImage:failImage];
        [self addSubview:self.betFailView];
        self.betFailView.hidden = YES;
        
    }
    if ([LCMyUser mine].liveType == LIVE_DOING)
    {
        self.switchCameraBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.closeBtn.left - viewSize - 10, self.badgeView.height / 2, viewSize, viewSize)];
        // self.switchCameraBtn.backgroundColor = [UIColor clearColor];
        [self.switchCameraBtn setImage:cameraNormalImage forState:UIControlStateNormal];
        [self.switchCameraBtn setImage:cameraFocusImage forState:UIControlStateHighlighted];
        [self.switchCameraBtn addTarget:self action:@selector(switchCamera) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.switchCameraBtn];
        
        leftX = self.switchCameraBtn.left;
        
        //game button
        self.gameBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.msgBtn.right+8, self.badgeView.height/2, viewSize, viewSize)];
        [self.gameBtn setImage:gameImage forState:UIControlStateNormal];
        [self.gameBtn addTarget:self action:@selector(showGameListView) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.gameBtn];
        //发牌command new
        self.startBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.gameBtn.right+8, self.badgeView.height/2, viewSize, viewSize)];
        [self.startBtn setImage:waitImage forState:UIControlStateNormal];
        [self.startBtn setEnabled:NO];
        [self.startBtn addTarget:self action:@selector(startAGame) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.startBtn];
        self.startBtn.hidden = YES;
        // hide game view
        self.hideGameBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.startBtn.right+8, self.badgeView.height/2, viewSize, viewSize)];
        [self.hideGameBtn setImage:hideGameImage forState:UIControlStateNormal];
        
        [self.hideGameBtn addTarget:self action:@selector(shouldHideGameView) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.hideGameBtn];
        self.hideGameBtn.hidden = YES;
        //game view 在上面
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameComesToAnEnd) name:kGameResultDidShowNotification object:nil];
    }
    else if ([LCMyUser mine].liveType == LIVE_UPMIKE)
    {
        self.switchCameraBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.closeBtn.left - viewSize - 10, self.badgeView.height / 2, viewSize, viewSize)];
        // self.switchCameraBtn.backgroundColor = [UIColor clearColor];
        [self.switchCameraBtn setImage:cameraNormalImage forState:UIControlStateNormal];
        [self.switchCameraBtn setImage:cameraFocusImage forState:UIControlStateHighlighted];
        [self.switchCameraBtn addTarget:self action:@selector(switchCamera) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.switchCameraBtn];
        
        self.giftBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.switchCameraBtn.left - viewSize - 10, self.badgeView.height / 2, viewSize, viewSize)];
        // self.giftBtn.backgroundColor = [UIColor clearColor];
        [self.giftBtn setImage:roomGiftImage forState:UIControlStateNormal];
        [self.giftBtn addTarget:self action:@selector(showGiftView) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.giftBtn];
        leftX = self.giftBtn.left;
    }
    else
    {
        self.giftBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.closeBtn.left - viewSize - 10, self.badgeView.height / 2, viewSize, viewSize)];
        // self.giftBtn.backgroundColor = [UIColor clearColor];
        [self.giftBtn setImage:roomGiftImage forState:UIControlStateNormal];
        [self.giftBtn addTarget:self action:@selector(showGiftView) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.giftBtn];
        leftX = self.giftBtn.left;
        
        self.mDrawBtn = [[UIButton alloc] initWithFrame:self.giftBtn.frame];
        self.mDrawBtn.right = self.giftBtn.left - 10;
        [self.mDrawBtn setImage:drawImage forState:UIControlStateNormal];
        [self.mDrawBtn addTarget:self action:@selector(showDrawGiftView) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.mDrawBtn];
        
        self.mDrawGiftView = [[DrawGiftView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, SCREEN_HEIGHT)];
        [self addSubview:self.mDrawGiftView];
        self.mDrawGiftView.mDrawDelegate = self;
        self.mDrawGiftView.hidden = YES;
        
        leftX = self.mDrawBtn.left;
    }
    
    isShowGiftAnim = YES;
    
    if ([LCMyUser mine].liveType == LIVE_DOING || [LCMyUser mine].liveType == LIVE_UPMIKE)
    {
        self.shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(leftX - viewSize - 10, self.badgeView.height / 2, viewSize, viewSize)];
        // self.shareBtn.backgroundColor = [UIColor clearColor];
        [self.shareBtn setImage:roomshareImage forState:UIControlStateNormal];
        [self.shareBtn addTarget:self action:@selector(showShareAction) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.shareBtn];
        
        self.priChatBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.shareBtn.left - viewSize - 10, self.badgeView.height / 2, viewSize, viewSize)];
        // self.priChatBtn.backgroundColor = [UIColor clearColor];
        [self.priChatBtn setImage:roomChatImage forState:UIControlStateNormal];
        [self.priChatBtn addTarget:self action:@selector(showPrivChatView) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.priChatBtn];
        
        self.showGiftAnimStateBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.priChatBtn.left - viewSize - 10, self.badgeView.height / 2, viewSize, viewSize)];
        // self.priChatBtn.backgroundColor = [UIColor clearColor];
        [self.showGiftAnimStateBtn setImage:giftAnimNoImage forState:UIControlStateNormal];
        [self.showGiftAnimStateBtn addTarget:self action:@selector(contollerAnimShowAction) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.showGiftAnimStateBtn];
        
        self.activeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.showGiftAnimStateBtn.left - viewSize - 10, self.badgeView.height / 2, viewSize, viewSize)];
        self.activeBtn.backgroundColor = [UIColor clearColor];
        if (self.mActivtyImageUrl) {
            [self.activeBtn sd_setImageWithURL:[NSURL URLWithString:self.mActivtyImageUrl] forState:UIControlStateNormal];
        } else {
            [self.activeBtn setImage:activeImage forState:UIControlStateNormal];
        }
        [self.activeBtn addTarget:self action:@selector(onShowActiveVC) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.activeBtn];
        self.activeBtn.hidden = YES;
    } else {
        self.shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(leftX - viewSize - 10, self.badgeView.height / 2, viewSize, viewSize)];
        // self.shareBtn.backgroundColor = [UIColor clearColor];
        [self.shareBtn setImage:roomshareImage forState:UIControlStateNormal];
        [self.shareBtn addTarget:self action:@selector(showShareAction) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.shareBtn];
        
        self.priChatBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.shareBtn.left - viewSize - 10, self.badgeView.height / 2, viewSize, viewSize)];
        // self.priChatBtn.backgroundColor = [UIColor clearColor];
        [self.priChatBtn setImage:roomChatImage forState:UIControlStateNormal];
        [self.priChatBtn addTarget:self action:@selector(showPrivChatView) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.priChatBtn];
        
        self.captureBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.priChatBtn.left - viewSize - 10, self.badgeView.height / 2, viewSize, viewSize)];
//        [self.captureBtn setImage:captureImage forState:UIControlStateNormal];
        [self.captureBtn setTitle:@"录制" forState:UIControlStateNormal];
        [self.captureBtn setImage:[UIImage imageNamed:@"image/liveroom/capture"] forState:UIControlStateNormal];
        [self.captureBtn addTarget:self action:@selector(captureAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.captureBtn];
//        self.activeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.priChatBtn.left - viewSize - 10, self.badgeView.height / 2, viewSize, viewSize)];
//        self.activeBtn.backgroundColor = [UIColor clearColor];
//        if (self.mActivtyImageUrl) {
//            [self.activeBtn sd_setImageWithURL:[NSURL URLWithString:self.mActivtyImageUrl] forState:UIControlStateNormal];
//        } else {
//            [self.activeBtn setImage:activeImage forState:UIControlStateNormal];
//        }
//        [self.activeBtn addTarget:self action:@selector(onShowActiveVC) forControlEvents:UIControlEventTouchUpInside];
//        [self.bottomView addSubview:self.activeBtn];
//        self.activeBtn.hidden = YES;
    }
    
    self.badgeView.left = self.priChatBtn.right - viewSize / 2;
    self.badgeView.top =  0;
    [self.bottomView addSubview:self.badgeView];
    
    if ([IMBridge bridge].countOfTotalUnreadMessages > 0) {
        self.badgeView.hidden = NO;
        self.badgeView.text = [NSString stringWithFormat:@"%d", [IMBridge bridge].countOfTotalUnreadMessages];
    } else {
        self.badgeView.hidden = YES;
    }
    
    [self addKeyboardNotification];
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    singleRecognizer.delegate = self;
    [self addGestureRecognizer:singleRecognizer];
    
    // 礼物列表
    self.giftView = [[LiveGiftView alloc] initWithFrame:CGRectZero];
    self.giftView.showRechargeBlock = ^() {
        ESStrongSelf;
        
        [_self.delegate showRechargeVC];
    };
    
    self.giftView.sendGiftBlock = ^(NSDictionary *giftDict) {
        ESStrongSelf;
        
        int grade = [giftDict[@"grade"] intValue];
        if (grade > [LCMyUser mine].userLevel) {
            [LCMyUser mine].userLevel = grade;
            
            NSMutableDictionary *socket = [NSMutableDictionary dictionary];
            socket[@"type"] = LIVE_GROUP_UPGRADE;                                   // 消息类型
            socket[@"uid"] = [LCMyUser mine].userID;                                // 用户id
            socket[@"nickname"] = [LCMyUser mine].nickname;                         // 用户昵称
            socket[@"grade"] = [NSNumber numberWithInt:[LCMyUser mine].userLevel];  // 用户等级
            
            [LiveMsgManager sendUserUpGrade:socket Succ:nil andFail:nil];
            [_self addMessage:@"upgrade" andUserInfo:socket];
        }
        
        if ([giftDict[@"gift_type"] intValue] == GIFT_TYPE_CONTINUE) {
            // 连续礼物动画
            if (_self.allShowGiftView) {
                [_self.allShowGiftView showGiftView:giftDict];
            }
        } else if ([giftDict[@"gift_type"] intValue] == GIFT_TYPE_REDPACKET) {
            // 红包
            [_self.contentTextField resignFirstResponder];
            [RedPacketManager redPacketManager].redPacketDict = giftDict;
        } else if ([giftDict[@"gift_type"] intValue] == GIFT_TYPE_LUXURY) {
            // 豪华礼物
            [LuxuryManager luxuryManager].luxuryDict = giftDict;
        }
        
        [_self addMessage:@"gift" andUserInfo:giftDict];
    };
    [self addSubview:self.giftView];
    self.giftView.hidden = YES;
    
    shareView = [[RoomShareView alloc] initWithFrame:CGRectZero];
    [self addSubview:shareView];
    shareView.hidden = YES;
    
    [self setManangerView];
    if (self.mDrawGiftView) {
        [self bringSubviewToFront:self.mDrawGiftView];
    }
    
    self.captureView = [[CaptureView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 150.f)];
    self.captureView.delegate = self;
    [self addSubview:self.captureView];
    
    [super awakeFromNib];
}

- (void)setMActivtyImageUrl:(NSString *)mActivtyImageUrl
{
    if (mActivtyImageUrl)
    {
        [self.activeBtn sd_setImageWithURL:[NSURL URLWithString:mActivtyImageUrl] forState:UIControlStateNormal];
    }
}


#pragma mark - 画图

- (void)showDrawGiftView
{
    self.mDrawGiftView.hidden = NO;
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.bottomView.top = SCREEN_HEIGHT;
                         _showGroupMsgView.hidden = YES;
                     }
                     completion:^(BOOL finished){
                         self.bottomView.hidden = YES;
                     }];
}


- (void)setActiveDict:(NSDictionary *)activeDict
{
    _activeDict = activeDict;
    if (_activeDict && _activeDict[@"title"]) {
        _activeBtn.hidden = NO;
    } else {
        _activeBtn.hidden = YES;
    }
}


#pragma mark - 显示送礼物

// - (void)dealShowGiftAsync
// {
//     if (!__gShowGiftMessagesQueue) {
//         __gShowGiftMessagesQueue = dispatch_queue_create("com.qianchuo.ShowGiftQueue", DISPATCH_QUEUE_SERIAL);
//     }
// }


#pragma mark - 显示我送出的礼物

- (void)showMineSendGift:(NSDictionary *)giftDict
{
    NSString *showMsg = [GroupMsgCell CellContent:giftDict];
    if (!showMsg) {
        return;
    }
    
    NSMutableDictionary *msgUpdateDict = [NSMutableDictionary dictionaryWithDictionary:giftDict];
    [msgUpdateDict setObject:showMsg forKey:@"show_msg"];
    
    int labHeight = [ShowGroupMsgView getTxtSize:showMsg withUserGrade:[giftDict[@"grade"] intValue] withGift:[giftDict[@"type"] isEqualToString:LIVE_GROUP_GIFT] ? YES : NO withContentWidth:self.showGroupMsgView.contentTable.width];
    
    [msgUpdateDict setObject:@(labHeight) forKey:@"height"];
    
    if ([giftDict[@"type"] isEqualToString:LIVE_GROUP_GIFT]) {
       [[[ParseContentCommon alloc] init] parseGiftMsg:showMsg withMsgInfo:msgUpdateDict];
    }
    
    if (labHeight == 0) {
        return;
    }
    
    [self addMessage:@"gift" andUserInfo:msgUpdateDict];
}


// 审核的view
- (void)setManangerView
{
    self.mSuperManagerView = [[UIView alloc] initWithFrame:CGRectMake(10, 115, ScreenWidth - 20, 300)];
    // self.mSuperManagerView.backgroundColor = [UIColor yellowColor];
    self.mSuperManagerView.hidden = YES;
    
    self.mAlertView = [[UIView alloc] initWithFrame:CGRectMake(10, 115, ScreenWidth - 20, ScreenHeight - 300)];
    self.mAlertView.backgroundColor = [UIColor blackColor];
    self.mAlertView.hidden = YES;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.mAlertView.width - 30, self.mAlertView.height)];
    label.numberOfLines = 5;
    label.text = @"警告！直播时请遵守社区文明公约，杜绝引诱、裸露、挂机、黑屏、不露脸等违规内容。";
    label.textColor = [UIColor redColor];
    [self.mAlertView addSubview:label];
    label.font = [UIFont systemFontOfSize:23];
    label.center = CGPointMake(self.mAlertView.width / 2, self.mAlertView.height / 2);
    [self addSubview:self.mAlertView];
    
    [self addSubview:self.mSuperManagerView];
    [self addManagerButtonWithTitle:@"禁止直播" tag:2 top:0 right:0];
    [self addManagerButtonWithTitle:@"关闭直播" tag:1 top:40 right:0];
    [self addManagerButtonWithTitle:@"隐藏直播" tag:5 top:80 right:0];
    [self addManagerButtonWithTitle:@"警告主播" tag:7 top:120 right:0];
    [self addManagerButtonWithTitle:@"操作记录" tag:9 top:160 right:0];
    
    [self addManagerButtonWithTitle:@"推荐直播" tag:3 top:0 right:self.mSuperManagerView.width];
    [self addManagerButtonWithTitle:@"置顶直播" tag:4 top:40 right:self.mSuperManagerView.width];
    [self addManagerButtonWithTitle:@"审核通过" tag:6 top:80 right:self.mSuperManagerView.width];
    [self addManagerButtonWithTitle:@"取消警告" tag:8 top:120 right:self.mSuperManagerView.width];
}

- (void)addManagerButtonWithTitle:(NSString *)title tag:(long)tag top:(long)top right:(long)right {
    ESButton *mSuperManagerButton = [ESButton buttonWithTitle:title];
    mSuperManagerButton.tag = tag;
    mSuperManagerButton.opaque = YES;
    mSuperManagerButton.color = ColorPink;
    mSuperManagerButton.top = top;
    
    if (right) {
        mSuperManagerButton.right = right;
    }
    
    [mSuperManagerButton addTarget:self action:@selector(onOperationAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.mSuperManagerView addSubview:mSuperManagerButton];
}

- (void)showAlertWith:(id)value {
    if ([value isKindOfClass:[NSString class]]) {
        self.mAlertView.hidden = ![(NSString *)value intValue];
    }
    else if ([value isKindOfClass:[NSNumber class]]) {
        self.mAlertView.hidden = ![(NSNumber *)value intValue];
    }
}

- (void)addKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    // [[NSNotificationCenter defaultCenter] addObserver:self
    //                                          selector:@selector(livingViewKeyboardHiden:)
    //                                              name:UIKeyboardWillChangeFrameNotification
    //                                            object:nil];
}

- (void)livingViewKeyboardHiden:(NSNotification *)note {
    // [self handleKeyboardWillHide:note];
}

- (void)completeInput
{
    if (_contentTextField) {
        [self textFieldShouldReturn:_contentTextField];
    }
}


#pragma mark - 刷新聊天信息

- (void)onRefresh {
    if (![LCMyUser mine].liveUserId) {
        return;
    }
    
    ESWeakSelf;
    
    [[IMBridge bridge] joinRoom:[LCMyUser mine].liveUserId completion:^(NSError *error) {
        NSLogIf(error, @"join room error: %@", error);
        
        ESStrongSelf;
        
        NSMutableDictionary *systemDict = [NSMutableDictionary dictionary];
        systemDict[@"type"] = LIVE_GROUP_SYSTEM_MSG;                        // 消息类型
        systemDict[@"system_content"] = @"重新连接服务器成功";                 // 系统消息
        
        [_self addMessage:nil andUserInfo:systemDict];
    }];
}


#pragma mark - 连接聊天标记

- (void)connectChatFlag
{
    self.msgBtn.hidden = NO;
    self.connectFlagImgView.hidden = YES;
}

#pragma mark-  显示游戏列表
- (void)showGameListView
{
    NSArray *titleArray = @[@"牛牛"];
    UIImage *img = [UIImage imageNamed:@"image/games/ic_game_list_niuniu"];
    NSArray *imageArray = @[img];
    [LiveGameListView showGridMenuWithTitle:ESLocalizedString(@"游戏列表")
                                 itemTitles:titleArray
                                     images:imageArray
                             selectedHandle:^(NSInteger index) {
                                 [self chooseGameAtIndex:index];
    }];
}

/**
 点击发牌按钮
 */
- (void)startAGame
{
    [self.startBtn setEnabled:NO];
    UIImage *waitImage = [UIImage imageNamed:@"image/games/ic_bottom_waiting"];
    [self.startBtn setImage:waitImage forState:UIControlStateNormal];
    [self startAGameWithType:self.currentGameType];
}

/**
 开始游戏（发送指令）
    游戏动画在收到socket game_new或game_poll时才开始
 @param type 游戏类型
 */
- (void)startAGameWithType:(NSInteger)type
{
    /**
     通知PushViewController 开始游戏(发牌 cmd: new)
     
     @param livingViewDidChooseGameAtIndex:
     @return
     */
    if (self.delegate && [self.delegate respondsToSelector:@selector(livingViewDidChooseGameAtIndex:)]) {
        [self.delegate performSelector:@selector(livingViewDidChooseGameAtIndex:) withObject:@(type)];
    }
////    __weak typeof(self)weakself = self;
//    if (self.gameState != LivingViewShowGameStateCounting) {
//        
////        [self.gameView startWithCompletionHandler:^{
////            //        __strong typeof(weakself)_self = weakself;
////        }];
//        [self.gameView startWithAnimation:YES];
//    }else {
//        [self.gameView startWithAnimation:NO];
//    }
//    if (self.gameView.isHost) {
//        
//    }
    
}
//隐藏/开启游戏界面
- (void)shouldHideGameView
{
    if (self.gameView.top < ScreenHeight) {
        [self hideGameView];
        UIImage *showGameImage = [UIImage imageNamed:@"image/games/ic_live_show_plugin"];
        [self.hideGameBtn setImage:showGameImage forState:UIControlStateNormal];
    }else {
        [self showGameViewWithCompletionHandler:^{
            
        }];
        UIImage *hideGameImage = [UIImage imageNamed:@"image/games/ic_live_hide_plugin"];
        [self.hideGameBtn setImage:hideGameImage forState:UIControlStateNormal];
    }
}
#pragma mark- 游戏
/** 
    pragma 游戏方法中包含
    主播端：PushViewController才会调用的方法
    观众端：WatchCutLiveViewController才会调用的方法
    其它为均会调用的方法
 */
/**
  本轮游戏结束
 */
- (void)gameComesToAnEnd
{
    if (self.startBtn) {//主播端
        [self.startBtn setEnabled:YES];
        UIImage *startImage = [UIImage imageNamed:@"image/games/ic_bottom_start"];
        [self.startBtn setImage:startImage forState:UIControlStateNormal];
    }
    
    self.gameView.isShowing = NO;
}

/**
 主播端：选择游戏并开始

 @param index 游戏代号
 */
- (void)chooseGameAtIndex:(NSInteger)index
{
    if (index == self.currentGameType) {
        return;
    }
    
    if (index > 0) {
        [self.startBtn setHidden:NO];
        [self.hideGameBtn setHidden:NO];
        [self startAGameWithType:index];
//        [self.gameView showWithGameType:CurrentGameTypeNiuniu isHost:YES];
//        __weak typeof(self)weakself = self;
//        [self showGameViewWithCompletionHandler:^{
//            [weakself startAGameWithType:index];
//        }];
    }
}


/**
 观众端：下注操作

 @param completionHandler 下注操作回调
 */
- (void)betActionWithCompletionHander:(void (^)(NSInteger, NSInteger))completionHandler
{
    [self.gameView betActionWithCompletionHander:completionHandler];
}

/**
 下注成功后展示下注总额度

 @param betArray 包含下注额度端NSNumber数组
 */
- (void)showBetActionWithArray:(NSArray *)betArray
{
    self.betArray = betArray;
    [self.gameView showBetActionWithArray:betArray];
}
- (void)showMyBetActionWithArray:(NSArray *)betArray
{
    [self.gameView showMyBetActionWithArray:betArray];
}

/**
 显示倒计时

 @param counting 倒计时秒数
 */
- (void)timeOutCounting:(NSInteger)counting
{
    [self.gameView timeoutCounting:counting];
}

/**
 主播端：关闭游戏
 self.gameView代理方法
 */
- (void)gameShouldClose
{
    self.currentGameType = CurrenGameTypeNone;
    self.isInGame = NO;
    [self gameClosing];
}

/**
 主播端：- (void)gameShouldClose;的子方法
 */
- (void)gameClosing
{
    self.betArray = nil;
    [self.startBtn setHidden:YES];
    [self.hideGameBtn setHidden:YES];
    [self hideGameView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(livingViewDidCloseTheGame)]) {
        [self.delegate performSelector:@selector(livingViewDidCloseTheGame)];
        
    }
}

/**
 观众端：充值钻石
 self.gameView代理方法
 */
- (void)gameShouldRechargeDiamond
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(livingViewDiamondRecharge)]) {
        [self.delegate performSelector:@selector(livingViewDiamondRecharge)];
    }
    
}


/**
 游戏视图下移
 */
- (void)hideGameView
{
    CGRect msgGroupRect = self.showGroupMsgView.frame;
    msgGroupRect.origin.y += kGameViewHeight;
    
    CGRect bottomRect = self.bottomView.frame;
    bottomRect.origin.y += kGameViewHeight;
    CGRect gameRect = self.gameView.frame;
    gameRect.origin.y += kGameViewHeight;
    [UIView animateWithDuration:0.5 animations:^{
        self.showGroupMsgView.frame = msgGroupRect;
        self.bottomView.frame = bottomRect;
        self.gameView.frame = gameRect;
    }];
}

/**
 游戏视图上移

 @param handler 上移完成后回调
 */
- (void)showGameViewWithCompletionHandler:(void(^)())handler
{
    CGRect msgGroupRect = self.showGroupMsgView.frame;
    msgGroupRect.origin.y -= kGameViewHeight;
    CGRect bottomRect = self.bottomView.frame;
    bottomRect.origin.y -= kGameViewHeight;
    CGRect gameRect = self.gameView.frame;
    gameRect.origin.y -= kGameViewHeight;
    [UIView animateWithDuration:0.5 animations:^{
        self.showGroupMsgView.frame = msgGroupRect;
        self.bottomView.frame = bottomRect;
        self.gameView.frame = gameRect;
    } completion:^(BOOL finished) {
        if (handler) {
            handler();
        }
    }];
}

/**
 展示游戏结果

 @param dict 包含结果的数据
 */
- (void)showGameResultWithDict:(NSDictionary *)dict
{
    [self.gameView showResultWithDict:dict];
    NSInteger win = [[dict objectForKey:@"win"] integerValue];
    NSInteger bet = [self.betArray[win] integerValue];
    if (bet > 0) {
//        self.betSuccView.hidden = NO;
        LCGameSuccessView *customView = [[LCGameSuccessView alloc] initWithFrame:CGRectMake(0, 0, 280, 300)];
        customView.closeBlock = ^{
            [LEEAlert closeWithCompletionBlock:nil];
        };
        [LEEAlert alert].config
        .LeeCustomView(customView)
        .LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
        .LeeHeaderColor([UIColor clearColor])
        .LeeShow();
        
        
        
        
        
    } else {
        self.betFailView.hidden = NO;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.betFailView.hidden = YES;
    });
    self.gameView.isShowing = NO;
}

/**
 开始游戏动画（收到socket game_new命令)
 这里要分主播端和观众端，
 @param type 游戏类型
 */
- (void)showGameViewWithType:(CurrentGameType)type;
{
    
    _currentGameType = type;
    if (self.gameView.isShowing) {
        return;
    }
    self.gameView.isShowing = YES;
    
    [LEEAlert closeWithCompletionBlock:nil];
    [self.gameView showWithGameType:type isHost:_isHost];
    BOOL animated = self.gameState == LivingViewShowGameStateCounting ? NO : YES;
    if (!_isInGame) {
        _isInGame = YES;
        __weak typeof(self)weakself = self;
        [self showGameViewWithCompletionHandler:^{
            [weakself.gameView startWithAnimation:animated];
        }];
    }else {
        [self.gameView startWithAnimation:animated];
    }
//    if (self.isHost) {
//    }else {
//        [self.gameView showWithGameType:type isHost:NO];
//        if (!_isInGame) {
//            _isInGame = YES;
//            [self showGameViewWithCompletionHandler:^{
//                
//            }];
//        }
//    }
    
//    [self startAGameWithType:type];
}



/**
 观众端：展示游戏历史记录

 @param history 请求的历史记录数据
 
 */
- (void)showHistoryWithData:(NSArray *)history
{
    LCBetHistoryView *historyView = [[LCBetHistoryView alloc] initWithFrame:CGRectMake(0, 0, 280, 44*8) infoArray:history lineHeight:44];
    [LEEAlert alert].config
    .LeeTitle(@"历史记录")
    .LeeAddCustomView(^(LEECustomView *custom) {
        custom.view = historyView;
        custom.positionType = LEECustomViewPositionTypeCenter;
    })
    .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeCancelAction(@"确定", nil)
    .LeeShow();
    
}

/**
 观众端：展示游戏历史
 self.gameView代理方法
 */
- (void)showHistory
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(livingViewShowHistory)]) {
        [self.delegate performSelector:@selector(livingViewShowHistory)];
    }
}

#pragma mark - 显示主播荣耀

- (void)showAnchorMedal
{
    if ([LCMyUser mine].liveAnchorMedalArray && [LCMyUser mine].liveAnchorMedalArray.count > 0)
    {
        self.medalView.hidden = NO;
        
        if ([LCMyUser mine].liveAnchorMedalArray.count == 1) {
            [self.medalFirstView sd_setImageWithURL:[LCMyUser mine].liveAnchorMedalArray[0] placeholderImage:nil];
            self.medalFirstView.hidden = NO;
        } else if ([LCMyUser mine].liveAnchorMedalArray.count == 2) {
            [self.medalFirstView sd_setImageWithURL:[LCMyUser mine].liveAnchorMedalArray[0] placeholderImage:nil];
            [self.medalSecondView sd_setImageWithURL:[LCMyUser mine].liveAnchorMedalArray[1] placeholderImage:nil];
            self.medalFirstView.hidden = NO;
            self.medalSecondView.hidden = NO;
        } else if ([LCMyUser mine].liveAnchorMedalArray.count == 3) {
            [self.medalFirstView sd_setImageWithURL:[LCMyUser mine].liveAnchorMedalArray[0] placeholderImage:nil];
            [self.medalSecondView sd_setImageWithURL:[LCMyUser mine].liveAnchorMedalArray[1] placeholderImage:nil];
            [self.medalThreeView sd_setImageWithURL:[LCMyUser mine].liveAnchorMedalArray[2] placeholderImage:nil];
            self.medalFirstView.hidden = NO;
            self.medalSecondView.hidden = NO;
            self.medalThreeView.hidden = NO;
        } else {
            [self.medalFirstView sd_setImageWithURL:[LCMyUser mine].liveAnchorMedalArray[0] placeholderImage:nil];
            [self.medalSecondView sd_setImageWithURL:[LCMyUser mine].liveAnchorMedalArray[1] placeholderImage:nil];
            [self.medalThreeView sd_setImageWithURL:[LCMyUser mine].liveAnchorMedalArray[2] placeholderImage:nil];
            [self.medalFourView sd_setImageWithURL:[LCMyUser mine].liveAnchorMedalArray[3] placeholderImage:nil];
            self.medalFirstView.hidden = NO;
            self.medalSecondView.hidden = NO;
            self.medalThreeView.hidden = NO;
            self.medalFourView.hidden = NO;
        }
    } else {
        self.medalView.hidden = YES;
    }
}


#pragma mark - 关注主播

- (void)attentLiveUserAction
{
    if (isAttentLiveUser || ![LCMyUser mine].liveUserId) {
        return;
    }
    
    isAttentLiveUser = YES;
    
    ESWeakSelf;
    
    LCRequestSuccessResponseBlock successBlock = ^(NSDictionary *responseDic) {
        isAttentLiveUser = NO;
        
        ESStrongSelf;
        
        NSInteger code = [[responseDic objectForKey:@"stat"] integerValue];
        if (URL_REQUEST_SUCCESS == code)
        {
            [[LCMyUser mine] addAttentUser:[LCMyUser mine].liveUserId];
            [_self showAttentHiddenAnimation];
        }
        else
        {
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
    };
    
    LCRequestFailResponseBlock failBlock = ^(NSError *error) {
        [LCNoticeAlertView showMsg:@"请求获取数据！"];
        isAttentLiveUser = NO;
    };
    
    NSDictionary *paramter = @{@"u":[LCMyUser mine].liveUserId};
    NSLog(@"paramter: %@", paramter);
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:paramter
                                                  withPath:URL_ADD_ATTENT_USER
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}


#pragma mark - 显示动画

- (void)showAttentDelayHiddenAnimation
{
    ESWeakSelf;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ESStrongSelf;
        
        if (_self.attentBtn.hidden) {
            return;
        }
        
        [_self showAttentHiddenAnimation];
    });
}

- (void)showAttentHiddenAnimation
{
    [UIView animateWithDuration:.2 animations:^{
        self.attentBtn.width = 0;
        self.myInfoBgView.width = 90;
        self.audienceTableView.left = self.myInfoBgView.right + 10;
        self.audienceTableView.width = SCREEN_WIDTH - self.myInfoBgView.right - 10;
    } completion:^(BOOL finished) {
        if (!self.attentBtn.hidden) {
            self.attentBtn.hidden = YES;
        }
    }];
}


// 获取UIViewController
- (UIViewController *)viewController
{
    for (UIView *next = [self superview]; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)nextResponder;
        }
    }
    
    return nil;
}

#pragma mark - 禁止直播

- (void)onOperation:(UIButton *)sender {
    ESWeakSelf;
    
    if (sender.tag == 9)
    {
        // 弹出操作记录页面
        NSLog(@"JoyYou-YMLive :: show manage log");
        UIStoryboard *manageLogStroyBoard = [UIStoryboard storyboardWithName:@"ManageLog" bundle:nil];
        UIViewController *manageLogView = [manageLogStroyBoard instantiateViewControllerWithIdentifier:@"manageLog"];
        
        // [[self viewController].navigationController pushViewController:manageLogView animated:YES];
        UINavigationController *manageLogNavigator = [[UINavigationController alloc] initWithRootViewController:manageLogView];
        [[self viewController] presentViewController:manageLogNavigator animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alterView = [UIAlertView alertViewWithTitle:sender.currentTitle message:nil cancelButtonTitle:@"取消" didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex)
        {
            if (buttonIndex == 0) {
                ESStrongSelf;
                
                [_self requestWithOperation:sender.tag];
            }
        } otherButtonTitles:@"确认", nil];
        
        [alterView show];
    }
}

- (void)onOperationAction:(UIButton *)sender {
    [self onOperation:sender];
}

- (void)requestWithOperation:(long)type {
    if (![LCMyUser mine].liveUserId) {
        return;
    }
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"liveuid":[LCMyUser mine].liveUserId, @"type":@(type)}
                                                  withPath:URL_BAN_LIVE
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:^(NSDictionary *responseDic) {
                                              [LCNoticeAlertView showClearBackgroundMsg:@"操作成功"];
                                              
                                              if (type == 7 || type == 8) {
                                                  bool alert = type == 7;
                                                  [LiveMsgManager sendSystemMsg:@{@"system_content":@"警告！直播时请遵守社区文明公约，杜绝引诱、裸露、挂机、黑屏、不露脸等违规内容。", @"alert":[NSString stringWithFormat:@"%d", alert], @"type":LIVE_GROUP_SYSTEM_MSG} andSucc:nil andFail:nil];
                                              }
                                              
                                              // NSMutableDictionary *socket = [NSMutableDictionary dictionary];
                                              // socket[@"type"] = LIVE_GROUP_SYSTEM_MSG;                       // 消息类型
                                              // socket[@"system_content"] = msg;                               // 系统消息
                                          } withFailBlock:^(NSError *error) {
                                              [LCNoticeAlertView showClearBackgroundMsg:@"操作失败"];
                                          }];
}


#pragma mark - 聊天

- (void)showMsgAction
{
    self.bottomView.hidden = YES;
    self.gameView.hidden = YES;
    self.contentContainerView.hidden = NO;
    self.contentTextField.hidden = NO;
//    self.enterContentView.hidden = NO;
    if (self.contentTextField) {
      [self.contentTextField becomeFirstResponder];
    }
}

#pragma mark- 录制小视频
- (void)captureAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordShouldBegin)]) {
        [self.delegate performSelector:@selector(recordShouldBegin)];
    }
    /*
    ESWeakSelf
    [UIView animateWithDuration:0.5f
                     animations:^{
                         ESStrongSelf
                         
                         //self.bottomView.top = SCREEN_HEIGHT;
                         _self.captureView.bottom=SCREEN_HEIGHT;
//                         self.showGroupMsgView.hidden=YES;
                         [_self shouldBeginRecording:YES];
                         
                     }
                     completion:^(BOOL finished){
//                         self.bottomView.hidden = YES;
                     }];
    [self.captureView recordVideoWhenBegin:^(UIButton *beginBtn) {
        ESStrongSelf
        [_self recordDidBegin];
        [_self.delegate recordDidBegin];
        
    } end:^(UIButton *EndBtn) {
        [weak_self.delegate recordShouldEnd];
    }  andCancel:^(UIButton *cancelBtn) {
        ESStrongSelf
        [_self recordingDidCancelled];
        [_self.delegate recordDidCancelled];
    }];
    */
    
}

- (void)recordDidBegin
{
    for (UIView *subView in self.subviews) {
        if (shouldHidenViewArray && shouldHidenViewArray.count > 0 && [shouldHidenViewArray containsObject:subView]) {
            [subView setUserInteractionEnabled:NO];
            
        }
    }
}

- (void)recordFinished
{
    for (UIView *subView in self.subviews) {
        if (shouldHidenViewArray && shouldHidenViewArray.count > 0 && [shouldHidenViewArray containsObject:subView]) {
            [subView setUserInteractionEnabled:YES];
        }
        [shouldHidenViewArray removeAllObjects];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touches: %@,  event: %@", touches, event);
}

- (void)captureViewClose
{
    ESWeakSelf
    [UIView animateWithDuration:0.5f
                     animations:^{
                         ESStrongSelf
                         //self.bottomView.top = SCREEN_HEIGHT;
                         self.captureView.top=SCREEN_HEIGHT;
//                         self.bottomView.hidden = NO;
//                         self.showGroupMsgView.hidden=NO;
                         [self shouldBeginRecording:NO];
                         
                     }
                     completion:^(BOOL finished){
                     }];
}
- (void)shouldBeginRecording:(BOOL)begin
{

    if (begin) {
        for (UIView *subView in self.subviews) {
            if (self.captureView != subView && !subView.isHidden) {
                [shouldHidenViewArray addObject:subView];
                [subView setHidden:YES];
            }
        }
    }else {
        if (shouldHidenViewArray && shouldHidenViewArray.count > 0) {
            for (UIView *subView in shouldHidenViewArray) {
                [subView setHidden:NO];
            }
        }
    }
    
}
//captureView delegate

//-(void)onStartAction:(int)isstart{
//    
//    [self.delegate captureShortVideo:isstart];
//}
- (void)recordingDidCancelled
{
    ESWeakSelf
    [UIView animateWithDuration:0.5f
                     animations:^{
                         ESStrongSelf
                         //self.bottomView.top = SCREEN_HEIGHT;
                         self.captureView.top=SCREEN_HEIGHT;
                         //                         self.bottomView.hidden = NO;
                         //                         self.showGroupMsgView.hidden=NO;
                         [self shouldBeginRecording:NO];
                         
                     }
                     completion:^(BOOL finished){
                     }];}


#pragma mark - 显示私聊

- (void)showPrivChatView
{
    [self.delegate showConversationVC];
}


#pragma mark - 显示活动

- (void)onShowActiveVC
{
    if (self.delegate) {
        [self.delegate showActiveVC:_activeDict];
    }
}


#pragma mark - 控制显示礼物动画显示

- (void)contollerAnimShowAction
{
    if (isShowGiftAnim) {
        if (self.allShowGiftView) {
            [self.allShowGiftView hiddenGiftView];
        }
        
        isShowGiftAnim = NO;
        
        UIImage *giftAnimNoImage = [UIImage imageNamed:@"image/liveroom/room_gift_anim_no"];
        [self.showGiftAnimStateBtn setImage:giftAnimNoImage forState:UIControlStateNormal];
        
        [LCNoticeAlertView showMsg:ESLocalizedString(@"已屏蔽礼物特效")];
    } else {
        isShowGiftAnim = YES;
        UIImage *giftAnimNoImage = [UIImage imageNamed:@"image/liveroom/room_gift_anim_yes"];
        [self.showGiftAnimStateBtn setImage:giftAnimNoImage forState:UIControlStateNormal];
        
        [LCNoticeAlertView showMsg:ESLocalizedString(@"已开启礼物特效")];
    }
}


#pragma mark - 显示分享

- (void)showShareAction
{
    shareView.hidden = NO;
    [UIView animateWithDuration:0.5f animations:^{
        shareView.top = 0;
    }];
}


#pragma mark - 显示礼物

- (void)showGiftView
{
    self.giftView.hidden = NO;
    self.showGroupMsgView.hidden = YES;
    
    self.giftView.shapeDic = nil;
    
    [self.giftView setCurrentBalance];
    
    self.giftView.selectUserId = [LCMyUser mine].liveUserId;
    
    [self.giftView upDateGiftList];
    
    [UIView animateWithDuration:0.5f animations:^{
        self.giftView.top = SCREEN_HEIGHT - self.giftView.size.height;
    }];
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.bottomView.top = SCREEN_HEIGHT;
                     }
                     completion:^(BOOL finished){
                         self.bottomView.hidden = YES;
                     }];
    [self bringSubviewToFront:self.giftView];
}


#pragma mark - 关闭视图
- (IBAction)closeLivingView:(id)sender
{
    if(self.delegate) {
        [self.delegate closeLivingView:self];
    }
}

- (void)closeLiveView
{
    if(self.delegate)
    {
        [self.delegate closeLivingView:self];
    }
}


#pragma mark - 显示下麦

- (void)showExitUpMikeAction
{
    if (_exitUpMikeBtn) {
        _exitUpMikeBtn.hidden = NO;
    }
}


#pragma mark - 上麦成功或退出上麦时更新聊天区域显示范围

- (void)updateShowMsgArea:(BOOL)isUpMikeSucc withEixtUpMike:(BOOL)isExitUpMike
{
// if (self.showGroupMsgView) {
//     if (isUpMikeSucc) {
//         [UIView animateWithDuration:.5f animations:^{
//             self.showGroupMsgView.width = ScreenWidth * 3 / 5;
//         }];
//     }
//     
//     if (isExitUpMike) {
//         [UIView animateWithDuration:.5f animations:^{
//             self.showGroupMsgView.width = ScreenWidth - 70;
//         }];
//     }
// }
}

#pragma mark - 上麦

- (void)exitUpMikeAction
{
    if (self.delegate) {
        [self.delegate exitUpMikeAction:self];
    }
}


#pragma mark - 取消邀请

- (void)cancelInviteAction
{
    if (self.delegate) {
        [self.delegate cancelInviteAction:self];
    }
}


#pragma mark - 群聊回复

- (void)reviewUser:(NSDictionary *)userInfo
{
    self.contentTextField.text = [NSString stringWithFormat:@"@%@:", userInfo[@"nickname"]];
    [self showMsgAction];
}


#pragma mark - 举报

- (void)reportAction
{
    [[Business sharedInstance] liveReportSucc:^(NSString *msg, id data) {
        [LCNoticeAlertView showMsg:msg];
    } fail:^(NSString *error) {
        // if needed
    }];
}


#pragma mark - textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendMsgAction];
    
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == _contentTextField) {
        if (textField.text.length > 32) {
            textField.text = [textField.text substringToIndex:32];
        }
    }
}

// 发送消息
- (void)sendMsgAction
{
    NSString *weixinRegex = @"[a-zA-Z0-9\\s]{7,}";
    NSRange range = [self.contentTextField.text rangeOfString:weixinRegex options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        NSLog(@"range：%@", [self.contentTextField.text substringWithRange:range]);
        [self uploadFilterMsg:self.contentTextField.text];
        
        return;
    }
    
    [LCMyUser mine].isServerFilterAD = NO;
    [self startSendMsg];
}

- (void)startSendMsg
{
    if (!self.contentTextField) {
        return;
    }
    
    if (self.contentTextField.text.length <= 0 || !self.sendMsgBtn.enabled) {
        return;
    }
    
    if ([LCMyUser mine].userLevel < [LCMyUser mine].gag_grade) {
        [self.contentTextField resignFirstResponder];
        [LCNoticeAlertView showMsg:@"级别太低不能发言！"];
        
        return;
    }
    
    if (self.contentTextField.text.length >= 30) {
        [self.contentTextField resignFirstResponder];
        [LCNoticeAlertView showClearBackgroundMsg:ESLocalizedString(@"字数太长")];
        
        return ;
    }
    
    if ([LCMyUser mine].isGag && ![LCMyUser mine].showManager) {
        // 管理员和超管都不会被禁言
        [self.contentTextField resignFirstResponder];
        [LCNoticeAlertView showMsg:ESLocalizedString(@"您已被管理员禁言!")];
        
        return;
    }
    
    if (isBarrageState) {
        [self sendBarrageMsg];
    } else {
        if(self.delegate) {
            [self.delegate sendMessage:self];
            self.contentTextField.text = @"";
            self.mMsgCD = 10;
            self.mMsgTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onMsgCD) userInfo:nil repeats:YES];
            [self onMsgCD];
        }
    }
}

- (void)onMsgCD {
    --self.mMsgCD;
    if (self.mMsgCD > 0) {
        [self.sendMsgBtn setTitle:[NSString stringWithFormat:@"%ld", self.mMsgCD] forState:UIControlStateNormal];
        self.sendMsgBtn.enabled = NO;
    }
    else {
        [self.sendMsgBtn setTitle:ESLocalizedString(@"发送") forState:UIControlStateNormal];
        self.sendMsgBtn.enabled = YES;
        [self.mMsgTimer invalidate];
    }
}

- (void)uploadFilterMsg:(NSString *)msg
{
    ESWeakSelf;
    
    LCRequestSuccessResponseBlock successBlock = ^(NSDictionary *responseDic) {
        ESStrongSelf;
        
        NSLog(@"uploadFilterMsg: %@", responseDic);
        if ([responseDic[@"stat"] intValue] == 502) {
            [LCMyUser mine].isServerFilterAD = YES;
        } else {
            [LCMyUser mine].isServerFilterAD = NO;
        }
        
        [_self startSendMsg];
    };
    
    LCRequestFailResponseBlock failBlock = ^(NSError *error) {
        [LCMyUser mine].isServerFilterAD = NO;
        
        ESStrongSelf;
        
        [_self startSendMsg];
    };
    
    NSDictionary *paramter = @{@"word":msg};
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:paramter
                                                  withPath:URL_UPLOAD_MSG
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}


#pragma mark - 弹幕

- (void)barrageAction
{
    if (!self.contentTextField) {
        return;
    }
    
    UIImage *switchCloseImg = [UIImage createContentsOfFile:@"image/liveroom/switch_barrage_close"];
    UIImage *switchopenImg = [UIImage createContentsOfFile:@"image/liveroom/switch_barrage_open"];
    if (isBarrageState) {
        self.contentTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:ESLocalizedString(@"说点什么吧") attributes:@{NSForegroundColorAttributeName:RGB16(COLOR_BG_WHITE)}];
        isBarrageState = NO;
        
        [self.brrageBtn setImage:switchCloseImg forState:UIControlStateNormal];
    } else {
        self.contentTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:ESLocalizedString(@"开启弹幕，1钻石/条") attributes:@{NSForegroundColorAttributeName:RGB16(COLOR_BG_WHITE)}];
        isBarrageState = YES;
        
        [self.brrageBtn setImage:switchopenImg forState:UIControlStateNormal];
    }
}

// 发送弹幕消息
- (void)sendBarrageMsg
{
    if (!self.contentTextField) {
        return;
    }
    
    if ([LCMyUser mine].isGag && ![LCMyUser mine].showManager) {
        // 超管不能被禁言
        [self.contentTextField resignFirstResponder];
        [LCNoticeAlertView showMsg:ESLocalizedString(@"您已被管理员禁言！")];
        
        return;
    }
    
    if ([LCMyUser mine].diamond < 1)
    {
        ESWeakSelf;
        
        UIAlertView *alert = [UIAlertView alertViewWithTitle:ESLocalizedString(@"提示") message:ESLocalizedString(@"余额不足，请充值！") cancelButtonTitle:ESLocalizedString(@"确认") didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            ESStrongSelf;
            
            [_self.contentTextField resignFirstResponder];
            if (_self.delegate) {
                [_self.delegate showRechargeVC];
            }
        } otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    if (self.contentTextField.text.length == 0)
    {
        return;
    }
    
    NSString *msg = self.contentTextField.text;
    
    if (![LCMyUser mine].showManager) {
        msg = [[ChatUtil shareInstance] getFilterStringWithSrc:msg];
    }
    
    if (self.delegate) {
        [self.delegate sendMessage:self];
        self.contentTextField.text = @"";
    }
    
    ESWeakSelf;
    
    LCRequestSuccessResponseBlock successBlock = ^(NSDictionary *responseDic) {
        NSString* code = [responseDic objectForKey:@"stat"];
        
        ESStrongSelf;
        if (URL_REQUEST_SUCCESS == [code intValue])
        {
            [LCMyUser mine].diamond = [responseDic[@"diamond"] intValue];
            
            NSMutableDictionary *barrageDict = [NSMutableDictionary dictionary];
            [barrageDict setObject:[LCMyUser mine].userID forKey:@"uid"];
            [barrageDict setObject:[LCMyUser mine].faceURL forKey:@"face"];
            [barrageDict setObject:[LCMyUser mine].nickname forKey:@"nickname"];
            [barrageDict setObject:[NSNumber numberWithInt:[LCMyUser mine].userLevel] forKey:@"grade"];
            [barrageDict setObject:msg forKey:@"chat_msg"];
            [barrageDict setObject:@([LCMyUser mine].showManager ? 1 : 0) forKey:@"offical"];
            [barrageDict setObject:LIVE_GROUP_CHAT_MSG forKey:@"type"];
            if (!_self.barrageView.barrageInfoArray)
            {
                _self.barrageView.barrageInfoArray = [NSMutableArray array];
            }
            
            [_self.barrageView.barrageInfoArray addObject:barrageDict];
            [_self.barrageView showBarrageAnimation];
            
            [LiveMsgManager sendUserBarrageMsg:msg Succ:^(NSString *msg) {
                NSLog(@"发送成功！");
            } andFail:^(NSString *error) {
                NSLog(@"发送失败！");
            }];
            
            // [LiveMsgManager sendChatMsg:barrageDict andSucc:^{
            // } andFail:^{
            // }];
        }
        else if (520 == [code intValue])
        {
            ESStrongSelf;
            
            UIAlertView *alert = [UIAlertView alertViewWithTitle:ESLocalizedString(@"提示") message:ESLocalizedString(@"余额不足，请充值！") cancelButtonTitle:ESLocalizedString(@"确认") didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                ESStrongSelf;
                
                [_self.contentTextField resignFirstResponder];
                if (_self.delegate) {
                    [_self.delegate showRechargeVC];
                }
            } otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            [_self.contentTextField resignFirstResponder];
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
    };
    
    LCRequestFailResponseBlock failBlock = ^(NSError *error) {
        ESStrongSelf;
        
        [_self.contentTextField resignFirstResponder];
        [LCNoticeAlertView showMsg:ESLocalizedString(@"发送失败！")];
    };
    
    if ([LCMyUser mine].liveUserId) {
        NSDictionary *paramter = @{@"liveuid":[LCMyUser mine].liveUserId, @"memo":msg};
        [[LCHTTPClient sharedHTTPClient] requestWithParameters:paramter
                                                      withPath:URL_LIVE_BARRAGE
                                                   withRESTful:GET_REQUEST
                                              withSuccessBlock:successBlock
                                                 withFailBlock:failBlock];
    }
}


# pragma mark - collection data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// - (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return _userArray.count;
// }

// - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    UserLogoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserLogoCell" forIndexPath:indexPath];
//    NSDictionary *userDic = [_userArray objectAtIndex:indexPath.row];
//    // 头像
//    NSString *logoPath = [userDic objectForKey:@"default_head"];
//    if ([logoPath isEqualToString:@""]) {
//        cell.userLogoImageView.image = [UIImage imageNamed:@"default_head"];
//    }
//    else {
//        NSInteger width = cell.userLogoImageView.frame.size.width*SCALE;
//        NSInteger height = width;
//        NSString *myLogoUrl = [NSString stringWithFormat:URL_IMAGE, logoPath, width, height];
//        [cell.userLogoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString faceURLString:logoPath]] placeholderImage:[UIImage imageWithColor:RGB16(COLOR_FONT_WHITE) andSize:cell.userLogoImageView.frame.size]];
//    }
//
//    return cell;
//}

// - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake(35, 35);
//}
//
// - (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.delegate) {
//        [self.delegate clickAudienceLogo:self withUserInfo:[_userArray objectAtIndex:indexPath.row]];
//    }
//
//    return;
//}


#pragma mark - 定时删除消息

- (void)delMsgView {
// if(messageViewArray.count != 0) {
//     for (NSInteger index = 0; index < messageViewArray.count; index++) {
//         UIView *view = [messageViewArray objectAtIndex:index];
//         NSDate *fromDate;
//         if ([view isKindOfClass:[MessageView class]]) {
//             fromDate = ((MessageView *)view).date;
//         }
//         if ([view isKindOfClass:[WelcomeView class]]) {
//             fromDate = ((WelcomeView *)view).date;
//         }
//         NSInteger interval = [self getTimeIntervalFromNow:fromDate];
//         if (MESSAGE_SURVIVAL_TIME <= interval) {
//             if (view.superview) {
//                 [messageViewArray removeObjectAtIndex:index];
//                 --index;
//                 [UIView animateWithDuration:0.3 animations:^{
//                     view.alpha = 0;
//                 } completion:^(BOOL finished) {
//                     [view removeFromSuperview];
//                 }];
//             }
//         }
//     }
// }
}


#pragma mark - 主播发红包

- (void)sendPacketAction
{
    if (_giftView) {
        [_giftView sendRedPacketAction];
    }
}


#pragma mark - 计算时间间隔
- (NSInteger)getTimeIntervalFromNow:(NSDate *)from
{
    NSDate *to = [NSDate date];
    NSTimeInterval aTimer = [to timeIntervalSinceDate:from];
    int hour = (int)(aTimer / 3600);
    int minute = (int)(aTimer - hour * 3600) / 60;
    int second = aTimer - hour * 3600 - minute * 60;
    
    return second;
}


#pragma mark - 添加一条消息

- (void)addMessage:(NSString *)message andUserInfo:(NSDictionary *)userInfoDict
{
    if (self.showGroupMsgView.contentArray && self.showGroupMsgView.contentArray.count >= 4)
    {
        if (self.showGroupMsgView.contentTable.contentInset.top > 0)
        {
            NSLog(@"content insert: %f", self.showGroupMsgView.contentTable.contentInset.top);
            self.showGroupMsgView.contentTable.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.showGroupMsgView.contentArray.count - 1  inSection:0];
            if (self.showGroupMsgView.contentTable.contentSize.height - self.showGroupMsgView.contentTable.contentOffset.y <= self.showGroupMsgView.contentTable.size.height) {
                // 只有在底部才滚动
                [self.showGroupMsgView.contentTable scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }
    }
    
    [self.showGroupMsgView addMsgToGroupMsgView:userInfoDict];
}

- (IBAction)onShowAllUser:(id)sender
{
    self.showAllUser = YES;
    [self onShowAllUser];
}

- (void)setShowAllUser:(BOOL)showAllUser
{
    _messageScrollView.hidden = showAllUser;
}

- (BOOL)showAllUser
{
    return _messageScrollView.hidden;
}

- (void)onShowAllUser
{
//    if ([_delegate respondsToSelector:@selector(onClickPanel:showAllUser:)])
//    {
//        [_delegate onClickPanel:self showAllUser:_userArray];
//    }
    [self refleshUserView];
}

- (void)refleshUserView
{
// ESWeakSelf;
//
// ESDispatchOnMainThreadAsynchrony(^{
//     ESStrongSelf;
//
//     [_self.onlineScrollerView removeAllSubviews];
//     
//     NSUInteger arrayNum = [_userArray count];
//     
//     CGSize newSize = CGSizeMake((ViewWidth + ViewPadding) * arrayNum, ViewWidth);
//     [_self.onlineScrollerView setContentSize:newSize];
//     
//     for(int i = 0; i < arrayNum; i++)
//     {
//         CGRect itemRect = CGRectMake(ViewPadding + i * (ViewWidth + ViewPadding), 0, ViewWidth, ViewWidth);
//         AudienceUserCell *userView = [[AudienceUserCell alloc] initWithFrame:itemRect];
//         
//         userView.showUserDetail = ^(LiveUser *liveUser) {
//             ESStrongSelf;
//
//             liveUser.hasInRoom = YES;
//             
//             NSString *userIdStr = [NSString stringWithFormat:@"%@", liveUser.userId];
//             if (!userIdStr || userIdStr.length <= 0) {
//                 return;
//             }
//             
//             UserSpaceViewController *onlineUserVC = [[UserSpaceViewController alloc] init];
//             onlineUserVC.liveUser = liveUser;
//             onlineUserVC.reViewBlock = ^(NSDictionary *userInfoDict) {
//                 ESStrongSelf;
//
//                 [_self reviewUser:userInfoDict];
//             };
//
//             onlineUserVC.privateChatBlock = ^(NSDictionary *userInfoDict) {
//                 ESStrongSelf;
//
//                 [_self.delegate showPrivChat:userInfoDict];
//             };
//             
//             [[ESApp rootViewControllerForPresenting] popupViewController:onlineUserVC completion:nil];
//         };
//         
//         userView.liveUser = (LiveUser *)_userArray[i];
//         [_self.onlineScrollerView addSubview:userView];
//     }
// });
}


#pragma mark - 添加用户

- (void)addUsers:(LiveUser *)lu
{
    [_audienceTableView addUserToAudience:lu];
    
    static BOOL waiting = NO;
    if (!waiting) {
        waiting = YES;
        
        ESWeakSelf;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(UPDATE_ONLINE_USER_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            waiting = NO;
            ESStrongSelf;
            
            [_self showUserCount];

// #ifdef DEBUG
//             {
//                 [[RCIMClient sharedRCIMClient] getChatRoomInfo:[LCMyUser mine].liveUserId count:0 order:RC_ChatRoom_Member_Asc success:^(RCChatRoomInfo *chatRoomInfo) {
//                     dispatch_async(dispatch_get_main_queue(), ^{
//                         NSString *total = [NSString stringWithFormat:@"%d", chatRoomInfo.totalMemberCount];
//                         NSLog(@"rongcloud进房后人数: %@", total);
//                     });
//                 } error:^(RCErrorCode shartatus) {
//                     NSLog(@"error: 聊天人数获取失败");
//                 }];
//             }
// #endif
        });
    }
}

- (NSInteger)invitedUserCount
{
    NSInteger count = 0;
    
    return count;
}

- (NSInteger)allUserCount
{
    return [LCMyUser mine].liveOnlineUserCount;
}


#pragma mark - 删除用户

- (void)delUsers:(LiveUser *)user
{
    if ([_audienceTableView isReloadDataVisibleUser:user]) {
        [_audienceTableView.datas removeObject:user];
        [_audienceTableView reloadData];
    }
    
    if ([LCMyUser mine].liveOnlineUserCount > 100) {
        --[LCMyUser mine].liveOnlineUserCount;
        
        static BOOL waiting = NO;
        if (!waiting) {
            waiting = YES;
            
            ESWeakSelf;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(UPDATE_ONLINE_USER_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                waiting = NO;
                
                ESStrongSelf;
                
                [_self showUserCount];
            });
        }
    }
}

- (void)showUserCount
{
    ESDispatchOnMainThreadAsynchrony(^{
        self.userCountLabel.text = [NSString stringWithFormat:@"%d", [LCMyUser mine].liveOnlineUserCount];
    });
}


#pragma mark - 点击用户头像

- (void)logoTap:(UITapGestureRecognizer *)recognizer {
    if (![LCMyUser mine].liveUserId) {
        return;
    }
    
    LiveUser *liveUser = [[LiveUser alloc] initWithPhone:[LCMyUser mine].liveUserId name:[LCMyUser mine].liveUserName logo:[LCMyUser mine].liveUserLogo];
    NSString *userIdStr = [NSString stringWithFormat:@"%@", liveUser.userId];
    
    if (!userIdStr || userIdStr.length <= 0) {
        return;
    }
    
    liveUser.isInRoom = YES;
    
    ESWeakSelf;
    
    UserSpaceViewController *onlineUserVC = [[UserSpaceViewController alloc] init];
    onlineUserVC.liveUser = liveUser;
    onlineUserVC.reViewBlock = ^(NSDictionary *userInfoDict) {
        ESStrongSelf;
        
        [_self reviewUser:userInfoDict];
    };
    
    onlineUserVC.privateChatBlock = ^(NSDictionary *userInfoDict) {
        ESStrongSelf;
        
        [_self.delegate showPrivChat:userInfoDict];
    };
    
    onlineUserVC.gagUserBlock = ^(NSDictionary *userInfoDict) {
        ESStrongSelf;
        
        NSMutableDictionary *socket = [NSMutableDictionary dictionary];
        socket[@"type"] = LIVE_GROUP_GAG;                       // 消息类型
        socket[@"uid"] = userInfoDict[@"uid"];                  // 用户id
        socket[@"nickname"] = userInfoDict[@"nickname"];        // 用户昵称
        socket[@"send_name"] = [LCMyUser mine].nickname;        // 被禁言用户昵称
        
        [LiveMsgManager sendGagInfo:socket Succ:nil andFail:nil];
        [_self addMessage:nil andUserInfo:socket];
    };
    
    onlineUserVC.addManagerBlock = ^(NSDictionary *userInfoDict) {
        ESStrongSelf;
        
        NSMutableDictionary *socket = [NSMutableDictionary dictionary];
        socket[@"type"] = LIVE_GROUP_MANAGER;                   // 消息类型
        socket[@"uid"] = userInfoDict[@"uid"];                  // 用户id
        socket[@"nickname"] = userInfoDict[@"nickname"];        // 用户昵称
        
        [LiveMsgManager sendManagerInfo:socket Succ:nil andFail:nil];
        [_self addMessage:nil andUserInfo:socket];
    };
    
    onlineUserVC.removeManagerBlock = ^(NSDictionary *userInfoDict) {
        ESStrongSelf;
        
        NSMutableDictionary *socket = [NSMutableDictionary dictionary];
        socket[@"type"] = LIVE_GROUP_REMOVE_MANAGER;            // 消息类型
        socket[@"uid"] = userInfoDict[@"uid"];                  // 用户id
        socket[@"nickname"] = userInfoDict[@"nickname"];        // 用户昵称
        
        [LiveMsgManager sendRemoveManagerInfo:socket Succ:nil andFail:nil];
        [_self addMessage:nil andUserInfo:socket];
    };
    
    onlineUserVC.attentUserBlock = ^(NSString *userId) {
        if ([userId isEqualToString:[LCMyUser mine].liveUserId]) {
            NSMutableDictionary *socket = [NSMutableDictionary dictionary];
            socket[@"type"] = LIVE_GROUP_ATTENT;            // 消息类型
            socket[@"uid"] = [LCMyUser mine].userID;        // 用户id
            socket[@"nickname"] = [LCMyUser mine].nickname; // 用户昵称
            
            ESStrongSelf;
            
            [_self addMessage:nil andUserInfo:socket];
            
            [LiveMsgManager sendAttentMsg:socket Succ:nil andFail:nil];
        }
    };
    
    onlineUserVC.showUserHomeBlock = ^(NSString *userId) {
        ESStrongSelf;
        
        [_self.delegate showHomePage:userId];
    };
    
    [[ESApp rootViewControllerForPresenting] popupViewController:onlineUserVC completion:nil];
}


#pragma mark - 点赞

- (void)loveTap:(UITapGestureRecognizer *)recognizer
{
    if(self.delegate)
    {
        [self.delegate loveTap:self];
    }
}


#pragma mark - 添加进房动画

- (void)addEnterRoomAnim:(NSDictionary *)enterRoomDict
{
    if (_enterRoomAnimView) {
        if (!_enterRoomAnimView.enterInfoArray) {
            _enterRoomAnimView.enterInfoArray = [NSMutableArray array];
        }
        
        if ([self isAddEnterRoomAnim:enterRoomDict]) {
            [_enterRoomAnimView.enterInfoArray addObject:enterRoomDict];
            
            [_enterRoomAnimView showEnterRoomView];
        }
    }
}

// 是否添加进房动画
- (BOOL)isAddEnterRoomAnim:(NSDictionary *)enterRoomDict
{
    if (!enterRoomDict[@"uid"]) {
        return NO;
    }
    
    if (!_addAnimTimerDict) {
        _addAnimTimerDict = [NSMutableDictionary dictionary];
        NSTimeInterval currTime = [[NSDate date] timeIntervalSince1970];
        double i = currTime; // NSTimeInterval返回的是double类型
        NSLog(@"1970timeInterval: %f", i);
        [_addAnimTimerDict setObject:@(currTime) forKey:enterRoomDict[@"uid"]];
        
        return YES;
    } else {
        if (_addAnimTimerDict[enterRoomDict[@"uid"]]) {
            NSTimeInterval currTime = [[NSDate date] timeIntervalSince1970];
            NSNumber *oldTime = _addAnimTimerDict[enterRoomDict[@"uid"]];
            float time = currTime - [oldTime longLongValue];
            NSLog(@"enter room time: %f", time);
            
            if (time > ADD_ENTER_ANIM_TIME * 60) {
                [_addAnimTimerDict setObject:@(currTime) forKey:enterRoomDict[@"uid"]];
                return YES;
            } else {
                return NO;
            }
        } else {
            NSTimeInterval currTime = [[NSDate date] timeIntervalSince1970];
            double i = currTime; // NSTimeInterval返回的是double类型
            NSLog(@"1970timeInterval: %f", i);
            [_addAnimTimerDict setObject:@(currTime) forKey:enterRoomDict[@"uid"]];
            
            return YES;
        }
    }
    
    return NO;
}


// 是否添加进房座驾动画

- (BOOL)isAddEnterRoomZuoJiaAnim:(NSDictionary *)enterRoomDict
{
    if (!enterRoomDict[@"uid"]) {
        return NO;
    }
    
    if (!_addZuoJiaTimerDict) {
        _addZuoJiaTimerDict = [NSMutableDictionary dictionary];
        NSTimeInterval currTime = [[NSDate date] timeIntervalSince1970];
        double i = currTime; // NSTimeInterval返回的是double类型
        NSLog(@"1970timeInterval: %f", i);
        [_addZuoJiaTimerDict setObject:@(currTime) forKey:enterRoomDict[@"uid"]];
        
        return YES;
    } else {
        if (_addZuoJiaTimerDict[enterRoomDict[@"uid"]]) {
            NSTimeInterval currTime = [[NSDate date] timeIntervalSince1970];
            NSNumber *oldTime = _addZuoJiaTimerDict[enterRoomDict[@"uid"]];
            float time = currTime - [oldTime longLongValue];
            NSLog(@"enter room time: %f", time);
            
            if (time > ADD_ENTER_ANIM_TIME * 60) {
                [_addZuoJiaTimerDict setObject:@(currTime) forKey:enterRoomDict[@"uid"]];
                return YES;
            } else {
                return NO;
            }
        } else {
            NSTimeInterval currTime = [[NSDate date] timeIntervalSince1970];
            double i = currTime; // NSTimeInterval返回的是double类型
            NSLog(@"1970timeInterval: %f", i);
            [_addZuoJiaTimerDict setObject:@(currTime) forKey:enterRoomDict[@"uid"]];
            
            return YES;
        }
    }
    
    return NO;
}

- (void)addLove:(NSInteger)count withLightPos:(int)lightPos
{
// ESWeakSelf;
//
// dispatch_async(dispatch_get_main_queue(), ^{
//     ESStrongSelf;
//
//     NSInteger newCount = [_self.loveCountLabel.text integerValue] + count;
//     _self.loveCountLabel.text = [[NSNumber numberWithInteger:newCount] stringValue];
//     NSString *imageName = nil;
//     if (lightPos > 0) {
//         imageName = [NSString stringWithFormat:@"image/liveroom/lightup_%d", lightPos];
//     } else {
//         int index = arc4random() % 6;
//         imageName = [NSString stringWithFormat:@"heart%d", index];
//     }
//
//     UIImageView *animateView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
//
//     animateView.center = CGPointMake(SCREEN_WIDTH - _self.loveView.width - 5 - _self.loveView.width / 2, SCREEN_HEIGHT - _self.loveView.height - 80);
//     
//     animateView.image = [UIImage imageNamed:imageName];
//     [_self.messageContentView addSubview:animateView];
//     
//     UIBezierPath *thumbPath = [UIBezierPath bezierPath];
//     [thumbPath moveToPoint:CGPointMake(99, 270)];
//     [thumbPath addCurveToPoint:CGPointMake(164, 260) controlPoint1:CGPointMake(164, 280) controlPoint2:CGPointMake(164, 280)];
//     [thumbPath addCurveToPoint:CGPointMake(164, 260) controlPoint1:CGPointMake(260, 310) controlPoint2:CGPointMake(260, 310)];
//     CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//     pathAnimation.path = thumbPath.CGPath;
//     pathAnimation.duration = 2.0;
//     
//     [UIView animateWithDuration:3 animations:^{
//         int x = arc4random() % 10 + 3;
//         int t = 0;
//         if (x % 2 == 0) {
//             t = x * 5;
//         } else {
//             t = - (x * 5);
//         }
//         
//         animateView.frame = CGRectMake(animateView.frame.origin.x + t, SCREEN_HEIGHT * 1 / 4, animateView.frame.size.width, animateView.frame.size.height);
//         NSLog(@"animateView: %@", NSStringFromCGRect(animateView.frame));
//         animateView.alpha = 0;
//     } completion:^(BOOL finish) {
//         [animateView removeFromSuperview];
//     }];
// });
    
    [self showMoreLoveAnimateFromView:self.loveView addToView:self.messageContentView withLoveCount:count withLightPos:lightPos];
}

- (void)showMoreLoveAnimateFromView:(UIView *)fromView addToView:(UIView *)addToView withLoveCount:(NSInteger)count withLightPos:(int)lightPos {
    // NSInteger newCount = [self.loveCountLabel.text integerValue] + count;
    // self.loveCountLabel.text = [[NSNumber numberWithInteger:newCount] stringValue];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    CGRect loveFrame = [fromView convertRect:fromView.frame toView:addToView];
    CGPoint position = CGPointMake(SCREEN_WIDTH - self.loveView.width - 5 - self.loveView.width / 2, loveFrame.origin.y - 30);
    position.y /= 2;
    imageView.layer.position = position;
    NSString *imageName = nil;
    if (lightPos > 0) {
        imageName = [NSString stringWithFormat:@"image/liveroom/lightup_%d", lightPos];
    } else {
        int index = arc4random() % 6;
        imageName = [NSString stringWithFormat:@"heart%d", index];
    }
    
    imageView.image = [UIImage imageNamed:imageName];
    [addToView addSubview:imageView];
    
    imageView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        imageView.transform = CGAffineTransformIdentity;
    } completion:nil];
    
    CGFloat duration = 3 + arc4random() % 5;
    CAKeyframeAnimation *positionAnimate = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimate.repeatCount = 1;
    positionAnimate.duration = duration;
    positionAnimate.fillMode = kCAFillModeForwards;
    positionAnimate.removedOnCompletion = NO;
    
    UIBezierPath *sPath = [UIBezierPath bezierPath];
    [sPath moveToPoint:position];
    CGFloat sign = arc4random() % 2 == 1 ? 1 : -1;
    CGFloat controlPointValue = (arc4random() % 50 + arc4random() % 100) * sign;
    [sPath addCurveToPoint:CGPointMake(position.x, position.y - 300) controlPoint1:CGPointMake(position.x - controlPointValue, position.y - 150) controlPoint2:CGPointMake(position.x + controlPointValue, position.y - 150)];
    positionAnimate.path = sPath.CGPath;
    [imageView.layer addAnimation:positionAnimate forKey:@"heartAnimated"];
    
    [UIView animateWithDuration:duration animations:^{
        imageView.layer.opacity = 0;
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
    }];
}


#pragma mark - 打开麦克风
- (IBAction)openMike:(id)sender {
    if(self.delegate){
        [self.delegate openMike:self];
    }
}


#pragma mark - 切换摄像头
- (IBAction)toggleCamera:(id)sender{
    if(self.delegate){
        [self.delegate toggleCamera:self];
    }
}

- (void)switchCamera
{
    if(self.delegate){
        [self.delegate toggleCamera:self];
    }
}


#pragma mark - 推流
- (IBAction)pushHLS:(id)sender {
    if(self.delegate){
        [self.delegate pushHLS:self];
    }
}

- (IBAction)pushRTMP:(id)sender {
    if(self.delegate){
        [self.delegate pushRTMP:self];
    }
}


#pragma mark - 录制
- (IBAction)liveREC:(id)sender {
    if(self.delegate){
        [self.delegate liveREC:self];
    }
}


#pragma mark - 视频参数
- (IBAction)livePAR:(id)sender {
    if(self.delegate){
        [self.delegate livePAR:self];
    }
}


#pragma mark - 旋转
- (void)netRotateStart
{
    [self runSpinAnimationOnView:self.netImageView duration:0.4 repeat:FLT_MAX];
}

- (void)netRotateStop
{
    [self.netImageView.layer removeAnimationForKey:@"rotationAnimation"];
}

- (void)runSpinAnimationOnView:(UIView *)view duration:(CGFloat)duration repeat:(float)repeat;
{
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)hideCamera
{
// _reportButton.hidden = YES;
// _cameraButton.hidden = YES;
// _mikeButton.hidden = YES;
// [_mikeButton removeFromSuperview];
// _mikeButton = nil;
// 
// [self addConstraint:[NSLayoutConstraint constraintWithItem:_reportButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_cameraButton attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
// 
// [self addConstraint:[NSLayoutConstraint constraintWithItem:_reportButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_cameraButton attribute:NSLayoutAttributeLeading multiplier:1 constant:-8]];
   
// NSArray *constraints1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[UIButton:0x15738fe70]-(8)-[UIButton:0x157389f30]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)];
// 
// NSArray *constraints2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[button(==30)]"
//                        　　　　　　　　　　　　　　　　　　　　　　　　　 options:0
//                        　　　　　　　　　　　　　　　　　　　　　　　　　 metrics:nil
//                        　　　　　　　　　　　　　　　　　　　　　　　　　　 views:NSDictionaryOfVariableBindings(button)];
// 
// [self.view addConstraints:constraints1];
}

- (void)startRec
{
    _recButton.selected = YES;
}

- (void)stopRec
{
    _recButton.selected = NO;
}

- (void)handleKeyboardDidShow:(NSNotification *)notification
{
    // [self.rootViewController.contentView bringSubviewToFront:self];
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat distanceToMove = kbSize.height;
    self.tempShowGroupMsgViewBottom = self.showGroupMsgView.bottom;
    
    [UIView animateWithDuration:duration animations:^{
        self.enterContentView.bottom = ScreenHeight - distanceToMove;
        self.showGroupMsgView.bottom = SCREEN_HEIGHT - distanceToMove - self.enterContentView.height;
//        self.bottom = SCREEN_HEIGHT - distanceToMove;
    }];
}

- (void)handleKeyboardWillHide:(NSNotification *)notification
{
    
    [UIView animateWithDuration:0.5f animations:^{
        self.showGroupMsgView.bottom = self.tempShowGroupMsgViewBottom;
//        self.bottom = SCREEN_HEIGHT;
        
        if (self.bottomView) {
            self.bottomView.hidden = NO;
        }
        if ((self.gameView)) {
            self.gameView.hidden = NO;
        }
        
        if (self.enterContentView) {
            self.enterContentView.top = ScreenHeight;
        }
    }];
}


#pragma mark - 屏幕点击

- (void)singleTap
{
    if(!self.captureView.isHidden){
        [self captureViewClose];
        if (self.delegate && [self.delegate respondsToSelector:@selector(recordDidCancelled)]) {
            [self.delegate performSelector:@selector(recordDidCancelled)];
        }
    }
    if (!self.giftView.isHidden) {
        [self hiddenGiftView];
    } else if (!shareView.isHidden) {
        [self hiddenShareView];
    } else {
        if (self.bottomView.hidden)
        {
            if (self.contentTextField) {
                [self.contentTextField resignFirstResponder];
            }
        } else {
            if(self.delegate)
            {
                [self.delegate loveTap:self];
            }
        }
    }
}


#pragma mark - 隐藏礼物列表

- (void)hiddenGiftView
{
    if (!self.giftView.isHidden)
    {
        [UIView animateWithDuration:0.5f animations:^{
            _giftView.top = SCREEN_HEIGHT;
            _bottomView.top = SCREEN_HEIGHT - _bottomView.size.height;
        } completion:^(BOOL finish) {
            [_giftView stopRefreshTimer];
            _giftView.hidden = YES;
            _showGroupMsgView.hidden = NO;
            _bottomView.hidden = NO;
        }];
    }
}

- (void)hiddenDrawGiftView
{
    if (self.mDrawGiftView.hidden == NO) {
        [UIView animateWithDuration:0.5f animations:^{
            self.mDrawGiftView.hidden = YES;
            _bottomView.hidden = NO;
            _showGroupMsgView.hidden = NO;
            _bottomView.top = SCREEN_HEIGHT - _bottomView.size.height;
        } completion:^(BOOL finish) {
        }];
    }
}

- (void)drawShowRecharge {
    [self.delegate showRechargeVC];
}

- (void)drawSendWithDict:(NSDictionary *)giftDict {
    int grade = [giftDict[@"grade"] intValue];
    if (grade > [LCMyUser mine].userLevel) {
        [LCMyUser mine].userLevel = grade;
        NSMutableDictionary *socket = [NSMutableDictionary dictionary];
        socket[@"type"] = LIVE_GROUP_UPGRADE;                                   // 消息类型
        socket[@"uid"] = [LCMyUser mine].userID;                                // 用户id
        socket[@"nickname"] = [LCMyUser mine].nickname;                         // 用户昵称
        socket[@"grade"] = [NSNumber numberWithInt:[LCMyUser mine].userLevel];  // 用户等级
        
        [LiveMsgManager sendUserUpGrade:socket Succ:nil andFail:nil];
        [self addMessage:@"upgrade" andUserInfo:socket];
    }
    
    [LuxuryManager luxuryManager].luxuryDict = giftDict;
    [self addMessage:@"gift" andUserInfo:giftDict];
}


#pragma mark - 隐藏分享

- (void)hiddenShareView
{
    if (!shareView.isHidden) {
        [UIView animateWithDuration:0.5f animations:^{
            shareView.top = SCREEN_HEIGHT;
        } completion:^(BOOL finish) {
            shareView.hidden = YES;
        }];
    }
}


#pragma mark - 点击范围

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([self.mDrawGiftView isSubview:touch.view]) {
        return NO;
    }
    
    if (gestureRecognizer.view == self && [gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if (!self.giftView.hidden) {
            CGPoint point = [touch locationInView:self.giftView.DispalyArea];
            
            if (point.x > 0 && point.x < self.giftView.DispalyArea.frame.size.width &&
                point.y > 0 && point.y < self.giftView.DispalyArea.frame.size.height)
            {
                return NO;
            }
        }
        
        if (!shareView.hidden) {
            CGPoint point = [touch locationInView:shareView.dispalyArea];
            
            if (point.x > 0 && point.x < shareView.dispalyArea.frame.size.width &&
                point.y > 0 && point.y < shareView.dispalyArea.frame.size.height)
            {
                return NO;
            }
        }
        
        CGPoint groupMsgPoint = [touch locationInView:self.showGroupMsgView];
        if (groupMsgPoint.x > 0 && groupMsgPoint.x < self.showGroupMsgView.frame.size.width
                && groupMsgPoint.y > 0 && groupMsgPoint.y < self.showGroupMsgView.frame.size.height)
        {
            if (self.bottomView.hidden)
            {
                [self.contentTextField resignFirstResponder];
            }
            
            return NO;
        }
        
//      CGPoint audiencePoint = [touch locationInView:self.audienceTableView];
//      if (audiencePoint.x > 0 && audiencePoint.x < self.audienceTableView.frame.size.width
//          && audiencePoint.y > 0 && audiencePoint.y < self.audienceTableView.frame.size.height) {
//          return NO;
//      }
        
        if ([touch.view findViewWithClassInSuperviews:[UITableView class]] == self.audienceTableView) {
            return NO;
        }
        
        CGPoint recvPoint = [touch locationInView:self.recvBgImgView];
        if (recvPoint.x > 0 && recvPoint.x < self.recvBgImgView.frame.size.width &&
            recvPoint.y > 0 && recvPoint.y < self.recvBgImgView.frame.size.height) {
            [self.delegate showRankVC];
            
            return NO;
        }
    }
    
    return YES;
}


#pragma mark - 更新收入

- (void)updateRecvDiamond
{
    if ([LCMyUser mine].liveRecDiamond > 0) {
        self.recvBgImgView.hidden = NO;
        UIImage *recvIconImg = [UIImage imageNamed:@"image/liveroom/room_money_check"];
        
        NSString *recvCountStr = [NSString stringWithFormat:@"%d", [LCMyUser mine].liveRecDiamond];
        CGSize recvSize = [recvCountStr sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12]}];
        float recvBgWidth = recvSize.width + _recvPromptLabel.width + recvIconImg.size.width + 15;
        self.recvCountLabel.width = recvSize.width + recvIconImg.size.width + 10;
        self.recvBgImgView.width = recvBgWidth;
        [self showRecvDiamond];
    } else {
        self.recvBgImgView.hidden = YES;
    }
}

- (void)showRecvDiamond
{
    NSString *recvDiamondText = [NSString stringWithFormat:@"%d  d", [LCMyUser mine].liveRecDiamond];
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:recvDiamondText];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    UIImage *image = [UIImage imageNamed:@"image/liveroom/room_money_check"];
    textAttachment.image = image;
    // textAttachment.image = [UIImage imageWithImage:image scaleToSize:CGSizeMake(image.size.width, image.size.height)];
    
    textAttachment.bounds = CGRectMake(0, -2, image.size.width, image.size.height);
    
    NSAttributedString *iconAttributedString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [mutableAttributedString replaceCharactersInRange:NSMakeRange(recvDiamondText.length - 1, 1) withAttributedString:iconAttributedString];
    
    self.recvCountLabel.attributedText = mutableAttributedString;
}


#pragma mark - 显示群聊

- (void)showDealGroupMsgType:(NSString *)msgType withMsgContent:(NSDictionary *)socketData
{
    if ([msgType isEqualToString:LIVE_GROUP_ENTER_ROOM])
    {
        LiveUser *lu = [[LiveUser alloc] initWithPhone:socketData[@"uid"] name:socketData[@"nickname"] logo:socketData[@"face"]];
        lu.userGrade = [socketData[@"grade"] intValue];
        lu.zuojia = [socketData[@"zuojia"] intValue];
        
        [self addUsers:lu];
        [self addMessage:nil andUserInfo:socketData];
        if (lu.userGrade >= LIVE_USER_GRADE * 2) {
            // 添加进房特效
            [self addEnterRoomAnim:socketData];
        }
        
        if (lu.zuojia) {
            NSDictionary *enterRoomZuoJiaDict = @{@"zuojia":@(lu.zuojia),
                                                  @"uid":lu.userId,
                                                  @"nickname":lu.userName};
            
            if ([self isAddEnterRoomZuoJiaAnim:enterRoomZuoJiaDict]) {
               [[DriveManager shareInstance] showDriveAnimation:enterRoomZuoJiaDict];
            }
        }
    } else if([msgType isEqualToString:LIVE_GROUP_CHAT_MSG]) {
        [self addMessage:socketData[@"chat_msg"] andUserInfo:socketData];
    } else if([msgType isEqualToString:LIVE_GROUP_EXIT_ROOM]) {
        NSString *userId = socketData[@"uid"];
        LiveUser *lu = [[LiveUser alloc] initWithPhone:userId name:nil logo:nil];
        [self delUsers:lu];
    } else if ([msgType isEqualToString:LIVE_GROUP_USER_LOVE]) {
        // 点亮
        [self addLove:1 withLightPos:[socketData[@"love_pos"] intValue]];
        // NSMutableDictionary *updateDict = [NSMutableDictionary dictionaryWithDictionary:socketData];
        // updateDict[@"grade"] = @(9999);
        [self addMessage:nil andUserInfo:socketData];
    } else if ([msgType isEqualToString:LIVE_GROUP_GIFT]) {
        int recvDiamond = [socketData[@"recv_diamond"] intValue];
        
        if (recvDiamond > [LCMyUser mine].liveRecDiamond) {
            [LCMyUser mine].liveRecDiamond = recvDiamond;
        }
        
        if ([socketData[@"gift_type"] intValue] == GIFT_TYPE_CONTINUE) {
            // 连续©ƒ
            if (isShowGiftAnim) {
                if (self.allShowGiftView) {
                    [self.allShowGiftView showGiftView:socketData];
                }
                [self addMessage:@"gift" andUserInfo:socketData];
            }
        } else if ([socketData[@"gift_type"] intValue] == GIFT_TYPE_REDPACKET) {
            // 红包
            if (self.contentTextField) {
                [self.contentTextField resignFirstResponder];
            }
            [RedPacketManager redPacketManager].redPacketDict = socketData;
            [self addMessage:@"gift" andUserInfo:socketData];
        } else if ([socketData[@"gift_type"] intValue] == GIFT_TYPE_LUXURY) {
            // 豪华礼物
            if (![LCMyUser mine].playBackUserId) {
                // 不在回看
                [LuxuryManager luxuryManager].luxuryDict = socketData;
            }
            
            [self addMessage:@"gift" andUserInfo:socketData];
        }
    } else if ([msgType isEqualToString:LIVE_GROUP_BARRAGE]) {
        if (!self.barrageView.barrageInfoArray)
        {
            self.barrageView.barrageInfoArray = [NSMutableArray array];
        }
        
        [self.barrageView.barrageInfoArray addObject:socketData];
        
        [self.barrageView showBarrageAnimation];
    } else if ([msgType isEqualToString:LIVE_GROUP_SHARE]) {
        // 分享消息
        [self addMessage:nil andUserInfo:socketData];
    } else if ([msgType isEqualToString:LIVE_GROUP_GAG]) {
        // 禁言消息
        if ([socketData[@"uid"] isEqualToString:[LCMyUser mine].userID]) {
            [LCMyUser mine].isGag = YES;
        }
        [self addMessage:nil andUserInfo:socketData];
    } else if ([msgType isEqualToString:LIVE_GROUP_REMOVE_GAG]) {
        // 解除禁言消息
        if ([socketData[@"uid"] isEqualToString:[LCMyUser mine].userID]) {
            [LCMyUser mine].isGag = NO;
        }
        [self addMessage:nil andUserInfo:socketData];
    } else if ([msgType isEqualToString:LIVE_GROUP_MANAGER]) {
        // 设置管理员
        if ([socketData[@"uid"] isEqualToString:[LCMyUser mine].userID]) {
            [LCMyUser mine].isManager = YES;
        }
        [self addMessage:nil andUserInfo:socketData];
    } else if ([msgType isEqualToString:LIVE_GROUP_REMOVE_MANAGER]) {
        // 移除管理员
        if ([socketData[@"uid"] isEqualToString:[LCMyUser mine].userID]) {
            [LCMyUser mine].isManager = NO;
            [self addMessage:nil andUserInfo:socketData];
        }
    } else if ([msgType isEqualToString:LIVE_GROUP_ATTENT]) {
        // 添加关注
        [self addMessage:nil andUserInfo:socketData];
    } else if ([msgType isEqualToString:LIVE_GROUP_UPGRADE]) {
        // 升级
        [self addMessage:nil andUserInfo:socketData];
    } else if ([msgType isEqualToString:LIVE_GROUP_SYSTEM_MSG]) {
        // 系统消息
        [self showAlertWith:socketData[@"alert"]];
        [self addMessage:nil andUserInfo:socketData];
        if ([socketData objectForKey:@"sender"]) {
            [self showTrumpetWithDict:socketData];
        }
        
        if ([socketData isKindOfClass:[NSDictionary class]]) {
            NSString *string = [socketData objectForKey:@"type"];
            if ([string isKindOfClass:[NSString class]] && [string isEqualToString:LIVE_GROUP_LIVE_BAN]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Live_Ban object:nil];
            }
        }
    } else if ([msgType isEqualToString:LIVE_GROUP_ROOM_NOTIFICATION]
               || [msgType isEqualToString:LIVE_GROUP_ROOM_ANCHOR_LEAVE]
               || [msgType isEqualToString:LIVE_GROUP_ROOM_ANCHOR_RESTORE]) {
        // 房间消息
        [self addMessage:nil andUserInfo:socketData];
    }
}

- (void)showTrumpetWithDict:(NSDictionary *)dict {
    if (!_addTrumpets) {
        _addTrumpets = [[NSMutableArray alloc] init];
    }
    [_addTrumpets addObject:dict];
    if (_addTrumpets.count > 0) {
        [self playTrumpetWithDict:dict];
    }
}

- (void)playTrumpetWithDict:(NSDictionary *)dict {
    UILabel *trumpetLabel = [self.mTrumpetView viewWithTag:10];
    trumpetLabel.attributedText = [ShowGroupMsgView getTrumpetStringWithDict:dict];
    [trumpetLabel sizeToFit];
    trumpetLabel.left = self.mTrumpetView.width + 10;
    trumpetLabel.top = self.mTrumpetView.height / 2 - trumpetLabel.height / 2;
    self.mTrumpetView.hidden = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:10.0 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            trumpetLabel.right = 0;
        } completion:^(BOOL finished) {
            self.mTrumpetView.hidden = YES;
            
            if (_addTrumpets && _addTrumpets.count > 0) {
                [_addTrumpets removeObjectAtIndex:0];
            }
            
            if (_addTrumpets.count > 0) {
                [self playTrumpetWithDict:_addTrumpets[0]];
            }
        }];
    });
}

- (void)showContinueGift:(NSDictionary *)giftDict
{
    // IM 消息
    GSPChatMessage *msg = [[GSPChatMessage alloc] init];
    msg.text = [NSString stringWithFormat:@"送一个%@", giftDict[@"gift_name"]];
    // 模拟 n 个人在送礼物
    msg.senderChatID = [NSString stringWithFormat:@"%@", giftDict[@"uid"]];
    msg.senderName = giftDict[@"nickname"];
    NSLog(@"id %@ -------送出了一个 %@--------", msg.senderChatID, giftDict[@"gift_name"]);
    // 礼物模型
    GiftModel *giftModel = [[GiftModel alloc] init];
    giftModel.headUrl = giftDict[@"face"];
    giftModel.name = msg.senderName;
    giftModel.giftId = [giftDict[@"gift_id"] intValue];
    giftModel.giftName = msg.text;
    giftModel.giftCount = [giftDict[@"gift_nums"] intValue];
    
    AnimOperationManager *manager = [AnimOperationManager sharedManager];
    manager.parentView = self;
    // 用用户唯一标识 msg.senderChatID 存储礼物信息，model 传入礼物模型
    [manager animWithUserID:[NSString stringWithFormat:@"%@,%d", msg.senderChatID, giftModel.giftId] model:giftModel finishedBlock:^(BOOL result) {
        // if needed
    }];
}

@end
