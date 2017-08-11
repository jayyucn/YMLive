//
//  MyPageControl.m
//  XCLive
//
//  Created by jacklong on 15/12/4.
//  Copyright © 2015年 www.yuanphone.com. All rights reserved.
//

#import "MyPageControl.h"

@implementation MyPageControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id) initWithFrame:(CGRect)frame

{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _activeColor = [UIColor redColor];
        
        _inactiveColor = [UIColor lightGrayColor];
        
    }
    return self;
}

-(void) updateDots

{
    
    for (int i = 0; i < [self.subviews count]; i++)
        
    {
        
        UIImageView* dot = [self.subviews objectAtIndex:i];
        
        if (i == self.currentPage) {
            
            dot.backgroundColor = _activeColor;
            
        } else {
            
            dot.backgroundColor = _inactiveColor;
            
        }
        
    }
    
}

-(void) setCurrentPage:(NSInteger)page

{
    
    [super setCurrentPage:page];
    
    [self updateDots];
    
}

@end