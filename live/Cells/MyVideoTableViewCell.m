//
//  MyVideoTableViewCell.m
//  live
//
//  Created by AlexiChen on 15/10/28.
//  Copyright © 2015年 kenneth. All rights reserved.
//

#import "MyVideoTableViewCell.h"

#import "MyVideoCover.h"

@implementation MyVideoTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self.textLabel removeFromSuperview];
        
        _videoCover = [[[NSBundle mainBundle] loadNibNamed:@"MyVideoCover" owner:_videoCover options:nil] firstObject];
        [self.contentView addSubview:_videoCover];
        
        
        _videoTitle = [[UILabel alloc] init];
        [self.contentView addSubview:_videoTitle];
        
        _lookButton = [[UIButton alloc] init];
        _lookButton.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_lookButton];
        
        _praiseButton = [[UIButton alloc] init];
        _praiseButton.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_praiseButton];
        
        _dateButton = [[UIButton alloc] init];
        _dateButton.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_dateButton];
    }
    return self;
}

#define kHorMargin 8
#define kVerMargin 8

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.contentView.bounds;
    
    rect = CGRectInset(rect, kHorMargin, kVerMargin);
    
    CGRect coverRect = rect;
    
    coverRect.size.width = rect.size.height * 1.25;
    _videoCover.frame = coverRect;
    
    rect.origin.x += coverRect.size.width + kHorMargin;
    rect.size.width -= coverRect.size.width + kHorMargin;
    
    CGRect titleRect = rect;
    titleRect.size.height = (titleRect.size.height - kVerMargin)/2;
    _videoTitle.frame = titleRect;
    
    titleRect.origin.y += kVerMargin + titleRect.size.height;
    
    CGSize btnSize = CGSizeMake((titleRect.size.width - 2*kHorMargin)/3, titleRect.size.height);
    titleRect.size = btnSize;
    
    _lookButton.frame = titleRect;
    
    titleRect.origin.x += titleRect.size.width + kHorMargin;
    _praiseButton.frame = titleRect;
    
    titleRect.origin.x += titleRect.size.width + kHorMargin;
    _dateButton.frame = titleRect;
}

@end
