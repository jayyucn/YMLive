//
//  支付宝兑换界面
//  AlipayViewController.m
//
//  Created by garsonge on 17/2/20.
//


#import "AlipayViewController.h"


@interface AlipayViewController() <UITextFieldDelegate>
{
    NSString *recv_diamond;
}

@end


@implementation AlipayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
     * do any additional setup after loading the view
     */
    self.view.backgroundColor = ColorBackGround;
    
    _numOfHana.textColor = ColorPink;
    _numOfHana.text = [LCMyUser mine].recvDiamond;
    
    recv_diamond = [LCMyUser mine].recvDiamond;
    
    _numOfRMB = 0;
    
    _sendMsg.backgroundColor = ColorPink;
    // _sendMsg.titleLabel.textColor = [UIColor whiteColor];
    // _sendMsg.titleLabel.font = [UIFont systemFontOfSize:18.0];
    
    _nameText.delegate = self;
    _nameText.placeholder = @"请输入姓名";
    _alipayAccountText.delegate = self;
    _alipayAccountText.placeholder = @"请输入支付宝账号";
    
    // 添加手势：点击空白处收起键盘
    UITapGestureRecognizer *tapToHideKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    // 设置成NO表示当前控件响应后会传递到其他控件上，默认为YES
    tapToHideKeyboard.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapToHideKeyboard];
    
    _list = [[NSMutableArray alloc] init];
    NSArray *array = @[
                       @{@"rmb":ESLocalizedString(@"10元"), @"hana":[NSString stringWithFormat:@"%ld有美币", 10*[LCMyUser mine].rmtToHana]},
                       @{@"rmb":ESLocalizedString(@"50元"), @"hana":[NSString stringWithFormat:@"%ld有美币", 50*[LCMyUser mine].rmtToHana]},
                       @{@"rmb":ESLocalizedString(@"100元"), @"hana":[NSString stringWithFormat:@"%ld有美币", 100*[LCMyUser mine].rmtToHana]},
                       @{@"rmb":ESLocalizedString(@"200元"), @"hana":[NSString stringWithFormat:@"%ld有美币", 200*[LCMyUser mine].rmtToHana]},
                       ];
    _list = [NSMutableArray arrayWithArray:array];
    
    // 设置代理
    _exchangeRateTable.delegate = self;
    _exchangeRateTable.dataSource = self;
}

- (void)dealloc
{
    // if needed
    _list = nil;
}

// 更新视图
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _numOfHana.text = recv_diamond;
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
    static NSString *identifier = @"rmtExchangeTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    NSUInteger row = [indexPath row];
    
    cell.textLabel.text = [[self.list objectAtIndex:row] objectForKey:@"rmb"];
    cell.detailTextLabel.text = [[self.list objectAtIndex:row] objectForKey:@"hana"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath row])
    {
        case 0:
            _numOfRMB = 10;
            break;
        case 1:
            _numOfRMB = 50;
            break;
        case 2:
            _numOfRMB = 100;
            break;
        case 3:
            _numOfRMB = 200;
            break;
        default:
            break;
    }
    
    NSLog(@"JoyYou-YMLive :: %ld && number of rmb for exchange = %ld", [indexPath row], _numOfRMB);
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

// 收起键盘
- (void)hideKeyboard:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}


// 支付宝兑换
- (IBAction)sendAlipayExchangeInfo
{
    NSString *name = _nameText.text;
    NSString *account = _alipayAccountText.text;
    
    NSLog(@"JoyYou-YMLive :: send alipay exchange request with name = %@ && account = %@ && rmb = %ld", name, account, _numOfRMB);
    
    LCRequestSuccessResponseBlock successBlock = ^(NSDictionary *responseDic)
    {
        NSLog(@"JoyYou-YMLive :: requset alipay exchange with response = %@", [self dicToJson:responseDic]);
        
        NSInteger code = [[responseDic objectForKey:@"stat"] integerValue];
        // 请求成功
        if (URL_REQUEST_SUCCESS == code)
        {
            NSLog(@"JoyYou-YMLive :: requset alipay exchange succeeded");
            
            // 弹出提示
            [[[UIAlertView alloc] initWithTitle:nil
                                        message:@"兑换成功"
                                       delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil] show];
            
            // 更新剩余兑换数量
            if ([responseDic objectForKey:@"last_diamond"])
            {
                _numOfHana.text = [NSString stringWithFormat:@"%ld", [[responseDic objectForKey:@"last_diamond"] integerValue]];
                
                recv_diamond = [NSString stringWithFormat:@"%ld", [[responseDic objectForKey:@"last_diamond"] integerValue]];
            }
        }
        else
        {
            NSLog(@"JoyYou-YMLive :: requset alipay exchange failed");
            
            // 弹出提示
            [[[UIAlertView alloc] initWithTitle:nil
                                        message:@"兑换失败"
                                       delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil] show];
        }
    };
    
    LCRequestFailResponseBlock failBlock = ^(NSError *error)
    {
        NSLog(@"JoyYou-YMLive :: requset alipay exchange with error = %@", error.description);
    };
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"coins":@(_numOfRMB), @"account":account, @"realname":name}
                                                  withPath:URL_EXCHANGE_ALIPAY
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
