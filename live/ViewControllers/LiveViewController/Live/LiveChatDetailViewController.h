//
//  LiveChatDetailViewController.h
//  qianchuo
//
//  Created by 林伟池 on 16/7/5.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface LiveChatDetailViewController : RCConversationViewController

@property (nonatomic , strong) UINavigationController *mNavigationController;

@property (nonatomic , assign) CGRect viewFrame;

@property (nonatomic , strong) UIBarButtonItem *lyLeftBarButtonItem;

- (instancetype)initWithConversationModel:(RCConversationModel *)model;
- (instancetype)initWithUserID:(NSString *)userID nickname:(NSString *)nickname avatar:(NSString *)avatar;
/// dictionary: uid, nickname, face
- (instancetype)initWithUserInfoDictionary:(NSDictionary *)dictionary;

- (void)pushFromNavigationController:(UINavigationController *)navigationController animated:(BOOL)animated;
//- (void)presentAnimated:(BOOL)animated completion:(dispatch_block_t)completion;
@end
