//
//  LCAsyncSocket.m
//  TaoHuaLive
//
//  Created by Jay on 2017/7/24.
//  Copyright © 2017年 上海七夕. All rights reserved.
//

#import "LCAsyncSocket.h"

@interface LCAsyncSocket ()

@end

@implementation LCAsyncSocket

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)writeData:(NSData *)data
          withTag:(long)tag
          Success:(void (^)(LCAsyncSocket *, long))success
         response:(void (^)(LCAsyncSocket *, NSDictionary *, long))response
{
    [super writeData:data withTimeout:-1 tag:tag];
}


@end
