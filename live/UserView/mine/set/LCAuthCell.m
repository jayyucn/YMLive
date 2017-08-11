//
//  LCAuthCell.m
//  XCLive
//
//  Created by ztkztk on 14-4-26.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCAuthCell.h"

@implementation LCAuthCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _authImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [self addSubview:_authImageView];
        [self addSubview:_authImageView];
        _authImageView.left = ScreenWidth *8/10-30;
        _authImageView.centerY = 25;
        
        _authLabel = [[UILabel alloc] initWithFrame:CGRectMake(_authImageView.right + 3,0,70,20)];
        _authLabel.textAlignment = NSTextAlignmentLeft;
        _authLabel.textColor=[UIColor grayColor];
        _authLabel.font=[UIFont systemFontOfSize:15];
        _authLabel.backgroundColor =[UIColor clearColor];
        [self addSubview:_authLabel];
        _authLabel.centerY=_authImageView.centerY;
    }
    return self;
}

-(void)setAuth:(BOOL)auth
{
    _auth=auth;
    if(_auth)
    {
        _authImageView.image=[UIImage imageNamed:@"image/mine/ProfileLockOn"];
        _authLabel.text=@"已保护";
        
    }else{
        
        _authImageView.image=[UIImage imageNamed:@"image/mine/ProfileLockOff"];
        _authLabel.text=@"未保护";
        
    }
    [self setNeedsLayout];
}


@end
