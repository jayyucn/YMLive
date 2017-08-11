//
//  LCMyFootprintsViewController.m
//  XCLive
//
//  Created by ztkztk on 14-4-21.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCMyFootprintsViewController.h"
#import "LCMyFootprintsViewController+NetWork.h"
#import "LCFootprintsCell.h"
#import "LCUserDetailViewController.h"

@interface LCMyFootprintsViewController ()

@end

@implementation LCMyFootprintsViewController


-(void)dealloc
{
//    [[LCHTTPClient sharedHTTPClient] cancelAllHTTPOperationsWithMethod:nil path:footprintsURL()];
//    [[LCHTTPClient sharedHTTPClient] cancelAllHTTPOperationsWithMethod:nil path:deleteFootsURL()];
//    [[LCHTTPClient sharedHTTPClient] cancelAllHTTPOperationsWithMethod:nil path:removeAllFootsURL()];
    
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
    self.title=@"我的足迹";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(beSureRemoveAll)];
    
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
//    self.tableView.separatorColor=[UIColor colorWithRed:241.0/255 green:232.0/255 blue:207.0/255 alpha:1.0];
    

    [self refreshData];
}


-(void)beSureRemoveAll
{
        ESWeakSelf;
        UIAlertView *alert = [UIAlertView alertViewWithTitle:@"是否清空足迹？" message:nil cancelButtonTitle:@"取消" didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                ESStrongSelf;
                if (alertView.cancelButtonIndex != buttonIndex) {
                        [_self removeAllFoots];
                }
        } otherButtonTitles:@"确定", nil];
        [alert show];
//    [UIAlertView alertViewWithTitle:@"是否清空足迹？"
//                            message:nil
//                  cancelButtonTitle:@"取消"
//                 customizationBlock:nil
//                       dismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
//                           [self removeAllFoots];
//                           
//                       }
//                        cancelBlock:^{
//                            
//                        }
//                  otherButtonTitles: @"确定",nil];
}

#pragma mark - Subclass
- (void)refreshData
{
    if(!self.isRefreshing)
    {
        self.hasMore=YES;
        self.isRefreshing=YES;
        currentPage=1;
        [self getFootprintsList:1];
    }
    
    
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData==%d",currentPage);
    [self getFootprintsList:currentPage+1];
    
}



#pragma mark - Table view data source


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return @"删除";
//}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"删除删除");
        [self deleteFootsWithIndexPath:indexPath];
    }
    
}



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
    static NSString *identifier=@"foodsCell";
    LCFootprintsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[LCFootprintsCell alloc] initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:identifier];
        // 取消选择模式
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }
    
    
    cell.infoDic=self.list[indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *userDic=self.list[indexPath.row];
    
    LCUserDetailViewController *userDetailController=[LCUserDetailViewController userDetail:userDic];
    [self.navigationController pushViewController:userDetailController animated:YES];
    
}


@end
