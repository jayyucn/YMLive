//
//  NSObject+LYDealloc.m
//  TaoHuaLive
//
//  Created by 林伟池 on 2017/1/18.
//  Copyright © 2017年 上海七夕. All rights reserved.
//

#import "NSObject+LYDealloc.h"
#import<objc/objc.h>
#import<objc/runtime.h>

const char *kDeallcing = "deallocing";
@interface NSObjectHooker : NSObject

@end


@implementation NSObjectHooker

+ (void)hookMethedClass:(Class)class hookSEL:(SEL)hookSEL originalSEL:(SEL)originalSEL myselfSEL:(SEL)mySelfSEL
{
    Method hookMethod = class_getInstanceMethod(class, hookSEL);
    Method mySelfMethod = class_getInstanceMethod([self class], mySelfSEL);
    
    IMP hookMethodIMP = method_getImplementation(hookMethod);
    class_addMethod(class, originalSEL, hookMethodIMP, method_getTypeEncoding(hookMethod));
    
    IMP hookMethodMySelfIMP = method_getImplementation(mySelfMethod);
    class_replaceMethod(class, hookSEL, hookMethodMySelfIMP, method_getTypeEncoding(hookMethod));
}

+ (void)hookNSObjectDealloc
{
    SEL deallocSelector = NSSelectorFromString(@"dealloc");
    [self hookMethedClass:NSClassFromString(@"NSObject")
                  hookSEL:deallocSelector
              originalSEL:@selector(originalDealloc)
                myselfSEL:@selector(myselfDealloc)];
}

- (void)myselfDealloc
{
    DeallocCallback callback = [self deallocCallback];
    if (callback) {
        callback();
    }
    
    [self originalDealloc];
}

- (void)originalDealloc
{
    
}
@end

@implementation NSObject(Deallocing)

+ (void)hookNSObjectDealloc
{
    [NSObjectHooker hookNSObjectDealloc];
}

- (void)setDeallocCallback:(DeallocCallback)callback
{
    objc_setAssociatedObject(self, kDeallcing, callback, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (DeallocCallback)deallocCallback
{
    DeallocCallback callback = (DeallocCallback)objc_getAssociatedObject(self, kDeallcing);
    return callback;
}

@end
