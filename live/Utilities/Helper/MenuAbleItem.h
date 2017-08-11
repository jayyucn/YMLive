//
//  MenuAbleItem.h
//  Fitel
//
//  Created by 陈耀武 on 14-1-16.
//  Copyright (c) 2014年 Fitel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol MenuAbleItem;

typedef void (^MenuAction)(id<MenuAbleItem> menu);

@protocol MenuAbleItem <NSObject>


- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon action:(MenuAction)action;

@optional
- (NSString *)title;
- (UIImage *)icon;
- (void)menuAction;
- (NSInteger)tag;
- (void)setTag:(NSInteger)tag;

@end
