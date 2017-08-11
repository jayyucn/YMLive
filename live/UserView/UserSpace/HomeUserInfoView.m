//
//  HomeUserInfoView.m
//  qianchuo
//
//  Created by jacklong on 16/8/10.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "HomeUserInfoView.h"
#import "TopRankCell.h"
#import "UserInfoItemView.h"
#import "EMMallSectionView.h"

@implementation HomeUserInfoView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return [EMMallSectionView getSectionHeight];
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return  1;
    }
    return [self.datas count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *identifier=@"tops_cell";
        
        TopRankCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell)
        {
            cell = [[TopRankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            // 取消选择模式
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        
        if (_topsDict) {
           cell.topsDict = _topsDict;
        }
        
        
        return cell;
    }
    
    static NSString *identifier=@"user_info_cell";
    
    UserInfoItemView *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[UserInfoItemView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        // 取消选择模式
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.userInfoDict = self.datas[indexPath.row];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (_showRankBlock) {
            _showRankBlock();
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}



@end
