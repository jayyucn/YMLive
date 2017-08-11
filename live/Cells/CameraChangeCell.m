//
//  CameraChangeCell.m
//  qianchuo
//
//  Created by jacklong on 16/5/3.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "CameraChangeCell.h"

@interface CameraChangeCell()
{
    UIImageView *iconImageView;
    UILabel     *promptLabel;
}
@end

@implementation CameraChangeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"image/liveroom/room_pop_up_lamp"];
        iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, image.size.width, image.size.height)];
        iconImageView.image = image;
        [self addSubview:iconImageView];
        
        promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconImageView.right+5, 0, 60, 30)];
        promptLabel.textAlignment = NSTextAlignmentLeft;
        promptLabel.textColor = [UIColor whiteColor];
        promptLabel.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:promptLabel];
    }
    
    return self;
}

- (void) setInfoDict:(NSDictionary *)infoDict
{
    NSLog(@"info %@",infoDict);
    promptLabel.text = infoDict[@"title"];
    iconImageView.image = [UIImage imageNamed:infoDict[@"icon"]];
}

@end
