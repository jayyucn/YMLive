//
//  NSString+LCAppendString.m
//  XCLive
//
//  Created by ztkztk on 14-5-27.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "NSString+LCAppendString.h"

@implementation NSString (LCAppendString)

+(NSString *)customAppendString:(NSString *)string1 string2:(NSString *)string2
{
    NSString *resultString=@"";
    
    if(string1.length!=0)
    {
        resultString=[resultString stringByAppendingString:string1];
        if(string2.length!=0)
        {
            resultString=[resultString stringByAppendingString:@" | "];
            resultString=[resultString stringByAppendingString:string2];
        }
    }else{
        if(string2.length!=0)
        {
            resultString=[resultString stringByAppendingString:string2];
        }

    }
    return resultString;
}


-(NSString *)getEmailAddress
{
    
    
    
    //qq:
    NSArray *qqEmails=@[@"@qq.com",@"@vip.qq.com",@"@foxmail.com"];
    
    for(NSString *emailString in qqEmails)
    {
        NSRange searchRange = [self rangeOfString:emailString];//QQ
        
        if(searchRange.location != NSNotFound)//包含
        {
            return @"http://w.mail.qq.com/cgi-bin/loginpage?f=xhtml&ad=false&f=xhtml";
            
        }
        
    }
    
    
    //wang yi
    NSArray *wyEmails=@[@"@163.com",@"@126.com",@"@yeah.net",@"@vip.163.com",@"@vip.126.com",@"@188.com"];
    
    for(NSString *emailString in wyEmails)
    {
        NSRange searchRange = [self rangeOfString:emailString];
        
        if(searchRange.location != NSNotFound)//包含
        {
           
            return @"http://m.mail.163.com/";
            
        }
        
    }
    
    
    // google
    
    NSRange searchRange = [self rangeOfString:@"@gmail.com"];
    
    if(searchRange.location != NSNotFound)//包含
    {
        return @"http://mail.google.com";
        
    }
    
    return nil;
    
    
}



@end
