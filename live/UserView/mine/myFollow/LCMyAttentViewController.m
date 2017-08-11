//
//  LCMyFollowViewController.m
//  XCLive
//
//  Created by ztkztk on 14-4-21.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCMyAttentViewController.h"

#import "MyAttentAndFansCell.h"
#import "UserSpaceViewController.h"
#import "HomeUserInfoViewController.h"
#import "SearchViewController.h"
#import "WatchCutLiveViewController.h"

@interface LCMyAttentViewController ()

@end

@implementation LCMyAttentViewController


-(void)dealloc
{
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title=@"关注的人";
    
    
    if (!_userId) {
        UIButton *rightItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightItemBtn.frame=CGRectMake(0, 0, 65.0, 30.0);
        
        [rightItemBtn setTitle:@"添加"
                      forState:UIControlStateNormal];
        rightItemBtn.backgroundColor=[UIColor clearColor];
        
        [rightItemBtn addTarget:self
                         action:@selector(rightAction)
               forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithCustomView:rightItemBtn];
        self.navigationItem.rightBarButtonItem=rightItem;
    }
   
    
    self.tableView.height -= NAVIGATIONBAR_HEIGHT+STATUS_HEIGHT;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self refreshData];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([LCMyUser mine].roomInfoDict) {// 换房间
        ESWeakSelf;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ESStrongSelf;
            [_self changeRoomVC:[LCMyUser mine].roomInfoDict];
            
            [LCMyUser mine].roomInfoDict = nil;
        });
        
    }
}

#pragma mark - 换房间
- (void) changeRoomVC:(NSDictionary *)userInfoDict
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


-(void)rightAction
{
    SearchViewController *searchVC = [[SearchViewController alloc] initWithStyle:UITableViewStylePlain hasRefreshControl:NO];
    [self.navigationController pushViewController:searchVC animated:YES];
}


#pragma mark - Subclass
- (void)refreshData
{
    if(!self.isRefreshing)
    {
        self.hasMore=YES;
        self.isRefreshing=YES;
        currentPage=1;
        [self getAttentList:1];
    }
    
    
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData==%d",currentPage);
    if(currentPage>=1)
      [self getAttentList:currentPage+1];
    
}


-(void)getAttentList:(int)page
{
        ESWeakSelf;
        LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
            NSLog(@"getFriendList =%@",responseDic);
    
            ESStrongSelf;
            [_self.refreshHeaderView endRefreshing];
    
            int stat=[responseDic[@"stat"] intValue];
            if(stat==200)
            {
                if(_self.isRefreshing)
                {
                    currentPage=1;
                    [_self.list removeAllObjects];
                    NSArray *responseArray=responseDic[@"list"];
                    if([responseArray isKindOfClass:[NSArray class]]&&[responseArray count]>0)
                    {
                        _self.noDataNotice.hidden=YES;
                        [_self.list addObjectsFromArray:responseArray];
                        if([responseArray count]<10)
                            _self.hasMore=NO;
    
                    }
                    else
                    {
                        //无数据
                        self.noDataNotice.hidden=NO;
                        self.noDataNotice.text=@"您还没有关注好友，关注将获得对方更多的信息";
                    }
    
                    _self.loadMoreButton.hidden=YES;
                    _self.hasMore=YES;
                    _self.isRefreshing=NO;
                }
                else
                {
    
                    NSArray *responseArray=responseDic[@"list"];
                    if([responseArray isKindOfClass:[NSArray class]]&&[responseArray count]>0)
                    {
                        [_self.list addObjectsFromArray:responseArray];
                        _self.hasMore=YES;
                        currentPage++;
                        if([responseArray count]<10)
                            _self.hasMore=NO;
    
                    }else{
                        //无数据
                        //[LCNoticeAlertView showMsg:@"无更多内容"];
                        _self.hasMore=NO;
                    }
                    _self.loadMoreButton.hidden=YES;
    
                }
    
                [_self.tableView reloadData];
    
                if([_self.list count]==0)
                {
                    _self.noDataNotice.hidden=NO;
                    _self.noDataImageView.hidden=NO;
                    _self.noDataNotice.text = responseDic[@"msg"];
    
                }else{
                    _self.noDataImageView.hidden=YES;
                    _self.noDataNotice.hidden=YES;
                }
            }else{
                [LCNoticeAlertView showMsg:responseDic[@"msg"]];
                _self.loadMoreButton.hidden=YES;
                _self.isRefreshing=NO;
                _self.isLoadingMore=NO;
            }
            _self.isLoadingMore=NO;
    
            //[MBProgressHUD hideHUDForView:_self.view animated:YES];
        };
    
        LCRequestFailResponseBlock failBlock=^(NSError *error){
            NSLog(@"fans list error =%@",error);
    
            ESStrongSelf;
            _self.isRefreshing=NO;
            [_self.refreshHeaderView endRefreshing];
            _self.isLoadingMore=NO;
        };
    
    NSDictionary *parameter = nil;
    
    if (_userId) {
        parameter =  @{@"liveuid":_userId,@"page":[NSNumber numberWithInt:page]};
    } else {
        parameter = @{@"liveuid":[LCMyUser mine].userID,@"page":[NSNumber numberWithInt:page]};
    }
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameter
                                                  withPath:URL_ATTENT_USER_LIST
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
    
}


#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ 
    return [self.list count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"attentCell";
    
    MyAttentAndFansCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[MyAttentAndFansCell alloc]  initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:identifier];
        
        // 取消选择模式
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.userInfoDict = self.list[indexPath.row];
    cell.lineView.hidden = NO;
//    if (indexPath.row == (self.list.count-1)) {
//        cell.lineView.hidden = YES;
//    } else {
//        cell.lineView.hidden = NO;
//    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *userDic=self.list[indexPath.row];
    LiveUser *liveUser = [[LiveUser alloc] initWithPhone:userDic[@"uid"] name:userDic[@"nickname"] logo:userDic[@"face"]];
    liveUser.hasInRoom = NO;
    NSString *userIdStr = [NSString stringWithFormat:@"%@",liveUser.userId];
    if (!userIdStr || userIdStr.length <= 0) {
        return;
    }
    
    UserSpaceViewController *onlineUserVC = [[UserSpaceViewController alloc] init];
    onlineUserVC.liveUser = liveUser;
    onlineUserVC.isShowBg = YES;
    ESWeakSelf;
    onlineUserVC.privateChatBlock = ^(NSDictionary * userInfoDict) {
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
    onlineUserVC.changeLiveRoomBlock = ^(NSDictionary *userInfoDict){
        ESStrongSelf;
        [_self changeRoomVC:userInfoDict];
    };
    
    onlineUserVC.showUserHomeBlock = ^(NSString *userId){
        ESStrongSelf;
        HomeUserInfoViewController *userInfoVC = [[HomeUserInfoViewController alloc] init];
        userInfoVC.userId = userId;
        [_self.navigationController pushViewController:userInfoVC animated:YES];
    };
   
    
    [onlineUserVC popupWithCompletion:nil];
//    HomeUserInfoViewController *userInfoVC = [[HomeUserInfoViewController alloc] init];
//    userInfoVC.userId = liveUser.userId;
//    [self.navigationController pushViewController:userInfoVC animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
