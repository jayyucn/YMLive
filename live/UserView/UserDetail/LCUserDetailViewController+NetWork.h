//
//  LCUserDetailViewController+NetWork.h
//  XCLive
//
//  Created by ztkztk on 14-4-30.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCUserDetailViewController.h"

@interface LCUserDetailViewController (NetWork)
-(void)getUserDetail;
-(void)addFriend;
-(void)deleteFriend;
-(void)blackList;
-(void)report:(NSInteger)type;
- (void)inviteUserUpdatePhoto;
@end
