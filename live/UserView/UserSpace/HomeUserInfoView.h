//
//  HomeUserInfoView.h
//  qianchuo
//
//  Created by jacklong on 16/8/10.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "BaseTableView.h"

typedef void(^ShowRankVCBlock)();

@interface HomeUserInfoView :BaseTableView


@property (nonatomic,strong) NSDictionary *topsDict;

@property (nonatomic,copy) ShowRankVCBlock showRankBlock;

@end
