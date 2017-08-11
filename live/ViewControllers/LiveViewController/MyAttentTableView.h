//
//  MyAttentTableView.h
//  qianchuo
//
//  Created by jacklong on 16/4/23.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "MJBaseTableView.h"

typedef void(^LookHotBlock)();

@interface MyAttentTableView : MJBaseTableView

@property (nonatomic ,copy)LookHotBlock lookHotBlock;


@end
