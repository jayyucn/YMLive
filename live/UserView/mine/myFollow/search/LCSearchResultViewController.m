//
//  LCSearchResultViewController.m
//  XCLive
//
//  Created by ztkztk on 14-6-19.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "LCSearchResultViewController.h"
//#import "LCUserDetailViewController.h"

#import "LCSearchCell.h"

@interface LCSearchResultViewController ()

@end

@implementation LCSearchResultViewController


-(void)dealloc
{
//    [[LCHTTPClient sharedHTTPClient] cancelAllHTTPOperationsWithMethod:nil path:searchUser()];
    
}


+(id)searchController:(NSString *)searchString
{
    LCSearchResultViewController *searchController=[[LCSearchResultViewController alloc] init];
    searchController.searchString=searchString;
    return searchController;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    self.title=@"搜索";
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
//    self.tableView.separatorColor=[UIColor colorWithRed:241.0/255 green:232.0/255 blue:207.0/255 alpha:1.0];
}


-(void)setSearchString:(NSString *)searchString
{
    _searchString=searchString;
    [self refreshData];
}


- (void)refreshData
{
    if(!self.isRefreshing)
    {
        
        NSLog(@"refreshData=====");
        self.hasMore=YES;
        self.isRefreshing=YES;
        currentPage=1;
        [self getsearchList:1];

    }
    
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData==%d",currentPage);
    if(currentPage>=1)
        [self getsearchList:currentPage+1];
    
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
    static NSString *identifier=@"searchCell";
    LCSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[LCSearchCell alloc] initWithStyle:UITableViewCellStyleDefault
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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary *userDic=self.list[indexPath.row];
//    LCUserDetailViewController *userDetailController=[LCUserDetailViewController userDetail:userDic];
//    [self.navigationController pushViewController:userDetailController animated:YES];
}


-(void)getsearchList:(int)page
{
//    NSLog(@"getsearchList===");
//    ESWeakSelf;
//    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
//        NSLog(@"gagresponseDic=%@",responseDic);
//        
//        ESStrongSelf;
//        [_self.refreshHeaderView endRefreshing];
//        
//        int stat=[responseDic[@"stat"] intValue];
//        if(stat==200)
//        {
//            if(_self.isRefreshing)
//            {
//                currentPage=1;
//                [_self.list removeAllObjects];
//                NSArray *responseArray=responseDic[@"list"];
//                if([responseArray isKindOfClass:[NSArray class]]&&[responseArray count]>0)
//                {
//                    _self.noDataNotice.hidden=YES;
//                    [_self.list addObjectsFromArray:responseArray];
//                    if([responseArray count]<10)
//                        _self.hasMore=NO;
//                    
//                }else{
//                    //无数据
//                    // self.noDataNotice.hidden=NO;
//                    // self.noDataNotice.text=@"您还没有关注好友，关注将获得对方更多的信息";
//                }
//                
//                _self.loadMoreButton.hidden=YES;
//                _self.hasMore=YES;
//                
//            }else{
//                
//                NSArray *responseArray=responseDic[@"list"];
//                if([responseArray isKindOfClass:[NSArray class]]&&[responseArray count]>0)
//                {
//                    [_self.list addObjectsFromArray:responseArray];
//                    _self.hasMore=YES;
//                    currentPage++;
//                    if([responseArray count]<10)
//                        _self.hasMore=NO;
//                    
//                }else{
//                    //无数据
//                    //[LCNoticeAlertView showMsg:@"无更多内容"];
//                    _self.hasMore=NO;
//                }
//                _self.loadMoreButton.hidden=YES;
//                
//            }
//            
//            [_self.tableView reloadData];
//            
//            if([_self.list count]==0)
//            {
//                _self.noDataNotice.hidden=NO;
//                _self.noDataImageView.hidden=NO;
//                _self.noDataNotice.text=@"搜索结果为0";
//                
//            }else{
//                _self.noDataImageView.hidden=YES;
//                _self.noDataNotice.hidden=YES;
//            }
//        }else{
//            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
//            _self.loadMoreButton.hidden=YES;
//            _self.isRefreshing=NO;
//            _self.isLoadingMore=NO;
//        }
//        _self.isLoadingMore=NO;
//        _self.isRefreshing=NO;
//        
//        //[MBProgressHUD hideHUDForView:_self.view animated:YES];
//    };
//    
//    LCRequestFailResponseBlock failBlock=^(NSError *error){
//        NSLog(@"gagerror=%@",error);
//        
//        ESStrongSelf;
//        _self.isRefreshing=NO;
//        [_self.refreshHeaderView endRefreshing];
//        _self.isLoadingMore=NO;
//        
//        // [MBProgressHUD hideHUDForView:_self.view animated:YES];
//    };
//    
//    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    NSDictionary *parameters=@{@"page":@(page),@"key":_searchString};
//    
//    [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameters
//                                                  withPath:searchUser()
//                                               withRESTful:GET_REQUEST
//                                          withSuccessBlock:successBlock
//                                             withFailBlock:failBlock];
    
}


@end
