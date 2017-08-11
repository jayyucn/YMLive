//
//  UIImage+Category.m
//  live
//
//  Created by kenneth on 15-7-9.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import "UIImage+Category.h"

#define LEVEL_ZONE 16

@implementation UIImage (Category)
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGRect fillRect = CGRectMake(0, 0, size.width, size.height);
    CGContextSetFillColorWithColor(currentContext, color.CGColor);
    CGContextFillRect(currentContext, fillRect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIImage *newImage = nil;
    
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(UIImage*)getSubImage:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(subImageRef);
    return smallImage;
}

+ (UIImage *)createUserGradeImage:(int)userGrade withIsManager:(BOOL)isManager
{
    if (isManager) {
        return [UIImage imageNamed:@"image/yonghu/user_grade_office"];
    } else {
        UIImage *gradeImg = nil;
        if (userGrade < LEVEL_ZONE) {
            gradeImg = [UIImage imageNamed:@"image/yonghu/user_grade_1"];
        } else if (userGrade < LEVEL_ZONE*2) {
            gradeImg = [UIImage imageNamed:@"image/yonghu/user_grade_2"];
        } else if (userGrade < LEVEL_ZONE*3) {
            gradeImg = [UIImage imageNamed:@"image/yonghu/user_grade_3"];
        } else if (userGrade < LEVEL_ZONE*4) {
            gradeImg = [UIImage imageNamed:@"image/yonghu/user_grade_4"];
        } else if (userGrade < LEVEL_ZONE*5) {
            gradeImg = [UIImage imageNamed:@"image/yonghu/user_grade_5"];
        } else if (userGrade < LEVEL_ZONE*6) {
            gradeImg = [UIImage imageNamed:@"image/yonghu/user_grade_6"];
        } else if (userGrade < LEVEL_ZONE*7) {
            gradeImg = [UIImage imageNamed:@"image/yonghu/user_grade_7"];
        } else if (userGrade < LEVEL_ZONE*8) {
            gradeImg = [UIImage imageNamed:@"image/yonghu/user_grade_8"];
        } else if (userGrade < LEVEL_ZONE*9) {
            gradeImg = [UIImage imageNamed:@"image/yonghu/user_grade_9"];
        } else if (userGrade < LEVEL_ZONE*10) {
            gradeImg = [UIImage imageNamed:@"image/yonghu/user_grade_10"];
        } else if (userGrade < LEVEL_ZONE*11) {
            gradeImg = [UIImage imageNamed:@"image/yonghu/user_grade_11"];
        } else if (userGrade < LEVEL_ZONE*12) {
            gradeImg = [UIImage imageNamed:@"image/yonghu/user_grade_12"];
        } else {
            gradeImg = [UIImage imageNamed:@"image/yonghu/user_grade_13"];
        }
        return  gradeImg;
    }
}

#pragma mark - 获取等级宽度
+ (CGFloat) getGradeSize:(int)grade
{
    NSMutableString *tempStr = [NSMutableString stringWithFormat:@"%d",grade];
    CGSize size = [tempStr boundingRectWithSize:CGSizeMake(50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} context:nil].size;
    
    return size.width;
}

// 创建用户等级标记图片
+ (UIImage *)createUserGradeFlagImage:(int)userGrade withIsManager:(BOOL) isManager
{
    if (isManager) {
        return [UIImage imageNamed:@"image/yonghu/grade_flag/grade_flag_office"];
    } else {
        if (userGrade < LEVEL_ZONE) {
            return [UIImage imageNamed:@"image/yonghu/grade_flag/grade_flag_1"];
        } else if (userGrade < LEVEL_ZONE*2) {
            return [UIImage imageNamed:@"image/yonghu/grade_flag/grade_flag_2"];
        } else if (userGrade < LEVEL_ZONE*3) {
            return [UIImage imageNamed:@"image/yonghu/grade_flag/grade_flag_3"];
        } else if (userGrade < LEVEL_ZONE*4) {
            return [UIImage imageNamed:@"image/yonghu/grade_flag/grade_flag_4"];
        } else if (userGrade < LEVEL_ZONE*5) {
            return [UIImage imageNamed:@"image/yonghu/grade_flag/grade_flag_5"];
        } else if (userGrade < LEVEL_ZONE*6) {
            return [UIImage imageNamed:@"image/yonghu/grade_flag/grade_flag_6"];
        } else if (userGrade < LEVEL_ZONE*7) {
            return [UIImage imageNamed:@"image/yonghu/grade_flag/grade_flag_7"];
        } else if (userGrade < LEVEL_ZONE*8) {
            return [UIImage imageNamed:@"image/yonghu/grade_flag/grade_flag_8"];
        } else if (userGrade < LEVEL_ZONE*9) {
            return [UIImage imageNamed:@"image/yonghu/grade_flag/grade_flag_9"];
        } else if (userGrade < LEVEL_ZONE*10) {
            return [UIImage imageNamed:@"image/yonghu/grade_flag/grade_flag_10"];
        } else if (userGrade < LEVEL_ZONE*11) {
            return [UIImage imageNamed:@"image/yonghu/grade_flag/grade_flag_11"];
        } else if (userGrade < LEVEL_ZONE*12) {
            return [UIImage imageNamed:@"image/yonghu/grade_flag/grade_flag_12"];
        } else {
            return [UIImage imageNamed:@"image/yonghu/grade_flag/grade_flag_13"];
        }
    }
}

+ (UIImage *)createContentsOfFile:(NSString *)imageNameStr
{
    NSString *path = [[NSBundle mainBundle] pathForResource:imageNameStr ofType:@"png"];
    return [UIImage imageWithContentsOfFile:path];
}

@end
