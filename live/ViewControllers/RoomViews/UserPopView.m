//
//  UserPopView.m
//  live
//
//  Created by hysd on 15/8/24.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import "UserPopView.h"
#import "Macro.h"
@implementation UserPopView

- (id)init{
    self = [[[NSBundle mainBundle] loadNibNamed:@"UserPopView" owner:self options:nil] lastObject];
    if(self){
        self.backgroundColor = RGBA16(COLOR_BG_ALPHABLACK);
        self.clipsToBounds = YES;
        self.nameLabel.textColor = RGB16(COLOR_FONT_WHITE);
        self.addressLabel.textColor = RGB16(COLOR_FONT_LIGHTWHITE);
        self.praiseLabel.textColor = RGB16(COLOR_FONT_LIGHTWHITE);
    }
    return self;
}

- (void)showView:(UIView*)view name:(NSString*)name address:(NSString*)address praise:(NSString*)praise{
    self.nameLabel.text = name;
    self.addressLabel.text = address;
    self.praiseLabel.text = praise;
    CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.frame = CGRectMake(view.frame.origin.x, view.frame.size.height+view.frame.origin.y+2, size.width, size.height);
    UIBezierPath* path = [UIBezierPath bezierPath];
    NSInteger cornerRadius = 5;
    NSInteger sharpHeight = 10;
    NSInteger sharpRadius = 5;
    
    [path moveToPoint:CGPointMake(cornerRadius, sharpHeight)];
    [path addLineToPoint:CGPointMake(view.frame.size.width/2-sharpRadius, sharpHeight)];
    [path addLineToPoint:CGPointMake(view.frame.size.width/2, 0)];
    [path addLineToPoint:CGPointMake(view.frame.size.width/2+sharpRadius, sharpHeight)];
    [path addLineToPoint:CGPointMake(self.frame.size.width-cornerRadius, sharpHeight)];
    [path addArcWithCenter:CGPointMake(self.frame.size.width-cornerRadius, sharpHeight+cornerRadius) radius:cornerRadius startAngle:1.5*M_PI endAngle:0 clockwise:YES];
    [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height-cornerRadius)];
    [path addArcWithCenter:CGPointMake(self.frame.size.width-cornerRadius, self.frame.size.height-cornerRadius) radius:cornerRadius startAngle:0 endAngle:0.5*M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(cornerRadius, self.frame.size.height)];
    [path addArcWithCenter:CGPointMake(cornerRadius, self.frame.size.height-cornerRadius) radius:cornerRadius startAngle:0.5*M_PI endAngle:M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(0.0, sharpHeight+cornerRadius)];
    [path addArcWithCenter:CGPointMake(cornerRadius, sharpHeight+cornerRadius) radius:cornerRadius startAngle:M_PI endAngle:1.5*M_PI clockwise:YES];
    
    CAShapeLayer* shape = [CAShapeLayer layer];
    shape.path = [path CGPath];
    shape.cornerRadius = 5;
    self.layer.mask = shape;
    
    self.alpha = 0;
    [view.superview addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }completion:nil];
}
- (void)hideView{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
