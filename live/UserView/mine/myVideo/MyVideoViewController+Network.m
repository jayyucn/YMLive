//
//  MyVideoViewController+Network.m
//  XCLive
//
//  Created by 王威 on 15/3/19.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import "MyVideoViewController.h"
#import "MyVideoModel.h"
#import "MJRefresh.h"


@implementation MyVideoViewController (Network)

- (void)getMyVideoData
{
//    ESWeakSelf;
//    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
//        NSLog(@"gagresponseDic=%@",responseDic);
//        ESStrongSelf;
//        
//        int stat=[responseDic[@"stat"] intValue];
//        if(stat == 200)
//        {
//            _self.videoArray = [NSMutableArray arrayWithCapacity:0];
//            if (![responseDic[@"list"] isEqual:[NSNull null]])
//            {
//                
//                for (NSDictionary *dic in responseDic[@"list"])
//                {
//                    MyVideoModel *model = [MyVideoModel initModelArrayWithData:dic];
//                    [_self.videoArray addObject:model];
//                }
//                [_self setTable];
//                [_self.myVideoTable headerEndRefreshing];
//            }
//        }
//        else
//        {
//            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
//        }
//    };
//    
//    LCRequestFailResponseBlock failBlock=^(NSError *error){
//        NSLog(@"gagerror=%@",error);
//        ESStrongSelf;
//        [LCNoticeAlertView showMsg:@"网络异常，请检查网络"];
//    };
//    NSString * urlString = [NSString stringWithFormat:@"%@video/my?page=%@",getBaseURL(),@"1"];
//
//    [[LCHTTPClient sharedHTTPClient] requestWithParameters:nil
//                                                  withPath:urlString
//                                               withRESTful:GET_REQUEST
//                                          withSuccessBlock:successBlock
//                                             withFailBlock:failBlock];
}

- (void)getMoreVideoData
{
//    ESWeakSelf;
//    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
//        NSLog(@"gagresponseDic=%@",responseDic);
//        ESStrongSelf;
//        
//        int stat=[responseDic[@"stat"] intValue];
//        if(stat == 200)
//        {
//
//            if (![responseDic[@"list"] isEqual:[NSNull null]])
//            {
//                
//                for (NSDictionary *dic in responseDic[@"list"])
//                {
//                    MyVideoModel *model = [MyVideoModel initModelArrayWithData:dic];
//                    [_self.videoArray addObject:model];
//                }
//                [_self.myVideoTable reloadData];
//                [_self.myVideoTable footerEndRefreshing];
//            }
//        }
//        else
//        {
//            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
//        }
//    };
//    
//    LCRequestFailResponseBlock failBlock=^(NSError *error){
//        NSLog(@"gagerror=%@",error);
//        ESStrongSelf;
//        [LCNoticeAlertView showMsg:@"网络异常，请检查网络"];
//    };
//    NSString * urlString=[NSString stringWithFormat:@"%@video/my?page=%@",getBaseURL(),NSStringWith(@"%d",self.currentPage)];
//    
//    [[LCHTTPClient sharedHTTPClient] requestWithParameters:nil
//                                                  withPath:urlString
//                                               withRESTful:GET_REQUEST
//                                          withSuccessBlock:successBlock
//                                             withFailBlock:failBlock];
}


@end
