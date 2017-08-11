//
//  UIImage+Category.h
//  live
//
//  Created by kenneth on 15-7-9.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;
+ (UIImage *)imageWithImage:(UIImage *)image scaleToSize:(CGSize)size;
+ (UIImage*) createImageWithColor: (UIColor*) color;
- (UIImage*)getSubImage:(CGRect)rect;

// 创建用户等级图片
+ (UIImage *)createUserGradeImage:(int)userGrade withIsManager:(BOOL)isManager;

// 创建用户等级标记图片
+ (UIImage *)createUserGradeFlagImage:(int)userGrade withIsManager:(BOOL) isManager;

+ (UIImage *)createContentsOfFile:(NSString *)imageNameStr;
@end
