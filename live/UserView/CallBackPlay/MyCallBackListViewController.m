//
//  MyCallBackListViewController.m
//  qianchuo
//
//  Created by jacklong on 16/8/8.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "MyCallBackListViewController.h"
#import "PlayCallBackViewController.h"

@interface MyCallBackListViewController(){
    BOOL isOpenPlayBack;
}
@end

@implementation MyCallBackListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"我的直播";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    self.tableView.separatorColor=[UIColor colorWithRed:241.0/255 green:232.0/255 blue:207.0/255 alpha:1.0];
    self.tableView.rowHeight = CELL_HEIGHT;
    
    // Do any additional setup after loading the view.
    [self getPlayBackList];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    isOpenPlayBack = NO;
}

#pragma mark - Subclass
-(void)getPlayBackList
{
    ESWeakSelf;
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        ESStrongSelf;
        if (200 == [responseDic[@"stat"] intValue]) {
            NSArray *array = responseDic[@"list"];
            if (array && array.count > 0) {
                [_self.list addObjectsFromArray:array];
                [_self.tableView reloadData];
            } else {
                _self.noDataNotice.text = @"你还没有直播过哦";
                _self.noDataNotice.textColor = UIColorWithRGB(160, 160, 160);
                _self.noDataImageView.image = [UIImage imageNamed:@"play_back_emtpy"];
                _self.noDataImageView.hidden = NO;
                _self.noDataNotice.hidden = NO;
            }
        } else {
            NSLog(@"get play back %@",responseDic[@"msg"]);
        }
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        NSLog(@"get play back error =%@",error);
 
    };
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"uid":[LCMyUser mine].userID,@"page":@(1)}
                                                  withPath:URL_CALLBACK_LIVE_LIST
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}



#pragma mark - Table view data source
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.list count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = CELL_ITIFIER;
    
    PlayBackManager *cell = (PlayBackManager *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        
        /*
         
         [leftUtilityButtons addUtilityButtonWithColor:[UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0] icon:[UIImage imageNamed:@"check.png"]];
         [leftUtilityButtons addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:1.0] icon:[UIImage imageNamed:@"clock.png"]];
         [leftUtilityButtons addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0] icon:[UIImage imageNamed:@"cross.png"]];
         [leftUtilityButtons addUtilityButtonWithColor:[UIColor colorWithRed:0.55f green:0.27f blue:0.07f alpha:1.0] icon:[UIImage imageNamed:@"list.png"]];
         
         */
        
        [rightUtilityButtons addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f] title:@"删除"];
        
        cell = [[PlayBackManager alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:identifier
                                               height:self.tableView.rowHeight
                                   leftUtilityButtons:nil
                                  rightUtilityButtons:rightUtilityButtons];
        cell.delegate = self;
    }
    
    cell.myCell.playBackInfoDict = self.list[indexPath.row];
    ESWeakSelf;
    cell.myCell.playBackBlock = ^(NSDictionary *dict) {
        ESStrongSelf;
        NSString *playUrl;
        ESStringVal(&playUrl,dict[@"url"]);
        if (!playUrl) {
            return;
        }
        if (isOpenPlayBack) {
            return;
        }
        
        isOpenPlayBack = YES;
        
        PlayCallBackViewController *playBackVC = [[PlayCallBackViewController alloc] init];
        playBackVC.playerCallBackUrl = playUrl;
        playBackVC.playVdoid = dict[@"id"];
        playBackVC.playerUid = [LCMyUser mine].userID;
        playBackVC.playBackDict = dict;
        
        [_self.navigationController pushViewController:playBackVC animated:YES];
    };
    return cell;
}

#pragma mark - Table view delegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *playUrl;
    ESStringVal(&playUrl,self.list[indexPath.row][@"url"]);
    if (!playUrl) {
        return;
    }
    
    PlayCallBackViewController *playBackVC = [[PlayCallBackViewController alloc] init];
    playBackVC.playerCallBackUrl = playUrl;
    [self.navigationController pushViewController:playBackVC animated:YES];
}

#pragma mark - SWTableViewDelegate

- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
            
    }
}

- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    switch (index) {
        case 0:
        {
            //           [self deleteFriend:cellIndexPath];
            NSLog(@"delete_manager%d",(int)cellIndexPath.row);
            [self removePlayBlackItem:cellIndexPath];
        }
            break;
        case 1:
        {
            break;
        }
        default:
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}


-(void)removePlayBlackItem:(NSIndexPath *)indexPath
{
    ESWeakSelf;
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        ESStrongSelf;
        if (200 == [responseDic[@"stat"] intValue]) {
            [_self.list removeObjectAtIndex:indexPath.row];
            
            if([_self.list count]!=0)
            {
                [_self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else
            {
                [_self.tableView reloadData];
            }
        } else {
            NSLog(@"get play back %@",responseDic[@"msg"]);
        }
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        NSLog(@"get play back error =%@",error);
        
    };
    
    
    NSDictionary *infoDict = self.list[indexPath.row];
    NSString *idStr;
    ESStringVal(&idStr,infoDict[@"id"]);
    if (idStr) {
        [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"id":idStr}
                                                      withPath:URL_DEL_CALLBACK_LIVE
                                                   withRESTful:GET_REQUEST
                                              withSuccessBlock:successBlock
                                                 withFailBlock:failBlock];
    }
}



@end
