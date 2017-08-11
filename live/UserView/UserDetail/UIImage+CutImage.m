//
//  UIImage+CutImage.m
//  XCLive
//
//  Created by ztkztk on 14-5-21.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "UIImage+CutImage.h"

@implementation UIImage (CutImage)

-(UIImage *)getImageWithRect:(CGRect)rect
{
    CGImageRef imageRef =self.CGImage;
    CGImageRef imageRefRect = CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *imageRect = [[UIImage alloc] initWithCGImage:imageRefRect];
    CGImageRelease(imageRefRect); // fix memory leak
    
    return imageRect;
}


@end
