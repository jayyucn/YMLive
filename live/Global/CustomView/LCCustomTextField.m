//
//  LCCustomTextField.m
//  XCLive
//
//  Created by ztkztk on 14-5-22.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCCustomTextField.h"

@implementation LCCustomTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor whiteColor];
    }
    return self;
}



//控制placeHolder的位置
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 20, 0);
}

//控制文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 20, 0);
}



@end
