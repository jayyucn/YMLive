//
//  RoomAudienceTableView.m
//  qianchuo 观众列表
//
//  Created by jacklong on 16/4/18.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "RoomAudienceTableView.h"
#import "UserSpaceViewController.h"

@interface RoomAudienceTableView(){
    BOOL isLoadMore;
    BOOL showing;
}
@end

@implementation RoomAudienceTableView

- (void)dealloc
{
    NSLog(@"dealloc %@",NSStringFromClass(self.class));
    [self removeFromSuperview];
}

- (instancetype)init {
    self = [super init];
//    isLoadMore = YES;
    showing = NO;
    return self;
}

- (void) loadAudienceData
{
    [self refreshData];
}

- (void) addUserToAudience:(LiveUser *)user
{
    if (!user) {
        return;
    }
    
    if (![self isExistUser:user.userId]) {
        [self.datas addObject:user];
        [self sortAudienceArray];
        
        // 更新可见区域的用户
        if ([self isReloadDataVisibleUser:user]) {
            [self reloadData];
        }
    }
}

// 更新可见区域的用户
- (BOOL) isReloadDataVisibleUser:(LiveUser *)user
{
    if (!self.datas || self.datas.isEmpty) {
        return NO;
    }
    
    if (self.datas.count <= 20) {
        return YES;
    }
    
    if (!self.reloadDataArray || self.reloadDataArray.isEmpty ) {
        self.reloadDataArray = [self.datas copy];
    
        return YES;
    }
    
    NSArray<NSIndexPath *> *indexPaths = [self indexPathsForVisibleRows];
    
    
    if (!indexPaths.isEmpty && [LCMyUser mine].liveOnlineUserCount > 15) {
        NSIndexPath *indexLastPath = indexPaths[indexPaths.count-1];
        NSIndexPath *indexFirstPath = indexPaths[0];
        
        if (indexLastPath.row < self.reloadDataArray.count) {
            LiveUser *liveLastUser = self.reloadDataArray[indexLastPath.row];
            LiveUser *liveFirstUser = self.reloadDataArray[indexFirstPath.row];
            if (indexFirstPath.row == 0 && user.grade >= liveFirstUser.grade) {
                return YES;
            }
            
            if ((user.grade >= liveLastUser.grade && user.grade <=liveFirstUser.grade)) {
                self.reloadDataArray = [self.datas copy];
                
                return  YES;
            } else {
                return NO;
            }
        } else {
            
            return NO;
        }
    } else {
        return NO;
    }
    
    
}

- (void)refreshData
{
    if (self.isLoading)
    {
        return;
    }
    self.currPage = 1;
    [self requestAudienceData:1];
}

- (void)loadData
{
    
    [self requestAudienceData:0];
}

- (void)requestAudienceData:(int)page
{
    if (self.isLoading)
    {
        return;
    }
    self.isLoading = YES;
    
    if (page == 0) {//加载更多
        page = self.currPage + 1;
    }
    
    ESWeakSelf;
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        ESStrongSelf;
        _self.isLoading = NO;
        if (URL_REQUEST_SUCCESS == [[responseDic objectForKey:@"stat"] integerValue])
        {
            NSArray* data = [responseDic objectForKey:@"list"];
            
            if(page == 1)
            {
                //刷新，如果是加载更多不用删除旧数据
                [_self.datas removeAllObjects];
                _self.reloadDataArray = [_self.datas copy];
            }
            
            if (page == 1 && (!data || (data && data.count <= 0))) {
                _self.currPage = 1;
                isLoadMore = NO;
                [_self reloadData];
                
            } else {
                _self.currPage = page;

                
                if (data && data.count > 0)
                {
                    if (data.count > 9) {
                        isLoadMore = YES;
                    } else {
                        isLoadMore = NO;
                    }
                    [_self addUserArray:data];
                } else {
                    isLoadMore = NO;
                }
            }
        }
        else
        {
            isLoadMore = NO;
            if (page == 1) {
                _self.currPage = 1;
                [_self.datas removeAllObjects];
                _self.reloadDataArray = [_self.datas copy];
                [_self reloadData];
            } else {
                [LCNoticeAlertView showMsg:responseDic[@"msg"]];
            }
        }
        
//        [_self.footer endRefreshing];
        _self.isLoading = NO;
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        ESStrongSelf;
        if (page == 1) {
            _self.currPage = 1;
            [_self.datas removeAllObjects];
            [_self reloadData];
        } else {
            [LCNoticeAlertView showMsg:@"获取数据失败！"];
        }
         isLoadMore = NO;
        _self.isLoading = NO;
    };
    
    NSString *roomUserId;
    if ([LCMyUser mine].playBackUserId) {
        roomUserId = [LCMyUser mine].playBackUserId;
    } else if ([LCMyUser mine].liveUserId) {
        roomUserId = [LCMyUser mine].liveUserId;
    }
    
    if (roomUserId) {
        NSDictionary *parameter =  @{@"liveuid":roomUserId,@"page":[NSNumber numberWithInt:page],@"vdoid":[LCMyUser mine].playVdoid?[LCMyUser mine].playVdoid:@""};
        
        [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameter
                                                      withPath:URL_LIVE_USERLIST
                                                   withRESTful:GET_REQUEST
                                              withSuccessBlock:successBlock
                                                 withFailBlock:failBlock];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiveUser *liveUser = self.datas[indexPath.row];
    
    NSString *userIdStr = [NSString stringWithFormat:@"%@",liveUser.userId];
    if (!userIdStr || userIdStr.length <= 0) {
        return;
    }
    liveUser.isInRoom = YES;

    if (_showUserBlock) {
        _showUserBlock(liveUser);
    }
//    UserSpaceViewController *onlineUserVC = [[UserSpaceViewController alloc] init];
//    onlineUserVC.liveUser = liveUser;
//    ESWeakSelf;
//    onlineUserVC.reViewBlock = ^(NSDictionary * userInfoDict) {
//        ESStrongSelf;
//        _self.reViewBlock(userInfoDict);
//    };
//    
//    onlineUserVC.privateChatBlock = ^(NSDictionary * userInfoDict) {
//        ESStrongSelf;
//        _self.privateChatBlock(userInfoDict);
//    };
//    onlineUserVC.gagUserBlock = _gagUserBlock;
//    onlineUserVC.addManagerBlock = _addManagerBlock;
//    onlineUserVC.removeManagerBlock = _removeManagerBlock;
//    
//    [[ESApp rootViewControllerForPresenting] popupViewController:onlineUserVC completion:nil];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"LiveRecvCell";
    
    AudienceUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[AudienceUserCell alloc]  initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:identifier];
        // 取消选择模式
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath  && indexPath.row < self.datas.count) {
        cell.liveUser = self.datas[indexPath.row];
      
        if ((indexPath.row == (self.datas.count - 1) ||
             (self.reloadDataArray && indexPath.row == (self.reloadDataArray.count-1))) && isLoadMore) {
            NSLog(@"indexpath row:%d  count:%d reloadDataArray:%d isLoadMore:%d",(int)indexPath.row,(int)self.datas.count,(int)self.reloadDataArray.count,isLoadMore);
            [self loadData];
        }
    }
   
    return cell;
}

- (void) addUserArray:(NSArray *)userArray
{
    NSArray *lus = [NSObject loadItem:[LiveUser class] fromArrayDictionary:userArray];
    
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
    
    for (LiveUser *user in lus)
    {
        if (user.userId) {
            [tempDict setObject:user forKey:user.userId];
        }
    }
    
    [self.datas addObjectsFromArray:[tempDict allValues]];
    
    [self sortAudienceArray];
    
    self.reloadDataArray = [self.datas copy];
    
    [self reloadData];
}

- (void) sortAudienceArray
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"userGrade" ascending:NO];//其中，userGrade为数组中的对象的属性，这个针对数组中存放对象比较更简洁方便
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    [self.datas sortUsingDescriptors:sortDescriptors];
}

- (BOOL)isExistUser:(NSString *)userId
{
    if (self.datas.count <= 0) {
        return  NO;
    }
    
    if (userId.length)
    {
        for(LiveUser *user in self.datas)
        {
            if([user.userId isEqualToString:userId])
            {
                return YES;
            }
        }
    }
    
    return NO;
}


@end
