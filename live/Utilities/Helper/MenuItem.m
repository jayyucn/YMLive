//
//  MenuItem.m
//  Fitel
//
//  Created by 陈耀武 on 14-1-16.
//  Copyright (c) 2014年 Fitel. All rights reserved.
//

#import "MenuItem.h"

@interface MenuItem ()


@property (nonatomic, copy) NSString *title;
//@property (nonatomic, copy) MenuAction action;
@property (nonatomic, strong) UIImage *icon;


@end

@implementation MenuItem

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon action:(MenuAction)action
{
    if (self = [super init]) {
        self.title = title;
        self.icon = icon;
        self.action = action;
    }
    return self;
}

- (void)menuAction
{
    if (_action)
    {
        _action(self);
    }
    
}

@end


@implementation SettingMenuItem

@end