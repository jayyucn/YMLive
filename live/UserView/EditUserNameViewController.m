//
//  EditUserNameViewController.m
//  qianchuo 编辑用户名称
//
//  Created by jacklong on 16/4/1.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "EditUserNameViewController.h"

#define  NAME_LENGHT 12

@interface  EditUserNameViewController()
{
    BOOL _isLoading;
}
@end

@implementation EditUserNameViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.title = ESLocalizedString(@"昵称");
    
    UIButton *leftItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItemBtn.frame = CGRectMake(0, 0, 65.0, 30.0);
    
    [leftItemBtn setTitle:ESLocalizedString(@"取消")
                 forState:UIControlStateNormal];
    leftItemBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    leftItemBtn.backgroundColor = [UIColor clearColor];
    
    [leftItemBtn addTarget:self
                    action:@selector(leftAction)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc] initWithCustomView:leftItemBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    
    UIButton *rightItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItemBtn.frame=CGRectMake(0, 0, 65.0, 30.0);
    
    rightItemBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [rightItemBtn setTitle:ESLocalizedString(@"保存")
                  forState:UIControlStateNormal];
    rightItemBtn.backgroundColor=[UIColor clearColor];
    
    [rightItemBtn addTarget:self
                     action:@selector(rightAction)
           forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithCustomView:rightItemBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    UIView  *headLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 1)];
    headLineView.backgroundColor = RGBA16(0x20000000);
    [self.view  addSubview:headLineView];
    
    
    UIView * contentContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, headLineView.bottom, SCREEN_WIDTH, 50)];
    //发送框容器
    contentContainerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentContainerView];
    
    _nickNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH, 50)];
    _nickNameTextField.text = [LCMyUser mine].nickname;
    _nickNameTextField.backgroundColor = [UIColor clearColor];
    _nickNameTextField.borderStyle = UITextBorderStyleNone;
    _nickNameTextField.textColor = ColorPink;
    _nickNameTextField.delegate = self;
    _nickNameTextField.font = [UIFont systemFontOfSize:14.f];
    [_nickNameTextField setReturnKeyType:UIReturnKeyDefault];
    [contentContainerView addSubview:_nickNameTextField];
    [_nickNameTextField becomeFirstResponder];
    
    UIView  *endLineView = [[UIView alloc] initWithFrame:CGRectMake(0, contentContainerView.bottom, SCREEN_WIDTH, 1)];
    endLineView.backgroundColor = RGBA16(0x20000000);
    [self.view addSubview:endLineView];
    
    UIImage *clearEditImg = [UIImage imageNamed:@"image/liveroom/clear_gb"];
    
    _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_clearBtn setImage:clearEditImg forState:UIControlStateNormal];
    _clearBtn.frame = CGRectMake(SCREEN_WIDTH-20-clearEditImg.size.width, headLineView.bottom+25-clearEditImg.size.height/2, clearEditImg.size.width, clearEditImg.size.height);
    [self.view addSubview:_clearBtn];
    [_clearBtn addTarget:self action:@selector(clearNameAction) forControlEvents:UIControlEventTouchUpInside];
    
    _promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, endLineView.bottom+30, SCREEN_WIDTH, 20)];
    _promptLabel.textAlignment = NSTextAlignmentCenter;
    _promptLabel.textColor = [UIColor grayColor];
    _promptLabel.font  = [UIFont systemFontOfSize:16.f];
    
    [self.view addSubview:_promptLabel];
    _promptLabel.text = [NSString stringWithFormat:ESLocalizedString(@"您最多还能输入%d个文字"),(int)(NAME_LENGHT - _nickNameTextField.text.length)];
    
    [_nickNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void) textFieldDidChange:(UITextField *) textField
{
    if (textField == _nickNameTextField) {
        if (textField.text.length > NAME_LENGHT) {
            textField.text = [textField.text substringToIndex:NAME_LENGHT];
            _promptLabel.text = [NSString stringWithFormat:ESLocalizedString(@"您最多还能输入0个文字")];
        } else {
            _promptLabel.text = [NSString stringWithFormat:ESLocalizedString(@"您最多还能输入%d个文字"),(int)(NAME_LENGHT - textField.text.length)];
        }
        
        if (textField.text.length == 0) {
            _clearBtn.hidden = YES;
        } else {
            self.navigationItem.rightBarButtonItem.customView.hidden=NO;
            _clearBtn.hidden = NO;
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _nickNameTextField) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > NAME_LENGHT) {
            return NO;
        }
    }
    
    return YES;
}


- (void) clearNameAction
{
    _nickNameTextField.text = @"";
    _clearBtn.hidden = YES;
    _promptLabel.text = ESLocalizedString(@"您最多还能输入16个文字");
    self.navigationItem.rightBarButtonItem.customView.hidden=YES;
}


- (void) rightAction
{
    if (_nickNameTextField.text.length == 0) {
        return;
    }
    
    if ([_nickNameTextField.text isEqualToString:[LCMyUser mine].nickname]) {
        [_nickNameTextField resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if(_isLoading)
        return;
    
    _isLoading=YES;
    ESWeakSelf;
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        
        ESStrongSelf;
        NSLog(@"edit detail = %@",responseDic);
        int stat=[responseDic[@"stat"] intValue];
        if(stat == URL_REQUEST_SUCCESS)
        {
            [LCMyUser mine].nickname = _nickNameTextField.text;
            [[LCMyUser mine] save];
            [_nickNameTextField resignFirstResponder];
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_EditInfo_Success
                                                                    object:@"name"];
            
            [_self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
        
        _isLoading = NO;
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        NSLog(@"edit fial :%@",error);
        ESStrongSelf;
        _isLoading = NO;
        [LCNoticeAlertView showMsg:ESLocalizedString(@"保存失败")];
    };
    
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"nickname":_nickNameTextField.text}
                                                  withPath:URL_EDIT_USER_INFO
                                               withRESTful:POST_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}

- (void) leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
