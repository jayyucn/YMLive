//
//  ManagerListViewController.m
//  qianchuo
//
//  Created by jacklong on 16/4/20.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ManagerListViewController.h"

@implementation ManagerListViewController

- (void)dealloc
{
    NSLog(@"dealloc %@",NSStringFromClass(self.class));
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=ESLocalizedString(@"管理列表");
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    //    self.tableView.separatorColor=[UIColor colorWithRed:241.0/255 green:232.0/255 blue:207.0/255 alpha:1.0];
    self.tableView.rowHeight = CELL_HEIGHT;
    
    [self getManagerList];
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
    static NSString *identifier = CELL_ITIFIER;
    
    ManagerUserCell *cell = (ManagerUserCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        
        /*
         
         [leftUtilityButtons addUtilityButtonWithColor:[UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0] icon:[UIImage imageNamed:@"check.png"]];
         [leftUtilityButtons addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:1.0] icon:[UIImage imageNamed:@"clock.png"]];
         [leftUtilityButtons addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0] icon:[UIImage imageNamed:@"cross.png"]];
         [leftUtilityButtons addUtilityButtonWithColor:[UIColor colorWithRed:0.55f green:0.27f blue:0.07f alpha:1.0] icon:[UIImage imageNamed:@"list.png"]];
         
         */
        
        [rightUtilityButtons addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f] title:@"删除"];
        
        cell = [[ManagerUserCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                   reuseIdentifier:identifier
                                            height:self.tableView.rowHeight
                                leftUtilityButtons:nil
                               rightUtilityButtons:rightUtilityButtons];
        cell.delegate = self;
    }
    
    cell.myCell.userInfoDict=self.list[indexPath.row];
    cell.myCell.lineView.hidden = NO;
    return cell;
}



#pragma mark - Table view delegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
            NSLog(@"delete_manager%d",(int)cellIndexPath.row);
            [self removeManager:cellIndexPath];
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


-(void)getManagerList
{
    if (![LCMyUser mine].liveUserId) {
        return;
    }
    
    ESWeakSelf;
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        NSLog(@"manager list =%@",responseDic);
        
        ESStrongSelf;
        int stat=[responseDic[@"stat"] intValue];
        if(stat==200)
        {
            NSArray *responseArray=responseDic[@"list"];
            if([responseArray isKindOfClass:[NSArray class]]&&[responseArray count]>0)
            {
                [_self.list addObjectsFromArray:responseArray];
                
            }
            _self.loadMoreButton.hidden=YES;
            
            
            [_self.tableView reloadData];
            
            if([_self.list count]==0)
            {
                _self.noDataNotice.hidden=NO;
                _self.noDataImageView.hidden=NO;
                _self.noDataNotice.text = ESLocalizedString(@"您还没有添加管理员");
            }else{
                _self.noDataImageView.hidden=YES;
                _self.noDataNotice.hidden=YES;
            }
        }else{
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
            _self.loadMoreButton.hidden=YES;
            _self.isRefreshing=NO;
        }
        _self.isLoadingMore=NO;
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        NSLog(@"gagerror=%@",error);
        
        ESStrongSelf;
        _self.isRefreshing=NO;
        [_self.refreshHeaderView endRefreshing];
        _self.isLoadingMore=NO;
    };
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"liveuid":[LCMyUser mine].liveUserId}
                                                  withPath:URL_LIVE_MANAGER_LIST
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}

-(void)removeManager:(NSIndexPath *)indexPath
{
    if (![LCMyUser mine].liveUserId) {
        return;
    }
    
    ESWeakSelf;
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        NSLog(@"gagresponseDic=%@",responseDic);
        ESStrongSelf;
        int stat=[responseDic[@"stat"] intValue];
        if(stat==200)
        {
            _self.removeManagerInfoDict(_self.list[indexPath.row]);
            [_self.list removeObjectAtIndex:indexPath.row];
            
            if([_self.list count]!=0)
                [_self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            else{
                [_self.tableView reloadData];
            }
        }
        else
        {
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
        
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        NSLog(@"gagerror=%@",error);
        [LCNoticeAlertView showMsg:@"Error!"];
    };
    
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"user":self.list[indexPath.row][@"uid"],@"type":@"0",@"liveuid":[LCMyUser mine].liveUserId}
                                                  withPath:URL_LIVE_OPERATE_MANAGER
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}
@end
