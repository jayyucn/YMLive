//
//  微信绑定界面
//  WechatBindViewController.h
//
//  Created by garsonge on 17/2/20.
//


@interface WechatBindViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton *sendMsgButton;

@property (nonatomic, weak) IBOutlet UITextField *verifyCodeText;

@property (nonatomic, copy) NSString *verifyCode;


// 回退到上一层界面
- (IBAction)backToPreviousView;

// 绑定微信
- (IBAction)sendWXBindInfo;

@end
