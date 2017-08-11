//
//  KFMyUser.h
//  KaiFang
//
//  Created by Elf Sundae on 14-1-6.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "LCUser.h"

/// 我的“关注”列表已更新,
FOUNDATION_EXTERN NSString *const LCMyUserAttentUsersDidUpdateNotification;

@interface LCMyUser : LCUser

@property (nonatomic)float percent;
//
@property (nonatomic, copy) NSString *videoURL;

+ (instancetype)mine;

- (NSString *)documentsDirectory;
- (BOOL)hasLogged;

// 临时用的变量,后面再优化注册,登录,主界面逻辑.
// 这个变量的意思是以前至少进来过一次MainController, 用户自动登录
//@property (nonatomic) BOOL flagHasLogged;

-(void)setMyPercent:(id)aPercent;
/// 保存文件
/// @warning 仅在真正需要保存文件时才调用该方法,例如从服务端更新最新数据
- (void)save;
/// 注销时调用
- (void)reset;

// 保存直播信息到本地
- (void)saveLiveToLocal;

- (void)setLiveFromLocalInfo:(NSDictionary*)live;

- (void)resetLiveInfo;

- (void)saveCrash:(NSString*)log;

- (NSString*)getCrash;

- (void)resetCrash;

- (void)exitApp;

#pragma mark - 用户关系缓存
#pragma mark 保存所有已经关注的用户
- (void) saveAllAttentUsers:(NSMutableString *)allUsers;
#pragma mark 取消关注用户
- (void) removeAttentUser:(NSString *)userId;
#pragma mark 添加关注用户
- (void) addAttentUser:(NSString *)userId;
#pragma mark 关注列表是否存在此用户
- (BOOL) isAttentUser:(NSString *)userId;

#pragma mark - 禁言用户列表
- (void) removeGagUser:(NSString *)userId;
#pragma mark 添加禁言用户
- (void) addGagUser:(NSString *)userId;
#pragma mark 禁言列表是否存在此用户
- (BOOL) isGagUser:(NSString *)userId;
#pragma mark 禁言所有用户
- (void) removeAllGagUser;


// 当前正在进行中的支付宝trade No.
// 临时变量,不保存userDefault
@property (nonatomic, copy) NSString *alipayTradeNo;

@property (nonatomic, assign) BOOL diamondPay;


/// Helper for [NSUserDefaults standardUserDefaults]
- (NSUserDefaults *)userDefaults;

/**
 * Sigleton
 */
+ (id)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (id)new __attribute__((unavailable("new not available, call sharedInstance instead")));
- (id)init __attribute__((unavailable("init not available, call sharedInstance instead")));
- (id)initWithFrame:(CGRect)frame __attribute__((unavailable("init not available, call sharedInstance instead")));

@end
