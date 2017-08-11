//
//  LiveGiftCell.m
//  qianchuo
//
//  Created by jacklong on 16/3/5.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "LiveGiftCell.h"

@implementation LiveGiftCell

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
            giftItemView.tag=1111+i;
            giftItemView.hidden = YES;
        }
        
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



@end
