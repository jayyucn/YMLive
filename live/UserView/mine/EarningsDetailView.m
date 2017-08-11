//
//  EarningsDetailView.m
//  XCLive
//
//  Created by jacklong on 16/1/20.
//  Copyright © 2016年 www.yuanphone.com. All rights reserved.
//

#import "EarningsDetailView.h"

@implementation EarningsDetailView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _headView = [[UIView alloc] init];
        _headView.frame = CGRectMake(0, 1, ScreenWidth, 120.f);
        _headView.backgroundColor = ColorPink;
        [self addSubview:_headView];
        
        UIImage * icon = [UIImage imageNamed:@"mall_cions"];
        _iconImg = [[UIImageView alloc] init];
        _iconImg.frame = CGRectMake(25.f, 25.f, icon.size.width, icon.size.height);
        [self addSubview:_iconImg];
        
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.frame = CGRectMake(_iconImg.right+3, _iconImg.top, 100, 20);
        _promptLabel.text = @"星币";
        [self addSubview:_promptLabel];
        
        _recvDiamondLabel = [[UILabel alloc] init];
        _recvDiamondLabel.frame = CGRectMake(_iconImg.left, _iconImg.bottom+20.f, 200, 50);
        
        [self addSubview:_recvDiamondLabel];
    }
    return self;
}


-(void)updateIncomeView
{

}
@end
