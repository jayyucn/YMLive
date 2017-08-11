//
//  HomeUserInfoViewController.m
//  qianchuo
//
//  Created by jacklong on 16/8/4.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "HomeUserInfoViewController.h"
#import "HomeUserHeadView.h"
#import "LCMyAttentViewController.h"
#import "XLMyFansViewController.h"
#import "UserStateSegView.h"
#import "EMMallSectionView.h"
#import "TopsRankControlView.h"
#import "DiscoverCell.h"
#import "HomeBottomView.h"
#import "HomeUserAllInfoCell.h"
#import "UserLiveListView.h"
#import "TopRankCell.h"
#import "UserInfoItemView.h"
#import "PlayBackCell.h"
#import "PlayCallBackViewController.h"
#import "OVOInviteViewController.h"
#import "RechargeViewController.h"

#define ZoomHieght 220

#define HOME_PAGE_TYPE 1
#define LIVE_TYPE      2

@interface HomeUserInfoViewController()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UserStateSegmentViewDelegate,AttentFansSegViewDelegate>
{
    BOOL isReqInvite;
    BOOL _isLoading;
    BOOL isOpenOneToOne;// 是否开通1v1
    int currType;
    
    BOOL isExitOldPlayBackVC;
    
    UserStateSegView *segStateView;
    TopRankCell *topRankCell;
    UserInfoItemView *userInfoCell;
    PlayBackCell *playBackCell;
    UILabel *noDataLabel;
    
    NSString *nickName;
    NSString *faceUrl;
}
@property (nonatomic,strong)NSMutableArray *list;

@property (nonatomic,strong)NSMutableArray *homePageArray;
@property (nonatomic,strong)NSMutableArray *liveArray;
@property (nonatomic,strong)NSDictionary   *topDict;

@property (nonatomic,strong)UITableView    *tableView;
@property (nonatomic,strong)HomeUserHeadView *detailHeaderView;
@property (nonatomic,strong)HomeBottomView  *homeBottomView;
//@property (nonatomic,strong)HomeUserAllInfoCell *userInfoAllCell;

@property (nonatomic,strong)UserLiveListView *userLiveListView;
@end

@implementation HomeUserInfoViewController

- (void)dealloc
{
    NSLog(@"dealloc %@",NSStringFromClass(self.class));
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = ColorBackGround;
    
    self.list = [[NSMutableArray alloc] init];
    
    currType = HOME_PAGE_TYPE;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    //3.设置代理，头文件也要包含 UITableViewDelegate,UITableViewDataSource
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //4.设置contentInset属性（上左下右 的值）
    self.tableView.contentInset = UIEdgeInsetsMake(ZoomHieght, 0, 0, 0);
    //5.添加_tableView
    [self.view addSubview:self.tableView];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = ColorBackGround;
    self.tableView.height -= TABBAR_HEIGHT;
    
    _detailHeaderView =[[HomeUserHeadView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth,ZoomHieght)];
    _detailHeaderView.image = [UIImage imageNamed:@"image/liveroom/user_space_bg"];
    //contentMode = UIViewContentModeScaleAspectFill时，高度改变宽度也跟着改变
    _detailHeaderView.segDelegate = self;
    _detailHeaderView.contentMode = UIViewContentModeScaleAspectFill;//重点（不设置那将只会被纵向拉伸）
    [self.tableView addSubview:_detailHeaderView];
    [_detailHeaderView.backActionBtn addTarget:self action:@selector(backFinishAction) forControlEvents:UIControlEventTouchUpInside];
    //设置autoresizesSubviews让子类自动布局
    _detailHeaderView.autoresizesSubviews = YES;
//    segStateView = [[UserStateSegView alloc] initWithFrame:CGRectMake(0, _detailHeaderView.bottom, SCREEN_WIDTH, 45)];
//    segStateView.isMySpaceUser = YES;
//    
//    segStateView.items = [NSArray arrayWithObjects:
//                          [NSString stringWithFormat:@"%@", ESLocalizedString(@"主页")],
//                          [NSString stringWithFormat:@"%@",ESLocalizedString(@"直播")],  nil];
//    segStateView.delegate = self;
//    [self.tableView addSubview:segStateView];
//    
//    
//    _homeUserInfoView = [[HomeUserInfoView alloc] initWithFrame:CGRectMake(0, segStateView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - segStateView.bottom - 40) withShowHeadRefresh:NO withShowFooterRefresh:NO];
//    ESWeakSelf;
//    _homeUserInfoView.showRankBlock = ^(){
//        ESStrongSelf;
//        TopsRankControlView *topsController = [[TopsRankControlView alloc] initWithStyle:UITableViewStylePlain hasRefreshControl:YES];
//        topsController.isLiveUser = NO;
//        topsController.userId = _self.userId;
//        [_self.navigationController pushViewController:topsController animated:YES];
//    };
//    [self.tableView addSubview:_homeUserInfoView];
//    
//    
//    
//    _userLiveListView = [[UserLiveListView alloc] initWithFrame:CGRectMake(0, segStateView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - segStateView.bottom - 40) withShowHeadRefresh:NO withShowFooterRefresh:YES];
//    _userLiveListView.userId = self.userId;
//    
//    [self.tableView addSubview:_userLiveListView];
//    _userLiveListView.hidden = YES;
//    
    noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ZoomHieght + 45, SCREEN_WIDTH, 20)];
    noDataLabel.textAlignment = NSTextAlignmentCenter;
    noDataLabel.textColor = [UIColor grayColor];
    noDataLabel.font = [UIFont boldSystemFontOfSize:15.f];
    noDataLabel.text = ESLocalizedString(@"TA还没有直播过哦");
    noDataLabel.centerY =  ZoomHieght + 45 + (SCREEN_HEIGHT - ZoomHieght - 45- 40)/2;
    [self.view addSubview:noDataLabel];
    noDataLabel.hidden = YES;
//    _userLiveListView.noPlayBackView = noDataLabel;
    
    if ([_userId isKindOfClass:[NSString class]] && [LCMyUser mine].userID && ![_userId isEqualToString:[LCMyUser mine].userID]) {
        self.homeBottomView = [[HomeBottomView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT- 40, SCREEN_WIDTH, 40) withUserId:_userId];
        self.homeBottomView.userId = _userId;
        [self.homeBottomView.privBtn addTarget:self action:@selector(showPrivAction) forControlEvents:UIControlEventTouchUpInside];
        [self.homeBottomView.oneToOneBtn addTarget:self action:@selector(startOneToOneAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.homeBottomView];
    }
    
    [self setUserHeadData:nil];
    
    [self getUserInfo];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;//根据实际选择加不加上NavigationBarHight（44、64 或者没有导航条）
    if (y < -ZoomHieght) {
        CGRect frame = _detailHeaderView.frame;
        frame.origin.y = y;
        frame.size.height =  -y;//contentMode = UIViewContentModeScaleAspectFill时，高度改变宽度也跟着改变
        _detailHeaderView.frame = frame;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.navigationController.isNavigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    
    isExitOldPlayBackVC = NO;
    
    if ([self.tableView indexPathForSelectedRow])
    {
        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    }
    
//    if (segStatecell) {
//        NSString * attentIds = [[LCMyUser mine].attentUserIdsStr copy];
//        if (attentIds && [attentIds rangeOfString:@","].location != NSNotFound) {
//            NSArray *array = [attentIds splitWith:@","];
//            if (array.count >= 2) {
//                [LCMyUser mine].atten_total = (int)(array.count - 2);
//            } else {
//                [LCMyUser mine].atten_total = 0;
//            }
//            
//        } else {
//            [LCMyUser mine].atten_total = 0;
//        }
//        
//        segStatecell.items = [NSArray arrayWithObjects:
//                              [NSString stringWithFormat:@"%@ %d", ESLocalizedString(@"关注"), [LCMyUser mine].atten_total],
//                              [NSString stringWithFormat:@"%@ %d", ESLocalizedString(@"粉丝"), [LCMyUser mine].fans_total],  nil];
//    }
}

- (void)segmentView:(UserStateSegView*)segmentView selectIndex:(NSInteger)index
{
    NSLog(@"index:%ld",(long)index);
//    [UIView animateWithDuration:0.2f animations:^{
//        _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width*index, 0);
//    }];
    
    if (index == 0) {
        currType = HOME_PAGE_TYPE;
        noDataLabel.hidden = YES;
        self.list = _homePageArray;
        [self.tableView reloadData];
    } else {
         currType = LIVE_TYPE;
        if (_liveArray && _liveArray.count > 0) {
            self.list = _liveArray;
            [self.tableView reloadData];
        } else {
            [self getPlayBackList:1];
        }
    }
}

- (void)attentFansSegmentView:(AttentFansSegView*)segmentView selectIndex:(NSInteger)index
{
    NSLog(@"index:%ld",(long)index);
    if (index == 0)
    {
        LCMyAttentViewController *attentController=[[LCMyAttentViewController alloc] initWithStyle:UITableViewStylePlain hasRefreshControl:YES];
        attentController.userId = _userId;
        [self.navigationController pushViewController:attentController animated:YES];
    }
    else if (index == 1)
    {
        XLMyFansViewController *fansController = [[XLMyFansViewController alloc] initWithStyle:UITableViewStylePlain hasRefreshControl:YES];
        fansController.userId = _userId;
        [self.navigationController pushViewController:fansController animated:YES];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (currType == HOME_PAGE_TYPE) {
        return  3;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (currType == HOME_PAGE_TYPE) {
        if (section == 0 || section == 1) {
            return  1;
        } else {
            return self.list.count;
        }
    } else {
        if (section == 0) {
            return 1;
        }
        
        return self.list.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section  == 0)
    {
        static NSString *identifier = @"segviewcell";
        segStateView = [tableView dequeueReusableCellWithIdentifier:identifier];

        if (!segStateView)
        {
            segStateView = [[UserStateSegView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            segStateView.isMySpaceUser = YES;
            
            segStateView.items = [NSArray arrayWithObjects:
                                  [NSString stringWithFormat:@"%@", ESLocalizedString(@"主页")],
                                  [NSString stringWithFormat:@"%@",ESLocalizedString(@"直播")],  nil];
            segStateView.delegate = self;
            
            // 取消选择模式
            segStateView.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [segStateView setAccessoryType:UITableViewCellAccessoryNone];
 
        return segStateView;
    }
    else if (indexPath.section == 1)
    {
        if (currType == HOME_PAGE_TYPE) {
            static NSString *identifier = @"user_top_cell";
            topRankCell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!topRankCell)
            {
                topRankCell = [[TopRankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                
                // 取消选择模式
                topRankCell.selectionStyle = UITableViewCellSelectionStyleGray;
                
                [topRankCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
            
            topRankCell.topsDict = _topDict;
            
            return topRankCell;
        } else {
            static NSString *identifier = @"play_back_cell";
            playBackCell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!playBackCell)
            {
                playBackCell = [[PlayBackCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                
                [playBackCell setAccessoryType:UITableViewCellAccessoryNone];
                // 取消选择模式
                playBackCell.selectionStyle = UITableViewCellSelectionStyleGray;
            }
            
            ESWeakSelf;
            playBackCell.playBackBlock = ^(NSDictionary *dict) {
                
                ESStrongSelf;
                [_self popOldPlayBackVC:dict];
                
                if (!_self->isExitOldPlayBackVC) {
                    PlayCallBackViewController *playBackVC = [[PlayCallBackViewController alloc] init];
                    playBackVC.playerCallBackUrl = dict[@"url"];
                    playBackVC.playVdoid = dict[@"id"];
                    playBackVC.playerUid = _self.userId;
                    playBackVC.playBackDict = dict;
                    playBackVC.isAgainLoad = NO;
                    [_self.navigationController pushViewController:playBackVC animated:YES];
                }
            };
            
            playBackCell.playBackInfoDict = self.list[indexPath.row];
            return playBackCell;
        }
       
    } else {
        static NSString *identifier = @"user_info_cell";
        userInfoCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!userInfoCell)
        {
            userInfoCell = [[UserInfoItemView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            
            // 取消选择模式
            userInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [userInfoCell setAccessoryType:UITableViewCellAccessoryNone];
        
        userInfoCell.userInfoDict = self.list[indexPath.row];
       
        return userInfoCell;
    }
}

// 销毁堆栈点播VC
- (void) popOldPlayBackVC:(NSDictionary *)dict
{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[PlayCallBackViewController class]]) {
            NSLog(@"destroy old playCallBackViewController");
            isExitOldPlayBackVC = YES;
            PlayCallBackViewController *playBackVC = (PlayCallBackViewController *)controller;
            playBackVC.playerCallBackUrl = dict[@"url"];
            playBackVC.playVdoid = dict[@"id"];
            playBackVC.playerUid = self.userId;
            playBackVC.playBackDict = dict;
            playBackVC.isAgainLoad = YES;
            [self.navigationController popToViewController:playBackVC animated:YES];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (currType == HOME_PAGE_TYPE) {
        if (indexPath.section == 1) {
            [self showRankDetailAction];
        }
    } else {
        if (indexPath.section == 1 && self.list && indexPath.row < self.list.count) {
            NSDictionary *dict = self.list[indexPath.row];
            PlayCallBackViewController *playBackVC = [[PlayCallBackViewController alloc] init];
            playBackVC.playerCallBackUrl = dict[@"url"];
            playBackVC.playVdoid = dict[@"id"];
            playBackVC.playerUid = _userId;
            playBackVC.playBackDict = dict;
            
            [self.navigationController pushViewController:playBackVC animated:YES];
        }
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (currType == HOME_PAGE_TYPE) {
        if (indexPath.section == 0) {
            return 45.f;
        }
        
        return 45.f;
    } else {
        if (indexPath.section == 0) {
            return 45.f;
        }
        return 60.f;
    }

}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    EMMallSectionView *sectionView =  [EMMallSectionView showWithName:[NSString stringWithFormat:@"section_title_%ld",(long)section]];
    sectionView.tableView = self.tableView;
    sectionView.section = section;
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (currType == HOME_PAGE_TYPE) {
        if (section == 0 || section == 1) {
            return 0;
        }
        return [EMMallSectionView getSectionHeight];
    } else {
        return 0;
    }
  
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    EMMallSectionView *sectionView =  [EMMallSectionView showWithName:[NSString stringWithFormat:@"section_title_%ld",(long)section]];
//    sectionView.tableView = self.tableView;
//    sectionView.section = section;
//    
//    return sectionView;
//}
//
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (section == self.list.count - 1) {
//        return [EMMallSectionView getSectionHeight];
//    }
//    return 0;
//}


//#pragma mark - Public Methods
//- (void)scrollTableViewToTop:(BOOL)animated
//{
////    [self.tableView setContentOffset:CGPointZero animated:animated];
//}
//
//- (void)setVisibleCellsNeedsDisplay
//{
//    NSArray *visibleCells = [self.tableView visibleCells];
//    if (visibleCells) {
//        [visibleCells makeObjectsPerformSelector:@selector(setNeedsDisplay)];
//    }
//}
//
//- (void)setVisibleCellsNeedsLayout
//{
//    NSArray *visibleCells = [self.tableView visibleCells];
//    if (visibleCells) {
//        [visibleCells makeObjectsPerformSelector:@selector(setNeedsLayout)];
//    }
//}

#pragma mark - head click event
- (void) backFinishAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) showRankDetailAction
{
    TopsRankControlView *topsController = [[TopsRankControlView alloc] initWithStyle:UITableViewStylePlain hasRefreshControl:YES];
    topsController.userId = _userId;
    [self.navigationController pushViewController:topsController animated:YES];
}

#pragma mark - private userinfo
- (void) getUserInfo
{
    if (!_userId) {
        return;
    }
    ESWeakSelf
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        
        NSLog(@" userinfo responseDic=%@",responseDic);
        ESStrongSelf
        int stat=[responseDic[@"stat"] intValue];
        if(stat==200)
        {
//            [_self.detailHeaderView.dic :responseDic[@"userinfo"]];
            
            if ([responseDic[@"userinfo"] isKindOfClass:[NSDictionary class]]) {
                [_self setUserHeadData:responseDic[@"userinfo"]];
            }
    
            [_self setUserInfo:responseDic[@"userinfo"]];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ESLocalizedString(@"提醒")
                                                            message:responseDic[@"msg"]
                                                           delegate:self
                                                  cancelButtonTitle:ESLocalizedString(@"确定")
                                                  otherButtonTitles:nil];
            alert.delegate=self;
            alert.tag=3;
            [alert show];
        }
    };
    
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        NSLog(@"gagerror=%@",error);
    };
    
    NSDictionary *parameters=@{@"u":_userId};
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameters
                                                  withPath:getLiveUserDetailURL()
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}

- (void) setUserHeadData:(NSDictionary *)responseDict
{
    if (!_detailHeaderView) {
        return;
    }
    if (!responseDict) {
        return;
    }
    _detailHeaderView.userInfoDict = responseDict;
    isOpenOneToOne = [responseDict[@"onetone"] intValue];
    if (isOpenOneToOne && [LCMyUser mine].liveType == LIVE_UPMIKE) {
        isOpenOneToOne = NO;
    }
    
    if (_homeBottomView) {// 1v1显示状态
        [_homeBottomView updateOneToOneState:isOpenOneToOne];
    }
}

- (void) setUserInfo:(NSDictionary *)responesDict
{
    NSMutableArray * infoArray = [NSMutableArray array];
    
    if (responesDict[@"uid"]) {
        NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
        [infoDict setObject:ESLocalizedString(@"ID号") forKey:@"name"];
        [infoDict setObject:responesDict[@"uid"] forKey:@"content"];
        [infoArray addObject:infoDict];
    }
 
    NSString *goodID = responesDict[@"goodid"];
    if (goodID.length > 1) {
        NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
        [infoDict setObject:ESLocalizedString(@"靓号") forKey:@"name"];
        [infoDict setObject:goodID forKey:@"content"];
        [infoArray addObject:infoDict];
    }
    
    NSString *tag = responesDict[@"tag"];
    if (tag && tag.length > 0) {
        NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
        [infoDict setObject:ESLocalizedString(@"认证") forKey:@"name"];
        [infoDict setObject:tag forKey:@"content"];
        [infoArray addObject:infoDict];
    }
    
    NSString *city = responesDict[@"city"];
    if (city && city.length > 0) {
        NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
        [infoDict setObject:ESLocalizedString(@"家乡") forKey:@"name"];
        [infoDict setObject:city forKey:@"content"];
        [infoArray addObject:infoDict];
    }
    
    NSString *sign = responesDict[@"signature"];
    if (sign && sign.length > 0) {
        NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
        [infoDict setObject:ESLocalizedString(@"个性签名") forKey:@"name"];
        [infoDict setObject:sign forKey:@"content"];
        [infoArray addObject:infoDict];
    }
    
    nickName = responesDict[@"nickname"];
    faceUrl = responesDict[@"face"];
    
//    [_userInfoAllCell.homeUserInfoView.datas addObjectsFromArray:infoArray];
    NSArray *array = responesDict[@"tops"];
    if (array && array.count > 0) {
//        _userInfoAllCell.homeUserInfoView.topsDict = array[0];
        _topDict =  array[0];
    }
    _homePageArray = infoArray;
    
    self.list = _homePageArray;
    [self.tableView reloadData];
}

#pragma mark - 点播列表
-(void)getPlayBackList:(int)page
{
    if (_isLoading)
    {
        return;
    }
    _isLoading = YES;
    
    ESWeakSelf;
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        ESStrongSelf;
        _self->_isLoading = NO;
        if (!_self.liveArray) {
            _self.liveArray = [NSMutableArray array];
        }

        if (200 == [responseDic[@"stat"] intValue]) {
           
            NSArray *array = responseDic[@"list"];
            if (array && array.count > 0) {
                _self->noDataLabel.hidden = YES;
                
                
                [_self.liveArray addObjectsFromArray:array];
            } else {
                _self->noDataLabel.hidden = NO;
                //                _self.noDataNotice.text = @"你还没有直播过哦";
                //                _self.noDataNotice.hidden = NO;
            }
        } else {
            NSLog(@"get play back %@",responseDic[@"msg"]);
        }
        
        _self.list = _self.liveArray;
        [_self.tableView reloadData];
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        NSLog(@"get play back error =%@",error);
        ESStrongSelf;
        _self->_isLoading = NO;
        if (_self.liveArray) {
            _self.list = _self.liveArray;
        }
        else
        {
            _self.list = [NSMutableArray array];
        }
        
        [_self.tableView reloadData];
    };
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"uid":_userId,@"page":@(page)}
                                                  withPath:URL_CALLBACK_LIVE_LIST
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}

#pragma mark - 显示私聊
- (void) showPrivAction
{
    if (!nickName) {
        return;
    }
    
    NSMutableDictionary * userInfoDict = [NSMutableDictionary dictionary];
    [userInfoDict setObject:_userId forKey:@"uid"];
    [userInfoDict setObject:nickName forKey:@"nickname"];
    [userInfoDict setObject:faceUrl forKey:@"face"];
    
    [[[ChatViewController alloc] initWithUserInfoDictionary:userInfoDict] pushFromNavigationController:self.navigationController animated:YES];
}

#pragma mark - 开始1v1
- (void) startOneToOneAction
{
    if (!isOpenOneToOne) {
        [LCNoticeAlertView showMsg:@"此玩家暂未开通1v1视频聊天！"];
        return;
    }
    
    [self startRequestOVO];
}

#pragma mark - 邀请1v1
- (void) startRequestOVO
{
    if (![[Common sharedInstance] isCanRequestOTOTime:_userId]) {
        [LCNoticeAlertView showMsg:@"您请求的时间太频繁！请稍后再试。。。"];
        return;
    }
    
    isReqInvite = YES;
    
    ESWeakSelf;
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"anchor":_userId,@"user":[LCMyUser mine].userID}  withPath:URL_OVO_SIGN withRESTful:GET_REQUEST withSuccessBlock:^(NSDictionary *responseDic) {
        ESStrongSelf;
        _self->isReqInvite = NO;
        NSLog(@" URL_OVO_SIGN res %@", responseDic);
        NSString *userAuthString = [responseDic objectForKey:@"user_url"];
        NSString *liveAuthString = [responseDic objectForKey:@"live_url"];
        NSString *queryDomainString = [responseDic objectForKey:@"domain_url"];
        
        if (userAuthString && liveAuthString && queryDomainString && [responseDic[@"stat"] intValue] == 200)
        {
            [self showIsStartOTODialog:responseDic[@"msg"] withQueryDomain:queryDomainString with:userAuthString];
        }
        else
        {
            if ([responseDic[@"stat"] intValue] == 520) {// 余额不足
                [_self showNoMoney];
            } else if ([responseDic[@"stat"] intValue] == 502) {// 未开通
                [LCNoticeAlertView showMsg:responseDic[@"msg"]];
            } else {
                [LCNoticeAlertView showMsg:responseDic[@"msg"]];
            }
        }
    } withFailBlock:^(NSError *error) {
        ESStrongSelf;
        _self->isReqInvite = NO;
        [LCNoticeAlertView showMsg:@"请求服务器失败"];
    }];
    
}

// 显示是否开始oto
- (void) showIsStartOTODialog:(NSString *)msg withQueryDomain:(NSString *)queryDomain with:(NSString *)authString
{
    ESWeakSelf;
    UIAlertView *alert = [UIAlertView alertViewWithTitle:@"提示" message:msg cancelButtonTitle:@"取消" didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex)
                          {
                              ESStrongSelf;
                              if(buttonIndex == 0)
                              {
                                   [[Common sharedInstance] saveRequestOTOTime:_self.userId];
                                  ChatUser *chatUser = [[ChatUser alloc] initWithUserId:_self.userId];
                                  chatUser.nickname = _self->nickName;
                                  chatUser.avatarUrl = _self->faceUrl;
                                  [chatUser save];
                                  
                                  OVOInviteViewController *inviteVC = [[OVOInviteViewController alloc] init];
                                  inviteVC.receiverChatUser = chatUser;
                                  inviteVC.queryDomainString = queryDomain;
                                  inviteVC.userAuthString = authString;
                                  [_self.navigationController pushViewController:inviteVC animated:YES];
                              }
                          }
                                       otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void) showNoMoney
{
    ESWeakSelf;
    UIAlertView *alert = [UIAlertView alertViewWithTitle:ESLocalizedString(@"提示") message:ESLocalizedString(@"余额不足，请充值！") cancelButtonTitle:ESLocalizedString(@"确认") didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        ESStrongSelf;
        RechargeViewController *rechargeVC = [[RechargeViewController alloc] init];
        [_self.navigationController pushViewController:rechargeVC animated:YES];
    } otherButtonTitles:nil, nil];
    [alert show];
}



@end
