//
//  MyInfoViewController.h
//  TaoHuaLive
//
//  Created by kellyke on 2017/6/28.
//  Copyright © 2017年 上海七夕. All rights reserved.
//


#import "XCHeadDetailView.h"
#import "UserStateSegView.h"


@interface MyInfoViewController_d : UIViewController <UITableViewDataSource, UITableViewDelegate, UserStateSegmentViewDelegate>

@property (nonatomic,strong) NSMutableArray *list;

@property (nonatomic,strong) UITableView *tableView;



@end
