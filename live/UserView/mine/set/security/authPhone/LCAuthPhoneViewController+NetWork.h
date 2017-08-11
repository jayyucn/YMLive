//
//  LCAuthPhoneViewController+NetWork.h
//  XCLive
//
//  Created by ztkztk on 14-4-28.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCAuthPhoneViewController.h"

@interface LCAuthPhoneViewController (NetWork)
-(void)requestVerifying;
-(void)verifyingPhone:(NSDictionary *)code;
@end
