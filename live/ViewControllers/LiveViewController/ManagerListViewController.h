//
//  ManagerListViewController.h
//  qianchuo 管理员列表
//
//  Created by jacklong on 16/4/20.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "LCViewController.h"
#import "ManagerUserCell.h"

// 删除管理员
typedef void(^RemoveManagerUserBlock)(NSDictionary *removeManagerInfoDict);

@interface ManagerListViewController : LCTableViewController<SWTableViewCellDelegate>

@property (nonatomic, copy)RemoveManagerUserBlock  removeManagerInfoDict;

@end
