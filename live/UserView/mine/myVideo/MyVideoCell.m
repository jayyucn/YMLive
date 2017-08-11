//
//  MyVideoCell.m
//  XCLive
//
//  Created by 王威 on 15/3/27.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import "MyVideoCell.h"

@implementation MyVideoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withVideoUrl:(NSString *)url
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.playerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 270)];
        self.playerScrollView.backgroundColor = [UIColor clearColor];
        self.playerScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        self.playerScrollView.bounces = NO;
        self.playerScrollView.contentSize = CGSizeMake(ScreenWidth, 270);
        
        [self.contentView addSubview:self.playerScrollView];
        
        _replyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _replyBtn.frame = CGRectMake(0, 280, ScreenWidth / 2, 30);
      
        _replyBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.f];
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth / 2 + 1, 285, .6f, 15)];
        lineLabel.backgroundColor = UIColorWithRGB(131, 129, 138);
        [self.contentView addSubview:lineLabel];
        
        [_replyBtn setTitleColor:UIColorWithRGB(131, 129, 138)  forState:UIControlStateNormal];
        [self.contentView addSubview:_replyBtn];
        
        _timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _timeBtn.frame = CGRectMake(ScreenWidth / 2, 280, ScreenWidth / 2, 30);
        [_timeBtn setTitleColor:UIColorWithRGB(131, 129, 138)  forState:UIControlStateNormal];
        _timeBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.f];
        [self.contentView addSubview:_timeBtn];
    }
    return self;
}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
