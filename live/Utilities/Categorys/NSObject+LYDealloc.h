//
//  NSObject+LYDealloc.h
//  TaoHuaLive
//
//  Created by 林伟池 on 2017/1/18.
//  Copyright © 2017年 上海七夕. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef void (^DeallocCallback)();

@interface NSObject(Deallocing)

+ (void)hookNSObjectDealloc;

- (void)setDeallocCallback:(DeallocCallback)callback;

- (DeallocCallback)deallocCallback;

@end
