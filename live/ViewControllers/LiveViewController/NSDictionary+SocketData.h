//
//  NSDictionary+SocketData.h
//  TaoHuaLive
//
//  Created by Jay on 2017/7/24.
//  Copyright © 2017年 上海七夕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SocketData)

- (NSData *)socketData;

+ (NSDictionary *)dictionaryWithRecievedData:(NSData *)data;

@end
