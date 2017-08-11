//
//  TopsLiverControlView.h
//  qianchuo 排行榜
//
//  Created by jacklong on 16/3/30.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//


#import "LCTableViewController.h"


@interface TopsLiverControlView : LCTableViewController

@property (nonatomic, assign) BOOL isLiveUser;

@property (nonatomic, strong) NSString *userId;


- (void)presentAnimated:(BOOL)animated completion:(dispatch_block_t)completion;

@end
