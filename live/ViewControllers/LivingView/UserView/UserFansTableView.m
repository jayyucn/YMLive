//
//  UserFansTableView.m
//  qianchuo
//
//  Created by jacklong on 16/3/21.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "UserFansTableView.h"
#import "LiveUserInfoCell.h"

@implementation UserFansTableView

// 设置用户信息
- (void)setUserInfoDict:(NSDictionary *)userInfoDict
{
    if (self.datas.count > 0 && _userInfoDict && ![userInfoDict[@"uid"] isEqualToString:_userInfoDict[@"uid"]]) {
        _userInfoDict = userInfoDict;
        self.currPage = 1;
        // 清空之前数据
        if (self.datas) {
            [self.datas removeAllObjects];
        }
    } else {
        _userInfoDict = userInfoDict;
    }
}

- (void)refreshData
{
    if (self.isLoading)
    {
        return;
    }
    self.currPage = 1;
    [self requestFansData:1];
}

- (void)loadData
{
    [self requestFansData:self.currPage++];
}

- (void)requestFansData:(int)page
{
    if (self.isLoading)
    { 
        return;
    }
    self.isLoading = YES;
    if (page == 1 && self.datas.count <= 0) {
        [self showLoading];
    }
    ESWeakSelf;
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        ESStrongSelf;
        _self.isLoading = NO;
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
                _self.noDataLabel.text = responseDic[@"msg"];
                _self.noDataView.hidden = NO;
                [_self reloadData];
            } else {
                if (data && data.count > 0)
                {
                    _self.noDataView.hidden = YES;
                    [_self.datas addObjectsFromArray:data];
                    NSLog(@"after _datas = %@",_self.datas);
                    [_self reloadData];
                } else {
                     _self.currPage--;
                }
            }
        }
        else
        {
            if (page == 1) {
                _self.noDataLabel.text = responseDic[@"msg"];
                _self.noDataView.hidden = NO;
                [_self.datas removeAllObjects];
                [_self reloadData];
            } else {
                _self.currPage--;
                [LCNoticeAlertView showMsg:responseDic[@"msg"]];
            }
        }
        
        [_self.header endRefreshing];
        [_self.footer endRefreshing];
        
        _self.isLoading = NO;
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        ESStrongSelf;
        if (page == 1) {
            _self.noDataLabel.text = @"获取数据失败！";
            _self.noDataView.hidden = NO;
            [_self.datas removeAllObjects];
            [_self reloadData];
        } else {
            _self.currPage--;
            [LCNoticeAlertView showMsg:@"获取数据失败！"];
        }
        
        [_self endLoading];
        
        [_self.header endRefreshing];
        [_self.footer endRefreshing];
        _self.isLoading = NO;
    };
    
    if (_userInfoDict[@"uid"]) {
        [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"liveuid":_userInfoDict[@"uid"],@"page":[NSNumber numberWithInt:page]}
                                                      withPath:URL_FANS_LIST
                                                   withRESTful:GET_REQUEST
                                              withSuccessBlock:successBlock
                                                 withFailBlock:failBlock];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"_data = %@, indexpath = %@", _datas, indexPath)
    static NSString *identifier=@"LiveFansCell";
    
    LiveUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[LiveUserInfoCell alloc]  initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:identifier];
        
        // 取消选择模式
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.cellType =  CELL_FANS_TYPE;
    cell.userInfoDict = self.datas[indexPath.row];
    if (indexPath.row == (self.datas.count-1)) {
        cell.lineView.hidden = YES;
    } else {
        cell.lineView.hidden = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_showUserDetailBlock) {
        _showUserDetailBlock(self.datas[indexPath.row]);
    }
}

- (void) showLoading
{
    if (_activityIndicator) {
        _noDataView.hidden = YES;
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

@end
