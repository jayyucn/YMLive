//
//  UserAttentTableView.h
//  qianchuo
//
//  Created by jacklong on 16/3/21.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "MyTableView.h"

typedef void(^ShowUserDetailBlock)(NSDictionary *);

@interface UserAttentTableView : MyTableView

@property (nonatomic, strong) UIView       *noDataView;
@property (nonatomic, strong) UILabel      *noDataLabel;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, copy) ShowUserDetailBlock showUserDetailBlock;

@property (nonatomic, strong)NSDictionary *userInfoDict;

@end
