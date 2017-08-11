//
//  LCBlackListController.m
//  XCLive
//
//  Created by ztkztk on 14-5-13.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCBlackListController.h" 


@interface LCBlackListController ()

@end

@implementation LCBlackListController


-(void)dealloc
{
//    [[LCHTTPClient sharedHTTPClient] cancelAllHTTPOperationsWithMethod:nil path:blackListURL()];
    
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
    self.title=ESLocalizedString(@"黑名单");
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    //    self.tableView.separatorColor=[UIColor colorWithRed:241.0/255 green:232.0/255 blue:207.0/255 alpha:1.0];
    self.tableView.rowHeight = CELL_HEIGHT;
    
    // Do any additional setup after loading the view.
    [self getBlackList];
}

#pragma mark - Subclass
-(void)getBlackList
{
    ESWeakSelf;
    [[RCIMClient sharedRCIMClient] getBlacklist:^(NSArray *blockUserIds) {
        ESStrongSelf;
        [_self getUserList:blockUserIds];
    } error:^(RCErrorCode status) {
    }];
}

- (void) getUserList:(NSArray *)userIDs
{
    if (!userIDs) {
        return;
    }
    
    NSString *uids = [userIDs componentsJoinedByString:@","];
    
    ESWeakSelf;
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"uid": uids,@"pf":@"android"} withPath:@"home/userinfo" withRESTful:GET_REQUEST withSuccessBlock:^(NSDictionary *responseDic) {
        ESStrongSelf;
        if (200 == [responseDic[@"stat"] intValue]) {
            NSArray *array = responseDic[@"userinfo"];
            if (array && array.count > 0) {
                [_self.list addObjectsFromArray:array];
                [_self.tableView reloadData];
            } else {
                _self.noDataNotice.text = ESLocalizedString(@"主人您还没添加黑名单！");
                _self.noDataNotice.hidden = NO;
            }
        } else {
        }
    } withFailBlock:nil];
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
    
    ManagerUserCell *cell = (ManagerUserCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        
        /*
         
         [leftUtilityButtons addUtilityButtonWithColor:[UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0] icon:[UIImage imageNamed:@"check.png"]];
         [leftUtilityButtons addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:1.0] icon:[UIImage imageNamed:@"clock.png"]];
         [leftUtilityButtons addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0] icon:[UIImage imageNamed:@"cross.png"]];
         [leftUtilityButtons addUtilityButtonWithColor:[UIColor colorWithRed:0.55f green:0.27f blue:0.07f alpha:1.0] icon:[UIImage imageNamed:@"list.png"]];
         
         */
        
        [rightUtilityButtons addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f] title:ESLocalizedString( @"删除")];
        
        cell = [[ManagerUserCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:identifier
                                               height:self.tableView.rowHeight
                                   leftUtilityButtons:nil
                                  rightUtilityButtons:rightUtilityButtons];
        cell.delegate = self;
    }
    
    cell.myCell.userInfoDict=self.list[indexPath.row];
    cell.myCell.lineView.hidden = NO;
    cell.myCell.attentStateBtn.hidden = YES;
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
            //           [self deleteFriend:cellIndexPath];
            NSLog(@"delete_manager%d",(int)cellIndexPath.row);
            [self removeBlackUser:cellIndexPath];
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


-(void)removeBlackUser:(NSIndexPath *)indexPath
{
    ESWeakSelf;
    [[RCIMClient sharedRCIMClient] removeFromBlacklist:self.list[indexPath.row][@"uid"] success:^{
        ESStrongSelf;
        ESDispatchOnMainThreadAsynchrony(^{
            ESStrongSelf;
            [_self.list removeObjectAtIndex:indexPath.row];
            
            if([_self.list count]!=0)
                [_self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            else{
                [_self.tableView reloadData];
            }
        });
    } error:^(RCErrorCode status) {
        NSLog(@"blcak code:%d",(int)status);
    }];
}


@end
