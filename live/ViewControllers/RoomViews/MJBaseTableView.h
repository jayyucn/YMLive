//
//  MJBaseTableView.h
//  live
//
//  Created by AlexiChen on 15/10/12.
//  Copyright © 2015年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefreshNormalHeader.h"
#import "MJRefreshBackNormalFooter.h"
#import "WatchCutLiveViewController.h"
#import "NewUserHallCell.h"
#import "LiveHallUserCell.h"
#import "ShowWebViewController.h"

#define BANNER_SCROLLER_TAG  1001
#define ALL_SCROLLER_TAG 1002
#define HOT_TABLEVIEW_TAG 1003

@protocol ScrollviewOffsetDelegate
@required
- (void)onScrollViewWillEndDraggingWithVelocity:(CGPoint)point;
@end

@interface MJBaseTableView : UITableView<UITableViewDataSource, UITableViewDelegate>
{
    MJRefreshNormalHeader       *_header;           //下拉刷新
    MJRefreshBackNormalFooter   *_footer;           //上拉加载
    NSMutableArray              *_datas;
    NSTimer                     *_refreshTimer;
    BOOL                        _isLoading;
}

@property (nonatomic, strong)UIViewController   *watchViewController;
@property (nonatomic , weak) id<ScrollviewOffsetDelegate> offsetDelegate;
@property (nonatomic, strong)UIScrollView  *outerScrollView;

- (void)beginRefreshing;

- (void)refreshData;

- (void)loadData;

- (NSInteger)dataArrayCount;

- (void)startRefreshTimer;
- (void)stopRefreshTimer;

- (void)endRefreshView;
@end

