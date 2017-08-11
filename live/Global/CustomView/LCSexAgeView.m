//
//  LCSexAgeView.m
//  XCLive
//
//  Created by Elf Sundae on 6/4/14.
//  Copyright (c) 2014 ztkztk. All rights reserved.
//

#import "LCSexAgeView.h"


@implementation LCSexAgeView
{
        UILabel *_label;
}

- (instancetype)init
{
        self = [super initWithFrame:CGRectMake(0.f, 0.f, 27.f, 12.f)];
        if (self) {
                _label = [[UILabel alloc] initWithFrame:self.bounds/*ESRectExpandWithEdgeInsetsFrom(self.bounds, 0, 3, 0, 3)*/];
                _label.textAlignment = NSTextAlignmentRight;
                _label.backgroundColor = [UIColor clearColor];
                _label.font = [UIFont systemFontOfSize:9.f];
                _label.textColor = [UIColor whiteColor];
                //_label.highlightedTextColor = [UIColor lightGrayColor];
                [self addSubview:_label];
                
                self.sex = LCSexMan;
        }
        return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
        return [self init];
}

- (void)setAge:(int)age
{
        _age = age;
        _label.text = (_age > 0 && _age < 280) ? NSStringWith(@"%d", _age) : nil;
        [self setNeedsDisplay];
}

- (void)setSex:(LCSex)sex
{
        _sex = sex;
        self.image = (LCSexMan == _sex ? UIImageFromCache(@"image/globle/boy") : UIImageFromCache(@"image/globle/girl"));
        [self setNeedsLayout];
}

@end
