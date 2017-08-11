//
//  LiveChatListViewController.m
//  qianchuo
//
//  Created by 林伟池 on 16/7/5.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "LiveChatListViewController.h"
#import "UIImage+QCAdditions.h"
#import "LiveChatDetailViewController.h"
#import "UserSpaceViewController.h"
#import "WatchCutLiveViewController.h"

typedef NS_ENUM(NSInteger, ChatConversationsListType) {
    /// 已关注
    ChatConversationsListTypeFriends = 0,
    /// 未关注
    ChatConversationsListTypeStrangers
};

@interface LiveChatListViewController ()
@property (nonatomic) ChatConversationsListType currentType;
@property (nonatomic) UISegmentedControl *navigationSegmentedControl;
@end

@implementation LiveChatListViewController

- (void)dealloc
{
    NSLog(@"dealloc %@",NSStringFromClass(self.class));
}

- (instancetype)init
{
    return [self initWithDisplayConversationTypes:nil collectionConversationType:nil];
}

- (id)initWithDisplayConversationTypes:(NSArray *)displayConversationTypeArray collectionConversationType:(NSArray *)collectionConversationTypeArray
{
    self = [super initWithDisplayConversationTypes:@[@(ConversationType_PRIVATE), @(ConversationType_SYSTEM)] collectionConversationType:nil];
    self.hidesBottomBarWhenPushed = YES;
    self.contentSizeInPopup = CGSizeMake([ESApp keyWindow].rootViewController.view.width, [ESApp keyWindow].rootViewController.view.height/2);
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.conversationListTableView.frame = CGRectMake(0, self.navigationController.view.height / 3, self.navigationController.view.width, self.navigationController.view.height / 3 * 2);
    [self _setupUI];

    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LCMyUserAttentUsersDidUpdateNotificationHandler:) name:LCMyUserAttentUsersDidUpdateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IMBridgeCountOfTotalUnreadMessagesDidChangeNotificationHandler:) name:IMBridgeCountOfTotalUnreadMessagesDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    self.conversationListTableView.frame = CGRectMake(0, ScreenHeight / 3 + 44, ScreenWidth, ScreenHeight / 3 * 2 - 44);
    self.conversationListTableView.contentOffset = CGPointMake(0, 0);
    self.emptyConversationView.frame = self.conversationListTableView.frame;
    if ([LCMyUser mine].roomInfoDict) {// 换房间
        ESWeakSelf;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ESStrongSelf;
            [_self changeRoomVC:[LCMyUser mine].roomInfoDict];
            
            [LCMyUser mine].roomInfoDict = nil;
        });
        
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - 换房间
- (void) changeRoomVC:(NSDictionary *)userInfoDict
{
    //    NSMutableArray *array = [NSMutableArray array];
    //    [array addObject:userInfoDict];
    //
    //    WatchCutLiveViewController *watchLiveViewController = [[WatchCutLiveViewController alloc ] init];
    //
    //    [LCMyUser mine].liveUserId = userInfoDict[@"uid"];
    //    [LCMyUser mine].liveUserName = userInfoDict[@"nickname"];
    //    [LCMyUser mine].liveUserLogo = userInfoDict[@"face"];
    //    [LCMyUser mine].liveTime = @"0";
    //    [LCMyUser mine].liveType = LIVE_WATCH;
    //    [LCMyUser mine].liveUserGrade = [userInfoDict[@"grade"] intValue];
    //    watchLiveViewController.playerUrl = userInfoDict[@"url"];
    //    watchLiveViewController.liveArray = array;
    //    watchLiveViewController.pos = 0;
    //    [self.navigationController pushViewController:watchLiveViewController animated:YES];
    [WatchCutLiveViewController ShowWatchLiveViewController:self.navigationController withInfoDict:userInfoDict withArray:nil withPos:0];
}


- (STPopupController *)preferredPopupController
{
    STPopupController *popupController = [super preferredPopupController];
    popupController.style = STPopupStyleBottomSheet;
    popupController.tapBackgroundViewToDismiss = YES;
    popupController.backgroundView.backgroundColor = [UIColor clearColor];
    return popupController;
}

- (void)_setupUI
{
    // Navigation bar
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[ESLocalizedString(@" 好友 "), ESLocalizedString(@" 未关注 ")]];
    UIColor *normalColor = [UIColor blackColor];
    //    UIColor *selectedColor = [[UINavigationBar appearance].barTintColor es_darkenColorWithValue:0.3];
    UIColor *selectedColor = [UIColor blackColor];
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,
                                                                             self.navigationController.view.height / 3,
                                                                             ScreenWidth,
                                                                             44)];
    
    [self.view addSubview:bar];
    CGFloat height = bar.height;
    [segmentedControl setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.],
                                               NSForegroundColorAttributeName: normalColor} forState:UIControlStateNormal];
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: selectedColor} forState:UIControlStateSelected];
    UIImage *bgImage = [UIImage imageWithColor:[UIColor clearColor] andSize:CGSizeMake(1, height)];
    UIImage *selectedBgImage = [bgImage imageByAddingBottomBorderWithColor:selectedColor lineWidth:2];
    [segmentedControl setBackgroundImage:bgImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [segmentedControl setBackgroundImage:selectedBgImage forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [segmentedControl setBackgroundImage:selectedBgImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [segmentedControl setBackgroundImage:selectedBgImage forState:UIControlStateSelected|UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [segmentedControl setDividerImage:[UIImage imageWithColor:[UIColor clearColor] andSize:CGSizeMake(1, height)] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [segmentedControl addTarget:self action:@selector(segmentedControlHander:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl sendActionsForControlEvents:UIControlEventValueChanged];
    UINavigationItem* item = [[UINavigationItem alloc] init];
    item.titleView = segmentedControl;
    [bar pushNavigationItem:item animated:NO];
    self.navigationSegmentedControl = segmentedControl;
    
    bar.topItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:ESLocalizedString(@"忽略未读") style:UIBarButtonItemStylePlain target:self action:@selector(ignoreAllUnreadMessage:)];
    [bar.topItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
    bar.topItem.leftBarButtonItem = self.lyLeftBarButtonItem;
    
    // TableView
    self.conversationListTableView.tableFooterView = [UIView new];
    self.conversationListTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    // Error View
    UIImage *errorIcon = [IFFontAwesome imageWithType:IFFACommentingO color:[UIColor lightGrayColor] fontSize:80];
    ESErrorView *errorView = [[ESErrorView alloc] initWithFrame:CGRectMake(0, self.navigationController.view.height / 3 + bar.height, self.navigationController.view.width, self.navigationController.view.height / 3 * 2 - bar.height) title:ESLocalizedString(@"找个人聊聊吧") subtitle:nil image:errorIcon];
    errorView.backgroundColor = self.conversationListTableView.backgroundColor;
    if ([errorView.backgroundColor es_isLightColor]) {
        errorView.titleLabel.textColor = [UIColor colorWithRed:0.376 green:0.404 blue:0.435 alpha:1.000];
    } else {
        errorView.titleLabel.textColor = [UIColor es_lightBorderColor];
    }
    self.emptyConversationView = errorView;
}

- (void)segmentedControlHander:(UISegmentedControl *)control
{
    ChatConversationsListType listType = self.currentType;
    if (control.selectedSegmentIndex == 0) {
        listType = ChatConversationsListTypeFriends;
    } else {
        listType = ChatConversationsListTypeStrangers;
    }
    if (listType != self.currentType) {
        self.currentType = listType;
        [self refreshConversationTableViewIfNeeded];
    }
}

- (void)refreshConversationTableViewIfNeeded {
    [super refreshConversationTableViewIfNeeded];
    self.conversationListTableView.contentOffset = CGPointMake(0, 0);
    self.conversationListTableView.contentInset = UIEdgeInsetsZero;
}

- (void)updateUnreadCountWithFriendsCount:(int)friendsCount strangersCount:(int)strangersCount
{
    ESWeakSelf;
    ESDispatchOnMainThreadAsynchrony(^{
        ESStrongSelf;
        NSString *friendsText = (friendsCount > 99 ? @"99+" : (friendsCount > 0 ? [NSString stringWithFormat:@"%d", friendsCount] : nil));
        NSString *strangersText = (strangersCount > 99 ? @"99+" : (strangersCount > 0 ? [NSString stringWithFormat:@"%d", strangersCount] : nil));
        [_self.navigationSegmentedControl setBadgeString:friendsText forSegmentIndex:ChatConversationsListTypeFriends badgeConfiguration:nil];
        [_self.navigationSegmentedControl setBadgeString:strangersText forSegmentIndex:ChatConversationsListTypeStrangers badgeConfiguration:nil];
    });
}

- (void)ignoreAllUnreadMessage:(id)sender
{
    ESWeakSelf;
    if ([[RCIMClient sharedRCIMClient] getUnreadCount:self.displayConversationTypeArray] > 0) {
        UIAlertView *alert = [UIAlertView alertViewWithTitle:ESLocalizedString(@"是否忽略所有未读消息？") message:nil cancelButtonTitle:ESLocalizedString(@"取消") didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (alertView.cancelButtonIndex != buttonIndex) {
                ESStrongSelf;
                for (RCConversationModel *model in self.conversationListDataSource) {
                    if ([model unreadMessageCount] > 0) {
                        [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:model.conversationType targetId:model.targetId];
                    }
                }
                [[IMBridge bridge] updateCountOfTotalUnreadMessages];
                [_self refreshConversationTableViewIfNeeded];
            }
        } otherButtonTitles:ESLocalizedString(@"确定"), nil];
        [alert show];
    }
}

- (void)LCMyUserAttentUsersDidUpdateNotificationHandler:(NSNotification *)notification
{
    [self refreshConversationTableViewIfNeeded];
}

- (void)IMBridgeCountOfTotalUnreadMessagesDidChangeNotificationHandler:(NSNotification *)notification
{
    ESWeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ESStrongSelf;
        __block int friendsCount = 0;
        __block int strangersCount = 0;
        NSArray *dataSource = [_self.conversationListDataSource copy];
        [dataSource each:^(RCConversationModel *model, NSUInteger idx, BOOL *stop) {
            if (model.conversationType == ConversationType_SYSTEM || [[LCMyUser mine] isAttentUser:model.targetId]) {
                friendsCount += model.unreadMessageCount;
            } else {
                strangersCount += model.unreadMessageCount;
            }
        } option:NSEnumerationConcurrent];
        [_self updateUnreadCountWithFriendsCount:friendsCount strangersCount:strangersCount];
    });
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - RongCloud Delegate

- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource
{
    ChatConversationsListType currentType = self.currentType;
    __block int friendsCount = 0;
    __block int strangersCount = 0;
    NSIndexSet *willRemove = [dataSource matches:^BOOL (RCConversationModel *model, NSUInteger idx, BOOL *stop) {
        if (model.conversationType == ConversationType_SYSTEM || [[LCMyUser mine] isAttentUser:model.targetId]) {
            friendsCount += model.unreadMessageCount;
            return (ChatConversationsListTypeFriends != currentType);
        } else {
            strangersCount += model.unreadMessageCount;
            return (ChatConversationsListTypeFriends == currentType);
        }
    } option:NSEnumerationConcurrent];
    [dataSource removeObjectsAtIndexes:willRemove];
    [self updateUnreadCountWithFriendsCount:friendsCount strangersCount:strangersCount];
    return dataSource;
}

- (void) didTapCellPortrait:(RCConversationModel *)model
{
    NSString *userId = model.targetId;
    
    ChatUser *chatUser = [ChatUser userWithID:userId];
    
    LiveUser *liveUser = nil;
    if ([userId isEqualToString:[LCMyUser mine].userID]) {
        liveUser = [[LiveUser alloc] initWithPhone:[LCMyUser mine].userID name:[LCMyUser mine].nickname logo:[LCMyUser mine].faceURL];
    } else if (chatUser) {
        liveUser = [[LiveUser alloc] initWithPhone:chatUser.userId name:chatUser.nickname logo:chatUser.avatarUrl];
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
            [_self changeRoomVC:userInfoDict];
        };
    }
    
    ESWeakSelf;
    userController.showUserHomeBlock = ^(NSString *userId){
        ESStrongSelf;
        HomeUserInfoViewController *userInfoVC = [[HomeUserInfoViewController alloc] init];
        userInfoVC.userId = userId;
        if (self.mNavigationController) {
            [_self.mNavigationController pushViewController:userInfoVC animated:YES];
        }
        else {
            [_self.navigationController pushViewController:userInfoVC animated:YES];
        }
    };
    
    [userController popupWithCompletion:nil];
}

- (void)didDeleteConversationCell:(RCConversationModel *)model
{
    ESDispatchOnDefaultQueue(^{
        [[RCIMClient sharedRCIMClient] clearMessages:model.conversationType targetId:model.targetId];
    });
    if (model.unreadMessageCount > 0) {
        [[IMBridge bridge] updateCountOfTotalUnreadMessages];
    }
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    LiveChatDetailViewController *chat = [[LiveChatDetailViewController alloc] initWithConversationModel:model];
    chat.mNavigationController = self.mNavigationController;
    chat.viewFrame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    [self.navigationController pushViewController:chat animated:NO];
}

@end

