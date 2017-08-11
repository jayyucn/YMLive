//
//  LiveAttentListView.h
//  qianchuo
//
//  Created by jacklong on 16/3/8.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "UserAttentTableView.h"

@interface LiveAttentListView : UIView

@property (nonatomic, strong) UILabel       *noDataLabel;
@property (nonatomic, strong) UIImageView   *noDataImg;
@property (nonatomic, strong) UIView        *noDataView;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) UserAttentTableView  *attentTableView;

@property (nonatomic, strong) ShowUserDetailBlock showUserDetailBlock;

- (void) beginLoadData;

// 切换用户 清空之前数据
- (void) clearData;

@end

