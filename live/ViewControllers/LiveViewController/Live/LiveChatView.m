//
//  LiveChatView.m
//  qianchuo
//
//  Created by 林伟池 on 16/10/17.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "LiveChatView.h"

@implementation LiveChatView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event {
    if (point.y > self.height / 3) {
        return NO;
    }
    return YES;
}

@end
