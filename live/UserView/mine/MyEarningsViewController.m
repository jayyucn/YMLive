//
//  我的收益界面
//  MyEarningsViewController.m
//
//  Created by garsonge on 17/2/17.
//


#import "MyEarningsViewController.h"

#import "WXExchangeViewController.h"
#import "FamilyViewController.h"
#import "FAQViewController.h"


@interface MyEarningsViewController()
{
}

@end


@implementation MyEarningsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
     * do any additional setup after loading the view
     */
    // 设置UIButton边框
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace, (CGFloat[]){0, 0, 0, 1});
    
    [_wxExchangeButton.layer setMasksToBounds:YES];
    [_wxExchangeButton.layer setCornerRadius:3.0];
    [_wxExchangeButton.layer setBorderWidth:1.0];
    [_wxExchangeButton.layer setBorderColor:colorref];
    
    [_bankExchangeButton.layer setMasksToBounds:YES];
    [_bankExchangeButton.layer setCornerRadius:3.0];
    [_bankExchangeButton.layer setBorderWidth:1.0];
    [_bankExchangeButton.layer setBorderColor:colorref];
    
    [_diaExchangeButton.layer setMasksToBounds:YES];
    [_diaExchangeButton.layer setCornerRadius:3.0];
    [_diaExchangeButton.layer setBorderWidth:1.0];
    [_diaExchangeButton.layer setBorderColor:colorref];
    
    [_aliExchangeButton.layer setMasksToBounds:YES];
    [_aliExchangeButton.layer setCornerRadius:3.0];
    [_aliExchangeButton.layer setBorderWidth:1.0];
    [_aliExchangeButton.layer setBorderColor:colorref];
    
    [_familyManageButton.layer setMasksToBounds:YES];
    [_familyManageButton.layer setCornerRadius:3.0];
    [_familyManageButton.layer setBorderWidth:1.0];
    [_familyManageButton.layer setBorderColor:colorref];
    
    // 获取用户兑换信息
    [self getUserExchangeInfo];
}

- (void)dealloc
{
    // if needed
}

// 更新视图
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"JoyYou-YMLive :: refresh current view");
    
    // 更新用户兑换信息
    [self getUserExchangeInfo];
    
    _numOfDiamond.text = [LCMyUser mine].curDiamond;
    _numOfHana.text = [LCMyUser mine].recvDiamond;
}


// 回退到上一层界面
- (IBAction)backToPreviousView
{
    UIViewController *previousVC = self.presentingViewController;
    
    [previousVC dismissViewControllerAnimated:YES completion:NULL];
}

// 打开微信兑换web页面
- (IBAction)openWXExchangeView
{
    WXExchangeViewController *viewController = [[WXExchangeViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

// 打开家族管理web页面
- (IBAction)openFamilyView
{
    FamilyViewController *viewController = [[FamilyViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

// 打开常见问题界面
- (IBAction)openFAQView
{
    FAQViewController *viewController = [[FAQViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}


// 获取用户兑换信息
- (void)getUserExchangeInfo
{
    LCRequestSuccessResponseBlock successBlock = ^(NSDictionary *responseDic)
    {
        NSLog(@"JoyYou-YMLive :: requset exchange info with response = %@", [self dicToJson:responseDic]);
        
        NSInteger code = [[responseDic objectForKey:@"stat"] integerValue];
        // 请求成功
        if (URL_REQUEST_SUCCESS == code)
        {
            NSLog(@"JoyYou-YMLive :: requset exchange info succeeded");
            
            NSInteger numOfDiamond = -1;
            NSInteger numOfRecDia = -1;
            
            if ([responseDic objectForKey:@"diamond"])
            {
                numOfDiamond = [[responseDic objectForKey:@"diamond"] integerValue];
            }
            if ([responseDic objectForKey:@"recv_diamond"])
            {
                numOfRecDia = [[responseDic objectForKey:@"recv_diamond"] integerValue];
            }
            
            if ([responseDic objectForKey:@"anchor_type"])
            {
                _anchorType = [responseDic objectForKey:@"anchor_type"];
                NSLog(@"JoyYou-YMLive :: anchor_type = %@", _anchorType);
            }
            
            if ([responseDic objectForKey:@"exchange_money_rate"])
            {
                [LCMyUser mine].rmtToHana = [[responseDic objectForKey:@"exchange_money_rate"] integerValue];
            }
            if ([responseDic objectForKey:@"exchange_diamond_rate"])
            {
                [LCMyUser mine].diaToHana = [[responseDic objectForKey:@"exchange_diamond_rate"] integerValue];
            }
            
            [LCMyUser mine].curDiamond = [NSString stringWithFormat:@"%ld", numOfDiamond];
            [LCMyUser mine].recvDiamond = [NSString stringWithFormat:@"%ld", numOfRecDia];
            NSLog(@"JoyYou-YMLive :: curDiamond = %@ && recvDiamond = %@", [LCMyUser mine].curDiamond, [LCMyUser mine].recvDiamond);
            
            _numOfDiamond.text = [LCMyUser mine].curDiamond;
            _numOfHana.text = [LCMyUser mine].recvDiamond;
            
            if (![_anchorType isEqualToString:@"5"])
            {
                _familyManageButton.hidden = YES;
                _familyManageImg.hidden = YES;
            }
            
            if ([[responseDic objectForKey:@"alipay_status"] intValue] == 0)
            {
                _aliExchangeButton.hidden = YES;
                _aliExchangeImg.hidden = YES;
            }
            if ([[responseDic objectForKey:@"wxpay_status"] intValue] == 0)
            {
                _wxExchangeButton.hidden = YES;
                _wxExchangeImg.hidden = YES;
            }
            if ([[responseDic objectForKey:@"lianlianpay_status"] intValue] == 0)
            {
                _bankExchangeButton.hidden = YES;
                _bankExchangeImg.hidden = YES;
            }
            if ([[responseDic objectForKey:@"diamond_status"] intValue] == 0)
            {
                _diaExchangeButton.hidden = YES;
                _diaExchangeImg.hidden = YES;
            }
        }
        else
        {
            NSLog(@"JoyYou-YMLive :: requset exchange info failed");
        }
    };
    
    LCRequestFailResponseBlock failBlock = ^(NSError *error)
    {
        NSLog(@"JoyYou-YMLive :: requset exchange info with error = %@", error.description);
    };
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:nil
                                                  withPath:URL_EXCHANGE_INFO
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}


// dic2json
- (NSString *)dicToJson:(NSDictionary *)dic
{
    NSError * parseError = nil;
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonStr;
}

@end
