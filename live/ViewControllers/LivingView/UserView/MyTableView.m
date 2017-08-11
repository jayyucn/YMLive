
//
//  MyTableView.m
//  qianchuo
//
//  Created by jacklong on 16/3/8.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "MyTableView.h"


@implementation MyTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        _datas = [NSMutableArray array];
        
        _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        _header.stateLabel.hidden = YES;
        _header.lastUpdatedTimeLabel.hidden = YES;
        self.mj_header = _header;
        
        //添加上拉加载
        _footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        _footer.stateLabel.hidden = YES;
        self.mj_footer = _footer;
    }
    return self;
}

- (void)beginRefreshing
{
    [_header beginRefreshing];
}

- (void)refreshData
{
    
}

- (void)loadData
{
    
}

- (void)startRefreshTimer
{
    
    [_refreshTimer invalidate];
    _refreshTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(refreshData) userInfo:nil repeats:YES];
}

- (void)stopRefreshTimer
{
    [_refreshTimer invalidate];
    _refreshTimer = nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_datas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

@end
