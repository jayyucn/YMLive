//
//  ManageLogCell.m
//  TaoHuaLive
//
//  Created by garsonge on 17/2/23.
//  All rights reserved.
//


#import "ManageLogCell.h"


@implementation ManageLogCell

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
    _userId.textColor = ColorDark;
    _name.textColor = ColorDark;
    
    _content.textColor = ColorPink;
}

@end
