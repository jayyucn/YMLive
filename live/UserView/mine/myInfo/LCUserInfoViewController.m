//
//  LCUserInfoViewController.m
//  XCLive
//
//  Created by ztkztk on 14-4-21.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCUserInfoViewController.h"

#import "LCUserHeaderCell.h"
#import "LCUserDetailViewController.h"
//#import "PBJViewController.h"

#import <AVFoundation/AVFoundation.h>
//#import "MVRecorderViewController.h"

@interface LCUserInfoViewController ()

@end

@implementation LCUserInfoViewController

-(void)dealloc
{
    
//    [[LCHTTPClient sharedHTTPClient] cancelAllHTTPOperationsWithMethod:nil path:modifyInfoURL()];
//
//    [[LCHTTPClient sharedHTTPClient] cancelUpdatePhoto:modifyPhotoURL()];
    
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
    self.title=[LCMyUser mine].nickname;
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundColor=[UIColor clearColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"预览"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(previewMyself)];
    
    
    NSArray *array=@[@[@"头像",@"录制个人视频",@"签名"],
                     @[@"昵称",@"我想",@"兴趣爱好",@"优点"],
                     @[@"性别",@"生日",@"出生地",@"居住地",@"真实姓名",@"身高",@"体型"],
                     @[@"学历",@"职业",@"婚姻",@"工资"],
                     @[@"独白"]];
    self.list=[NSMutableArray arrayWithArray:array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(editUserInfoSuccess:)
                                                 name:NotificationMsg_EditInfo_Success
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(previewVideo:)
                                                 name:NotificationMsg_VideoPreview
                                               object:nil];
    
    self.tableView.height -= 25;

    
    
    
    [self getMineInfo];

    
}

-(void)previewMyself
{
    NSDictionary *userInfo = @{@"uid":[LCMyUser mine].userID,
                 @"nickname": [LCMyUser mine].nickname};
    
    LCUserDetailViewController *userVC = [LCUserDetailViewController userDetail:userInfo];
    [self.navigationController pushViewController:userVC animated:YES];

}

- (void)editUserInfoSuccess:(NSNotification *)notification
{
    [self.tableView reloadData];
}

- (void)previewVideo:(NSNotification *)notification
{
    NSDictionary *userInfo = @{@"uid":[LCMyUser mine].userID,
                               @"nickname": [LCMyUser mine].nickname};
    
    LCUserDetailViewController *userVC = [LCUserDetailViewController userDetailAutoPlayVideo:userInfo];
    [self.navigationController pushViewController:userVC animated:YES];
    
}



#pragma mark  --


-(void)getMineInfo
{
    ESWeakSelf;
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        ESStrongSelf;
        NSLog(@"gagresponseDic=%@",responseDic);
        
        int stat=[responseDic[@"stat"] intValue];
        if(stat==200)
        {
            if ([responseDic isKindOfClass:[NSDictionary class]]&&[responseDic[@"userinfo"] isKindOfClass:[NSDictionary class]])
                {
                    [[LCMyUser mine] fillWithDictionary:responseDic[@"userinfo"]];
                    [[LCMyUser mine] save];
                    [_self.tableView reloadData];
                    
                   // [LCLocalCache saveMyUser:responseDic[@"userinfo"]];
                }
        }
        else{
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
        
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        NSLog(@"gagerror=%@",error);
    };
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:nil
                                                  withPath:mineInfoURL()
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
    
}


- (void)recordVideo
{
        if ([[AVCaptureDevice class] respondsToSelector:@selector(authorizationStatusForMediaType:)])
        {
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                
                
                if(authStatus==AVAuthorizationStatusRestricted||authStatus==AVAuthorizationStatusDenied)
                {
                        //[LCNoticeAlertView showMsg:@"相机已禁用，请在系统设置里打开应用相机权限"];
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                        message:@"相机已禁用，请在系统设置里打开应用相机权限"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil,nil];
                        
                        [alert show];
                        
                        return;
                }
                
        }
        
        /*
         if(IOS_VERSION_IS_ABOVE_7)
         {
         AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
         
         
         if(authStatus==AVAuthorizationStatusRestricted||authStatus==AVAuthorizationStatusDenied)
         {
         //[LCNoticeAlertView showMsg:@"相机已禁用，请在系统设置里打开应用相机权限"];
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
         message:@"相机已禁用，请在系统设置里打开应用相机权限"
         delegate:self
         cancelButtonTitle:@"确定"
         otherButtonTitles:nil,nil];
         
         [alert show];
         
         return;
         }
         
         }
         
         */
        
//#if 0
//        PBJViewController *jControlller=[[PBJViewController alloc] init];
//        //[self.navigationController pushViewController:jControlller animated:YES];
//        BaseNavigationController *videoNav=[[BaseNavigationController alloc] initWithRootViewController:jControlller];
//        
//        [self.navigationController presentModalViewController:videoNav animated:YES];
//#else
//        /* 设置草稿保存在用户目录下 */
//        [MVRecorderSession setRootDirectory:[[LCMyUser mine].documentsDirectory appendPathComponent:@"video_recorder"]];
//        
//        /* 创建录制配置 */
//        MVConfig *config = [MVConfig defaultConfig];
//        // 最短和最长录制时间
//        config.minRecordedDuration = 5;
//        config.maxRecordedDuration = 20;
//        // 视频尺寸
//        config.videoSize = 480;
//        // 默认前置还是后置摄像头
//        config.preferredCameraPosition = AVCaptureDevicePositionFront;
//        
////        /* 打开拍摄界面 */
////        [MVRecorderViewController presentWithConfig:config finishedBlock:^(MVRecorderViewController *recorderController, MVRecorderSession *recorderSession) {
////                // NSLog(@"RecorderViewController finished with session: %@", recorderSession);
////                [recorderController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
////        }];
//#endif
}

- (void)removeVideo
{
//        ESWeakSelf;
//        [LCJSONClient get:@"/profile/videoshow" parameters:@{@"type":@(0)} success:^(NSDictionary *result) {
//                if ([result isKindOfClass:[NSDictionary class]]) {
//                        int ok = 0;
//                        if (ESIntVal(&ok, result[@"stat"]) && 200 == ok) {
////                                [LCMyUser mine].videoURL = @"";
//                                [[LCMyUser mine] save];
//                                ESStrongSelf;
//                                if (_self.isViewVisible) {
//                                        [JDMessageView showWithSuperView:_self.view title:@"个人视频已删除!" message:nil];
//                                }
//                                return;
//                        }
//                }
//                
//                ESStrongSelf;
//                if (_self.isViewVisible)
//                        [JDMessageView showWithSuperView:_self.view title:@"个人视频删除失败,请重试" message:nil];
//                
//        } failure:^(NSError *error) {
//                ESStrongSelf;
//                if (_self.isViewVisible)
//                        [JDMessageView showWithSuperView:_self.view title:@"个人视频删除失败,请重试" message:nil];
//        }];
}

#pragma mark end


#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.list count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [(NSArray *)self.list[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0&&indexPath.row==0)
    {
        static NSString *identifier=@"headerCell";
        LCUserHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell=[[LCUserHeaderCell alloc] initWithStyle:UITableViewCellStyleValue1
                                         reuseIdentifier:identifier];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            // 取消选择模式
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
        }
        
        cell.textLabel.text=self.list[0][0];
        [cell showDataOfCell];
        return cell;
    }else{
        static NSString *identifier=@"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                        reuseIdentifier:identifier];
            
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            cell.accessoryView.backgroundColor=[UIColor redColor];
            // 取消选择模式
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor=[UIColor blackColor];
            cell.detailTextLabel.textColor=[UIColor grayColor];
            
            /*
            CGSize size = [noticeString sizeWithFont:_notice.font
                                   constrainedToSize:CGSizeMake(NoticeWidth, CGFLOAT_MAX)
                                       lineBreakMode:NSLineBreakByWordWrapping];
             */
            cell.textLabel.numberOfLines = 0;
            cell.detailTextLabel.numberOfLines = 0;
            //_notice.height=size.height;
            //_notice.text=noticeString;

            
        }
        
        [self loadCellData:cell withIndexPath:indexPath];
        [cell.textLabel sizeToFit];
        cell.detailTextLabel.width = cell.contentView.width - cell.accessoryView.width - 45.f - cell.textLabel.width;
        cell.detailTextLabel.font=[UIFont systemFontOfSize:15];
        [cell.detailTextLabel sizeToFit];
        
        return cell;
    }
}
-(void)loadCellData:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
//    NSString *title=self.list[indexPath.section][indexPath.row];
//    cell.textLabel.text=title;
//    
//    if([title isEqualToString:@"昵称"])
//    {
//        cell.detailTextLabel.text=[LCMyUser mine].nickname;
//    }else if([title isEqualToString:@"录制个人视频"])
//    {
//        cell.detailTextLabel.text=@"";
//    }else if([title isEqualToString:@"签名"])
//    {
//        cell.detailTextLabel.text=[LCMyUser mine].sign;
//    }else if([title isEqualToString:@"我想"])
//    {
//        cell.detailTextLabel.text=[LCMyUser mine].ithink;
//    }else if([title isEqualToString:@"兴趣爱好"])
//    {
//        
//        cell.detailTextLabel.text=[LCMyUser mine].hobbies;// @"dfvnjdfnvdnfvdmnkvlmdfnviunvinvkdmvlkdmvdfvidvindfvndfvndfionviovnidnvdnvdnvkdfnvkdfnvkdfnvdfivndfinvdfnvdfnvdfnv";
//        
//        NSLog(@"");
//    }else if([title isEqualToString:@"优点"])
//    {
//        cell.detailTextLabel.text=[LCMyUser mine].good;
//    }else if([title isEqualToString:@"性别"])
//    {
//        cell.detailTextLabel.text=LCSexName([LCMyUser mine].sex);
//    }else if([title isEqualToString:@"生日"])
//    {
//        cell.detailTextLabel.text=[LCMyUser mine].birthday;
//    }else if([title isEqualToString:@"出生地"])
//    {
//        cell.detailTextLabel.text=[NSString stringWithFormat:@"%@  %@",[LCMyUser mine].home_prov,[LCMyUser mine].home_city];
//    }else if([title isEqualToString:@"居住地"])
//    {
//        cell.detailTextLabel.text=[NSString stringWithFormat:@"%@  %@",[LCMyUser mine].province,[LCMyUser mine].city];
//    }else if([title isEqualToString:@"真实姓名"])
//    {
//        cell.detailTextLabel.text=[LCMyUser mine].realname;
//    }else if([title isEqualToString:@"身高"])
//    {
//        
//        NSInteger userHeight=[LCMyUser mine].height;
//        if(userHeight==0)
//        {
//            userHeight=170;
//            [LCMyUser mine].height=170;
//        }
//        
//        cell.detailTextLabel.text=[NSString stringWithFormat:@"%ld厘米",userHeight];
//    }else if([title isEqualToString:@"体型"])
//    {
//        cell.detailTextLabel.text=[LCMyUser mine].stature;
//    }else if([title isEqualToString:@"学历"])
//    {
//            cell.detailTextLabel.text=/*LCDegreeName([LCMyUser mine].degree);*/[LCMyUser mine].degree;
//    }else if([title isEqualToString:@"工资"])
//    {
//        cell.detailTextLabel.text=[NSString stringWithFormat:@"%d",(int)[LCMyUser mine].wage];
//    }else if([title isEqualToString:@"职业"])
//    {
//        cell.detailTextLabel.text=[LCMyUser mine].job;
//        
//    }else if([title isEqualToString:@"婚姻"])
//    {
//        cell.detailTextLabel.text=LCMarriageName([LCMyUser mine].marry);
//    }else if([title isEqualToString:@"独白"])
//    {
//        cell.detailTextLabel.text=[LCMyUser mine].monologue;
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title=self.list[indexPath.section][indexPath.row];
    if([title isEqualToString:@"头像"])
    {
//        ESWeakSelf;
//        [[LCEditUserInfoManager sharedSubmitDetail] submitPhotoWithSuccessBlock:^(LCEditDetailType editType){
//            ESStrongSelf;
//            [_self.tableView reloadData];
//        } withController:self];
        
    }else if([title isEqualToString:@"录制个人视频"])
    {
//            if (ESIsStringWithAnyText([LCMyUser mine].videoURL) &&
//                [[LCMyUser mine].videoURL.lowercaseString hasPrefix:@"http"]) {
//                    ESWeakSelf;
//                    UIActionSheet *action = [UIActionSheet actionSheetWithTitle:nil
//                                                              cancelButtonTitle:@"取消"
//                                                                didDismissBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex)
//                    {
//                            ESStrongSelf;
//                            if (0 == buttonIndex) {
//                                    [_self recordVideo];
//                            } else if (1 == buttonIndex) {
//                                    UIAlertView *alert = [UIAlertView alertViewWithTitle:@"确定要删除个人视频吗?" message:nil cancelButtonTitle:@"取消" didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
//                                            if (buttonIndex != alertView.cancelButtonIndex) {
//                                                    ESStrongSelf;
//                                                    [_self removeVideo];
//                                            }
//                                    } otherButtonTitles:@"确定删除", nil];
//                                    [alert show];
//                            }
//                    } otherButtonTitles:@"录制个人视频", @"删除个人视频", nil];
//                    action.destructiveButtonIndex = 1;
//                    [action showInView:self.view];
//            } else {
//                    [self recordVideo];
//            }
    }
    else if([title isEqualToString:@"签名"])
    {
//        ESWeakSelf;
//        [[LCEditUserInfoManager sharedSubmitDetail] submitSignWithSuccessBlock:^(LCEditDetailType editType){
//            ESStrongSelf;
//            [_self.tableView reloadData];
//        }];
        
    }else if([title isEqualToString:@"昵称"])
    {
//        ESWeakSelf;
//        [[LCEditUserInfoManager sharedSubmitDetail] submitNicknameWithSuccessBlock:^(LCEditDetailType editType){
//            ESStrongSelf;
//            [_self.tableView reloadData];
//        }];

    }else if([title isEqualToString:@"我想"])
    {
//        ESWeakSelf;
//        [[LCEditUserInfoManager sharedSubmitDetail] submitIthingWithSuccessBlock:^(LCEditDetailType editType){
//            ESStrongSelf;
//            [_self.tableView reloadData];
//        }];
//
        
    }else if([title isEqualToString:@"兴趣爱好"])
    {
//        ESWeakSelf;
//        [[LCEditUserInfoManager sharedSubmitDetail] submitHobbiesWithSuccessBlock:^(LCEditDetailType editType){
//            ESStrongSelf;
//            [_self.tableView reloadData];
//        }];

    }else if([title isEqualToString:@"优点"])
    {
//        ESWeakSelf;
//        [[LCEditUserInfoManager sharedSubmitDetail] submitGoodWithSuccessBlock:^(LCEditDetailType editType){
//            ESStrongSelf;
//            [_self.tableView reloadData];
//        }];
    }else if([title isEqualToString:@"性别"])
    {
        [LCNoticeAlertView showMsg:@"性别不可修改"];
    }else if([title isEqualToString:@"生日"])
    {
//        ESWeakSelf;
//        [[LCEditUserInfoManager sharedSubmitDetail] submitBirthdayWithSuccessBlock:^(LCEditDetailType editType){
//            ESStrongSelf;
//            [_self.tableView reloadData];
//        }];

    }else if([title isEqualToString:@"出生地"])
    {
//        ESWeakSelf;
//        [[LCEditUserInfoManager sharedSubmitDetail] submitHomeWithSuccessBlock:^(LCEditDetailType editType){
//            ESStrongSelf;
//            [_self.tableView reloadData];
//        }];
    }else if([title isEqualToString:@"居住地"])
    {
//        ESWeakSelf;
//        [[LCEditUserInfoManager sharedSubmitDetail] submitLocalWithSuccessBlock:^(LCEditDetailType editType){
//            ESStrongSelf;
//            [_self.tableView reloadData];
//        }];

    }else if([title isEqualToString:@"真实姓名"])
    {
//        ESWeakSelf;
//        [[LCEditUserInfoManager sharedSubmitDetail] submitRealnameWithSuccessBlock:^(LCEditDetailType editType){
//            ESStrongSelf;
//            [_self.tableView reloadData];
//        }];

        
    }else if([title isEqualToString:@"身高"])
    {
//        ESWeakSelf;
//        [[LCEditUserInfoManager sharedSubmitDetail] submitHeightWithSuccessBlock:^(LCEditDetailType editType){
//            ESStrongSelf;
//            [_self.tableView reloadData];
//        }];
    }else if([title isEqualToString:@"体型"])
    {
//        ESWeakSelf;
//        [[LCEditUserInfoManager sharedSubmitDetail] submitStatureWithSuccessBlock:^(LCEditDetailType editType){
//            ESStrongSelf;
//            [_self.tableView reloadData];
//        }];
    }else if([title isEqualToString:@"学历"])
    {
//        ESWeakSelf;
//        [[LCEditUserInfoManager sharedSubmitDetail] submitDegreeWithSuccessBlock:^(LCEditDetailType editType){
//            ESStrongSelf;
//            [_self.tableView reloadData];
//        }];
    }else if([title isEqualToString:@"工资"])
    {
//        ESWeakSelf;
//        [[LCEditUserInfoManager sharedSubmitDetail] submitWageWithSuccessBlock:^(LCEditDetailType editType)
//        {
//            ESStrongSelf;
//            [_self.tableView reloadData];
//        }];
    }else if([title isEqualToString:@"职业"])
    {
//        ESWeakSelf;
//        [[LCEditUserInfoManager sharedSubmitDetail] submitJobWithSuccessBlock:^(LCEditDetailType editType){
//            ESStrongSelf;
//        [_self.tableView reloadData];
    }

        
//    }else if([title isEqualToString:@"婚姻"])
//    {
//        ESWeakSelf;
//        [[LCEditUserInfoManager sharedSubmitDetail] submitMarriageWithSuccessBlock:^(LCEditDetailType editType){
//            ESStrongSelf;
//            [_self.tableView reloadData];
//        }];
//    }else if([title isEqualToString:@"独白"])
//    {
//        ESWeakSelf;
//        [[LCEditUserInfoManager sharedSubmitDetail] submitMonologueWithSuccessBlock:^(LCEditDetailType editType){
//            ESStrongSelf;
//            [_self.tableView reloadData];
//        }];
//    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0&&indexPath.row==0)
        return 98.0;
//    else if(indexPath.section==4)
//    {
//        
//        return 80.0;
//    }
    
    else
//        return 43.0;
    {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return MAX(cell.detailTextLabel.height + 20, 44);
    }
    
}

@end
