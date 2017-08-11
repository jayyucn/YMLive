//
//  KFPreReady.m
//  KaiFang
//
//  Created by ztkztk on 13-12-4.
//  Copyright (c) 2013年 www.0x123.com. All rights reserved.
//

#import "LCStart.h" 
#import "LCMyUser.h"
#import "LCCore.h"
#import "CustomNotification.h"
#import "LiveGiftFile.h"

@implementation LCStart

static LCStart *_sharedStart = nil;

+ (LCStart *)sharedStart
{
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
            _sharedStart = [[LCStart alloc] init];
//        _sharedStart.locationManager=[LocationManager locationManager];
        });
    return _sharedStart;

}


-(void)requestForStart:(BOOL)first
{
    [LCCore globalCore].shouldRequestSync = YES;
    [[LCCore globalCore] requestSync];
}

//+(void)requestForSyn:(BOOL)first withLocation:(NSDictionary *)location
//{
//    
//    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
//        
//         NSLog(@"responseDic=%@",responseDic);
//           
//        int stat=[responseDic[@"stat"] intValue];
//        if(stat==200)
//        {
//            if(first)
//            {
//                [LCStart firstLoadView:responseDic];
//            }else{
//                if(![LCCore globalCore].viewLoaded)
//                    [LCStart firstLoadView:responseDic];
//                else{
//                    NSInteger  step= 0;
//                    ESIntegerVal(&step, responseDic[@"step"]);
//                    if(step==4)
//                    {
//                        if(![LCCore globalCore].Registering)
//                            [LCCore presentLandController];
//                        //[LCCore presentLandController];
//                    }
//
//                    
//                }
//               
//            }
//          
//        }
//          else{
//              [LCNoticeAlertView showMsg:responseDic[@"msg"]];
//              [[ESMemoryCache sharedCache] removeAllObjects:nil];
//              [[ESCache sharedCache] removeAllObjects:nil];
////              [[[LCHTTPClient sharedHTTPClient] operationQueue] cancelAllOperations];
////              [[[LCJSONClient sharedClient] operationQueue] cancelAllOperations];
//              
//              /* Clear cookies */
//              [ESApp deleteAllHTTPCookies];
//              
//              [LCCore presentLandController];
//              [LCCore globalCore].viewLoaded=YES;
//           
//        }
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_Land_State
//                                                            object:nil
//                                                          userInfo:nil];
//     };
//    LCRequestFailResponseBlock failBlock=^(NSError *error){
//        NSLog(@"gagerror=%@",error);
//        [LCNoticeAlertView showMsg:@"网络异常，请检查网络。"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_Land_State
//                                                            object:nil
//                                                          userInfo:nil];
//        
//        
//        if([[LCMyUser mine] hasLogged])
//        {
//            [LCCore presentMainViewController];
//        }else{
//          
//            [LCCore presentLandController];
//        }
//        
//       };
//    
//    
//    NSMutableDictionary *parameters=[NSMutableDictionary dictionaryWithDictionary:[LCCore analyticsInformation]];
//    [parameters addEntriesFromDictionary:location];
//    
//    
//    [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameters
//                                                    withPath:getStartURL()
//                                                 withRESTful:GET_REQUEST
//                                            withSuccessBlock:successBlock
//                                               withFailBlock:failBlock];
//    
//    
//    
//}


+(void)firstLoadView:(NSDictionary *)responseDic
{
    BOOL isReviewing = NO;
    ESBoolVal(&isReviewing, responseDic[@"is_reviewing"]);
    [LCCore globalCore].isAppStoreReviewing = isReviewing;
    [LCCore globalCore].shouldShowPayment = !isReviewing;
    [LCMyUser mine].uplive_url = responseDic[@"uplive_url"];
    
  
    NSInteger step= 0;
    ESIntegerVal(&step, responseDic[@"step"]);
    switch (step)
    {
        case 0:
        {
            if(![LCCore globalCore].Registering)
                
                [LCCore presentLandController];
                if ([LCCore globalCore].isAppStoreReviewing) {
                        [[LCCore globalCore] performSelector:@selector(showEULA) withObject:nil afterDelay:.5];
                }
        }
            break;
        case 1:
        {
            if(![LCCore globalCore].Registering)
                [LCCore presentRegisterFirstController];
        }
            break;
        case 2:
        {
            if(![LCCore globalCore].Registering)
                [LCCore presentRegisterSecondController];//
        }
            break;
        case 3:
        {
            if([responseDic[@"userinfo"] isKindOfClass:[NSDictionary class]]) {
                int giftVersion = 0;
                ESIntVal(&giftVersion, responseDic[@"gift_version"]);
                [LiveGiftFile updateGiftList:giftVersion];
                
                [LCMyUser mine].onetone = [responseDic[@"userinfo"][@"onetone"] intValue];// 1V1开通的状态
                
                [[LCCore globalCore] sendPushToken:responseDic[@"userinfo"][@"device_token"]];
                    
                [[LCMyUser mine] fillWithDictionary:responseDic[@"userinfo"]];
                [[LCMyUser mine] save];
                
                [[NSUserDefaults standardUserDefaults] setObject:[LCMyUser mine].account
                                                          forKey:PreAccount];
                
                if (responseDic[@"startpage"]) {
                    [[NSUserDefaults standardUserDefaults] setObject:responseDic[@"startpage"]
                                                              forKey:kUserStartPageInfo];
                } else {
                    [[NSUserDefaults standardUserDefaults] setObject:nil
                                                              forKey:kUserStartPageInfo];
                }
                
                if (![LCCore globalCore].isEnterHome)
                {
                    [LCCore presentMainViewController];
                }
 
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_Land_Sucess
                                                                        object:nil
                                                                      userInfo:nil];
            }
            else
                [LCCore presentLandController];
        }
            break;
        case 4:
        {
            if(![LCCore globalCore].Registering)
                [LCCore presentLandController];
        }
        default:
            break;
    }
    
    [LCCore globalCore].viewLoaded=YES;

}


+(void)sendPushTokenToSever:(NSString *)token//发送pushToken
{
//    
//    
//    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
//        NSLog(@"responseDic=%@",responseDic);
//     
//        int stat=[responseDic[@"stat"] intValue];
//        if(stat==200)
//        {
//            
//        }
//        if(stat==500)
//        {
//            [[LCMyUser mine] reset];
//        }
//   
//    };
//       
//     
//    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"id":token, @"udid":[UIDevice deviceIdentifier]}
//                                                    withPath:pushToken()
//                                                 withRESTful:GET_REQUEST
//                                            withSuccessBlock:successBlock
//                                               withFailBlock:nil];
//
 
    
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic)
    {
        int stat=[responseDic[@"stat"] intValue];
        if(stat == URL_REQUEST_SUCCESS)
        {
            NSLog(@"upload push token succ");
        }
        
        if(stat==500)
        {
            [[LCMyUser mine] reset];
        }
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        NSLog(@"upload push token fail %@",error);
    };
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"id":token, @"udid":[UIDevice openUDID]}
                                                  withPath:URL_LIVE_PUSH_TOKEN
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}


/*
-(void)test
{
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        //NSLog(@"gagresponseDic=%@",responseDic);
        int stat=[responseDic[@"stat"] intValue];
        if(stat==200)
        {
            [self test];
        }else{
            
            NSLog(@"test===%@ ",responseDic);
        }
   
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        NSLog(@"test===%@ ",error);
        //[MBProgressHUD hideHUDForView:_self.view animated:YES];
    };
    
    
    //NSMutableDictionary *parameters=[NSMutableDictionary dictionaryWithDictionary:dic];
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    
    
    
    [parameters setObject:@(1) forKey:@"page"];
    [parameters setObject:@(31.13304308962403) forKey:@"latitude"];
    [parameters setObject:@(121.5788747469149) forKey:@"longitude"];
    
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameters
                                                  withPath:squareListURL()
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];

}
 
*/

@end
