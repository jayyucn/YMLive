//
//  LCMineViewController.m
//  XCLive
//
//  Created by ztkztk on 14-4-14.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCMineViewController.h"
#import "LCMineHeaderCell.h"
#import "LCUserInfoViewController.h"
#import "LCMyPhotoLibraryViewController.h"
#import "LCMyAttentViewController.h"
#import "LCSetViewController.h"
#import "LCMyFootprintsViewController.h"
#import "LCBlackListController.h"
#import "FeedbackViewController.h"
//#import "LCVIPIntroViewController.h"
//#import "LCCreditViewController.h"
//#import "MyPurseViewController.h"
//#import "MyVideoViewController.h"
//#import "MallViewController.h"

@interface LCMineViewController ()

@end

@implementation LCMineViewController

-(id)initWithStyle:(UITableViewStyle)style hasRefreshControl:(BOOL)hasRefreshControl
{
    self = [super initWithStyle:style hasRefreshControl:hasRefreshControl];
    if (self) {
         self.hidesBottomBarWhenPushed = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"我的";
    
    // Do any additional setup after loading the view.
    //image/mine/mineIcon/
    
    
    
    if([LCCore globalCore].isAppStoreReviewing)
    {
        NSArray *array=@[@[@{@"title":@"我的视频",@"icon":@"icon_video_x.png"},
                           @{@"title":@"我的相册",@"icon":@"MoreMyAlbum"},
                           @{@"title":@"我关注的",@"icon":@"MoreMyFavorites"},
                           @{@"title":@"我的足迹",@"icon":@"foot"},
                           @{@"title":@"黑名单",@"icon":@"blacklist"}],
                         
                         @[
                           @{@"title":@"VIP特权",@"icon":@"vip"},
                           @{@"title":@"诚信度",@"icon":@"faith"}],
                         
                         @[@{@"title":@"意见反馈",@"icon":@"yijian"},
                           @{@"title":@"设置",@"icon":@"set"}],
                         ];
        self.list=[NSMutableArray arrayWithArray:array];

    }
    else
    {
        NSArray *array=@[@[
  @{@"title":@"我的视频",@"icon":@"icon_video_x.png"},@{@"title":@"我的相册",@"icon":@"MoreMyAlbum"},
                           @{@"title":@"我关注的",@"icon":@"MoreMyFavorites"},
                           @{@"title":@"我的足迹",@"icon":@"foot"},
                           @{@"title":@"黑名单",@"icon":@"blacklist"}],
                         
                         @[@{@"title":@"我的钱包",@"icon":@"mypurse_x"},
                           @{@"title":@"商城",@"icon":@"shop_icon"},
                           @{@"title":@"VIP特权",@"icon":@"vip"},
                           @{@"title":@"诚信度",@"icon":@"faith"}],
                         
                         @[@{@"title":@"意见反馈",@"icon":@"yijian"},
                           @{@"title":@"设置",@"icon":@"set"}],
                         ];
        self.list=[NSMutableArray arrayWithArray:array];
    }
    
    self.tableView.height -= TABBAR_HEIGHT + 30;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    //NSLog(@"%@",self.list);
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reLand)
                                                 name:NotificationMsg_Land_Sucess
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reLand)
                                                 name:NotificationMsg_PopRootView
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selecteTab)
                                                 name:NotificationMsg_TabbarSelect
                                               object:nil];


}

- (void)selecteTab
{
    self.tabBarController.selectedIndex = 2;
}

-(void)reLand
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.list count]+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        if (0 == section)
        {
            return 1;
        }
        else if (section <= self.list.count)
        {
            return [(NSArray *)self.list[section-1] count];
        }
        return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        static NSString *identifier=@"headerCell";
        LCMineHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell=[[LCMineHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:identifier];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            // 取消选择模式
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell showDataOfCell];
        }
        return cell;
    }else{
        static NSString *identifier=@"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:identifier];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            // 取消选择模式
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor=[UIColor grayColor];
            cell.detailTextLabel.textColor=[UIColor blackColor];
            
        }
#if 0 //-Elf
        if(indexPath.section==1)
        {
            NSDictionary *dic=self.list[0][indexPath.row];
            cell.textLabel.text=dic[@"title"];
            //cell.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"image/mine/mineIcon/%@",dic[@"icon"]]];
                cell.imageView.image = UIImageFromCache(@"image/mine/mineIcon/%@", dic[@"icon"]);
        }else{
            
            NSDictionary *dic=self.list[1][indexPath.row];
            cell.textLabel.text=dic[@"title"];
            //cell.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"image/mine/mineIcon/%@",dic[@"icon"]]];
                cell.imageView.image = UIImageFromCache(@"image/mine/mineIcon/%@", dic[@"icon"]);
        }
        
        //[self loadCellData:cell withIndexPath:indexPath];
#else
            NSDictionary *dict = self.list[indexPath.section - 1][indexPath.row];
            cell.textLabel.text = dict[@"title"];
            cell.imageView.image = UIImageFromCache(dict[@"icon"]);
#endif
        return cell;
    }
}
-(void)loadCellData:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        LCUserInfoViewController *usrInfoViewController=[[LCUserInfoViewController alloc] initWithStyle:UITableViewStyleGrouped hasRefreshControl:NO];
        
        [self.navigationController pushViewController:usrInfoViewController animated:YES];
    }
    else if(indexPath.section==1)
    {
        switch (indexPath.row)
        {
            case 0:
            {
//                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Gift" bundle:nil];
//                MyVideoViewController *myVideo = [storyboard instantiateViewControllerWithIdentifier:@"MyVideoViewController"];
//                myVideo.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:myVideo animated:YES];
            }
                break;
            case 1:
            {
                LCMyPhotoLibraryViewController *photoLibraryController=[[LCMyPhotoLibraryViewController alloc] initWithStyle:UITableViewStylePlain hasRefreshControl:YES];
                [self.navigationController pushViewController:photoLibraryController animated:YES];
            }
                break;
            case 2:
            {
                LCMyAttentViewController *attentController=[[LCMyAttentViewController alloc] initWithStyle:UITableViewStylePlain hasRefreshControl:YES];
                [self.navigationController pushViewController:attentController animated:YES];
            }
                break;
            case 3:
            {
                LCMyFootprintsViewController *footprintsController=[[LCMyFootprintsViewController alloc] initWithStyle:UITableViewStylePlain hasRefreshControl:YES];
                [self.navigationController pushViewController:footprintsController animated:YES];
            }
                break;

            case 4:
            {
                LCBlackListController *blackListController=[[LCBlackListController alloc] initWithStyle:UITableViewStylePlain hasRefreshControl:NO];
                [self.navigationController pushViewController:blackListController animated:YES];
            }
                break;
            default:
                break;
        }
    } else if (indexPath.section == 2)
    {
        if ([LCCore globalCore].isAppStoreReviewing)
        {
            if (0 == indexPath.row)
            {
//                [self.navigationController pushViewController:[[LCVIPIntroViewController alloc] init] animated:YES];
            }
            else if (1 == indexPath.row)
            {
//                [self.navigationController pushViewController:[[LCCreditViewController alloc] init] animated:YES];
            }
        }
        else
        {
            if (0 == indexPath.row)
            {
//                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Gift" bundle:nil];
//                MyPurseViewController *myPurse = [storyBoard instantiateViewControllerWithIdentifier:@"MyPurseViewController"];
//                myPurse.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:myPurse animated:YES];
            }
            else if (1 == indexPath.row)
            {
//                //商城
//               MallViewController *mallVC = [[[NSBundle mainBundle]loadNibNamed:@"MallViewController" owner:self options:nil] lastObject];
//               // MallViewController *mallVC = [[MallViewController alloc] init];
//                mallVC.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:mallVC animated:YES];
            }
            else if (2 == indexPath.row)
            {
//                [self.navigationController pushViewController:[[LCVIPIntroViewController alloc] init] animated:YES];
            }
            else if (3 == indexPath.row)
            {
//                [self.navigationController pushViewController:[[LCCreditViewController alloc] init] animated:YES];
            }

        }
    }
    else if (indexPath.section == 3)
    {
        if (0 == indexPath.row)
        {
            FeedbackViewController *feebBackViewController=[[FeedbackViewController alloc] init];
            [self.navigationController pushViewController:feebBackViewController animated:YES];
        }
        else if (1 == indexPath.row)
        {
            LCSetViewController *setController=[[LCSetViewController alloc] initWithStyle:UITableViewStyleGrouped hasRefreshControl:NO];
            [self.navigationController pushViewController:setController animated:YES];
        }
    }
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
        return 98.0;
    else
        return 43.0;
    
}
@end
