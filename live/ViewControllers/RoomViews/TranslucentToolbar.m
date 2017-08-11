//
//  TranslucentToolbar.m
//  qianchuo
//
//  Created by jacklong on 16/3/3.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "TranslucentToolbar.h"

@implementation TranslucentToolbar

- (id)initWithFrame:(CGRect)aRect {
    if((self= [super initWithFrame:aRect])) {
        self.opaque=NO;
        self.backgroundColor= [UIColor colorWithRed:34.0/255.0 green:39.0/255.0 blue:42.0/255.0 alpha:0.8];
        self.clearsContextBeforeDrawing=YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
@end
