//
//  用户个人信息界面
//  MyInfoViewController.h
//  XCLive
//
//  Created by jacklong on 16/1/13.
//  Copyright © 2016年 www.yuanphone.com. All rights reserved.
//


#import "XCHeadDetailView.h"
#import "UserStateSegView.h"


@interface MyInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *list;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) XCHeadDetailView *detailHeaderView;

@end
