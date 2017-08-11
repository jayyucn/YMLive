//
//  EditUserHeaderCell.m
//  qianchuo
//
//  Created by jacklong on 16/3/31.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "EditUserHeaderCell.h"

@implementation EditUserHeaderCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 46 - ScreenWidth/16-15, 7, 46, 46)];
        // 圆形背景
        _headImgView.layer.borderWidth = 2;
        _headImgView.layer.borderColor = ColorPink.CGColor;
        _headImgView.layer.cornerRadius = _headImgView.frame.size.width/2;
        _headImgView.clipsToBounds = YES;
        [self.contentView addSubview:_headImgView];
        
        
    }
    return self;
}

-(void)showDataOfCell
{
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString faceURLString:[LCMyUser mine].faceURL]] placeholderImage:UIImageFromCache(@"default_head")];
//    [_headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString faceURLString:[LCMyUser mine].faceURL]] placeholderImage:UIImageFromCache(@"default_head") options:SDWebImageRefreshCached | SDWebImageProgressiveDownload];
}

@end
