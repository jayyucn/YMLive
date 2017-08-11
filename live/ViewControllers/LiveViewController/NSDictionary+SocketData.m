//
//  NSDictionary+SocketData.m
//  TaoHuaLive
//
//  Created by Jay on 2017/7/24.
//  Copyright © 2017年 上海七夕. All rights reserved.
//

#import "NSDictionary+SocketData.h"

@implementation NSDictionary (SocketData)

- (NSData *)socketData
{
    NSError* error;
    //先转nsdata再转nsstring是为了保证nsdictionary格式不变
    NSData *createData= [NSJSONSerialization dataWithJSONObject:self
                                                        options:NSJSONWritingPrettyPrinted
                                                          error:&error];
    NSString* jsonString=[[NSString alloc] initWithData:createData
                                         encoding:NSUTF8StringEncoding];
    jsonString=[jsonString stringByReplacingOccurrencesOfString:@"\n"
                                         withString:@""];
    jsonString=[jsonString stringByReplacingOccurrencesOfString:@" "
                                         withString:@""];
    jsonString=[jsonString stringByAppendingString:@"\\n"];
    
    return [jsonString dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSDictionary *)dictionaryWithRecievedData:(NSData *)data
{
    NSString *dataString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSString *jsonString = [dataString substringFromIndex:9];
//    jsonString=[jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    jsonString=[jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return [NSDictionary dictionaryWithJsonString:jsonString];
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    id obj = [NSDictionary objcetWithJsonString:jsonString];
    return [obj isKindOfClass:[NSDictionary class]] ? obj : nil;
}

+ (id)objcetWithJsonString:(NSString *)jsonString
{
  
    NSError *error = nil;
    id tempObj = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    if ([tempObj isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:tempObj];
        __weak typeof(dict)weakDict = dict;
        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                NSString *subObjStr = (NSString *)obj;
                if ([NSDictionary isJSONString:subObjStr]) {
                    id returnObj = [NSDictionary objcetWithJsonString:subObjStr];
                    [weakDict setValue:returnObj forKey:key];
                }
            }
        }];
        tempObj = dict;
    }else if([tempObj isKindOfClass:[NSArray class]]){
        NSMutableArray *array = [NSMutableArray arrayWithArray:tempObj];
        for (id subObj in array) {
            if ([subObj isKindOfClass:[NSString class]]) {
                NSString *subObjStr = (NSString *)subObj;
                if ([NSDictionary isJSONString:subObjStr]) {
                   id returnObj = [NSDictionary objcetWithJsonString:subObjStr];
                    [array replaceObject:subObj withObject:returnObj];
                }
            }
        }
        tempObj = array;
    }
    
    return tempObj;
}
+ (BOOL)isJSONString:(NSString *)string
{
    NSError *error = nil;
    [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    
    return error?NO:YES;
}

@end
