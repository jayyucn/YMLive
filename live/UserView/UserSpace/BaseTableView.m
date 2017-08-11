//
//  BaseTableView.m
//  qianchuo
//
//  Created by jacklong on 16/8/10.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "BaseTableView.h"

@implementation BaseTableView


- (void)dealloc
{
    
}

- (instancetype)initWithFrame:(CGRect)frame withShowHeadRefresh:(BOOL)isShowHeadRefresh withShowFooterRefresh:(BOOL)isShowFooterRefresh
{
    if (self = [super initWithFrame:frame])
    {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        _datas = [NSMutableArray array];
        
        if (isShowHeadRefresh) {
            _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
            _header.stateLabel.hidden = YES;
            _header.lastUpdatedTimeLabel.hidden = YES;
            self.mj_header = _header;
        }
     
        
        if (isShowFooterRefresh) {
            //添加上拉加载
            _footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
            _footer.stateLabel.hidden = YES;
            self.mj_footer = _footer;
        }
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

- (NSInteger)dataArrayCount
{
    if (!_datas) {
        return 0;
    }
    
    return _datas.count;
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
    return 45;
}

@end
