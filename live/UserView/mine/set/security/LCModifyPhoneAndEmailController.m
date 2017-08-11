//
//  LCModifyPhoneAndEmailController.m
//  XCLive
//
//  Created by ztkztk on 14-4-28.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCModifyPhoneAndEmailController.h"

@interface LCModifyPhoneAndEmailController ()

@end

@implementation LCModifyPhoneAndEmailController


-(void)dealloc
{
//    [[LCHTTPClient sharedHTTPClient] cancelAllHTTPOperationsWithMethod:nil path:modifyPhoneAndEmailURL()];
    
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
    self.navigationItem.rightBarButtonItem.customView.hidden=NO;
}

-(void)nextAction
{
    
}

-(void)requestModify:(NSDictionary *)modifyDic
{
//    ESWeakSelf;
//    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
//        ESStrongSelf;
//        NSLog(@"gagresponseDic=%@",responseDic);
//        int stat=[responseDic[@"stat"] intValue];
//        if(stat==200)
//        {
//            [[LCMyUser mine] setMyPercent:responseDic[@"percent"]];
//            [[LCSet mineSet] modifySet:modifyDic];
//            [[LCMyUser mine] modifyInfo:modifyDic];
//            [_self nextAction];
//        }
//        else{
//            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
//        }
//    };
//    
//    LCRequestFailResponseBlock failBlock=^(NSError *error){
//        NSLog(@"gagerror=%@",error);
//        [LCNoticeAlertView showMsg:@"请检查网络状态"];
//        
//    };
//    
//    [[LCHTTPClient sharedHTTPClient] requestWithParameters:modifyDic
//                                                  withPath:modifyPhoneAndEmailURL()
//                                               withRESTful:POST_REQUEST
//                                          withSuccessBlock:successBlock
//                                             withFailBlock:failBlock];
//
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
