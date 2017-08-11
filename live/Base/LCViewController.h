//
//  KFViewController.h
//  KaiFang
//
//  Created by Elf Sundae on 8/2/13.
//  Copyright (c) 2013 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCViewController : UIViewController
//@property (nonatomic, strong) UIBarButtonItem *navToggleLeftBarItem;
//@property (nonatomic, assign) BOOL disableViewDeckPanning;
@property (nonatomic,strong)UIButton *rightItemBtn;

//- (void)closeLeftViewDeckController;

-(void)setRightItemTitle:(NSString *)title;
-(void)rightAction;



@end
