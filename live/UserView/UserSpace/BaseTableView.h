//
//  BaseTableView.h
//  qianchuo
//
//  Created by jacklong on 16/8/10.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "MJRefresh.h"

@interface BaseTableView : UITableView<UITableViewDataSource, UITableViewDelegate>
{
    MJRefreshNormalHeader       *_header;           //下拉刷新
    MJRefreshBackNormalFooter   *_footer;           //上拉加载
    NSTimer                     *_refreshTimer;
    BOOL                        _isLoading;
}

@property (nonatomic, strong) NSMutableArray              *datas;

- (instancetype)initWithFrame:(CGRect)frame withShowHeadRefresh:(BOOL)isShowHeadRefresh withShowFooterRefresh:(BOOL)isShowFooterRefresh;

- (void)beginRefreshing;

- (void)refreshData;

- (void)loadData;

- (NSInteger)dataArrayCount;

@end

