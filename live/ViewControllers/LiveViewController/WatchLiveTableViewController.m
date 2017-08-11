//
//  WatchLiveTableViewController.m
//  live
//
//  Created by kenneth on 15-7-10.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import "WatchLiveTableViewController.h"
#import "Macro.h"
#import "SegmentView.h"
#import "MJBaseTableView.h"
#import "SearchViewController.h"
#import "MyAttentTableView.h"
#import "LiveHotTableView.h"
#import "NewLiveTableView.h"
#import "ReviewLiveTableView.h"
#import "LocationManager.h"
#import "HiddenLiveTableView.h" 
#import "ShowAdView.h"
#import "PushLiveViewController.h"
#import "WatchCutLiveViewController.h"
#import "NearByUserViewController.h"
#import "SetOneToOneMoneyViewController.h"

NS_ENUM(NSInteger, LiveTabIndex)
{
    ELiveTab_Attent,    // 关注
    ELiveTab_Hot,       // 热门
    ELiveTab_New,       // 最新
    ELiveTab_Review,    // 审核
    ELiveTab_Hidden,    // 隐藏
    ELiveTab_Count,
    ELiveTab_Videos,    // 精彩回放
};
@interface WatchLiveTableViewController ()<SegmentViewDelegate, ScrollviewOffsetDelegate, UIScrollViewDelegate>
{
    SegmentView *_segmentView;
    ESBadgeView *_badgeView;// 新消息数目
    
    UIScrollView *_scrollView;
    MyAttentTableView *_liveAttentTableView;
    MJBaseTableView *_liveHotTableView;
    MJBaseTableView *_liveNewTableView;
    MJBaseTableView *_liveReviewTableView;
    MJBaseTableView *_liveHiddenTableView;
//    MJBaseTableView *_videoTableView;
    BOOL            isNeedShowOneToOne;
}
@end

@implementation WatchLiveTableViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _scrollView.delegate = nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [UINavigationBar appearance].tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    
    
    //分段视图
    NSArray* items = [NSArray arrayWithObjects: ESLocalizedString(@"关注"), ESLocalizedString(@"热门"), ESLocalizedString(@"最新"), nil];
    if ([LCMyUser mine].showManager) {
        items = [items arrayByAddingObject:@"审核"];
        items = [items arrayByAddingObject:@"隐藏"];
    }
    
    
    CGRect segmentFrame = CGRectMake(0, 0,[LCMyUser mine].showManager? SCREEN_WIDTH*2/3:SCREEN_WIDTH/2, 44);
    _segmentView = [[SegmentView  alloc] initWithFrame:segmentFrame andItems:items andSize:15 border:NO];
    _segmentView.center = CGPointMake(SCREEN_WIDTH/2, 0);
    _segmentView.delegate = self;
    self.navigationItem.titleView = _segmentView;
    [_segmentView setSelectIndex:1];
    //设置scrollview
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, SCREEN_HEIGHT)];
    _scrollView.backgroundColor = RGB16(COLOR_BG_LIGHTGRAY);
    if ([LCMyUser mine].showManager)
    {
        _scrollView.contentSize = CGSizeMake(ELiveTab_Count * SCREEN_WIDTH, 0);
    }
    else
    {
        _scrollView.contentSize = CGSizeMake((ELiveTab_Count - 2) * ScreenWidth, 0);
    }
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    _scrollView.tag = ALL_SCROLLER_TAG;
    
    _liveAttentTableView = [[MyAttentTableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * ELiveTab_Attent, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _liveAttentTableView.watchViewController = self;
    [_scrollView addSubview:_liveAttentTableView];
    
    ESWeakSelf;
    _liveAttentTableView.lookHotBlock = ^(){
        ESStrongSelf;
        [_self->_segmentView setSelectIndex:1];
        [UIView animateWithDuration:0.2f animations:^{
            _self->_scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        }];
    };
    
    _liveHotTableView = [[LiveHotTableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * ELiveTab_Hot, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _liveHotTableView.watchViewController = self;
    _liveHotTableView.outerScrollView = _scrollView;
    [_scrollView addSubview:_liveHotTableView];
    _liveHotTableView.tag = HOT_TABLEVIEW_TAG;
    
    _liveNewTableView = [[NewLiveTableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * ELiveTab_New, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _liveNewTableView.watchViewController = self;
    [_scrollView addSubview:_liveNewTableView];
    
    _liveAttentTableView.offsetDelegate = _liveHotTableView.offsetDelegate = _liveNewTableView.offsetDelegate = self;
    
    _liveReviewTableView = [[ReviewLiveTableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * ELiveTab_Review, 0, SCREEN_WIDTH, _scrollView.bounds.size.height)];
    _liveReviewTableView.watchViewController = self;
    if ([LCMyUser mine].showManager) {
        [_scrollView addSubview:_liveReviewTableView];
        
        _liveHiddenTableView = [[HiddenLiveTableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * ELiveTab_Hidden, 0, SCREEN_WIDTH, _scrollView.bounds.size.height)];
        _liveHiddenTableView.watchViewController = self;
        
        [_scrollView addSubview:_liveHiddenTableView];
    }
    _liveHiddenTableView.offsetDelegate = _liveReviewTableView.offsetDelegate = self;
    
    [_liveHotTableView beginRefreshing];
    
    _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startUpdateLiveList)
                                                 name:Notification_Start_Update_Live_List
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stopUpdateLiveList)
                                                 name:Notification_Stop_Update_Live_List
                                               object:nil];
    // 添加新消息监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyUpdateUnreadMessageCount:) name:IMBridgeCountOfTotalUnreadMessagesDidChangeNotification object:nil];
    
    // 检索
    UIImage *searchImage = [UIImage imageNamed:@"image/liveroom/search_"];
    UIButton *searchBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:searchImage forState:UIControlStateNormal];
    [searchBtn sizeToFit];
    [searchBtn setFrame:CGRectMake(0, 0, searchImage.size.width, searchImage.size.height)];
    [searchBtn addTarget:self action:@selector(showSearchAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    
    UIView *lefView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(leftAction)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [lefView addGestureRecognizer:singleRecognizer];
    // 消息
    UIImage *msgImage = [UIImage imageNamed:@"image/liveroom/live_sixin_icon"];
    UIButton *_msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_msgBtn setImage:msgImage forState:UIControlStateNormal];
    [_msgBtn setFrame:CGRectMake(0, 0, msgImage.size.width, msgImage.size.height)];
    _msgBtn.centerY = lefView.height/2;
    [_msgBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [lefView addSubview:_msgBtn];
    
    _badgeView = [ESBadgeView badgeViewWithText:@"0"];
    _badgeView.color = [UIColor whiteColor];
    _badgeView.textColor = [UIColor redColor];
    _badgeView.size = CGSizeMake(20, 20);
    _badgeView.top = 0;
    _badgeView.font = [UIFont systemFontOfSize:8];
    _badgeView.left = _msgBtn.right - _badgeView.width/2;
    _badgeView.hidden = YES;
    [lefView addSubview:_badgeView];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:lefView];
    
    [LCMyUser mine].liveType = LIVE_NONE;
    
    // 开始定位
    [LocationManager locationManager];
    
    [self configVCFullScreen];
}

#pragma mark - 询问用户是否开通1对1视频
- (void) showOneToOnePrompt
{
    return ;
    if (![LCMyUser mine].userID || ([LCMyUser mine].userID && [LCMyUser mine].userID.length <= 0)
         || ![LCMyUser mine].nickname || ([LCMyUser mine].nickname && [LCMyUser mine].nickname.length <= 0)) {
        isNeedShowOneToOne = YES;
        return;
    }
    
    BOOL isPrompt = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserOVO_Prompt_KEY] boolValue];
    if (!isPrompt) {
        if ([LCMyUser mine].onetone == 0) {
            ESWeakSelf;
            UIAlertView *alert = [UIAlertView alertViewWithTitle:@"限时免费开通" message:@"开通此功能可以和他人1对1视频聊天，接受他人的视频聊天邀请，您每分钟都会获得有美币的收益。" cancelButtonTitle:@"取消" didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex)
                                  {
                                      ESStrongSelf;
                                      if(buttonIndex == 0)
                                      {
                                          [_self startRequstOpenOneToOne];
                                      }
                                      
                                      [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:kUserOVO_Prompt_KEY];
                                  }
                                               otherButtonTitles:@"确定", nil];
            [alert show];
            
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:kUserOVO_Prompt_KEY];
            [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:kUserOnetoOneAgreeKey];
        }
    }
}

- (void) startRequstOpenOneToOne
{
    ESWeakSelf;
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"type":@(1)}  withPath:URL_OVO_OPEN withRESTful:GET_REQUEST withSuccessBlock:^(NSDictionary *responseDic) {
        ESStrongSelf;
        
        NSLog(@"URL_OVO_OPEN res %@", responseDic);
        
        if ([responseDic[@"stat"] intValue] == 200) {
            [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:kUserOnetoOneAgreeKey];
            SetOneToOneMoneyViewController *setDiamondVC = [[SetOneToOneMoneyViewController alloc] init];
            [_self.navigationController pushViewController:setDiamondVC animated:YES];
        } else {
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
        
    } withFailBlock:^(NSError *error) {
      
        [LCNoticeAlertView showMsg:@"设置失败"];
    }];

}

/// 设置 self.view 全屏
- (void)configVCFullScreen
{
//    self.edgesForExtendedLayout = UIRectEdgeAll;
//    self.extendedLayoutIncludesOpaqueBars = YES;
//    self.modalPresentationCapturesStatusBarAppearance = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController.isNavigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    
    [LCMyUser mine].liveUserId = nil;
    
    self.hidesBottomBarWhenPushed = NO;
    
    int totalUnread = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
    [self updateUnReadCount:totalUnread];
    
    
    [self startUpdateLiveList];
    
    if ([LCMyUser mine].isContinueLive) {
        
        [LCMyUser mine].isContinueLive = NO;
       
        
        PushLiveViewController *_liveController = [[PushLiveViewController alloc] init];
        
        [LCMyUser mine].liveUserId = [LCMyUser mine].userID;
        [LCMyUser mine].liveUserName = [LCMyUser mine].nickname;
        [LCMyUser mine].liveUserLogo = [LCMyUser mine].faceURL;
        [LCMyUser mine].liveUserGrade = [LCMyUser mine].userLevel;
        [LCMyUser mine].livePraiseNum = @"0";
        [LCMyUser mine].liveType = LIVE_DOING;
        UINavigationController * doLiveNav = [[UINavigationController alloc] initWithRootViewController:_liveController];
        doLiveNav.navigationBarHidden = YES;
        doLiveNav.navigationBar.frame =  CGRectMake(0, STATUS_HEIGHT, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT);
        [self presentViewController:doLiveNav animated:YES completion:nil];
       
    } else if ([LCMyUser mine].roomInfoDict) {// 换房间
        ESWeakSelf;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ESStrongSelf;
            [_self changeRoom:[LCMyUser mine].roomInfoDict];
            
            [LCMyUser mine].roomInfoDict = nil;
        });
    }
    
    //[self showOneToOnePrompt];
}

#pragma  mark - 更新未读取消息
- (void) notifyUpdateUnreadMessageCount:(NSNotification *)notification
{
    int unreadCount = [[notification object] intValue];//获取到传递的对象
    [self updateUnReadCount:unreadCount];
}

- (void) updateUnReadCount:(int)unReadCount
{
    ESWeakSelf;
    ESDispatchOnMainThreadAsynchrony(^{
        ESStrongSelf;
        if (unReadCount > 0) {
            if (unReadCount >= 100) {
                _self->_badgeView.text = @"99+";
            } else {
                _self->_badgeView.text = [NSString stringWithFormat:@"%d",unReadCount];
            }
            _self->_badgeView.hidden = NO;
        } else {
            _self->_badgeView.hidden = YES;
        }
    });
}

#pragma mark - nearby user
- (void) leftAction
{
     [self.navigationController pushViewController:[[ChatConversationsListViewController alloc] init] animated:YES];
}


#pragma mark - scroll offset
- (void)onScrollViewWillEndDraggingWithVelocity:(CGPoint)point {
    if (point.y > 0) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        ESWeakSelf;
        [UIView animateWithDuration:0.25 animations:^{
            ESStrongSelf;
            CGRect rect = _self.tabBarController.tabBar.bounds;
            [_self.tabBarController.tabBar setFrame:CGRectMake(0, SCREEN_HEIGHT + 40, CGRectGetWidth(rect), CGRectGetHeight(rect))];
        }];
        
    }
    else if (point.y < 0) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
        ESWeakSelf;
        [UIView animateWithDuration:0.25 animations:^{
            ESStrongSelf;
            CGRect rect = _self.tabBarController.tabBar.bounds;
            [_self.tabBarController.tabBar setFrame:CGRectMake(0, SCREEN_HEIGHT - CGRectGetHeight(rect), CGRectGetWidth(rect), CGRectGetHeight(rect))];
        }];
    }
}

#pragma mark - 换房间
- (void) changeRoom:(NSDictionary *)userInfoDict
{
//    NSMutableArray *array = [NSMutableArray array];
//    [array addObject:userInfoDict];
//    
//    WatchCutLiveViewController *watchLiveViewController = [[WatchCutLiveViewController alloc ] init];
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


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self stopUpdateLiveList];
}

// 显示搜索页面
- (void) showSearchAction
{
    SearchViewController *searchVC = [[SearchViewController alloc] initWithStyle:UITableViewStylePlain hasRefreshControl:NO];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)segmentView:(SegmentView  *)segmentView selectIndex:(NSInteger)index
{
    [UIView animateWithDuration:0.2f animations:^{
        _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width*index, 0);
    }];
    
    [self beganLoadData:index];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scroll
{
    CGPoint offset = _scrollView.contentOffset;
    NSInteger page = (offset.x + _scrollView.frame.size.width/2) / _scrollView.frame.size.width;
    [_segmentView setSelectIndex:page];
    
     [self beganLoadData:page];
}

- (void) beganLoadData:(NSInteger)index
{
    
    if (index == ELiveTab_New) {
        [_liveAttentTableView endRefreshView];
        [_liveHotTableView endRefreshView];
        
        if ([_liveNewTableView dataArrayCount] <= 0) {
            [_liveNewTableView beginRefreshing];
        }
    } else if (index == ELiveTab_Attent) {
        [_liveNewTableView endRefreshView];
        [_liveHotTableView endRefreshView];
        
        if ([_liveAttentTableView dataArrayCount] <= 0) {
            [_liveAttentTableView beginRefreshing];
        }
    } else if (index == ELiveTab_Hot) {
        
        [_liveNewTableView endRefreshView];
        [_liveAttentTableView endRefreshView];
        
        if ([_liveHotTableView dataArrayCount] <= 0) {
            [_liveHotTableView beginRefreshing];
        }
    } else if (index == ELiveTab_Review) {
        if ([_liveReviewTableView dataArrayCount] <= 0) {
            [_liveReviewTableView beginRefreshing];
        }
    }
}

#pragma mark 发布成功代理
- (void)publishTrailerSuccess
{
//    [_trailerTableView beginRefreshing];
}

#pragma mark - 开始定时更新直播列表
- (void) startUpdateLiveList
{
//    [_liveHotTableView startRefreshTimer];
}

#pragma mark - 关闭定时更新直播列表
- (void) stopUpdateLiveList
{
//    [_liveHotTableView stopRefreshTimer]; 
}


@end
