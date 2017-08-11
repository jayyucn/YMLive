//
//  SendGiftRequest.h
//  qianchuo
//
//  Created by jacklong on 16/3/5.
//  Copyright © 2016年 kenneth. All rights reserved.
//


@interface SendGiftRequest : NSObject

+(void)sendGift:(NSDictionary *)parameters succeed:(LCRequestSuccessResponseBlock)succeedBlock failed:(LCRequestFailResponseBlock)failedBlock;

+(void)sendDrawGift:(NSDictionary *)parameters succeed:(LCRequestSuccessResponseBlock)succeedBlock failed:(LCRequestFailResponseBlock)failedBlock;
@end
