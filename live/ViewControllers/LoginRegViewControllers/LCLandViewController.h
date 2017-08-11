//
//  LCLandViewController.h
//  XCLive
//
//  Created by ztkztk on 14-4-29.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCRegisterViewController.h"
//#import "LocationManager.h"

@interface LCLandViewController : LCRegisterViewController<UIActionSheetDelegate>

@property (nonatomic,strong)UIButton *forgetPassword;
//@property (nonatomic,strong)LocationManager *locationManager;

-(void)forgetPasswordAction;
@end
