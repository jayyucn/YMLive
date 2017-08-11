//
//  ShowLuxuryGiftView.m
//  qianchuo
//
//  Created by jacklong on 16/3/17.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "ShowLuxuryGiftView.h"
#import "LiveGiftFile.h"

@implementation ShowLuxuryGiftView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _luxuryImg = [[UIImageView  alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH*2/3, SCREEN_WIDTH*2/3)];
        [self addSubview:_luxuryImg];
    }
    return self;
}



@end
