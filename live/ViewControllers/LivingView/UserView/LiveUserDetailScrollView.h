//
//  LiveUserDetailScrollView.h
//  qianchuo
//
//  Created by jacklong on 16/3/8.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "LiveAttentListView.h"
#import "LiveFansListView.h"
#import "LiveReceiverMoneyListView.h"
#import "MeFollowSegView.h"

typedef void(^ShowUserDetailBlock)(NSDictionary *);
@interface LiveUserDetailScrollView : UIView<UIScrollViewDelegate>

@property (nonatomic, strong) UIView            *lineView;
@property (nonatomic, strong) UIScrollView      *scrollView;
@property (nonatomic, strong) MeFollowSegView   *segView;

@property (nonatomic, strong) NSDictionary      *userInfoDict;

@property (nonatomic, strong) ShowUserDetailBlock showUserDetailBlock;

// 加载关注列表数据
- (void) loadAttentData;

// 加载粉丝列表数据
- (void) loadFansData;

// 加载收入列表数据
- (void) loadReceiverData;
@end
