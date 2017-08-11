//
//  钻石兑换界面
//  DiamondExchangeViewController.m
//
//  Created by garsonge on 17/2/20.
//


#import "DiamondExchangeViewController.h"


@interface DiamondExchangeViewController()
{
    NSString *cur_diamond;
    NSString *recv_diamond;
}

@end


@implementation DiamondExchangeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
     * do any additional setup after loading the view
     */
    _numOfDiamond.text = [LCMyUser mine].curDiamond;
    _numOfHana.text = [LCMyUser mine].recvDiamond;
    
    cur_diamond = [LCMyUser mine].curDiamond;
    recv_diamond = [LCMyUser mine].recvDiamond;
    
    _numOfDia = 0;
    
    _sendMsg.backgroundColor = ColorPink;
    
    _list = [[NSMutableArray alloc] init];
    NSArray *array = @[
                       @{@"dia":ESLocalizedString(@"100钻石"), @"hana":[NSString stringWithFormat:@"%ld有美币", 100*[LCMyUser mine].diaToHana]},
                       @{@"dia":ESLocalizedString(@"500钻石"), @"hana":[NSString stringWithFormat:@"%ld有美币", 500*[LCMyUser mine].diaToHana]},
                       @{@"dia":ESLocalizedString(@"1000钻石"), @"hana":[NSString stringWithFormat:@"%ld有美币", 1000*[LCMyUser mine].diaToHana]},
                       @{@"dia":ESLocalizedString(@"3000钻石"), @"hana":[NSString stringWithFormat:@"%ld有美币", 3000*[LCMyUser mine].diaToHana]},
                       @{@"dia":ESLocalizedString(@"5000钻石"), @"hana":[NSString stringWithFormat:@"%ld有美币", 5000*[LCMyUser mine].diaToHana]},
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
    
    _numOfDiamond.text = cur_diamond;
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
    static NSString *identifier = @"diaExchangeTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    NSUInteger row = [indexPath row];
    
    cell.textLabel.text = [[self.list objectAtIndex:row] objectForKey:@"dia"];
    cell.detailTextLabel.text = [[self.list objectAtIndex:row] objectForKey:@"hana"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath row])
    {
        case 0:
            _numOfDia = 100;
            break;
        case 1:
            _numOfDia = 500;
            break;
        case 2:
            _numOfDia = 1000;
            break;
        case 3:
            _numOfDia = 3000;
            break;
        case 4:
            _numOfDia = 5000;
        default:
            break;
    }
    
    NSLog(@"JoyYou-YMLive :: %ld && number of diamond for exchange = %ld", [indexPath row], _numOfDia);
}


// 兑换钻石
- (IBAction)sendDiamondExchangeInfo
{
    NSLog(@"JoyYou-YMLive :: send diamond exchange request with diamond = %ld", _numOfDia);
    
    LCRequestSuccessResponseBlock successBlock = ^(NSDictionary *responseDic)
    {
        NSLog(@"JoyYou-YMLive :: requset diamond exchange with response = %@", [self dicToJson:responseDic]);
        
        NSInteger code = [[responseDic objectForKey:@"stat"] integerValue];
        // 请求成功
        if (URL_REQUEST_SUCCESS == code)
        {
            NSLog(@"JoyYou-YMLive :: requset diamond exchange succeeded");
            
            // 弹出提示
            [[[UIAlertView alloc] initWithTitle:nil
                                        message:@"兑换成功"
                                       delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil] show];
            
            // 更新剩余兑换数量
            if ([responseDic objectForKey:@"diamond"] && [responseDic objectForKey:@"last_diamond"])
            {
                _numOfDiamond.text = [NSString stringWithFormat:@"%ld", [[responseDic objectForKey:@"diamond"] integerValue]];
                _numOfHana.text = [NSString stringWithFormat:@"%ld", [[responseDic objectForKey:@"last_diamond"] integerValue]];
                
                cur_diamond = [NSString stringWithFormat:@"%ld", [[responseDic objectForKey:@"diamond"] integerValue]];
                recv_diamond = [NSString stringWithFormat:@"%ld", [[responseDic objectForKey:@"last_diamond"] integerValue]];
            }
        }
        else
        {
            NSLog(@"JoyYou-YMLive :: requset diamond exchange failed");
            
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
        NSLog(@"JoyYou-YMLive :: requset diamond exchange with error = %@", error.description);
    };
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"coins":@(_numOfDia)}
                                                  withPath:URL_EXCHANGE_DIAMOND
                                               withRESTful:GET_REQUEST
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
