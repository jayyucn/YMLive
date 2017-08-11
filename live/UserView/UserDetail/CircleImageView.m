//
//  CircleImageView.m
//  XCLive
//
//  Created by ztkztk on 14-5-12.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "CircleImageView.h"

@implementation CircleImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        if (!_isNoShowBorder) {
            self.layer.borderWidth = 2;
            self.layer.borderColor = [UIColor whiteColor].CGColor;

        } else {
            self.layer.borderWidth = 0;
            self.layer.borderColor = [UIColor clearColor].CGColor;
        }
        self.layer.cornerRadius = CGRectGetHeight(self.bounds) / 2;
        self.clipsToBounds = YES;

        
        /*
        self.backgroundColor=[UIColor redColor];
        self.layer.cornerRadius = frame.size.width/2;
        self.layer.masksToBounds = YES;
        [self.layer setBorderWidth:2];
        [self.layer setBorderColor:(__bridge CGColorRef)([UIColor whiteColor])];
        self.contentMode = UIViewContentModeScaleToFill;
         */
    
    }
    return self;
}

-(void)setIsNoShowBorder:(BOOL)isNoShowBorder
{
    _isNoShowBorder = isNoShowBorder;
    if (!_isNoShowBorder) {
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        
    } else {
        self.layer.borderWidth = 0;
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }
    self.layer.cornerRadius = CGRectGetHeight(self.bounds) / 2;
    self.clipsToBounds = YES;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    
}


@end
