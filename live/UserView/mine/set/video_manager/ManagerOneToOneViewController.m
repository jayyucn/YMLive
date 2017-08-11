//
//  ManagerOneToOneViewController.m
//  qianchuo
//
//  Created by jacklong on 16/10/25.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ManagerOneToOneViewController.h"
#import "SetOneToOneMoneyViewController.h"
#import "AgreeOTOCell.h"
#import "ShowWebViewController.h"

@interface ManagerOneToOneViewController()
{
    
}

@property (nonatomic,strong)NSArray *titleArray;
@end

@implementation ManagerOneToOneViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.title = @"视频聊天管理";
    
    self.titleArray=@[@"接收在线视频聊天",@"视频认证"];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.scrollEnabled=NO;
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.titleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        static NSString *identifier=@"AgreeOTOCell";
        AgreeOTOCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            
            cell=[[AgreeOTOCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:identifier];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            cell.accessoryView.backgroundColor=[UIColor redColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.titleLabel.text=self.titleArray[indexPath.row];
        ESWeakSelf;
        cell.agreeCellBlock = ^(BOOL isAgree){
            ESStrongSelf;
            if (isAgree) {
               [_self showSetDiamondVC];
            }
        };
        return cell;
    }
    else
    {
        static NSString *identifier=@"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:identifier];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            cell.accessoryView.backgroundColor=[UIColor redColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text=self.titleArray[indexPath.row];
        
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
        {
            if (0 == indexPath.row) {
               
            }

            else if (1 == indexPath.row) {
                ShowWebViewController *showWebVC = [[ShowWebViewController alloc] init];
                showWebVC.hidesBottomBarWhenPushed = YES;
                showWebVC.isShowRightBtn = false;
                showWebVC.webTitleStr = ESLocalizedString(@"视频认证");
                showWebVC.webUrlStr = [NSString stringWithFormat:@"%@other/certify",URL_HEAD];
                [self.navigationController pushViewController:showWebVC animated:YES];
            }
        }
            break; 
        default:
            break;
    }
}

- (void) showSetDiamondVC
{
    SetOneToOneMoneyViewController *oneToOneVC = [[SetOneToOneMoneyViewController alloc] init];
    [self.navigationController pushViewController:oneToOneVC animated:YES];
}

@end
