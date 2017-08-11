//
//  LocationManager.h
//  qianchuo
//
//  Created by jacklong on 16/5/7.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//


@interface LocationManager : NSObject<CLLocationManagerDelegate>

ES_SINGLETON_DEC(locationManager);

#pragma mark - 开始登录
- (void) startUpdateLocation;

@end
