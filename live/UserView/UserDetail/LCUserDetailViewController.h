//
//  LCUserDetailViewController.h
//  XCLive
//
//  Created by ztkztk on 14-4-30.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCTableViewController.h"
#import "LCDetailHeaderView.h"
#import "LCMoreDetailCell.h"
#import "LCCustomTabBar.h"
//#import "MatchCoupleRootView.h"

@interface LCUserDetailViewController : LCTableViewController

@property (nonatomic,strong)NSString *userID;
@property (nonatomic,strong)NSString *userName;
@property (nonatomic,strong)NSDictionary *userDic;
@property (nonatomic,strong)LCDetailHeaderView *detailHeaderView;
@property (nonatomic,strong)LCCustomTabBar *tabBar;
//@property (nonatomic,strong)MatchCoupleRootView *coupleRootView;
@property (nonatomic)int atten;
@property (nonatomic)BOOL autoPlayVideo;

@property (nonatomic,strong)MPMoviePlayerController *playerController;
@property (nonatomic, strong)NSArray *userGiftArray;
@property (nonatomic, strong)NSDictionary *userDateDic;

@property (nonatomic)int convertSectionIndex;

+(id)userDetail:(NSDictionary *)dic;

+(id)userDetailAutoPlayVideo:(NSDictionary *)dic;

@end
