//
//  LCPhotoLibraryCell.m
//  XCLive
//
//  Created by ztkztk on 14-4-22.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCPhotoLibraryCell.h"


@implementation LCPhotoLibraryCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        for(int i=0;i<PhotoNumEachRow;i++)
        {
            LCMyPhotoView *imageView=[[LCMyPhotoView alloc] initWithFrame:CGRectMake(2+(PhotoLibraryWidth+2)*i,2,PhotoLibraryWidth,PhotoLibraryWidth)];
            imageView.tag=PhotoImageTag+i;
            
            [self.contentView addSubview:imageView];
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
