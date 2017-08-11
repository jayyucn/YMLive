//
//  UIImage+KFCutImage.m
//  KaiFang
//
//  Created by ztkztk on 13-11-12.
//  Copyright (c) 2013年 www.0x123.com. All rights reserved.
//

#import "UIImage+KFCutImage.h"

@implementation UIImage (KFCutImage)


-(UIImage *)interceptionImageWithFrameDic:(NSDictionary *)dic
{
    CGRect getRect;
    getRect=CGRectFromString(dic[@"frame"]);
    
    BOOL rotated;
    if([dic[@"rotated"] intValue]==1)
        rotated=YES;
    else
        rotated=NO;
    
    UIImage *getImage;
    if(rotated)
    {
        getRect=CGRectMake(getRect.origin.x,getRect.origin.y,getRect.size.height,getRect.size.width);
        getImage=[self getImageWithRect:getRect];
        
        getImage=[getImage imageRotatedByDegrees:-90.0];
        
    }else
        getImage=[self getImageWithRect:getRect];
    
    
    return getImage;
    
}


-(UIImage *)getImageWithRect:(CGRect)rect
{
    CGImageRef imageRef =self.CGImage;
    CGImageRef imageRefRect = CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *imageRect = [[UIImage alloc] initWithCGImage:imageRefRect];
        CGImageRelease(imageRefRect); // fix memory leak
        
    return imageRect;
}

//CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
//CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};

-(UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(degrees * M_PI / 180);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, degrees * M_PI / 180);
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}


@end
