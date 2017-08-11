//
//  CLIconView.m
//  XCLive
//
//  Created by ztkztk on 14-4-29.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "CLIconView.h"

@implementation CLIconView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame=CGRectMake(0,0,320,115);
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 58, 58)];
        [self addSubview:_iconImageView];
        
        _iconImageView.layer.cornerRadius = 6;
        _iconImageView.layer.masksToBounds = YES;
        
        _iconImageView.centerX = ScreenWidth / 2;
        _iconImageView.top = 15;
        _iconImageView.image = [UIImage imageNamed:@"AppIcon60x60@2x"];
        
        _versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,200,30)];
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        _versionLabel.textColor=[UIColor blackColor];
        _versionLabel.font=[UIFont systemFontOfSize:20];
        _versionLabel.backgroundColor =[UIColor clearColor];
        [self addSubview:_versionLabel];
        _versionLabel.centerX = ScreenWidth / 2;
        _versionLabel.top = _iconImageView.bottom+10;
        //_versionLabel.text = @"有美直播1.0";
        _versionLabel.text = [NSString stringWithFormat:@"有美直播:%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
        /*
        _companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,400,130)];
        _companyLabel.textAlignment = NSTextAlignmentCenter;
        _companyLabel.textColor=[UIColor blackColor];
        _companyLabel.font=[UIFont systemFontOfSize:16];
        _companyLabel.backgroundColor =[UIColor clearColor];
        [self addSubview:_companyLabel];
        _companyLabel.centerX = ScreenWidth / 2;
        _companyLabel.top = _versionLabel.bottom+200;
        _companyLabel.text = @"上海钦亲网络科技有限公司";
         */

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
