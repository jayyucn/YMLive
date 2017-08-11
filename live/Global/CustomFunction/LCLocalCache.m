//
//  LCLocalCache.m
//  XCLive
//
//  Created by ztkztk on 14-7-8.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "LCLocalCache.h"
#import "LCMyUser.h"


@implementation LCLocalCache

+(void)saveMyUser:(NSDictionary *)myUser
{
    ESDispatchOnBackgroundQueue(^{
        NSString *path=[[LCMyUser mine] documentsDirectory];
        NSString *plist_path=[path stringByAppendingPathComponent:@"user.plist"];
        [myUser writeToFile:plist_path atomically:YES];
    });
    
}


+(NSDictionary *)readMyUserInfo
{
    
    NSString *path=[[LCMyUser mine] documentsDirectory];
    NSString *plist_path=[path stringByAppendingPathComponent:@"user.plist"];
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:plist_path]) {
        
        NSDictionary* dic = [[NSDictionary alloc] initWithContentsOfFile:plist_path];
        return dic;
    }else
        return nil;
}



/*
+(void)savePhotoLibrary:(NSDictionary *)photoList page:(int)page
{
    ESDispatchOnBackgroundQueue(^{
        NSString *path=[[LCMyUser mine] documentsDirectory];
        
        NSString *fileName=[NSString stringWithFormat:@"%d.plist",page];
        NSString *plist_path=[path stringByAppendingPathComponent:fileName];
        [photoList writeToFile:plist_path atomically:YES];
    });
    
}


+(NSDictionary *)readPhotoLibrary:(int)page
{
    NSString *path=[[LCMyUser mine] documentsDirectory];
    NSString *fileName=[NSString stringWithFormat:@"%d.plist",page];
    NSString *plist_path=[path stringByAppendingPathComponent:fileName];
    
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:plist_path]) {
        NSDictionary* dic = [[NSDictionary alloc] initWithContentsOfFile:plist_path];
        return dic;
    }else
        return nil;
}
 
 */



+(void)savePhotoLibrary:(NSArray *)photoList
{
    ESDispatchOnBackgroundQueue(^{
        NSString *path=[[LCMyUser mine] documentsDirectory];
        NSString *plist_path=[path stringByAppendingPathComponent:@"photoLibaray.plist"];
        [photoList writeToFile:plist_path atomically:YES];
    });
    
}


+(NSArray *)readPhotoLibrary
{
    NSString *path=[[LCMyUser mine] documentsDirectory];
    NSString *plist_path=[path stringByAppendingPathComponent:@"photoLibaray.plist"];
    
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:plist_path]) {
        NSArray* photoArray = [NSArray arrayWithContentsOfFile:plist_path];
        return photoArray;
    }else
        return nil;
}






@end
