//
//  LCNewsSetViewController.m
//  XCLive
//
//  Created by ztkztk on 14-4-26.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCNewsSetViewController.h"
#import "LCNewsSetViewController+NetWork.h"
#import "LCSwitchCell.h"

@interface LCNewsSetViewController ()
@property (nonatomic,strong)NSArray *titleArray;
@end

@implementation LCNewsSetViewController

@synthesize titleArray;


-(void)dealloc
{
//    [[LCHTTPClient sharedHTTPClient] cancelAllHTTPOperationsWithMethod:nil path:pushsetURL()];
    
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
    self.title=ESLocalizedString(@"新消息通知");
    
    
    titleArray=@[@[ESLocalizedString(@"接受新消息通知")],@[ESLocalizedString(@"通知显示消息详情")]];
//    @[@"声音",@"振动"]
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.scrollEnabled=YES;
}

#pragma mark - Table view data source



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 70;
            break;
        case 1:
            return 50;
            break;
        case 2:
            return 50;
            break;
            
        default:
            break;
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

    if(section==0)
    {
        
        LCInsetsLabel *sectionFooterLabel=[[LCInsetsLabel alloc] initWithFrame:CGRectMake(0,0,320,60) andInsets:UIEdgeInsetsMake(3,12,0,12)];
        
        sectionFooterLabel.textAlignment = NSTextAlignmentLeft;
        sectionFooterLabel.textColor=[UIColor grayColor];
        sectionFooterLabel.font=[UIFont systemFontOfSize:16];
        sectionFooterLabel.backgroundColor =[UIColor clearColor];
        sectionFooterLabel.numberOfLines = 0;
        
        
        NSString *labelString=ESLocalizedString(@"如果你要关闭或开启新消息通知，请在手机系统“设置”-“通知”功能中，找到应用程序“有美直播”进行修改");
        
        CGSize size = [labelString sizeWithFont:sectionFooterLabel.font
                              constrainedToSize:CGSizeMake(sectionFooterLabel.width-sectionFooterLabel.insets.left*2, CGFLOAT_MAX)
                                  lineBreakMode:NSLineBreakByWordWrapping];
        
        sectionFooterLabel.height=size.height+12;
        sectionFooterLabel.text=labelString;
        return sectionFooterLabel;
    }else if(section==1)
    {
        LCInsetsLabel *sectionFooterLabel=[[LCInsetsLabel alloc] initWithFrame:CGRectMake(0,0,320,50) andInsets:UIEdgeInsetsMake(3,12,0,12)];
        
        sectionFooterLabel.textAlignment = NSTextAlignmentLeft;
        sectionFooterLabel.textColor=[UIColor grayColor];
        sectionFooterLabel.font=[UIFont systemFontOfSize:16];
        sectionFooterLabel.backgroundColor =[UIColor clearColor];
        sectionFooterLabel.numberOfLines = 0;
        
        
        NSString *labelString=ESLocalizedString(@"若关闭，当收到消息时，通知提示将不显示发送人和内容提要。");
        
        CGSize size = [labelString sizeWithFont:sectionFooterLabel.font
                              constrainedToSize:CGSizeMake(sectionFooterLabel.width-sectionFooterLabel.insets.left*2, CGFLOAT_MAX)
                                  lineBreakMode:NSLineBreakByWordWrapping];
        
        sectionFooterLabel.height=size.height+12;
        sectionFooterLabel.text=labelString;
        return sectionFooterLabel;

    }else if(section==2)
    {
        LCInsetsLabel *sectionFooterLabel=[[LCInsetsLabel alloc] initWithFrame:CGRectMake(0,0,320,60) andInsets:UIEdgeInsetsMake(3,12,0,12)];
        
        sectionFooterLabel.textAlignment = NSTextAlignmentLeft;
        sectionFooterLabel.textColor=[UIColor grayColor];
        sectionFooterLabel.font=[UIFont systemFontOfSize:16];
        sectionFooterLabel.backgroundColor =[UIColor clearColor];
        sectionFooterLabel.numberOfLines = 0;
        
        
        NSString *labelString=ESLocalizedString(@"当有美直播在运行时，你可以设置是否需要声音或振动。");
        
        CGSize size = [labelString sizeWithFont:sectionFooterLabel.font
                              constrainedToSize:CGSizeMake(sectionFooterLabel.width-sectionFooterLabel.insets.left*2, CGFLOAT_MAX)
                                  lineBreakMode:NSLineBreakByWordWrapping];
        
        sectionFooterLabel.height=size.height+12;
        sectionFooterLabel.text=labelString;
        return sectionFooterLabel;
        
    }

#pragma clang diagnostic pop
    return nil;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [titleArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titleArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(indexPath.section==0)
    {
        static NSString *identifier=@"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                        reuseIdentifier:identifier];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            // 取消选择模式
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor=[UIColor blackColor];
            cell.detailTextLabel.textColor=[UIColor grayColor];
            
        }
        cell.textLabel.text = titleArray[indexPath.section][indexPath.row];
        
        
        BOOL remoteNOtifi;
        
#if 0 //-Elf, use LCCore to detect
#ifdef __IPHONE_8_0
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            if([[UIApplication sharedApplication] isRegisteredForRemoteNotifications])
            {
                remoteNOtifi=YES;
            }else{
                remoteNOtifi=NO;
            }
        }else{
            
            
#endif
            if([[UIApplication sharedApplication] enabledRemoteNotificationTypes]==UIRemoteNotificationTypeNone)
            {
                remoteNOtifi=NO;
            }else{
                remoteNOtifi=YES;
            }
#ifdef __IPHONE_8_0
        }
        
#endif
            
#else // -Elf
            remoteNOtifi = [LCCore globalCore].isPushNotificationEnabled;
#endif
        
        if(remoteNOtifi)
        {
            cell.detailTextLabel.text= ESLocalizedString(@"已开启");
        }else{
            cell.detailTextLabel.text=ESLocalizedString(@"未开启");
        }
 
        return cell;
    }
    else
    {
        static NSString *identifier=@"cell";
        LCSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            
            cell=[[LCSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:identifier];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            cell.accessoryView.backgroundColor=[UIColor redColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.titleLabel.text=titleArray[indexPath.section][indexPath.row];
        
        
        if(indexPath.section==1)
        {
            
            cell.switchView.on=![[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKey_NewsDetail] boolValue];
            cell.switchCellBlock=^(BOOL on){
                [[NSUserDefaults standardUserDefaults] setObject:@(!on) forKey:kUserDefaultsKey_NewsDetail];
                [LCCore globalCore].newMessageNotifyShowsDetail=on;
            };

            
        }else{
            
            if(indexPath.row==0)
            {
                cell.switchView.on=![[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKey_NewsVoice] boolValue];
                cell.switchCellBlock=^(BOOL on){
                    [[NSUserDefaults standardUserDefaults] setObject:@(!on) forKey:kUserDefaultsKey_NewsVoice];
                    [LCCore globalCore].newMessageNotifyPlaySound=on;
                };
                
            }else{
                cell.switchView.on=![[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKey_NewsVibration] boolValue];
                cell.switchCellBlock=^(BOOL on){
                    [[NSUserDefaults standardUserDefaults] setObject:@(!on) forKey:kUserDefaultsKey_NewsVibration];
                    [LCCore globalCore].newMessageNotifyPlayVibrate=on;
                };
                
            }
        }
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
