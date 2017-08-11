//
//  LCCancelAndOKView.h
//  XCLive
//
//  Created by ztkztk on 14-4-17.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCAlertView.h"

@interface LCCancelAndOKView : LCAlertView

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)id editView;
@property (nonatomic)float offsetY;

@property (nonatomic,strong)ESButton *OKBtn;
@property (nonatomic,strong)ESButton *cancelBtn;
@property (nonatomic,strong)UIImageView *addCoseBtn;
-(void)setTitle:(NSString *)title;
- (void)layoutSubviews;
-(void)okAction;
-(void)submitAction;
@end
