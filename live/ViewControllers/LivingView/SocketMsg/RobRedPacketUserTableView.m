//
//  RobRedPacketUserTableView.m
//  qianchuo
//
//  Created by jacklong on 16/3/26.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "RobRedPacketUserTableView.h"
#import "RobRedPacketUserCell.h"

@interface RobRedPacketUserTableView()
{
    BOOL isLoading;
    int  currPage;
}

@end

@implementation RobRedPacketUserTableView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        _datas = [NSMutableArray array];
        
        //添加上拉加载
        _footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        _footer.stateLabel.hidden = YES;
        self.mj_footer = _footer;
    }
    return self;
}


- (void)refreshData
{
    currPage = 1;
    [self requestUserArray:currPage];
    
}

- (void)loadData
{
    currPage++;
    [self requestUserArray:currPage];
}

- (void)requestUserArray:(int)page
{
    if (isLoading || ![LCMyUser mine].liveUserId)
    {
        return;
    }
    
    isLoading = YES;
    if (page == 1 && self.datas.count <= 0) {
        [self showLoading];
    }
    ESWeakSelf;
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        ESStrongSelf;
        isLoading = NO;
        [_self endLoading];
        if (URL_REQUEST_SUCCESS == [[responseDic objectForKey:@"stat"] integerValue])
        {
            NSArray* data = [responseDic objectForKey:@"list"];
            
            if(page == 1)
            {
                //刷新，如果是加载更多不用删除旧数据
                [_self.datas removeAllObjects];
            }
            
            if (page == 1 && (!data || (data && data.count <= 0))) {
                [_self reloadData];
            } else {
                if (data && data.count > 0)
                {
                    [_self.datas addObjectsFromArray:data];
                    NSLog(@"after _datas = %@",_self.datas);
                    [_self reloadData];
                } else {
                    currPage--;
                }
            }
        }
        else
        {
            if (page == 1) {
                [_self.datas removeAllObjects];
                [_self reloadData];
            } else {
                currPage--;
                [LCNoticeAlertView showMsg:responseDic[@"msg"]];
            }
        }
        
        [_self.footer endRefreshing];
        
        isLoading = NO;
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        ESStrongSelf;
        if (page == 1) {
            [_self.datas removeAllObjects];
            [_self reloadData];
        } else {
            currPage--;
            [LCNoticeAlertView showMsg:@"获取数据失败！"];
        }
        
        [_self endLoading];
        
        [_self.footer endRefreshing];
        isLoading = NO;
    };
    
    NSDictionary *parameter =  @{@"liveuid":[LCMyUser mine].liveUserId,@"packetid":_packetId,@"page":[NSNumber numberWithInt:page]};
    
    NSLog(@"paramter :%@",parameter);
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameter
                                                  withPath:URL_SHOW_RED_PACKET_DETAIL
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}


- (void) showLoading
{
    if (_activityIndicator) {
        _activityIndicator.hidden = NO;
        [_activityIndicator startAnimating];
    }
}

- (void) endLoading
{
    if (_activityIndicator) {
        _activityIndicator.hidden = YES;
        [_activityIndicator stopAnimating];
    }
}

- (void)clearData
{
    if (_datas.count > 0) {
        [_datas removeAllObjects];
        [self reloadData];
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSIndexPath *path =  [self indexPathForRowAtPoint:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y)];
    
    if (path.row < 10) {
        self.bounces = NO;
    } else {
        self.bounces = YES;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
    headView.backgroundColor = UIColorWithRGB(247, 247, 247);
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.textColor = [UIColor blackColor];
    topLabel.font = [UIFont systemFontOfSize:15.f];
    topLabel.text = @"TOP50";
    [headView addSubview:topLabel];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_datas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"_data = %@, indexpath = %@", _datas, indexPath)
    static NSString *identifier=@"rob_red_packet_identifier";
    
    RobRedPacketUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[RobRedPacketUserCell alloc]  initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:identifier];
        
        // 取消选择模式
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.userInfoDict = self.datas[indexPath.row];
    if (indexPath.row == (self.datas.count-1)) {
        cell.lineView.hidden = YES;
    } else {
        cell.lineView.hidden = NO;
    }
    
    if (indexPath.row == 0) {
        cell.luckKingImg.hidden = NO;
    } else {
        cell.luckKingImg.hidden = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

@end
