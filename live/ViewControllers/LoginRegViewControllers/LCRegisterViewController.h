//
//  LCRegisterViewController.h
//  XCLive
//
//  Created by ztkztk on 14-4-15.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCViewController.h"

#import "LCCustomTextField.h"

@interface LCRegisterViewController : LCViewController<UITextFieldDelegate>

@property (nonatomic,strong)LCCustomTextField *accountField;
@property (nonatomic,strong)LCCustomTextField *password;
@property (nonatomic,strong)LCCustomTextField *confirmPassword;
@property (nonatomic,strong)UIButton *registerBtn;

//-(void)rightAction;

@end
