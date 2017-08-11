//
//  OnlineUserScrollView.m
//  qianchuo
//
//  Created by jacklong on 16/3/4.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "OnlineUserScrollView.h"

@implementation OnlineUserScrollView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.directionalLockEnabled = YES; //只能一个方向滑动
        self.pagingEnabled = YES; //是否翻页
        self.backgroundColor=[UIColor clearColor];
        self.showsVerticalScrollIndicator =NO; //垂直方向的滚动指示
        self.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
        self.showsHorizontalScrollIndicator = YES;//水平方向的滚动指示
        self.delegate = self;
        // CGSize newSize = CGSizeMake(306*6, 191);
        // [_scrollView setContentSize:newSize];
        self.scrollEnabled = YES;
    }
    return self;
}
@end
