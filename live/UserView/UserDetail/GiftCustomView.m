//
//  GiftCustomView.m
//  XCLive
//
//  Created by 王威 on 15/2/4.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import "GiftCustomView.h"
@interface GiftCustomView ()

@property (nonatomic, strong)UIScrollView *bgScroll;
@end

@implementation GiftCustomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.bgScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.bgScroll.pagingEnabled = YES;
        self.bgScroll.backgroundColor = [UIColor blackColor];
        [self addSubview:_bgScroll];
    }
    return self;
}

- (void)initView:(NSArray *)array
{
    int pageCount = (int)array.count / 12;
    self.bgScroll.contentSize = CGSizeMake(pageCount * self.size.width, 120);
    //每行个数
    int totalloc = 6;
    CGFloat appviewW = 40;
    CGFloat appviewH = 40;
    //间隔
    CGFloat margin = 10;
    
    for (int i = 0; i < array.count;i++)
    {
        int row = i / totalloc;//行号
        
        int loc = i % totalloc;//列号
        
        CGFloat appviewX = margin + (margin + appviewW) * loc;
        CGFloat appviewY = margin+(margin + appviewH) * row;
        
        NSString *giftUrl  = array[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        
        [btn sd_setImageWithURL:[NSURL URLWithString:giftUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@""]]; 
        btn.frame = CGRectMake(appviewX, appviewY, appviewW, appviewH); 
        [self addSubview:btn];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
