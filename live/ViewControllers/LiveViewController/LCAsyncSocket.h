//
//  LCAsyncSocket.h
//  TaoHuaLive
//
//  Created by Jay on 2017/7/24.
//  Copyright © 2017年 上海七夕. All rights reserved.
//

#import "GCDAsyncSocket.h"

@interface LCAsyncSocket : GCDAsyncSocket


- (void)writeData:(NSData *)data
          withTag:(long)tag
          Success:(void(^)(LCAsyncSocket *sock, long tag))success
         response:(void(^)(LCAsyncSocket *sock, NSDictionary *response, long tag))response;

@end
