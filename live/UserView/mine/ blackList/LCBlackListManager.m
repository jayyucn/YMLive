//
//  LCBlackListManager.m
//  XCLive
//
//  Created by ztkztk on 14-5-13.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCBlackListManager.h"

@implementation LCBlackListManager

+(void)addBlack:(NSString *)userID withBlock:(LCBlackManagerBlock)blackBlock
{
//    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
//        NSLog(@"gagresponseDic=%@",responseDic);
//        
//        int stat=[responseDic[@"stat"] intValue];
//        if(stat==200)
//        {
//            [LCNoticeAlertView showMsg:@"已加入黑名单"];
//            blackBlock(YES);
//        }else{
//            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
//            blackBlock(NO);
//        }
//        
//    };
//    
//    LCRequestFailResponseBlock failBlock=^(NSError *error){
//        NSLog(@"gagerror=%@",error);
//        [LCNoticeAlertView showMsg:@"网络异常，请检查网络"];
//        blackBlock(NO);
//        
//    };
//      
//    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"user":userID}
//                                                  withPath:blackaddURL()
//                                               withRESTful:GET_REQUEST
//                                          withSuccessBlock:successBlock
//                                             withFailBlock:failBlock];

}
+(void)deleteBlack:(NSString *)userID withBlock:(LCBlackManagerBlock)blackBlock
{
//    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
//        NSLog(@"gagresponseDic=%@",responseDic);
//        
//        int stat=[responseDic[@"stat"] intValue];
//        if(stat==200)
//        {
//            [LCNoticeAlertView showMsg:@"已移除黑名单"];
//            blackBlock(YES);
//        }else{
//            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
//            blackBlock(NO);
//        }
//        
//    };
//    
//    LCRequestFailResponseBlock failBlock=^(NSError *error){
//        NSLog(@"gagerror=%@",error);
//        [LCNoticeAlertView showMsg:@"网络异常，请检查网络"];
//        
//        blackBlock(NO);
//        
//    };
//    
//      
//    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"user":userID}
//                                                  withPath:blackdelURL()
//                                               withRESTful:GET_REQUEST
//                                          withSuccessBlock:successBlock
//                                             withFailBlock:failBlock];

}


@end
