//
//  MyVideoTableViewCell.h
//  live
//
//  Created by AlexiChen on 15/10/28.
//  Copyright © 2015年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyVideoCover;

@interface MyVideoTableViewCell : UITableViewCell

@property (strong, nonatomic)  MyVideoCover *videoCover;

@property (strong, nonatomic)  UILabel *videoTitle;
@property (strong, nonatomic)  UIButton *lookButton;
@property (strong, nonatomic)  UIButton *praiseButton;
@property (strong, nonatomic)  UIButton *dateButton;

@end
