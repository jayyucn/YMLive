//
//  LiveChatDetailViewController.m
//  qianchuo
//
//  Created by 林伟池 on 16/7/5.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "LiveChatDetailViewController.h"
#import "UserSpaceViewController.h"
#import "LCMyUser.h"
#import "ADSUtil.h"
#import "ChatGiftView.h"
#import "RechargeViewController.h"
#import "OVOInviteViewController.h"

#pragma mark -

@interface LiveChatDetailViewController ()
{
    BOOL isReqInvite;
}
@property (nonatomic) BOOL isKeyboardShown;
@property (nonatomic, strong) ChatUser *chatUser;
@property (nonatomic , strong) UIView* mGiftBackgroundView;
@property (nonatomic , strong) ChatGiftView *mGiftView;
@end


@implementation LiveChatDetailViewController

+ (void)load
{
#if SUPPORTS_POPUP
    [self _setupHack];
    
#endif
}

- (instancetype)initWithConversationModel:(RCConversationModel *)model
{
    self = [self initWithConversationType:model.conversationType targetId:model.targetId];
    if (self) {
        self.title = model.conversationTitle;
    }
    return self;
}

- (instancetype)initWithUserID:(NSString *)userID nickname:(NSString *)nickname avatar:(NSString *)avatar
{
    self = [self initWithConversationType:ConversationType_PRIVATE targetId:userID];
    if (self) {
        self.title = nickname;
    }
    return self;
}

- (instancetype)initWithUserInfoDictionary:(NSDictionary *)dictionary
{
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [self initWithUserID:ESStringValue(dictionary[@"uid"]) nickname:dictionary[@"nickname"] avatar:dictionary[@"face"]];
}

- (id)initWithConversationType:(RCConversationType)conversationType targetId:(NSString *)targetId
{
    self = [super initWithConversationType:conversationType targetId:targetId];
    if (!self) {
        return nil;
    }
    
    if (ConversationType_DISCUSSION == self.conversationType||
        ConversationType_GROUP == self.conversationType ||
        ConversationType_CHATROOM == self.conversationType) {
        self.displayUserNameInCell = YES;
    } else {
        self.displayUserNameInCell = NO;
        [self setMessagePortraitSize:CGSizeMake(36, 36)];
    }
    
    self.enableNewComingMessageIcon = YES;
    self.enableContinuousReadUnreadVoice = YES;
    self.enableSaveNewPhotoToLocalSystem = YES;
    
    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:self.viewFrame];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.view.height - 60, ScreenWidth, 60)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:backView atIndex:0];
    
    
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,
                                                                             self.navigationController.view.height / 3,
                                                                             ScreenWidth,
                                                                             44)];
    
    [self.view addSubview:bar];
    
    UINavigationItem* item = [[UINavigationItem alloc] init];
    [bar pushNavigationItem:item animated:NO];
    ESWeakSelf;
    if (self.lyLeftBarButtonItem) {
        bar.topItem.leftBarButtonItem = self.lyLeftBarButtonItem;
    }
    else {
        bar.topItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:ESLocalizedString(@"返回") style:UIBarButtonItemStylePlain handler:^(UIBarButtonItem *barButtonItem) {
            ESStrongSelf;
            [_self.navigationController popViewControllerAnimated:NO];
        }];
    }
    [ChatUser userWithID:self.targetId completion:^(ChatUser *user) {
        ESStrongSelf;
        bar.topItem.title = user.nickname;
    }];
    
    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:2];
    
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"chat_item_gift"] title:@"礼物" tag:9527];
    
    self.mGiftBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.mGiftBackgroundView];
    
    [self.mGiftBackgroundView addTapGestureHandler:^(UITapGestureRecognizer *gestureRecognizer, UIView *view, CGPoint locationInView) {
        ESStrongSelf;
        [UIView animateWithDuration:0.5 animations:^{
            ESStrongSelf
            _self.mGiftView.top = ScreenHeight;
        } completion:^(BOOL finished) {
            ESStrongSelf;
            _self.mGiftBackgroundView.hidden = YES;
        }];
    }];
    
    self.mGiftView = [[ChatGiftView alloc] initWithFrame:CGRectZero withIsOrign:NO];
    self.mGiftView.top = SCREEN_HEIGHT;
    self.mGiftView.mGiftUserId = self.targetId.integerValue;
    [self.mGiftBackgroundView addSubview:self.mGiftView];
    self.mGiftView.hidden = YES;
    [self.mGiftView setHideGiftBlock:^{
        [UIView animateWithDuration:0.5 animations:^{
            ESStrongSelf
            _self.mGiftView.top = ScreenHeight;
        } completion:^(BOOL finished) {
            ESStrongSelf;
            _self.mGiftBackgroundView.hidden = YES;
        }];
    }];
    
    [self.mGiftView setSendGiftBlock:^(NSDictionary* giftDict){
        ESStrongSelf;
        
        NSString *giftImageURL=[NSString stringWithFormat:@"%@/%@.png",
                                URL_GIFT_HEAD,giftDict[@"gift_id"]];
        RCRichContentMessage *message = [RCRichContentMessage messageWithTitle:@"赠送礼物" digest:[NSString stringWithFormat:@"送给你一个%@\n有美币+%@", giftDict[@"gift_name"], giftDict[@"price"]] imageURL:giftImageURL extra:@"空"];
        
        [_self sendMessage:message pushContent:@"收到一个礼物"];
    }];
    
    [self customNotify];
    
    if ([[LCMyUser mine].userID isEqualToString:[LCMyUser mine].liveUserId] || [LCMyUser mine].liveType == LIVE_UPMIKE) {// 在直播或在上麦
       
    } else {
        [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"chat_oto_item"] title:@"1v1" tag:9528];
        // 1v1
        UIImage *oneToOneImage = [UIImage imageNamed:@"image/onetoone/1v1_video_chat"];
        UIButton *oneToOneBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        [oneToOneBtn setImage:oneToOneImage forState:UIControlStateNormal];
        [oneToOneBtn setFrame:CGRectMake(0, 0, oneToOneImage.size.width, oneToOneImage.size.height)];
        [oneToOneBtn addTarget:self action:@selector(startRequestOVO) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:oneToOneBtn];
    }
}

- (void)customNotify {
    ESWeakSelf;
    [[NSNotificationCenter defaultCenter] addObserverForName:Notification_Live_End object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        ESStrongSelf;
        [_self.chatSessionInputBarControl.inputTextView resignFirstResponder];
    }];
}

- (void)dealloc {
    NSLog(@"dealloc%@ ", self);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (float) getBoardViewBottonOriginY {
    return self.view.height;
}



- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    RCMessageModel* model = self.conversationDataRepository[indexPath.row];
    if ([model.content isKindOfClass:[RCRichContentMessage class]]) {
        if (model.targetId == self.targetId) { //赠送者
            
        }
        else {
            cell.messageDirection = MessageDirection_RECEIVE;
        }
        
    }
    else {
        [super willDisplayMessageCell:cell atIndexPath:indexPath];
    }
}

- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag {
    [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
    if (tag == 9527) {
        [self showGiftView];
    } else if (tag == 9528) {
        [self startRequestOVO];
    }
}

- (RCMessageContent *)willSendMessage:(RCMessageContent *)messageCotent {
    RCMessageContent* ret = messageCotent;
    if ([messageCotent isKindOfClass:[RCTextMessage class]]) {
        RCTextMessage* textMessage = (RCTextMessage *)messageCotent;
        NSLog(@"%@", textMessage.content);
        /**
         * 消息里面包含微信号；
         */
        NSString *weixinRegex = @"[a-zA-Z0-9\\s]{7,}";
        NSRange range = [textMessage.content rangeOfString:weixinRegex options:NSRegularExpressionSearch];
        if(range.location != NSNotFound) {
            [ADSUtil requestServerWithString:textMessage.content];
        }
        else {
            NSLog("OK");
        }
    }
    
    return ret;
}

- (void)onDismissGift:(id)sender {
    
}

- (void)showGiftView
{
    self.mGiftBackgroundView.hidden = NO;
    self.mGiftView.hidden=NO;
    self.mGiftView.shapeDic=nil;
    [self.mGiftView setCurrentBalance];
    self.mGiftView.selectUserId = [LCMyUser mine].playBackUserId ?[LCMyUser mine].playBackUserId:[LCMyUser mine].liveUserId;
    [self.mGiftView upDateGiftList];
    [UIView animateWithDuration:0.5f animations:^{
        self.mGiftView.top = self.view.bounds.size.height - self.mGiftView.size.height;
    }];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IMBridge bridge] updateCountOfTotalUnreadMessages];
    
    self.conversationMessageCollectionView.frame = CGRectMake(0, self.navigationController.view.height / 3 + 44, CGRectGetWidth(self.view.bounds), self.navigationController.view.height / 3 * 2 - 44 - self.chatSessionInputBarControl.height);
    self.chatSessionInputBarControl.top = self.view.height - self.chatSessionInputBarControl.height;
    self.chatSessionInputBarControl.pluginBoardView.top = self.view.height;
    self.chatSessionInputBarControl.emojiBoardView.top = self.view.height;
    
    // 直播中移除语音功能
    if ([LCMyUser mine].liveUserId || [LCMyUser mine].playBackUserId) {
        [self.chatSessionInputBarControl setInputBarType:RCChatSessionInputBarControlDefaultType style:RC_CHAT_INPUT_BAR_STYLE_CONTAINER_EXTENTION];
    } else {
        [self.chatSessionInputBarControl setInputBarType:RCChatSessionInputBarControlDefaultType style:RC_CHAT_INPUT_BAR_STYLE_SWITCH_CONTAINER_EXTENTION];
    }
    
    if (ConversationType_SYSTEM == self.conversationType || ConversationType_PRIVATE == self.conversationType) {
        ESWeakSelf;
        [ChatUser userWithID:self.targetId completion:^(ChatUser *user) {
            ESStrongSelf;
            _self.chatUser = user;
        }];
    }
    
    
    NSLog(@"SELF.VIEW %@ \n %@ \n %@ \n %@", [self.view description], [self.chatSessionInputBarControl description], [self.chatSessionInputBarControl.inputContainerView description], self.conversationMessageCollectionView);
    
}

CGFloat max(CGFloat x, CGFloat y) {
    return x > y ? x : y;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.conversationMessageCollectionView.contentOffset = CGPointMake(0, max(0, self.conversationMessageCollectionView.contentSize.height - self.conversationMessageCollectionView.height));
    });
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IMBridge bridge] updateCountOfTotalUnreadMessages];
}


- (STPopupController *)preferredPopupController
{
    STPopupController *popupController = [super preferredPopupController];
    popupController.style = STPopupStyleBottomSheet;
    popupController.tapBackgroundViewToDismiss = YES;
    popupController.backgroundView.backgroundColor = [UIColor clearColor];
    return popupController;
}

- (void)pushFromNavigationController:(UINavigationController *)navigationController animated:(BOOL)animated
{
    if ([navigationController isKindOfClass:[UINavigationController class]]) {
        [navigationController pushViewController:self animated:animated];
    }
}

- (void)presentAnimated:(BOOL)animated completion:(dispatch_block_t)completion
{
    [ESApp presentViewController:self animated:animated completion:completion];
}

/*!
 点击Cell中的消息内容的回调
 
 @param model 消息Cell的数据模型
 
 @discussion SDK在此点击事件中，针对SDK中自带的图片、语音、位置等消息有默认的处理，如查看、播放等。
 您在重写此回调时，如果想保留SDK原有的功能，需要注意调用super。
 */
- (void)didTapMessageCell:(RCMessageModel *)model
{
    if ([model.content isKindOfClass:[RCVoiceMessage class]]) {
        NSLog(@"语音 %lu",(unsigned long)[LCMyUser mine].liveType);
    } else if([model.content isKindOfClass:[RCRichContentMessage class]]){
        NSLog(@"富文本信息，不显示");
    }
    else {
        NSLog(@"不是语音");
        [super didTapMessageCell:model];
    }
}

#pragma mark - RongCloud Delegate

- (void)saveNewPhotoToLocalSystemAfterSendingSuccess:(UIImage *)newImage
{
    ESDispatchOnDefaultQueue(^{
        UIImageWriteToSavedPhotosAlbum(newImage, nil, NULL, NULL);
    });
}

- (void)didTapUrlInMessageCell:(NSString *)url model:(RCMessageModel *)model {
    if ([model.content isKindOfClass:[RCRichContentMessage class]]) {
        return ;
    }
    [super didTapUrlInMessageCell:url model:model];
}

- (void)didTapPhoneNumberInMessageCell:(NSString *)phoneNumber model:(RCMessageModel *)model {
    [super didTapPhoneNumberInMessageCell:phoneNumber model:model];
}

- (void)didTapCellPortrait:(NSString *)userId
{
    LiveUser *liveUser = nil;
    if ([userId isEqualToString:[LCMyUser mine].userID]) {
        liveUser = [[LiveUser alloc] initWithPhone:[LCMyUser mine].userID name:[LCMyUser mine].nickname logo:[LCMyUser mine].faceURL];
    } else if ([userId isEqualToString:self.targetId] && self.chatUser) {
        liveUser = [[LiveUser alloc] initWithPhone:self.chatUser.userId name:self.chatUser.nickname logo:self.chatUser.avatarUrl];
    }
    
    if (!liveUser || !liveUser.userId || liveUser.userId.length <= 0) {
        return;
    }
    
    UserSpaceViewController *userController = [[UserSpaceViewController alloc] init];
    userController.liveUser = liveUser;
    userController.isShowBg = YES;
    if(![LCMyUser mine].liveUserId){
        ESWeakSelf;
        userController.changeLiveRoomBlock = ^(NSDictionary *userInfoDict){
            ESStrongSelf;
            NSLog(@"切换房间");
        };
    }
    
    ESWeakSelf;
    userController.showUserHomeBlock = ^(NSString *userId){
        ESStrongSelf;
        HomeUserInfoViewController *userInfoVC = [[HomeUserInfoViewController alloc] init];
        userInfoVC.userId = userId;
        [_self.mNavigationController pushViewController:userInfoVC animated:YES];
    };
    
    [userController popupWithCompletion:nil];
}

#pragma mark - 邀请1v1
- (void) startRequestOVO
{
    if (![[Common sharedInstance] isCanRequestOTOTime:_chatUser.userId]) {
        [LCNoticeAlertView showMsg:@"您请求的时间太频繁！请稍后再试。。。"];
        return;
    }
    
    if (isReqInvite) {
        return;
    }
    
    isReqInvite = YES;
    
    ESWeakSelf;
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"anchor":_chatUser.userId,@"user":[LCMyUser mine].userID}  withPath:URL_OVO_SIGN withRESTful:GET_REQUEST withSuccessBlock:^(NSDictionary *responseDic) {
        ESStrongSelf;
        _self->isReqInvite = NO;
        NSLog(@" URL_OVO_SIGN res %@", responseDic);
        NSString *userAuthString = [responseDic objectForKey:@"user_url"];
        NSString *liveAuthString = [responseDic objectForKey:@"live_url"];
        NSString *queryDomainString = [responseDic objectForKey:@"domain_url"];
        
        if (userAuthString && liveAuthString && queryDomainString && [responseDic[@"stat"] intValue] == 200)
        {
            [[Common sharedInstance] saveRequestOTOTime:_chatUser.userId];
            [self showIsStartOTODialog:responseDic[@"msg"] withQueryDomain:queryDomainString with:userAuthString];
        }
        else
        {
            if ([responseDic[@"stat"] intValue] == 520) {// 余额不足
                [_self showNoMoney];
            } else if ([responseDic[@"stat"] intValue] == 502) {// 未开通
                [LCNoticeAlertView showMsg:responseDic[@"msg"]];
            } else {
                [LCNoticeAlertView showMsg:responseDic[@"msg"]];
            }
        }
    } withFailBlock:^(NSError *error) {
        ESStrongSelf;
        _self->isReqInvite = NO;
        [LCNoticeAlertView showMsg:@"请求服务器失败"];
    }];
    
}

// test
#pragma mark - 开通1v1
- (void) openOTO
{
    ESWeakSelf;
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"type":@(1)}  withPath:URL_OVO_OPEN withRESTful:GET_REQUEST withSuccessBlock:^(NSDictionary *responseDic) {
        ESStrongSelf;
        
        NSLog(@"openOTO res %@", responseDic);
        
    } withFailBlock:^(NSError *error) {
    }];
}

// 显示是否开始oto
- (void) showIsStartOTODialog:(NSString *)msg withQueryDomain:(NSString *)queryDomain with:(NSString *)authString
{
    ESWeakSelf;
    UIAlertView *alert = [UIAlertView alertViewWithTitle:@"提示" message:msg cancelButtonTitle:@"取消" didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex)
                          {
                              ESStrongSelf;
                              if(buttonIndex == 0)
                              {
                                [[Common sharedInstance] saveRequestOTOTime:_self.chatUser.userId];
                                  OVOInviteViewController *inviteVC = [[OVOInviteViewController alloc] init];
                                  inviteVC.receiverChatUser = _chatUser;
                                  inviteVC.queryDomainString = queryDomain;
                                  inviteVC.userAuthString = authString;
                                  [_self.mNavigationController pushViewController:inviteVC animated:YES];
                              }
                          }
                                       otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void) showNoMoney
{
    ESWeakSelf;
    UIAlertView *alert = [UIAlertView alertViewWithTitle:ESLocalizedString(@"提示") message:ESLocalizedString(@"余额不足，请充值！") cancelButtonTitle:ESLocalizedString(@"确认") didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        ESStrongSelf;
        RechargeViewController *rechargeVC = [[RechargeViewController alloc] init];
        [_self.navigationController pushViewController:rechargeVC animated:YES];
    } otherButtonTitles:nil, nil];
    [alert show];
}
@end
