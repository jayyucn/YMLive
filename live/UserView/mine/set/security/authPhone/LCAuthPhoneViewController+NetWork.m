//
//  LCAuthPhoneViewController+NetWork.m
//  XCLive
//
//  Created by ztkztk on 14-4-28.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCAuthPhoneViewController+NetWork.h"

#import "LCSecurityViewController.h"

@implementation LCAuthPhoneViewController (NetWork)




-(void)requestVerifying
{
    
//    [self startRequestCode];
//    ESWeakSelf;
//    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
//        
//        NSLog(@"gagresponseDic=%@",responseDic);
//        ESStrongSelf;
//        int stat=[responseDic[@"stat"] intValue];
//        if(stat==200)
//        {
//            self.phoneTimeCounter=60;
//            
//            [_self savePhoneCodeTime];
//            [_self showVerify];
//        }
//        else{
//            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
//            [_self failedRequest];
//            
//        }
//        
//    };
//    
//    LCRequestFailResponseBlock failBlock=^(NSError *error){
//        NSLog(@"gagerror=%@",error);
//        ESStrongSelf;
//        [LCNoticeAlertView showMsg:@"请检查网络状态"];
//        [_self failedRequest];
//    };
//    
//    
//    [[LCHTTPClient sharedHTTPClient] requestWithParameters:nil
//                                                  withPath:requestVerifyingCodeURL()
//                                               withRESTful:GET_REQUEST
//                                          withSuccessBlock:successBlock
//                                             withFailBlock:failBlock];

}

-(void)verifyingPhone:(NSDictionary *)code
{
//    
//    
//    ESWeakSelf;
//    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
//        
//        
//        ESStrongSelf;
//        NSLog(@"gagresponseDic=%@",responseDic);
//        int stat=[responseDic[@"stat"] intValue];
//        if(stat==200)
//        {
//            [LCSet mineSet].phone_auth=YES;
//            [LCNoticeAlertView showMsg:@"手机验证成功"];
//            
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PhoneCodeTime"];
//            //手机验证成功 跳转到验证首页  todo todo
//            
//            for(UIViewController *viewController in _self.navigationController.viewControllers)
//            {
//                if([viewController isKindOfClass:[LCSecurityViewController class]])
//                {
//                    [_self.navigationController popToViewController:viewController animated:YES];
//                }
//            }
//
//        }
//        else{
//            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
//            
//            
//        }
//        
//    };
//    
//    LCRequestFailResponseBlock failBlock=^(NSError *error){
//        NSLog(@"gagerror=%@",error);
//        
//        [LCNoticeAlertView showMsg:@"请检查网络状态"];
//        
//    };
//    
//    [[LCHTTPClient sharedHTTPClient] requestWithParameters:code
//                                                  withPath:verifyPhoneURL()
//                                               withRESTful:GET_REQUEST
//                                          withSuccessBlock:successBlock
//                                             withFailBlock:failBlock];

}



@end
