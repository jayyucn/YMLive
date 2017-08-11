//
//  LCAboutViewController.h
//  XCLive
//
//  Created by ztkztk on 14-4-26.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCTableViewController.h"
#import "CLIconView.h"

#define AppURL @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=708986164"

@interface LCAboutViewController : LCTableViewController
@property (nonatomic,strong)CLIconView *iconView;
@property (nonatomic,strong)UILabel *versionLabel;
@property (nonatomic,strong)UIImageView *versionMark;


@end
