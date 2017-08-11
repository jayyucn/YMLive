//
//  HomeBottomView.h
//  qianchuo
//
//  Created by jacklong on 16/8/4.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeBottomView : UIView

- (id)initWithFrame:(CGRect)frame withUserId:(NSString *)userId;

- (void)updateOneToOneState:(int)isOpenOneToOne;

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) UIButton *privBtn;

@property (nonatomic, strong) UIButton *oneToOneBtn;
@end
