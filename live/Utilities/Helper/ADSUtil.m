//
//  ADSUtil.m
//  qianchuo
//
//  Created by 林伟池 on 16/7/4.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ADSUtil.h"
#import "LCHTTPClient.h"

@implementation ADSUtil


+ (void)requestServerWithString:(NSString *)memo {
    ESWeakSelf;
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        ESStrongSelf;
        NSLog(@"ADSresponseDic=%@",responseDic);
        
        int stat=[responseDic[@"stat"] intValue];
        if(stat==200)
        {
            
        }
        else
        {
//            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
        
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        NSLog(@"ADSerror=%@",error);
    };
    if (!memo) {
        memo = @" ";
    }
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"word":memo}
                                                  withPath:URL_UPLOAD_MSG
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}

+ (NSString *)requestLocaleString {
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    NSLog ( @"%@" , currentLanguage);
    return currentLanguage;
}

@end
