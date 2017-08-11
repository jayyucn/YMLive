//
//  RobRedPacketViewController.h
//  qianchuo
//
//  Created by jacklong on 16/4/14.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

@interface RobRedPacketViewController : UIViewController <UIGestureRecognizerDelegate>

+ (BOOL) isShowRedPacket;

+ (void) isCloseRedPacket;

@property (nonatomic, strong) NSMutableDictionary *redBagInfoDict;

@property (nonatomic, strong) NSDictionary *bagInfoDict;

@property (nonatomic, assign) BOOL isShowDetail;

@end
