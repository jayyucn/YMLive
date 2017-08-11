//  热门直播视图单元
//  LiveHallUserCell.m
//  qianchuo
//
//  Created by jacklong on 16/4/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "LiveHallUserCell.h"

@implementation LiveHallUserCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        for (int i = 0; i<cNum; ++i)
        {
            CGRect itemRect = CGRectMake(cIntervalPixel+i*(cCell_Items_Width+cIntervalPixel), cIntervalPixel, cCell_Items_Width, cCell_Items_Height+30);
            HotUserItemView *itemView = [[HotUserItemView alloc] initWithFrame:itemRect];
            [self.contentView addSubview:itemView];
            
            itemView.tag = 10000 + i;
            itemView.hidden = YES;
        }
    }
    
    return self;
}

@end
