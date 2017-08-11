//
//  AudienceUserCell.h
//  qianchuo
//
//  Created by jacklong on 16/3/4.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ViewWidth  40
#define ViewPadding 8

typedef void(^ShowUserDetail)(LiveUser *);

@interface AudienceUserCell : UITableViewCell

@property (nonatomic,strong)LiveUser *liveUser;// 用户数据

@property (nonatomic,strong)UIImageView *portraitView;// 头像
@property (nonatomic,strong)UIImageView *gradeFlagImgView;// 级别标记

@property (nonatomic,copy)ShowUserDetail showUserDetail;

@end
