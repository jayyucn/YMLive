//
//  EditUserInfoViewController.m
//  qianchuo 编辑用户信息
//
//  Created by jacklong on 16/3/31.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "EditUserInfoViewController.h"
#import "EditUserHeaderCell.h"
#import "EditUserNameViewController.h"
#import "EditUserSignatureViewController.h"
#import "ShowWebViewController.h"
#import "QCEditLocalView.h"
#import "EditUserInfoViewController+YingYingImagePickerController.h"

@interface EditUserInfoViewController()

@property (nonatomic , strong) UIImage *mWaitingImage;

@end

@implementation EditUserInfoViewController
{
}


-(id)initWithStyle:(UITableViewStyle)style hasRefreshControl:(BOOL)hasRefreshControl
{
    self = [super initWithStyle:style hasRefreshControl:hasRefreshControl];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title= ESLocalizedString(@"编辑资料");
    
    NSArray *array=@[@[ESLocalizedString(@"头像")],
                     @[ESLocalizedString(@"昵称"),ESLocalizedString(@"个性签名"),ESLocalizedString(@"定位位置"),ESLocalizedString(@"认证")]];
    self.list=[NSMutableArray arrayWithArray:array];
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundColor=[UIColor clearColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUserInfoAction)
                                                 name:NotificationMsg_EditInfo_Success
                                               object:nil];

    
    @weakify(self);
    [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFY_UI_IMAGE_PICKER_DONE object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self);
//        self.mWaitingImage = note.object;
        self.mWaitingImage = [self imageChangeWithSize:CGSizeMake(640, 640) WithImage:note.object];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.mWaitingImage) {
        [self submitPhoto:self.mWaitingImage url:URL_MODIFY_FACE];
        self.mWaitingImage = nil;
    }
}

- (void)dealloc {
    NSLog(@"dealloc %@", self);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (UIImage *)imageChangeWithSize:(CGSize)maxSize WithImage:(UIImage *)image
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    
    CGSize targetSize = image.size;
    if (maxSize.height <= 0 || maxSize.width <= 0) {
        return nil;
    }
    while (targetSize.width > maxSize.width || targetSize.height > maxSize.width) {
        targetSize.width = targetSize.width / 1.1;
        targetSize.height = targetSize.height / 1.1;
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    [sourceImage drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) {
        NSLog(@"LY could not scale image");
    }
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}


-(void)submitPhoto:(UIImage *)image url:(NSString *)urlString
{
    ESWeakSelf;
//    NSLog(@"submit %@", image);
//    NSData *data = UIImageJPEGRepresentation(image, 1.0);
//    if (data) {
//        NSLog(@"data %ld k", data.length / 1024);
//        image = [UIImage imageWithData:data];
//    }
    MBProgressHUD* hub = [[MBProgressHUD alloc] initWithView:self.view];
    hub.mode = MBProgressHUDModeDeterminate;
    [self.view addSubview:hub];
    hub.labelText = ESLocalizedString(@"上传中");
    hub.progress = 0;
    [hub show:YES];
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        [hub removeFromSuperview];
        NSLog(@"upload image =%@",responseDic);
        
        int stat=[responseDic[@"stat"] intValue];
        if(stat == URL_REQUEST_SUCCESS)
        {
            ESStrongSelf;
            [LCMyUser mine].faceURL=[NSString faceURLString:responseDic[@"face"]];
            [[LCMyUser mine] save];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_EditInfo_Success  object:@"face" ];
        }
        else
        {
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
        
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        [hub removeFromSuperview];
        NSLog(@"upload image fail %@",error);
        [LCNoticeAlertView showMsg:ESLocalizedString(@"上传失败")];
    };
    
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"?uid=%@", [LCMyUser mine].userID]];
    
    [[LCHTTPClient sharedHTTPClient] upLoadImage:image
                                       withParam:nil
                                        withPath:urlString
                                        progress:^(NSProgress *progress) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                float value = progress.fractionCompleted;
                                                    if (value >= 0 && value <= 1) {
                                                        hub.progress = value;
                                                    }
                                            });
                                        }
                                     withRESTful:POST_REQUEST
                                withSuccessBlock:successBlock
                                   withFailBlock:failBlock];
}



// 更新用户信息
- (void) updateUserInfoAction
{
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.list count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(NSArray *)self.list[section] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *seperateView = nil;
    if (section == 0) {
        seperateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        seperateView.backgroundColor=[UIColor clearColor];
    } else {
        seperateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        seperateView.backgroundColor=[UIColor clearColor];
    }
    
    return seperateView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if(indexPath.section==0)
    {
        static NSString *identifier=@"headerCell";
        EditUserHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell=[[EditUserHeaderCell alloc] initWithStyle:UITableViewCellStyleValue1
                                         reuseIdentifier:identifier];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            // 取消选择模式
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        
        cell.textLabel.text = self.list[indexPath.section][indexPath.row];
        [cell showDataOfCell];
        return cell;
    }
    else
    {
        static NSString *identifier=@"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                        reuseIdentifier:identifier];
            
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            cell.accessoryView.backgroundColor=[UIColor redColor];
            // 取消选择模式
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
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
        
        cell.textLabel.text = self.list[indexPath.section][indexPath.row];
        
        if (indexPath.row == 0)
        {
            cell.detailTextLabel.textColor = ColorPink;
            cell.detailTextLabel.text = [LCMyUser mine].nickname;
        }
        else if (indexPath.row == 2)
        {
            cell.detailTextLabel.textColor = ColorPink;
            cell.detailTextLabel.text = [LCMyUser mine].city;
        }
      
        [cell.textLabel sizeToFit];
        cell.detailTextLabel.width = cell.contentView.width - cell.accessoryView.width - 45.f - cell.textLabel.width;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        [cell.detailTextLabel sizeToFit];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title=self.list[indexPath.section][indexPath.row];
    if([title isEqualToString:ESLocalizedString(@"头像")])
    {
        [self lyModalChoosePicker];
        
        
    } else if([title isEqualToString:ESLocalizedString(@"昵称")]) {
        EditUserNameViewController *editNameViewController = [[EditUserNameViewController alloc] init];
        [self.navigationController pushViewController:editNameViewController animated:YES];
    } else if([title isEqualToString:ESLocalizedString(@"个性签名")]) {
        EditUserSignatureViewController *editSignController = [[EditUserSignatureViewController alloc] init];
        [self.navigationController pushViewController:editSignController animated:YES];
    } else if ([title isEqualToString:ESLocalizedString(@"认证")])
    {
        ShowWebViewController *showWebVC = [[ShowWebViewController alloc] init];
        showWebVC.hidesBottomBarWhenPushed = YES;
        showWebVC.isShowRightBtn = false;
        showWebVC.webTitleStr = ESLocalizedString(@"认证");
        showWebVC.webUrlStr = [NSString stringWithFormat:@"%@other/certify",URL_HEAD];
        [self.navigationController pushViewController:showWebVC animated:YES];
    } else if ([title isEqualToString:ESLocalizedString(@"定位位置")]) {
        ESWeakSelf;
        [QCEditLocalView showEditViewAndEditedBlock:^(NSDictionary *editedDic) {
            ESStrongSelf;
            [_self updateUserAddress:editedDic[@"prov"] withCity:editedDic[@"city"]];
        }];
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60;
    }
    return 50.f;
}


#pragma mark - edit address
- (void) updateUserAddress:(NSString *)prov withCity:(NSString *)city
{
    if (!prov || !city) {
        return;
    }
    
    ESWeakSelf;
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        NSLog(@"update address %@",responseDic);
        ESStrongSelf;
        if (URL_REQUEST_SUCCESS == [[responseDic objectForKey:@"stat"] integerValue])
        {
            [LCMyUser mine].city = prov;
            [self updateUserInfoAction];
        }
        else
        {
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error)
    {
        [LCNoticeAlertView showMsg:@"error!"];
        NSLog(@"error %@", error);
    };
    
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"prov":prov,@"city":city}
                                                  withPath:URL_EDIT_USER_INFO
                                               withRESTful:POST_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}

@end
