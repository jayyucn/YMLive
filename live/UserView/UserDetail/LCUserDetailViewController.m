//
//  LCUserDetailViewController.m
//  XCLive
//
//  Created by ztkztk on 14-4-30.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCUserDetailViewController.h"
//#import "LCPhotoScrollController.h"
#import "LCUserDetailViewController+TabBarOperate.h"
#import "LCInsetsLabel.h"
#import "LCUserInfoViewController.h"
//#import "LCVIPIntroViewController.h"
#import "UserGiftCell.h"
//#import "GiftRootViewController.h"
#import "LCMineDateCell.h"
//#import "DatesDetailViewController.h"
//#import "MyDatesDetailViewController.h"
//#import "LCChatVoiceRecorderManager.h"
//#import "LiveShowRootViewController.h"
@interface LCUserDetailViewController ()
{
    BOOL isOpenGiftView;
    BOOL _previousControllerIsLiveShow; // 当前界面的上一个界面是否是直播间
}
@end

@implementation LCUserDetailViewController


+(id)userDetailAutoPlayVideo:(NSDictionary *)dic
{
    LCUserDetailViewController *userDetailController=[LCUserDetailViewController userDetail:dic];
    userDetailController.autoPlayVideo=YES;
    return userDetailController;
}

+(id)userDetail:(NSDictionary *)dic
{
    LCUserDetailViewController *userDetailController=[[LCUserDetailViewController alloc] initWithStyle:UITableViewStyleGrouped
                                                    hasRefreshControl:NO];
    
    
#if 0// -Elf, uid是NSNumber, it will crash on "LCUserDetailViewController+TabBarOperate.m" -doAction: (isEqualToString:)
    userDetailController.userID=dic[@"uid"];
    userDetailController.title=dic[@"nickname"];
#else
    NSString *uid;
    ESStringVal(&uid, dic[@"uid"]);
    userDetailController.userID = uid;
    NSString *nickname;
    ESStringVal(&nickname, dic[@"nickname"]);
    userDetailController.title = nickname;
    userDetailController.userName = nickname;
#endif
    return userDetailController;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [[LCHTTPClient sharedHTTPClient] cancelAllHTTPOperationsWithMethod:nil path:getBaseURL()];
//    [[LCHTTPClient sharedHTTPClient] cancelAllHTTPOperationsWithMethod:nil path:addFriendURL()];
//    [[LCHTTPClient sharedHTTPClient] cancelAllHTTPOperationsWithMethod:nil path:deleteFriendURL()];
//    [[LCHTTPClient sharedHTTPClient] cancelAllHTTPOperationsWithMethod:nil path:reportURL()];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.title=_userDic[@"nickname"]; 
//    self.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _detailHeaderView=[[LCDetailHeaderView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,300)];
    
    ESWeakSelf;
    _detailHeaderView.playVideoBlock = ^(NSString *videoPath)
    {
        ESStrongSelf;
        [_self playVideo:videoPath];
    };
    
//    [_detailHeaderView.liveImage addTapGestureHandler:^(UITapGestureRecognizer *gestureRecognizer, UIView *view, CGPoint locationInView)
//     {
//         ESStrongSelf;
//#if 0 //-elf, 不管进谁的房间，都重新加载, 这样可以临时解决很多跳转bug和liveRoot里状态值bug
//         LiveShowRoomViewController *room = [LiveShowRootViewController getCurrentRoom];
//         if([DataManager sharedManager].moreActionType != ShowNomalMoreAction)
//         {
//             //说明在里面诶
//             
//             
//             if (![_self.userID isEqualToString:room.roomInfoModel.uid])
//             {
//                 //用户想到另一个用户的房间里去
//                 [_self goUserRoomFromDetail];
//             }
//             else
//             {
//                //还是返回到自己房间
//                 [_self.navigationController popViewControllerAnimated:YES];
//             }
//         }
//         else
//         {
//             [_self goUserRoomFromDetail];
//         }
//#else
////         [_self goUserRoomFromDetail];
//#endif
//     }];

    self.tableView.tableHeaderView = _detailHeaderView;
    
    _tabBar = [LCCustomTabBar customTabBarWithTapBarBlock:^(NSString *title)
             {
                 ESStrongSelf;
                 [_self doAction:title];
             }];
    
    [self.view addSubview:_tabBar];
    _tabBar.bottom = self.view.height ;
    self.tableView.height -= _tabBar.height + 25;
    self.tableView.alpha = 0.0f;
//    
//    _coupleRootView=[[MatchCoupleRootView alloc] init];
//    [self.view addSubview:_coupleRootView];
//    _coupleRootView.hidden=YES;
////    ESWeakSelf;
////    _coupleRootView.showCoupleBlock=^(NSDictionary *user){
////        ESStrongSelf;
////        [_self showUserDetail:user];
////    };
//    
//    _coupleRootView.matchView.viewController=self;
    
}

- (void)goUserRoomFromDetail
{
//#if 1 //-elf
//    _previousControllerIsLiveShow = NO; // 防止重复刷新直播间（见willMoveToParentViewController)
//#endif
//    
//    [DataManager sharedManager].jumpRoomID = self.userID;
//    [DataManager sharedManager].moreActionType = ShowSimpleMoreAction;
//    self.navigationController.tabBarController.selectedIndex = 2;
//    [self.navigationController popToRootViewControllerAnimated:NO];
//    NSDictionary *dic = @{@"controller":self};
//#if 0 //-elf, 第一次启动app，从聊天进直播间，要等liveRootVC viewDidAppear
//    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_TabbarSelect object:nil userInfo:dic];
//#else
//    
//    NSString *toUserID = self.userID;
//    [MBProgressHUD showHUDAddedTo:[LCCore keyWindow] animated:YES];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [MBProgressHUD hideHUDForView:[LCCore keyWindow] animated:NO];
//        
//        [DataManager sharedManager].jumpRoomID = toUserID;
//        [DataManager sharedManager].moreActionType = ShowSimpleMoreAction;
//        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_TabbarSelect object:nil userInfo:dic];
//    });
//#endif
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    isOpenGiftView = NO;
    [self getUserDetail];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(lookPhotoDetail:)
                                                 name:NotificationMsg_LookPhoto
                                               object:nil];
#if 1 //-elf
//    if ([self.previousViewController isKindOfClass:[LiveShowRootViewController class]]) {
//        _previousControllerIsLiveShow = YES;
//    }
#endif
}

#if 1 //-elf
- (void)willMoveToParentViewController:(UIViewController *)parent
{
    if (!parent && _previousControllerIsLiveShow) {
        _previousControllerIsLiveShow = NO;
        // 导航栏的返回操作，并且上级界面是直播间
//        if ([LiveShowRootViewController getCurrentRoom]) {
//            NSString *toUserID = [LiveShowRootViewController getCurrentRoom].roomID;
//            KeyboardMoreActionType toType = [DataManager sharedManager].moreActionType;
//            [MBProgressHUD showHUDAddedTo:[LCCore keyWindow] animated:YES];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [MBProgressHUD hideHUDForView:[LCCore keyWindow] animated:NO];
//                
//                [DataManager sharedManager].jumpRoomID = toUserID;
//                [DataManager sharedManager].moreActionType = toType;
//                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_TabbarSelect object:nil userInfo:nil];
//            });
//        }
    }
}
#endif


-(void)playVideo:(NSString *)videoPath
{
//    [[ESSpeexPlayer sharedPlayer] stop];
    
    if (![self.userID isEqualToString:[LCMyUser mine].userID] &&
        ![LCMyUser mine].isVIP) {
        ESWeakSelf;
        UIAlertView *alert = [UIAlertView alertViewWithTitle:@"升级VIP" message:@"不是会员没办法看Ta的个性视频呢(T ^ T)要不要开通会员，从此视频聊天无障碍？" cancelButtonTitle:@"继续屌丝" didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            ESStrongSelf;
            if (buttonIndex != alertView.cancelButtonIndex) {
//                [_self.navigationController pushViewController:[[LCVIPIntroViewController alloc] init] animated:YES];
            }
        } otherButtonTitles:@"升级会员", nil];
        [alert show];
        return;
    }
    
    if(!_playerController)
    {
        
        [_detailHeaderView startLoadingAnimation];
        //视频播放对象
        _playerController = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:videoPath]];
        _playerController.controlStyle = MPMovieControlStyleNone;
        [_playerController.view setFrame:CGRectMake(0, 0,ScreenWidth,ScreenWidth)];
        _playerController.initialPlaybackTime = -1;
        _playerController.view.centerX = ScreenWidth/2.f;
        
        [self.view addSubview:_playerController.view];
        // 注册一个播放结束的通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(myMovieFinishedCallback:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:_playerController];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayerPreloadFinish:)
                                                     name:MPMoviePlayerReadyForDisplayDidChangeNotification
                                                   object:_playerController];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayerLoadStateChanged:)
                                                     name:MPMoviePlayerLoadStateDidChangeNotification
                                                   object:_playerController];
        
        _playerController.view.hidden=YES;
        [_playerController prepareToPlay];
        return;
    }

    [_playerController play];
    _playerController.view.hidden = NO;

}

- (void) moviePlayerLoadStateChanged:(NSNotification*)notification
{
    // Unless state is unknown, start playback
    if ([_playerController loadState] != MPMovieLoadStateUnknown)
    {
        [_playerController play];
    }
}

-(void)moviePlayerPreloadFinish:(NSNotification*)notification{
    //添加你的处理代码
    _playerController.view.hidden = NO;
    [_detailHeaderView stopLoadingAnimation];
    
}
-(void)myMovieFinishedCallback:(NSNotification*)notify
{
    _playerController.view.hidden = YES;
}

-(void)lookPhotoDetail:(NSNotification*)notify
{
    NSDictionary *notiDic=notify.userInfo;
    if(notiDic)
    {
        int order=0;
        NSString *idStr = NSStringWith(@"%@",notiDic[@"id"]);
        if (![idStr isEqualToString:@"0"])
        {
            for(NSDictionary *dic in _userDic[@"photo"])
            {
                if([dic[@"id"] isEqualToString:notiDic[@"id"]])
                {
                    break;
                }
                order++;
            }
//            LCPhotoScrollController *photoController=[LCPhotoScrollController showPhotoController:_userDic[@"userinfo"]
//                                                                                        withOrder:order
//                                                                                        withTotal:(int)[_userDic[@"photo"] count]];
//            [self.navigationController pushViewController:photoController animated:YES];
        }
        else
        {
            [self inviteUserUpdatePhoto];
        }
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)setUserDic:(NSDictionary *)userDic
{
    _userDic=userDic;
    
    if(_autoPlayVideo)
    {
        NSString *videoPath = @"";
        ESStringVal(&videoPath, userDic[@"userinfo"][@"video"]);
        
        if(![videoPath isEqualToString:@""])
        {
            [self playVideo:videoPath];
        }
    }
    
#if 1 // -Elf, set navigation title with nickname
    NSString *nickname = nil;
    if (ESStringVal(&nickname, userDic[@"userinfo"][@"nickname"])) {
        self.navigationItem.title = nickname;
    }
#endif
    
    [[LCMyUser mine] setMyPercent:userDic[@"percent"]];
    
    //[[LCMyUser mine] setMyPercent:@(70)];
    [self creatList];
    
    NSLog(@"self.list=====%@",self.list);
    [self.tableView reloadData];
    [_detailHeaderView showData:userDic[@"userinfo"] photos:userDic[@"photo"]];
    
    self.tableView.tableHeaderView=_detailHeaderView;
    int visit = 0;
    ESIntVal(&visit, userDic[@"visit"]);

    if(visit==1)
    {
        
        __unused NSDictionary *data=@{@"type":@"visit",\
                             @"uid":[LCMyUser mine].userID,\
                             @"recv":_userID};
        //        NSDictionary *socketDic=[data addRadarLatAndLon];
        //        [[KFSocketManager defaultManager] writeJSON:data];
        
    }
    
    /*
     NSDictionary *data=@{@"type":@"visit",\
     @"uid":[LCMyUser mine].userID,\
     @"recv":_userID};
     //NSDictionary *socketDic=[data addRadarLatAndLon];
     [[KFSocketManager defaultManager] writeJSON:data];
     */
    
    int allow_match = 1;
    ESIntVal(&visit, userDic[@"userinfo"][@"allow_match"]);
    
    NSArray *icons;
    
    if(allow_match == 0)
    {
        icons=@[@{@"title":@"聊天",@"icon":@"image/globle/InfoToolBarChatIcon"},
                @{@"title":@"关注",@"icon":@"image/globle/InfoToolBarUnFollowed"},
                @{@"title":@"更多",@"icon":@"image/globle/InfoToolBarMoreIcon"}];
        
    }
    else
    {
        if([LCCore globalCore].isAppStoreReviewing)
        {
            icons=@[@{@"title":@"聊天",@"icon":@"image/globle/InfoToolBarChatIcon"},
                    @{@"title":@"夫妻相",@"icon":@"image/globle/couple"},
                    @{@"title":@"关注",@"icon":@"image/globle/InfoToolBarUnFollowed"},
                    @{@"title":@"更多",@"icon":@"image/globle/InfoToolBarMoreIcon"}];
            
        }
        else
        {
            icons=@[@{@"title":@"聊天",@"icon":@"image/globle/InfoToolBarChatIcon"},
                    @{@"title":@"礼物",@"icon":@"image/globle/InfoToolBarGiftIcon"},
                    @{@"title":@"夫妻相",@"icon":@"image/globle/couple"},
                    @{@"title":@"关注",@"icon":@"image/globle/InfoToolBarUnFollowed"},
                    @{@"title":@"更多",@"icon":@"image/globle/InfoToolBarMoreIcon"}];
        }
      
    }
    _tabBar.items=icons;
    
    
    int atten = 0;
    ESIntVal(&atten, userDic[@"atten"]);
    self.atten=atten;
    
    
    
    
    /*
     
     NSDictionary *data=@{@"type":@"visit",\
     @"uid":[LCMyUser mine].userID,\
     @"recv":_userID};
     
     NSDictionary *socketDic=[data addRadarLatAndLon];
     [[KFSocketManager defaultManager] writeJSON:socketDic];
     
     */
    
}

-(void)creatList
{
    [self.list removeAllObjects];
    if(ESIsStringWithAnyText(self.userDic[@"userinfo"][@"ithink"])) {
        [self.list addObject:@{@"title":@"我想",\
                               @"content":self.userDic[@"userinfo"][@"ithink"]}];
    }
    
    if(ESIsStringWithAnyText(self.userDic[@"userinfo"][@"height"])) {
        [self.list addObject:@{@"title":@"身高",\
                               @"content":[NSString stringWithFormat:@"%@cm",self.userDic[@"userinfo"][@"height"]]}];
    }
    
    if(ESIsStringWithAnyText(self.userDic[@"userinfo"][@"stature"])) {
        [self.list addObject:@{@"title":@"体型",\
                               @"content":self.userDic[@"userinfo"][@"stature"]}];
    }
    
    
    NSString *dubai = @"";
    ESStringVal(&dubai, self.userDic[@"userinfo"][@"dubai"]);
    
    if(![dubai isEqualToString:@""])
    {
        [self.list addObject:@{@"title":@"独白",\
                               @"content":self.userDic[@"userinfo"][@"dubai"]}];
        
    }
    
    if([LCMyUser mine].percent<80)
        return;
    
    if(self.userDic[@"userinfo"][@"privacy"]&&[self.userDic[@"userinfo"][@"privacy"] isKindOfClass:[NSArray class]])
    {
        for(NSString *aString in self.userDic[@"userinfo"][@"privacy"])
        {
            if(aString&&[aString isKindOfClass:[NSString class]])
            {
                NSArray *array=[aString componentsSeparatedByString:@":"];
                
                [self.list addObject:@{@"title":array[0],\
                                       @"content":array[1]}];
            }
        }
    }
}

-(void)setAtten:(int)atten
{
    _atten=atten;
    
    if(_atten==0)
    {
        [_tabBar showfollow];
    }else{
        [_tabBar showDeleteFollow];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(!_userDateDic)
    {
        if(section==0)
        {
            return [self returnSectionView];
        }
    }
    else
    {
        if(section == 1)
        {
            return [self returnSectionView];
        }
        
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_userDateDic && !_userGiftArray)
    {
        return 2;
    }
    
    if (!_userDateDic && _userGiftArray)
    {
        if([LCCore globalCore].isAppStoreReviewing)
        {
            return 1;
        }
        else
        {
            return 2;
        }
    }
    
    if (!_userDateDic && !_userGiftArray)
    {
        return 1;
    }
    
    if ([LCCore globalCore].isAppStoreReviewing)
    {
        return 2;
    }
    else
    {
        return 3;
    }
    
    return 3;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if (!_userDateDic)
    {
        if (section == 0)
        {
            if([LCMyUser mine].percent<80)
            {
                if([self.list count]==0)
                    return 0;
                else
                    return [self.list count] + 1;
            }
            else
            {
                return [self.list count];
            }
            
        }
        else
        {
            return 1;
        }
    }
    else
    {
        if (section == 1)
        {
            if([LCMyUser mine].percent<80)
            {
                if([self.list count]==0)
                    return 0;
                else
                    return [self.list count] + 1;
            }
            else
            {
                return [self.list count];
            }
            
        }
        else
        {
            return 1;
        }
        
    }
    
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_userDateDic)
    {
        if (indexPath.section == 0)
        {
            static NSString *dateIndentifier=@"mineDateCell";
            
            LCMineDateCell *dateCell = [tableView dequeueReusableCellWithIdentifier:dateIndentifier];
            if (!dateCell)
            {
                dateCell = [[[NSBundle mainBundle] loadNibNamed:@"LCMineDateCell" owner:nil options:nil] firstObject];
            }
            dateCell.dotPlaceLabel.text = _userDateDic[@"address"];
            dateCell.dotTimeLabel.text = _userDateDic[@"time"];
            dateCell.nameLabel.text = _userDateDic[@"theme"];
            int themeType = [[NSString stringWithFormat:@"%@",_userDateDic[@"type"]] intValue];
            
            dateCell.themeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"date_feed_subject_%d",themeType]];
            return dateCell;
        }
        else if (indexPath.section == 1)
        {
            if([LCMyUser mine].percent < 80 && indexPath.row==[self.list count])
            {
                static NSString *identifier=@"MoreCell";
                LCMoreDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[LCMoreDetailCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:identifier];
                    [cell setAccessoryType:UITableViewCellAccessoryNone];
                    // 取消选择模式
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }
                return cell;
            }
            else
            {
                static NSString *identifier=@"cell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                reuseIdentifier:identifier];
                    [cell setAccessoryType:UITableViewCellAccessoryNone];
                    // 取消选择模式
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.textLabel.textColor=[UIColor grayColor];
                    cell.detailTextLabel.textColor=[UIColor blackColor];
                    
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
                    cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
                    //cell.textLabel.numberOfLines = 0;
                    //cell.detailTextLabel.numberOfLines = 0;
                }
                
                [self loadCellData:cell withIndexPath:indexPath];
                
                cell.textLabel.numberOfLines = 0;
                cell.detailTextLabel.numberOfLines = 0;
                [cell.textLabel sizeToFit];
                cell.detailTextLabel.width = cell.contentView.width - 45.f;
                //[cell.detailTextLabel sizeToFit];
                return cell;
            }
        }
        else
        {
            if(![LCCore globalCore].isAppStoreReviewing)
        {
        
            static NSString *cellIndentifier = @"giftCell";
            UserGiftCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (!cell)
            {
                cell = [[UserGiftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            }
            
            cell.showGiftDetailBlock = ^{
                if (isOpenGiftView) {
                    return;
                }
                isOpenGiftView = YES;
//                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Gift" bundle:nil];
//                GiftRootViewController *gift = [storyBoard instantiateViewControllerWithIdentifier:@"GiftRootViewController"];
//                gift.isScanner = YES;
//                gift.personID = self.userID;
//                [self.navigationController pushViewController:gift animated:YES];
            };
            [cell initView:self.userGiftArray];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            return cell;

        }
    
        }
    }
    else
    {
        if(indexPath.section == 0)
        {
            if([LCMyUser mine].percent<80 && indexPath.row==[self.list count])
            {
                static NSString *identifier=@"MoreCell";
                LCMoreDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[LCMoreDetailCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:identifier];
                    [cell setAccessoryType:UITableViewCellAccessoryNone];
                    // 取消选择模式
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }
                return cell;
            }
            else
            {
                static NSString *identifier=@"cell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                reuseIdentifier:identifier];
                    [cell setAccessoryType:UITableViewCellAccessoryNone];
                    // 取消选择模式
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.textLabel.textColor=[UIColor grayColor];
                    cell.detailTextLabel.textColor=[UIColor blackColor];
                    
                    cell.textLabel.font=[UIFont boldSystemFontOfSize:14];
                    cell.detailTextLabel.font=[UIFont systemFontOfSize:16];
                }
                
                [self loadCellData:cell withIndexPath:indexPath];
                
                cell.textLabel.numberOfLines = 0;
                cell.detailTextLabel.numberOfLines = 0;
                [cell.textLabel sizeToFit];
                cell.detailTextLabel.width = cell.contentView.width - 45.f;
                //[cell.detailTextLabel sizeToFit];
                return cell;
            }
        }
        else
        {
            if(![LCCore globalCore].isAppStoreReviewing)
            {
                static NSString *cellIndentifier = @"giftCell";
                UserGiftCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
                if (!cell)
                {
                    cell = [[UserGiftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
                }
                
                cell.showGiftDetailBlock = ^{
                    if (isOpenGiftView) {
                        return;
                    }
                    isOpenGiftView = YES;

//                    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Gift" bundle:nil];
//                    GiftRootViewController *gift = [storyBoard instantiateViewControllerWithIdentifier:@"GiftRootViewController"];
//                    gift.isScanner = YES;
//                    gift.personID = self.userID;
//                    [self.navigationController pushViewController:gift animated:YES];
//
                };

                
                [cell initView:self.userGiftArray];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                return cell;

            }
        }
    }
    
    return 0;
}
-(void)loadCellData:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    
    if([LCMyUser mine].percent<80 && indexPath.row==[self.list count])
        return;
    cell.textLabel.text=self.list[indexPath.row][@"title"];
    cell.detailTextLabel.text=self.list[indexPath.row][@"content"];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == _convertSectionIndex + 1)
//    {
//        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Gift" bundle:nil];
//        GiftRootViewController *gift = [storyBoard instantiateViewControllerWithIdentifier:@"GiftRootViewController"];
//        gift.isScanner = YES;
//        gift.personID = self.userID;
//        [self.navigationController pushViewController:gift animated:YES];
//    }
    
    
    if (indexPath.section == _convertSectionIndex)
    {
        if([LCMyUser mine].percent < 80 && indexPath.row==[self.list count])
        {
            ESWeakSelf;
            UIAlertView *alert = [UIAlertView alertViewWithTitle:@"提示" message:@"您需要完善自己80%以上的个人资料或者升级VIP，才能查看TA更多个人资料哦" cancelButtonTitle:@"升级VIP" didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                ESStrongSelf;
                if (buttonIndex != alertView.cancelButtonIndex) {
                    LCUserInfoViewController *usrInfoViewController=[[LCUserInfoViewController alloc] initWithStyle:UITableViewStyleGrouped hasRefreshControl:NO];
                    [_self.navigationController pushViewController:usrInfoViewController animated:YES];
                }
                else
                {
//                         [_self.navigationController pushViewController:[[LCVIPIntroViewController alloc] init] animated:YES];
                }
            } otherButtonTitles:@"完善资料", nil];
            [alert show];
        }
    }
    
    if (_convertSectionIndex == 1)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (indexPath.section == _convertSectionIndex - 1)
        {
            
            __unused UIStoryboard *stroyBoard = [UIStoryboard storyboardWithName:@"Dates" bundle:nil];
            
            if (![_userID isEqualToString:[LCMyUser mine].userID])
            {
//                DatesDetailViewController *detailVC = [stroyBoard instantiateViewControllerWithIdentifier:@"DatesDetailViewController"];
//                detailVC.datesID =  NSStringWith(@"%@",_userDateDic[@"id"]);
//                
//                detailVC.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:detailVC animated:YES];
            }
            else
            {
//                MyDatesDetailViewController *detailVC = [stroyBoard instantiateViewControllerWithIdentifier:@"MyDatesDetailViewController"];
//                detailVC.datesID =  NSStringWith(@"%@",_userDateDic[@"id"]);
//                
//                [self.navigationController pushViewController:detailVC animated:YES];
                
            }
        }
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!_userDateDic)
    {
        if (indexPath.section == 1)
        {
            int count = (int)[self.userGiftArray count] / 4;
            float index = [self.userGiftArray count] / 4.0;
            if (index > count)
            {
                count += 1;
            }
            return 60 * count;
        }
        
        if([LCMyUser mine].percent<80&&indexPath.row==[self.list count])
            return 43;
        
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        
        NSString *text = self.list[indexPath.row][@"content"];
        
        
        CGSize constraint = CGSizeMake(cell.contentView.width - 45.f, CGFLOAT_MAX);
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:16.0f]
                       constrainedToSize:constraint
                           lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
        
        return MAX(60, ceilf(size.height) + 40);
    }
    else
    {
        if (indexPath.section == 2)
        {
            int   count = (int)[self.userGiftArray count] / 4;
            float index = [self.userGiftArray count] / 4.0;
            if (index > count)
            {
                count += 1;
            }
            return 60 * count;
        }
        if (indexPath.section == 1)
        {
            if([LCMyUser mine].percent<80&&indexPath.row==[self.list count])
                return 43;
            
            UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            
            NSString *text = self.list[indexPath.row][@"content"];
            
            
            CGSize constraint = CGSizeMake(cell.contentView.width - 45.f, CGFLOAT_MAX);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:16.0f]
                           constrainedToSize:constraint
                               lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
            
            
            return MAX(60, ceilf(size.height) + 40);
        }
        
        if (indexPath.section == 0)
        {
            return 92.f;
        }
        
    }
    return 0;
}

-(UIView *)returnSectionView
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,35)];
    LCInsetsLabel *sectionFooterLabel=[[LCInsetsLabel alloc] initWithFrame:CGRectMake(0,0,ScreenWidth/2,35) andInsets:UIEdgeInsetsMake(3,12,0,12)];
    sectionFooterLabel.textAlignment = NSTextAlignmentLeft;
    sectionFooterLabel.textColor=[UIColor colorWithRed:175.0/255 green:142.0/255 blue:93.0/255 alpha:1.0];
    sectionFooterLabel.font=[UIFont systemFontOfSize:16];
    sectionFooterLabel.backgroundColor =[UIColor clearColor];
    sectionFooterLabel.text=[NSString stringWithFormat:@"基本资料"];
    [sectionView addSubview:sectionFooterLabel];
    
    LCInsetsLabel *sectionIDLabel=[[LCInsetsLabel alloc] initWithFrame:CGRectMake(ScreenWidth/2,0,ScreenWidth/2,35) andInsets:UIEdgeInsetsMake(3,12,0,12)];
    sectionIDLabel.textAlignment = NSTextAlignmentRight;
    sectionIDLabel.textColor=[UIColor colorWithRed:175.0/255 green:142.0/255 blue:93.0/255 alpha:1.0];
    sectionIDLabel.font=[UIFont systemFontOfSize:16];
    sectionIDLabel.backgroundColor =[UIColor clearColor];
    sectionIDLabel.text=[NSString stringWithFormat:@"同城ID：%@",self.userDic[@"userinfo"][@"uid"]];
    [sectionView addSubview:sectionIDLabel];
    
    return sectionView;
}



@end
