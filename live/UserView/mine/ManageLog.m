//
//  ManageLog.m
//  TaoHuaLive
//
//  Created by garsonge on 17/2/23.
//  All rights reserved.
//


#import "ManageLog.h"

#import "ManageLogCell.h"


@interface ManageLog()
{
    ManageLogCell *logCell;
    
    BOOL isRegNib;
    
    BOOL isStart;
    BOOL isOver;
}

@end


@implementation ManageLog

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
    return 90.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"manageLogTableViewCell";
    
    // 注册自定义cell到tableview中，并设置cell的标识符
    if (!isRegNib)
    {
        [tableView registerNib:[UINib nibWithNibName:@"ManageLogCell" bundle:nil] forCellReuseIdentifier:identifier];
        isRegNib = YES;
    }
    logCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    // 设置cell的属性
    [logCell setupCell];
    
    if (logCell)
    {
        NSUInteger row = [indexPath row];
        
        if ([[self.list objectAtIndex:row] objectForKey:@"created"])
        {
            NSString *timeInterval = [[self.list objectAtIndex:row] objectForKey:@"created"];
            logCell.time.text = [self transToDate:timeInterval];
        }
        else
        {
            logCell.time.text = @"没有数据";
        }
        
        if ([[self.list objectAtIndex:row] objectForKey:@"uid"])
        {
            logCell.userId.text = [[self.list objectAtIndex:row] objectForKey:@"uid"];
        }
        else
        {
            logCell.userId.text = @"没有数据";
        }
        
        if ([[self.list objectAtIndex:row] objectForKey:@"operator"])
        {
            logCell.name.text = [[self.list objectAtIndex:row] objectForKey:@"operator"];
        }
        else
        {
            logCell.name.text = @"没有数据";
        }
        
        if ([[self.list objectAtIndex:row] objectForKey:@"content"])
        {
            logCell.content.text = [[self.list objectAtIndex:row] objectForKey:@"content"];
        }
        else
        {
            logCell.content.text = @"没有数据";
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

- (IBAction)closeCurrentView
{
    NSLog(@"JoyYou-YMLive :: close manage log view");
    
    UIViewController *previousVC = self.presentingViewController;
    
    [previousVC dismissViewControllerAnimated:YES completion:NULL];
}


// 获取兑换记录
- (void)getLogInfo
{
    NSLog(@"JoyYou-YMLive :: get manage log request");
    
    LCRequestSuccessResponseBlock successBlock = ^(NSDictionary *responseDic)
    {
        NSLog(@"JoyYou-YMLive :: get manage log with response = %@", [self dicToJson:responseDic]);
        
        NSInteger code = [[responseDic objectForKey:@"stat"] integerValue];
        // 请求成功
        if (URL_REQUEST_SUCCESS == code)
        {
            NSLog(@"JoyYou-YMLive :: get manage log succeeded");
            
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
            NSLog(@"JoyYou-YMLive :: get manage log failed");
            
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
        NSLog(@"JoyYou-YMLive :: get manage log with error = %@", error.description);
    };
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"page":@(_page), @"liveuid":[LCMyUser mine].liveUserId}
                                                  withPath:URL_MANAGE_LOG
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
