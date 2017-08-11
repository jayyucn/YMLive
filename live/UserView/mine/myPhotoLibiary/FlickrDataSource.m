//
//  SDWebImageDataSource.m
//  Sample
//
//  Created by Kirby Turner on 3/18/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "FlickrDataSource.h"

#define FULL_SIZE_INDEX 0
#define THUMBNAIL_INDEX 1

@implementation FlickrDataSource


- (id)init {
   self = [super init];
   if (self) {
      // Create a 2-dimensional array. First element of
      // the sub-array is the full size image URL and 
      // the second element is the thumbnail URL.
       
       
       /*
       
       {
           id = 20;
           url = "http://img.yuanphone.com/photo/31/135055671398180886.jpg";
       },
        */
       
       
   }
   return self;
}

- (UIImage *)imageWithURLString:(NSString *)string {
    
    
    NSURL *url = [NSURL URLWithString:string];
   NSData *data = [NSData dataWithContentsOfURL:url];
   UIImage *image = [UIImage imageWithData:data];
   return image;
}

#pragma mark -
#pragma mark KTPhotoBrowserDataSource

- (NSInteger)numberOfPhotos {
   NSInteger count = [_images count];
   return count;
}



- (UIImage *)imageAtIndex:(NSInteger)index {
     return [self imageWithURLString:_images[index][@"url"]];
}

- (UIImage *)thumbImageAtIndex:(NSInteger)index {
    NSArray *imageUrls = [_images objectAtIndex:index];
    NSString *url = [imageUrls objectAtIndex:THUMBNAIL_INDEX];
    
    return [self imageWithURLString:url];
}

/*
- (UIImage *)imageAtIndex:(NSInteger)index {
   NSArray *imageUrls = [images_ objectAtIndex:index];
   NSString *url = [imageUrls objectAtIndex:FULL_SIZE_INDEX];

   return [self imageWithURLString:url];
}

- (UIImage *)thumbImageAtIndex:(NSInteger)index {
   NSArray *imageUrls = [images_ objectAtIndex:index];
   NSString *url = [imageUrls objectAtIndex:THUMBNAIL_INDEX];

   return [self imageWithURLString:url];
}
 */

@end
