//
//  Common.m
//  live
//
//  Created by hysd on 15/7/29.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import "Common.h"
#import "Macro.h"

#define SEQ_TIME        60// 成功的间隔时间
static Common *sharedObj = nil; //第一步：静态实例，并初始化。
@implementation Common
+ (Common*) sharedInstance  //第二步：实例构造检查静态实例是否为nil
{
    @synchronized (self)
    {
        if (sharedObj == nil)
        {
            sharedObj = [[self alloc] init];
        }
    }
    return sharedObj;
}
+ (id) allocWithZone:(NSZone *)zone //第三步：重写allocWithZone方法
{
    @synchronized (self) {
        if (sharedObj == nil) {
            sharedObj = [super allocWithZone:zone];
            return sharedObj;
        }
    }
    return nil;
}
- (id) copyWithZone:(NSZone *)zone //第四步
{
    return self;
}

#pragma mark 抖动
- (void)shakeView:(UIView*)viewToShake
{
    CGFloat t =4.0;
    CGAffineTransform translateRight  =CGAffineTransformTranslate(CGAffineTransformIdentity, t,0.0);
    CGAffineTransform translateLeft =CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
    viewToShake.transform = translateLeft;
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        viewToShake.transform = translateRight;
    } completion:^(BOOL finished){
        if(finished){
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform =CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}
#pragma mark 手机号码验证
/*
 电话号码
 移动  134［0-8］ 135 136 137 138 139 150 151 152 158 159 182 183 184 157 187 188 147 178
 联通  130 131 132 155 156 145 185 186 176
 电信  133 153 180 181 189 177
 
 上网卡专属号段
 移动 147
 联通 145
 
 虚拟运营商专属号段
 移动 1705
 联通 1709
 电信 170 1700
 
 卫星通信 1349
 */

-(BOOL) isValidateMobile:(NSString *)mobile
{
    NSString * phoneRegex = @"^1(3[0-9]|4[57]|5[0-35-9]|(7[0[059]|6｜7｜8])|8[0-9])\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

- (BOOL) isCanRequestOTOTime:(NSString *)userId
{
    NSMutableDictionary *seqTimeDict = [[NSUserDefaults standardUserDefaults] objectForKey:kUserOTORequestSeqTime];
    if (!seqTimeDict) {
        return YES;
    }
    
    NSString *time = seqTimeDict[userId];
   
    if (time) {
        NSTimeInterval newTime = [[NSDate date] timeIntervalSince1970];
        
        if (newTime - time.longLongValue > SEQ_TIME) {
            return YES;
        } else {// 不能请求1v1时间间隔短
            return NO;
        }
    }
    
    return  YES;
}

// 保存请求1v1成功的时间
- (void) saveRequestOTOTime:(NSString *)userId
{
    NSMutableDictionary *seqTimeDict = [[NSUserDefaults standardUserDefaults] objectForKey:kUserOTORequestSeqTime];
    if (!seqTimeDict) {
        seqTimeDict = [NSMutableDictionary dictionary];
    } else {
        seqTimeDict = [NSMutableDictionary dictionaryWithDictionary:seqTimeDict];
    }
    
    NSString *time = seqTimeDict[userId];
    if (time) {
        seqTimeDict[userId] = [NSString stringWithFormat:@"%@",@([[NSDate date] timeIntervalSince1970])];
    } else {
        [seqTimeDict setObject:[NSString stringWithFormat:@"%@",@([[NSDate date] timeIntervalSince1970])]  forKey:userId];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:seqTimeDict forKey:kUserOTORequestSeqTime];
}
@end

