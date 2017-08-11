//
//  MyAttentTableView.m
//  qianchuo
//
//  Created by jacklong on 16/4/23.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "MyAttentTableView.h"
#import "MyEmptyAttentView.h"
#import "MyAttentHallCell.h"


#define ATTENT_VIEW_TAG 1111

@interface MyAttentTableView()
{
    BOOL    isLoadAttentLive;
    UIView  *headView;
    UILabel *promptLabel;
    UIImageView *promptImgView;
    UILabel     *labelFirstLabel;
    UILabel     *labelSecondLabel;
    UIButton    *lookHotBtn;
    MyEmptyAttentView *emptyAttentView;
}
@end


@implementation MyAttentTableView


- (void)refreshData
{
    [self requestLiveData:0];
}

- (void)loadData
{
    [self requestLiveData:[[[_datas lastObject] objectForKey:@"time"] longLongValue]];
}

- (void)requestLiveData:(long)lastTime
{
    if (isLoadAttentLive)
    {
        return;
    }
    isLoadAttentLive = YES;
    ESWeakSelf;
    [[Business sharedInstance] getAttentLives:lastTime succ:^(NSString *msg, id data) {
        NSLog(@"_datas = %@", _datas);
        ESStrongSelf;
        if(lastTime == 0)
        {
            //刷新，如果是加载更多不用删除旧数据
            [_self->_datas removeAllObjects];
        }
        
        
        [_self->_datas addObjectsFromArray:data];
        NSLog(@"after _datas = %@", _datas);
        [_self->_header endRefreshing];
        [_self->_footer endRefreshing];
        [_self reloadData];
        
        isLoadAttentLive = NO;
        
        [_self addAttentHeadView];
    } fail:^(NSString *error) {
        ESStrongSelf;
        isLoadAttentLive = NO;
        [_self->_header endRefreshing];
        [_self->_footer endRefreshing];
    }];
}

#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_datas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"attent_cell";
    MyAttentHallCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        //cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:identifier];
        cell = [[MyAttentHallCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        // 取消选择模式
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row < _datas.count) {
        cell.userInfoDict = _datas[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= _datas.count) {
        return;
    }
    
    NSDictionary* item = [_datas objectAtIndex:indexPath.row];
    if([[item objectForKey:@"uid"] isEqualToString:[LCMyUser mine].userID])
    {
        return;
    }
    
//    WatchCutLiveViewController *watchLiveViewController = [[WatchCutLiveViewController alloc ] init];
//    [LCMyUser mine].liveUserId = [item objectForKey:@"uid"];
//    [LCMyUser mine].liveUserName = [item objectForKey:@"nickname"];
//    [LCMyUser mine].liveUserLogo = [item objectForKey:@"face"];
//    [LCMyUser mine].liveTime = [item objectForKey:@"time"];
//    [LCMyUser mine].liveTitle = [item objectForKey:@"title"];
//    [LCMyUser mine].liveType = LIVE_WATCH;
//    [LCMyUser mine].liveOnlineUserCount = [[item objectForKey:@"total"] intValue];
//    [LCMyUser mine].liveUserGrade = [[item objectForKey:@"grade"] intValue];
//    watchLiveViewController.playerUrl = [item objectForKey:@"url"];
//    watchLiveViewController.liveArray = _datas;
//    watchLiveViewController.pos = indexPath.row;
//    UINavigationController * liveVC = [[UINavigationController alloc] initWithRootViewController:watchLiveViewController];
//    liveVC.navigationBarHidden = YES;
    if (self.watchViewController) {
//        [self.watchViewController.navigationController pushViewController:watchLiveViewController animated:YES];
        [WatchCutLiveViewController ShowWatchLiveViewController:self.watchViewController.navigationController withInfoDict:item withArray:_datas withPos:(int)indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= _datas.count) {
        return 0;
    }
    
    NSString *titleStr = ESStringValue(_datas[indexPath.row][@"title"]);
    if (titleStr && titleStr.length > 0) {
        return 50+SCREEN_WIDTH+40+10;
    } else {
        return 50+SCREEN_WIDTH+10;
    }
}


- (void) addAttentHeadView
{
    if (!headView) {
        UIImage *promptImg = [UIImage imageNamed:@"image/liveroom/attent_null_live_bg"];
        headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(self.bounds))];
        headView.tag = ATTENT_VIEW_TAG;
        
        promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        promptLabel.backgroundColor = ColorPink;
        promptLabel.text =  ESLocalizedString(@"  关注好友的直播");
        promptLabel.textColor = [UIColor blackColor];
        promptLabel.font = [UIFont systemFontOfSize:14];
        promptLabel.textAlignment = NSTextAlignmentLeft;
        [headView addSubview:promptLabel];
        
        promptImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, promptLabel.bottom, SCREEN_WIDTH,120)];
        promptImgView.image = promptImg;
        [headView addSubview:promptImgView];
        
        labelFirstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 15)];
        labelFirstLabel.text = ESLocalizedString(@"你的好友静悄悄");
        labelFirstLabel.textColor = [UIColor grayColor];
        labelFirstLabel.font = [UIFont systemFontOfSize:10];
        labelFirstLabel.textAlignment = NSTextAlignmentCenter;
        [promptImgView addSubview:labelFirstLabel];
        
        labelSecondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, labelFirstLabel.bottom, SCREEN_WIDTH, 15)];
        labelSecondLabel.text = ESLocalizedString(@"此时还没有直播");
        labelSecondLabel.textColor = [UIColor grayColor];
        labelSecondLabel.font = [UIFont systemFontOfSize:10];
        labelSecondLabel.textAlignment = NSTextAlignmentCenter;
        [promptImgView addSubview:labelSecondLabel];
        
        
        UIImage *lookHotNormalImg = [UIImage imageNamed:@"image/liveroom/attent_null_live_btn_n"];
        UIImage *lookHotFocusImg = [UIImage imageNamed:@"image/liveroom/attent_null_live_btn_h"];
        
        
        lookHotBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, labelSecondLabel.bottom+15+30, lookHotNormalImg.size.width, lookHotNormalImg.size.height)];
        lookHotBtn.centerX = SCREEN_WIDTH/2;
        [lookHotBtn setBackgroundImage:lookHotNormalImg forState:UIControlStateNormal];
        [lookHotBtn setBackgroundImage:lookHotFocusImg forState:UIControlStateHighlighted];
        [lookHotBtn setTitle:ESLocalizedString(@"去看看最新精彩直播") forState:UIControlStateNormal];
        lookHotBtn.titleLabel.text = ESLocalizedString(@"去看看最新精彩直播");
        lookHotBtn.titleLabel.textColor = [UIColor whiteColor];
        lookHotBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [lookHotBtn addTarget:self action:@selector(lookHotAction) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:lookHotBtn];
        
        emptyAttentView = [[MyEmptyAttentView alloc] initWithFrame:headView.bounds];
        [emptyAttentView.mButton addTarget:self action:@selector(lookHotAction) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:emptyAttentView];
        emptyAttentView.hidden = YES;
    }
    
    if (_datas.count > 0) {
        headView.height = 30;
        promptImgView.hidden = YES;
        lookHotBtn.hidden = YES;
        emptyAttentView.hidden = YES;
    } else {
        headView.height = CGRectGetHeight(self.bounds);
        promptImgView.hidden = NO;
        lookHotBtn.hidden = NO;
        emptyAttentView.hidden = NO;
    }

    self.tableHeaderView = headView;
}

#pragma mark - 观看最热
- (void) lookHotAction
{
    if (_lookHotBlock) {
       _lookHotBlock();
    }
}


#pragma mark - 点击范围
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (gestureRecognizer.view == self) {
        NSLog(@"touch view:%@",touch.view);
        if (touch.view.tag == ATTENT_VIEW_TAG) {
            return NO;
        }
    }
    
    return YES;
}

@end
