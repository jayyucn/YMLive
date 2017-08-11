//
//  PlayCallBackViewController.h
//  qianchuo
//
//  Created by jacklong on 16/8/8.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//
 

@interface PlayCallBackViewController : UIViewController

@property (nonatomic, strong) NSString *playerCallBackUrl;// 回放的url地址
@property (nonatomic, strong) NSString *playVdoid;  // 点播id
@property (nonatomic, strong) NSString *playerUid;  // 回放的用户id
@property (nonatomic, strong) NSDictionary *playBackDict;

@property (nonatomic, assign) BOOL  isAgainLoad;
@end
