//
//  LCMineHeaderCell.m
//  XCLive
//
//  Created by ztkztk on 14-4-21.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCMineHeaderCell.h"

@implementation LCMineHeaderCell

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //self.backgroundColor=[UIColor clearColor];
        
        _photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 9, 80, 80)];
        [self.contentView addSubview:_photoImageView];
        
        _photoImageView.layer.cornerRadius = 4;
        _photoImageView.layer.masksToBounds = YES;
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_photoImageView.right+7,16,150,24)];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor=[UIColor blackColor];
        _nameLabel.font=[UIFont systemFontOfSize:18];
        _nameLabel.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:_nameLabel];
        
        _IDLabel = [[UILabel alloc] initWithFrame:CGRectMake(_photoImageView.right+7,45,150,24)];
        _IDLabel.textAlignment = NSTextAlignmentLeft;
        _IDLabel.textColor=[UIColor grayColor];
        _IDLabel.font=[UIFont systemFontOfSize:18];
        _IDLabel.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:_IDLabel];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(showDataOfCell)
                                                     name:NotificationMsg_EditInfo_Success
                                                   object:nil];

            self.vipCapImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 32, 30)];
            [self.contentView addSubview:self.vipCapImageView];
       
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
//                                        
//                                        
//                                    }
//                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
//                                        
//                                    }];
    _nameLabel.width = _nameLabel.width + ScreenWidth - 320;
    _nameLabel.text = [LCMyUser mine].nickname;
    _IDLabel.text=[NSString stringWithFormat:@"ID:%@",[LCMyUser mine].userID];
        
//        int vipLevel = [LCMyUser mine].VIPLevel;
//        if (vipLevel > 0) {
//                self.vipCapImageView.hidden = NO;
//                self.vipCapImageView.image = UIImageFromCache(@"image/vip/vip%d", vipLevel);
//        } else {
//                self.vipCapImageView.image = nil;
//                self.vipCapImageView.hidden = YES;
//        }

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
