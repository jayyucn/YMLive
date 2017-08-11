//
//  AnimationImageCache.h
//  qianchuo
//
//  Created by 林伟池 on 16/7/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IMAGE_CACHE_BASE_PATH ([[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/image/animation/"])

#define IMAGE_CACHE_DRIVE_PATH ([[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/image/drive/"])



@interface AnimationImageCache : NSObject


#pragma mark - init
+ (instancetype)shareInstance;


#pragma mark - update



#pragma mark - get

- (UIImage *)getImageWithName:(NSString *)name;

- (UIImage *)getDriveImageWithName:(NSString *)name;

#pragma mark - message


@end
