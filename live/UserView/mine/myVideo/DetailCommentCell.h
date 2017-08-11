//
//  DetailCommentCell.h
//  XCLive
//
//  Created by 王威 on 15/3/23.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "TTStyledTextLabel.h"
@interface DetailCommentCell : UITableViewCell

@property (nonatomic, strong)UIImageView *userFaceImage;
@property (nonatomic, strong)UILabel *nameLabel;
//@property (nonatomic, strong)TTStyledTextLabel *contentLabel;
@property (nonatomic, strong)UILabel *timeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier;
@end
