//
//  MenuItem.h
//  Fitel
//
//  Created by 陈耀武 on 14-1-16.
//  Copyright (c) 2014年 Fitel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MenuAbleItem.h"

#import "KeyValue.h"

@interface MenuItem : NSObject<MenuAbleItem>

@property (nonatomic, copy) MenuAction action;

@end

@interface SettingMenuItem : MenuItem

@property (nonatomic, strong) KeyValue *value;

@end


