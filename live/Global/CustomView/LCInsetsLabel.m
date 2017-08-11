//
//  LCInsetsLabel.m
//  XCLive
//
//  Created by ztkztk on 14-4-25.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCInsetsLabel.h"

@implementation LCInsetsLabel

@synthesize insets = _insets;

- (id)initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets {
    self = [super initWithFrame:frame];
    if(self) {
        self.insets = insets;
    }
    return self;
}

- (id)initWithInsets:(UIEdgeInsets)insets {
    self = [super init];
    if(self) {
        self.insets = insets;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}

@end

