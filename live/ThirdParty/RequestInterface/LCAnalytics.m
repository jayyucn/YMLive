//
//  LCAnalytics.m
//  XCLive
//
//  Created by ztkztk on 14-7-10.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "LCAnalytics.h"

@implementation LCAnalytics

+(void)analyticsWithType:(NSString *)type
{
    
    NSDictionary *analyDic=@{@"udid":[UIDevice openUDID],@"type":type};
    
    
    [LCAnalytics analytics:analyDic];
    
}



+(void)analyticsInWithType:(NSString *)type
{
    
    NSDictionary *analyDic=@{@"type":type};
    
    
    [LCAnalytics analytics:analyDic];
    
    
    
}

+(void)analytics:(NSDictionary *)analyDic
{
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:analyDic
                                                  withPath:URL_ANALYTIS_COUNT
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:nil
                                             withFailBlock:nil];
    
    
    //18621759057 861217
}





+(void)shareSuccessWithType:(NSString *)type
{
    
    
    /*
     LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
     
     NSLog(@"responseDic===%@",responseDic);
     int stat=[responseDic[@"stat"] intValue];
     if(stat==200)
     {
     
     
     }
     
     else{
     
     }
     };
     LCRequestFailResponseBlock failBlock=^(NSError *error){
     
     };
     
    */
    
    //NSDictionary *analyDic=@{@"udid":[UIDevice deviceIdentifier],@"type":type};
    
    NSString *path;
    NSDictionary *shareDic=@{@"type":type};
    if ([LCCore globalCore].fromMask) {
        //shareDic = @{@"type":@"qq"};
        path = @"task/shareok";
    }else{
        //shareDic=@{@"type":type};
        path = @"find/shareok";
    }
    
    NSLog(@"type   %@", shareDic);
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:shareDic
                                                  withPath:path
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:^(NSDictionary *dict){
                                              if ([[dict objectForKey:@"stat"] intValue] == 200) {
                                                  [[NSNotificationCenter defaultCenter] postNotificationName:RefreshMask object:nil];
                                              }
                                          }
                                             withFailBlock:nil];
    
    
    //18621759057 861217
    
    
}



@end
