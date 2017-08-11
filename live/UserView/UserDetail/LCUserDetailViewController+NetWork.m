//
//  LCUserDetailViewController+NetWork.m
//  XCLive
//
//  Created by ztkztk on 14-4-30.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCUserDetailViewController+NetWork.h"

#import "LCBlackListManager.h"

//#import "LCMessageListViewController.h"
#import "KVNProgress.h"
@implementation LCUserDetailViewController (NetWork)



-(void)getUserDetail
{
    ESWeakSelf;
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        NSLog(@"gagresponseDic=%@",responseDic);
        ESStrongSelf;
        
        int stat=[responseDic[@"stat"] intValue];
        if(stat==200)
        {
            if (![responseDic[@"gifts"] isEqual:[NSNull null]])
            {
                _self.userGiftArray = responseDic[@"gifts"];
            }
            
            if (![responseDic[@"dates"] isEqual:[NSNull null]])
            {
                _self.userDateDic = responseDic[@"dates"];
                
                _self.convertSectionIndex = 1;
            }
            else
            {
                _self.convertSectionIndex = 0;
            }
            _self.userDic=responseDic;
            
            
            _self.tableView.alpha=1.0f;
            [_self.tableView reloadData];
            /*
             [UIView animateWithDuration:0.1 animations:^(void){
             _self.tableView.alpha=1.0f;
             }];
             */
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_Visit
                                                                object:responseDic
                                                              userInfo:nil];
            
            
        }else{
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
        
        //[MBProgressHUD hideHUDForView:_self.view animated:YES];
        
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        NSLog(@"gagerror=%@",error);
        ESStrongSelf;
        [LCNoticeAlertView showMsg:@"网络异常，请检查网络"];
        //[MBProgressHUD hideHUDForView:_self.view animated:YES];
    };
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",getBaseURL(),self.userID];
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:nil
                                                  withPath:urlString
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}


-(void)addFriend
{
    ESWeakSelf;
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        NSLog(@"gagresponseDic=%@",responseDic);
        ESStrongSelf;
        
        int stat=[responseDic[@"stat"] intValue];
        if(stat==200)
        {
            BOOL sendChat = NO;
            if (ESBoolVal(&sendChat, responseDic[@"is_send"]) && sendChat) {
                // NSDictionary *data = _self.userDic[@"userinfo"];
//                [LCMessageListViewController sendChatTipsMessage:LCChatMessageTypeTipsFollow toUser:_self.userID data:data];
            }
            [LCNoticeAlertView showMsg:@"关注成功"];
            
            _self.atten = 1;
        }else{
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
        
        //[MBProgressHUD hideHUDForView:_self.view animated:YES];
        
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        NSLog(@"gagerror=%@",error);
        [LCNoticeAlertView showMsg:@"网络异常，请检查网络"];
        ESStrongSelf;
        //[MBProgressHUD hideHUDForView:_self.view animated:YES];
    };
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"user":self.userID}
                                                  withPath:addFriendURL()
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}

-(void)deleteFriend
{
    ESWeakSelf;
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        NSLog(@"gagresponseDic=%@",responseDic);
        ESStrongSelf;
        int stat=[responseDic[@"stat"] intValue];
        if(stat==200)
        {
            [LCNoticeAlertView showMsg:@"已取消关注"];
            
            
            _self.atten=0;
            
        }else{
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
            
        }
        
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        NSLog(@"gagerror=%@",error);
        [LCNoticeAlertView showMsg:@"网络异常，请检查网络"];
        
    };
    
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"user":self.userID}
                                                  withPath:deleteFriendURL()
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}


-(void)blackList
{
    [LCBlackListManager addBlack:self.userID
                       withBlock:^(BOOL success){
                           if(success)
                           {
                               
                           }else{
                               
                           }
                       }];
}
-(void)report:(NSInteger)type
{
    ESWeakSelf;
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        NSLog(@"gagresponseDic=%@",responseDic);
        ESStrongSelf;
        
        int stat=[responseDic[@"stat"] intValue];
        if(stat==200)
        {
            [LCNoticeAlertView showMsg:@"举报成功"];
        }else{
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
        //[MBProgressHUD hideHUDForView:_self.view animated:YES];
        
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        NSLog(@"gagerror=%@",error);
        ESStrongSelf;
        [LCNoticeAlertView showMsg:@"网络异常，请检查网络"];
        //[MBProgressHUD hideHUDForView:_self.view animated:YES];
    };
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"user":self.userID,@"type":@(type)}
                                                  withPath:reportURL()
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
    
}

- (void)inviteUserUpdatePhoto
{
    ESWeakSelf;
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        NSLog(@"gagresponseDic=%@",responseDic);
        ESStrongSelf;
        
        int stat=[responseDic[@"stat"] intValue];
        if(stat==200)
        {
            [KVNProgress showSuccessWithStatus:@"邀请成功"];
        }
        else
        {
            [KVNProgress showErrorWithStatus:@"邀请失败"];
        }
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        NSLog(@"gagerror=%@",error);
        ESStrongSelf;
        [LCNoticeAlertView showMsg:@"网络异常，请检查网络"];
    };
    
    NSString *path = NSStringWith(@"%@home/invite",getBaseURL());
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"user":self.userID,@"type":@"1"}
                                                  withPath:path
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}



@end
