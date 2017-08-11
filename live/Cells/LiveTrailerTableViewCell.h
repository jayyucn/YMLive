//
//  LiveTrailerTableViewCell.h
//  live
//
//  Created by hysd on 15/7/13.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveTrailerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *leftTimeView;
@property (weak, nonatomic) IBOutlet UIImageView *trailerImageView;
@property (weak, nonatomic) IBOutlet UILabel *trailerTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *trailerUserLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (nonatomic, strong) NSDictionary *trailerItem;

@end
