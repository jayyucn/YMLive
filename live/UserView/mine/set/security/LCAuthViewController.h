//
//  LCAuthViewController.h
//  XCLive
//
//  Created by ztkztk on 14-4-28.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCViewController.h"
#import "RTLabel.h"

#import "LCCustomBackItemController.h"


@interface LCAuthViewController : LCCustomBackItemController<UITextFieldDelegate>
@property (nonatomic,strong)RTLabel *message;
@property (nonatomic,strong)ESButton *againBtn;
@property (nonatomic,strong)ESButton *authBtn;
@property (nonatomic,strong)NSTimer *myTimer;
@property (nonatomic)int timeNumber;

-(void)showVerify;
-(void)startRequestCode;
-(void)failedRequest;

-(void)requestVerifying;

@end
