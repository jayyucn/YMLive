//
//  UserGiftCell.h
//  XCLive
//
//  Created by 王威 on 15/2/4.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftCustomView.h"

typedef void (^showGiftDetailBlock)();

@interface UserGiftCell : UITableViewCell<UIGestureRecognizerDelegate>

@property (nonatomic, strong)GiftCustomView *customView;
@property (nonatomic, strong)UIScrollView *bgScroll;
@property (nonatomic, strong)showGiftDetailBlock showGiftDetailBlock;

- (void)initView:(NSArray *)array;
@end
