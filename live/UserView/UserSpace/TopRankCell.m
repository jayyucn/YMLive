//
//  TopRankCell.m
//  qianchuo
//
//  Created by jacklong on 16/8/5.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "TopRankCell.h"

@interface TopRankCell()
{
    UILabel *topLabel;
    UIImageView *headImgView;
}

@end


@implementation TopRankCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      
        
        topLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 120, self.frame.size.height)];
        topLabel.textColor = [UIColor lightGrayColor];
        topLabel.font = [UIFont systemFontOfSize:15.f];
        topLabel.text = ESLocalizedString(@"有美币贡献榜");
        [self addSubview:topLabel];
        
        headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 5, 35, 35)];
        //圆形头像
        headImgView.layer.borderWidth = 1;
        headImgView.layer.borderColor = ColorPink.CGColor;
        headImgView.layer.cornerRadius = headImgView.frame.size.width/2;
        headImgView.clipsToBounds = YES;
        headImgView.image = [UIImage imageNamed:@"default_head"];
        headImgView.userInteractionEnabled = YES;
        [self addSubview:headImgView];
        
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, .5)];
//        lineView.backgroundColor = [UIColor lightGrayColor];
//        [self addSubview:lineView];
    }
    return self;
}

- (void)setTopsDict:(NSDictionary *)topsDict
{
    if (!topsDict) {
        return;
    }
    
    if (topsDict && topsDict[@"face"])
    {
        NSString *faceString = [NSString faceURLString:topsDict[@"face"]];
        [headImgView sd_setImageWithURL:[NSURL URLWithString:faceString]
                         placeholderImage:[UIImage imageNamed:@"default_head"]];
    }
}
@end
