//
//  KFRegisterFirstController.h
//  CaoLiu
//
//  Created by jacklong on 15/9/10.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import "LCCustomTextField.h"
#import "LCInsetsLabel.h"
#import "LCViewController.h"

@interface KFRegisterFirstController : LCViewController<UITextFieldDelegate>

@property (nonatomic,strong)LCCustomTextField *accountField;
@property (nonatomic,strong)LCCustomTextField *password;
@property (nonatomic,strong)LCCustomTextField *authCode;
@property (nonatomic,strong)UIButton *getAuthCodeBtn; 

@property (nonatomic)BOOL Loading;

@property (nonatomic,strong)NSTimer *myTimer;
@property (nonatomic)int timeNumber;
@property (nonatomic)int phoneTimeCounter;

@end
