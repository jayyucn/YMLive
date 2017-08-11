//
//  NSString+ManageFaceURLString.h
//  KaiFang
//
//  Created by ztkztk on 13-10-24.
//  Copyright (c) 2013年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ManageFaceURLString)
+(NSString *)faceURLString:(NSString *) initialString;
-(NSString *)addLocation;
@end
