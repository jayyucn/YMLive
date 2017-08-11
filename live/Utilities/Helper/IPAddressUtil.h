//
//  IPAddressUtil.h
//  qianchuo
//
//  Created by 林伟池 on 16/6/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IPAddressTimestampKey @"IPAddressTimestampKey"
#define ServerIPAddressKey @"ServerIPAddressKey"

@interface IPAddressUtil : NSObject

+ (NSString *)getIPAddressIsIPv4:(BOOL)preferIPv4;

+ (BOOL)isValidatIP:(NSString *)ipAddress;



@end
