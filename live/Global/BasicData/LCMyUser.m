//
//  KFMyUser.m
//  KaiFang
//
//  Created by Elf Sundae on 14-1-6.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "LCMyUser.h"
#import "LCCore.h"
#import "CustomNotification.h"
#import "XGPush.h"

NSString *const LCMyUserAttentUsersDidUpdateNotification = @"LCMyUserAttentUsersDidUpdateNotification";

static LCMyUser *_sharedMine = nil;

@implementation LCMyUser

+ (instancetype)mine
{
    if (nil == _sharedMine) {
        _sharedMine = [[super alloc] initMine];
    }
    return _sharedMine;
}

- (instancetype)initMine
{
    self = [super init];
    if (self) {
        NSDictionary *dict = [self.userDefaults objectForKey:kUserDefaultsKey_Mine];
        [self fillWithDictionary:dict];
        
         NSDictionary* liveDic = [self.userDefaults objectForKey:kUserDefalutKey_Live];
        [self setLiveFromLocalInfo:liveDic];
//        BOOL flagHasLogged = NO;
//        ESBoolVal(&flagHasLogged, dict[@"flag_has_logged"]);
//        self.flagHasLogged = flagHasLogged;
        
        [LCCore globalCore].newMessageNotifyShowsDetail = ![[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKey_NewsDetail] boolValue];
        [LCCore globalCore].newMessageNotifyPlaySound = ![[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKey_NewsVoice] boolValue];
        [LCCore globalCore].newMessageNotifyPlayVibrate = ![[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKey_NewsVibration] boolValue];
        
        [self _readAttentUsersFromCache];
    }
    return self;
}

- (NSString *)documentsDirectory
{
    NSString *path = ESPathForDocumentsResource([NSString stringWithFormat:@"Users/%@", self.userID]);
    ESTouchDirectoryAtFilePath(path);
    return path;
}

- (BOOL)hasLogged
{
    return ESIsStringWithAnyText(self.userID) && ESIsStringWithAnyText(self.nickname) && ESIsStringWithAnyText(self.faceURL);
}

-(void)setMyPercent:(id)aPercent
{
#if DEBUG && 0
    self.percent = 10;
#else
    float percent = 0;
    ESFloatVal(&percent, aPercent);
    self.percent = percent;
#endif
}

- (float)percent
{
    if (self.isVIP) {
        return 100.f;
    } else {
        return _percent;
    }
}

- (void)_save
{
    NSDictionary *info =
    @{ @"uid" :      (self.userID ?: @""),
       @"imToken":  self.imToken ?: @"",
       @"account" :  (self.account ?: @""),
       @"nickname" : (self.nickname ?: @""),
       @"face" :     (self.faceURL ?: @""),
       @"sex" :      @(self.sex),
       @"birthday" :    (self.birthday ?:@""),
       @"signature":    (self.signature?:@""),
       @"diamond":      @(self.diamond),
       @"fans_total":   @(self.fans_total),
       @"send_diamond": @(self.send_diamond),
       @"atten_total":  @(self.atten_total),
       @"recv_diamond": @(self.recv_diamond),
       @"userLevel":    @(self.userLevel),
       @"userCharm":    @(self.userCharm),
       
       @"prov":  (self.province ?: @""),
       @"city":  (self.city ?: @""),
       @"longitude":     @(self.longitude),
       @"latitude":     @(self.latitude),
       @"a_trade" : self.alipayTradeNo ?: @"",
       @"show_manager": @(self.showManager)
       };
    
    [self.userDefaults setObject:info forKey:kUserDefaultsKey_Mine];
}

- (void)save
{
    ESWeakSelf;
    ESDispatchOnBackgroundQueue(^{
        ESStrongSelf;
        [_self _save];
        NSLog(@"%@",[_self.userDefaults objectForKey:kUserDefaultsKey_Mine]);
    });
}

- (void)saveLiveToLocal{
    if (!self.liveRoomId || !self.liveUserId) {
        return;
    }
    
    NSString* isInLiveRoom;
    if(self.isInLiveRoom){
        isInLiveRoom = @"yes";
    }
    else{
        isInLiveRoom = @"no";
    }
    
    NSString* isInChatRoom;
    if(self.isInChatRoom){
        isInChatRoom = @"yes";
    }
    else{
        isInChatRoom = @"no";
    }
    NSString* liveRoomId = [NSString stringWithFormat:@"%ld", (long)self.liveRoomId];
    NSString* liveType = [NSString stringWithFormat:@"%ld",self.liveType];
    
    NSDictionary* liveDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             isInLiveRoom,@"isInLiveRoom",
                             isInChatRoom,@"isInChatRoom",
                             liveType,@"liveType",
                             liveRoomId,@"liveRoomId",
                             self.chatRoomId,@"chatRoomId",
                             self.liveUserId,@"liveUserId",nil];
    [self.userDefaults setObject:liveDic forKey:kUserDefalutKey_Live];
}

- (void)setLiveFromLocalInfo:(NSDictionary*)live{
    if(live != nil){
        NSString* isInLiveRoom = [live objectForKey:@"isInLiveRoom"];
        if([isInLiveRoom isEqualToString:@"yes"]){
            self.isInLiveRoom = YES;
        }
        else{
            self.isInLiveRoom = NO;
        }
        
        NSString* isInChatRoom = [live objectForKey:@"isInChatRoom"];
        if([isInChatRoom isEqualToString:@"yes"]){
            self.isInChatRoom = YES;
        }
        else{
            self.isInChatRoom = NO;
        }
        
        self.liveType = [[live objectForKey:@"liveType"] intValue];
        self.liveRoomId = [[live objectForKey:@"liveRoomId"] integerValue];
        self.chatRoomId = [live objectForKey:@"chatRoomId"];
        self.liveUserId = [live objectForKey:@"liveUserId"];
    }
}

- (void)resetLiveInfo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* userDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"no",@"isInLiveRoom",
                             @"no",@"isInChatRoom",
                             @"0",@"liveType",
                             @"0",@"liveRoomId",
                             @"0",@"chatRoomId",
                             @"",@"liveUserId",nil];
    [userDefaults setObject:userDic forKey:kUserDefalutKey_Live];
}

- (void)saveCrash:(NSString*)log{
    [self.userDefaults setObject:log forKey:@"crash"];
}

- (NSString*)getCrash{
    NSString* log = [self.userDefaults objectForKey:@"crash"];
    [self.userDefaults setObject:@"" forKey:@"crash"];
    if(log == nil){
        log = @"";
    }
    return log;
}

- (void)resetCrash{
    [self.userDefaults setObject:@"" forKey:@"crash"];
}

- (void)reset
{
    if (_sharedMine) {
        if (![LCCore globalCore].isThirdLogin)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_Exit_Success
                                                            object:_sharedMine.userID
                                                          userInfo:nil];
            [[UIApplication sharedApplication] unregisterForRemoteNotifications];
            [[[LCHTTPClient sharedHTTPClient] operationQueue] cancelAllOperations];
            //            [[[LCJSONClient sharedClient] operationQueue] cancelAllOperations];
        }
        /* Clear cookies */
        [ESApp deleteAllHTTPCookies];
        
        
        // 重置数据库
        [SQLiteInstanceManager reset];
        
        // 删除缓存目录
        //[[NSFileManager defaultManager] removeItemAtPath:self.documentsDirectory error:NULL];
        
        // 删除UserDefaults中不需要保存的键值
        [self.userDefaults removeObjectForKey:kUserDefaultsKey_Mine];
        
        // 删除liveinfo中的保存的键值
        [self.userDefaults removeObjectForKey:kUserDefalutKey_Live];
        
        [self.userDefaults removeObjectForKey:@"crash"];
        _sharedMine = nil;
        [[self class] mine];
        
//        [LCSet reset];
    }
}

- (void)exitApp
{
    
    //直播信息保存
    [self saveLiveToLocal];
    [self save];
    
    usleep(1*1000*1000);
}

#pragma mark - 用户关系缓存
#pragma mark 保存所有已经关注的用户
- (void) saveAllAttentUsers:(NSMutableString *)allUsers
{
    if ([allUsers isKindOfClass:[NSString class]] && ![self.attentUserIdsStr isEqualToString:allUsers]) {
        self.attentUserIdsStr = allUsers;
        [self _saveAttentUsersToCache];
        ESDispatchOnMainThreadAsynchrony(^{
            [[NSNotificationCenter defaultCenter] postNotificationName:LCMyUserAttentUsersDidUpdateNotification object:self.attentUserIdsStr];
        });
    }
}

- (NSString *)attentUsersCacheFilePath
{
    return ESPathForLibraryResource([NSString stringWithFormat:@"attents-%@.cache", self.userID]);
}

- (void)_saveAttentUsersToCache
{
    ESDispatchOnDefaultQueue(^{
        if (ESIsStringWithAnyText(self.attentUserIdsStr)) {
            [self.attentUserIdsStr writeToFile:[self attentUsersCacheFilePath] atomically:YES encoding:NSUTF8StringEncoding error:NULL];
        } else {
            [[NSFileManager defaultManager] removeItemAtPath:[self attentUsersCacheFilePath] error:NULL];
        }
    });
}

- (void)_readAttentUsersFromCache
{
    NSString *cachePath = [self attentUsersCacheFilePath];
    NSString *cacheString = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
        cacheString = [[NSString alloc] initWithContentsOfFile:cachePath encoding:NSUTF8StringEncoding error:NULL];
    }
    cacheString || (cacheString = @"");
    self.attentUserIdsStr = [cacheString mutableCopy];
}

#pragma mark 取消关注用户
- (void) removeAttentUser:(NSString *)userId
{
    if (userId) {
        [XGPush delTag:userId];
    }
    userId = ESStringValue(userId);
    if (ESIsStringWithAnyText(userId)) {
        NSString *old = self.attentUserIdsStr.copy;
        [self.attentUserIdsStr replace:[NSString stringWithFormat:@"%@,", userId] to:@""];
        if (![old isEqualToString:self.attentUserIdsStr]) {
            [self _saveAttentUsersToCache];
            ESDispatchOnMainThreadAsynchrony(^{
                [[NSNotificationCenter defaultCenter] postNotificationName:LCMyUserAttentUsersDidUpdateNotification object:self.attentUserIdsStr];
            });
        }
    }
}

#pragma mark 添加关注用户
- (void) addAttentUser:(NSString *)userId
{
    if (userId) {
        [XGPush setTag:userId];
    }
    userId = ESStringValue(userId);
    if (ESIsStringWithAnyText(userId)) {
        NSString *string = [NSString stringWithFormat:@"%@,", userId];
        if (![self.attentUserIdsStr contains:string]) {
            [self.attentUserIdsStr appendString:string];
            [self _saveAttentUsersToCache];
            ESDispatchOnMainThreadAsynchrony(^{
                [[NSNotificationCenter defaultCenter] postNotificationName:LCMyUserAttentUsersDidUpdateNotification object:self.attentUserIdsStr];
            });
        }
    }
}

#pragma mark 关注列表是否存在此用户
- (BOOL) isAttentUser:(NSString *)userId
{
    userId = ESStringValue(userId);
    NSLog(@"%@", self.attentUserIdsStr);
    return ESIsStringWithAnyText(userId) ? [self.attentUserIdsStr contains:[NSString stringWithFormat:@"%@,", userId]] : NO;
}

#pragma mark - 房间禁言用户


- (void)removeGagUser:(NSString *)userId {
    userId = ESStringValue(userId);
    if (ESIsStringWithAnyText(userId)) {
        NSString *string = [NSString stringWithFormat:@"%@,", userId];
        if (self.gagUserIdsStr) {
            NSRange range = [self.gagUserIdsStr rangeOfString:string];
            if (range.location != NSNotFound) {
                [self.gagUserIdsStr replaceInRange:range to:@""];
            }
        }
    }
}

#pragma mark 添加禁言用户
- (void) addGagUser:(NSString *)userId
{
    userId = ESStringValue(userId);
    if (ESIsStringWithAnyText(userId)) {
        NSString *string = [NSString stringWithFormat:@"%@,", userId];
        if (!self.gagUserIdsStr) {
            self.gagUserIdsStr = [NSMutableString string];
        }
        
        if (![self.gagUserIdsStr contains:string]) {
            [self.gagUserIdsStr appendString:string];
        }
    }
}

#pragma mark 禁言列表是否存在此用户
- (BOOL) isGagUser:(NSString *)userId
{
    userId = ESStringValue(userId);
    return ESIsStringWithAnyText(userId) ? [self.gagUserIdsStr contains:[NSString stringWithFormat:@"%@,", userId]] : NO;
}

#pragma mark 禁言所有用户
- (void) removeAllGagUser
{
    self.gagUserIdsStr = nil;    
}




//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Helper
- (NSUserDefaults *)userDefaults
{
    return [NSUserDefaults standardUserDefaults];
}


@end
