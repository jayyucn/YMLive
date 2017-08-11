//
//  KSYLiveInitManager.m
//  qianchuo 金山云初始管理
//
//  Created by jacklong on 16/4/6.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "KSYLiveInitManager.h" 

@implementation KSYLiveInitManager

ES_SINGLETON_IMP(ksylive);

- (id)init
{
    self = [super init];
    if (self) {
//        NSString* time = [NSString stringWithFormat:@"%d",(int)[[NSDate date]timeIntervalSince1970]];
//        NSString* sk = [NSString stringWithFormat:@"s77sdlkjdlkjslkdlskldd%@", time];
//        NSString* sksign = [KSYAuthInfo KSYMD5:sk];
//        [[KSYAuthInfo sharedInstance]setAuthInfo:kKSYAppID  accessKey:kKSYAccessKey secretKeySign:sksign timeSeconds:time];
    }
    return self;
}


@end
