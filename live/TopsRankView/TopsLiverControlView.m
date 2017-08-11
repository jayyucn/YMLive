//
//  TopsLiverControlView.m
//  qianchuo
//
//  Created by jacklong on 16/3/30.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//


#import "TopsLiverControlView.h"
#import "UserRankModel.h"
#import "TopsRankCell.h"
#import "TopOneRankCell.h"
#import "TopTwoCell.h"
#import "TopThreeCell.h"
#import "UserSpaceViewController.h"
#import "WatchCutLiveViewController.h"
#import "SegmentView.h"


#define TOP_CONTRIBUTE_TYPE 1
#define TOP_WEEK_TYPE       2

#define TOP_DAILY_TYPE      3


@interface TopsLiverControlView()<SegmentViewDelegate>
{
    int currType;
    
    int totalRevDiamond;
    int totalRevWeekDiamond;
    
    int totalRevDailyDiamond;
    
    int currContributePage;
    int currWeekPage;
    
    int currDailyPage;
   
    NSMutableArray *topsContributeArray;
    NSMutableArray *topsWeekArray;
    
    NSMutableArray *topsDailyArray;
    
    UILabel *topLabel;
    SegmentView *_segmentView;
}

@end


@implementation TopsLiverControlView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 分段视图
    NSArray *items = [NSArray arrayWithObjects:ESLocalizedString(@"总榜"), ESLocalizedString(@"周榜"), ESLocalizedString(@"日榜"), nil];
    
    CGRect segmentFrame = CGRectMake(0, 0, SCREEN_WIDTH/2, 44);
    _segmentView = [[SegmentView alloc] initWithFrame:segmentFrame andItems:items andSize:14 border:NO];
    _segmentView.center = CGPointMake(SCREEN_WIDTH/2, 0);
    _segmentView.delegate = self;
    
    self.navigationItem.titleView = _segmentView;
    [_segmentView setSelectIndex:1];
    
    currType = TOP_CONTRIBUTE_TYPE;
    
    self.tableView.height = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - STATUS_HEIGHT;
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    headView.backgroundColor = head_bg;
    topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 60)];
    topLabel.centerX = SCREEN_WIDTH/2;
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.textColor = [UIColor blackColor];
    topLabel.font = [UIFont systemFontOfSize:15.f];
    topLabel.text = [NSString stringWithFormat:@"%d %@", totalRevDiamond, ESLocalizedString(@"有美币")];
    [headView addSubview:topLabel];
    
    [self moneyTotalLabel:0];
    
    self.tableView.tableHeaderView = headView;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self refreshData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([LCMyUser mine].roomInfoDict)
    {
        // 换房间
        ESWeakSelf;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ESStrongSelf;
            
            [_self changeRoomVC:[LCMyUser mine].roomInfoDict];
            
            [LCMyUser mine].roomInfoDict = nil;
        });
    }
}

#pragma mark - 换房间

- (void)changeRoomVC:(NSDictionary *)userInfoDict
{
//    NSMutableArray *array = [NSMutableArray array];
//    [array addObject:userInfoDict];
//    
//    WatchCutLiveViewController *watchLiveViewController = [[WatchCutLiveViewController alloc] init];
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
    
    if (![LCMyUser mine].liveUserId)
    {
        [WatchCutLiveViewController ShowWatchLiveViewController:self.navigationController withInfoDict:userInfoDict withArray:nil withPos:0];
    }
}

- (void)presentAnimated:(BOOL)animated completion:(dispatch_block_t)completion
{
    [ESApp presentViewController:self animated:animated completion:completion];
}

#pragma mark - Subclass

- (void)refreshData
{
    if (currType == TOP_CONTRIBUTE_TYPE)
    {
        if (!self.isRefreshing)
        {
            self.hasMore = YES;
            self.isRefreshing = YES;
            currContributePage = 1;
            [self getTopsData:1];
        }
    }
    else if (currType == TOP_WEEK_TYPE)
    {
        if(!self.isRefreshing)
        {
            self.hasMore = YES;
            self.isRefreshing = YES;
            currContributePage = 1;
            [self getTopWeekData:1];
        }
    }
    else
    {
        if (!self.isRefreshing)
        {
            self.hasMore = YES;
            self.isRefreshing = YES;
            currContributePage = 1;
            [self getTopDailyData:1];
        }
    }
}

- (void)loadMoreData
{
    if (currType == TOP_CONTRIBUTE_TYPE)
    {
        NSLog(@"currContributePage loadMoreData == %d", currContributePage);
        if (currContributePage >= 1)
            [self getTopsData:currContributePage + 1];
    }
    else if (currType == TOP_WEEK_TYPE)
    {
        NSLog(@"currWeekPage loadMoreData == %d", currWeekPage);
        if(currWeekPage >=1 )
            [self getTopWeekData:currWeekPage + 1];
    }
    else
    {
        NSLog(@"currDailyPage loadMoreData == %d", currDailyPage);
        if(currDailyPage >= 1)
            [self getTopDailyData:currDailyPage + 1];
    }
}

- (void)getTopsData:(int)page
{
        ESWeakSelf;
    
        LCRequestSuccessResponseBlock successBlock = ^(NSDictionary *responseDic)
        {
            NSLog(@"JoyYou-YMLive :: getTopsData = %@", responseDic);
    
            ESStrongSelf;
            
            [_self.refreshHeaderView endRefreshing];
    
            int stat = [responseDic[@"stat"] intValue];
            if (stat == 200)
            {
                if(_self.isRefreshing)
                {
                    currContributePage = 1;
                    if (!topsContributeArray)
                    {
                        topsContributeArray = [NSMutableArray array];
                    }
                    [topsContributeArray removeAllObjects];
                    NSArray *responseArray = responseDic[@"list"];
                    totalRevDiamond = [responseDic[@"total"] intValue];
                    [self moneyTotalLabel:totalRevDiamond];
                    
                    if ([responseArray isKindOfClass:[NSArray class]] && [responseArray count] > 0)
                    {
                        _self.noDataNotice.hidden = YES;
                        for (NSDictionary *obj in responseArray)
                        {
                            [topsContributeArray addObject:[UserRankModel modelWithDictionary:obj]];
                        }
                        
                        if ([responseArray count] < 10)
                            _self.hasMore = NO;
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
                            [topsContributeArray addObject:[UserRankModel modelWithDictionary:obj]];
                        }
                        _self.hasMore = YES;
                        currContributePage++;
                        
                        if ([responseArray count] < 10)
                            _self.hasMore = NO;
                    }
                    else
                    {
                        // 无数据
                        // [LCNoticeAlertView showMsg:@"无更多内容"];
                        _self.hasMore = NO;
                    }
                }
                
                if (currType == TOP_CONTRIBUTE_TYPE)
                {
                    _self.list = topsContributeArray;
                    [_self.tableView reloadData];
                }
                
                if ([topsContributeArray count] == 0)
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
                _self.isRefreshing = NO;
                _self.isLoadingMore = NO;
                
                if([topsContributeArray count] == 0)
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
            NSLog(@"JoyYou-YMLive :: get error = %@", error);
            
            ESStrongSelf;
            _self.isRefreshing = NO;
            [_self.refreshHeaderView endRefreshing];
            _self.isLoadingMore = NO;
            
            // [MBProgressHUD hideHUDForView:_self.view animated:YES];
        };
    
    NSDictionary *parameter = @{@"type":@"all", @"page":[NSNumber numberWithInt:page]};
    
    if (parameter)
    {
        [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameter
                                                      withPath:URL_TOPS_LIVER
                                                   withRESTful:GET_REQUEST
                                              withSuccessBlock:successBlock
                                                 withFailBlock:failBlock];
    }
}

- (void)getTopWeekData:(int)page
{
    ESWeakSelf;
    
    LCRequestSuccessResponseBlock successBlock = ^(NSDictionary *responseDic)
    {
        NSLog(@"JoyYou-YMLive :: getTopWeekData = %@", responseDic);
        
        ESStrongSelf;
        
        [_self.refreshHeaderView endRefreshing];
        
        int stat = [responseDic[@"stat"] intValue];
        if (stat == 200)
        {
            if(_self.isRefreshing)
            {
                currWeekPage = 1;
                if (!topsWeekArray)
                {
                    topsWeekArray = [NSMutableArray array];
                }
                [topsWeekArray removeAllObjects];
                
                NSArray *responseArray = responseDic[@"list"];
                totalRevWeekDiamond = [responseDic[@"total"] intValue];
                [self moneyTotalLabel:totalRevWeekDiamond];
                
                if ([responseArray isKindOfClass:[NSArray class]] && [responseArray count] > 0)
                {
                    _self.noDataNotice.hidden = YES;
                    for (NSDictionary *obj in responseArray)
                    {
                        [topsWeekArray addObject:[UserRankModel modelWithDictionary:obj]];
                    }
                    
                    if ([responseArray count] < 10)
                        _self.hasMore = NO;
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
                        [topsWeekArray addObject:[UserRankModel modelWithDictionary:obj]];
                    }
                    _self.hasMore = YES;
                    currWeekPage++;
                    
                    if ([responseArray count] < 10)
                        _self.hasMore = NO;
                }
                else
                {
                    // 无数据
                    // [LCNoticeAlertView showMsg:@"无更多内容"];
                    _self.hasMore = NO;
                }
            }
            
            if (currType == TOP_WEEK_TYPE) {
                _self.list = topsWeekArray;
                [_self.tableView reloadData];
            }
            
            if ([topsWeekArray count] == 0)
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
            _self.isRefreshing = NO;
            _self.isLoadingMore = NO;
            
            if([topsWeekArray count] == 0)
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
        NSLog(@"JoyYou-YMLive :: get error = %@", error);
        
        ESStrongSelf;
        
        _self.isRefreshing = NO;
        [_self.refreshHeaderView endRefreshing];
        _self.isLoadingMore = NO;
        
        // [MBProgressHUD hideHUDForView:_self.view animated:YES];
    };
    
    NSDictionary *parameter = @{@"type":@"week", @"page":[NSNumber numberWithInt:page]};
    
    if (parameter)
    {
        [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameter
                                                      withPath:URL_TOPS_LIVER
                                                   withRESTful:GET_REQUEST
                                              withSuccessBlock:successBlock
                                                 withFailBlock:failBlock];
    }
}

- (void)getTopDailyData:(int)page
{
    ESWeakSelf;
    
    LCRequestSuccessResponseBlock successBlock = ^(NSDictionary *responseDic)
    {
        NSLog(@"JoyYou-YMLive :: getTopDailyData = %@", responseDic);
        
        ESStrongSelf;
        
        [_self.refreshHeaderView endRefreshing];
        
        int stat = [responseDic[@"stat"] intValue];
        if (stat == 200)
        {
            if(_self.isRefreshing)
            {
                currDailyPage = 1;
                if (!topsDailyArray)
                {
                    topsDailyArray = [NSMutableArray array];
                }
                [topsDailyArray removeAllObjects];
                
                NSArray *responseArray = responseDic[@"list"];
                totalRevDailyDiamond = [responseDic[@"total"] intValue];
                [self moneyTotalLabel:totalRevDailyDiamond];
                
                if ([responseArray isKindOfClass:[NSArray class]] && [responseArray count] > 0)
                {
                    _self.noDataNotice.hidden = YES;
                    for (NSDictionary *obj in responseArray)
                    {
                        [topsDailyArray addObject:[UserRankModel modelWithDictionary:obj]];
                    }
                    
                    if ([responseArray count] < 10)
                        _self.hasMore = NO;
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
                        [topsDailyArray addObject:[UserRankModel modelWithDictionary:obj]];
                    }
                    _self.hasMore = YES;
                    currDailyPage++;
                    
                    if ([responseArray count] < 10)
                        _self.hasMore = NO;
                }
                else
                {
                    // 无数据
                    // [LCNoticeAlertView showMsg:@"无更多内容"];
                    _self.hasMore = NO;
                }
            }
            
            if (currType == TOP_DAILY_TYPE) {
                _self.list = topsDailyArray;
                [_self.tableView reloadData];
            }
            
            if ([topsDailyArray count] == 0)
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
            _self.isRefreshing = NO;
            _self.isLoadingMore = NO;
            
            if([topsDailyArray count] == 0)
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
        NSLog(@"JoyYou-YMLive :: get error = %@", error);
        
        ESStrongSelf;
        
        _self.isRefreshing = NO;
        [_self.refreshHeaderView endRefreshing];
        _self.isLoadingMore = NO;
        
        // [MBProgressHUD hideHUDForView:_self.view animated:YES];
    };
    
    NSDictionary *parameter = @{@"type":@"day", @"page":[NSNumber numberWithInt:page]};
    
    if (parameter)
    {
        [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameter
                                                      withPath:URL_TOPS_LIVER
                                                   withRESTful:GET_REQUEST
                                              withSuccessBlock:successBlock
                                                 withFailBlock:failBlock];
    }
}

#pragma mark - segmentview delegate

- (void)segmentView:(SegmentView *)segmentView selectIndex:(NSInteger)index
{
    if (index == 0)
    {
        currType = TOP_CONTRIBUTE_TYPE;
        
        if (!topsContributeArray || topsContributeArray.isEmpty)
        {
            self.isRefreshing = NO;
            
            self.list = topsContributeArray;
            [self.tableView reloadData];
            
            [self refreshData];
        } else {
            self.list = topsContributeArray;
            [self.tableView reloadData];
            
            [self moneyTotalLabel:totalRevDiamond];
        }
    }
    else if (index == 1)
    {
        currType = TOP_WEEK_TYPE;
        
        if (!topsWeekArray || topsWeekArray.isEmpty)
        {
            self.isRefreshing = NO;
            
            self.list = topsWeekArray;
            [self.tableView reloadData];
            
            [self refreshData];
        } else {
            self.list = topsWeekArray;
            [self.tableView reloadData];
            
            [self moneyTotalLabel:totalRevWeekDiamond];
        }
    }
    else
    {
        currType = TOP_DAILY_TYPE;
        
        if (!topsDailyArray || topsDailyArray.isEmpty)
        {
            self.isRefreshing = NO;
            
            self.list = topsDailyArray;
            [self.tableView reloadData];
            
            [self refreshData];
        } else {
            self.list = topsDailyArray;
            [self.tableView reloadData];
            
            [self moneyTotalLabel:totalRevDailyDiamond];
        }
    }
}


#pragma mark - Table view data source
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//
//    return headView;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 60;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        static NSString *identifier = @"tops_rank_cell_one";
        
        TopOneRankCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell)
        {
            cell = [[TopOneRankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            
            // 取消选择模式
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.userModel = self.list[indexPath.row];
         
        return cell;
    }
    else if (indexPath.row == 1)
    {
        static NSString *identifier = @"tops_rank_cell_two";
        
        TopTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell)
        {
            cell = [[TopTwoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            
            // 取消选择模式
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.userModel = self.list[indexPath.row];
        
        return cell;
    }
    else if (indexPath.row == 2)
    {
        static NSString *identifier = @"tops_rank_cell_three";
        
        TopThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell)
        {
            cell = [[TopThreeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            
            // 取消选择模式
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.userModel = self.list[indexPath.row];
        
        return cell;
    }
    else
    {
        static NSString *identifier = @"tops_rank_cell";
        
        TopsRankCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell)
        {
            cell = [[TopsRankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            
            // 取消选择模式
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (indexPath.row == 3)
        {
            cell.intervalView.height = 10;
            cell.intervalView.hidden = NO;
            cell.gradeFlagImgView.top = 49; // cell.faceImg.bottom - cell.gradeFlagImgView.height;
        }
        else
        {
            cell.intervalView.height = 0;
            cell.intervalView.hidden = YES;
            cell.gradeFlagImgView.top = cell.lineView.top - cell.gradeFlagImgView.height * 2 - 2;
        }
        
        cell.numRankLabel.text = [NSString stringWithFormat:@"NO.%d", (int)(indexPath.row + 1)];
        cell.userModel = self.list[indexPath.row];
        
        return cell;
    }
}


#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 185;
    } else if (indexPath.row == 1) {
        return  155;
    } else if (indexPath.row == 2) {
        return 150;
    } else if (indexPath.row == 3) {
        return 70;
    }
    
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserRankModel *userModel = self.list[indexPath.row];
    
    // [self showDetail:userDic];
    
    LiveUser *liveUser = [[LiveUser alloc]initWithPhone:userModel.uid name:userModel.nickname logo:userModel.face];
    liveUser.hasInRoom = NO;
    NSString *userIdStr = [NSString stringWithFormat:@"%@", liveUser.userId];
    if (!userIdStr || userIdStr.length <= 0)
    {
        return;
    }
    UserSpaceViewController *onlineUserVC = [[UserSpaceViewController alloc] init];
    onlineUserVC.isShowBg = YES;
    onlineUserVC.liveUser = liveUser;
    
    ESWeakSelf;
    
    onlineUserVC.privateChatBlock = ^(NSDictionary *userInfoDict)
    {
        ESStrongSelf;
        
        if ([LCMyUser mine].priChatTag && [[LCMyUser mine].priChatTag isEqualToString:@"0"])
        {
            [[[ChatViewController alloc] initWithUserInfoDictionary:userInfoDict] pushFromNavigationController:_self.navigationController animated:YES];
        }
        else
        {
            // 弹出提示
            [[[UIAlertView alloc] initWithTitle:nil
                                        message:@"很抱歉，您没有私信的权限"
                                       delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil] show];
        }
    };
    
    onlineUserVC.showUserHomeBlock = ^(NSString *userId)
    {
        ESStrongSelf;
        
        HomeUserInfoViewController *userInfoVC = [[HomeUserInfoViewController alloc] init];
        userInfoVC.userId = userId;
        [_self.navigationController pushViewController:userInfoVC animated:YES];
    };
    
//    onlineUserVC.changeLiveRoomBlock = ^(NSDictionary *userInfoDict) {
//        ESStrongSelf;
//
//        [_self changeRoom:userInfoDict];
//    };
    
    [onlineUserVC popupWithCompletion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

#pragma mark - 币榜

- (void)moneyTotalLabel:(int)recvDiamond
{
    NSString *recDiamondStr = [NSString stringWithFormat:@"d %d %@", recvDiamond, ESLocalizedString(@"有美币")];
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:recDiamondStr];
    
    NSRange recRange = [mutableAttributedString.string rangeOfString:[NSString stringWithFormat:@"%d", recvDiamond]];
    
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:ColorPink range:recRange];
    
    UIImage *moneyIconImg = [UIImage createContentsOfFile:@"image/liveroom/me_ranking_money"];
    
    NSTextAttachment *moneyAttachment = [[NSTextAttachment alloc] init];
    moneyAttachment.image = [UIImage imageWithImage:moneyIconImg scaleToSize:CGSizeMake(moneyIconImg.size.width/3, moneyIconImg.size.height/3)];
    moneyAttachment.bounds = CGRectMake(0, 0, moneyIconImg.size.width/3, moneyIconImg.size.height/3);
    NSAttributedString *moneyAttributedString = [NSAttributedString attributedStringWithAttachment:moneyAttachment];
    [mutableAttributedString replaceCharactersInRange:NSMakeRange(0, 1) withAttributedString:moneyAttributedString];
    topLabel.attributedText = mutableAttributedString;
}

@end
