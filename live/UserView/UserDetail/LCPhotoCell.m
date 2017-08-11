//
//  LCPhotoCell.m
//  XCLive
//
//  Created by ztkztk on 14-5-12.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCPhotoCell.h"

@implementation LCPhotoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        for(int i = 0;i < PhotoNumEachRow;i++)
        {
            LCPhoto *photoView = [[LCPhoto alloc] initWithFrame:CGRectMake(6+(PhotoWidth + distanceBeteen) * i,distanceBeteen,PhotoWidth,PhotoWidth)];
            photoView.tag=1000+i;
            [self.contentView addSubview:photoView];
        }

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
