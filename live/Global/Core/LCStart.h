//
//  KFPreReady.h
//  KaiFang
//
//  Created by ztkztk on 13-12-4.
//  Copyright (c) 2013年 www.0x123.com. All rights reserved.
//
 
//#import "LocationManager.h"


@interface LCStart : NSObject

//@property (nonatomic,strong)LocationManager *locationManager;

+ (LCStart *)sharedStart;
-(void)requestForStart:(BOOL)first;
//+(void)requestForSyn:(BOOL)first withLocation:(NSDictionary *)location;

+(void)sendPushTokenToSever:(NSString *)token;
//-(void)test;

+(void)firstLoadView:(NSDictionary *)responseDic;

@end
