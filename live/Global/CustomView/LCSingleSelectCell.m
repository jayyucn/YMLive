//
//  KFUpdateAmateurCell.m
//  KaiFang
//
//  Created by ztkztk on 14-3-18.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "LCSingleSelectCell.h"


@implementation LCSingleSelectCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _titleLabel= [[UILabel alloc] initWithFrame:CGRectMake(5,5,200,16)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor=[UIColor blackColor];
        _titleLabel.font=[UIFont systemFontOfSize:13];
        _titleLabel.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:_titleLabel];
        _titleLabel.centerY=SingleSelectCellHeight/2;
        
        _selectImageView=[[UIImageView alloc] initWithFrame:CGRectMake(_titleLabel.right+10, 5, 16, 16)];
        
        [self.contentView addSubview:_selectImageView];
    
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
