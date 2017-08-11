//
//  EditUserNameViewController.h
//  qianchuo
//
//  Created by jacklong on 16/4/1.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//


@interface EditUserNameViewController : LCViewController<UITextFieldDelegate>

@property (nonatomic, strong)UIButton       *clearBtn;
@property (nonatomic, strong)UITextField    *nickNameTextField;
@property (nonatomic, strong)UILabel        *promptLabel;
@end
