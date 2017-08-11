////
////  LCMyFollowViewController+NetWork.m
////  XCLive
////
////  Created by ztkztk on 14-5-14.
////  Copyright (c) 2014年 ztkztk. All rights reserved.
////
//
//#import "LCMyFollowViewController+NetWork.h"
//
//@implementation LCMyFollowViewController (NetWork)
//
//
//
//
//-(void)getFriendList:(int)page
//{
//    
////    ESWeakSelf;
////    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
////        NSLog(@"gagresponseDic=%@",responseDic);
////        
////        ESStrongSelf;
////        [_self.refreshHeaderView endRefreshing];
////        
////        int stat=[responseDic[@"stat"] intValue];
////        if(stat==200)
////        {
////            if(_self.isRefreshing)
////            {
////                currentPage=1;
////                [_self.list removeAllObjects];
////                NSArray *responseArray=responseDic[@"friend"];
////                if([responseArray isKindOfClass:[NSArray class]]&&[responseArray count]>0)
////                {
////                    _self.noDataNotice.hidden=YES;
////                    [_self.list addObjectsFromArray:responseArray];
////                    if([responseArray count]<10)
////                        _self.hasMore=NO;
////                    
////                }else{
////                    //无数据
////                   // self.noDataNotice.hidden=NO;
////                   // self.noDataNotice.text=@"您还没有关注好友，关注将获得对方更多的信息";
////                }
////                
////                _self.loadMoreButton.hidden=YES;
////                _self.hasMore=YES;
////                _self.isRefreshing=NO;
////            }else{
////                
////                NSArray *responseArray=responseDic[@"friend"];
////                if([responseArray isKindOfClass:[NSArray class]]&&[responseArray count]>0)
////                {
////                    [_self.list addObjectsFromArray:responseArray];
////                    _self.hasMore=YES;
////                    currentPage++;
////                    if([responseArray count]<10)
////                        _self.hasMore=NO;
////                    
////                }else{
////                    //无数据
////                    //[LCNoticeAlertView showMsg:@"无更多内容"];
////                    _self.hasMore=NO;
////                }
////                _self.loadMoreButton.hidden=YES;
////                
////            }
////            
////            [_self.tableView reloadData];
////            
////            if([_self.list count]==0)
////            {
////                _self.noDataNotice.hidden=NO;
////                _self.noDataImageView.hidden=NO;
////                _self.noDataNotice.text=@"您还没有关注好友，关注将获得对方更多的信息";
////
////            }else{
////                _self.noDataImageView.hidden=YES;
////                _self.noDataNotice.hidden=YES;
////            }
////        }else{
////            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
////            _self.loadMoreButton.hidden=YES;
////            _self.isRefreshing=NO;
////            _self.isLoadingMore=NO;
////        }
////        _self.isLoadingMore=NO;
////        
////        //[MBProgressHUD hideHUDForView:_self.view animated:YES];
////    };
////    
////    LCRequestFailResponseBlock failBlock=^(NSError *error){
////        NSLog(@"gagerror=%@",error);
////        
////        ESStrongSelf;
////        _self.isRefreshing=NO;
////        [_self.refreshHeaderView endRefreshing];
////        _self.isLoadingMore=NO;
////        
////       // [MBProgressHUD hideHUDForView:_self.view animated:YES];
////    };
////    
////    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
////    NSDictionary *parameters=@{@"page":@(page)};
////    
////    [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameters
////                                                  withPath:friendsURL()
////                                               withRESTful:GET_REQUEST
////                                          withSuccessBlock:successBlock
////                                             withFailBlock:failBlock];
////    
//}
//
//-(void)deleteFriend:(NSIndexPath *)indexPath
//{
//    
////     ESWeakSelf;
////    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
////        NSLog(@"gagresponseDic=%@",responseDic);
////        ESStrongSelf;
////        int stat=[responseDic[@"stat"] intValue];
////        if(stat==200)
////        {
////            [_self.list removeObjectAtIndex:indexPath.row];
////            // Delete the row from the data source.
////            
////            
////            if([_self.list count]!=0)
////                [_self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
////            else{
////                [_self.tableView reloadData];
////            }
////
////
////            
////        }else{
////            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
////            
////        }
////        
////    };
////    
////    LCRequestFailResponseBlock failBlock=^(NSError *error){
////        NSLog(@"gagerror=%@",error);
////        [LCNoticeAlertView showMsg:@"网络异常，请检查网络"];
////     
////    };
////    
////    
////    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"user":self.list[indexPath.row][@"uid"]}
////                                                  withPath:deleteFriendURL()
////                                               withRESTful:GET_REQUEST
////                                          withSuccessBlock:successBlock
////                                             withFailBlock:failBlock];
//}
//
//-(void)modifyFriend:(NSDictionary *)userDic
//{
////    
////    ESWeakSelf;
////    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
////        NSLog(@"gagresponseDic=%@",responseDic);
////        ESStrongSelf;
////        int stat=[responseDic[@"stat"] intValue];
////        if(stat==200)
////        {
////            [LCNoticeAlertView showMsg:@"修改成功"];
////            [_self refreshData];
////            
////        }else{
////            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
////            
////        }
////        
////    };
////    
////    LCRequestFailResponseBlock failBlock=^(NSError *error){
////        NSLog(@"gagerror=%@",error);
////        [LCNoticeAlertView showMsg:@"网络异常，请检查网络"];
////        
////    };
////    
////    
////    
////    int modifyLevel;
////    NSInteger level = 0;
////    ESIntegerVal(&level, userDic[@"level"]);
////    if(level==0)
////    {
////        modifyLevel=1;
////    }else
////    {
////        modifyLevel=0;
////    }
////    
////    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"user":userDic[@"uid"],@"level":@(modifyLevel)}
////                                                  withPath:modifyFriendURL()
////                                               withRESTful:GET_REQUEST
////                                          withSuccessBlock:successBlock
////                                             withFailBlock:failBlock];
////    
//}
//
//
//@end
