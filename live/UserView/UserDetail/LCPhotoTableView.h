//
//  LCPhotoTableView.h
//  XCLive
//
//  Created by ztkztk on 14-5-12.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCPhotoCell.h"

@interface LCPhotoTableView : UITableView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *photos;
@end
