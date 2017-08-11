//
//  LCRegisterViewController.m
//  XCLive
//
//  Created by ztkztk on 14-4-15.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCRegisterViewController.h"

#import "LCRegDoneController.h"
#import "LCCore.h"

@interface LCRegisterViewController ()

@end

@implementation LCRegisterViewController


#define UserInterfaceShowTop 50
#define UserInterfaceNormal 150



-(void)dealloc
{
    //    [[LCHTTPClient sharedHTTPClient] cancelAllHTTPOperationsWithMethod:nil path:basicRegisterURL()];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"注册";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width / 2 - 50, 70, 100, 100)];
    imageView.image = [UIImage imageNamed:@"image/liveroom/xinxiu"];
    imageView.layer.cornerRadius = 10;
    imageView.layer.masksToBounds = YES;
    [self.view addSubview:imageView];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"有美直播";
    [label sizeToFit];
    label.center = CGPointMake(imageView.centerX, imageView.bottom + 15);
    label.textColor = ColorDark;
    [self.view addSubview:label];
    
    _accountField=[[LCCustomTextField alloc] initWithFrame:CGRectMake(0.0f, label.bottom + 15, ScreenWidth, 50)];
    _accountField.placeholder = ESLocalizedString(@"请输入手机号码");
    _accountField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _accountField.font=[UIFont systemFontOfSize:15.0f];
    _accountField.delegate=self;
    _accountField.returnKeyType=UIReturnKeySend;
    _accountField.keyboardType=UIKeyboardTypeNumberPad;
    [self.view addSubview:_accountField];
    
    
    
    _password=[[LCCustomTextField alloc] initWithFrame:CGRectMake(0.0f,_accountField.bottom + 1.0f,ScreenWidth,50)];
    _password.placeholder = ESLocalizedString(@"请输入6到16位密码");
    _password.secureTextEntry = YES;
    _password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _password.font=[UIFont systemFontOfSize:15.0f];
    _password.delegate=self;
    _password.returnKeyType=UIReturnKeySend;
    [self.view addSubview:_password];
    
    
    _confirmPassword=[[LCCustomTextField alloc] initWithFrame:CGRectMake(0.0f,_password.bottom+1.0f,320,50)];
    _confirmPassword.placeholder = ESLocalizedString(@"确认密码");
    _confirmPassword.secureTextEntry = YES;
    _confirmPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _confirmPassword.font=[UIFont systemFontOfSize:15.0f];
    _confirmPassword.delegate=self;
    _confirmPassword.returnKeyType=UIReturnKeySend;
    [self.view addSubview:_confirmPassword];
    
    _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_registerBtn setBackgroundImage:[UIImage imageNamed:@"recharge_button_normal"]
                            forState:UIControlStateNormal];
    [_registerBtn setBackgroundImage:[UIImage imageNamed:@"recharge_button_selected"]
                            forState:UIControlStateHighlighted];
    [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIImage *btnImage = [UIImage imageNamed:@"recharge_button_normal"];
    _registerBtn.frame=CGRectMake(self.view.width / 2 - btnImage.size.width / 2, _confirmPassword.bottom + 5.0f, btnImage.size.width, btnImage.size.height);
    [_registerBtn setTitleColor:[UIColor whiteColor]
                       forState:UIControlStateNormal];
    [_registerBtn setTitle:@"注 册"
                  forState:UIControlStateNormal];
    
    [_registerBtn addTarget:self
                     action:@selector(btnAction)
           forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerBtn];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillChangeFrameNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//        CGFloat durtion = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey]floatValue];
//        NSLog(@"%@", NSStringFromCGRect(frame));
        self.view.bottom = frame.origin.y;
    }];
}



-(void)btnAction
{
    //参数判断
    if(![[LCCore globalCore] isValidateMobile:self.accountField.text])
    {
        [[LCCore globalCore] shakeView:self.accountField];
        return;
    }
    
    
    if([_password.text length]<6||[_password.text length]>16)
    {
        [[LCCore globalCore] shakeView:self.password];
        return;
    }
    
    if(![_password.text isEqualToString:_confirmPassword.text]){
        [[LCCore globalCore] shakeView:self.confirmPassword];
        return;
    }
    
    [_accountField resignFirstResponder];
    [_password resignFirstResponder];
    [_confirmPassword resignFirstResponder];
    
    [self registerToSever];
}

-(void)registerToSever
{
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self btnAction];
    [textField resignFirstResponder];
    
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
