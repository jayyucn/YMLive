//
//  DiscoverModel.h
//  QXLoveCity
//
//  Created by 王威 on 15/5/25.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//


#import "JSONModel.h"

@interface DiscoverModel : JSONModel

@property (nonatomic, strong) NSString                  *name;
@property (nonatomic, strong) NSString                  *type;
@property (nonatomic, strong) NSString <Optional>       *memo;

@property (nonatomic, assign) int                       group;

// 0 gray | 1 red | 2 blue
@property (nonatomic, assign) int                       color;

@property (nonatomic, strong) NSURL    <Optional>       *ico;
@property (nonatomic, strong) NSString <Optional>       *url;
@property (nonatomic, strong) NSNumber <Ignore>         *hidden;

@end
