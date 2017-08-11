//  主播人气周榜视图单元
//  HotRankCell.m
//
//  Created by garsonge on 17/7/3.
//  Copyright © 2017年 上海七夕. All rights reserved.
//

#import "HotRankCell.h"

@implementation HotRankCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        CGRect itemRect = CGRectMake(0, 0, ScreenWidth, 60);
        HotRankItemView *itemView = [[HotRankItemView alloc] initWithFrame:itemRect];
        itemView.tag = 8000000;
        [self.contentView addSubview:itemView];
    }
    
    return self;
}

@end
