//
//  LCFootprintsCell.m
//  XCLive
//
//  Created by ztkztk on 14-5-14.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCFootprintsCell.h"

@implementation LCFootprintsCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        /*
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(210,10,100,20)];
        _timeLabel.textAlignment = UITextAlignmentRight;
        _timeLabel.textColor=[UIColor grayColor];
        _timeLabel.font=[UIFont systemFontOfSize:15];
        _timeLabel.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:_timeLabel];
         
         */
        
    }
    return self;
}


-(void)setInfoDic:(NSDictionary *)infoDic
{
    [super setInfoDic:infoDic];
    
    NSString *time = @"";
    ESStringVal(&time, infoDic[@"time"]);
    
    self.timeLabel.text=time;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
