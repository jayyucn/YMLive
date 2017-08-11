//
//  MyTableView.h
//  qianchuo
//
//  Created by jacklong on 16/3/8.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "MJRefreshNormalHeader.h"
#import "MJRefreshBackNormalFooter.h"

#define CELL_HEIGHT 60

@interface MyTableView: UITableView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)    MJRefreshNormalHeader       *header;           //下拉刷新
@property (nonatomic, strong)    MJRefreshBackNormalFooter   *footer;           //上拉加载
@property (nonatomic, strong)    NSMutableArray              *datas;
@property (nonatomic, strong)    NSTimer                     *refreshTimer;
@property (nonatomic, assign)    BOOL                        isLoading;
@property (nonatomic, assign)    int                         currPage;


- (void)beginRefreshing;

- (void)refreshData;

- (void)loadData;

- (void)startRefreshTimer;
- (void)stopRefreshTimer;

@end
