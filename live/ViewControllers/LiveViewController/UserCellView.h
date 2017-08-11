//
//  UserCellView.h
//  TaoHuaLive
//
//  Created by Jay on 2017/7/3.
//  Copyright © 2017年 上海七夕. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OnItemBlock)(NSDictionary *userInfoDict);

@interface UserCellView : UIView

-(void)configViewWithDict:(NSDictionary *)dict;

@property(nonatomic, copy) OnItemBlock itemBlock;

@end
