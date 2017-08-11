//
//  PlayBackCell.m
//  qianchuo
//
//  Created by jacklong on 16/8/8.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "PlayBackCell.h"

@implementation PlayBackCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 20)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:16.f];
        [self addSubview:_titleLabel];
        
        _playBackTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 30, 100, 20)];
        _playBackTimeLabel.textColor = [UIColor grayColor];
        _playBackTimeLabel.font = [UIFont systemFontOfSize:11.f];
        _playBackTimeLabel.text = @"tt";
        [self addSubview:_playBackTimeLabel];
        
        _lookFlagLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 35, _playBackTimeLabel.top, 25, 12)];
        _lookFlagLabel.textColor = [UIColor grayColor];
        _lookFlagLabel.font = [UIFont systemFontOfSize:11.f];
        _lookFlagLabel.text = @"看过";
        [self addSubview:_lookFlagLabel];
        
        _visitTotalLabel = [[UILabel alloc] initWithFrame:CGRectMake(_lookFlagLabel.left - 85, _lookFlagLabel.top - 5, 80, 20)];
        _visitTotalLabel.textColor = ColorPink;
        _visitTotalLabel.font = [UIFont boldSystemFontOfSize:16.f];
        _visitTotalLabel.text = @"1.2万";
        _visitTotalLabel.textAlignment =  NSTextAlignmentRight;
        [self addSubview:_visitTotalLabel];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(10, _playBackTimeLabel.bottom+9.5f, SCREEN_WIDTH - 10, .5f)];
        _lineView.backgroundColor = [UIColor grayColor];
        [self addSubview:_lineView];
        
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Actiondo)];
        
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}


- (void) setPlayBackInfoDict:(NSDictionary *)playBackInfoDict
{
    if (!playBackInfoDict) {
        return;
    }
    _playBackInfoDict = playBackInfoDict;
    
    NSString *titleStr;
    ESStringVal(&titleStr,_playBackInfoDict[@"title"]);
    
    if (titleStr && titleStr.length > 0) {
        _titleLabel.text =  titleStr;
    } else {
        _titleLabel.text = _playBackInfoDict[@"nickname"];
    }
    
    NSString *timeStr;
    ESStringVal(&timeStr,_playBackInfoDict[@"time"]);
    
    if (timeStr && timeStr.length > 0) {
        _playBackTimeLabel.text =  timeStr;
    }

    NSString *totalStr;
    ESStringVal(&totalStr,_playBackInfoDict[@"visit_total"]);
    if (totalStr && totalStr.length > 0) {
        _visitTotalLabel.text = totalStr;
    }
}

- (void) Actiondo
{
    NSLog(@"action do");
    if (_playBackBlock) {
        _playBackBlock(_playBackInfoDict);
    }
}



@end
