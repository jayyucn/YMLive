//
//  LCLoginrequest.m
//  XCLive
//
//  Created by ztkztk on 14-4-28.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCLoginAndExitRequest.h"
//#import "FacebookManager.h"
//#import "LiveShowRootViewController.h"

@implementation LCLoginAndExitRequest



+(void)login:(NSDictionary *)dic withBlock:(LCLoginSuccessBlock)resultBlock
{
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        
        NSLog(@"responseDic=%@",responseDic);
        
        int stat=[responseDic[@"stat"] intValue];
        if(stat==200)
        {
            resultBlock(responseDic);
        }
        else
        {
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
    };
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        NSLog(@"gagerror=%@",error);
        [LCNoticeAlertView showMsg:@"网络请求失败，请检查网络。"];
        
    };
    
    
    NSMutableDictionary *loginDic=[NSMutableDictionary dictionaryWithDictionary:dic];
      
    [loginDic setObject:[UIDevice openUDID] forKey:@"udid"];
    [loginDic setObject:@"1" forKey:@"ry"];
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:loginDic
                                                  withPath:URL_LIVE_LOGIN
                                               withRESTful:POST_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
    
}

+(void)exitLC
{
    [MBProgressHUD showHUDAddedTo:[LCCore appRootViewController].view  animated:YES];
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        
        NSLog(@"responseDic=%@",responseDic);
        
        [MBProgressHUD hideHUDForView:[LCCore appRootViewController].view animated:YES];
        
        int stat=[responseDic[@"stat"] intValue];
        if(stat==200)
        {
//            [[FacebookManager shareInstance] requestLogout];
//            //如果有房间在运行,退出房间
//            LiveShowRoomViewController *room = [LiveShowRootViewController getCurrentRoom];
//            if (room != nil)
//            {
//                LiveShowRootViewController *showRoot = (LiveShowRootViewController *)room.rootVC;
//                [DataManager sharedManager].moreActionType = ShowNomalMoreAction;
//                [showRoot exitShowRoom];
//            }
//            [[LCCore globalCore].tabBarController setSelectedIndex:0];
//            [LCCore globalCore].tabBarController = nil;
            
            [[LCMyUser mine] reset];
            
//            [[LCQQInvite inviteManager] tencentLogout];
            
            [LCCore presentLandController];
            //[LCCore presentStartController];
        }
        
        else{
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
    };
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        NSLog(@"gagerror=%@",error);
        [MBProgressHUD hideHUDForView:[LCCore appRootViewController].view animated:YES];
        [LCNoticeAlertView showMsg:@"网络请求失败，请检查网络。"];
        
        [[LCMyUser mine] reset];
        
        [LCCore presentLandController];
    };
    
    
   // [[LCMyUser mine] reset];
    
   // return;
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_Exit_Success
                                                        object:[LCMyUser mine].userID
                                                      userInfo:nil];
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:nil
                                                  withPath:URL_LIVE_EXIT
                                               withRESTful:POST_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
    
    
    //18621759057 861217

    
}

@end
