//
//  QCDiamondMallViewController.m
//  qianchuo 购买钻石商场
//
//  Created by jacklong on 16/4/26.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "QCDiamondMallViewController.h"
#import "MallDiamondCell.h"
#import "WXPayManager.h"
#import "RMStore.h"

#import <AlipaySDK/AlipaySDK.h>
#import <AlipaySDK/Order.h>
#import <AlipaySDK/DataSigner.h>

#import <CommonCrypto/CommonCryptor.h>

@interface QCDiamondMallViewController()
{
    int myDiamond;// 我的钻石
}

@end



@implementation QCDiamondMallViewController

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=ESLocalizedString(@"我的钻石");

    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled=YES;
    
    [self loadDiamond];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMyDiamondView) name:LCUserLiveDiamondDidChangeNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.tableView indexPathForSelectedRow])
    {
        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    }
}


// 获取购买钻石列表
-(void)loadDiamond
{
    ESWeakSelf;
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        NSLog(@"getFansList =%@",responseDic);
        
        ESStrongSelf;
        
        int stat=[responseDic[@"stat"] intValue];
        if(stat==200)
        {
            if (_self.list.count > 0) {
                [_self.list removeAllObjects];
            }
            
            myDiamond = [responseDic[@"diamond"] intValue];
            
            [_self.list addObjectsFromArray:responseDic[@"coins"]];
            
            [_self.tableView reloadData];
            
            
            [LCMyUser mine].diamond = myDiamond;
            
            [_self updateMyDiamondView];
        } else {
          
        }
        _self.isLoadingMore=NO;
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        NSLog(@"fans list error =%@",error);
        
        ESStrongSelf;
        _self.isLoadingMore=NO;
    };
    
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"pf":@"ios", 
                                                             @"jailbroken":[NSNumber numberWithInt:([UIDevice isJailbroken] ? 1 : 0)]}
                                                  withPath:URL_BUY_DIAMOND
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
    
}


#pragma mark - tableview head
- (void) updateMyDiamondView
{
    UIView *myDiamondView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    myDiamondView.backgroundColor = [UIColor whiteColor];
    
    UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 60, 50)];
    promptLabel.text = ESLocalizedString(@"账户余额");
    promptLabel.textColor = [UIColor blackColor];
    promptLabel.font = [UIFont systemFontOfSize:14];
    [myDiamondView addSubview:promptLabel];
    
    UIImage *diamondImage = [UIImage imageNamed:@"image/liveroom/me_myaccount_reddiamond"];
    
    UIImageView *iconDiamondImageView = [[UIImageView alloc] initWithFrame:CGRectMake(promptLabel.right, 0, diamondImage.size.width, diamondImage.size.height)];
    iconDiamondImageView.image = diamondImage;
    iconDiamondImageView.centerY = 25;
    [myDiamondView addSubview:iconDiamondImageView];
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconDiamondImageView.right+5, 0, 150, 50)];
    moneyLabel.centerY = 25;
    moneyLabel.text = [NSString stringWithFormat:@"%d",[LCMyUser mine].diamond];
    moneyLabel.font = [UIFont boldSystemFontOfSize:15];
    moneyLabel.textColor =  ColorPink;
    moneyLabel.tag = 9527;
    [myDiamondView addSubview:moneyLabel];
    
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 30)];
    headView.backgroundColor = ColorBackGround;
    [myDiamondView addSubview:headView];
    
    UILabel *promptRechargeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 30)];
    promptRechargeLabel.textColor = [UIColor grayColor];
    promptRechargeLabel.font = [UIFont systemFontOfSize:12];
    promptRechargeLabel.text = ESLocalizedString(@"充值:");
    [headView addSubview:promptRechargeLabel];
    
    self.tableView.tableHeaderView = myDiamondView;
}


#pragma mark - Table view data source
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
    static NSString *identifier=@"buy_diamond_cell";
    
    MallDiamondCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[MallDiamondCell alloc]  initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:identifier];
        
        // 取消选择模式
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    cell.diamondInfoDict = self.list[indexPath.row];
    return cell;
}



#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *payInfoDict = self.list[indexPath.row];
    
    if ([LCCore globalCore].isAppStoreReviewing) {
        [self payGoodsViaIAP:payInfoDict];
    } else {
        int money = [payInfoDict[@"money"] intValue];
        ESWeakSelf;
        UIActionSheet *action = [UIActionSheet actionSheetWithTitle:ESLocalizedString(@"选择支付方式") cancelButtonTitle:ESLocalizedString(@"取消") didDismissBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex)
                                 {
                                     ESStrongSelf;
                                     if (0 == buttonIndex)
                                     {
                                         [[WXPayManager wxPayManager] sendPay:[NSMutableDictionary dictionaryWithDictionary:payInfoDict]];
                                     }
                                     else if(1 == buttonIndex)
                                     {
                                         [_self payGoodsViaAlipay:payInfoDict];
                                     }
                                     else if(2 == buttonIndex)
                                     {
                                         [_self payGoodsViaIAP:payInfoDict];
                                     }
                                 } otherButtonTitles:[NSString stringWithFormat:@"%@(￥%d)",ESLocalizedString(@"微信支付"), money],[NSString stringWithFormat:@"%@(￥%d)", ESLocalizedString(@"支付宝") , money],[NSString stringWithFormat:@"%@(￥%d)", ESLocalizedString(@"苹果支付"), money], nil];
        [action showInView:self.view];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}




#pragma mark - 支付

#pragma mark - 苹果支付

- (void)payGoodsViaIAP:(NSDictionary *)payInfoDict
{
    if (![RMStore canMakePayments]) {
        [UIAlertView showWithTitle:ESLocalizedString(@"支付失败(#100)") message:nil];
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[ESApp keyWindow] animated:YES];
    hud.labelText = ESLocalizedString(@"支付正在进行中...");
    hud.detailsLabelText = ESLocalizedString(@" 请在完成前不要离开当前界面 ");
    hud.removeFromSuperViewOnHide = YES; 
    [[RMStore defaultStore] addPayment:payInfoDict[@"iap_id"]
                                  user:[LCMyUser mine].userID
                               success:^(SKPaymentTransaction *transaction)
     {
         [hud hide:NO];
         
         // 更新profile
         [[LCCore globalCore] updateMyProfile];
         UILabel* moneyLabel = (UILabel *)[self.tableView.tableHeaderView viewWithTag:9527];
         moneyLabel.text = [NSString stringWithFormat:@"%d",[LCMyUser mine].diamond];
         
         
         [UIAlertView showWithTitle:ESLocalizedString(@"购买成功！") message:nil];
         
     } failure:^(SKPaymentTransaction *transaction, NSError *error) {
         NSLog(@"%@", error);
         
         [hud hide:NO];
         NSString *errorAlert = [NSString stringWithFormat: @"%@ (#%@)", ESLocalizedString(@"支付失败"), @(error.code)];
         [UIAlertView showWithTitle:errorAlert message:nil];
     }];
}

//- (void)restoreTransaction
//{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    ESWeakSelf;
//    void (^_restoreCompleted)(void) = ^() {
//        ESStrongSelf;
//        [MBProgressHUD hideHUDForView:_self.view animated:NO];
//    };
//    
//    if ([[SKPaymentQueue defaultQueue] respondsToSelector:@selector(restoreCompletedTransactionsWithApplicationUsername:)]) {
//        [[RMStore defaultStore] restoreTransactionsOfUser:[LCMyUser mine].userID onSuccess:_restoreCompleted failure:^(NSError *error) {
//            _restoreCompleted();
//        }];
//    } else {
//        [[RMStore defaultStore] restoreTransactionsOnSuccess:_restoreCompleted failure:^(NSError *error) {
//            _restoreCompleted();
//        }];
//    }
//}



#pragma mark - Alipay

- (void)payGoodsViaAlipay:(NSDictionary *)payInfoDict
{    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[ESApp keyWindow] animated:YES];
    hud.labelText = ESLocalizedString(@"支付正在进行中...");
    hud.detailsLabelText = ESLocalizedString(@" 请在完成前不要离开当前界面 ");
    hud.removeFromSuperViewOnHide = YES;
    
    NSString *tradeNO = [self generateTradeNO];
    [LCMyUser mine].alipayTradeNo = tradeNO;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:tradeNO forKey:@"out_trade_no"];
    [params setObject:[NSString stringWithFormat:@"%d",[payInfoDict[@"money"] intValue]] forKey:@"money"];
    [params setObject:[NSString stringWithFormat:@"%d",[payInfoDict[@"diamond"] intValue]] forKey:@"diamond"];
    [params setObject:@"ios" forKey:@"pf"];
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = PartnerID;
    NSString *seller = SellerID;
//    NSString *privateKey = PartnerPrivKey;
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = tradeNO; //订单ID（由商家自行制定）
    order.productName = ESLocalizedString(@"购买钻石"); //商品标题
    order.productDescription = [NSString stringWithFormat:@"%@%d", ESLocalizedString(@"购买钻石"), [payInfoDict[@"diamond"] intValue]]; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",[payInfoDict[@"money"] floatValue]]; //商品价格
    order.notifyURL =  NotifyURL; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    [params setObject:orderSpec forKey:@"order_desc"];
    
    ESWeakSelf;
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        [hud hide:NO];
        
        NSLog(@"aliorder %@",responseDic);
        
        ESStrongSelf;
        int stat = 0;
        if (ESIntVal(&stat, responseDic[@"stat"]) && 200 == stat) {
            //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
            NSString *appScheme = @"alith";
            
//            //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//            id<DataSigner> signer = CreateRSADataSigner(privateKey);
//            NSString *nativeSignedString= [signer signString:orderSpec];
            
            NSString *signedString = responseDic[@"sign"];
//            NSLog(@"signedString %@  nativeSignedString: %@",signedString,nativeSignedString);
//            if ([signedString isEqualToString:nativeSignedString]) {
//                NSLog(@"sign is equals");
//            } else {
//                NSLog(@"sign not equals");
//            }
            
            
            //将签名成功字符串格式化为订单字符串,请严格按照该格式
            NSString *orderString = nil;
            if (signedString != nil) {
                orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                               orderSpec, signedString, @"RSA"];
                
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    NSLog(@"pay result %@",resultDic);
                    if ([resultDic[@"resultStatus"] intValue] == 9000) {
                        [QCDiamondMallViewController alipaymentResultSucc];
                    } else {
                        [LCNoticeAlertView showMsg:ESLocalizedString(@"支付失败！")];
                    }
                }];
            }
        } else {
            NSString *msg = nil;
            ESStringVal(&msg, responseDic[@"msg"]);
            if (ESIsStringWithAnyText(msg))
            {
                [UIAlertView showWithTitle:msg message:nil];
            }
        }
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        NSLog(@"pay info error =%@",error);
        [hud hide:NO];
    };
    
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:params
                                                  withPath:@"pay/aliorder"
                                               withRESTful:POST_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
    
}


+ (void)aliPaymentResultHandler:(id)res
{
    NSString *resultString = nil;
    if ([res isKindOfClass:[NSURL class]]) {
        // 从openURL回调
        NSURL *url = (NSURL *)res;
        if ([[url absoluteString] rangeOfString:@"safepay"].location != NSNotFound) {
            resultString = [[url absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
          
            NSLog(@"decode pay result:%@",resultString);
        } else {
            return;
        }
    } else if ([res isKindOfClass:[NSString class]]) {
         NSLog(@"web pay");
        // 网页支付回调
        resultString = (NSString *)res;
    }
    
    
    NSLog(@"pay result:%@",resultString);
    if (!ESIsStringWithAnyText(resultString)) {
        return;
    }
    
    if ([resultString rangeOfString:@"\"ResultStatus\":\"9000\""].location != NSNotFound) {
        NSLog(@"update diamond");
        [QCDiamondMallViewController alipaymentResultSucc];
    }
    
}
 
+ (void)alipaymentResultSucc
{
    NSString *tradeNo = [LCMyUser mine].alipayTradeNo;
    [LCMyUser mine].alipayTradeNo = nil;
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"out_trade_no" : tradeNo} withPath:@"pay/success" withRESTful:POST_REQUEST withSuccessBlock:^(NSDictionary *responseDic) {
        NSLog(@"%@", responseDic);
        
        if ([responseDic[@"stat"] intValue] == 200) {
            [LCMyUser mine].diamond = [responseDic[@"diamond"] intValue];
        }
    } withFailBlock:^(NSError *error) {
        NSLog(@"error %@", error);
    }];
    
    // 交易成功
    [UIAlertView showWithTitle:ESLocalizedString(@"支付成功!") message:nil];
}

- (NSString *)generateTradeNO
{
//    const int N = 15;
    srand((unsigned)time(0));
    int randNum = arc4random() % 10000;
    NSString * timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970] * 1000 * 1000];

    NSString *sourceString = [NSString stringWithFormat:@"%@%d%@",[LCMyUser mine].userID,randNum,timestamp];
//    NSMutableString *result = [[NSMutableString alloc] init];
//    
//    for (int i = 0; i < N; i++)
//    {
//        int num = rand();
//        unsigned index = num % [sourceString length];
//        NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
//        [result appendString:s];
//    }
    return sourceString;
}
 
@end
