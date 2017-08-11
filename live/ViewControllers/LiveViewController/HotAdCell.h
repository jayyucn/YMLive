//
//  HotAdCell.h
//  qianchuo
//
//  Created by jacklong on 16/7/11.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "RollingView.h"

@interface HotAdCell : UITableViewCell<RollingViewDelegate>

/** 顶部AD数组 */
@property (nonatomic, strong) NSMutableArray *topADs;
/** 点击图片的block */
@property (nonatomic, copy) void (^imageClickBlock)(NSInteger index);

@end
