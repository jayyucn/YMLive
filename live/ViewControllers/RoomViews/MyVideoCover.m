//
//  MyVideoCover.m
//  live
//
//  Created by AlexiChen on 15/10/28.
//  Copyright © 2015年 kenneth. All rights reserved.
//

#import "MyVideoCover.h"

@implementation MyVideoCover

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)setup
{

}

- (void)awakeFromNib
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
