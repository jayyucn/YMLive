//
//  UIView+ReleativeCoordinate.h
//  TCPlayerDemo
//
//  Created by AlexiChen on 15/8/17.
//  Copyright (c) 2015年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ReleativeCoordinate)

// 是不是某个控
- (BOOL)isSubContentOf:(UIView *)aSuperView;

- (CGRect)relativePositionTo:(UIView *)aSuperView;

@end
