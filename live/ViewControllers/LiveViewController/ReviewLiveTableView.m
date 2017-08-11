//
//  ReviewLiveTableView.m
//  qianchuo
//
//  Created by 林伟池 on 16/5/30.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ReviewLiveTableView.h"

@implementation ReviewLiveTableView

- (void)refreshData
{
    if (_isLoading)
    {
        return;
    }
//    self.layer.allowsGroupOpacity
    [self requestLiveData:0];
}

- (void)loadData
{
    [self requestLiveData:[[[_datas lastObject] objectForKey:@"time"] longLongValue]];
}

- (void)requestLiveData:(long)lastTime
{
    if (_isLoading)
    {
        [_header endRefreshing];
        [_footer endRefreshing];
        return;
    }
    _isLoading = YES;
    [[Business sharedInstance] getReviewLives:lastTime succ:^(NSString *msg, id data) {
        if(lastTime == 0)
        {
            //刷新，如果是加载更多不用删除旧数据
            [_datas removeAllObjects];
        }
        NSMutableArray* arr = [NSMutableArray array];
        for (long index = _datas.count - 1, i = 0; i < [(NSArray *)data count]; ++i) {
            [arr addObject:[NSIndexPath indexPathForRow:index inSection:0]];
        }
        [_datas addObjectsFromArray:data];
        [_header endRefreshing];
        [_footer endRefreshing];
        [self reloadData];
        _isLoading = NO;
    } fail:^(NSString *error) {
        _isLoading = NO;
        [_header endRefreshing];
        [_footer endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_datas count] % 3 == 0)
    {
        return [_datas count] / kNum;
    }
    
    return [_datas count]/kNum + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"new_user_cell";
    NewUserHallCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NewUserHallCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        // 取消选择模式
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell clear];
    
    
    NSInteger flag = indexPath.row * kNum;
    for (int i = 0; i<kNum; ++i) {
        // 跳出循环
        
        NewUserItemView *authorItemView=(NewUserItemView *)[cell viewWithTag:1000+i];
        ESWeakSelf;
        authorItemView.itemBlock = ^(NSDictionary *userInfoDict){
            ESStrongSelf;
            [_self onItemClick:userInfoDict withPos:flag];
        };
        authorItemView.hidden=YES;
        if(flag>=[_datas count])
        {
            break;
        }
        authorItemView.hidden=NO;
        
        authorItemView.userInfoDict=_datas[flag];
        ++flag;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  kCell_Items_Height + IntervalPixel;
}

// item 事件选择
- (void) onItemClick:(NSDictionary *)item withPos:(NSInteger)currPos
{
    if([[item objectForKey:@"uid"] isEqualToString:[LCMyUser mine].userID])
    {
        return;
    }
    
    NSLog(@"审核");
//    WatchCutLiveViewController *watchLiveViewController = [[WatchCutLiveViewController alloc ] init];
//    [LCMyUser mine].liveUserId = [item objectForKey:@"uid"];
//    [LCMyUser mine].liveUserName = [item objectForKey:@"nickname"];
//    [LCMyUser mine].liveUserLogo = [item objectForKey:@"face"];
//    [LCMyUser mine].liveTime = [item objectForKey:@"time"];
//    [LCMyUser mine].liveType = LIVE_WATCH;
//    [LCMyUser mine].liveOnlineUserCount = [[item objectForKey:@"total"] intValue];
//    [LCMyUser mine].liveUserGrade = [[item objectForKey:@"grade"] intValue];
//    watchLiveViewController.playerUrl = [item objectForKey:@"url"];
//    watchLiveViewController.liveArray = _datas;
//    watchLiveViewController.pos = currPos;
//    
//    UINavigationController * liveVC = [[UINavigationController alloc] initWithRootViewController:watchLiveViewController];
//    liveVC.navigationBarHidden = YES;
    if (self.watchViewController) {
//        [self.watchViewController.navigationController pushViewController:watchLiveViewController animated:YES];
        [WatchCutLiveViewController ShowWatchLiveViewController:self.watchViewController.navigationController withInfoDict:item withArray:_datas withPos:(int)currPos];
    }
}

@end
