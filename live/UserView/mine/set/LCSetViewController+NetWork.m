//
//  LCSetViewController+NetWork.m
//  XCLive
//
//  Created by ztkztk on 14-4-26.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCSetViewController+NetWork.h"
#import "LCLoginAndExitRequest.h"

@implementation LCSetViewController (NetWork)




-(void)getSetInfo
{
//    
//    ESWeakSelf;
//    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
//        
//        NSLog(@"gagresponseDic=%@",responseDic);
//        ESStrongSelf;
//        int stat=[responseDic[@"stat"] intValue];
//        if(stat==200)
//        {
//            [[LCSet mineSet] fillWithDictionary:responseDic[@"userinfo"]];
//            [_self.tableView reloadData];
//        }
//        else{
//            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
//        }
//        
//    };
//    
//    LCRequestFailResponseBlock failBlock=^(NSError *error){
//        NSLog(@"gagerror=%@",error);
//    };
//    
//    [[LCHTTPClient sharedHTTPClient] requestWithParameters:nil
//                                                  withPath:setURL()
//                                               withRESTful:GET_REQUEST
//                                          withSuccessBlock:successBlock
//                                             withFailBlock:failBlock];
//    
}

-(void)exitCurrentAccount
{
    [LCLoginAndExitRequest exitLC];
}



@end
