//
//  IAPReceiptVerificator.m
//  qianchuo
//
//  Created by 林伟池 on 16/5/14.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "IAPReceiptVerificator.h"
#import "LCCore.h"

@implementation IAPReceiptVerificator
- (void)verifyTransaction:(SKPaymentTransaction*)transaction
                  success:(void (^)())successBlock
                  failure:(void (^)(NSError *error))failureBlock
{
    LCRequestSuccessResponseBlock success=^(NSDictionary *responseDic){
        NSLog(@"success");
        if (responseDic[@"diamond"]) {
            [LCMyUser mine].diamond = [(NSNumber *)responseDic[@"diamond"] intValue];
        }
        if (successBlock) {
            successBlock();
        }
    };
    
    LCRequestFailResponseBlock fail=^(NSError *error){
        NSLog(@"fail");
        if (failureBlock) {
            failureBlock(error);
        }
    };
    NSData* data = [NSData dataWithContentsOfURL:[NSBundle mainBundle].appStoreReceiptURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([LCMyUser mine].liveUserId) {
         params[@"liveuid"] = [LCMyUser mine].liveUserId;
    }
    params[@"receipt-data"] = [data base64EncodedStringWithOptions:0];
    
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:params
                                                  withPath:@"pay/apple"
                                               withRESTful:POST_REQUEST
                                          withSuccessBlock:success
                                             withFailBlock:fail];
   
}
@end