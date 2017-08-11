//
//  LCModifyPwdController.h
//  XCLive
//
//  Created by ztkztk on 14-4-28.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCViewController.h"

@interface LCModifyPwdController : LCViewController<UITextFieldDelegate>
@property (nonatomic,strong)UITextField *oldPwdText;
@property (nonatomic,strong)UITextField *pwdText;
@property (nonatomic,strong)UITextField *confirmPwdText;
@property (nonatomic,strong)ESButton *okBtn;

-(void)modifyPwd;

@end
