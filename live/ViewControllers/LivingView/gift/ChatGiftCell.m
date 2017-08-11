//
//  ChatGiftCell.m
//  qianchuo
//
//  Created by jacklong on 16/7/14.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ChatGiftCell.h"

@implementation ChatGiftCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        
        for (int i = 0; i<kItemNum; ++i) {
            CGRect itemRect=CGRectMake(i*ItemWidth,0,ItemWidth,ItemHeight);
            LiveGiftItemView *giftItemView=[[LiveGiftItemView alloc] initWithFrame:itemRect];
            [self.contentView addSubview:giftItemView];
            giftItemView.tag=10+i;
            giftItemView.hidden = YES;
        }
        
    }
    return self;
}

@end
