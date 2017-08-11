//
//  LiveHotTableView.m
//  qianchuo
//
//  Created by jacklong on 16/4/23.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "LiveHotTableView.h"
#import "HotAdCell.h"
#import "HotRankCell.h"
#import "WatchCutLiveViewController.h"
#import "TopsLiverControlView.h"

#import "UserSpaceViewController.h"


static NSString *ADReuseIdentifier = @"ad_cell";
static NSString *HotRankIdentifier = @"rank_cell";
static NSString *identifier = @"hot_cell";


@implementation LiveHotTableView

- (void)refreshData
{
    if (_isLoading)
    {
        return;
    }
    
    [self requestHotData:0];
}

- (void)loadData
{
    [self requestHotData:[[[_datas lastObject] objectForKey:@"time"] longLongValue]];
}

- (void)requestHotData:(long)lastTime
{
    if (_isLoading)
    {
        return;
    }
    _isLoading = YES;
    
    ESWeakSelf;
    
    [[Business sharedInstance] getHotLives:lastTime succ:^(NSString *msg, id data)
    {
        ESStrongSelf;
        
        if (lastTime == 0)
        {
            // 刷新，如果是加载更多则不用删除旧数据
            [_datas removeAllObjects];
            
            if (!_self.advArray) {
                _self.advArray = [NSMutableArray array];
            } else {
                [_self.advArray removeAllObjects];
            }
            
            if ([[data objectForKey:@"adv"] isKindOfClass:[NSArray class]]) {
                [_self.advArray addObjectsFromArray:[data objectForKey:@"adv"]];
            }
            
            if (!_rankArray)
            {
                _rankArray = [NSMutableArray array];
            }
            else
            {
                [_rankArray removeAllObjects];
            }
            if ([[data objectForKey:@"rank"] isKindOfClass:[NSArray class]])
            {
                [_rankArray addObjectsFromArray:[data objectForKey:@"rank"]];
            }
            NSLog(@"JoyYouLive-getRankData :: count of rankArray = %ld && rankArray = %@", _rankArray.count, _rankArray);
        }
        
        if ([[data objectForKey:@"list"] isKindOfClass:[NSArray class]]) {
            [_datas addObjectsFromArray:[data objectForKey:@"list"]];
        }
        
        NSArray *dataArray = (NSArray *)[data objectForKey:@"list"];
        if (dataArray && [dataArray count] > 0)
        {
            NSString *url = [NSString stringWithFormat:@"%@", dataArray[0][@"url"]];
            if ([url rangeOfString:@"http:"].location != NSNotFound)
            {
                if (dataArray && !dataArray.isEmpty)
                {
                    for (NSDictionary *dict in dataArray)
                    {
                        NSLog(@"JoyYouLive-getLiveHotData :: dict = %@", dict);
                        
                        [_self preloadUrl:dict[@"url"]];
                    }
                }
            }
        }
        
        NSLog(@"JoyYouLive-getLiveHotData :: _datas = %@", _datas);
        
        [_self->_header endRefreshing];
        
        [_self->_footer endRefreshing];
        
        [_self reloadData];
        
        _isLoading = NO;
        
        // [_self addHotHeadView];
    } fail:^(NSString *error) {
        ESStrongSelf;
        
        _isLoading = NO;
        
        [_self->_header endRefreshing];
        
        [_self->_footer endRefreshing];
    }];
}

// 预加载
- (void)preloadUrl:(NSString *)url
{
    if (!url) {
        return;
    }
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:nil
                                                  withPath:url
                                               withRESTful:POST_REQUEST
                                          withSuccessBlock:nil
                                             withFailBlock:nil];
}

#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_datas count] % cNum == 0)
    {
        if (_advArray && _advArray.count > 0) {
            if (_rankArray && _rankArray.count > 0)
            {
                return [_datas count] / cNum + 1 + 1;
            }
            else
            {
                return [_datas count] / cNum + 1;
            }
        }
        else
        {
            if (_rankArray && _rankArray.count > 0)
            {
                return [_datas count] / cNum + 1;
            }
            else
            {
                return [_datas count] / cNum;
            }
        }
    }
    else
    {
        if (_advArray && _advArray.count > 0) {
            if (_rankArray && _rankArray.count > 0)
            {
                return [_datas count] / cNum + 2 + 1;
            }
            else
            {
                return [_datas count] / cNum + 2;
            }
        }
        else
        {
            if (_rankArray && _rankArray.count > 0)
            {
                return [_datas count] / cNum + 1 + 1;
            }
            else
            {
                return [_datas count] / cNum + 1;
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_advArray && _advArray.count > 0)
    {
        if (indexPath.row == 0)
        {
            HotAdCell *cell = [tableView dequeueReusableCellWithIdentifier:ADReuseIdentifier];
            if (!cell) {
                cell = [[HotAdCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ADReuseIdentifier];
            }
            cell.topADs = _advArray;
            
            ESWeakSelf;
            
            [cell setImageClickBlock:^(NSInteger index)
            {
                ESStrongSelf;
                
                [_self showWebIndex:index];
            }];
            
            return cell;
        }
        
        if (_rankArray && _rankArray.count > 0)
        {
            if (indexPath.row == 1)
            {
                HotRankCell *cell = [tableView dequeueReusableCellWithIdentifier:HotRankIdentifier];
                if (!cell)
                {
                    cell = [[HotRankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HotRankIdentifier];
                }
                
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                // 取消选择模式
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                HotRankItemView *rankItemView = (HotRankItemView *)[cell viewWithTag:8000000];
                
                ESWeakSelf;
                
                rankItemView.itemBlock = ^(NSDictionary *userInfoDict)
                {
                    ESStrongSelf;
                    
                    [self onItemClick:userInfoDict];
                };
                
                // NSLog(@"JoyYouLive :: count of rank array is: %ld && row index is: %ld", _rankArray.count, indexPath.row);
                rankItemView.firstUserInfoDict = _rankArray[0];
                rankItemView.secondUserInfoDict = _rankArray[1];
                rankItemView.thirdUserInfoDict = _rankArray[2];
                
                // NSLog(@"JoyYouLive :: cell frame: x = %f, y = %f, wid = %f, hgt = %f", cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
                
                return cell;
            }
        }
    }
    else
    {
        if (_rankArray && _rankArray.count > 0)
        {
            if (indexPath.row == 0)
            {
                HotRankCell *cell = [tableView dequeueReusableCellWithIdentifier:HotRankIdentifier];
                if (!cell)
                {
                    cell = [[HotRankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HotRankIdentifier];
                }
                
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                // 取消选择模式
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                HotRankItemView *rankItemView = (HotRankItemView *)[cell viewWithTag:8000000];
                
                ESWeakSelf;
                
                rankItemView.itemBlock = ^(NSDictionary *userInfoDict)
                {
                    ESStrongSelf;
                    
                    [self onItemClick:userInfoDict];
                };
                
                // NSLog(@"JoyYouLive :: count of rank array is: %ld && row index is: %ld", _rankArray.count, indexPath.row);
                rankItemView.firstUserInfoDict = _rankArray[0];
                rankItemView.secondUserInfoDict = _rankArray[1];
                rankItemView.thirdUserInfoDict = _rankArray[2];
                
                // NSLog(@"JoyYouLive :: cell frame: x = %f, y = %f, wid = %f, hgt = %f", cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
                
                return cell;
            }
        }
    }
    
    LiveHallUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[LiveHallUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    // 取消选择模式
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger flag = 0;
    if (_advArray && _advArray.count > 0)
    {
        if (_rankArray && _rankArray.count > 0)
        {
            if (indexPath.row < (_datas.count+1+1))
            {
                flag = (indexPath.row-2) * cNum;
            }
        }
        else
        {
            if (indexPath.row < (_datas.count+1))
            {
                flag = (indexPath.row-1) * cNum;
            }
        }
    }
    else
    {
        if (_rankArray && _rankArray.count > 0)
        {
            if (indexPath.row < (_datas.count+1))
            {
                flag = (indexPath.row-1) * cNum;
            }
        }
        else
        {
            if (indexPath.row < (_datas.count))
            {
                flag = indexPath.row * cNum;
            }
        }
    }
    
    for (int i = 0; i<cNum; ++i)
    {
        HotUserItemView *authorItemView = (HotUserItemView *)[cell viewWithTag:10000+i];
        
        authorItemView.hidden = YES;
        // 跳出循环
        if (flag >= [_datas count])
        {
            break;
        }
        authorItemView.hidden = NO;
        
        ESWeakSelf;
        
        authorItemView.itemBlock = ^(NSDictionary *userInfoDict)
        {
            ESStrongSelf;
            
            [_self onItemClick:userInfoDict with:flag];
        };
        
        authorItemView.userInfoDict = _datas[flag];
        
        ++flag;
    }
    
    // NSLog(@"JoyYouLive :: index %ld cell frame: x = %f, y = %f, wid = %f, hgt = %f", indexPath.row, cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
    
    return cell;
}

// item单击事件
- (void)onItemClick:(NSDictionary *)item with:(NSInteger)currPos
{
    if ([[item objectForKey:@"uid"] isEqualToString:[LCMyUser mine].userID] || [LCMyUser mine].liveUserId)
    {
        return;
    }
    
    if (self.watchViewController)
    {
        [WatchCutLiveViewController ShowWatchLiveViewController:self.watchViewController.navigationController withInfoDict:item withArray:_datas withPos:(int)currPos];
    }
}

- (void)onItemClick:(NSDictionary *)item
{
    if (item == nil)
    {
        if (self.watchViewController)
        {
            TopsLiverControlView *topsController = [[TopsLiverControlView alloc] initWithStyle:UITableViewStylePlain hasRefreshControl:YES];
            [self.watchViewController.navigationController pushViewController:topsController animated:YES];
        }
        
        return;
    }
    
    NSString *uid = [item objectForKey:@"uid"];
    NSString *nickName = [item objectForKey:@"nickname"];
    NSString *face = [item objectForKey:@"face"];
    
    LiveUser *liveUser = [[LiveUser alloc] initWithPhone:uid name:nickName logo:face];
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
            if (self.watchViewController)
            {
                [[[ChatViewController alloc] initWithUserInfoDictionary:userInfoDict] pushFromNavigationController:self.watchViewController.navigationController animated:YES];
            }
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
        
        if (self.watchViewController)
        {
            HomeUserInfoViewController *userInfoVC = [[HomeUserInfoViewController alloc] init];
            userInfoVC.userId = userId;
            [self.watchViewController.navigationController pushViewController:userInfoVC animated:YES];
        }
    };
    
    [onlineUserVC popupWithCompletion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_advArray && _advArray.count > 0)
    {
        if (indexPath.row == 0) {
            return 100;
        }
        
        if (_rankArray && _rankArray.count > 0)
        {
            if (indexPath.row == 1)
            {
                return 60 + 5;
            }
            
            if (indexPath.row < (_datas.count+2))
            {
                return cCell_Items_Height+30+5;
            }
        }
        else
        {
            if (indexPath.row < (_datas.count+1))
            {
                return cCell_Items_Height+30+5;
            }
        }
    } else {
        if (_rankArray && _rankArray.count > 0)
        {
            if (indexPath.row == 0)
            {
                return 60 + 5;
            }
            
            if (indexPath.row < (_datas.count+1))
            {
                return cCell_Items_Height+30+5;
            }
        }
        else
        {
            if (indexPath.row < (_datas.count))
            {
                return cCell_Items_Height+30+5;
            }
        }
    }
    
    return 0;
}

//- (void)addHotHeadView
//{
//    if (_advArray.count > 0) {
//        if (!_bannerView) {
//            _bannerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
//            
//            _bannerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
//            _bannerScrollView.userInteractionEnabled = YES;
//            _bannerScrollView.directionalLockEnabled = YES; // 只能一个方向滑动
//            _bannerScrollView.pagingEnabled = YES; // 是否翻页
//            _bannerScrollView.backgroundColor=[UIColor clearColor];
//            _bannerScrollView.delegate = self;
//            [_bannerView addSubview:_bannerScrollView];
//            _bannerScrollView.userInteractionEnabled = YES;
//            _bannerScrollView.tag = BANNER_SCROLLER_TAG;
//            
//            _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, 20)];
//            _pageControl.currentPage = 0;
//            _pageControl.currentPageIndicatorTintColor = ColorPink;
//            _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
//            [_bannerView addSubview:_pageControl];
//            
//            self.userInteractionEnabled = YES;
//            UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                               action:@selector(singleTap)];
//            singleRecognizer.numberOfTapsRequired = 1; // 单击
//            singleRecognizer.delegate = self;
//            [_bannerView addGestureRecognizer:singleRecognizer];
//        }
//        
//        [self showAdv];
//        
//        [self addAdvTimer];
//        
//        self.tableHeaderView = _bannerView;
//    }
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return _bannerView;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 100;
//}

//- (void)showAdv
//{
//    [_bannerScrollView removeAllSubviews];
//    
//    for (int i = 0; i < _advArray.count; i++) {
//        UIImageView *imageView = [[UIImageView alloc] init];
//        // 图片X
//        CGFloat imageX = i * SCREEN_WIDTH;
//        // 设置frame
//        imageView.frame = CGRectMake(imageX, 0, SCREEN_WIDTH, 100);
//        // 设置图片
//        NSString *name = [NSString stringWithFormat:@"default_head"];
//        imageView.image = [UIImage imageNamed:name];
//        // 隐藏指示条
//        _bannerScrollView.showsHorizontalScrollIndicator = NO;
//        
//        [_bannerScrollView addSubview:imageView];
//        
//        [imageView sd_setImageWithURL:[NSURL URLWithString:_advArray[i][@"pic"]] placeholderImage:[UIImage imageNamed:name]];
//    }
//    
//    _pageControl.numberOfPages = _advArray.count;
//}

//- (void)nextImage
//{
//    if (currPageControl == _advArray.count) {
//        currPageControl = 0;
//    } else {
//        currPageControl++;
//    }
//    
//    if (currPageControl == _advArray.count) {
//        currPageControl = 0;
//    }
//    
//    CGFloat x = currPageControl * _bannerScrollView.frame.size.width;
//    
//    [UIView animateWithDuration:0.5 animations:^{
//         _bannerScrollView.contentOffset = CGPointMake(x, 0);
//    }];
//}

//#pragma mark - scrollview
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    // 计算页码
//    // 页码 = (contentoffset.x + scrollView一半宽度) / scrollView宽度
//    if (scrollView.tag == BANNER_SCROLLER_TAG) {
//        CGFloat scrollviewW =  scrollView.frame.size.width;
//        CGFloat x = scrollView.contentOffset.x;
//        int page = (x + scrollviewW / 2) / scrollviewW;
//        self.pageControl.currentPage = page;
//    }
//}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    if (scrollView.tag == BANNER_SCROLLER_TAG) {
//        // 关闭定时器
//        [self removeAdvTimer];
//    }
//}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    if (scrollView.tag == BANNER_SCROLLER_TAG) {
//        // 关闭定时器
//        [self addAdvTimer];
//    }
//}

//#pragma mark - 定时器
//- (void)addAdvTimer
//{
//    if (_advArray.count <= 1) {
//        return;
//    }
//    
//    if (!self.timer) {
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
//    }
//}

//- (void)removeAdvTimer
//{
//    if (_advArray.count <= 1) {
//        return;
//    }
//    
//    if (self.timer) {
//        [self.timer invalidate];
//        self.timer = nil;
//    }
//}

#pragma mark - view
#pragma mark - 屏幕点击
- (void)showWebIndex:(NSInteger)index
{
    ShowWebViewController *showWebVC = [[ShowWebViewController alloc] init];
    showWebVC.hidesBottomBarWhenPushed = YES;
    showWebVC.webTitleStr = _advArray[index][@"title"];
    showWebVC.webUrlStr = [NSString stringWithFormat:@"%@", _advArray[index][@"url"]];
    showWebVC.automaticallyAdjustsScrollViewInsets = NO;
    [self.watchViewController.navigationController pushViewController:showWebVC animated:YES];
}

//#pragma mark - 点击范围
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    if (gestureRecognizer.view == self) {
//        UIScrollView *scrView = (UIScrollView *)touch.view;
//        if (scrView.tag == BANNER_SCROLLER_TAG) {
//            [_bannerScrollView setScrollEnabled:YES];
//            [self.outerScrollView setScrollEnabled:NO];
//            
//            return NO;
//        } else {
//            [self.outerScrollView setScrollEnabled:YES];
//            [_bannerScrollView setScrollEnabled:NO];
//        }
//    }
//    
//    return YES;
//}

@end
