//
//  兑换记录界面
//  ExchangeLogViewController.m
//
//  Created by garsonge on 17/2/22.
//


#import "ExchangeLogViewController.h"

#import "LogTableCell.h"


@interface ExchangeLogViewController()
{
    LogTableCell *logCell;
    
    BOOL isRegNib;
    
    BOOL isStart;
    BOOL isOver;
}

@end


@implementation ExchangeLogViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
     * do any additional setup after loading the view
     */
    isRegNib = NO;
    
    isStart = NO;
    isOver = NO;
    
    self.view.backgroundColor = ColorBackGround;
    
    _page = 1;
    
    _pageNum.textColor = ColorPink;
    _pageNum.text = [NSString stringWithFormat:@"%ld", _page];
    
    _list = [[NSMutableArray alloc] init];
    [self getLogInfo];
    
    // 设置代理
    _logTable.delegate = self;
    _logTable.dataSource = self;
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
    NSLog(@"JoyYou-YMLive :: table row count = %ld", [self.list count]);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"exchangeLogTableViewCell";
    
    // 注册自定义cell到tableview中，并设置cell的标识符
    if (!isRegNib)
    {
        [tableView registerNib:[UINib nibWithNibName:@"logTableCell" bundle:nil] forCellReuseIdentifier:identifier];
        isRegNib = YES;
    }
    logCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    // 设置cell的属性
    [logCell setupCell];
    
    if (logCell)
    {
        NSUInteger row = [indexPath row];
        
        NSString *timeInterval = [[self.list objectAtIndex:row] objectForKey:@"add_time"];
        logCell.time.text = [self transToDate:timeInterval];
        
        NSString *exchangType = [[self.list objectAtIndex:row] objectForKey:@"type"];
        switch ([exchangType integerValue])
        {
            case 1:
                logCell.channel.text = @"兑换钻石";
                break;
            case 2:
                logCell.channel.text = @"支付宝兑换";
                break;
            case 3:
                logCell.channel.text = @"微信红包兑换";
                break;
            case 4:
                logCell.channel.text = @"银行卡兑换";
                break;
            default:
                break;
        }
        
        NSString *getCoins = [[self.list objectAtIndex:row] objectForKey:@"money"];
        NSString *costCoins = [[self.list objectAtIndex:row] objectForKey:@"ucoins"];
        if ([exchangType isEqualToString:@"1"])
        {
            logCell.content.text = [NSString stringWithFormat:@"消耗%@有美币兑换%@钻石", costCoins, getCoins];
        }
        else
        {
            logCell.content.text = [NSString stringWithFormat:@"消耗%@有美币兑换%@元", costCoins, getCoins];
        }
        
        NSString *status = [[self.list objectAtIndex:row] objectForKey:@"status"];
        switch ([status integerValue])
        {
            case 0:
                logCell.status.text = @"进行中";
                break;
            case 2:
                logCell.status.text = @"完成";
                break;
            case 9:
                logCell.status.text = @"兑换失败";
                break;
            default:
                break;
        }
    }
    
    return logCell;
}


// 下一页
- (IBAction)nextPage
{
    NSLog(@"JoyYou-YMLive :: current page number = %ld", _page);
    
    if (!isOver)
    {
        _page++;
        [self getLogInfo];
    }
    else
    {
        // 弹出提示
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"没有更多数据"
                                   delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil] show];
    }
}

// 上一页
- (IBAction)previousPage
{
    NSLog(@"JoyYou-YMLive :: current page number = %ld", _page);
    
    isOver = NO;
    
    if (!isStart)
    {
        // 弹出提示
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"已经是第一页"
                                   delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil] show];
    }
    else
    {
        _page = [_pageNum.text integerValue];
        _page--;
        [self getLogInfo];
    }
}


// 获取兑换记录
- (void)getLogInfo
{
    NSLog(@"JoyYou-YMLive :: get log info request");
    
    LCRequestSuccessResponseBlock successBlock = ^(NSDictionary *responseDic)
    {
        NSLog(@"JoyYou-YMLive :: get log info with response = %@", [self dicToJson:responseDic]);
        
        NSInteger code = [[responseDic objectForKey:@"stat"] integerValue];
        // 请求成功
        if (URL_REQUEST_SUCCESS == code)
        {
            NSLog(@"JoyYou-YMLive :: get log info succeeded");
            
            // 更新表格内容
            if ([responseDic objectForKey:@"data"])
            {
                NSArray *array = [responseDic objectForKey:@"data"];
                _list = [NSMutableArray arrayWithArray:array];
                
                [_logTable reloadData];
            }
            
            // 更新页码
            _pageNum.text = [NSString stringWithFormat:@"%ld", _page];
            
            if (_page >= 2)
            {
                isStart = YES;
            }
            else
            {
                isStart = NO;
            }
        }
        else if (201 == code)
        {
            NSLog(@"JoyYou-YMLive :: no more log");
            
            isOver = YES;
            
            // 弹出提示
            [[[UIAlertView alloc] initWithTitle:nil
                                        message:@"没有更多数据"
                                       delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil] show];
        }
        else
        {
            NSLog(@"JoyYou-YMLive :: get log info failed");
            
            // 弹出提示
            [[[UIAlertView alloc] initWithTitle:nil
                                        message:@"获取数据失败"
                                       delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil] show];
        }
    };
    
    LCRequestFailResponseBlock failBlock = ^(NSError *error)
    {
        NSLog(@"JoyYou-YMLive :: get log info with error = %@", error.description);
    };
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"page":@(_page)}
                                                  withPath:URL_EXCHANGE_LOG
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

// 时间戳2日期
- (NSString *)transToDate:(NSString *)timsp
{
    NSTimeInterval time = [timsp doubleValue];
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    
    // 实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    // 设置时间显示格式
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate:detailDate];
    
    return currentDateStr;
}

@end
