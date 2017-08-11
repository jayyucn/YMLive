//
//  RobRedPacketUserTableView.h
//  qianchuo
//
//  Created by jacklong on 16/3/26.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "MJRefreshBackNormalFooter.h"

#define CELL_HEIGHT 50

@interface RobRedPacketUserTableView : UITableView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong)    MJRefreshBackNormalFooter   *footer;           //上拉加载
@property (nonatomic, strong)    NSMutableArray              *datas;
@property (nonatomic, strong)    NSString                    *packetId;

 
- (void)refreshData;

- (void)loadData;

- (void)clearData;
 

@end