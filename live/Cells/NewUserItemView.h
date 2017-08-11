//
//  NewUserItemView.h
//  qianchuo
//
//  Created by jacklong on 16/4/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OnItemBlock)(NSDictionary *userInfoDict);

@interface NewUserItemView : UIView

@property (nonatomic,strong)UIImageView *portraitView;//头像

@property (nonatomic,strong)NSDictionary *userInfoDict;// 直播数据

@property (nonatomic, copy)OnItemBlock itemBlock;
@end
