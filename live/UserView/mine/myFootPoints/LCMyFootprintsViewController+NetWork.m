//
//  LCMyFootprintsViewController+NetWork.m
//  XCLive
//
//  Created by ztkztk on 14-5-14.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCMyFootprintsViewController+NetWork.h"


@implementation LCMyFootprintsViewController (NetWork)




-(void)getFootprintsList:(int)page
{
//    ESWeakSelf;
//    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
//        NSLog(@"gagresponseDic=%@",responseDic);
//        
//        ESStrongSelf;
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
//                    [_self.list addObjectsFromArray:responseArray];
//                    if([responseArray count]<10)
//                        _self.hasMore=NO;
//                    
//                }else{
//                    //无数据
//                    _self.navigationItem.rightBarButtonItem=nil;
//                }
//                //[self.refreshHeaderView endRefreshing];
//                    [_self.tableView.refreshControl endRefreshing];
//                _self.loadMoreButton.hidden=YES;
//                _self.hasMore=YES;
//                _self.isRefreshing=NO;
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
//            [_self.tableView reloadData];
//            
//            
//            if([_self.list count]==0)
//            {
//                _self.noDataNotice.hidden=NO;
//                _self.noDataImageView.hidden=NO;
//                _self.noDataNotice.text=@"你还没看过别人，抓紧到广场里看看吧";
//                
//            }else{
//                _self.noDataImageView.hidden=YES;
//                _self.noDataNotice.hidden=YES;
//            }
//
//        }else{
//            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
//        }
//        _self.isLoadingMore=NO;
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
//        //[MBProgressHUD hideHUDForView:_self.view animated:YES];
//    };
//    
//    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    NSDictionary *parameters=@{@"page":@(page)};
//    
//    [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameters
//                                                  withPath:footprintsURL()
//                                               withRESTful:GET_REQUEST
//                                          withSuccessBlock:successBlock
//                                             withFailBlock:failBlock];
    
}

-(void)deleteFootsWithIndexPath:(NSIndexPath *)indexPath
{
    
//    ESWeakSelf;
//    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
//        NSLog(@"gagresponseDic=%@",responseDic);
//        ESStrongSelf;
//        int stat=[responseDic[@"stat"] intValue];
//        if(stat==200)
//        {
//            //[LCNoticeAlertView showMsg:@"已删除此足迹"];
//            //[self refreshData];
//            
//            [_self.list removeObjectAtIndex:indexPath.row];
//            // Delete the row from the data source.
//                        
//            if([_self.list count]!=0)
//                [_self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            else{
//                [_self.tableView reloadData];
//            }
//
//            
//        }else{
//            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
//            
//        }
//        
//    };
//    
//    LCRequestFailResponseBlock failBlock=^(NSError *error){
//        NSLog(@"gagerror=%@",error);
//        [LCNoticeAlertView showMsg:@"网络异常，请检查网络"];
//        
//    };
//    
//    
//    
//    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"user":self.list[indexPath.row][@"uid"]}
//                                                  withPath:deleteFootsURL()
//                                               withRESTful:GET_REQUEST
//                                          withSuccessBlock:successBlock
//                                             withFailBlock:failBlock];
}


-(void)removeAllFoots
{
    
//    ESWeakSelf;
//    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
//        NSLog(@"gagresponseDic=%@",responseDic);
//        ESStrongSelf;
//        int stat=[responseDic[@"stat"] intValue];
//        if(stat==200)
//        {
//            [_self.list removeAllObjects];
//            [_self.tableView reloadData];
//            
//            _self.navigationItem.rightBarButtonItem=nil;
//            
//        }else{
//            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
//            
//        }
//        
//    };
//    
//    LCRequestFailResponseBlock failBlock=^(NSError *error){
//        NSLog(@"gagerror=%@",error);
//        [LCNoticeAlertView showMsg:@"网络异常，请检查网络"];
//        
//    };
//     
//    [[LCHTTPClient sharedHTTPClient] requestWithParameters:nil
//                                                  withPath:removeAllFootsURL()
//                                               withRESTful:GET_REQUEST
//                                          withSuccessBlock:successBlock
//                                             withFailBlock:failBlock];
}


@end
