//
//  UIImage+KFCutImage.h
//  KaiFang
//
//  Created by ztkztk on 13-11-12.
//  Copyright (c) 2013年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (KFCutImage)
-(UIImage *)getImageWithRect:(CGRect)rect;//切图
-(UIImage *)imageRotatedByDegrees:(CGFloat)degrees;//图片翻转
-(UIImage *)interceptionImageWithFrameDic:(NSDictionary *)dic;//自定义获取图片，根据dic

@end
