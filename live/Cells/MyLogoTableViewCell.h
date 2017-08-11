//
//  MyLogoTableViewCell.h
//  live
//
//  Created by hysd on 15/8/28.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyLogoTableViewCell : UITableViewCell
@property (nonatomic) BOOL isModLogo;
@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *valueImageView;

@end
