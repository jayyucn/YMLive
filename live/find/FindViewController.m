//
//  FindViewController.m
//  qianchuo
//
//  Created by jacklong on 16/10/31.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//


#import "FindViewController.h"
#import "SearchViewController.h"
#import "DiscoverCell.h"

#import "TopsLiverControlView.h"
#import "TopsSenderControlView.h"
#import "TopsUserControlView.h"


@interface FindViewController ()<UIScrollViewDelegate>
{
    // 新消息数量
    ESBadgeView *_badgeView;
    
    DiscoverCell *detailCell;
}

@end


@implementation FindViewController

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
    self.title = @"发现";
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    
    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    //textAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    [self.navigationController.navigationBar setTitleTextAttributes:textAttrs];
    
    self.list = [NSMutableArray arrayWithCapacity:0];
    NSArray *array = @[@[@{@"title":ESLocalizedString(@"主播排行榜"), @"icon":@"image/find/ico-anchor"},
                         @{@"title":ESLocalizedString(@"富豪排行榜"), @"icon":@"image/find/ico-tuhao"},
                         @{@"title":ESLocalizedString(@"周榜"), @"icon":@"image/find/ico-week"}]];
    self.list = [NSMutableArray arrayWithArray:array];
    NSLog(@"%@", self.list);
    
    self.tableView.height -= 30;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    // 添加消息监听器
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

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.list count];
    // NSLog(@"FindViewController :: section count is %ld", [self.list count]);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.list[section] count];
    // NSLog(@"FindViewController :: row count for section %ld is %ld", section, [self.list count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    
    detailCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!detailCell)
    {
        detailCell = [[[NSBundle mainBundle] loadNibNamed:@"DiscoverCell" owner:self options:nil] lastObject];
    }
    
    NSDictionary *dic = nil;
    if ([self.list[indexPath.section][indexPath.row] isKindOfClass:[NSDictionary class]])
    {
        dic = self.list[indexPath.section][indexPath.row];
        detailCell.titleLabel.text = dic[@"title"];
        detailCell.titleLabel.textColor = [UIColor colorWithRed:68.0/255.0 green:68/255.0 blue:68/255.0 alpha:1.0];
        detailCell.iconImage.image = [UIImage imageNamed:dic[@"icon"]];
        
        detailCell.statusLabel.hidden = YES;
        detailCell.statusView.hidden = YES;
    }
    
    return detailCell;
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
    rect.origin.x = self.view.width - size.width - ScreenWidth/8;
    
    cell.statusView.frame = rect;
    
    cell.statusLabel.frame = CGRectMake(0, 3, rect.size.width, 12);
    // cell.statusLabel.center = cell.statusView.center;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        // 主播排行榜
        TopsLiverControlView *topsController = [[TopsLiverControlView alloc] initWithStyle:UITableViewStylePlain hasRefreshControl:YES];
        [self.navigationController pushViewController:topsController animated:YES];
    }
    else if (indexPath.row == 1)
    {
        // 富豪排行榜
        TopsSenderControlView *topsController = [[TopsSenderControlView alloc] initWithStyle:UITableViewStylePlain hasRefreshControl:YES];
        [self.navigationController pushViewController:topsController animated:YES];
    }
    else if (indexPath.row == 2)
    {
        // 周榜
        TopsUserControlView *topsController = [[TopsUserControlView alloc] initWithStyle:UITableViewStylePlain hasRefreshControl:YES];
        [self.navigationController pushViewController:topsController animated:YES];
    }
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
            if (unReadCount >= 100)
            {
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

#pragma mark - nearby user
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

/*
#pragma mark - 获取发现列表item
- (void)getDiscoverData
{
    ESWeakSelf;
    
    LCRequestSuccessResponseBlock successBlock = ^(NSDictionary *responseDic)
    {
        NSLog(@"getDiscoverData with responseDic = %@", responseDic);
        ESStrongSelf;
        
        int stat = [responseDic[@"stat"] intValue];
        if (stat == 200)
        {
            if (![responseDic[@"list"] isEqual:[NSNull null]])
            {
                [_self.list removeAllObjects];
                [_self handleDiscoverData:responseDic[@"list"]];
                [_self.refreshHeaderView endRefreshing];
            }
        }
        else
        {
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
    };
    
    LCRequestFailResponseBlock failBlock = ^(NSError *error)
    {
        NSLog(@"getDiscoverData with error = %@", error);
        ESStrongSelf;
        
        [LCNoticeAlertView showMsg:@"网络异常，请检查网络"];
    };
    
    NSString *path = NSStringWith(@"%@find", URL_HEAD);
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"version":[ESApp appVersion]}
                                                  withPath:path
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}

- (void)handleDiscoverData:(NSArray *)array
{
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *tempFirst = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *tempSecond = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *tempThree = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSDictionary *dic in array)
    {
        NSError *error = nil;
        DiscoverModel *model = [[DiscoverModel alloc] initWithDictionary:dic error:&error];
        model.hidden = [NSNumber numberWithBool:NO];
        
        if (model.group == 0)
        {
            [tempFirst addObject:model];
        }
        
        if (model.group == 1)
        {
            [tempSecond addObject:model];
        }
        
        if (model.group == 2)
        {
            [tempThree addObject:model];
        }
    }
    
    [self.list addObject:tempFirst];
    [self.list addObject:tempSecond];
    [self.list addObject:tempThree];
    
    [self.tableView reloadData];
}
 */

@end
