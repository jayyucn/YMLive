//
//  VideoDetailTopView.m
//  XCLive
//
//  Created by 王威 on 15/3/20.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import "VideoDetailTopView.h"

@implementation VideoDetailTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _faceImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 4, 40, 40)];
        _faceImage.layer.masksToBounds = YES;
        _faceImage.layer.cornerRadius = 18.9f;
        [self addSubview:_faceImage];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_faceImage.origin.x + 40 + 7, _faceImage.origin.y+ 5, 100, 10)];
        _nameLabel.font = [UIFont systemFontOfSize:14.f];
        _nameLabel.textColor = [UIColor whiteColor];
        [self addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.origin.x, _faceImage.origin.y + 27, 30, 10)];
        _timeLabel.font = [UIFont systemFontOfSize:11.f];
        _timeLabel.textColor = [UIColor whiteColor];
        [self addSubview:_timeLabel];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
