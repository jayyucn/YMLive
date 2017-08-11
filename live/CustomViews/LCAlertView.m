//
//  KFAlertView.m
//  KaiFang
//
//  Created by Elf Sundae on 13-12-24.
//  Copyright (c) 2013年 www.0x123.com. All rights reserved.
//

#import "LCAlertView.h"


@implementation LCAlertView

- (id)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self) {
                
                _autoDismissTimeInterval = 3.0;
                _shouldDismissWhenTouchsAnywhere = YES;
                _cornerRadius = 7.f;
                _shadowRadius = _cornerRadius + 5.f;
                self.backgroundColor = [UIColor whiteColor];
                
                _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, LCAlertViewWidth, 120.0)];
                _backgroundView.backgroundColor = [UIColor clearColor];
                _backgroundView.clipsToBounds = YES;
                [self addSubview:_backgroundView];
        }
        return self;
}

- (id)init
{
        return [self initWithFrame:CGRectZero];
}

- (BOOL)shouldAutoDismiss
{
        return (self.autoDismissTimeInterval > 0.0);
}

- (CGSize)screenSize
{
        return [LCAlertWindow sharedWindow].frame.size;
}

- (void)layoutSubviews
{
        const CGFloat padding = 5.0;
        CGRect backgroundFrame = self.backgroundView.frame;
        CGRect frame = backgroundFrame;
        frame.size.width = 2 * padding + backgroundFrame.size.width;
        frame.size.height = 2 * padding + backgroundFrame.size.height;
        frame.origin.x = floorf((self.screenSize.width - frame.size.width) / 2.0);
        frame.origin.y = floorf((self.screenSize.height - frame.size.height) / 2.0) - 30.0;
        self.frame = frame;
        backgroundFrame.origin.x = backgroundFrame.origin.y = padding;
        self.backgroundView.frame = backgroundFrame;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
- (void)showWithAnimated
{
        [self showWithAnimation:(LCAlertViewAnimationOptionSmallToBig | LCAlertViewAnimationOptionCurveEaseInOut | LCAlertViewAnimationOptionShowGradient)
                       duration:0.2];
}
- (void)showWithAnimation:(LCAlertViewAnimationOption)animationOption duration:(NSTimeInterval)animationDuration
{
        [self layoutSubviews];
    
    
        if (ESMaskIsSet(animationOption, LCAlertViewAnimationOptionShowGradient)) {
                CAGradientLayer *gradient = [CAGradientLayer layer];
                gradient.frame = self.bounds;
                gradient.colors = [NSArray arrayWithObjects:
                                   (id)[[UIColor colorWithWhite:0.973 alpha:1.0] CGColor],
                                   (id)[[UIColor colorWithWhite:0.944 alpha:1.0] CGColor],
                                   (id)[[UIColor colorWithWhite:0.973 alpha:1.0] CGColor],
                                   nil];
                gradient.cornerRadius = self.cornerRadius;
                [self.layer insertSublayer:gradient atIndex:0];
        }
        
        if (self.cornerRadius > 0.0) {
                self.layer.cornerRadius = self.cornerRadius;
                self.layer.borderColor = [[UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f] CGColor];
                self.layer.borderWidth = 1;
        }
        
        if (self.shadowRadius > 0.0) {
                self.layer.shadowRadius = self.shadowRadius;
                self.layer.shadowOpacity = 0.1f;
                self.layer.shadowOffset = CGSizeMake(0 - (self.cornerRadius+5)/2, 0 - (self.cornerRadius+5)/2);
                self.layer.shadowColor = [UIColor blackColor].CGColor;
                self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.layer.cornerRadius].CGPath;
        }
        
        if (ESMaskIsSet(animationOption, LCAlertViewAnimationOptionSmallToBig)) {
                self.layer.transform = CATransform3DMakeScale(0.3, 0.3, 1.0);
        } else if (ESMaskIsSet(animationOption, LCAlertViewAnimationOptionBigToSmall)) {
                self.layer.transform = CATransform3DMakeScale(1.4, 1.4, 1.0);
        }
        
        if (ESMaskIsSet(animationOption, LCAlertViewAnimationOptionCurveEaseInOut)) {
                self.layer.opacity = 0.5;
        }
        
     
        self.isShowing = YES;
        [UIView animateWithDuration:animationDuration delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                                 self.layer.opacity = 1.f;
                                 self.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
                                 [[LCAlertWindow sharedWindow] showView:self];
                         } completion:^(BOOL finished) {
                                 _firstShowTime = [[NSDate date] timeIntervalSince1970];
                                 if (self.shouldAutoDismiss) {
                                         [self performSelector:@selector(dismissWithAnimated) withObject:nil afterDelay:self.autoDismissTimeInterval];
                                 }
                         }];
    
}



- (void)dismissWithAnimated
{
    
   
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissWithAnimated) object:nil];
        
        self.isShowing = NO;
        [UIView animateWithDuration:0.2 delay:0.0 options:0 animations:^{
                self.layer.opacity = 0.f;
        } completion:^(BOOL finished) {
                [[LCAlertWindow sharedWindow] dismissView:self];
        }];
}

- (void)dismiss
{
    
     //NSLog(@"00000====%@",NSStringFromCGRect(self.frame));
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissWithAnimated) object:nil];
        
        self.isShowing = NO;
        [[LCAlertWindow sharedWindow] dismissView:self];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
        BOOL shouldDismiss = NO;
        if (self.shouldDismissWhenTouchsAnywhere) {
                /* 不管点击哪里都会dismiss */
                shouldDismiss = YES;
        } else {
                /* 只有点击到backgroundView区域才会dismiss */
                UITouch *touch = [touches anyObject];
                CGPoint touchPoint = [touch locationInView:self.backgroundView];
                if (CGRectContainsPoint(self.backgroundView.bounds, touchPoint)) {
                        shouldDismiss = YES;
                }
        }
        
        if (shouldDismiss) {
                if (self.minShownTime > 0.0) {
                        if (([[NSDate date] timeIntervalSince1970] - _firstShowTime) < self.minShownTime) {
                                shouldDismiss = NO;
                        }
                }
        }
        
        if (shouldDismiss) {
                [self dismiss];
                return;
        }
        
        [super touchesEnded:touches withEvent:event];
}

@end
