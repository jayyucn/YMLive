//
//  ShowWebViewController.h
//  qianchuo
//
//  Created by jacklong on 16/4/18.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "LCViewController.h"

@interface ShowWebViewController : LCViewController

@property (nonatomic, assign)BOOL    isShowRightBtn;
@property (nonatomic, copy)NSString  *rightBtnTitleStr;

@property (nonatomic, copy)NSString  *webTitleStr;
@property (nonatomic, copy)NSString  *webUrlStr;

@end
