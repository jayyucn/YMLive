//
//  HomeUserAllInfoCell.h
//  qianchuo
//
//  Created by jacklong on 16/8/11.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "HomeUserInfoView.h"

typedef void(^ShowRankVCBlock)();

@interface HomeUserAllInfoCell : UITableViewCell

@property (nonatomic, strong) HomeUserInfoView *homeUserInfoView;

@property (nonatomic,copy) ShowRankVCBlock showRankBlock;
@end
