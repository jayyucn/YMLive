//
//  LocationManager.m
//  qianchuo 定位
//
//  Created by jacklong on 16/5/7.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//


#import "LocationManager.h"
#import "LCUser.h"


@interface LocationManager()
{
    CLLocationManager *locationManager;
    
    BOOL isStartUpdateLocation;
}

@end


@implementation LocationManager

ES_SINGLETON_IMP(locationManager);

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        locationManager.delegate = self;
        [locationManager startUpdatingLocation];
        isStartUpdateLocation = YES;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            // 调用了这句，就会弹出允许框了
            [locationManager requestWhenInUseAuthorization];
        }
    }
    
    return self;
}

#pragma mark - 定位的回调
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    /*
    [HUD hideText:@"定位出错" atMode:MBProgressHUDModeText andDelay:1 andCompletion:^{
        [self avExitRoom];
    }];
     */
    
    NSLog(@"定位出错");
    if (!isStartUpdateLocation)
    {
        return;
    }
    
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocatioin = locations[0];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    ESWeakSelf;
    
    [geocoder reverseGeocodeLocation:newLocatioin completionHandler:^(NSArray *placemarks, NSError *error)
    {
        if (!isStartUpdateLocation)
        {
            return;
        }
        ESStrongSelf;
        
        if (error)
        {
            NSLog(@"get location failed with error = %@", error);
            [locationManager stopUpdatingLocation];
        }
        else
        {
            isStartUpdateLocation = NO;
            if (![[LCMyUser mine] hasLogged])
            {
                return;
            }
            
            CLPlacemark *placeMark = placemarks[0];
            [LCMyUser mine].curlongi = placeMark.location.coordinate.longitude;
            [LCMyUser mine].curlati = placeMark.location.coordinate.latitude;
            
            // 记录地址
            
            NSLog(@"get location succeeded with country:%@ city:%@ || sublocation:%@ name:%@ || lat:%f lon:%f", placeMark.country, placeMark.locality, placeMark.subLocality, placeMark.name, placeMark.location.coordinate.latitude, placeMark.location.coordinate.longitude);
            
            [_self uploadLocationInfo:placeMark.locality withCLLocation:placeMark.location];
        }
    }];
}

// 上传位置信息
- (void)uploadLocationInfo:(NSString *)city withCLLocation:(CLLocation *)location
{
    LCRequestSuccessResponseBlock successBlock = ^(NSDictionary *responseDic)
    {
        if (URL_REQUEST_SUCCESS == [[responseDic objectForKey:@"stat"] integerValue])
        {
            NSLog(@"location succ");
        }
        else
        {
            NSLog(@"location fail:%@", responseDic[@"msg"]);
        }
    };
    
    LCRequestFailResponseBlock failBlock = ^(NSError *error)
    {
        // if needed
    };
    
    if (!city)
    {
        city = @"未知";
    }
    
    NSDictionary *parameter = @{@"lat":[NSNumber numberWithFloat:location.coordinate.latitude], @"lng":[NSNumber numberWithFloat:location.coordinate.longitude], @"city":city};
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameter
                                                  withPath:@"profile/latlng"
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}

#pragma mark - 开始登录
- (void)startUpdateLocation
{
    isStartUpdateLocation = YES;
}

@end
