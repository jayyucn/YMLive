//
//  ShowWebViewController.m
//  qianchuo
//
//  Created by jacklong on 16/4/18.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ShowWebViewController.h"
#import "UserSpaceViewController.h"
#import "WatchCutLiveViewController.h"

@interface ShowWebViewController() <UIWebViewDelegate>
{
    UIWebView *webView;
}
@end

@implementation ShowWebViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _webTitleStr;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    if (_isShowRightBtn) {
        UIButton *rightItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightItemBtn.frame=CGRectMake(0, 0, 65.0f, 30.0f);
        
        [rightItemBtn setTitle:_rightBtnTitleStr
                      forState:UIControlStateNormal];
        rightItemBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        rightItemBtn.titleLabel.font = [UIFont systemFontOfSize: 11.0];
        [rightItemBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        rightItemBtn.backgroundColor=[UIColor clearColor];
        
        [rightItemBtn addTarget:self
                         action:@selector(rightAction)
               forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithCustomView:rightItemBtn];
        self.navigationItem.rightBarButtonItem=rightItem;
    }
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:_webUrlStr]];
    __typeof(self) weakSelf = self;
    webView.delegate = weakSelf;
    [self.view addSubview: webView];
    [webView loadRequest:request];
    
    [self setLeftItem];
}

- (void)dealloc {
    NSLog(@"dealloc %@", self);
}

-(void)rightAction
{
    if ([_rightBtnTitleStr isEqualToString:ESLocalizedString(@"提现记录")]) {
        ShowWebViewController   *showWebVC = [[ShowWebViewController alloc] init];
        showWebVC.hidesBottomBarWhenPushed = YES;
        showWebVC.isShowRightBtn = false;
        showWebVC.webTitleStr = ESLocalizedString(@"提现记录");
        showWebVC.webUrlStr = [NSString stringWithFormat:@"%@profile/exchangelog",URL_HEAD];
        [self.navigationController pushViewController:showWebVC animated:YES];
    } else if ([_rightBtnTitleStr isEqualToString:ESLocalizedString(@"关 闭")]){
        [[ESApp rootViewController] dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString* urlString = [[request URL] absoluteString];
    NSLog(@"%@", urlString);
    if ([urlString contains:@"http://protocal.hainandaocheng.com/"]) {
        NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:[request URL]
                                                    resolvingAgainstBaseURL:NO];
        NSArray *queryItems = urlComponents.queryItems;
        NSString *type = [self valueForKey:@"type"
                              fromQueryItems:queryItems];
        if ([type intValue] == 1) { //兑换钻石
            [LCMyUser mine].diamond = [(NSString *)[self valueForKey:@"diamond" fromQueryItems:queryItems] intValue];
        }
        else if([type intValue] == 2) { //查看头像
            NSString* uid = [self valueForKey:@"uid" fromQueryItems:queryItems];
            NSString* nickname = [self valueForKey:@"nickname" fromQueryItems:queryItems];
            NSString* face = [self valueForKey:@"face" fromQueryItems:queryItems];
            LiveUser *liveUser = [[LiveUser alloc] initWithPhone:uid name:nickname logo:face];
            if (!liveUser || !liveUser.userId || liveUser.userId.length <= 0) {
                
                NSLog(@"error %@", [liveUser description]);
            }
            else
            { 
                UserSpaceViewController *userController = [[UserSpaceViewController alloc] init];
                userController.liveUser = liveUser;
                userController.isShowBg = YES;
                userController.isNoShowPrivChat = YES; 
                ESWeakSelf;
                userController.changeLiveRoomBlock = ^(NSDictionary *userInfoDict){
                    ESStrongSelf;
                    [_self changeRoomVC:userInfoDict];
                };
                userController.showUserHomeBlock = ^(NSString *userId){
                    ESStrongSelf;
                    HomeUserInfoViewController *userInfoVC = [[HomeUserInfoViewController alloc] init];
                    userInfoVC.userId = userId;
                    [_self.navigationController pushViewController:userInfoVC animated:YES];
                };
                
                [userController popupWithCompletion:nil];
            }
        }
        else if ([type intValue] == 3) { // 查看直播
            NSString* uid = [self valueForKey:@"uid" fromQueryItems:queryItems];
            NSString* nickname = [self valueForKey:@"nickname" fromQueryItems:queryItems];
            NSString* face = [self valueForKey:@"face" fromQueryItems:queryItems];
            NSString* grade = [self valueForKey:@"grade" fromQueryItems:queryItems];
            NSString* title = [self valueForKey:@"title" fromQueryItems:queryItems];
//            NSString* time = [self valueForKey:@"time" fromQueryItems:queryItems];
//            NSString* total = [self valueForKey:@"total" fromQueryItems:queryItems];
            
            
            NSMutableDictionary *userInfoDict = [NSMutableDictionary dictionary];
            [userInfoDict setObject:uid forKey:@"uid"];
            [userInfoDict setObject:nickname  forKey:@"nickname"];
            [userInfoDict setObject:face forKey:@"face"];
            [userInfoDict setObject:grade forKey:@"grade"];
            [userInfoDict setObject:title forKey:@"title"];
            
            [self changeRoomVC:userInfoDict];
        }

        return NO;
    }
    return YES;
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
    if (![LCMyUser mine].liveUserId) {
        [WatchCutLiveViewController ShowWatchLiveViewController:self.navigationController withInfoDict:userInfoDict withArray:nil withPos:0];
    }
}


- (NSString *)valueForKey:(NSString *)key
           fromQueryItems:(NSArray *)queryItems
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", key];
    NSURLQueryItem *queryItem = [[queryItems
                                  filteredArrayUsingPredicate:predicate]
                                 firstObject];
    return queryItem.value;
}

#pragma mark 后退

- (void) setLeftItem
{
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:2];
    //    UIBarButtonItem *temporaryBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"返回"
    //                                                                              style:UIBarButtonItemStyleDone
    //                                                                             target:self action:@selector(back)];
    
    UIButton *backButton = [[UIButton alloc ]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image =[[UIImage imageNamed:@"navbar_btn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [backButton setImage:image forState:UIControlStateNormal];
    
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height) blendMode:kCGBlendModeNormal alpha:0.7];
    UIImage *neImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [backButton setImage:neImage forState:UIControlStateHighlighted];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    backButton.titleLabel.font  =[UIFont boldSystemFontOfSize:17] ;
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    //    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    
    UIBarButtonItem *closeBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"关闭"
                                                                          style:UIBarButtonItemStyleDone
                                                                         target:self action:@selector(popAction)];
    [closeBarButtonItem setTintColor:[UIColor blackColor]];
    
    [buttons addObject:backItem];
    [buttons addObject:closeBarButtonItem];
    
    self.navigationItem.leftBarButtonItems = buttons;
}

-(void)back
{
    if ([webView canGoBack])
    {
        [self setLeftItem];
        
        [webView goBack];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
