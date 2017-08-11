//
//  MJBaseTableView.m
//  live
//
//  Created by AlexiChen on 15/10/12.
//  Copyright © 2015年 kenneth. All rights reserved.
//

#import "MJBaseTableView.h"
#import "Macro.h"
#import "MJRefresh.h" 


//#import "MultiVideoViewController.h"

//#import "LivePlaybackViewController.h"


@implementation MJBaseTableView

- (void)dealloc
{
    
}

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

- (void)endRefreshView
{
    if (_header) {
        [_header endRefreshing];
    }
    
    if (_footer) {
        [_footer endRefreshing];
    }
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

- (NSInteger)dataArrayCount
{
    if (!_datas) {
        return 0;
    }
    
    return _datas.count;
}

// 开启定时器
- (void)startRefreshTimer
{
    if (!_refreshTimer) {
        [_refreshTimer invalidate];
        _refreshTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(refreshData) userInfo:nil repeats:YES];
    }
}

// 关闭定时器
- (void)stopRefreshTimer
{
    if (_refreshTimer) {
        [_refreshTimer invalidate];
        _refreshTimer = nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_datas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: overrider by subclass
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 2*SCREEN_WIDTH/3;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    NSLog(@"速度 %@  offset %@", NSStringFromCGPoint(velocity), NSStringFromCGPoint(*targetContentOffset));
    if (self.offsetDelegate) {
        [self.offsetDelegate onScrollViewWillEndDraggingWithVelocity:velocity];
    }
}



@end
