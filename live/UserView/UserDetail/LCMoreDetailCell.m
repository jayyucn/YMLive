//
//  LCMoreDetailCell.m
//  XCLive
//
//  Created by ztkztk on 14-5-12.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCMoreDetailCell.h"

@implementation LCMoreDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UILabel * moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,5,80,20)];
        moreLabel.textAlignment = NSTextAlignmentCenter;
        moreLabel.textColor=[UIColor blackColor];
        moreLabel.font=[UIFont systemFontOfSize:13];
        moreLabel.backgroundColor =[UIColor clearColor];
        moreLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:moreLabel];
        moreLabel.text=@"更多资料";
        moreLabel.centerX = ScreenWidth / 2;
        
        UIImageView *moreImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image/globle/base-info-more"]];
        [self addSubview:moreImage];
        moreImage.top=moreLabel.bottom + 2;
        moreImage.centerX = ScreenWidth / 2;
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
