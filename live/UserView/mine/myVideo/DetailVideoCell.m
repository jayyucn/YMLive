//
//  DetailVideoCell.m
//  XCLive
//
//  Created by 王威 on 15/3/23.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import "DetailVideoCell.h"

@implementation DetailVideoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.playerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, 250)];
        self.playerScrollView.backgroundColor = [UIColor clearColor];
        self.playerScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        self.playerScrollView.bounces = NO;
        self.playerScrollView.contentSize = CGSizeMake(self.width, 250);


        [self.contentView addSubview:self.playerScrollView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(13.f, self.playerScrollView.bottom + 15, 25, 10)];
        label.text = @"评论";
        label.font = [UIFont systemFontOfSize:11.f];
        label.textColor = [UIColor grayColor];
        [self.contentView addSubview:label];
        
        _commentCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.right + 5, label.top, 15, 10)];
        _commentCountLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.f];
        _commentCountLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_commentCountLabel];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
