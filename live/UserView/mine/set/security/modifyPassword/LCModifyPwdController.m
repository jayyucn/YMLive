//
//  LCModifyPwdController.m
//  XCLive
//
//  Created by ztkztk on 14-4-28.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCModifyPwdController.h"

@interface LCModifyPwdController ()

@end

@implementation LCModifyPwdController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)dealloc
{
//    [[LCHTTPClient sharedHTTPClient] cancelAllHTTPOperationsWithMethod:nil path:modifyPwdURL()];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _oldPwdText=[[UITextField alloc] initWithFrame:CGRectMake(20.0f,30.0f,280.0f,30.0f)];
    _oldPwdText.placeholder = @"请输入原始密码";
    _oldPwdText.secureTextEntry = YES;
    _oldPwdText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _oldPwdText.font=[UIFont systemFontOfSize:20.0f];
    _oldPwdText.delegate=self;
    _oldPwdText.returnKeyType=UIReturnKeyDone;
    [self.view addSubview:_oldPwdText];

    
    _pwdText=[[UITextField alloc] initWithFrame:CGRectMake(20.0f,_oldPwdText.bottom+10,280.0f,30.0f)];
    _pwdText.placeholder = @"请输入新密码";
    _pwdText.secureTextEntry = YES;
    _pwdText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _pwdText.font=[UIFont systemFontOfSize:20.0f];
    _pwdText.delegate=self;
    _pwdText.returnKeyType=UIReturnKeyDone;
    [self.view addSubview:_pwdText];

    
    
    _confirmPwdText=[[UITextField alloc] initWithFrame:CGRectMake(20.0f,_pwdText.bottom+10,280,30)];
    _confirmPwdText.placeholder = @"确认新密码";
    _confirmPwdText.secureTextEntry = YES;
    _confirmPwdText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _confirmPwdText.font=[UIFont systemFontOfSize:20.0f];
    _confirmPwdText.delegate=self;
    _confirmPwdText.returnKeyType=UIReturnKeyDone;
    [self.view addSubview:_confirmPwdText];
    
    self.okBtn= [ESButton buttonWithTitle:@"确认认证" buttonColor:[UIColor blueColor]];
    _okBtn.frame=CGRectMake(10, _confirmPwdText.bottom+20,ScreenWidth - 20,40);
    [_okBtn setTitleColor:[UIColor whiteColor]
                      forState:UIControlStateNormal];
    
    [_okBtn addTarget:self
                    action:@selector(modifyPwd)
          forControlEvents:UIControlEventTouchUpInside];
    
    [_okBtn setTitle:@"确认修改"
                 forState:UIControlStateNormal];
    [self.view addSubview:_okBtn];


}

-(void)modifyPwd
{
    
//    if([_pwdText.text length]<6||[_pwdText.text length]>16)
//    {
//        [LCNoticeAlertView showMsg:@"用户密码为6到16位字母，数字或者下划线！"];
//        return;
//    }else if(![_pwdText.text isEqualToString:_confirmPwdText.text]){
//        [LCNoticeAlertView showMsg:@"输入用户密码不一致！"];
//        return;
//    }else if([_oldPwdText.text isEqualToString:_pwdText.text])
//    {
//        [LCNoticeAlertView showMsg:@"您输入的密码和原密码一样"];
//        return;
//    }
//
//    ESWeakSelf;
//    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
//        ESStrongSelf;
//        NSLog(@"gagresponseDic=%@",responseDic);
//        int stat=[responseDic[@"stat"] intValue];
//        if(stat==200)
//        {
//            [LCNoticeAlertView showMsg:@"修改密码成功"];
//            [_self.navigationController popViewControllerAnimated:YES];
//            
//        }
//        else{
//            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
//        }
//      };
//    
//    LCRequestFailResponseBlock failBlock=^(NSError *error){
//        NSLog(@"gagerror=%@",error);
//         [LCNoticeAlertView showMsg:@"请检查网络状态"];
//        
//    };
//    
//    NSDictionary *dic=@{@"oldpwd":[_oldPwdText.text es_md5Hash],@"newpwd":[_pwdText.text es_md5Hash]};
//    [[LCHTTPClient sharedHTTPClient] requestWithParameters:dic
//                                                  withPath:modifyPwdURL()
//                                               withRESTful:POST_REQUEST
//                                          withSuccessBlock:successBlock
//                                             withFailBlock:failBlock];
//
//    
//    
//
//    
    
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
