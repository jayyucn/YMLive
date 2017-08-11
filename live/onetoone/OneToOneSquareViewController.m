//
//  OneToOneSquareViewController.m
//  qianchuo
//
//  Created by jacklong on 16/10/31.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//


#import "OneToOneSquareViewController.h"
#import "SearchViewController.h"
#import "LocationManager.h"
#import "NearbyUserCell.h"
#import "NearbyUserModel.h"
#import "HomeUserInfoViewController.h"


@interface OneToOneSquareViewController ()<UIScrollViewDelegate>
{
    // 新消息数数量
    ESBadgeView     *_badgeView;
    
    NearbyUserModel *userModel;
    NearbyUserCell  *detailCell;
    
    int curPage;
    NSMutableArray  *userArray;
}

@end


@implementation OneToOneSquareViewController

- (id)initWithStyle:(UITableViewStyle)style hasRefreshControl:(BOOL)hasRefreshControl
{
    self = [super initWithStyle:style hasRefreshControl:hasRefreshControl];
    if (self)
    {
        self.hidesBottomBarWhenPushed = NO;
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
    
    [self setHidesBottomBarWhenPushed:NO];
    
    // 注意与tabBar视图的声明保持一致
    self.title = @"附近";
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    
    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    //textAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    [self.navigationController.navigationBar setTitleTextAttributes:textAttrs];
    
    [self refreshData];
    
    self.tableView.height -= 30;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    // 添加新消息监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyUpdateUnreadMessageCount:) name:IMBridgeCountOfTotalUnreadMessagesDidChangeNotification object:nil];
    
    // 搜索
    UIImage *searchImage = [UIImage imageNamed:@"image/liveroom/search_"];
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:searchImage forState:UIControlStateNormal];
    [searchBtn sizeToFit];
    [searchBtn setFrame:CGRectMake(0, 0, 20, 20)];
    [searchBtn addTarget:self action:@selector(showSearchAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    
    UIView *lefView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftAction)];
    // 单击
    singleRecognizer.numberOfTapsRequired = 1;
    [lefView addGestureRecognizer:singleRecognizer];
    
    // 消息
    UIImage *msgImage = [UIImage imageNamed:@"image/liveroom/live_sixin_icon"];
    UIButton *_msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_msgBtn setImage:msgImage forState:UIControlStateNormal];
    [_msgBtn setFrame:CGRectMake(0, 0, 20, 20)];
    _msgBtn.centerY = lefView.height/2;
    [_msgBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [lefView addSubview:_msgBtn];
    
    _badgeView = [ESBadgeView badgeViewWithText:@"0"];
    _badgeView.size = CGSizeMake(20, 20);
    _badgeView.top = 0;
    _badgeView.font = [UIFont systemFontOfSize:8];
    _badgeView.left = _msgBtn.right - _badgeView.width/2;
    _badgeView.hidden = YES;
    [lefView addSubview:_badgeView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:lefView];
}

#pragma mark - Subclass
- (void)refreshData
{
    if (!self.isRefreshing)
    {
        self.hasMore = YES;
        self.isRefreshing = YES;
        
        curPage = 1;
        [self getNearbyUsers:1];
    }
}

- (void)loadMoreData
{
    NSLog(@"JoyYou-YMLive :: loadMoreData with curPage == %d", curPage);
    
    if (curPage >= 1)
    {
        [self getNearbyUsers:(curPage + 1)];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // return [self.list count];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    // return [self.list[section] count];
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    
    detailCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!detailCell)
    {
        detailCell = [[[NSBundle mainBundle] loadNibNamed:@"NearbyUserCell" owner:self options:nil] lastObject];
        
        // 取消选择模式
        // detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    userModel = self.list[indexPath.row];
    
    if (detailCell)
    {
        NSUInteger row = [indexPath row];
        NSLog(@"JoyYou-YMLive :: index path row == %ld", row);
        
        detailCell.nameLabel.text = userModel.nickname;
        
        detailCell.disLabel.text = [NSString stringWithFormat:@"%@km", userModel.distance];
        
        detailCell.loginLabel.text = userModel.last_login_time;
        
        [detailCell.iconImage sd_setImageWithURL:[NSURL URLWithString:userModel.face] placeholderImage:[UIImage imageNamed:@"image/globle/man"]];
    }
    
    return detailCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    userModel = self.list[indexPath.row];
    
    HomeUserInfoViewController *userInfoVC = [[HomeUserInfoViewController alloc] init];
    userInfoVC.userId = userModel.uid;
    [self.navigationController pushViewController:userInfoVC animated:YES];
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.f;
}

#pragma  mark - 更新未读取消息
- (void)notifyUpdateUnreadMessageCount:(NSNotification *)notification
{
    // 获取传递对象
    int unreadCount = [[notification object] intValue];
    [self updateUnReadCount:unreadCount];
}

- (void)updateUnReadCount:(int)unReadCount
{
    ESWeakSelf;
    
    ESDispatchOnMainThreadAsynchrony(^{
        ESStrongSelf;
        
        if (unReadCount > 0)
        {
            if (unReadCount >= 100) {
                _self->_badgeView.text = @"99+";
            } else {
                _self->_badgeView.text = [NSString stringWithFormat:@"%d", unReadCount];
            }
            _self->_badgeView.hidden = NO;
        } else {
            _self->_badgeView.hidden = YES;
        }
    });
}

#pragma mark - chat
- (void)leftAction
{
    [self.navigationController pushViewController:[[ChatConversationsListViewController alloc] init] animated:YES];
}

// 显示搜索页面
- (void)showSearchAction
{
    SearchViewController *searchVC = [[SearchViewController alloc] initWithStyle:UITableViewStylePlain hasRefreshControl:NO];
    [self.navigationController pushViewController:searchVC animated:YES];
}

// 获取附近的人数据
- (void)getNearbyUsers:(int)page
{
    ESWeakSelf;
    
    LCRequestSuccessResponseBlock successBlock = ^(NSDictionary *responseDic)
    {
        ESStrongSelf;
        
        [_self.refreshHeaderView endRefreshing];
        
        int stat = [responseDic[@"stat"] intValue];
        if (200 == stat)
        {
            NSLog(@"JoyYou-YMLive :: get location data succ with response = %@", responseDic);
            
            if(_self.isRefreshing)
            {
                curPage = 1;
                
                if (!userArray)
                {
                    userArray = [NSMutableArray array];
                }
                [userArray removeAllObjects];
                
                NSArray *responseArray = responseDic[@"list"];
                if ([responseArray isKindOfClass:[NSArray class]] && [responseArray count] > 0)
                {
                    _self.noDataNotice.hidden = YES;
                    for (NSDictionary *obj in responseArray)
                    {
                        [userArray addObject:[NearbyUserModel modelWithDictionary:obj]];
                    }
                    
                    if ([responseArray count] < 10)
                    {
                        _self.hasMore = NO;
                    }
                }
                else
                {
                    // 无数据
                    self.noDataNotice.hidden = NO;
                    self.noDataNotice.text = responseDic[@"msg"];
                }
                
                _self.hasMore = YES;
                _self.isRefreshing = NO;
            }
            else
            {
                NSArray *responseArray = responseDic[@"list"];
                if ([responseArray isKindOfClass:[NSArray class]] && [responseArray count] > 0)
                {
                    for (NSDictionary *obj in responseArray)
                    {
                        [userArray addObject:[NearbyUserModel modelWithDictionary:obj]];
                    }
                    _self.hasMore = YES;
                    curPage++;
                    
                    if ([responseArray count] < 10)
                    {
                        _self.hasMore = NO;
                    }
                }
                else
                {
                    // 无数据
                    // [LCNoticeAlertView showMsg:@"没有更多内容"];
                    _self.hasMore = NO;
                }
            }
            
            _self.list = userArray;
            [_self.tableView reloadData];
            
            if ([userArray count] == 0)
            {
                _self.noDataNotice.hidden = NO;
                _self.noDataImageView.hidden = NO;
                _self.noDataNotice.text = responseDic[@"msg"];
            }
            else
            {
                _self.noDataImageView.hidden = YES;
                _self.noDataNotice.hidden = YES;
            }
        }
        else
        {
            NSLog(@"JoyYou-YMLive :: get location data fail with msg = %@", responseDic[@"msg"]);
            
            _self.isRefreshing = NO;
            _self.isLoadingMore = NO;
            
            if([userArray count] == 0)
            {
                _self.noDataNotice.hidden = NO;
                _self.noDataImageView.hidden = NO;
                _self.noDataNotice.text = responseDic[@"msg"];
            }
            else
            {
                [LCNoticeAlertView showMsg:responseDic[@"msg"]];
            }
        }
        _self.isLoadingMore = NO;
        
        // [MBProgressHUD hideHUDForView:_self.view animated:YES];
    };
    
    LCRequestFailResponseBlock failBlock = ^(NSError *error)
    {
        NSLog(@"JoyYou-YMLive :: get location data fail with error = %@", error);
        
        ESStrongSelf;
        
        _self.isRefreshing = NO;
        [_self.refreshHeaderView endRefreshing];
        _self.isLoadingMore = NO;
        
        // [MBProgressHUD hideHUDForView:_self.view animated:YES];
    };
    
    NSDictionary *parameter = @{@"lng":[NSNumber numberWithFloat:[LCMyUser mine].curlongi], @"lat":[NSNumber numberWithFloat:[LCMyUser mine].curlati], @"page":[NSNumber numberWithInt:page]};
    NSLog(@"JoyYou-YMLive :: longi = %f lati = %f page = %d", [LCMyUser mine].curlongi, [LCMyUser mine].curlati, page);
    
    if (parameter)
    {
        [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameter
                                                      withPath:URL_NEARBY_USER
                                                   withRESTful:GET_REQUEST
                                              withSuccessBlock:successBlock
                                                 withFailBlock:failBlock];
    }
}

#pragma mark - scroll offset
- (void)onScrollViewWillEndDraggingWithVelocity:(CGPoint)point
{
    if (point.y > 0)
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        ESWeakSelf;
        
        [UIView animateWithDuration:0.25 animations:^{
            ESStrongSelf;
            
            CGRect rect = _self.tabBarController.tabBar.bounds;
            [_self.tabBarController.tabBar setFrame:CGRectMake(0, SCREEN_HEIGHT + 20, CGRectGetWidth(rect), CGRectGetHeight(rect))];
        }];
    }
    else if (point.y < 0)
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        ESWeakSelf;
        
        [UIView animateWithDuration:0.25 animations:^{
            ESStrongSelf;
            
            CGRect rect = _self.tabBarController.tabBar.bounds;
            [_self.tabBarController.tabBar setFrame:CGRectMake(0, SCREEN_HEIGHT - CGRectGetHeight(rect), CGRectGetWidth(rect), CGRectGetHeight(rect))];
        }];
    }
}

@end
