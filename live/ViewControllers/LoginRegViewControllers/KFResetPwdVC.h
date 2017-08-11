//
//  KFResetPwdVC.h
//  CaoLiu
//
//  Created by jacklong on 15/9/15.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import "LCViewController.h"
#import "LCCustomTextField.h"

@interface KFResetPwdVC : LCViewController<UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic,strong)LCCustomTextField *accountField;
@property (nonatomic,strong)LCCustomTextField *password;
@property (nonatomic,strong)LCCustomTextField *authCode;
@property (nonatomic,strong)UIButton *getAuthCodeBtn;
@property (nonatomic,strong)UIButton *resetPwdBtn;

@property (nonatomic)BOOL Loading;

@property (nonatomic,strong)NSTimer *myTimer;
@property (nonatomic)int timeNumber;
@property (nonatomic)int phoneTimeCounter;

@end
