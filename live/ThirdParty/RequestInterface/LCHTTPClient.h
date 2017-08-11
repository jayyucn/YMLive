//
//  WeatherHTTPClient.h
//  Weather
//
//  Created by Scott on 02/02/2013.
//  Copyright (c) 2013 Scott Sherwood. All rights reserved.
//
#import <AFNetworking.h>

typedef NS_ENUM(NSInteger, RESTfulType) {
    GET_REQUEST = 0,
    POST_REQUEST,
    PUT_REQUEST,
    DELETE_REQUEST,
};


@interface LCHTTPClient : AFHTTPSessionManager

+ (LCHTTPClient *)sharedHTTPClient;
-(void)addNetworkChangeNotification;
-(void)removeNetworkChangeNotification;


//网络请求接口
-(void)requestWithParameters:(NSDictionary *)parameters
                    withPath:(NSString *)subPath
                 withRESTful:(RESTfulType)requestType
            withSuccessBlock:(LCRequestSuccessResponseBlock)successBlock
               withFailBlock:(LCRequestFailResponseBlock)failBlock;



//上传图片
-(void)upLoadImage:(UIImage *)image
         withParam:(NSDictionary*)paramters
          withPath:(NSString *)subPath
          progress:(void (^)(NSProgress *progress))uploadProgressBlock
       withRESTful:(RESTfulType)requestType
  withSuccessBlock:(LCRequestSuccessResponseBlock)successBlock
     withFailBlock:(LCRequestFailResponseBlock)failBlock;


@end


