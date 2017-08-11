//
//  DetailCommentCell.m
//  XCLive
//
//  Created by 王威 on 15/3/23.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import "DetailCommentCell.h"


@implementation DetailCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
     self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        _userFaceImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 40, 40)];
        _userFaceImage.layer.masksToBounds = YES;
        _userFaceImage.layer.cornerRadius = 18.f;
        _userFaceImage.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_userFaceImage];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userFaceImage.right + 10, _userFaceImage.left - 3, 200, 20)];
        _nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.f];
        _nameLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_nameLabel];
        
//        _contentLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(_nameLabel.left , _nameLabel.bottom + 5, 250, 30)];
//        _contentLabel.backgroundColor = [UIColor clearColor];
//        _contentLabel.font = [UIFont systemFontOfSize:11.f];
//        _contentLabel.textColor = [UIColor grayColor];
//        [self.contentView addSubview:_contentLabel];
//        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier ];
//    if (self)
//    {
//        _userFaceImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
//        _userFaceImage.layer.masksToBounds = YES;
//        _userFaceImage.layer.cornerRadius = 18.f;
//        _userFaceImage.backgroundColor = [UIColor redColor];
//        [self.contentView addSubview:_userFaceImage];
//        
//        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userFaceImage.right + 10, _userFaceImage.left - 5, 200, 20)];
//        _nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.f];
//        _nameLabel.textColor = [UIColor whiteColor];
//        [self.contentView addSubview:_nameLabel];
//        
//        _contentLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(_nameLabel.left , _nameLabel.bottom + 5, 250, 40)];
//        _contentLabel.backgroundColor = [UIColor clearColor];
//        _contentLabel.font = [UIFont systemFontOfSize:11.f];
//        //_contentLabel.numberOfLines = 0;
//        _contentLabel.textColor = [UIColor grayColor];
//        [self.contentView addSubview:_contentLabel];
//
//    }
//    return self;
//}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
