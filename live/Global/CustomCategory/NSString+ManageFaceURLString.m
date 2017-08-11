//
//  NSString+ManageFaceURLString.m
//  KaiFang
//
//  Created by ztkztk on 13-10-24.
//  Copyright (c) 2013年 www.0x123.com. All rights reserved.
//

#import "NSString+ManageFaceURLString.h"
#import "LCDefines.h"


@implementation NSString (ManageFaceURLString)


//face URL 增补前缀 

+(NSString *)faceURLString:(NSString *) initialString
{
    if ([initialString isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    if([initialString hasPrefix:@"http:"] || [initialString hasPrefix:@"https:"])
    {
        return initialString;
    }
    else
    {
        if(initialString)
            return [URL_PHOTO_HEAD stringByAppendingString:initialString];
        else
            return nil;
    }

}


-(NSString *)addLocation
{
    NSString *urlString=self;
   // if(![[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKey_SubmitLocation] boolValue])
  //  {
        NSDictionary *dic=[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKey_Location];
        if(dic)
        {
            urlString=[NSString stringWithFormat:@"%@/?address=%@&latitude=%@&longitude=%@",self,\
                       [(NSString *)dic[@"address"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],\
                       dic[@"latitude"],\
                       dic[@"longitude"]];
            
        }
        
   // }
    

    return urlString;
}


@end
