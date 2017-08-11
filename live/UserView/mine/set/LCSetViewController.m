//
//  LCSetViewController.m
//  XCLive
//
//  Created by ztkztk on 14-4-21.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCSetViewController.h"
#import "LCSetViewController+NetWork.h"


#import "LCSecretViewController.h"
#import "LCNewsSetViewController.h"
#import "LCBlackListController.h"
#import "FeedbackViewController.h"

#import "LCAboutViewController.h"
#import "ManagerOneToOneViewController.h"


@interface LCSetViewController ()
@property (nonatomic,strong)NSArray *titleArray;
@property (nonatomic,strong)ESButton *enterBtn;

@end

@implementation LCSetViewController
@synthesize titleArray;


-(void)dealloc
{
//    [[LCHTTPClient sharedHTTPClient] cancelAllHTTPOperationsWithMethod:nil path:setURL()];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


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
    self.title=ESLocalizedString(@"设置");
    
    
    titleArray=@[ 
                @[@"视频聊天管理",ESLocalizedString(@"黑名单"),ESLocalizedString(@"新消息通知"), ESLocalizedString(@"用户反馈"), ESLocalizedString(@"关于有美直播")],
                @[ESLocalizedString(@"退出登录")]];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.scrollEnabled=NO;
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self.tableView reloadData];
}

-(void)emailAuthSuccess
{
//    [self.tableView reloadData];
}

-(void)exitAction
{
    
    
    ESWeakSelf;
    UIAlertView *alert = [UIAlertView alertViewWithTitle:ESLocalizedString(@"退出登录")
                                                 message:@"退出后不会删除任何历史数据，下次登录依然可以使用本账号"
                                       cancelButtonTitle:ESLocalizedString(@"取消")
                                         didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                             ESStrongSelf;
                                             if (buttonIndex != alertView.cancelButtonIndex) {
                                                 [_self exitCurrentAccount];
                                             }
                                         } otherButtonTitles:ESLocalizedString(@"确定"), nil];
    [alert show];

    
   // [self exitCurrentAccount];
}


#pragma mark - Table view data source


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
        
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:identifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.accessoryView.backgroundColor=[UIColor redColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor colorWithRed:68.0/255.0 green:68/255.0 blue:68/255.0 alpha:1.0];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        
    }
    cell.textLabel.text=titleArray[indexPath.section][indexPath.row];
    return cell;
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
                ManagerOneToOneViewController *managerVC=[[ManagerOneToOneViewController alloc] initWithStyle:UITableViewStyleGrouped hasRefreshControl:NO];
                [self.navigationController pushViewController:managerVC animated:YES];
            }
            else if(1 == indexPath.row)
            {
                LCBlackListController *securityController=[[LCBlackListController alloc] initWithStyle:UITableViewStyleGrouped hasRefreshControl:NO];
                [self.navigationController pushViewController:securityController animated:YES];
            } else if (2 == indexPath.row) {
                LCNewsSetViewController *newsSetController=[[LCNewsSetViewController alloc] initWithStyle:UITableViewStyleGrouped hasRefreshControl:NO];
                [self.navigationController pushViewController:newsSetController animated:YES];
            } else if (3 == indexPath.row ) {
                // FeedbackViewController *secretController=[[FeedbackViewController alloc] init];
                // [self.navigationController pushViewController:secretController animated:YES];
                
                UIStoryboard *feedbackStroyBoard = [UIStoryboard storyboardWithName:@"Feedback" bundle:nil];
                UIViewController *feedbackView = [feedbackStroyBoard instantiateViewControllerWithIdentifier:@"feedback"];
                
                UINavigationController *feedbackNavigator = [[UINavigationController alloc] initWithRootViewController:feedbackView];
                [self presentViewController:feedbackNavigator animated:YES completion:nil];
            } else if (4 == indexPath.row) {
                LCAboutViewController *aboutController=[[LCAboutViewController alloc] initWithStyle:UITableViewStyleGrouped
                                                                                  hasRefreshControl:NO];
                [self.navigationController pushViewController:aboutController animated:YES];
            }
        }
            break;
        case 1:
        {
            [self exitAction];
        }
            break;
        default:
            break;
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
