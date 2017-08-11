//
//  LCUserHeaderCell.m
//  XCLive
//
//  Created by ztkztk on 14-4-23.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCUserHeaderCell.h"

@implementation LCUserHeaderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 80 - ScreenWidth/16-15, 9, 80, 80)];
        [self.contentView addSubview:_photoImageView];
        
        _photoImageView.layer.cornerRadius = 4;
        _photoImageView.layer.masksToBounds = YES;

    }
    return self;
}

-(void)showDataOfCell
{
                [_photoImageView sd_setImageWithURL:[NSURL URLWithString:[LCMyUser mine].faceURL] placeholderImage:UIImageFromCache(@"image/globle/placeholder")];
//    ESWeak(_photoImageView, weakPortraitView);
//    [_photoImageView setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[LCMyUser mine].faceURL]]
//                           placeholderImage:[UIImage imageNamed:@"image/globle/placeholder"]
//                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
//                                        ESStrong(weakPortraitView, strongPortraitView);
//                                        if (strongPortraitView)
//                                            strongPortraitView.image = image;
//                                     }
//                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
//                                        
//                                    }];
    
    
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
