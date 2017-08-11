//
//  ChatUtil.h
//  qianchuo
//
//  Created by 林伟池 on 16/5/24.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatUtil : NSObject





#pragma mark - init
+ (instancetype)shareInstance;


#pragma mark - update



#pragma mark - get

- (NSString *)getFilterStringWithSrc:(NSString *)srcString;


#pragma mark - message

#pragma mark - 下载脏词文件
- (void) downLoadDirtyFile:(NSString*)fileUrl;

@end
