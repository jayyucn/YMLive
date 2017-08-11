////
////  MyVideoDetailViewController+Network.m
////  XCLive
////
////  Created by 王威 on 15/3/20.
////  Copyright (c) 2015年 www.0x123.com. All rights reserved.
////
//
//#import "MyVideoDetailViewController.h"
//#import "KVNProgress.h"
//#import "MJRefresh.h"
//@implementation MyVideoDetailViewController (Network)
//
//- (void)getVideoDetailData:(NSString *)videoId
//{
////    ESWeakSelf;
////    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic)
////    {
////        ESStrongSelf;
////        NSLog(@"%@",responseDic);
////        int stat=[responseDic[@"stat"] intValue];
////        if(stat == 200)
////        {
////            //_self.videoArray = [NSMutableArray arrayWithCapacity:0];
////            _self.contentDic = [[NSMutableDictionary alloc] initWithDictionary:responseDic[@"detail"]];
////            [_self setPlayView];
////            [_self getCommentData:videoId];
////        }
////        else
////        {
////            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
////        }
////    };
////    
////    LCRequestFailResponseBlock failBlock=^(NSError *error){
////        NSLog(@"gagerror=%@",error);
////        ESStrongSelf;
////        [LCNoticeAlertView showMsg:@"网络异常，请检查网络"];
////    };
////    NSString *urlString=[NSString stringWithFormat:@"%@video/detail?id=%@&user=%@",getBaseURL(),videoId,[LCMyUser mine].userID];
////    
////    [[LCHTTPClient sharedHTTPClient] requestWithParameters:nil
////                                                  withPath:urlString
////                                               withRESTful:GET_REQUEST
////                                          withSuccessBlock:successBlock
////                                             withFailBlock:failBlock];
//}
//
//- (void)getCommentData:(NSString *)vid
//{
////    ESWeakSelf;
////    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
////        NSLog(@"gagresponseDic=%@",responseDic);
////        ESStrongSelf;
////        
////        int stat=[responseDic[@"stat"] intValue];
////        if(stat == 200)
////        {
////            _self.commentArray = [NSMutableArray arrayWithCapacity:0];
////            if(![responseDic[@"list"] isEqual:[NSNull null]])
////            {
////                [_self.commentArray addObjectsFromArray:responseDic[@"list"]];
////            }
////            [_self.videoDetailTable reloadData];
////        }
////        else
////        {
////            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
////        }
////        
////    };
////    
////    LCRequestFailResponseBlock failBlock=^(NSError *error){
////        NSLog(@"gagerror=%@",error);
////        ESStrongSelf;
////        [LCNoticeAlertView showMsg:@"网络异常，请检查网络"];
////    };
////    NSString *urlString=[NSString stringWithFormat:@"%@video/comment?vid=%@&page=1",getBaseURL(),vid];
////    
////    [[LCHTTPClient sharedHTTPClient] requestWithParameters:nil
////                                                  withPath:urlString
////                                               withRESTful:GET_REQUEST
////                                          withSuccessBlock:successBlock
////                                             withFailBlock:failBlock];
//}
//
//- (void)getMoreCommentDataWithVideo
//{
////    ESWeakSelf;
////    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
////        NSLog(@"gagresponseDic=%@",responseDic);
////        ESStrongSelf;
////        
////        int stat=[responseDic[@"stat"] intValue];
////        if(stat == 200)
////        {
////             [_self.videoDetailTable footerEndRefreshing];
////            if(![responseDic[@"list"] isEqual:[NSNull null]])
////            {
////                [_self.commentArray addObjectsFromArray:responseDic[@"list"]];
////            }
////           
////
////            [_self.videoDetailTable reloadData];
////           
////        }
////        else
////        {
////            _self.currentPage --;
////            [_self.videoDetailTable footerEndRefreshing];
////
////            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
////            
////        }
////    };
////    
////    LCRequestFailResponseBlock failBlock=^(NSError *error){
////        NSLog(@"gagerror=%@",error);
////        ESStrongSelf;
////        [LCNoticeAlertView showMsg:@"网络异常，请检查网络"];
////    };
////    NSString *urlString=[NSString stringWithFormat:@"%@video/comment?vid=%@&page=%@",getBaseURL(),self.videoID,NSStringWith(@"%d",self.currentPage)];
////    
////    [[LCHTTPClient sharedHTTPClient] requestWithParameters:nil
////                                                  withPath:urlString
////                                               withRESTful:GET_REQUEST
////                                          withSuccessBlock:successBlock
////                                             withFailBlock:failBlock];
//}
//
//- (void)commiteCommentData:(NSString *)content
//{
////    ESWeakSelf;
////    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
////        NSLog(@"gagresponseDic=%@",responseDic);
////        ESStrongSelf;
////        
////        int stat=[responseDic[@"stat"] intValue];
////        if(stat == 200)
////        {
////            [KVNProgress showSuccessWithStatus:@"评论成功"];
////            _self.contentView.text = @"";
////            if(_self.commtenTotalLabel)
////            {
////                int total = [_self.commtenTotalLabel.text intValue];
////                _self.commtenTotalLabel.text = NSStringWith(@"%d",total + 1);
////                [_self.contentDic removeObjectForKey:@"comm_total"];
////                [_self.contentDic setObject:NSStringWith(@"%@",responseDic[@"id"]) forKey:@"comm_total"];
////            }
////            
////            NSDictionary *dic = @{@"face" : [LCMyUser mine].faceURL,
////                                  @"id" : NSStringWith(@"%@",responseDic[@"id"]),
////                                  @"msg" : content,
////                                  @"nickname" : [LCMyUser mine].nickname,
////                                  @"time" : @"18-20",
////                                  @"uid" : [LCMyUser mine].userID};
////            [_self.commentArray insertObject:dic atIndex:0];
////
////            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
////            [_self.videoDetailTable insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
////        }
////        else
////        {
////            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
////        }
////        
////    };
////    
////    LCRequestFailResponseBlock failBlock=^(NSError *error){
////        NSLog(@"gagerror=%@",error);
////        ESStrongSelf;
////        [LCNoticeAlertView showMsg:@"网络异常，请检查网络"];
////    };
////    NSString *urlString=[NSString stringWithFormat:@"%@video/comm_add",getBaseURL()];
////    NSDictionary *paramsDic = @{@"vid":self.videoID,@"cont":content};
////    [[LCHTTPClient sharedHTTPClient] requestWithParameters:paramsDic
////                                                  withPath:urlString
////                                               withRESTful:POST_REQUEST
////                                          withSuccessBlock:successBlock
////                                             withFailBlock:failBlock];
//}
//
//- (void)deleteVideo
//{
////    ESWeakSelf;
////    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
////        NSLog(@"gagresponseDic=%@",responseDic);
////        ESStrongSelf;
////        
////        int stat=[responseDic[@"stat"] intValue];
////        if(stat == 200)
////        {
////            [KVNProgress showSuccessWithStatus:@"删除成功"];
////            [_self.navigationController popViewControllerAnimated:YES];
////            return;
////        }
////        else
////        {
////            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
////        }
////    };
////    
////    LCRequestFailResponseBlock failBlock=^(NSError *error){
////        NSLog(@"gagerror=%@",error);
////        ESStrongSelf;
////        [LCNoticeAlertView showMsg:@"网络异常，请检查网络"];
////    };
////    NSString *urlString=[NSString stringWithFormat:@"%@video/del?id=%@",getBaseURL(),self.videoID];
////    
////    [[LCHTTPClient sharedHTTPClient] requestWithParameters:nil
////                                                  withPath:urlString
////                                               withRESTful:GET_REQUEST
////                                          withSuccessBlock:successBlock
////                                             withFailBlock:failBlock];
//}
//
//- (void)deleteCommentWithId:(NSDictionary *)commDic
//{
////    ESWeakSelf;
////    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
////        NSLog(@"gagresponseDic=%@",responseDic);
////        ESStrongSelf;
////        
////        int stat=[responseDic[@"stat"] intValue];
////        if(stat == 200)
////        {
////            NSInteger index = [_self.commentArray indexOfObject:commDic];
////            [_self.commentArray removeObject:commDic];
////            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index + 1 inSection:0];
////            [_self.videoDetailTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
////            
////            return;
////        }
////        else
////        {
////            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
////        }
////    };
////    
////    LCRequestFailResponseBlock failBlock=^(NSError *error){
////        NSLog(@"gagerror=%@",error);
////        ESStrongSelf;
////        [LCNoticeAlertView showMsg:@"网络异常，请检查网络"];
////    };
////    NSString *commID = commDic[@"id"];
////    NSString *urlString=[NSString stringWithFormat:@"%@video/comm_del?id=%@&vid=%@",getBaseURL(),commID,self.videoID];
////    
////    [[LCHTTPClient sharedHTTPClient] requestWithParameters:nil
////                                                  withPath:urlString
////                                               withRESTful:GET_REQUEST
////                                          withSuccessBlock:successBlock
////                                             withFailBlock:failBlock];
//}
//
//@end