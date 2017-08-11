//
//  LCBaseMenu.m
//  TaoHuaLive
//
//  Created by Jay on 2017/7/24.
//  Copyright © 2017年 上海七夕. All rights reserved.
//

#import "LCBaseMenu.h"
#import <QuartzCore/QuartzCore.h>
#import <sys/sysctl.h>

@implementation LCButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //initialization
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        self.backgroundColor = [UIColor lightGrayColor];
    }else{
        double delayInSeconds = 0.2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.backgroundColor = [UIColor clearColor];
        });
    }
}

@end

@implementation LCBaseMenu
@synthesize style = _style;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _style = LCListViewStyleLight;
        self.roundedCorner = [self nicePerformance];
    }
    return self;
}

- (void)setRoundedCorner:(BOOL)roundedCorner
{
    if (roundedCorner) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight
                                                         cornerRadii:CGSizeMake(8, 8)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = self.bounds;
        maskLayer.path = path.CGPath;
        self.layer.mask = maskLayer;
    }else{
        self.layer.mask = nil;
    }
    _roundedCorner = roundedCorner;
    [self setNeedsDisplay];
}

- (BOOL)nicePerformance{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *name = malloc(size);
    sysctlbyname("hw.machine", name, &size, NULL, 0);
    
    NSString *machine = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    
    free(name);
    
    BOOL b = YES;
    if ([machine hasPrefix:@"iPhone"]) {
        b = [[machine substringWithRange:NSMakeRange(6, 1)] intValue] >= 4;
    }else if ([machine hasPrefix:@"iPod"]){
        b = [[machine substringWithRange:NSMakeRange(4, 1)] intValue] >= 5;
    }else if ([machine hasPrefix:@"iPad"]){
        b = [[machine substringWithRange:NSMakeRange(4, 1)] intValue] >= 2;
    }
    
    return b;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
