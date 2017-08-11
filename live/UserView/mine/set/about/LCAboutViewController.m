//
//  LCAboutViewController.m
//  XCLive
//
//  Created by ztkztk on 14-4-26.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCAboutViewController.h"
#import "CLIconView.h"
#import "FeedbackViewController.h"
#import "LCIntroductionController.h"
#import "ShowWebViewController.h"
//#import "LCWebViewController.h"

@interface LCAboutViewController ()
@property (nonatomic,strong)NSArray *titleArray;
@end

@implementation LCAboutViewController

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
    self.title=ESLocalizedString(@"关于有美直播");
    
    //titleArray=@[@[@"去评分",@"功能介绍",/*@"帮助与反馈"*/@"服务条款"],@[@"版本更新"]];
        if ([LCCore globalCore].isAppStoreReviewing) {
                titleArray=@[@[ESLocalizedString(@"社会公约"),/*@"帮助与反馈"*/ESLocalizedString(@"服务条款")]];
        } else {
                titleArray=@[@[ESLocalizedString(@"去评分"),ESLocalizedString(@"社会公约"),/*@"帮助与反馈"*/ESLocalizedString(@"服务条款")]];
        }
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.scrollEnabled=NO;
    
    
    _iconView=[[CLIconView alloc] init];
    self.tableView.tableHeaderView=_iconView;

}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
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
        
        UITableViewCellStyle style;
        if(indexPath.section==0)
            style=UITableViewCellStyleDefault;
        else
            style=UITableViewCellStyleValue1;
            
        cell=[[UITableViewCell alloc] initWithStyle:style
                                    reuseIdentifier:identifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.accessoryView.backgroundColor=[UIColor redColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.textColor=[UIColor grayColor];
    }

    cell.textLabel.text=titleArray[indexPath.section][indexPath.row];

    if(indexPath.section!=0)
    {
        
        
        if(!_versionMark)
        {
            _versionMark=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image/mine/new"]];
            [cell addSubview:_versionMark];
            
            _versionMark.top=10;
            
        }
        
        /*
        CGSize nameSize=[cell.textLabel.text sizeWithFont:cell.textLabel.font
                                        constrainedToSize:CGSizeMake(MAXFLOAT, 15)];
         */
        
        _versionMark.left=16+70+2;
        
        if(!_versionLabel)
        {
            _versionLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0,160, 22)];
            _versionLabel.textAlignment = NSTextAlignmentRight;
            _versionLabel.textColor=[UIColor grayColor];
            _versionLabel.font=[UIFont systemFontOfSize:13];
            _versionLabel.backgroundColor =[UIColor clearColor];
            [cell addSubview:_versionLabel];
            _versionLabel.centerY=50.0f/2;
            _versionLabel.right=320-35;
            
            
        }
        
        [self reloadUpdateCell];

    }
    
    
    
    
	return cell;
}

-(void)reloadUpdateCell
{
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"infoDictionary==%@",infoDictionary);
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    NSDictionary *updateDic=[[NSUserDefaults standardUserDefaults] objectForKey:@"updateVersion"];
    if([updateDic[@"update"] boolValue])
        _versionMark.hidden=NO;
    else
        _versionMark.hidden=YES;
    
    _versionLabel.text=[NSString stringWithFormat:@"%@:%@", ESLocalizedString(@"当前版本"), app_Version];
    
    _iconView.versionLabel.text=[NSString stringWithFormat:@"%@%@",ESLocalizedString(@"有美直播"), app_Version];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
#if 1 //-Elf: AppStore审核时没有"去评分"
            NSUInteger selectedIndex = indexPath.row;
            if ([LCCore globalCore].isAppStoreReviewing) {
                    selectedIndex++;
            }
#endif
        switch (selectedIndex) {
            case 0:
            {
#if 1 //-Elf
                [[UIApplication sharedApplication] openURL:[ESStoreHelper appStoreReviewLinkForAppID:kAppStoreID storeCountryCode:ESAppStoreCountryCodeChina]];
#else
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppURL]];
#endif
                
            }
                break;
            case 1:
            {
                ShowWebViewController *showWebVC = [[ShowWebViewController alloc] init];
                showWebVC.hidesBottomBarWhenPushed = YES;
                showWebVC.isShowRightBtn = false;
                showWebVC.webTitleStr = ESLocalizedString(@"社区公约");
                showWebVC.webUrlStr = [NSString stringWithFormat:@"%@other/treaty",URL_HEAD];
                [self.navigationController pushViewController:showWebVC animated:YES];
            }
                break;
#if 0 // -Elf
                case 2:
                {
                        FeedbackViewController *feebBackViewController=[[FeedbackViewController alloc] init];
                        [self.navigationController pushViewController:feebBackViewController animated:YES];
                        break;
                }
#endif
                case 2:
                {
//                        LCWebViewController *web = [[LCWebViewController alloc] initWithURL:NSURLWith(@"%@/other/policy", kWebServerBaseURL)];
//                        web.showsToolbar = NO;
//                        [self.navigationController pushViewController:web animated:YES];
                    
                    ShowWebViewController   *showWebVC = [[ShowWebViewController alloc] init];
                    showWebVC.hidesBottomBarWhenPushed = YES;
                    showWebVC.isShowRightBtn = false;
                    showWebVC.webTitleStr = ESLocalizedString(@"服务条款");
                    showWebVC.webUrlStr = [NSString stringWithFormat:@"%@other/eula",URL_HEAD];
                    [self.navigationController pushViewController:showWebVC animated:YES];
                    
                        break;
                }
                
            default:
                break;
        }

    }
    
    /*else{
        if(!_versionMark.hidden)
        {
            // NSString *str = [NSString stringWithFormat:KFAppURL];
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            
            NSDictionary *updateDic=[[NSUserDefaults standardUserDefaults] objectForKey:@"updateVersion"];
            
            NSString *newVersionPath = [[NSString alloc]initWithString:[updateDic objectForKey:@"path"]];
            NSURL *url = [NSURL URLWithString:newVersionPath];
            [[UIApplication sharedApplication]openURL:url];
        }else
        {
            
            
            ESWeakSelf;
            [LCCore checkUMengUpdate:^(BOOL NewVesion){
                ESStrongSelf;
            if(NewVesion)
            {
                [_self reloadUpdateCell];
            }else{
                [LCNoticeAlertView showMsg:@"当前已是最新版本"];
            }
            
            }];
        }

    }*/
    
}


@end
