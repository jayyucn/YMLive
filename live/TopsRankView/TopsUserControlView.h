//
//  TopsUserControlView.h
//  qianchuo 排行榜
//
//  Created by jacklong on 16/3/30.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//


#import "LCTableViewController.h"


@interface TopsUserControlView : LCTableViewController

@property (nonatomic, assign) BOOL isLiveUser;

@property (nonatomic, strong) NSString *userId;

@end
