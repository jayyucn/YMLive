//
//  LCSecretViewController+NetWork.m
//  XCLive
//
//  Created by ztkztk on 14-4-26.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCSecretViewController+NetWork.h"

@implementation LCSecretViewController (NetWork)




-(void)modifySecret:(NSDictionary *)dic
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
//            [[LCSet mineSet] modifySet:dic];
//        }
//        else{
//            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
//        }
//        
//        [_self.tableView reloadData];
//        
//    };
//    
//    LCRequestFailResponseBlock failBlock=^(NSError *error){
//        NSLog(@"gagerror=%@",error);
//        ESStrongSelf;
//        [_self.tableView reloadData];
//    };
//    
//    [[LCHTTPClient sharedHTTPClient] requestWithParameters:dic
//                                                  withPath:modifySecretURL()
//                                               withRESTful:POST_REQUEST
//                                          withSuccessBlock:successBlock
//                                             withFailBlock:failBlock];
    
}


@end
