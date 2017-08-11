//
//  LCRegDoneController.m
//  XCLive
//
//  Created by jacklong on 16/1/12.
//  Copyright © 2016年 www.yuanphone.com. All rights reserved.
//

#import "LCRegDoneController.h"

#import "LCSelectPhoto.h"
#import "LCInsetsLabel.h"
#import "LCSinglePickerView.h"
#import "LCAlertTextFieldView.h"
#import "LCBirthdayPickerAlert.h"
#import "LCSelectSexAlert.h"
#import "NSString+ManageFaceURLString.h"
#import "LCCore.h"
#import "CustomNotification.h"
#import "LCDefines.h"
#import "LCNoticeAlertView.h" 

@interface LCRegDoneController ()

@end

@implementation LCRegDoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"注册(2/2)";
    
    UIButton *rightItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItemBtn.frame=CGRectMake(0, 0, 65.0, 30.0);
    
    [rightItemBtn setTitle:@"完 成"
                  forState:UIControlStateNormal];
    rightItemBtn.backgroundColor=[UIColor clearColor];
    
    [rightItemBtn addTarget:self
                     action:@selector(rightAction)
           forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithCustomView:rightItemBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    UIButton *leftItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItemBtn.frame = CGRectMake(0, 0, 65.0, 30.0);
    
    [leftItemBtn setTitle:@"返回"
                 forState:UIControlStateNormal];
    leftItemBtn.backgroundColor = [UIColor clearColor];
    
    [leftItemBtn addTarget:self
                    action:@selector(leftAction)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc] initWithCustomView:leftItemBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    
    ESWeakSelf;
    _babyPhoto = [[MMBabyPhoto alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,140)];
    _babyPhoto.babyPhotoBlock=^(void){
        ESStrongSelf;
        [_self selectPhoto];
        
    };
    
    self.tableView.tableHeaderView = _babyPhoto;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    
    NSArray *array=@[@"昵称",@"生日",@"性别"];
    self.list=[NSMutableArray arrayWithArray:array];
    
    self.infoDic=[NSMutableDictionary dictionary];
}

- (void)leftAction
{
    //[self.navigationController popViewControllerAnimated:YES];
    [LCCore presentLandController];
}

-(void)rightAction
{
    if(![LCMyUser mine].faceURL || [[LCMyUser mine].faceURL isEqualToString:@""])
    {
        [LCNoticeAlertView showMsg:@"请上传形象照"];
        return;
    }
    else if(!self.infoDic[@"nickname"]||[self.infoDic[@"nickname"] isEqualToString:@""])
    {
        [LCNoticeAlertView showMsg:@"请填写您的昵称"];
        return;
    }
    else if(!self.infoDic[@"birthday"])
    {
        [LCNoticeAlertView showMsg:@"请填写您的生日"];
        return;
    }
    else if(!self.infoDic[@"sex"])
    {
        [LCNoticeAlertView showMsg:@"请填写您的性别"];
        return;
    }
    
    if(_Loading)
        return;
    
    _Loading=YES;
    ESWeakSelf;
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        
        ESStrongSelf;
        NSLog(@"reg detail = %@",responseDic);
        int stat=[responseDic[@"stat"] intValue];
        if(stat == URL_REQUEST_SUCCESS)
        {
            [[LCMyUser mine] modifyInfo:responseDic[@"userinfo"]];
            
            [LCMyUser mine].imToken = ESStringValue(responseDic[@"im_token"]);
            // [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_Land_Sucess object:nil];
            
            [LCCore presentMainViewController];
            //            NSDictionary *userInfo = result[@"userinfo"];
            //            [KFSocketManager defaultManager].loginInfo = userInfo;
            //            KFSocketConfig *socketConfig = [KFSocketConfig configWithDictionary:userInfo];
            //            [[KFSocketManager defaultManager] setSocketConfig:socketConfig];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_Land_Sucess object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_EditInfo_Success object:nil];//更新设置页面显示内容
        }
        else
        {
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
        
        _self.Loading=NO;
        
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        NSLog(@"reg detial fial :%@",error);
        ESStrongSelf;
        _self.Loading=NO;
        [LCNoticeAlertView showMsg:@"请求失败!"];
    };
    
    [self.infoDic setObject:@"1" forKey:@"ry"];
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:self.infoDic
                                                  withPath:URL_LIVE_REG_DETAIL
                                               withRESTful:POST_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}


-(void)selectPhoto
{
    ESWeakSelf;
    [[LCSelectPhoto selectPhoto] showSelectItemForPortraitWithController:self
                                                               submitURL:URL_LIVE_REG_UPLOAD_FACE
                                                         withSubmitBlock:^(NSDictionary *dic){
                                                             
                                                             
                                                             ESStrongSelf;
                                                             [LCMyUser mine].faceURL=[NSString faceURLString:dic[@"face"]];
                                                             [[LCMyUser mine] save];
                                                             
                                                             [_self.babyPhoto showImage];
                                                             
                                                             /*
                                                              [[SDImageCache sharedImageCache] removeImageForKey:[LCMyUser mine].faceURL fromDisk:YES withCompletion:^(void){
                                                              
                                                              [_self.babyPhoto showImage];
                                                              }];
                                                              */
                                                             [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_EditInfo_Success
                                                                                                                 object:nil
                                                                                                               userInfo:nil];
                                                         }];
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    LCInsetsLabel *sectionFooterLabel=[[LCInsetsLabel alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,50) andInsets:UIEdgeInsetsMake(3,12,0,12)];
    
    sectionFooterLabel.textAlignment = NSTextAlignmentLeft;
    sectionFooterLabel.textColor=[UIColor grayColor];
    sectionFooterLabel.font=[UIFont systemFontOfSize:16];
    sectionFooterLabel.backgroundColor =[UIColor clearColor];
    sectionFooterLabel.numberOfLines = 0;
    
    NSString *labelString=@"性别修改后不允许修改，请谨慎操作";
    

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGSize size = [labelString sizeWithFont:sectionFooterLabel.font
                          constrainedToSize:CGSizeMake(sectionFooterLabel.width-sectionFooterLabel.insets.left*2, CGFLOAT_MAX)
                              lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
    
    sectionFooterLabel.height=size.height+12;
    sectionFooterLabel.text=labelString;
    
    return sectionFooterLabel;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.list count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row==0)
    {
        static NSString *identifier=@"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                        reuseIdentifier:identifier];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            // 取消选择模式
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSString *title=self.list[indexPath.row];
        cell.textLabel.text=title;
        cell.detailTextLabel.text=@"请输入您的昵称";
        cell.detailTextLabel.textColor=[UIColor grayColor];
        _nicknameCell=cell;
        return cell;
        
    }
    else if(indexPath.row==1)
    {
        static NSString *identifier=@"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                        reuseIdentifier:identifier];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            // 取消选择模式
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSString *title=self.list[indexPath.row];
        cell.textLabel.text=title;
        cell.detailTextLabel.text=@"请选择您的出生日期";
        _brithdayCell=cell;
        return cell;
        
    }
    else if(indexPath.row==2)
    {
        static NSString *identifier=@"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                        reuseIdentifier:identifier];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            // 取消选择模式
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSString *title=self.list[indexPath.row];
        cell.textLabel.text=title;
        cell.detailTextLabel.text=@"请选择您的性别";
        _sexCell=cell;
        return cell;
    }
    return nil;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ESWeakSelf;
    if(indexPath.row==0)
    {
        [LCAlertTextFieldView showAlertTextFieldView:@"请输入昵称"
                                       textFieldText:self.infoDic[@"nickname"]
                                     withEditedBlock:^(NSString *text) {
                                         ESStrongSelf;
                                         _self.infoDic[@"nickname"]=text;
                                         
                                         //[_self.infoDic setObject:text forKey:@"nickname"];
                                         
                                         if([text length]>0)
                                         {
                                             _self.nicknameCell.detailTextLabel.text=text;
                                             _self.nicknameCell.detailTextLabel.textColor=[UIColor blackColor];
                                             
                                         }else{
                                             _self.nicknameCell.detailTextLabel.text=@"请输入您的昵称";
                                             _self.nicknameCell.detailTextLabel.textColor=[UIColor grayColor];
                                             
                                         }
                                         
                                     }];
    }else if (indexPath.row==1)
    {
        [LCBirthdayPickerAlert birthdayPicker:self.infoDic[@"birthday"]
                              withFinishBlock:^(NSString *brithdayString){
                                  
                                  ESStrongSelf;
                                  _self.infoDic[@"birthday"]=brithdayString;
                                  _self.brithdayCell.detailTextLabel.text=brithdayString;
                                  _self.brithdayCell.detailTextLabel.textColor=[UIColor blackColor];
                                  
                              }];
    }else if(indexPath.row==2)
    {
        NSInteger sexs=0;
        ESIntegerVal(&sexs, self.infoDic[@"sex"]);
        if(sexs>0)
            sexs-=1;
        [LCSelectSexAlert selectSex:(int)sexs
                    withFinishBlock:^(int sex){
                        
                        ESStrongSelf;
                        _self.infoDic[@"sex"]=@(sex+1);
                        
                        
                        NSString *sexString;
                        if(sex==0)
                            sexString=@"男";
                        else
                            sexString=@"女";
                        _self.sexCell.detailTextLabel.text=sexString;
                        _self.sexCell.detailTextLabel.textColor=[UIColor blackColor];
                    }];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

