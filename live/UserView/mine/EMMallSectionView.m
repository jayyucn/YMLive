

//
//  EMMallSectionView.m
//  chexun
//
//  Created by macrong on 15/5/27.
//  Copyright (c) 2015年 macrong. All rights reserved.
//

#import "EMMallSectionView.h"


@interface EMMallSectionView()

@end

@implementation EMMallSectionView

+ (EMMallSectionView *)showWithName:(NSString *)sectionName
{
    EMMallSectionView  *sectionView = [[EMMallSectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    sectionView.backgroundColor = ColorBackGround;
   
    return sectionView;
}

+ (CGFloat)getSectionHeight
{
    return 10;
}

- (void)setFrame:(CGRect)frame
{
    if (self.section == 0) {
        [super setFrame:frame];
        return;
    }
    CGRect sectionRect = [self.tableView rectForSection:self.section];
    CGRect newFrame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(sectionRect), CGRectGetWidth(frame), CGRectGetHeight(frame));
    [super setFrame:newFrame];
}

@end
