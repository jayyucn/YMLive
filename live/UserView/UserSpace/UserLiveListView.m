//
//  UserLiveListView.m
//  qianchuo
//
//  Created by jacklong on 16/8/10.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "UserLiveListView.h"
#import "PlayBackCell.h"

@interface UserLiveListView(){
    int currPage;
}
@end

@implementation UserLiveListView

- (void) refreshData
{
    [self getPlayBackList:1];
}

- (void) loadData
{
    int tempPage = currPage+1;
    [self getPlayBackList:tempPage];
}

#pragma mark - Subclass
-(void)getPlayBackList:(int)page
{
    if (_isLoading)
    {
        return;
    }
    _isLoading = YES;
    
    if (page == 1) {
        currPage = 1;
    }
    
    ESWeakSelf;
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        ESStrongSelf;
        _self->_isLoading = NO;
        if (200 == [responseDic[@"stat"] intValue]) {
            _self->currPage = page;
            NSArray *array = responseDic[@"list"];
            if (array && array.count > 0) {
                _self.noPlayBackView.hidden = YES;
                [_self.datas addObjectsFromArray:array];
                [_self reloadData];
            } else {
                _self.noPlayBackView.hidden = NO;
//                _self.noDataNotice.text = @"你还没有直播过哦";
//                _self.noDataNotice.hidden = NO;
            }
        } else {
            NSLog(@"get play back %@",responseDic[@"msg"]);
        }
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        NSLog(@"get play back error =%@",error);
        ESStrongSelf;
        _self->_isLoading = NO;
    };
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"uid":_userId,@"page":@(page)}
                                                  withPath:URL_CALLBACK_LIVE_LIST
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.datas count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *identifier=@"tops_cell";
        
        PlayBackCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell)
        {
            cell = [[PlayBackCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            // 取消选择模式
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }

        return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
       
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


@end
