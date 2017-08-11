//
//  LCSearchResultViewController.h
//  XCLive
//
//  Created by ztkztk on 14-6-19.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "LCTableViewController.h"

@interface LCSearchResultViewController : LCTableViewController
@property (nonatomic,strong)NSString *searchString;

+(id)searchController:(NSString *)searchString;

-(void)getsearchList:(int)page;

@end
