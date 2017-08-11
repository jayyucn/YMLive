//
//  LCMyPhotoLibraryViewController+NetWork.m
//  XCLive
//
//  Created by ztkztk on 14-4-22.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCMyPhotoLibraryViewController.h"

@implementation LCMyPhotoLibraryViewController (NetWork)

-(void)getPhotoListWithPage:(int)page
{
//    ESWeakSelf;
//    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
//         NSLog(@"gagresponseDic=%@",responseDic);
//        ESStrongSelf;
//        [_self.refreshHeaderView endRefreshing];
//        int stat=[responseDic[@"stat"] intValue];
//        if(stat==200)
//        {
//            if(_self.isRefreshing)
//            {
//                currentPage=1;
//                [_self.list removeAllObjects];
//                NSArray *responseArray=responseDic[@"photo"];
//                if([responseArray count]>0)
//                {
//                    [_self.list addObjectsFromArray:responseArray];
//                    
//                }else{
//                    //无数据
//                }
//                
//                _self.loadMoreButton.hidden=YES;
//                _self.hasMore=YES;
//                _self.isRefreshing=NO;
//            }else{
//                
//                NSArray *responseArray=responseDic[@"photo"];
//                if([responseArray count]>0)
//                {
//                    [_self.list addObjectsFromArray:responseArray];
//                    _self.hasMore=YES;
//                    currentPage++;
//                    
//                }else{
//                    //无数据
//                    [LCNoticeAlertView showMsg:@"无更多图片"];
//                    _self.hasMore=NO;
//                }
//                _self.loadMoreButton.hidden=YES;
//            }
//            
//            NSLog(@"_self.tableView===%d",[_self.list count]);
//            [_self.tableView reloadData];
//            
//            [LCLocalCache savePhotoLibrary:_self.list];
//        }else{
//            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
//            _self.loadMoreButton.hidden=YES;
//            _self.isRefreshing=NO;
//            _self.isLoadingMore=NO;
//        }
//        
//        _self.isLoadingMore=NO;
//        
//        
//        //[MBProgressHUD hideHUDForView:_self.view animated:YES];
//         
//    };
//    
//    LCRequestFailResponseBlock failBlock=^(NSError *error){
//        NSLog(@"gagerror=%@",error);
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
//                                                  withPath:photoListURL()
//                                               withRESTful:GET_REQUEST
//                                          withSuccessBlock:successBlock
//                                             withFailBlock:failBlock];
}

-(void)deletePhoto:(NSDictionary *)photoDic
{
//    ESWeakSelf;
//    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
//        NSLog(@"gagresponseDic=%@",responseDic);
//        ESStrongSelf;
//        
//        int stat=[responseDic[@"stat"] intValue];
//        if(stat==200)
//        {
//            [_self refreshData];
//        }else{
//            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
//        }
//        
//        //[MBProgressHUD hideHUDForView:_self.view animated:YES];
//    };
//    
//    LCRequestFailResponseBlock failBlock=^(NSError *error){
//        ESStrongSelf;
//        //[MBProgressHUD hideHUDForView:_self.view animated:YES];
//        [LCNoticeAlertView showMsg:[NSString stringWithFormat:@"%@",error]];
//    };
//    
//    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    NSDictionary *parameters=@{@"id":photoDic[@"id"]};
//    [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameters
//                                                  withPath:deletePhotoURL()
//                                               withRESTful:GET_REQUEST
//                                          withSuccessBlock:successBlock
//                                             withFailBlock:failBlock];

}




@end
