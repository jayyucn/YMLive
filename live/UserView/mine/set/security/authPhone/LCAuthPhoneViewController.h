//
//  LCAuthPhoneViewController.h
//  XCLive
//
//  Created by ztkztk on 14-4-26.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCAuthViewController.h"

#import "LCCustomTextField.h"
//static int phoneTimeCounter;
@interface LCAuthPhoneViewController : LCAuthViewController

@property (nonatomic,strong)LCCustomTextField *codeText;
@property (nonatomic)int phoneTimeCounter;
-(void)savePhoneCodeTime;
@end
