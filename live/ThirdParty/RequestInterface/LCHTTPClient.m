//
//  WeatherHTTPClient.m
//  Weather
//
//  Created by Scott on 02/02/2013.
//  Copyright (c) 2013 Scott Sherwood. All rights reserved.
//

#import "LCHTTPClient.h"

@implementation LCHTTPClient



static LCHTTPClient *_sharedHTTPClient = nil;

+ (LCHTTPClient *)sharedHTTPClient
{
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        _sharedHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:[LCCore requestUrlHead]]];
        [_sharedHTTPClient.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil]];
    });
    return _sharedHTTPClient;
}


-(void)addNetworkChangeNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkingReachabilityDidChange:)
                                                 name:AFNetworkingReachabilityDidChangeNotification
                                               object:nil];
}

-(void)removeNetworkChangeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AFNetworkingReachabilityDidChangeNotification
                                                  object:nil];
}

-(void)networkingReachabilityDidChange:(NSNotification *)notification
{
    NSDictionary *userInfo=[notification userInfo];
    
    
    
    int netStatus=[userInfo[AFNetworkingReachabilityNotificationStatusItem] intValue];
    
    if(netStatus!=2)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒"
                                                        message:@"当前网络不在wifi下，请检查网络状况"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        alert.delegate=self;
        alert.tag=3;
        [alert show];
        
    }
    
}

//网络请求
-(void)requestWithParameters:(NSDictionary *)parameters
                    withPath:(NSString *)subPath
                 withRESTful:(RESTfulType)requestType
            withSuccessBlock:(LCRequestSuccessResponseBlock)successBlock
               withFailBlock:(LCRequestFailResponseBlock)failBlock
{
    //    [self setDefaultHeader:@"Accept" value:@"application/json"];
    //    [self setDefaultHeader:@"Content-Type" value:@"application/json"];
    if(requestType==GET_REQUEST)
    {
        uint64_t start = mach_absolute_time();
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self GET:subPath parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            uint64_t end = mach_absolute_time();
            mach_timebase_info_data_t timebaseInfo;
            (void) mach_timebase_info(&timebaseInfo);
            uint64_t elapsedNano = (end - start) * timebaseInfo.numer / timebaseInfo.denom;
            double elapsedSeconds = (double)elapsedNano / 1000000000.0;
            NSLog(@"%@ 请求时间：%f", subPath, elapsedSeconds);
            if(successBlock && [responseObject isKindOfClass:[NSDictionary class]]) {
                successBlock(responseObject);
            }


        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            NSLog(@"error==%@",error);
            
            if(failBlock) {
                failBlock(error);
            }
        }];
    }
    if(requestType==POST_REQUEST)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self POST:subPath parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NSDictionary *responseDic = responseObject;
            if(successBlock) {
                successBlock(responseDic);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NSLog(@"error==%@",error);
            if(failBlock) {
                failBlock(error);
            }
        }];
    }
    
}


//上传图片
-(void)upLoadImage:(UIImage *)image
         withParam:(NSDictionary*)paramters
          withPath:(NSString *)subPath
          progress:(void (^)(NSProgress * progress))uploadProgressBlock
       withRESTful:(RESTfulType)requestType
  withSuccessBlock:(LCRequestSuccessResponseBlock)successBlock
     withFailBlock:(LCRequestFailResponseBlock)failBlock
{
    NSString *imageType;
    NSData *imageData;
    NSString *imageString;
    
    //返回为JPEG图像。
    imageData = UIImagePNGRepresentation(image);
    imageType=@"image/png";
    imageString=@"uploadedfile.png";
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self POST:subPath parameters:paramters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData
                                    name:@"uploadedfile"
                                fileName:imageString
                                mimeType:imageType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        uploadProgressBlock(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (responseObject) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"error==%@",error);
        if(failBlock) {
            failBlock(error);
        }
    }];
}
@end
