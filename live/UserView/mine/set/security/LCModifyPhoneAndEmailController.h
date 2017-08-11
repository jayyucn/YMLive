//
//  LCModifyPhoneAndEmailController.h
//  XCLive
//
//  Created by ztkztk on 14-4-28.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCInputTextViewController.h"

@interface LCModifyPhoneAndEmailController : LCInputTextViewController

-(void)nextAction;
-(void)requestModify:(NSDictionary *)modifyDic;
@end
