//
//  LCMyPhotoLibraryViewController.m
//  XCLive
//
//  Created by ztkztk on 14-4-21.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCMyPhotoLibraryViewController.h"
#import "LCPhotoLibraryCell.h"
#import "LCPhotoScrollViewController.h"



//#import "LCPhotoScrollController.h"

@interface LCMyPhotoLibraryViewController ()

@end

@implementation LCMyPhotoLibraryViewController


-(void)dealloc
{
//    [[LCHTTPClient sharedHTTPClient] cancelAllHTTPOperationsWithMethod:nil path:photoListURL()];
//    [[LCHTTPClient sharedHTTPClient] cancelAllHTTPOperationsWithMethod:nil path:deletePhotoURL()];
//    
//        
//    [[LCHTTPClient sharedHTTPClient] cancelUpdatePhoto:updatePhotoURL()];
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
    self.title=@"我的相册";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTableView)
                                                 name:NotificationMsg_DeletePhoto_Success
                                               object:nil];

    if ([UIDevice currentNetworkReachabilityStatus] == ESNetworkReachabilityStatusNotReachable)
    {
        NSArray *photos=[LCLocalCache readPhotoLibrary];
        if(photos&&[photos isKindOfClass:[NSArray class]])
        {
            [self.list addObjectsFromArray:photos];
        }
    }else{
        [self refreshData];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ESNetworkReachabilityDidChangeNotificationHandler:) name:ESNetworkReachabilityDidChangeNotification object:nil];
}

- (void)ESNetworkReachabilityDidChangeNotificationHandler:(id)sender
{
    if ([UIDevice currentNetworkReachabilityStatus] != ESNetworkReachabilityStatusNotReachable) {
        [self refreshData];
    }
}

-(void)reloadTableView
{
    [self refreshData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Subclass
- (void)refreshData
{
    if(!self.isRefreshing)
    {
        self.hasMore=YES;
        self.isRefreshing=YES;
        currentPage=1;
        [self getPhotoListWithPage:1];

    }
    
}

- (void)loadMoreData
{
    
    NSLog(@"loadMoreData==%d",currentPage);
    [self getPhotoListWithPage:currentPage+1];
    
}



#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return ([self.list count])/PhotoNumEachRow+1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"headerCell";
    LCPhotoLibraryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[LCPhotoLibraryCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:identifier];
        // 取消选择模式
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [self loadCellData:cell withIndexPath:indexPath];
    return cell;
}

-(void)loadCellData:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    NSInteger flag = indexPath.row * PhotoNumEachRow;
    for (int i = 0; i<PhotoNumEachRow; ++i) {
        LCMyPhotoView *imageView=(LCMyPhotoView *)[cell viewWithTag:PhotoImageTag+i];
        if(flag==0)
        {
            imageView.hidden=NO;
            
            imageView.image=[UIImage imageNamed:@"image/mine/addphotoHL"];
            ESWeakSelf;
            imageView.singleTapBlock=^(NSDictionary *dic){
                ESStrongSelf;
                [_self addNewPhoto];
            };
            imageView.longPressBlock=^(NSDictionary *dic){
                ESStrongSelf;
                [_self addNewPhoto];
            };
        }else{
            
            if(flag>[self.list count])
            {
                imageView.hidden=YES;
            }else{
                imageView.hidden=NO;
                imageView.photoDic=self.list[flag-1];
                ESWeakSelf;
                imageView.singleTapBlock=^(NSDictionary *dic){
                    ESStrongSelf;
                    [_self showBigPhoto:dic];
                };
                imageView.longPressBlock=^(NSDictionary *dic){ESStrongSelf;
                    [_self confirmDelete:dic];
                };
             }
        }
        ++flag;
        
    }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return PhotoLibraryWidth+2;
}


#pragma mark custom fuction

-(void)addNewPhoto
{
//    ESWeakSelf;
//    [[LCSelectPhoto selectPhoto] showSelectItemWithController:self
//                                                    submitURL:updatePhotoURL()
//                                              withSubmitBlock:^(NSDictionary *dic){
//                                                  ESStrongSelf;
//                                                  [_self refreshData];
//                                              }];

    
}

-(void)confirmDelete:(NSDictionary *)photoDic
{
        ESWeakSelf;
        UIAlertView *alert = [UIAlertView alertViewWithTitle:@"提示："
                                                     message:@"确认删除此照片吗？"
                                           cancelButtonTitle:@"取消"
                                             didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                ESStrongSelf;
                if (alertView.cancelButtonIndex != buttonIndex) {
                        [_self deletePhoto:photoDic];
                }
        }
                                           otherButtonTitles:@"确定", nil];
        [alert show];

}


-(void)showBigPhoto:(NSDictionary *)photoDic
{
    
//    int order=0;
//    for(NSDictionary *dic in self.list)
//    {
//        if([photoDic[@"id"] isEqualToString:dic[@"id"]])
//        {
//            break;
//        }
//        order++;
//    }
//
//    NSDictionary *userDic=@{@"uid":[LCMyUser mine].userID,@"face":[LCMyUser mine].faceURL,@"nickname":[LCMyUser mine].nickname};
//    LCPhotoScrollController *photoController=[LCPhotoScrollController showPhotoController:userDic
//                                                                                withOrder:order
//                                                                                withTotal:[self.list count]];
//    [self.navigationController pushViewController:photoController animated:YES];
}



@end
