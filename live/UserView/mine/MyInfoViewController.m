//
//  用户个人信息界面
//  MyInfoViewController.m
//  XCLive
//
//  Created by jacklong on 16/1/13.
//  Copyright © 2016年 www.yuanphone.com. All rights reserved.
//


#import "MyInfoViewController.h"
#import "XCHeadDetailView.h"
#import "DiscoverCell.h"
#import "UserStateSegView.h"
#import "EMMallSectionView.h"
#import "LCSetViewController.h"
#import "LCMyAttentViewController.h"
#import "XLMyFansViewController.h"
#import "SearchViewController.h"
#import "MyEarningsViewController.h"
#import "ShowWebViewController.h"
#import "ChatConversationsListViewController.h"
#import "TopsRankControlView.h"
#import "EditUserInfoViewController.h"
#import "MyCallBackListViewController.h"
#import "RechargeViewController.h"
#import "MyAttentCell.h"
#import "MyInfoCell.h"
#import "MyInfoModel.h"
#define ZoomHieght SCREEN_WIDTH

#define REC_DIAMOND_TAG 111111 // 我的收益
#define MY_DIAMOND_TAG 111112  // 我的钻石


@interface MyInfoViewController()
{
    MyAttentCell *segStatecell;
    MyInfoCell *myInfocell;
    DiscoverCell *detailCell;
    ESBadgeView *_badgeView;// 新消息数目
    MyInfoModel *_dataModel;
}

@end


@implementation MyInfoViewController

- (id)init {
    if (self = [super init])
    {
        [self setHidesBottomBarWhenPushed:NO];
    }
    
    return self;
}

- (id)initWithUserId:(NSString *)userID isUser:(BOOL)user
{
    if (self = [super init])
    {
        // if needed
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"用户中心";
    // 设置文字属性
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    
    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    //textAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    [self.navigationController.navigationBar setTitleTextAttributes:textAttrs];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
   [UINavigationBar appearance].backgroundColor = [UIColor redColor];
    
    _dataModel = [[MyInfoModel alloc] init];
    self.view.backgroundColor = ColorBackGround;
    
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
                                                                                       action:@selector(showChatMsgList)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [lefView addGestureRecognizer:singleRecognizer];
    // 消息
    UIImage *msgImage = [UIImage imageNamed:@"image/liveroom/live_sixin_icon"];
    UIButton *_msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_msgBtn setImage:msgImage forState:UIControlStateNormal];
    [_msgBtn setFrame:CGRectMake(0, 0, msgImage.size.width, msgImage.size.height)];
    _msgBtn.centerY = lefView.height/2;
    [_msgBtn addTarget:self action:@selector(showChatMsgList) forControlEvents:UIControlEventTouchUpInside];
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
    
    self.list = [[NSMutableArray alloc] init];
    
    NSArray *array = @[
                     @[@{@"title":ESLocalizedString(@"设置"), @"icon":@"set"}],
                     @[@{@"title":ESLocalizedString(@"我的收益"), @"icon":@"image/liveroom/mypurse_x"},
                       @{@"title":ESLocalizedString(@"我的等级"), @"icon":@"image/liveroom/grade"},
                       @{@"title":ESLocalizedString(@"我的钻石"), @"icon":@"image/liveroom/diamonds"},
                       @{@"title":ESLocalizedString(@"我的直播"), @"icon":@"image/liveroom/direct_seeding"},
                       @{@"title":ESLocalizedString(@"实名认证"), @"icon":@"image/liveroom/real_name_authentication"},
                       @{@"title":ESLocalizedString(@"设置"), @"icon":@"image/liveroom/setting"}]];
    self.list = [NSMutableArray arrayWithArray:array];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    // 设置代理，头文件也要包含 UITableViewDelegate, UITableViewDataSource
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // 设置contentInset属性（上左下右的值）
    //self.tableView.contentInset = UIEdgeInsetsMake(ZoomHieght, 0, 0, 0);
    // 添加_tableView
    [self.view addSubview:self.tableView];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = ColorBackGround;
    self.tableView.height -= TABBAR_HEIGHT;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    _detailHeaderView = [[XCHeadDetailView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ZoomHieght)];
    _detailHeaderView.image = [UIImage imageNamed:@"image/liveroom/user_space_bg"];
    // contentMode = UIViewContentModeScaleAspectFill时，高度改变宽度也随之改变
//    _detailHeaderView.contentMode = UIViewContentModeScaleAspectFill; // 重点（不设置将只会被纵向拉伸）
//    
//    ESWeakSelf;
//    
//    [_detailHeaderView setShowSearchBlock:^() {
//        SearchViewController *searchVC = [[SearchViewController alloc] initWithStyle:UITableViewStylePlain hasRefreshControl:NO];
//        [weak_self.navigationController pushViewController:searchVC animated:YES];
//    }];
//    
   // [self.tableView addSubview:_detailHeaderView];
    
    // 设置autoresizesSubviews让子类自动布局
//    _detailHeaderView.autoresizesSubviews = YES;
//    
//    [_detailHeaderView.msgBtn addTarget:self action:@selector(showChatMsgList) forControlEvents:UIControlEventTouchUpInside];
//    [_detailHeaderView.editUserBtn addTarget:self action:@selector(showEditUserInfo) forControlEvents:UIControlEventTouchUpInside];
//    [_detailHeaderView.rankDetailBtn addTarget:self action:@selector(showRankDetailAction) forControlEvents:UIControlEventTouchUpInside];
//    
//    _detailHeaderView.badgeView.userInteractionEnabled = YES;
//    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showChatMsgList)];
//    singleRecognizer.numberOfTapsRequired = 1; // 单击
//    [_detailHeaderView.badgeView addGestureRecognizer:singleRecognizer];
    
    [self setUserHeadData:[NSArray array]];
    [self getUserInfo];
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateEditUserInfo:) name:NotificationMsg_EditInfo_Success object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyUpdateUnreadMessageCount:) name:IMBridgeCountOfTotalUnreadMessagesDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSendDiamond:) name:LCUserLiveSendDiamondDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMyDiamond:) name:LCUserLiveDiamondDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMyRecvDiamond:) name:LCUserMyRecDiamondDidChangeNotification object:nil];
    
    // [[LCMyUser mine] addObserver:self forKeyPath:@"send_diamond" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:NULL];
    // [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y; // 根据实际选择加不加上NavigationBarHight（44、64或者没有导航条）
    if (y < -ZoomHieght) {
        CGRect frame = _detailHeaderView.frame;
        frame.origin.y = y;
        frame.size.height = -y; // contentMode = UIViewContentModeScaleAspectFill时，高度改变宽度也随之改变
        _detailHeaderView.frame = frame;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    //[self getUserInfo];
    if ([self.navigationController isNavigationBarHidden]) {
        self.navigationController.navigationBarHidden = NO;
    }
    if ([self.tableView indexPathForSelectedRow])
    {
        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    }
    
    int totalUnread = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
    [self updateUnReadCount:totalUnread];
    
    if (segStatecell)
    {
        NSString *attentIds = [[LCMyUser mine].attentUserIdsStr copy];
        if (attentIds && [attentIds rangeOfString:@","].location != NSNotFound)
        {
            NSArray *array = [attentIds splitWith:@","];
            
            if (array.count >= 2)
            {
                [LCMyUser mine].atten_total = (int)(array.count - 2);
            } else {
                [LCMyUser mine].atten_total = 0;
            }
        } else {
            [LCMyUser mine].atten_total = 0;
        }
        [segStatecell setInfo:[NSString stringWithFormat:@"%d",  [LCMyUser mine].atten_total] setAttentBootom:[NSString stringWithFormat:@"%@", ESLocalizedString(@"我的关注")] setFanstop:[NSString stringWithFormat:@"%d", [LCMyUser mine].fans_total]setFansBottom:[NSString stringWithFormat:@"%@", ESLocalizedString(@"我的粉丝")]];
        
    }
}

// 显示搜索页面
- (void) showSearchAction
{
    SearchViewController *searchVC = [[SearchViewController alloc] initWithStyle:UITableViewStylePlain hasRefreshControl:NO];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)segmentView:(NSInteger)index
{
    NSLog(@"index: %ld", (long)index);
    if (index == 1)
    {
        LCMyAttentViewController *attentController=[[LCMyAttentViewController alloc] initWithStyle:UITableViewStylePlain hasRefreshControl:YES];
        [self.navigationController pushViewController:attentController animated:YES];
    }
    else if (index == 0)
    {
        XLMyFansViewController *fansController = [[XLMyFansViewController alloc] initWithStyle:UITableViewStylePlain hasRefreshControl:YES];
        [self.navigationController pushViewController:fansController animated:YES];
    }
}


#pragma mark - table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.list count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([LCCore globalCore].isAppStoreReviewing && section == 1) {
        // AppStore审核期间去掉收益显示
        return [(NSArray *)self.list[section] count] - 1;
    }
    if(section == 0) return 2;
    return [(NSArray *)self.list[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if(indexPath.row==1) {
            static NSString *identifier = @"segviewcell";
            segStatecell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!segStatecell)                                                         
            {
                segStatecell  = [[[NSBundle mainBundle] loadNibNamed:@"MyAttentCell" owner:self options:nil] lastObject];
                [segStatecell setInfo:[NSString stringWithFormat:@"%d",  [LCMyUser mine].atten_total] setAttentBootom:[NSString stringWithFormat:@"%@", ESLocalizedString(@"我的关注")] setFanstop:[NSString stringWithFormat:@"%d", [LCMyUser mine].fans_total]setFansBottom:[NSString stringWithFormat:@"%@", ESLocalizedString(@"我的粉丝")]];
                segStatecell.delegate = self;
                //segStatecell.isMySpaceUser = NO;
                
//                segStatecell.items = [NSArray arrayWithObjects:
//                              [NSString stringWithFormat:@"%@ %d", ESLocalizedString(@"我的关注"), [LCMyUser mine].atten_total],
//                              [NSString stringWithFormat:@"%@ %d", ESLocalizedString(@"我的粉丝"), [LCMyUser mine].fans_total], nil];
//                segStatecell.delegate = self;
                
                
                // 取消选择模式
                segStatecell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [segStatecell setAccessoryType:UITableViewCellAccessoryNone];
            
            return segStatecell;
        }
        else {
            static NSString *identifier = @"MyInfocell";
            myInfocell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!myInfocell)
            {
                myInfocell  = [[[NSBundle mainBundle] loadNibNamed:@"MyInfoCell" owner:self options:nil] lastObject];
//                myInfocell.delegate=self;
                [myInfocell configCellWithModel:_dataModel];
                myInfocell.delegate=self;
                
                // 取消选择模式
                //myInfocell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return myInfocell;
        }
    }
    else
    {
        NSIndexPath *reviewIndexPath = indexPath;
        if ([LCCore globalCore].isAppStoreReviewing && indexPath.section == 1) {
            // AppStore审核期间去掉收益显示
            reviewIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
        }
        static NSString *identifier = @"cell";
        
        detailCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!detailCell)
        {
            detailCell = [[[NSBundle mainBundle] loadNibNamed:@"DiscoverCell" owner:self options:nil] lastObject];
        }
        
        NSDictionary *dic = nil;
        if ([self.list[reviewIndexPath.section][reviewIndexPath.row] isKindOfClass:[NSDictionary class]])
        {
            dic = self.list[reviewIndexPath.section][reviewIndexPath.row];
            detailCell.titleLabel.text = dic[@"title"];
            detailCell.titleLabel.textColor = [UIColor colorWithRed:68.0/255.0 green:68/255.0 blue:68/255.0 alpha:1.0];
            detailCell.iconImage.image = [UIImage imageNamed:dic[@"icon"]];
            
            if (reviewIndexPath.section == 1)
            {
                detailCell.statusLabel.hidden = NO;
                detailCell.statusView.hidden = NO;
                detailCell.statusLabel.textColor = ColorPink;
                
                detailCell.statusLabel.textAlignment = NSTextAlignmentRight;
                detailCell.statusView.backgroundColor = [UIColor whiteColor];
                
                NSString *memo = nil;
                if (reviewIndexPath.row == 0)
                {
                    memo = [NSString stringWithFormat:@"%d", [LCMyUser mine].recv_diamond];
                    detailCell.statusLabel.tag = REC_DIAMOND_TAG;
                }
                else if(reviewIndexPath.row == 1)
                {
                    memo = [NSString stringWithFormat:@"%d", [LCMyUser mine].userLevel];
                    // detailCell.statusLabel.hidden = YES;
                }
                else if (reviewIndexPath.row == 2)
                {
                    memo = [NSString stringWithFormat:@"%d", [LCMyUser mine].diamond];
                    detailCell.statusLabel.tag = MY_DIAMOND_TAG;
                }
                else
                {
                    detailCell.statusLabel.hidden = YES;
                    detailCell.statusView.hidden = YES;
                }
                
                detailCell.statusLabel.text = memo;
                [self changeLabelFrameWith:detailCell string:memo];
            }
            else
            {
                detailCell.statusLabel.hidden = YES;
                detailCell.statusView.hidden = YES;
            }
        }
        
        return detailCell;
    }
}

- (void)changeLabelFrameWith:(DiscoverCell *)cell string:(NSString *)string
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f]} context:nil].size;
    
    if (size.width < 10)
    {
        size.width = 10;
    }
    
    CGRect rect = cell.statusView.frame;
    rect.size.width = size.width + 10;
    rect.origin.x = self.view.width - size.width - ScreenWidth / 8;
    cell.statusView.frame = rect;
    
    cell.statusLabel.frame = CGRectMake(0, 3, rect.size.width, 12);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1)
    {
        NSIndexPath *reviewIndexPath = indexPath;
        if ([LCCore globalCore].isAppStoreReviewing && indexPath.section == 1) {
            // AppStore审核期间去掉收益显示
            reviewIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
        }
        
        if (reviewIndexPath.row == 0)
        {
            // 如果用户没有绑定微信，弹出绑定微信界面
            if (![LCMyUser mine].isBindWX)
            {
                UIStoryboard *wechatBindStroyBoard = [UIStoryboard storyboardWithName:@"WechatBind" bundle:nil];
                UIViewController *wechatBindView = [wechatBindStroyBoard instantiateViewControllerWithIdentifier:@"wechatBind"];
                
                UINavigationController *wechatBindNavigator = [[UINavigationController alloc] initWithRootViewController:wechatBindView];
                [self presentViewController:wechatBindNavigator animated:YES completion:nil];
            }
            else
            {
                // 我的收益storyboard
                UIStoryboard *mineEarningStroyBoard = [UIStoryboard storyboardWithName:@"MineExchange" bundle:nil];
                UIViewController *mineEarningView = [mineEarningStroyBoard instantiateViewControllerWithIdentifier:@"mineEarning"];
                
                UINavigationController *mineEarningNavigator = [[UINavigationController alloc] initWithRootViewController:mineEarningView];
                [self presentViewController:mineEarningNavigator animated:YES completion:nil];
            }
        }
        else if (reviewIndexPath.row == 1)
        {
            ShowWebViewController *showWebVC = [[ShowWebViewController alloc] init];
            showWebVC.hidesBottomBarWhenPushed = YES;
            showWebVC.isShowRightBtn = false;
            showWebVC.webTitleStr = ESLocalizedString(@"我的等级");
            showWebVC.webUrlStr = [NSString stringWithFormat:@"%@profile/mygrade", URL_HEAD];
            [self.navigationController pushViewController:showWebVC animated:YES];
            
            // [CarPorscheFirstView showCar];
            // RecommendedViewController *recommendedVC = [[RecommendedViewController alloc] init];
            // recommendedVC.title = @"我的等级";
            // recommendedVC.htmlStr = @"https://www.baidu.com";
            // recommendedVC.hidesBottomBarWhenPushed = YES;
            // [self.navigationController pushViewController:recommendedVC animated:YES];
        }
        else if (reviewIndexPath.row == 2)
        {
            RechargeViewController *viewController = [[RechargeViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else if (reviewIndexPath.row == 3)
        {
            MyCallBackListViewController *playBackVC = [[MyCallBackListViewController alloc] initWithStyle:UITableViewStylePlain hasRefreshControl:NO];
            [self.navigationController pushViewController:playBackVC animated:YES];
        }
        else if (reviewIndexPath.row == 4)
        {
            ShowWebViewController *showWebVC = [[ShowWebViewController alloc] init];
            showWebVC.hidesBottomBarWhenPushed = YES;
            showWebVC.isShowRightBtn = false;
            showWebVC.webTitleStr = ESLocalizedString(@"认证");
            showWebVC.webUrlStr = [NSString stringWithFormat:@"%@other/certify",URL_HEAD];
            [self.navigationController pushViewController:showWebVC animated:YES];
        }
        else
        {
            LCSetViewController *setController=[[LCSetViewController alloc] initWithStyle:UITableViewStyleGrouped hasRefreshControl:NO];
            [self.navigationController pushViewController:setController animated:YES];
        }
    }
    
}


#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0) {
        if(indexPath.row==0) return 120.f;
        else return 60.f;
    }
    return 45.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    EMMallSectionView *sectionView = [EMMallSectionView showWithName:[NSString stringWithFormat:@"section_title_%ld", (long)section]];
    sectionView.tableView = self.tableView;
    sectionView.section = section;
    
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    
    return [EMMallSectionView getSectionHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    EMMallSectionView *sectionView = [EMMallSectionView showWithName:[NSString stringWithFormat:@"section_title_%ld", (long)section]];
    sectionView.tableView = self.tableView;
    sectionView.section = section;
    
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.list.count - 1) {
        return [EMMallSectionView getSectionHeight];
    }
    
    return 0;
}


#pragma mark - Public Methods

- (void)scrollTableViewToTop:(BOOL)animated
{
    [self.tableView setContentOffset:CGPointZero animated:animated];
}

- (void)setVisibleCellsNeedsDisplay
{
    NSArray *visibleCells = [self.tableView visibleCells];
    if (visibleCells) {
        [visibleCells makeObjectsPerformSelector:@selector(setNeedsDisplay)];
    }
}

- (void)setVisibleCellsNeedsLayout
{
    NSArray *visibleCells = [self.tableView visibleCells];
    if (visibleCells) {
        [visibleCells makeObjectsPerformSelector:@selector(setNeedsLayout)];
    }
}


#pragma mark - head click event

- (void)showChatMsgList
{
    [self.navigationController pushViewController:[[ChatConversationsListViewController alloc] init] animated:YES];
}

- (void)showEditUserInfo
{
    EditUserInfoViewController *editController = [[EditUserInfoViewController alloc] initWithStyle:UITableViewStyleGrouped hasRefreshControl:NO];
    [self.navigationController pushViewController:editController animated:YES];
}

- (void)showRankDetailAction
{
    TopsRankControlView *topsController = [[TopsRankControlView alloc] initWithStyle:UITableViewStylePlain hasRefreshControl:YES];
    [self.navigationController pushViewController:topsController animated:YES];
}


#pragma mark - private userinfo

- (void)getUserInfo
{
    ESWeakSelf;
    
    LCRequestSuccessResponseBlock successBlock = ^(NSDictionary *responseDic) {
        NSLog(@"userinfo responseDic = %@", responseDic);
        
        ESStrongSelf;
        
        int stat = [responseDic[@"stat"] intValue];
        if (stat == 200)
        {
            [[LCMyUser mine] fillWithDictionary:responseDic[@"userinfo"]];
            
            if ([responseDic[@"userinfo"] isKindOfClass:[NSDictionary class]]) {
//                [_self setUserHeadData:responseDic[@"userinfo"][@"tops"]];
                [_dataModel setValuesForKeysWithDictionary:responseDic[@"userinfo"]];
            }
            [_self.tableView reloadData];
            // 获取已经兑换的有美币数量
            [LCMyUser mine].exchange_diamond = [responseDic[@"userinfo"][@"exchange_diamond"] intValue];
            NSLog(@"JoyYou - YMLive :: exchange diamond = %d", [LCMyUser mine].exchange_diamond);
            
            // 读取微信绑定标记
            NSInteger tagOfWX = -1;
            if (responseDic[@"userinfo"][@"wx_bindid"])
            {
                tagOfWX = [responseDic[@"userinfo"][@"wx_bindid"] integerValue];
                NSLog(@"JoyYou-YMLive :: wx bind tag = %ld", tagOfWX);
            }
            if (tagOfWX == 0)
            {
                [LCMyUser mine].isBindWX = YES;
            }
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ESLocalizedString(@"提醒")
                                                            message:responseDic[@"msg"]
                                                           delegate:self
                                                  cancelButtonTitle:ESLocalizedString(@"确定")
                                                  otherButtonTitles:nil];
            alert.delegate = self;
            alert.tag = 3;
            [alert show];
        }
    };
    
    LCRequestFailResponseBlock failBlock = ^(NSError *error) {
        NSLog(@"gag error = %@", error);
    };
    
    NSDictionary *parameters = @{@"u":[LCMyUser mine].userID};
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameters
                                                  withPath:getLiveUserDetailURL()
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}

- (void)setUserHeadData:(NSArray *)tops
{
    if (![LCMyUser mine].userID || ![LCMyUser mine].nickname) {
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[LCMyUser mine].nickname forKey:@"nickname"];
    [dict setObject:[[NSNumber alloc]initWithInt:[LCMyUser mine].sex] forKey:@"sex"];
    [dict setObject:[LCMyUser mine].faceURL forKey:@"face"];
    [dict setObject:[LCMyUser mine].account forKey:@"account"];
    [dict setObject:[[NSNumber alloc] initWithInt:[LCMyUser mine].fans_total] forKey:@"fans_total"];
    [dict setObject:[[NSNumber alloc] initWithInt:[LCMyUser mine].atten_total] forKey:@"atten_total"];
    [dict setObject:[[NSNumber alloc] initWithInt:[LCMyUser mine].send_diamond] forKey:@"send_diamond"];
    [dict setObject:[LCMyUser mine].signature forKey:@"signature"];
    [dict setObject:[LCMyUser mine].userID forKey:@"uid"];
    [dict setObject:[[NSNumber alloc] initWithInt:[LCMyUser mine].userLevel] forKey:@"grade"];
    
    if (tops) {
        [dict setObject:tops forKey:@"tops"];
    }
    [_detailHeaderView showData:dict];
    
    [self.tableView reloadData];
}


#pragma mark - 更新用户信息

- (void)updateEditUserInfo:(NSNotification *)notify
{
    NSString *objName = [notify object];
    if ([objName isEqualToString:@"name"]) {
        [_detailHeaderView modifyNickname];
    } else if ([objName isEqualToString:@"face"]) {
        [_detailHeaderView modifyFace];
    } else if ([objName isEqualToString:@"signature"]) {
        [_detailHeaderView modifySign];
    }
}


#pragma  mark - 更新未读取消息

- (void)notifyUpdateUnreadMessageCount:(NSNotification *)notification
{
    // 获取传递的对象
    int unreadCount = [[notification object] intValue];
    [self updateUnReadCount:unreadCount];
}

- (void)updateUnReadCount:(int)unReadCount
{
    ESWeakSelf;
    
    ESDispatchOnMainThreadAsynchrony(^{
        ESStrongSelf;
        
        if (unReadCount > 0) {
            if (unReadCount >= 100) {
                _self.detailHeaderView.badgeView.text = @"99+";
            } else {
                _self.detailHeaderView.badgeView.text = [NSString stringWithFormat:@"%d", unReadCount];
            }
            _self.detailHeaderView.badgeView.hidden = NO;
        } else {
            _self.detailHeaderView.badgeView.hidden = YES;
        }
    });
}


#pragma mark - 更新送出的钻石数目

- (void)updateSendDiamond:(NSNotification *)notification
{
    if (notification.object != [LCMyUser mine]) {
        return;
    }
    
    [_detailHeaderView showSendDiamond];
}


#pragma mark - 更新我的钻石
- (void)updateMyDiamond:(NSNotification *)notification
{
    if (notification.object != [LCMyUser mine]) {
        return;
    }
    
    NSIndexPath *reviewIndexPath = [NSIndexPath indexPathForRow:2 inSection:1];
    if ([LCCore globalCore].isAppStoreReviewing) {
        // AppStore审核期间去掉收益显示
        reviewIndexPath = [NSIndexPath indexPathForRow:reviewIndexPath.row - 1 inSection:reviewIndexPath.section];
    }
    DiscoverCell *cell = [self.tableView cellForRowAtIndexPath:reviewIndexPath];
    
    if (cell) {
        NSString *detailStr = [NSString stringWithFormat:@"%d", [LCMyUser mine].diamond];
        cell.statusLabel.text = detailStr;
    }
}


#pragma mark - 更新收入

- (void)updateMyRecvDiamond:(NSNotification *)notification
{
    if (notification.object != [LCMyUser mine]) {
        return;
    }
   
    DiscoverCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    if (cell) {
        NSString *detailStr = [NSString stringWithFormat:@"%d", [LCMyUser mine].recv_diamond - [LCMyUser mine].exchange_diamond];
        cell.statusLabel.text = detailStr;
    }
}

@end
