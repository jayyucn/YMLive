//
//  LCCustomTabBar.h
//  XCLive
//
//  Created by ztkztk on 14-5-12.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^LCCustomTapBarBlock)(NSString *title);

@interface LCCustomTabBar : UIView
@property (nonatomic,strong)NSArray *items;


@property (nonatomic,strong)LCCustomTapBarBlock tapBarBlock;


+(id)customTabBar:(NSArray *)array withTapBarBlock:(LCCustomTapBarBlock)tapBarBlock;
+(id)customTabBarWithTapBarBlock:(LCCustomTapBarBlock)tapBarBlock;

-(void)initTabBar:(NSArray *)array;

-(void)showfollow;
-(void)showDeleteFollow;
@end
