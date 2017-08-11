//
//  NewUserHallCell.m
//  qianchuo
//
//  Created by jacklong on 16/4/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "NewUserHallCell.h"

@implementation NewUserHallCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        
        for (int i = 0; i<kNum; ++i) {
            CGRect itemRect = CGRectMake(IntervalPixel+i*(kCell_Items_Width+IntervalPixel),IntervalPixel,kCell_Items_Width,kCell_Items_Height);
            NewUserItemView *itemView = [[NewUserItemView alloc] initWithFrame:itemRect];
            [self.contentView addSubview:itemView];
            itemView.tag=1000+i;
            itemView.hidden = YES;
        }
        
    }
    return self;
}

- (void)clear {
    for (int i = 0; i < kNum; ++i) {
        NewUserItemView *authorItemView=(NewUserItemView *)[self viewWithTag:1000+i];
        [authorItemView.portraitView setImage:nil];
    }
}

@end
