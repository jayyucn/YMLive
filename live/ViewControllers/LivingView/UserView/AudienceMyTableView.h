//
//  AudienceMyTableView.h
//  qianchuo
//
//  Created by jacklong on 16/4/18.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//
#import "AudienceUserCell.h"
#import "MJRefreshBackNormalFooter.h"

@interface AudienceMyTableView : UITableView<UITableViewDataSource, UITableViewDelegate>

//@property (nonatomic, strong)    MJRefreshBackNormalFooter   *footer;           //上拉加载
@property (nonatomic, strong)    NSMutableArray              *datas;
@property (nonatomic, strong)    NSArray                     *reloadDataArray;
@property (nonatomic, strong)    NSTimer                     *refreshTimer;
@property (nonatomic, assign)    BOOL                        isLoading;
@property (nonatomic, assign)    int                         currPage;
 

- (void)loadData;
@end
