//
//  LiveGameListView.h
//  TaoHuaLive
//
//  Created by Jay on 2017/7/21.
//  Copyright © 2017年 上海七夕. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LCListViewStyle) {
    LCListViewStyleLight = 0,
    LCListViewStyleDark
};

typedef void(^LCMenuItemActionHandler)(NSInteger index);

@interface LiveGameListView : UIView

@property (nonatomic, assign) LCListViewStyle style;


+ (LiveGameListView *)shareView;

+ (void)showGridMenuWithTitle:(NSString *)title
                   itemTitles:(NSArray *)itemTitles
                       images:(NSArray *)images
               selectedHandle:(LCMenuItemActionHandler)handler;

@end
