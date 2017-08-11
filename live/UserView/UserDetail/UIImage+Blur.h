//
//  UIImage+Blur.h
//  XCLive
//
//  Created by ztkztk on 14-5-16.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Blur)
-(UIImage *)boxblurImageWithBlur:(CGFloat)blur;

-(UIImage *)TransformtoSize:(CGSize)Newsize;

- (UIImage*)resizeImage:(UIImage*)image withWidth:(CGFloat)width withHeight:(CGFloat)height;
@end
