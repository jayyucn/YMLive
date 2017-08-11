//
//  SendGiftRequest.m
//  qianchuo
//
//  Created by jacklong on 16/3/5.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "SendGiftRequest.h"

@implementation SendGiftRequest

+(void)sendGift:(NSDictionary *)parameters succeed:(LCRequestSuccessResponseBlock)succeedBlock failed:(LCRequestFailResponseBlock)failedBlock
{
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameters
                                                    withPath:URL_LIVE_SENG_GIFT_URL
                                                 withRESTful:GET_REQUEST
                                            withSuccessBlock:succeedBlock
                                               withFailBlock:failedBlock];
}


+(void)sendDrawGift:(NSDictionary *)parameters succeed:(LCRequestSuccessResponseBlock)succeedBlock failed:(LCRequestFailResponseBlock)failedBlock
{
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameters
                                                  withPath:URL_LIVE_DRAW_GIFT_URL
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:succeedBlock
                                             withFailBlock:failedBlock];
}
@end
