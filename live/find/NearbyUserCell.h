//
//  NearbyUserCell.h
//  TaoHuaLive
//
//  Created by garsonge on 17/3/27.
//  Copyright © 2017年 上海七夕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NearbyUserModel.h"

@interface NearbyUserCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView  *iconImage;
@property (strong, nonatomic) IBOutlet UILabel      *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel      *loginLabel;
@property (strong, nonatomic) IBOutlet UILabel      *disLabel;

// 设置cell的属性
- (void)setupCell;

@end
