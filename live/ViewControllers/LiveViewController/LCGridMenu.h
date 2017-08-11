//
//  LCGridMenu.h
//  TaoHuaLive
//
//  Created by Jay on 2017/7/24.
//  Copyright © 2017年 上海七夕. All rights reserved.
//

#import "LCBaseMenu.h"

@interface LCGridMenu : LCBaseMenu

- (id)initWithTitle:(NSString *)title itemTitles:(NSArray *)itemTitles images:(NSArray *)images;

- (void)triggerSelectedAction:(void(^)(NSInteger))actionHandle;

@end
