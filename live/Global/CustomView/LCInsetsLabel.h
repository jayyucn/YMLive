//
//  LCInsetsLabel.h
//  XCLive
//
//  Created by ztkztk on 14-4-25.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCInsetsLabel : UILabel
@property(nonatomic) UIEdgeInsets insets;
- (id)initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets) insets;
- (id)initWithInsets:(UIEdgeInsets) insets;
@end
