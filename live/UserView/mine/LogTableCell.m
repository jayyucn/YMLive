//
//  兑换记录
//  LogTableCell.m
//
//  Created by garsonge on 17/2/22.
//


#import "LogTableCell.h"


@implementation LogTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // if needed
    }
    
    return self;
}


// 设置cell的属性
- (void)setupCell
{
    _time.textColor = ColorDark;
    _channel.textColor = ColorDark;
    _content.textColor = ColorDark;
    
    _status.textColor = ColorPink;
}

@end
