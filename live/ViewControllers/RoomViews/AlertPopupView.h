//
//  AlertPopupView.h
//  live
//
//  Created by AlexiChen on 15/10/21.
//  Copyright © 2015年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>

// 默认显示在屏幕中间
@interface AlertPopupViewBaseContentView : UIView

//- (CGSize)showSize;
//
//- (void)close;

@end

@interface AlertPopupView : UIView

- (void)showContent:(AlertPopupViewBaseContentView *)content;

@end
