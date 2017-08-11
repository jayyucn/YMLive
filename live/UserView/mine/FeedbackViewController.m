//
//  FeedbackViewController.m
//  TaoHuaLive
//
//  Created by garsonge on 17/2/22.
//  All rights reserved.
//


#import "FeedbackViewController.h"


@interface FeedbackViewController() <UITextViewDelegate>
{
    NSString *recv_diamond;
    NSString *questionType;
}

@end



@implementation FeedbackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
     * do any additional setup after loading the view
     */
    self.view.backgroundColor = ColorBackGround;
    _sendMsg.backgroundColor = ColorPink;
    
    // 默认其他
    questionType = @"1";
    
    // 添加手势：点击空白处收起键盘
    UITapGestureRecognizer *tapToHideKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    // 设置成NO表示当前控件响应后会传递到其他控件上，默认为YES
    tapToHideKeyboard.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapToHideKeyboard];
    
    _list = [[NSMutableArray alloc] init];
    NSArray *array = @[@"兑换问题", @"支付问题", @"直播问题", @"账户问题", @"其他问题"];
    _list = [NSMutableArray arrayWithArray:array];
    
    _questionDes.delegate = self;
    
    // 设置代理
    _questionTypeTable.delegate = self;
    _questionTypeTable.dataSource = self;
}

- (void)dealloc
{
    // if needed
    _list = nil;
}


#pragma mark - table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"qTypeTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSUInteger row = [indexPath row];
    
    cell.textLabel.text = [self.list objectAtIndex:row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath row])
    {
        case 0:
            questionType = @"5";
            break;
        case 1:
            questionType = @"4";
            break;
        case 2:
            questionType = @"3";
            break;
        case 3:
            questionType = @"2";
            break;
        case 4:
            questionType = @"1";
            break;
        default:
            break;
    }
    
    NSLog(@"JoyYou-YMLive :: %ld && question type = %@", [indexPath row], questionType);
}

// 收起键盘
- (void)hideKeyboard:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}


// 回退到上一层界面
- (IBAction)backToPreviousView
{
    UIViewController *previousVC = self.presentingViewController;
    
    [previousVC dismissViewControllerAnimated:YES completion:NULL];
}

// 发送反馈
- (IBAction)sendFeedbackInfo
{
    NSString *content = _questionDes.text;
    
    NSLog(@"JoyYou-YMLive :: send feedback info with content = %@ && type = %@", content, questionType);
    
    if ([_questionDes hasText])
    {
        LCRequestSuccessResponseBlock successBlock = ^(NSDictionary *responseDic)
        {
            NSLog(@"JoyYou-YMLive :: send feedback info with response = %@", [self dicToJson:responseDic]);
            
            NSInteger code = [[responseDic objectForKey:@"stat"] integerValue];
            // 请求成功
            if (URL_REQUEST_SUCCESS == code)
            {
                NSLog(@"JoyYou-YMLive :: send feedback info succeeded");
                
                // 弹出提示
                [[[UIAlertView alloc] initWithTitle:@"提交成功"
                                            message:@"谢谢您的反馈"
                                           delegate:nil
                                  cancelButtonTitle:@"确定"
                                  otherButtonTitles:nil] show];
            }
            else
            {
                NSLog(@"JoyYou-YMLive :: send feedback info failed");
                
                // 弹出提示
                [[[UIAlertView alloc] initWithTitle:nil
                                            message:@"提交失败，请稍后重试"
                                           delegate:nil
                                  cancelButtonTitle:@"确定"
                                  otherButtonTitles:nil] show];
            }
        };
        
        LCRequestFailResponseBlock failBlock = ^(NSError *error)
        {
            NSLog(@"JoyYou-YMLive :: send feedback info with error = %@", error.description);
        };
        
        NSMutableDictionary *parameters=[NSMutableDictionary dictionaryWithDictionary:[LCCore appInformation]];
        [parameters setObject:content forKey:@"memo"];
        [parameters setObject:questionType forKey:@"type"];
        
        [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameters
                                                      withPath:feedBackURL()
                                                   withRESTful:GET_REQUEST
                                              withSuccessBlock:successBlock
                                                 withFailBlock:failBlock];
    }
    else
    {
        // 弹出提示
        [[[UIAlertView alloc] initWithTitle:@"温馨提示"
                                    message:@"问题内容不能为空"
                                   delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil] show];
    }
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
