//
//  微信绑定界面
//  WechatBindViewController.m
//
//  Created by garsonge on 17/2/20.
//


#import "WechatBindViewController.h"


@interface WechatBindViewController() <UITextFieldDelegate>
{
}

@end


@implementation WechatBindViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
     * do any additional setup after loading the view
     */
    self.view.backgroundColor = ColorBackGround;
    _sendMsgButton.backgroundColor = ColorPink;
    
    _verifyCodeText.delegate = self;
    _verifyCodeText.placeholder = @"请输入验证码";
    
    // 添加手势：点击空白处收起键盘
    UITapGestureRecognizer *tapToHideKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    // 设置成NO表示当前控件响应后会传递到其他控件上，默认为YES
    tapToHideKeyboard.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapToHideKeyboard];
}

- (void)dealloc
{
    // if needed
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

// 收起键盘
- (void)hideKeyboard:(UITapGestureRecognizer *)tap
{
    // [self.view endEditing:YES];
    [_verifyCodeText resignFirstResponder];
}


// 回退到上一层界面
- (IBAction)backToPreviousView
{
    UIViewController *previousVC = self.presentingViewController;
    
    [previousVC dismissViewControllerAnimated:YES completion:NULL];
}

// 绑定微信
- (IBAction)sendWXBindInfo
{
    _verifyCode = _verifyCodeText.text;
    NSLog(@"JoyYou-YMLive :: send wx bind request with verify code = %@", _verifyCode);
    
    LCRequestSuccessResponseBlock successBlock = ^(NSDictionary *responseDic)
    {
        NSLog(@"JoyYou-YMLive :: requset bind wx with response = %@", [self dicToJson:responseDic]);
        
        NSInteger code = [[responseDic objectForKey:@"stat"] integerValue];
        // 请求成功
        if (URL_REQUEST_SUCCESS == code)
        {
            NSLog(@"JoyYou-YMLive :: requset bind wx succeeded");
            
            // 修改用户绑定状态
            [LCMyUser mine].isBindWX = YES;
            
            // 跳转我的收益界面
            UIStoryboard *mineEarningStroyBoard = [UIStoryboard storyboardWithName:@"MineExchange" bundle:nil];
            UIViewController *mineEarningView = [mineEarningStroyBoard instantiateViewControllerWithIdentifier:@"mineEarning"];
            
            UINavigationController *mineEarningNavigator = [[UINavigationController alloc] initWithRootViewController:mineEarningView];
            [self presentViewController:mineEarningNavigator animated:YES completion:nil];
        }
        else
        {
            NSLog(@"JoyYou-YMLive :: requset bind wx failed");
            
            // 弹出提示
            [[[UIAlertView alloc] initWithTitle:@"温馨提示"
                                        message:@"绑定微信失败"
                                       delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil] show];
        }
    };
    
    LCRequestFailResponseBlock failBlock = ^(NSError *error)
    {
        NSLog(@"JoyYou-YMLive :: requset bind wx with error = %@", error.description);
    };
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"code":_verifyCode}
                                                  withPath:URL_PROFILE_BINDWX
                                               withRESTful:POST_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}


// dic2json
- (NSString *)dicToJson:(NSDictionary *)dic
{
    NSError * parseError = nil;
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonStr;
}

@end
