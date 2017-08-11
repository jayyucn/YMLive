//
//  UserLogoCell.m
//  live
//
//  Created by hysd on 15/7/21.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import "UserLogoCell.h"
#import "Macro.h"
@implementation UserLogoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = self.frame.size.height/2;
        self.clipsToBounds = YES;
        self.layer.borderColor = RGB16(COLOR_BG_WHITE).CGColor;
        self.layer.borderWidth = 1;
        self.userLogoImageView = [[UIImageView alloc] init];
        self.userLogoImageView.frame = self.bounds;
        [self addSubview:self.userLogoImageView];
    }
    return self;
}
@end
