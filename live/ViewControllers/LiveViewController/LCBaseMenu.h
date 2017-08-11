//
//  LCBaseMenu.h
//  TaoHuaLive
//
//  Created by Jay on 2017/7/24.
//  Copyright © 2017年 上海七夕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveGameListView.h"

#define BaseMenuBackgroundColor(style)  (style == LCListViewStyleLight ? [UIColor colorWithWhite:1.0 alpha:1.0] : [UIColor colorWithWhite:0.2 alpha:1.0])
#define BaseMenuTextColor(style)        (style == LCListViewStyleLight ? [UIColor darkTextColor] : [UIColor lightTextColor])
#define BaseMenuActionTextColor(style)  ([UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0])

@interface LCButton : UIButton
@end

@interface LCBaseMenu : UIView
{
    LCListViewStyle _style;
}


@property (nonatomic, assign) BOOL roundedCorner;

@property (nonatomic, assign) LCListViewStyle style;

@end
