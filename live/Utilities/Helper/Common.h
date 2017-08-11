// 
//  Common.h
//  live
//
//  Created by jacklong on 15/7/29.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Common : NSObject
+ (Common *) sharedInstance;
-(void)shakeView:(UIView*)viewToShake;
-(BOOL) isValidateMobile:(NSString *)mobile;

// 获取请求1v1间隔时间
- (BOOL) isCanRequestOTOTime:(NSString *)userId;

// 保存请求1v1成功的时间
- (void) saveRequestOTOTime:(NSString *)userId;
@end
