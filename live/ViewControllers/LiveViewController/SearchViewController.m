//
//  SearchViewController.m
//  qianchuo
//
//  Created by jacklong on 16/4/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "SearchViewController.h"
#import "MyAttentAndFansCell.h"
#import "UserSpaceViewController.h"
#import "WatchCutLiveViewController.h"

#define Search_Length 20
#define Cell_Height 60

@interface SearchViewController()<UITextFieldDelegate>
{
    UIView  *titleView;
    UIView  *bgView;
    UIImageView *searchIconImgView;
    UITextField *searchContentTextField;
    UIButton   *clearSearchBtn;
    UIButton   *closeViewBtn;
    BOOL    isSearching;
    BOOL    isNoData;
}
@end

@implementation SearchViewController

- (void)dealloc
{
    NSLog(@"dealloc %@",NSStringFromClass(self.class));
}

- (void) viewDidLoad
{
    [super viewDidLoad];

    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT, SCREEN_WIDTH, 44)];
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH - 65, 30)];
    bgView.backgroundColor = [UIColor whiteColor];
    //设置圆角边框
    bgView.layer.cornerRadius = 3;
    bgView.layer.masksToBounds = YES;
    [titleView addSubview:bgView];
    
    UIImage *searchImg = [UIImage imageNamed:@"image/liveroom/search_prompt_icon"];
    searchIconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, searchImg.size.width, searchImg.size.height)];
    searchIconImgView.image = searchImg;
    searchIconImgView.centerY =  bgView.centerY - searchImg.size.height/2+2;
    [bgView addSubview:searchIconImgView];
    
    searchContentTextField = [[UITextField alloc] initWithFrame:CGRectMake(searchIconImgView.right+5, 0, bgView.width-60, bgView.height)];
    searchContentTextField.backgroundColor = [UIColor clearColor];
    searchContentTextField.borderStyle = UITextBorderStyleNone;
    searchContentTextField.textColor = [UIColor blackColor];
    searchContentTextField.delegate = self;
    searchContentTextField.font = [UIFont systemFontOfSize:14.f];
    [searchContentTextField setReturnKeyType:UIReturnKeySearch];
    searchContentTextField.tintColor = [UIColor grayColor];
    searchContentTextField.placeholder = ESLocalizedString(@"输入ID号或昵称");
    [bgView addSubview:searchContentTextField];
    [searchContentTextField becomeFirstResponder];
    
    [searchContentTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIImage *clearImg = [UIImage imageNamed:@"image/liveroom/search_clear"];
    clearSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(bgView.width - clearImg.size.width-10, 0, clearImg.size.width
                                                                , clearImg.size.height)];
    [clearSearchBtn setImage:clearImg forState:UIControlStateNormal];
    [clearSearchBtn addTarget:self action:@selector(clearSearchContent) forControlEvents:UIControlEventTouchUpInside];
    clearSearchBtn.centerY = bgView.centerY - clearImg.size.height/2+2;
    [bgView addSubview:clearSearchBtn];
    clearSearchBtn.hidden = YES;
    
    
    closeViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeViewBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [closeViewBtn setTitle:ESLocalizedString(@"取消") forState:UIControlStateNormal];
    [closeViewBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    closeViewBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [closeViewBtn addTarget:self action:@selector(closeViewAction) forControlEvents:UIControlEventTouchUpInside];
    closeViewBtn.frame =  CGRectMake(bgView.right, 5, 60, 30);
    [titleView addSubview:closeViewBtn];
    
    //导航栏
    UINavigationBar* navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44+STATUS_HEIGHT)];
    
    UINavigationItem* navItem = [[UINavigationItem alloc] init];
    navItem.titleView = titleView;
    
    [navBar pushNavigationItem:navItem animated:NO];
    [self.view addSubview:navBar];
    
    self.tableView.frame = CGRectMake(0, 44+STATUS_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - (44+STATUS_HEIGHT));
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = Cell_Height;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.navigationController.isNavigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    
    if ([LCMyUser mine].roomInfoDict) {// 换房间
        ESWeakSelf;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ESStrongSelf;
            [_self changeRoomVC:[LCMyUser mine].roomInfoDict];
            
            [LCMyUser mine].roomInfoDict = nil;
        });
        
    }
}

#pragma mark - 换房间
- (void) changeRoomVC:(NSDictionary *)userInfoDict
{
//    NSMutableArray *array = [NSMutableArray array];
//    [array addObject:userInfoDict];
//    
//    WatchCutLiveViewController *watchLiveViewController = [[WatchCutLiveViewController alloc ] init];
//    [LCMyUser mine].liveUserId = userInfoDict[@"uid"];
//    [LCMyUser mine].liveUserName = userInfoDict[@"nickname"];
//    [LCMyUser mine].liveUserLogo = userInfoDict[@"face"];
//    [LCMyUser mine].liveTime = @"0";
//    [LCMyUser mine].liveType = LIVE_WATCH;
//    [LCMyUser mine].liveUserGrade = [userInfoDict[@"grade"] intValue];
//    watchLiveViewController.playerUrl = userInfoDict[@"url"];
//    watchLiveViewController.liveArray = array;
//    watchLiveViewController.pos = 0;
//    [self.navigationController pushViewController:watchLiveViewController animated:YES];
     [WatchCutLiveViewController ShowWatchLiveViewController:self.navigationController withInfoDict:userInfoDict withArray:nil withPos:0];
}

#pragma mark - Table view data source
-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    [searchContentTextField resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.list count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"search_cell";
    
    MyAttentAndFansCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[MyAttentAndFansCell alloc]  initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:identifier];
        
        // 取消选择模式
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.userInfoDict = self.list[indexPath.row];
    cell.lineView.hidden = NO;
    cell.attentStateBtn.hidden = NO;
    
    if (indexPath.row + 1 == self.list.count && [self.list count] >= 19 && searchContentTextField.text.length > 0) {
        [self getSearchList:searchContentTextField.text];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *userDic=self.list[indexPath.row];
    LiveUser *liveUser = [[LiveUser alloc] initWithPhone:userDic[@"uid"] name:userDic[@"nickname"] logo:userDic[@"face"]];
    liveUser.hasInRoom = NO;
    NSString *userIdStr = [NSString stringWithFormat:@"%@",liveUser.userId];
    if (!userIdStr || userIdStr.length <= 0) {
        return;
    }
    
    UserSpaceViewController *onlineUserVC = [[UserSpaceViewController alloc] init];
    onlineUserVC.liveUser = liveUser;
    onlineUserVC.isShowBg = YES;
    ESWeakSelf;
    onlineUserVC.privateChatBlock = ^(NSDictionary * userInfoDict) {
        ESStrongSelf;
        
        if ([LCMyUser mine].priChatTag && [[LCMyUser mine].priChatTag isEqualToString:@"0"])
        {
            [[[ChatViewController alloc] initWithUserInfoDictionary:userInfoDict] pushFromNavigationController:_self.navigationController animated:YES];
        }
        else
        {
            // 弹出提示
            [[[UIAlertView alloc] initWithTitle:nil
                                        message:@"很抱歉，您没有私信的权限"
                                       delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil] show];
        }
    };
    
    onlineUserVC.changeLiveRoomBlock = ^(NSDictionary *userInfoDict){
        ESStrongSelf;
        [_self changeRoomVC:userInfoDict];
    };
    onlineUserVC.showUserHomeBlock = ^(NSString *userId){
        ESStrongSelf;
        HomeUserInfoViewController *userInfoVC = [[HomeUserInfoViewController alloc] init];
        userInfoVC.userId = userId;
        [_self.navigationController pushViewController:userInfoVC animated:YES];
    };
    [onlineUserVC popupWithCompletion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Cell_Height;
}


-(void)getSearchList:(NSString *)searchContent
{
    if (isNoData || isSearching) {
        return;
    }
    
    isSearching = YES;
    
    [LCMyUser mine].liveUserId = nil;
    
    ESWeakSelf;
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        NSLog(@"search response =%@",responseDic);
        
        ESStrongSelf;
        int stat=[responseDic[@"stat"] intValue];
        if(stat==200)
        {
            NSArray *responseArray=responseDic[@"list"];
            
            if (_self.currentPage == 1) {
                [_self.list removeAllObjects];
            }
            
            if([responseArray isKindOfClass:[NSArray class]]&&[responseArray count]>0)
            {
                [_self.list addObjectsFromArray:responseArray];
                if (responseArray.count >= 19) {
                    isNoData = NO;
                    ++_self.currentPage;
                } else {
                    isNoData = YES;
                }
            }
            _self.loadMoreButton.hidden=YES;
            
            [_self.tableView reloadData];
            
            if([_self.list count]==0)
            {
                _self.noDataNotice.hidden=NO;
                _self.noDataImageView.hidden=NO;
                _self.noDataNotice.text=[NSString stringWithFormat:@"%@%@", ESLocalizedString(@"抱歉，没检索到"), searchContent];
            }else{
                _self.noDataImageView.hidden=YES;
                _self.noDataNotice.hidden=YES;
            }
        }else{
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
            _self.loadMoreButton.hidden=YES;
        }
        _self.isLoadingMore=NO;
        _self->isSearching = NO;
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        NSLog(@"gagerror=%@",error);
        
        ESStrongSelf;
        _self.isLoadingMore=NO;
        _self->isSearching = NO;
    };
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"word":searchContent,@"page":[NSNumber numberWithInt:self.currentPage]}
                                                  withPath:URL_SEARCH_USER
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}


- (void) loadMoreData
{
    
}


// 关闭view
- (void) closeViewAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 清空检索内容
- (void) clearSearchContent
{
    NSLog(@"clear search content");
    searchContentTextField.text = @"";
    clearSearchBtn.hidden = YES;
}

- (void) textFieldDidChange:(UITextField *) textField
{
    if (textField == searchContentTextField) {
        if (textField.text.length > Search_Length) {
            textField.text = [textField.text substringToIndex:Search_Length];
        }
        
        if (textField.text.length <= 0) {
            clearSearchBtn.hidden = YES;
        } else {
            clearSearchBtn.hidden = NO;
            self.currentPage = 1;
            [self getSearchList:searchContentTextField.text];
        }
    }
}

#pragma mark - textfield 监听
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == searchContentTextField) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > Search_Length) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == searchContentTextField) {
        if (textField.text.length > Search_Length) {
            textField.text = [textField.text substringToIndex:Search_Length];
        }
        
        if (textField.text.length <= 0) {
            clearSearchBtn.hidden = YES;
        } else {
            clearSearchBtn.hidden = NO;
            
            self.currentPage = 1;
            
            isNoData = NO;
            
            
            [self getSearchList:searchContentTextField.text];
        }
    }
    return YES;
}


@end
