//
//  NSDictionary+AddLocation.m
//  XCLive
//
//  Created by ztkztk on 14-4-30.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "NSDictionary+AddLocation.h"
#import "LCDefines.h"

@implementation NSDictionary (AddLocation)
-(NSDictionary *)addlocationDic
{
    NSMutableDictionary *parameters=[NSMutableDictionary dictionaryWithDictionary:self];
    //if(![[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKey_SubmitLocation] boolValue])
    //{
        NSDictionary *dic=[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKey_Location];
        if(dic)
            [parameters addEntriesFromDictionary:dic];
    //}
    return parameters;

}


-(NSDictionary *)addLatAndLon
{
    NSMutableDictionary *parameters=[NSMutableDictionary dictionaryWithDictionary:self];
    //if(![[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKey_SubmitLocation] boolValue])
    //{
    NSDictionary *dic=[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKey_Location];
    if(dic)
    {
        [parameters addEntriesFromDictionary:dic];
        
        [parameters removeObjectForKey:@"address"];
    }
    //}
    return parameters;
    
}

-(NSDictionary *)addRadarLatAndLon
{
    NSMutableDictionary *parameters=[NSMutableDictionary dictionaryWithDictionary:self];
    //if(![[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKey_SubmitLocation] boolValue])
    //{
    NSDictionary *dic=[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKey_Location];
    if(dic)
    {
        
        [parameters setObject:dic[@"latitude"] forKey:@"lat"];
        [parameters setObject:dic[@"longitude"] forKey:@"lon"];
    }
    //}
    return parameters;
    
}


@end
