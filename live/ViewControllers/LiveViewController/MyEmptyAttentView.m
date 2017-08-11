//
//  MyEmptyAttendView.m
//  qianchuo
//
//  Created by 林伟池 on 16/5/7.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "MyEmptyAttentView.h"

@implementation MyEmptyAttentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    UIView* view = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:nil options:nil] lastObject];
    self.mButton = [view viewWithTag:110];
    [view setFrame:frame];
    [self addSubview:view];
    
    return self;
}

@end
