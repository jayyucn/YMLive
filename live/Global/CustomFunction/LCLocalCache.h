//
//  LCLocalCache.h
//  XCLive
//
//  Created by ztkztk on 14-7-8.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCLocalCache : NSObject

+(void)saveMyUser:(NSDictionary *)myUser;




//+(void)savePhotoLibrary:(NSDictionary *)photoList page:(int)page;
//+(NSDictionary *)readPhotoLibrary:(int)page;


+(void)savePhotoLibrary:(NSArray *)photoList;
+(NSArray *)readPhotoLibrary;



@end
