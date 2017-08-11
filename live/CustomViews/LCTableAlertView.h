//
//  LCTableAlertView.h
//  XCLive
//
//  Created by ztkztk on 14-5-13.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCAlertView.h"

typedef void(^LCTableAlertBlock)(NSInteger select);
@interface LCTableAlertView : LCAlertView<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)NSArray *list;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)LCTableAlertBlock tableAlertBlock;

+(void)showTableAlertView:(NSString *)title array:(NSArray *)array withBlock:(LCTableAlertBlock)alertBlock;
@end
