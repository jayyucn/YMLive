//
//  LCSecurityViewController.m
//  XCLive
//
//  Created by ztkztk on 14-4-26.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCSecurityViewController.h"

#import "LCInsetsLabel.h"


#import "LCConfirmPhoneViewController.h"
#import "LCConFirmEmailViewController.h"
#import "LCModifyPwdController.h"
#import "LCAuthEmailViewController.h"
#import "LCLoginAndExitRequest.h"

@interface LCSecurityViewController ()
@property (nonatomic,strong)NSArray *titleArray;
@end

@implementation LCSecurityViewController

@synthesize titleArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title=@"账号安全";
    
    
//    if (ESIsStringWithAnyText([LCSet mineSet].openID)) {
//        titleArray=@[@[@"手机号码",@"邮箱地址"],@[@"退出登录"]];
//    }else{
        titleArray=@[@[@"手机号码",@"邮箱地址"],
                     @[@"修改密码"],
                     @[@"退出登录"]];
//    }
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.scrollEnabled=NO;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(emailAuthSuccess)
                                                 name:NotificationMsg_EmailAuthSuccess
                                               object:nil];

    
}

-(void)emailAuthSuccess
{
    [self.tableView reloadData];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section==0)
    {
        LCInsetsLabel *sectionFooterLabel=[[LCInsetsLabel alloc] initWithFrame:CGRectMake(0,0,320,35) andInsets:UIEdgeInsetsMake(3,12,0,12)];
        sectionFooterLabel.textAlignment = NSTextAlignmentLeft;
        sectionFooterLabel.textColor=[UIColor grayColor];
        sectionFooterLabel.font=[UIFont systemFontOfSize:16];
        sectionFooterLabel.backgroundColor =[UIColor clearColor];
        sectionFooterLabel.text=@"邮箱用于找回密码请正确填写邮箱";
        return sectionFooterLabel;

    }else
        return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [titleArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [(NSArray *)titleArray[section] count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                    reuseIdentifier:identifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.accessoryView.backgroundColor=[UIColor redColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.textColor=[UIColor grayColor];
    }
    cell.textLabel.text=titleArray[indexPath.section][indexPath.row];
    
    if(indexPath.section==0)
    {
//        if(indexPath.row==0)
//        {
//            if([LCSet mineSet].phone_auth)
//                cell.detailTextLabel.text=[NSString stringWithFormat:@"已验证 %@",[LCSet mineSet].account];
//            else
//                cell.detailTextLabel.text=[NSString stringWithFormat:@"未验证 %@",[LCSet mineSet].account];
//        }else{
//            
//            if([LCSet mineSet].email_auth)
//                
//                cell.detailTextLabel.text=[NSString stringWithFormat:@"已验证 %@",[LCSet mineSet].email];
//            else
//            {
//                if([[LCSet mineSet].email isEqualToString:@""])
//                    cell.detailTextLabel.text=@"未绑定";
//                else
//                    cell.detailTextLabel.text=[NSString stringWithFormat:@"未验证 %@",[LCSet mineSet].email];
//            }
//            
//        }
    }
    
    cell.detailTextLabel.numberOfLines = 0;
//    if (ESIsStringWithAnyText([LCSet mineSet].openID))
//    {
//        if(indexPath.section==1)
//        {
//            [cell setAccessoryType:UITableViewCellAccessoryNone];
//        }
//        else
//        {
//         [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//         cell.detailTextLabel.width = cell.contentView.width - cell.accessoryView.width - 45.f - cell.textLabel.width;
//        }
//    }
//    else
//    {
//        if (indexPath.section == 2)
//        {
//            [cell setAccessoryType:UITableViewCellAccessoryNone];
//        }
//        else
//        {
//            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//            cell.detailTextLabel.width = cell.contentView.width - cell.accessoryView.width - 45.f - cell.textLabel.width;
//        }
//    }
    
    [cell.detailTextLabel sizeToFit];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0&&indexPath.row==1)
    {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return MAX(cell.detailTextLabel.height + 30, 50);
    }
    
    return 50.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        if(indexPath.row==0)
        {
            LCConfirmPhoneViewController *authorPhoneController=[[LCConfirmPhoneViewController alloc] init];
            [self.navigationController pushViewController:authorPhoneController animated:YES];
        }else{
            
            LCConFirmEmailViewController *authorEmailController=[[LCConFirmEmailViewController alloc] init];
            [self.navigationController pushViewController:authorEmailController animated:YES];
            
            /*
            LCAuthEmailViewController *authEmailViewController=[[LCAuthEmailViewController alloc] init];
            [self.navigationController pushViewController:authEmailViewController animated:YES];
             */
        }
    }else{
//        if (ESIsStringWithAnyText([LCSet mineSet].openID) && indexPath.section==1) {
//            [self exitAction];
//        } else if (indexPath.section == 2) {
//            [self exitAction];
//        } else {
//            LCModifyPwdController *modifyPwdController=[[LCModifyPwdController alloc] init];
//            [self.navigationController pushViewController:modifyPwdController animated:YES];
//        }
    }
}


-(void)exitAction
{
    
    
    UIAlertView *alert = [UIAlertView alertViewWithTitle:@"退出登录"
                                                 message:@"退出后不会删除任何历史数据，下次登录依然可以使用本账号"
                                       cancelButtonTitle:@"取消"
                                         didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                             if (buttonIndex != alertView.cancelButtonIndex) {
                                                 [LCLoginAndExitRequest exitLC];
                                             }
                                         } otherButtonTitles:@"确定", nil];
    [alert show];
    
    
    // [self exitCurrentAccount];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
