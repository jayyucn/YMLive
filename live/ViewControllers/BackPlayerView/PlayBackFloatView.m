//
//  PlayBackFloatView.m
//  qianchuo
//
//  Created by jacklong on 16/8/8.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "PlayBackFloatView.h"
#import "RoomShareView.h"
#import "RedPacketManager.h"
#import "LuxuryManager.h"
#import "UserSpaceViewController.h"

#define MESSAGE_SURVIVAL_TIME 20
#define ChatControlHeight (155.0/2 - 35.f)

#define UPDATE_ONLINE_USER_TIME .2

#define ADD_ENTER_ANIM_TIME 5

@interface PlayBackFloatView()<UITextFieldDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate>{
    int  insertMsgHeight;
    BOOL isRequesstUserDetailInfo;
    BOOL isBarrageState;
    BOOL isAttentLiveUser;
    //    NSMutableArray* messageViewArray;
    //    NSMutableArray* _userArray;
    //    NSTimer* delMsgViewTimer;·
    
    CGPoint beginpoint;
    
    RoomShareView  *shareView;
} 

@property (nonatomic, strong)NSMutableDictionary *addAnimTimerDict;

@end



@implementation PlayBackFloatView


- (void)dealloc
{
    NSLog(@"%@ dealloc", NSStringFromClass(self.class));
    
    self.myInfoBgView = nil;
    self.giftView = nil;
    self.allShowGiftView = nil;
    self.barrageView = nil;
   
    //    self.onlineScrollerView = nil;
    //    __gShowGiftMessagesQueue = nil;
    
    [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.myInfoBgView = [[UIView alloc] initWithFrame:CGRectMake(10,STATUS_HEIGHT + 10, 130.f, ViewWidth)];
        self.myInfoBgView.layer.cornerRadius = 20;
        self.myInfoBgView.backgroundColor = RGBA16(0x30000000);
        [self addSubview:self.myInfoBgView];
        
        self.userFaceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.f, 5.f, 30, 30)];
        //    self.userFaceImageView.layer.borderWidth = 1;
        //    self.userFaceImageView.layer.borderColor = RGB16(COLOR_BG_WHITE).CGColor;
        self.userFaceImageView.layer.cornerRadius = self.userFaceImageView.frame.size.width/2;
        self.userFaceImageView.clipsToBounds = YES;
        self.userFaceImageView.image = [UIImage imageNamed:@"default_head"];
        self.userFaceImageView.userInteractionEnabled = YES;
        [self.myInfoBgView addSubview:self.userFaceImageView];
        
        UIImage *gradeFlagImg = [UIImage imageNamed:@"image/yonghu/grade_flag/grade_flag_1"];
        _gradeFlagImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_userFaceImageView.right - gradeFlagImg.size.width, _userFaceImageView.bottom - gradeFlagImg.size.height+2, gradeFlagImg.size.width, gradeFlagImg.size.height)];
        _gradeFlagImgView.image = gradeFlagImg;
        [self.myInfoBgView addSubview:_gradeFlagImgView];
        
        
        UITapGestureRecognizer *logoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoTap:)];
        [self.myInfoBgView addGestureRecognizer:logoTap];
        
        self.livingLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.userFaceImageView.right+5, 4, 60, 15)];
        self.livingLabel.right = self.userFaceImageView.right+self.userFaceImageView.size.width+25.f;
        self.livingLabel.textAlignment = NSTextAlignmentCenter;
        self.livingLabel.textColor = RGB16(COLOR_FONT_WHITE);
        self.livingLabel.font = [UIFont systemFontOfSize:11.f];
        self.livingLabel.text = ESLocalizedString(@"直播Live");
        [self.myInfoBgView addSubview:self.livingLabel];
        
        self.userCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.livingLabel.frame.origin.x, self.livingLabel.frame.origin.y+ 15, 60, 15)];
        self.userCountLabel.textAlignment = NSTextAlignmentCenter;
        self.userCountLabel.textColor = RGB16(COLOR_FONT_WHITE);
        self.userCountLabel.font = [UIFont systemFontOfSize:10.f];
        [self.myInfoBgView addSubview:self.userCountLabel];
        
        self.attentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.attentBtn.left = _livingLabel.right;
        self.attentBtn.centerY = self.myInfoBgView.height/2-10;
        self.attentBtn.size = CGSizeMake(35, 20);
        [self.attentBtn.layer setMasksToBounds:YES];
        [self.attentBtn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
        [self.attentBtn setBackgroundImage:[UIImage createImageWithColor:ColorPink] forState:UIControlStateNormal];
        [self.attentBtn setTitle:ESLocalizedString(@"关注") forState:UIControlStateNormal];
        self.attentBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        self.attentBtn.titleLabel.textColor = [UIColor whiteColor];
        [self.attentBtn addTarget:self action:@selector(attentLiveUserAction) forControlEvents:UIControlEventTouchUpInside];
        [self.myInfoBgView addSubview:self.attentBtn];
  
        // IDLabel
        UILabel *IDLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, self.myInfoBgView.bottom+10, 100, 20)];
        IDLabel.textAlignment = NSTextAlignmentCenter;
        IDLabel.textColor = [UIColor whiteColor];
        IDLabel.font = [UIFont systemFontOfSize:11.f];
        IDLabel.shadowColor = [UIColor blackColor];
        IDLabel.shadowOffset = CGSizeMake(0, -1.0);
        IDLabel.text = [NSString stringWithFormat:@"ID:%@",[LCMyUser mine].playBackUserId];
        [self addSubview:IDLabel];
     
        self.audienceTableView = [[RoomAudienceTableView alloc] initWithFrame:CGRectMake(self.myInfoBgView.right+ViewPadding,self.myInfoBgView.top+5, ViewWidth+ViewPadding,ViewWidth)];
        //    self.audienceTableView.size = CGSizeMake(SCREEN_WIDTH - self.myInfoBgView.right, ViewWidth);
        ESWeakSelf;
//        self.audienceTableView.reViewBlock = ^(NSDictionary * userInfoDict) {
//            ESStrongSelf;
//            [_self reviewUser:userInfoDict];
//        };
//        
        self.audienceTableView.privateChatBlock = ^(NSDictionary * userInfoDict) {
            ESStrongSelf;
            [_self.delegate showPrivChat:userInfoDict];
        };
        self.audienceTableView.showUserBlock = ^(LiveUser *liveUser){
            ESStrongSelf;
            [_self.delegate showUserSpaceVC:liveUser];
        };
        
//        self.audienceTableView.gagUserBlock = ^(NSDictionary * userInfoDict) {
//            ESStrongSelf;
//            NSMutableDictionary *socket = [NSMutableDictionary dictionary];
//            socket[@"type"] = LIVE_GROUP_GAG;                       // 消息类型
//            socket[@"uid"] = userInfoDict[@"uid"];                  // 用户id
//            socket[@"nickname"] = userInfoDict[@"nickname"];        // 用户名称
//            socket[@"send_name"] = [LCMyUser mine].nickname;        // 发送禁言
//            [LiveMsgManager sendGagInfo:socket Succ:nil andFail:nil];
//            [_self addMessage:nil andUserInfo:socket];
//        };
        
        
//        self.audienceTableView.addManagerBlock = ^(NSDictionary * userInfoDict) {
//            ESStrongSelf;
//            NSMutableDictionary *socket = [NSMutableDictionary dictionary];
//            socket[@"type"] = LIVE_GROUP_MANAGER;                      // 消息类型
//            socket[@"uid"] = userInfoDict[@"uid"];                  // 用户id
//            socket[@"nickname"] = userInfoDict[@"nickname"];        // 用户名称
//            
//            [LiveMsgManager sendManagerInfo:socket Succ:nil andFail:nil];
//            [_self addMessage:nil andUserInfo:socket];
//        };
//        self.audienceTableView.removeManagerBlock = ^(NSDictionary * userInfoDict) {
//            ESStrongSelf;
//            NSMutableDictionary *socket = [NSMutableDictionary dictionary];
//            socket[@"type"] = LIVE_GROUP_REMOVE_MANAGER;            // 消息类型
//            socket[@"uid"] = userInfoDict[@"uid"];                  // 用户id
//            socket[@"nickname"] = userInfoDict[@"nickname"];        // 用户名称
//            
//            [LiveMsgManager sendRemoveManagerInfo:socket Succ:nil andFail:nil];
//            [_self addMessage:nil andUserInfo:socket];
//        };
        
        
        [self addSubview:self.audienceTableView];
        self.audienceTableView.userInteractionEnabled = YES;
        
        if ([LCMyUser mine].playBackUserId && ([[LCMyUser mine].userID isEqualToString:[LCMyUser mine].playBackUserId]
                                           || [[LCMyUser mine] isAttentUser:[LCMyUser mine].playBackUserId]))
        {
            _attentBtn.hidden = YES;
            self.myInfoBgView.width = 90;
            self.audienceTableView.left = self.myInfoBgView.right+10;
            self.audienceTableView.width = SCREEN_WIDTH - self.myInfoBgView.right-10;
        }
        else
        {
            _attentBtn.hidden = NO;
            self.myInfoBgView.width = 130;
            self.audienceTableView.left = self.myInfoBgView.right+10;
            self.audienceTableView.width = SCREEN_WIDTH - self.myInfoBgView.right-10;
            [self showAttentDelayHiddenAnimation];
        }
        
        UIImage *recBgImg = [UIImage imageNamed:@"image/liveroom/me_ub_bg"];
        UIEdgeInsets insetsHead = UIEdgeInsetsMake(0, 5, 0,40);
        // 指定为拉伸模式，伸缩后重新赋值
        recBgImg = [recBgImg resizableImageWithCapInsets:insetsHead resizingMode:UIImageResizingModeStretch];
        self.recvBgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.myInfoBgView.bottom+15, recBgImg.size.width, recBgImg.size.height)];
        self.recvBgImgView.image = recBgImg;
        [self addSubview:self.recvBgImgView];
        
        self.recvPromptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 26, self.recvBgImgView.height)];
        self.recvPromptLabel.textAlignment = NSTextAlignmentCenter;
        self.recvPromptLabel.textColor = ColorPink;
        self.recvPromptLabel.font = [UIFont systemFontOfSize:11.f];
        self.recvPromptLabel.text = ESLocalizedString(@"有美币");
        [self.recvBgImgView addSubview:self.recvPromptLabel];
        
        self.recvCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.recvPromptLabel.right, 0, 24, self.recvBgImgView.height)];
        self.recvCountLabel.textAlignment = NSTextAlignmentCenter;
        self.recvCountLabel.textColor = [UIColor whiteColor];
        self.recvCountLabel.font = [UIFont systemFontOfSize:11.f];
        self.recvCountLabel.text = @"0";
        [self.recvBgImgView addSubview:self.recvCountLabel];
        
        // 更新收入
        [self updateRecvDiamond:@"0"];
        
        self.barrageView = [[BarrageAllMsgView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2-70, SCREEN_WIDTH, 120.f)];
        [self addSubview:self.barrageView];
        
        self.allShowGiftView = [[LiveAllShowGiftView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2 - 50, 290.f, 130.f)];
        [self addSubview:self.allShowGiftView];
        
//        self.showGroupMsgView = [[ShowGroupMsgView alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT- 140 - 50, SCREEN_WIDTH-70, 140)];
//        self.showGroupMsgView.showUserSpaceBlock = ^(LiveUser *liveUser){
//            ESStrongSelf;
//            [_self.delegate showUserSpaceVC:liveUser];
//        };
//        
//        [self addSubview:self.showGroupMsgView];
//        self.showGroupMsgView.contentTable.contentInset = UIEdgeInsetsMake(self.showGroupMsgView.height, 0, 0, 0);
        
//        UIImage *roomEnterImg = [UIImage imageNamed:@"image/liveroom/room_enter_2"];
//        
//        self.enterRoomAnimView = [[EnterRoomAnimView alloc] initWithFrame:CGRectMake(0, self.showGroupMsgView.top - roomEnterImg.size.height-10, SCREEN_WIDTH, roomEnterImg.size.height)];
//        [self addSubview:self.enterRoomAnimView];
        
  
//        UIImage *msgImage = [UIImage imageNamed:@"image/liveroom/roommsg"];
        UIImage *roomShutImage = [UIImage imageNamed:@"image/liveroom/roomshut"];
        
//        UIImage *cameraNormalImage = [UIImage imageNamed:@"image/liveroom/mg_room_btn_shan_h"];
//        UIImage *cameraFocusImage = [UIImage imageNamed:@"image/liveroom/mg_room_btn_shan_n"];
        
        UIImage *roomGiftImage = [UIImage imageNamed:@"image/liveroom/roomgift"];
        UIImage *roomChatImage = [UIImage imageNamed:@"image/liveroom/roomchat"];
        UIImage *roomshareImage = [UIImage imageNamed:@"image/liveroom/roomshare"];
        
        
        UIImage *connectChatImage = [UIImage imageNamed:@"image/liveroom/room_up_voice"];
        
//        UIImage *giftAnimNoImage = [UIImage imageNamed:@"image/liveroom/room_gift_anim_yes"];
        
        
        float viewSize = roomShutImage.size.width;
        self.badgeView = [ESBadgeView badgeViewWithText:@"0"];
        
        self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - viewSize - 10-self.badgeView.height/2,SCREEN_WIDTH, viewSize+10+self.badgeView.height/2)];
        [self addSubview:self.bottomView];
        
        self.timeLabel = [UILabel new];
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        self.timeLabel.font = [UIFont systemFontOfSize:12.0];
        self.timeLabel.textColor = [UIColor whiteColor];
        self.timeLabel.frame = CGRectMake(15, self.bottomView.height/2 - 10, 100, 20);
        [self.bottomView addSubview:self.timeLabel];
//        self.msgBtn = [[UIButton alloc] initWithFrame:CGRectMake(5,self.badgeView.height/2, viewSize, viewSize)];
//        self.msgBtn.backgroundColor = [UIColor clearColor];
//        [self.msgBtn setImage:msgImage forState:UIControlStateNormal];
//        
//        [self.msgBtn addTarget:self action:@selector(showMsgAction) forControlEvents:UIControlEventTouchUpInside];
//        [self.bottomView addSubview:self.msgBtn];
//        self.msgBtn.hidden = NO;
        
        self.connectFlagImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, connectChatImage.size
                                                                                .width, connectChatImage.size.height)];
        self.connectFlagImgView.image = connectChatImage;
        self.connectFlagImgView.centerY = _bottomView.centerY;
        [self.bottomView addSubview:_connectFlagImgView];
        
        
        self.closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH- viewSize - 10,self.badgeView.height/2, viewSize, viewSize)];
        [self.closeBtn setImage:roomShutImage  forState:UIControlStateNormal];
        [self.closeBtn addTarget:self action:@selector(closeLiveView) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.closeBtn];
        
        float leftX = 0.f;
        
    
        self.giftBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.closeBtn.left - viewSize - 10, self.badgeView.height/2, viewSize, viewSize)];
        //        self.giftBtn.backgroundColor = [UIColor clearColor];
        [self.giftBtn setImage:roomGiftImage forState:UIControlStateNormal];
        [self.giftBtn addTarget:self action:@selector(showGiftView) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.giftBtn];
        leftX = self.giftBtn.left;
        
        self.shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(leftX - viewSize - 10, self.badgeView.height/2, viewSize, viewSize)];
        //        self.shareBtn.backgroundColor = [UIColor clearColor];
        [self.shareBtn setImage:roomshareImage forState:UIControlStateNormal];
        [self.shareBtn addTarget:self action:@selector(showShareAction) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.shareBtn];
        
        self.priChatBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.shareBtn.left - viewSize - 10, self.badgeView.height/2, viewSize, viewSize)];
        //        self.priChatBtn.backgroundColor = [UIColor clearColor];
        [self.priChatBtn setImage:roomChatImage forState:UIControlStateNormal];
        [self.priChatBtn addTarget:self action:@selector(showPrivChatView) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.priChatBtn];
       
        
        self.badgeView.left = self.priChatBtn.right - viewSize/2;
        self.badgeView.top =  0;
        [self.bottomView addSubview:self.badgeView];
        if ([IMBridge bridge].countOfTotalUnreadMessages > 0) {
            self.badgeView.hidden = NO;
            self.badgeView.text =  [NSString stringWithFormat:@"%d",[IMBridge bridge].countOfTotalUnreadMessages];
        } else {
            self.badgeView.hidden = YES;
        }
        
        [self addKeyboardNotification];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(singleTap)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        singleRecognizer.delegate = self;
        [self addGestureRecognizer:singleRecognizer];
        
        /* 礼物列表 */
        self.giftView = [[LiveGiftView alloc] initWithFrame:CGRectZero];
        self.giftView.showRechargeBlock = ^(){
            ESStrongSelf;
            [_self.delegate showRechargeVC];
        };
        self.giftView.sendGiftBlock = ^(NSDictionary *giftDict){
            ESStrongSelf;
            [_self updateRecvDiamond:[NSString stringWithFormat:@"%d",[giftDict[@"recv_diamond"] intValue]]];
            
            int grade = [giftDict[@"grade"] intValue];
            if (grade > [LCMyUser mine].userLevel) {
                [LCMyUser mine].userLevel = grade;
                
                NSMutableDictionary *socket = [NSMutableDictionary dictionary];
                socket[@"type"] = LIVE_GROUP_UPGRADE;                    // 消息类型
                socket[@"uid"] = [LCMyUser mine].userID;        // 用户id
                socket[@"nickname"] = [LCMyUser mine].nickname; // 用户昵称
                socket[@"grade"] = [NSNumber numberWithInt:[LCMyUser mine].userLevel];  // 用户级别
                
                [LiveMsgManager sendUserUpGrade:socket Succ:nil andFail:nil];
                
                [_self addMessage:@"upgrade" andUserInfo:socket];
            }
            
            if ([giftDict[@"gift_type"] intValue] == GIFT_TYPE_CONTINUE) {// 连续礼物动画
                if (_self.allShowGiftView) {
                    [_self.allShowGiftView showGiftView:giftDict];
                }
            } else if ([giftDict[@"gift_type"] intValue] == GIFT_TYPE_REDPACKET) {// 红包
                
//                [_self.contentTextField resignFirstResponder];
                [RedPacketManager redPacketManager].redPacketDict = giftDict;
                
            } else if ([giftDict[@"gift_type"] intValue] == GIFT_TYPE_LUXURY) {// 豪华礼物
                [LuxuryManager luxuryManager].luxuryDict = giftDict;
            }
            
            [_self addMessage:@"gift" andUserInfo:giftDict];
        };
        [self addSubview:self.giftView];
        self.giftView.hidden=YES;
        
        shareView = [[RoomShareView alloc] initWithFrame:CGRectZero];
        [self addSubview:shareView];
        shareView.hidden = YES;
    }
    
    return self;
}


#pragma mark - 显示送礼物
//- (void) dealShowGiftAsync
//{
//    if (!__gShowGiftMessagesQueue) {
//        __gShowGiftMessagesQueue = dispatch_queue_create("com.qianchuo.ShowGiftQueue", DISPATCH_QUEUE_SERIAL);
//    }
//}

#pragma mark - 显示我送出礼物
- (void) showMineSendGift:(NSDictionary *)giftDict
{
//    NSString *showMsg =  [GroupMsgCell CellContent:giftDict];
//    if (!showMsg) {
//        return;
//    }
//    
//    NSMutableDictionary *msgUpdateDict = [NSMutableDictionary dictionaryWithDictionary:giftDict];
//    [msgUpdateDict setObject:showMsg forKey:@"show_msg"];
//    
//    int labHeight = [ShowGroupMsgView getTxtSize:showMsg withUserGrade:[giftDict[@"grade"] intValue] withGift:[giftDict[@"type"] isEqualToString:LIVE_GROUP_GIFT]?YES:NO];
//    
//    [msgUpdateDict setObject:@(labHeight) forKey:@"height"];
//    
//    if ([giftDict[@"type"] isEqualToString:LIVE_GROUP_GIFT]) {
//        [[[ParseContentCommon alloc] init] parseGiftMsg:showMsg withMsgInfo:msgUpdateDict];
//    }
//    
//    if (labHeight == 0) {
//        return;
//    }
//    
//    [self addMessage:@"gift" andUserInfo:msgUpdateDict];
}

// 审核的view
//- (void) setManangerView
//{
//    self.mSuperManagerView = [[UIView alloc] initWithFrame:CGRectMake(10, 115, ScreenWidth - 20, 300)];
//    //    self.mSuperManagerView.backgroundColor = [UIColor yellowColor];
//    self.mSuperManagerView.hidden = YES;
//    [self addSubview:self.mSuperManagerView];
//    [self addManagerButtonWithTitle:@"禁止直播" tag:2 top:0 right:0];
//    [self addManagerButtonWithTitle:@"关闭直播" tag:1 top:40 right:0];
//    [self addManagerButtonWithTitle:@"隐藏直播" tag:5 top:80 right:0];
//    
//    [self addManagerButtonWithTitle:@"推荐直播" tag:3 top:0 right:self.mSuperManagerView.width];
//    [self addManagerButtonWithTitle:@"置顶直播" tag:4 top:40 right:self.mSuperManagerView.width];
//    [self addManagerButtonWithTitle:@"审核通过" tag:6 top:80 right:self.mSuperManagerView.width];
//}
//
//- (void)addManagerButtonWithTitle:(NSString *)title tag:(long)tag top:(long)top right:(long)right {
//    ESButton* mSuperManagerButton = [ESButton buttonWithTitle:title];
//    mSuperManagerButton.tag = tag;
//    mSuperManagerButton.opaque = YES;
//    mSuperManagerButton.color = ColorPink;
//    mSuperManagerButton.top = top;
//    if (right) {
//        mSuperManagerButton.right = right;
//    }
//    [mSuperManagerButton addTarget:self action:@selector(onOperationAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.mSuperManagerView addSubview:mSuperManagerButton];
//    
//}



-(void)addKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

//- (void)completeInput
//{
//    if (_contentTextField) {
//        [self textFieldShouldReturn:_contentTextField];
//    }
//}
//
//#pragma mark - 刷新聊天
//- (void)onRefresh {
//    if (![LCMyUser mine].liveUserId) {
//        return;
//    }
//    
//    ESWeakSelf;
//    [[IMBridge bridge] joinRoom:[LCMyUser mine].liveUserId completion:^(NSError *error) {
//        NSLogIf(error, @"watch join error %@", error);
//        ESStrongSelf;
//        NSMutableDictionary *systemDict = [NSMutableDictionary dictionary];
//        systemDict[@"type"] = LIVE_GROUP_SYSTEM_MSG;                    // 消息类型
//        systemDict[@"system_content"] = @"重新连接服务器成功";                  // 系统消息
//        
//        [_self addMessage:nil andUserInfo:systemDict];
//    }];
//}
//
//#pragma mark - 链接聊天标记
//- (void) connectChatFlag
//{
//    self.msgBtn.hidden = NO;
//    self.connectFlagImgView.hidden = YES;
//}

#pragma mark - 关注主播
- (void) attentLiveUserAction
{
    if (isAttentLiveUser || ![LCMyUser mine].playBackUserId) {
        return;
    }
    isAttentLiveUser = YES;
    ESWeakSelf;
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        
        isAttentLiveUser = NO;
        
        ESStrongSelf;
        NSInteger code = [[responseDic objectForKey:@"stat"] integerValue];
        if (URL_REQUEST_SUCCESS == code)
        {
            [[LCMyUser mine] addAttentUser:[LCMyUser mine].playBackUserId];
            [_self showAttentHiddenAnimation];
        }
        else
        {
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        [LCNoticeAlertView showMsg:@"请求获取数据！"];
        isAttentLiveUser = NO;
    };
    
    NSDictionary *paramter = @{@"u":[LCMyUser mine].playBackUserId};
    NSLog(@"paramter %@",paramter);
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:paramter
                                                  withPath:URL_ADD_ATTENT_USER
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
    
}

#pragma mark - 显示动画
- (void) showAttentDelayHiddenAnimation
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


- (void) showAttentHiddenAnimation
{
    [UIView animateWithDuration:.2 animations:^{
        self.attentBtn.width = 0;
        self.myInfoBgView.width = 90;
        self.audienceTableView.left = self.myInfoBgView.right+10;
        self.audienceTableView.width = SCREEN_WIDTH - self.myInfoBgView.right-10;
        
    } completion:^(BOOL finished) {
        if (!self.attentBtn.hidden) {
            self.attentBtn.hidden = YES;
        }
    }];
}

//#pragma mark - 禁止直播
//- (void)onOperation:(UIButton *)sender {
//    ESWeakSelf;
//    UIAlertView *alterView = [UIAlertView alertViewWithTitle:sender.currentTitle message:nil cancelButtonTitle:@"取消" didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
//        if (buttonIndex == 0) {
//            ESStrongSelf;
//            [_self requestWithOperation:sender.tag];
//        }
//    } otherButtonTitles:@"确认", nil];
//    [alterView show];
//}
//
//- (void)onOperationAction:(UIButton *)sender {
//    [self onOperation:sender];
//}
//
//- (void)requestWithOperation:(long)type {
//    if (![LCMyUser mine].liveUserId) {
//        return;
//    }
//    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"liveuid":[LCMyUser mine].liveUserId, @"type":@(type)}
//                                                  withPath:URL_BAN_LIVE
//                                               withRESTful:GET_REQUEST
//                                          withSuccessBlock:^(NSDictionary *responseDic) {
//                                              NSLog(@"禁止直播: %@", [responseDic description]);
//                                              [LCNoticeAlertView showClearBackgroundMsg:@"操作成功"];
//                                          } withFailBlock:^(NSError *error) {
//                                              NSLog(@"禁止直播失败: %@", [error description]);
//                                              [LCNoticeAlertView showClearBackgroundMsg:@"操作失败"];
//                                          }];
//}
//
//#pragma mark - 聊天
//- (void)showMsgAction
//{
//    self.bottomView.hidden = YES;
//    self.contentContainerView.hidden = NO;
//    self.contentTextField.hidden = NO;
//    self.enterContentView.hidden = NO;
//    if (self.contentTextField) {
//        [self.contentTextField becomeFirstResponder];
//    }
//    
//}

#pragma mark - 显示私聊
- (void) showPrivChatView
{
    [self.delegate showConversationVC];
}

//#pragma mark - 控制显示礼物动画显示
//- (void) contollerAnimShowAction
//{
//    if (isShowGiftAnim) {
//        
//        if (self.allShowGiftView) {
//            [self.allShowGiftView hiddenGiftView];
//        }
//        
//        isShowGiftAnim = NO;
//        
//        UIImage *giftAnimNoImage = [UIImage imageNamed:@"image/liveroom/room_gift_anim_no"];
//        [self.showGiftAnimStateBtn setImage:giftAnimNoImage forState:UIControlStateNormal];
//        
//        [LCNoticeAlertView showMsg:ESLocalizedString(@"已屏蔽礼物特效")];
//    } else {
//        isShowGiftAnim = YES;
//        UIImage *giftAnimNoImage = [UIImage imageNamed:@"image/liveroom/room_gift_anim_yes"];
//        [self.showGiftAnimStateBtn setImage:giftAnimNoImage forState:UIControlStateNormal];
//        
//        [LCNoticeAlertView showMsg:ESLocalizedString(@"已开启礼物特效")];
//    }
//}
//
#pragma mark - 显示分享
- (void) showShareAction
{
    shareView.hidden = NO;
    if (_progressBar) {
        _progressBar.hidden = YES;
    }
    [UIView animateWithDuration:0.5f animations:^{
        shareView.top = 0;
    }];
}

#pragma mark - 显示礼物
- (void)showGiftView
{
    self.giftView.hidden=NO;
    //    self.showGroupMsgView.hidden = YES;
    
    self.giftView.shapeDic=nil;
    
    
    [self.giftView setCurrentBalance];
    
    self.giftView.selectUserId = [LCMyUser mine].playBackUserId;
    
    [self.giftView upDateGiftList];
    
    if (self.progressBar) {
        self.progressBar.hidden = YES;
    }
    
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

#pragma mark 关闭视图
- (IBAction)closeLivingView:(id)sender
{
    if(self.delegate){
        [self.delegate closeLivingView:self];
    }
}

- (void) closeLiveView
{
    if(self.delegate)
    {
        [self.delegate closeLivingView:self];
    }
}

//#pragma mark - 群聊回复
//- (void) reviewUser:(NSDictionary *)userInfo
//{
//    self.contentTextField.text = [NSString stringWithFormat:@"@%@:",userInfo[@"nickname"]];
//    [self showMsgAction];
//}
//
//#pragma mark - 举报
//- (void) reportAction
//{
//    [[Business sharedInstance] liveReportSucc:^(NSString *msg, id data) {
//        [LCNoticeAlertView showMsg:msg];
//    } fail:^(NSString *error) {
//        
//    }];
//}


//#pragma mark textfield delegate
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [self sendMsgAction];
//    return YES;
//}

//- (void) textFieldDidChange:(UITextField *) textField
//{
//    if (textField == _contentTextField) {
//        if (textField.text.length > 32) {
//            textField.text = [textField.text substringToIndex:32];
//        }
//    }
//}

//// 发送消息
//- (void) sendMsgAction
//{
//    if (!self.contentTextField) {
//        return;
//    }
//    
//    if (self.contentTextField.text.length <= 0 || !self.sendMsgBtn.enabled) {
//        return;
//    }
//    
//    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
//    /**
//     *  本次登录内：
//     1、发送内容与粘贴板一致超过3次；
//     2、5级以下；
//     3、本次发送内容仍旧和粘贴板一致；
//     
//     满足以上内容，内容不发送房间消息
//     */
//    [LCMyUser mine].isAD = NO;
//    if ([pasteboard.string isEqualToString:self.contentTextField.text]) {
//        static long count = 0;
//        ++count;
//        NSLog(@"粘贴次数 %ld", count);
//        if ([LCMyUser mine].userLevel < 5 && count > 3) {
//            [LCMyUser mine].isAD = YES;
//            [ADSUtil requestServerWithString:self.contentTextField.text];
//        }
//    }
//    
//    
//    if (self.contentTextField.text.length >= 30) {
//        [self.contentTextField resignFirstResponder];
//        [LCNoticeAlertView showClearBackgroundMsg:ESLocalizedString(@"字数太长")];
//        return ;
//    }
//    
//    if (isBarrageState) {
//        [self sendBarrageMsg];
//    } else {
//        if ([LCMyUser mine].isGag) {
//            [self.contentTextField resignFirstResponder];
//            [LCNoticeAlertView showMsg:ESLocalizedString(@"您已被管理员禁言!")];
//            return;
//        }
//        if(self.delegate) {
//            [self.delegate sendMessage:self];
//            self.contentTextField.text =  @"";
//            self.mMsgCD = 10;
//            self.mMsgTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onMsgCD) userInfo:nil repeats:YES];
//            [self onMsgCD];
//            
//        }
//    }
//}
//
//- (void)onMsgCD {
//    --self.mMsgCD;
//    if (self.mMsgCD > 0) {
//        [self.sendMsgBtn setTitle:[NSString stringWithFormat:@"%ld", self.mMsgCD] forState:UIControlStateNormal];
//        self.sendMsgBtn.enabled = NO;
//    }
//    else {
//        [self.sendMsgBtn setTitle:ESLocalizedString(@"发送") forState:UIControlStateNormal];
//        self.sendMsgBtn.enabled = YES;
//        [self.mMsgTimer invalidate];
//    }
//}

//#pragma mark - 弹幕
//- (void) barrageAction
//{
//    if (!self.contentTextField) {
//        return;
//    }
//    
//    UIImage *switchCloseImg = [UIImage createContentsOfFile:@"image/liveroom/switch_barrage_close"];
//    UIImage *switchopenImg = [UIImage createContentsOfFile:@"image/liveroom/switch_barrage_open"];
//    if (isBarrageState) {
//        self.contentTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:ESLocalizedString(@"说点什么吧") attributes:@{NSForegroundColorAttributeName: RGB16(COLOR_BG_WHITE)}];
//        isBarrageState = NO;
//        [self.brrageBtn setImage:switchCloseImg forState:UIControlStateNormal];
//    } else {
//        self.contentTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:ESLocalizedString(@"开启弹幕，1钻石/条") attributes:@{NSForegroundColorAttributeName: RGB16(COLOR_BG_WHITE)}];
//        isBarrageState = YES;
//        [self.brrageBtn setImage:switchopenImg forState:UIControlStateNormal];
//    }
//}

//// 发送弹幕消息
//- (void) sendBarrageMsg
//{
//    if (!self.contentTextField) {
//        return;
//    }
//    
//    if ([LCMyUser mine].isGag) {
//        [LCNoticeAlertView showMsg:ESLocalizedString(@"您已被管理员禁言!")];
//        return;
//    }
//    
//    if ([LCMyUser mine].diamond < 1)
//    {
//        ESWeakSelf;
//        UIAlertView *alert = [UIAlertView alertViewWithTitle:ESLocalizedString(@"提示") message:ESLocalizedString(@"余额不足，请充值！") cancelButtonTitle:ESLocalizedString(@"确认") didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
//            ESStrongSelf;
//            [_self.contentTextField resignFirstResponder];
//            if (_self.delegate) {
//                [_self.delegate showRechargeVC];
//            }
//        } otherButtonTitles:nil, nil];
//        [alert show];
//        return;
//    }
//    
//    if (self.contentTextField.text.length == 0)
//    {
//        return;
//    }
//    
//    NSString* msg = self.contentTextField.text;
//    
//    if (![LCMyUser mine].showManager) {
//        msg = [[ChatUtil shareInstance] getFilterStringWithSrc:msg];
//    }
//    
//    
//    if(self.delegate) {
//        [self.delegate sendMessage:self];
//        self.contentTextField.text =  @"";
//    }
//    
//    ESWeakSelf;
//    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
//        NSString* code = [responseDic objectForKey:@"stat"];
//        ESStrongSelf;
//        if (URL_REQUEST_SUCCESS == [code intValue])
//        {
//            [LCMyUser mine].diamond = [responseDic[@"diamond"] intValue];
//            
//            
//            NSMutableDictionary * barrageDict = [NSMutableDictionary dictionary];
//            [barrageDict setObject:[LCMyUser mine].userID forKey:@"uid"];
//            [barrageDict setObject:[LCMyUser mine].faceURL forKey:@"face"];
//            [barrageDict setObject:[LCMyUser mine].nickname forKey:@"nickname"];
//            [barrageDict setObject:[NSNumber numberWithInt:[LCMyUser mine].userLevel] forKey:@"grade"];
//            [barrageDict setObject:msg forKey:@"chat_msg"];
//            
//            if (!_self.barrageView.barrageInfoArray)
//            {
//                _self.barrageView.barrageInfoArray = [NSMutableArray array];
//            }
//            
//            [_self.barrageView.barrageInfoArray addObject:barrageDict];
//            [_self.barrageView showBarrageAnimation];
//            
//            [LiveMsgManager sendUserBarrageMsg:msg Succ:^(NSString *msg) {
//                NSLog(@"发送成功！");
//            } andFail:^(NSString *error) {
//                NSLog(@"发送失败！");
//            }];
//        }
//        else if (520 == [code intValue])
//        {
//            ESStrongSelf
//            UIAlertView *alert = [UIAlertView alertViewWithTitle:ESLocalizedString(@"提示") message:ESLocalizedString(@"余额不足，请充值！") cancelButtonTitle:ESLocalizedString(@"确认") didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
//                ESStrongSelf;
//                [_self.contentTextField resignFirstResponder];
//                if (_self.delegate) {
//                    [_self.delegate showRechargeVC];
//                }
//            } otherButtonTitles:nil, nil];
//            [alert show];
//        }
//        else
//        {
//            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
//        }
//    };
//    
//    LCRequestFailResponseBlock failBlock=^(NSError *error){
//        [LCNoticeAlertView showMsg:ESLocalizedString(@"发送失败！")];
//    };
//    
//    if ([LCMyUser mine].liveUserId) {
//        NSDictionary * paramter = @{@"liveuid":[LCMyUser mine].liveUserId,@"memo":msg};
//        [[LCHTTPClient sharedHTTPClient] requestWithParameters:paramter
//                                                      withPath:URL_LIVE_BARRAGE
//                                                   withRESTful:GET_REQUEST
//                                              withSuccessBlock:successBlock
//                                                 withFailBlock:failBlock];
//    }
//}

#pragma mark collection data source
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return _userArray.count;
//}

//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    UserLogoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserLogoCell" forIndexPath:indexPath];
//    NSDictionary* userDic = [_userArray objectAtIndex:indexPath.row];
//    //头像
//    NSString* logoPath = [userDic objectForKey:@"default_head"];
//    if([logoPath isEqualToString:@""]){
//        cell.userLogoImageView.image = [UIImage imageNamed:@"default_head"];
//    }
//    else{
////        NSInteger width = cell.userLogoImageView.frame.size.width*SCALE;
////        NSInteger height = width;
////        NSString *myLogoUrl = [NSString stringWithFormat:URL_IMAGE,logoPath,width,height];
//        [cell.userLogoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString faceURLString:logoPath]] placeholderImage:[UIImage imageWithColor:RGB16(COLOR_FONT_WHITE) andSize:cell.userLogoImageView.frame.size]];
//    }
//    return cell;
//}

//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake(35, 35);
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    if(self.delegate){
//        [self.delegate clickAudienceLogo:self withUserInfo:[_userArray objectAtIndex:indexPath.row]];
//    }
//    return;
//}
#pragma mark 定时删除消息
- (void)delMsgView{
    //    if(messageViewArray.count != 0){
    //        for(NSInteger index = 0; index < messageViewArray.count; index++){
    //            UIView* view = [messageViewArray objectAtIndex:index];
    //            NSDate* fromDate;
    //            if([view isKindOfClass:[MessageView class]]){
    //                fromDate = ((MessageView*)view).date;
    //            }
    //            if([view isKindOfClass:[WelcomeView class]]){
    //                fromDate = ((WelcomeView*)view).date;
    //            }
    //            NSInteger interval = [self getTimeIntervalFromNow:fromDate];
    //            if(MESSAGE_SURVIVAL_TIME <= interval){
    //                if(view.superview){
    //                    [messageViewArray removeObjectAtIndex:index];
    //                    --index;
    //                    [UIView animateWithDuration:0.3 animations:^{
    //                        view.alpha = 0;
    //                    }completion:^(BOOL finished) {
    //                        [view removeFromSuperview];
    //                    }];
    //                }
    //            }
    //        }
    //    }
}


//#pragma mark - 主播发红包
//- (void) sendPacketAction
//{
//    if (_giftView) {
//        [_giftView sendRedPacketAction];
//    }
//}

#pragma mark 计算时间间隔
- (NSInteger)getTimeIntervalFromNow:(NSDate*)from
{
    NSDate *to = [NSDate date];
    NSTimeInterval aTimer = [to timeIntervalSinceDate:from];
    int hour = (int)(aTimer/3600);
    int minute = (int)(aTimer - hour*3600)/60;
    int second = aTimer - hour*3600 - minute*60;
    return second;
}

#pragma mark 添加一条信息
- (void)addMessage:(NSString *)message andUserInfo:(NSDictionary*)userInfoDict
{
    
//    if (self.showGroupMsgView.contentArray && self.showGroupMsgView.contentArray.count >= 4) {
//        if ( self.showGroupMsgView.contentTable.contentInset.top > 0) {
//            NSLog(@"content inset %f",self.showGroupMsgView.contentTable.contentInset.top);
//            self.showGroupMsgView.contentTable.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//            
//            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.showGroupMsgView.contentArray.count - 1  inSection:0];
//            if (self.showGroupMsgView.contentTable.contentSize.height - self.showGroupMsgView.contentTable.contentOffset.y <= self.showGroupMsgView.contentTable.size.height) { // 只有在底部才滚动
//                [self.showGroupMsgView.contentTable scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//            }
//        }
//    }
//    
//    [self.showGroupMsgView addMsgToGroupMsgView:userInfoDict];
}

//- (void)setShowAllUser:(BOOL)showAllUser
//{
//    _messageScrollView.hidden = showAllUser;
//}

//- (BOOL)showAllUser
//{
//    return _messageScrollView.hidden;
//}

//- (void)onShowAllUser
//{
//    //    if ([_delegate respondsToSelector:@selector(onClickPanel:showAllUser:)])
//    //    {
//    //        [_delegate onClickPanel:self showAllUser:_userArray];
//    //    }
//    [self refleshUserView];
//}

//-(void)refleshUserView
//{
    //    ESWeakSelf;
    //    ESDispatchOnMainThreadAsynchrony(^{
    //        ESStrongSelf;
    //        [_self.onlineScrollerView removeAllSubviews];
    //
    //        NSUInteger arrayNum=[_userArray count];
    //
    //        CGSize newSize = CGSizeMake((ViewWidth+ViewPadding)*arrayNum, ViewWidth);
    //        [_self.onlineScrollerView setContentSize:newSize];
    //
    //
    //        for(int i=0;i<arrayNum;i++)
    //        {
    //            CGRect itemRect=CGRectMake(ViewPadding+i*(ViewWidth+ViewPadding),0,ViewWidth,ViewWidth);
    //            AudienceUserCell *userView=[[AudienceUserCell alloc] initWithFrame:itemRect];
    //
    //            userView.showUserDetail = ^(LiveUser *liveUser) {
    //                ESStrongSelf;
    //                liveUser.hasInRoom = YES;
    //
    //                NSString *userIdStr = [NSString stringWithFormat:@"%@",liveUser.userId];
    //                if (!userIdStr || userIdStr.length <= 0) {
    //                    return;
    //                }
    //
    //                UserSpaceViewController *onlineUserVC = [[UserSpaceViewController alloc] init];
    //                onlineUserVC.liveUser = liveUser;
    //                onlineUserVC.reViewBlock = ^(NSDictionary * userInfoDict) {
    //                    ESStrongSelf;
    //                    [_self reviewUser:userInfoDict];
    //                };
    //
    //                onlineUserVC.privateChatBlock = ^(NSDictionary * userInfoDict) {
    //                    ESStrongSelf;
    //                    [_self.delegate showPrivChat:userInfoDict];
    //                };
    //
    //                [[ESApp rootViewControllerForPresenting] popupViewController:onlineUserVC completion:nil];
    //            };
    //
    //
    //            userView.liveUser=(LiveUser *)_userArray[i];
    //            [_self.onlineScrollerView addSubview:userView];
    //        }
    //
    //    });
//    
//}

#pragma mark 添加用户
- (void)addUsers:(LiveUser *)lu
{
    [_audienceTableView addUserToAudience:lu];
}

- (NSInteger)invitedUserCount
{
    NSInteger count = 0;
    
    return count;
}

//- (NSInteger)allUserCount
//{
//    return [LCMyUser mine].liveOnlineUserCount;
//}

#pragma mark 删除用户
- (void)delUsers:(LiveUser *)user
{
    if ([_audienceTableView isReloadDataVisibleUser:user]) {
        [_audienceTableView.datas removeObject:user];
        [_audienceTableView reloadData];
    }
    
//    if ([LCMyUser mine].liveOnlineUserCount > 100) {
//        --[LCMyUser mine].liveOnlin eUserCount;
//        static BOOL waiting = NO;
//        if (!waiting) {
//            waiting = YES;
//            ESWeakSelf;
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(UPDATE_ONLINE_USER_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                waiting = NO;
//                ESStrongSelf;
//                [_self showUserCount];
//            });
//        }
//    }
}

#pragma mark - 显示用户总数
- (void) showUserCount:(NSString *)userCount
{
     self.userCountLabel.text = userCount;
}

#pragma mark 点击用户头像
- (void)logoTap:(UITapGestureRecognizer*)recognizer{
//    if (![LCMyUser mine].playBackUserId) {
//        return;
//    }
//    LiveUser *liveUser = [[LiveUser alloc] initWithPhone:[LCMyUser mine].playBackUserId name:[LCMyUser mine].liveUserName logo:[LCMyUser mine].liveUserLogo];
//    NSString *userIdStr = [NSString stringWithFormat:@"%@",liveUser.userId];
//    if (!userIdStr || userIdStr.length <= 0) {
//        return;
//    }
//    
//    ESWeakSelf;
//    UserSpaceViewController *onlineUserVC = [[UserSpaceViewController alloc] init];
//    onlineUserVC.liveUser = liveUser;
//    onlineUserVC.privateChatBlock = ^(NSDictionary * userInfoDict) {
//        ESStrongSelf;
//        [_self.delegate showPrivChat:userInfoDict];
//    };
//    onlineUserVC.attentUserBlock = ^(NSString *userId) {
//        if ([userId isEqualToString:[LCMyUser mine].liveUserId]) {
//            NSMutableDictionary *socket = [NSMutableDictionary dictionary];
//            socket[@"type"] = LIVE_GROUP_ATTENT;            // 消息类型
//            socket[@"uid"] = [LCMyUser mine].userID;        // 用户id
//            socket[@"nickname"] = [LCMyUser mine].nickname; // 用户昵称
//            ESStrongSelf;
//            [_self addMessage:nil andUserInfo:socket];
//            
//            [LiveMsgManager sendAttentMsg:socket Succ:nil andFail:nil];
//        }
//    };
//    
//    [[ESApp rootViewControllerForPresenting] popupViewController:onlineUserVC completion:nil];
}

#pragma mark 点赞
- (void)loveTap:(UITapGestureRecognizer*)recognizer
{
//    if(self.delegate)
//    {
//        [self.delegate loveTap:self];
//    }
}

//#pragma mark 添加进房动画
//- (void)addEnterRoomAnim:(NSDictionary*)enterRoomDict
//{
//    if (_enterRoomAnimView) {
//        if (!_enterRoomAnimView.enterInfoArray) {
//            _enterRoomAnimView.enterInfoArray = [NSMutableArray array];
//        }
//        
//        if ([self isAddEnterRoomAnim:enterRoomDict]) {
//            [_enterRoomAnimView.enterInfoArray addObject:enterRoomDict];
//            
//            [_enterRoomAnimView showEnterRoomView];
//        }
//    }
//}

//// 是否添加进房动画
//- (BOOL) isAddEnterRoomAnim:(NSDictionary*)enterRoomDict
//{
//    if (!enterRoomDict[@"uid"]) {
//        return NO;
//    }
//    
//    if (!_addAnimTimerDict) {
//        _addAnimTimerDict = [NSMutableDictionary dictionary];
//        NSTimeInterval currTime=[[NSDate date] timeIntervalSince1970];
//        double i=currTime;      //NSTimeInterval返回的是double类型
//        NSLog(@"1970timeInterval:%f",i);
//        [_addAnimTimerDict setObject:@(currTime) forKey:enterRoomDict[@"uid"]];
//        
//        return YES;
//    } else {
//        if (_addAnimTimerDict[enterRoomDict[@"uid"]]) {
//            NSTimeInterval currTime=[[NSDate date] timeIntervalSince1970];
//            
//            NSNumber *oldTime = _addAnimTimerDict[enterRoomDict[@"uid"]];
//            
//            float time = currTime - [oldTime longLongValue];
//            
//            NSLog(@"enter room time:%f",time);
//            
//            if (time > ADD_ENTER_ANIM_TIME * 60) {
//                [_addAnimTimerDict setObject:@(currTime) forKey:enterRoomDict[@"uid"]];
//                return  YES;
//            } else {
//                return  NO;
//            }
//            
//        } else {
//            NSTimeInterval currTime=[[NSDate date] timeIntervalSince1970];
//            double i=currTime;      //NSTimeInterval返回的是double类型
//            NSLog(@"1970timeInterval:%f",i);
//            [_addAnimTimerDict setObject:@(currTime) forKey:enterRoomDict[@"uid"]];
//            return YES;
//        }
//    }
//    
//    return  NO;
//}
//
//- (void)addLove:(NSInteger)count withLightPos:(int)lightPos
//{
//    ESWeakSelf;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        ESStrongSelf;
//        NSInteger newCount = [_self.loveCountLabel.text integerValue] + count;
//        _self.loveCountLabel.text = [[NSNumber numberWithInteger:newCount] stringValue];
//        NSString* imageName = nil;
//        if (lightPos > 0) {
//            imageName = [NSString stringWithFormat:@"image/liveroom/lightup_%d",lightPos];
//        } else {
//            int index = arc4random() % 6;
//            imageName = [NSString stringWithFormat:@"heart%d",index];
//        }
//        
//        UIImageView* animateView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
//        //        if ([LCMyUser mine].liveType == LIVE_WATCH) {
//        //            animateView.center = _self.giftBtn.center;
//        //        } else {
//        //            animateView.center = _self.switchCameraBtn.center;
//        //        }
//        animateView.center = CGPointMake(SCREEN_WIDTH - _self.loveView.width - 5 - _self.loveView.width/2, SCREEN_HEIGHT-_self.loveView.height - 80);
//        
//        animateView.image = [UIImage imageNamed:imageName];
//        [_self.messageContentView addSubview:animateView];
//        
//        UIBezierPath *thumbPath = [UIBezierPath bezierPath];
//        [thumbPath moveToPoint: CGPointMake(99,270)];
//        [thumbPath addCurveToPoint:CGPointMake(164,260) controlPoint1:CGPointMake(164,280) controlPoint2:CGPointMake(164,280)];
//        [thumbPath addCurveToPoint:CGPointMake(164,260) controlPoint1:CGPointMake(260,310) controlPoint2:CGPointMake(260,310)];
//        CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//        pathAnimation.path = thumbPath.CGPath;
//        pathAnimation.duration = 2.0;
//        
//        
//        [UIView animateWithDuration:3 animations:^{
//            int x = arc4random() % 10+3;
//            int t = 0;
//            if (x % 2 == 0) {
//                t = x * 5;
//            } else {
//                t = - (x * 5);
//            }
//            
//            animateView.frame = CGRectMake(animateView.frame.origin.x+t, SCREEN_HEIGHT*1/4, animateView.frame.size.width, animateView.frame.size.height);
//            //            NSLog(@"animateView %@",NSStringFromCGRect(animateView.frame));
//            animateView.alpha = 0;
//        } completion:^(BOOL finish) {
//            [animateView removeFromSuperview];
//        }];
//    });
//}


- (void)handleKeyboardDidShow:(NSNotification *)notification
{
    //[self.rootViewController.contentView bringSubviewToFront:self];
    NSDictionary *info=[notification userInfo];
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat distanceToMove = kbSize.height;
    
    [UIView animateWithDuration:0.5f animations:^{
        self.bottom = SCREEN_HEIGHT - distanceToMove;
    }];
}

- (void)handleKeyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.5f animations:^{
        self.bottom = SCREEN_HEIGHT;
        if (self.bottomView) {
            self.bottomView.hidden = NO;
        }
        
       
    }];
}


#pragma mark 屏幕点击
- (void) singleTap
{
    if (!self.giftView.isHidden) {
        [self hiddenGiftView];
    } else if (!shareView.isHidden) {
        [self hiddenShareView];
    } else {
        if(self.delegate)
        {
            [self.delegate loveTap:self];
        }
    }
}

#pragma mark - 隐藏礼物列表
- (void) hiddenGiftView
{
    if (!self.giftView.isHidden) {
        [UIView animateWithDuration:0.5f animations:^{
            _giftView.top = SCREEN_HEIGHT;
            _bottomView.top = SCREEN_HEIGHT - _bottomView.size.height;
        } completion:^(BOOL finish) {
            [_giftView stopRefreshTimer];
            _giftView.hidden = YES;
//            _showGroupMsgView.hidden = NO;
            _bottomView.hidden = NO;
            if (self.progressBar) {
                self.progressBar.hidden = NO;
            }
        }];
    }
}

#pragma mark - 隐藏分享
- (void) hiddenShareView
{
    if (!shareView.isHidden) {
        [UIView animateWithDuration:0.5f animations:^{
            shareView.top = SCREEN_HEIGHT;
            
        } completion:^(BOOL finish) {
            shareView.hidden = YES;
            if (_progressBar) {
                _progressBar.hidden = NO;
            }
        }];
    }
}

#pragma mark - 点击范围
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
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
        
//        CGPoint groupMsgPoint = [touch locationInView:self.showGroupMsgView];
//        if (groupMsgPoint.x > 0 && groupMsgPoint.x < self.showGroupMsgView.frame.size.width
//            && groupMsgPoint.y > 0 && groupMsgPoint.y < self.showGroupMsgView.frame.size.height)
//        {
//            if (self.bottomView.hidden)
//            {
//                [self.contentTextField resignFirstResponder];
//            }
//            return NO;
//        }
        
        //        CGPoint audiencePoint = [touch locationInView:self.audienceTableView];
        //        if (audiencePoint.x > 0 && audiencePoint.x < self.audienceTableView.frame.size.width
        //            && audiencePoint.y > 0 && audiencePoint.y < self.audienceTableView.frame.size.height) {
        //            return NO;
        //        }
        
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

#pragma mark - 滑动区域
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

#pragma mark - 更新收入
- (void) updateRecvDiamond:(NSString *)recDiamondStr
{
    self.recvBgImgView.hidden = NO;
    UIImage *recvIconImg = [UIImage imageNamed:@"image/liveroom/room_money_check"];
    
    CGSize recvSize = [recDiamondStr sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12]}];
    float recvBgWidth = recvSize.width+_recvPromptLabel.width+recvIconImg.size.width+15;
    self.recvCountLabel.width = recvSize.width + recvIconImg.size.width+10;
    self.recvBgImgView.width = recvBgWidth;
    [self showRecvDiamond:recDiamondStr];
}

- (void) showRecvDiamond:(NSString *)recDiamondStr
{
    NSString *recvDiamondText = [NSString stringWithFormat:@"%@  d",recDiamondStr];
    NSMutableAttributedString * mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:recvDiamondText];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    UIImage *image = [UIImage imageNamed:@"image/liveroom/room_money_check"];
    textAttachment.image = image;
    //    textAttachment.image = [UIImage imageWithImage:image scaleToSize:CGSizeMake(image.size.width, image.size.height)];
    
    textAttachment.bounds = CGRectMake(0, -2, image.size.width, image.size.height);
    
    NSAttributedString *iconAttributedString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [mutableAttributedString replaceCharactersInRange:NSMakeRange(recvDiamondText.length-1, 1) withAttributedString:iconAttributedString];
    
    self.recvCountLabel.attributedText = mutableAttributedString;
}


#pragma mark - 显示群聊
- (void) showDealGroupMsgType:(NSString *)msgType withMsgContent:(NSDictionary *)socketData
{
    if ([LCMyUser mine].playBackUserId) {
        return;
    }
    
    if ([msgType isEqualToString:LIVE_GROUP_ENTER_ROOM]) {
        LiveUser *lu = [[LiveUser alloc] initWithPhone:socketData[@"uid"] name:socketData[@"nickname"] logo:socketData[@"face"]];
        lu.userGrade = [socketData[@"grade"] intValue];
        
        
        [self addUsers:lu];
        [self addMessage:nil andUserInfo:socketData];
        if (lu.userGrade >= LIVE_USER_GRADE *2) {// 添加进房特效
//            [self addEnterRoomAnim:socketData];
        }
    } else if([msgType isEqualToString:LIVE_GROUP_CHAT_MSG]) {
        
        [self addMessage:socketData[@"chat_msg"] andUserInfo:socketData];
        
    } else if([msgType isEqualToString:LIVE_GROUP_EXIT_ROOM]) {
        NSString *userId = socketData[@"uid"];
        LiveUser *lu = [[LiveUser alloc] initWithPhone:userId name:nil logo:nil];
        [self delUsers:lu];
    } else if ([msgType isEqualToString:LIVE_GROUP_USER_LOVE]) {// 点亮
        
//        [self addLove:1 withLightPos:[socketData[@"love_pos"] intValue]];
        //        NSMutableDictionary *updateDict = [NSMutableDictionary dictionaryWithDictionary:socketData];
        //        updateDict[@"grade"] = @(9999);
        [self addMessage:nil andUserInfo:socketData];
    } else if ([msgType isEqualToString:LIVE_GROUP_GIFT]) {
        
        int recvDiamond = [socketData[@"recv_diamond"] intValue];
        
        if (recvDiamond > [LCMyUser mine].liveRecDiamond) {
            [LCMyUser mine].liveRecDiamond = recvDiamond;
        }
        
        if ([socketData[@"gift_type"] intValue] == GIFT_TYPE_CONTINUE) {// 连续
//            if (isShowGiftAnim) {
                if (self.allShowGiftView) {
                    [self.allShowGiftView showGiftView:socketData];
                }
                [self addMessage:@"gift" andUserInfo:socketData];
//            }
        } else if ([socketData[@"gift_type"] intValue] == GIFT_TYPE_REDPACKET) {// 红包
            
//            if (self.contentTextField) {
//                [self.contentTextField resignFirstResponder];
//            }
            [RedPacketManager redPacketManager].redPacketDict = socketData;
            [self addMessage:@"gift" andUserInfo:socketData];
        } else if ([socketData[@"gift_type"] intValue] == GIFT_TYPE_LUXURY) {//豪华礼物
            [LuxuryManager luxuryManager].luxuryDict = socketData;
            [self addMessage:@"gift" andUserInfo:socketData];
        }
    } else if ([msgType isEqualToString:LIVE_GROUP_BARRAGE]) {
        if (!self.barrageView.barrageInfoArray)
        {
            self.barrageView.barrageInfoArray = [NSMutableArray array];
        }
        
        [self.barrageView.barrageInfoArray addObject:socketData];
        
        [self.barrageView showBarrageAnimation];
    } else if ([msgType isEqualToString:LIVE_GROUP_SHARE]) {// 分享消息
        [self addMessage:nil andUserInfo:socketData];
    } else if ([msgType isEqualToString:LIVE_GROUP_GAG]) {// 禁言消息
        if ([socketData[@"uid"] isEqualToString:[LCMyUser mine].userID]) {
            [LCMyUser mine].isGag = YES;
        }
        [self addMessage:nil andUserInfo:socketData];
    } else if ([msgType isEqualToString:LIVE_GROUP_REMOVE_GAG]) {// 解除禁言消息
        // 逻辑处理
        if ([socketData[@"uid"] isEqualToString:[LCMyUser mine].userID]) {
            [LCMyUser mine].isGag = NO;
        }
        [self addMessage:nil andUserInfo:socketData];
    } else if ([msgType isEqualToString:LIVE_GROUP_MANAGER]) {// 设置为管理员
        if ([socketData[@"uid"] isEqualToString:[LCMyUser mine].userID]) {
            [LCMyUser mine].isManager = YES;
        }
        
        [self addMessage:nil andUserInfo:socketData];
    } else if ([msgType isEqualToString:LIVE_GROUP_REMOVE_MANAGER]){// 移除管理员
        if ([socketData[@"uid"] isEqualToString:[LCMyUser mine].userID]) {
            [LCMyUser mine].isManager = NO;
            [self addMessage:nil andUserInfo:socketData];
        }
    } else if ([msgType isEqualToString:LIVE_GROUP_ATTENT]) {// 添加关注
        [self addMessage:nil andUserInfo:socketData];
    } else if ([msgType isEqualToString:LIVE_GROUP_UPGRADE]) {// 升级
        [self addMessage:nil andUserInfo:socketData];
    } else if ([msgType isEqualToString:LIVE_GROUP_SYSTEM_MSG]){// 系统消息
        [self addMessage:nil andUserInfo:socketData];
        if ([socketData isKindOfClass:[NSDictionary class]]) {
            NSString* string = [socketData objectForKey:@"type"];
            if ([string isKindOfClass:[NSString class]] && [string isEqualToString:LIVE_GROUP_LIVE_BAN]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Live_Ban object:nil];
            }
        }
    } else if ([msgType isEqualToString:LIVE_GROUP_ROOM_NOTIFICATION]
               || [msgType isEqualToString:LIVE_GROUP_ROOM_ANCHOR_LEAVE]
               || [msgType isEqualToString:LIVE_GROUP_ROOM_ANCHOR_RESTORE]) {// 房间消息
        [self addMessage:nil andUserInfo:socketData];
    }
    
}


@end
