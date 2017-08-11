//
//  LiveMsgManager.m
//  房间消息管理
//
//  Created by jacklong on 16/3/10.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "LiveMsgManager.h"

@implementation LiveMsgManager

// 送礼物
+ (void) sendGiftMsg:(NSDictionary *)giftDict andSucc:(LiveMsgManagerSucc)succ andFail:(LiveMsgManagerFail)fail
{
    if ([[LCMyUser mine].userID isEqualToString:@"18462369"]) {// app store 测试ID
        return;
    }
//    NSMutableDictionary *socket = [NSMutableDictionary dictionary];
//    socket[@"type"] = LIVE_GROUP_GIFT;                      // 消息类型
//    socket[@"uid"] = [LCMyUser mine].userID;        // 用户id
//    socket[@"nickname"] = [LCMyUser mine].nickname; // 用户昵称
//    socket[@"grade"] = [NSNumber numberWithInt:[LCMyUser mine].userLevel];  // 用户级别
//    socket[@"face"] = [LCMyUser mine].faceURL;      // 用户头像
//    socket[@"gift_id"] = giftDict[@"gift_id"];      // 礼物id
//    socket[@"gift_nums"] = giftDict[@"gift_nums"];   // 礼物数目
//    socket[@"gift_type"] = giftDict[@"gift_type"];       // 礼物类型
//    socket[@"gift_name"] = giftDict[@"gift_name"];       // 礼物名称
//    socket[@"recv_diamond"] = giftDict[@"recv_diamond"]; // 收到的钻石
//    sendGift[@"price"] = giftDic[@"price"];              // 礼物价格
    
    [LiveMsgManager sendMsg:giftDict andMsgType:LIVE_GROUP_GIFT Succ:succ andFail:fail];
}

// 发送聊天消息
+ (void) sendChatMsg:(NSDictionary *)msgDict andSucc:(LiveMsgManagerSucc)succ andFail:(LiveMsgManagerFail)fail
{
    if ([[LCMyUser mine].userID isEqualToString:@"18462369"]
            || [LCMyUser mine].isServerFilterAD) {// app store 测试ID或是广告状态
        return;
    }
//      NSMutableDictionary *socket = [NSMutableDictionary dictionary];
//    socket[@"type"] = LIVE_GROUP_CHAT_MSG;                      // 消息类型
//    socket[@"uid"] = [LCMyUser mine].userID;        // 用户id
//    socket[@"nickname"] = [LCMyUser mine].nickname; // 用户昵称
//    socket[@"grade"] = [NSNumber numberWithInt:[LCMyUser mine].userLevel];  // 用户级别
//    socket[@"face"] = [LCMyUser mine].faceURL;      // 用户头像
//    socket[@"chat_msg"] = msg;                      // 聊天内容
    
    [LiveMsgManager sendMsg:msgDict andMsgType:LIVE_GROUP_CHAT_MSG Succ:succ andFail:fail];
}

// 发送系统消息
+ (void) sendSystemMsg:(NSDictionary *)systemDict andSucc:(LiveMsgManagerSucc)succ andFail:(LiveMsgManagerFail)fail
{
//    NSMutableDictionary *socket = [NSMutableDictionary dictionary];
//    socket[@"type"] = LIVE_GROUP_SYSTEM_MSG;                    // 消息类型
//    socket[@"system_content"] = msg;                // 系统消息
    
    [LiveMsgManager sendMsg:systemDict andMsgType:LIVE_GROUP_SYSTEM_MSG Succ:succ andFail:fail];
}

// 发送进入房间消息
+ (void) sendEnterRoomSucc:(LiveMsgManagerSucc)succ andFail:(LiveMsgManagerFail)fail
{
    NSMutableDictionary *socket = [NSMutableDictionary dictionary];
    socket[@"type"] = LIVE_GROUP_ENTER_ROOM;                      // 消息类型
    socket[@"uid"] = [LCMyUser mine].userID;        // 用户id
    socket[@"nickname"] = [LCMyUser mine].nickname; // 用户昵称
    socket[@"grade"] = [NSNumber numberWithInt:[LCMyUser mine].userLevel];  // 用户级别
    socket[@"face"] = [LCMyUser mine].faceURL;      // 用户头像
    socket[@"welcome_msg"] = [NSString stringWithFormat:@"欢迎%@",[LCMyUser mine].nickname];                      // 欢迎内容
    socket[@"total"] = @([LCMyUser mine].liveOnlineUserCount);
    socket[@"zuojia"] = @([LCMyUser mine].zuojia);
    socket[@"offical"] = @([LCMyUser mine].showManager?1:0);
    if ([LCMyUser mine].wanjiaMedalArray && [LCMyUser mine].wanjiaMedalArray.count > 0) {
      socket[@"wanjia_medal"] = [LCMyUser mine].wanjiaMedalArray;
    }
    
    [LiveMsgManager sendMsg:socket andMsgType:LIVE_GROUP_ENTER_ROOM Succ:succ andFail:fail];
}

// 发送退出房间消息
+ (void) sendQuitRoom:(NSDictionary *)systemDict andSucc:(LiveMsgManagerSucc)succ andFail:(LiveMsgManagerFail)fail
{
//    NSMutableDictionary *socket = [NSMutableDictionary dictionary];
//    socket[@"type"] = LIVE_GROUP_EXIT_ROOM;                      // 消息类型
//    socket[@"uid"] = [LCMyUser mine].userID;        // 用户id
    
    [LiveMsgManager sendMsg:systemDict andMsgType:LIVE_GROUP_EXIT_ROOM Succ:succ andFail:fail];
}

// 发送关注消息
+ (void) sendAttentMsg:(NSDictionary *)attentDict Succ:(LiveMsgManagerSucc)succ andFail:(LiveMsgManagerFail)fail
{
//    NSMutableDictionary *socket = [NSMutableDictionary dictionary];
//    socket[@"type"] = LIVE_GROUP_ATTENT;                      // 消息类型
//    socket[@"uid"] = [LCMyUser mine].userID;        // 用户id
//    socket[@"nickname"] = [LCMyUser mine].nickname; // 用户昵称
    [LiveMsgManager sendMsg:attentDict andMsgType:LIVE_GROUP_ATTENT Succ:succ andFail:fail];
}

// 用户升级
+ (void) sendUserUpGrade:(NSDictionary *)upgradeDict Succ:(LiveMsgManagerSucc)succ andFail:(LiveMsgManagerFail)fail
{
//    NSMutableDictionary *socket = [NSMutableDictionary dictionary];
//    socket[@"type"] = LIVE_GROUP_UPGRADE;                    // 消息类型
//    socket[@"uid"] = [LCMyUser mine].userID;        // 用户id
//    socket[@"nickname"] = [LCMyUser mine].nickname; // 用户昵称
//    socket[@"grade"] = [NSNumber numberWithInt:[LCMyUser mine].userLevel];  // 用户级别
    [LiveMsgManager sendMsg:upgradeDict andMsgType:LIVE_GROUP_UPGRADE Succ:succ andFail:fail];

}

// 用户点亮
+ (void) sendLightUp:(NSDictionary *)socket UserLoveSucc:(LiveMsgManagerSucc)succ andFail:(LiveMsgManagerFail)fail
{
    [LiveMsgManager sendMsg:socket andMsgType:LIVE_GROUP_USER_LOVE Succ:succ andFail:fail];
}

// 用户弹幕
+ (void) sendUserBarrageMsg:(NSString *)msg Succ:(LiveMsgManagerSucc)succ andFail:(LiveMsgManagerFail)fail
{
    if ([LCMyUser mine].isServerFilterAD) {
        return;
    }
    
    NSMutableDictionary *socket = [NSMutableDictionary dictionary];
    socket[@"type"] = LIVE_GROUP_BARRAGE;                    // 消息类型
    socket[@"uid"] = [LCMyUser mine].userID;        // 用户id
    socket[@"nickname"] = [LCMyUser mine].nickname; // 用户昵称
    socket[@"face"] = [LCMyUser mine].faceURL;      // 用户头像
    socket[@"grade"] = [NSNumber numberWithInt:[LCMyUser mine].userLevel];  // 用户级别
    socket[@"chat_msg"] = msg;                      // 聊天内容
    socket[@"offical"] = @([LCMyUser mine].showManager?1:0);
    [LiveMsgManager sendMsg:socket andMsgType:LIVE_GROUP_BARRAGE Succ:succ andFail:fail];
}

// 禁言用户
+ (void) sendGagInfo:(NSDictionary *)gagInfoDict  Succ:(LiveMsgManagerSucc)succ andFail:(LiveMsgManagerFail)fail
{
//    NSMutableDictionary *socket = [NSMutableDictionary dictionary];
//    socket[@"type"] = LIVE_GROUP_REMOVE_GAG;                       // 消息类型
//    socket[@"uid"] = user;                       // 用户id
    [LiveMsgManager sendMsg:gagInfoDict andMsgType:LIVE_GROUP_GAG Succ:succ andFail:fail];
}

// 解除禁言
+ (void) removeGagInfo:(NSDictionary *)removeGagInfoDict Succ:(LiveMsgManagerSucc)succ andFail:(LiveMsgManagerFail)fail
{
//    NSMutableDictionary *socket = [NSMutableDictionary dictionary];
//    socket[@"type"] = LIVE_GROUP_REMOVE_GAG;                       // 消息类型
//    socket[@"uid"] = user;                       // 用户id
    [LiveMsgManager sendMsg:removeGagInfoDict andMsgType:LIVE_GROUP_REMOVE_GAG Succ:succ andFail:fail];
}

// 设置管理员
+ (void) sendManagerInfo:(NSDictionary *)managerInfoDict Succ:(LiveMsgManagerSucc)succ andFail:(LiveMsgManagerFail)fail
{
//    NSMutableDictionary *socket = [NSMutableDictionary dictionary];
//    socket[@"uid"] = user.userId;                    // 收到用户id
//    socket[@"nickname"] = user.nickname;            // 用户名称
    [LiveMsgManager sendMsg:managerInfoDict andMsgType:LIVE_GROUP_MANAGER Succ:succ andFail:fail];
}

// 解除管理员
+ (void) sendRemoveManagerInfo:(NSDictionary *)removeManagerInfoDict Succ:(LiveMsgManagerSucc)succ andFail:(LiveMsgManagerFail)fail
{
//    NSMutableDictionary *socket = [NSMutableDictionary dictionary];
//    socket[@"uid"] = user.userId;            // 收到用户id
    [LiveMsgManager sendMsg:removeManagerInfoDict andMsgType:LIVE_GROUP_REMOVE_MANAGER Succ:succ andFail:fail];
}

// 分享直播间
+ (void) shareRoomInfo:(NSDictionary *)shareInfoDict Succ:(LiveMsgManagerSucc)succ andFail:(LiveMsgManagerFail)fail
{
//    NSMutableDictionary *socket = [NSMutableDictionary dictionary];
//    socket[@"type"] = LIVE_GROUP_SHARE;
//    socket[@"uid"] = [LCMyUser mine].userID;
//    socket[@"nickname"] = [LCMyUser mine].nickname;
    [LiveMsgManager sendMsg:shareInfoDict andMsgType:LIVE_GROUP_SHARE Succ:succ andFail:fail];
}

// 房间消息
+ (void) roomNotificationInfo:(NSDictionary *)roomInfoDict Succ:(LiveMsgManagerSucc)succ andFail:(LiveMsgManagerFail)fail
{
    [LiveMsgManager sendMsg:roomInfoDict andMsgType:roomInfoDict[@"type"] Succ:succ andFail:fail];
}

+ (void) sendMsg:(NSDictionary *)msgInfo andMsgType:(NSString *)msgType Succ:(LiveMsgManagerSucc)succ andFail:(LiveMsgManagerFail)fail
{
    if ([LCMyUser mine].playBackUserId) {// 在观看点播
        return;
    }
    
    if (![LCMyUser mine].liveUserId) {
        return;
    }
    
    if ([msgType isEqualToString:LIVE_GROUP_GIFT]
            || [msgType isEqualToString:LIVE_GROUP_CHAT_MSG]
            || [msgType isEqualToString:LIVE_GROUP_BARRAGE]
            || [msgType isEqualToString:LIVE_GROUP_SYSTEM_MSG]
            || [msgType isEqualToString:LIVE_RTCLIVE_TYPE]) {
        [[IMBridge bridge] sendRoomMessageWithRoomID:[LCMyUser mine].liveUserId type:msgType data:msgInfo  success:^(long messageId) {
            NSLog(@"succ %ld",messageId);
        } error:^(NSError *error, long messageId) {
            NSLog(@"error code:%@ %ld",error, messageId);
        }];
    } else {
        if ([msgType isEqualToString:LIVE_GROUP_EXIT_ROOM]) {// 退出房间消息
            if ([LCMyUser mine].userLevel > [LCMyUser mine].sendMsgGrade
                    || [LCMyUser mine].liveType == LIVE_DOING) {
                [[IMBridge bridge] sendRoomMessageWithRoomID:[LCMyUser mine].liveUserId type:msgType data:msgInfo  success:^(long messageId) {
                    NSLog(@"succ exit room %ld",messageId);
                } error:^(NSError *error, long messageId) {
                    NSLog(@"error code:%@ %ld",error, messageId);
                }];
            } else {
                NSLog(@"no send enter or exit room msg");
            }
        } else if ([msgType isEqualToString:LIVE_GROUP_ENTER_ROOM]) {// 进入房间
            if ( [LCMyUser mine].userLevel > [LCMyUser mine].sendMsgGrade
                    || [LCMyUser mine].liveType == LIVE_DOING) {
                [[IMBridge bridge] sendRoomMessageWithRoomID:[LCMyUser mine].liveUserId type:msgType data:msgInfo  success:^(long messageId) {
                    NSLog(@"succ %ld",messageId);
                } error:^(NSError *error, long messageId) {
                    NSLog(@"error code:%@ %ld",error, messageId);
                }];
            } else {
                NSLog(@"no send enter room");
            }
        } else {
            if ([LCMyUser mine].userLevel >= [LCMyUser mine]. sendMsgGrade) {
                [[IMBridge bridge] sendRoomMessageWithRoomID:[LCMyUser mine].liveUserId type:msgType data:msgInfo  success:^(long messageId) {
                    NSLog(@"succ %ld",messageId);
                } error:^(NSError *error, long messageId) {
                    NSLog(@"error code:%@ %ld",error, messageId);
                }];
            } else {
                NSLog(@"online user count more no send other msg");
            }
        }
    }
}

#pragma mark - 上麦模块
// 上麦消息处理
+ (void) sendRTCLiveInfo:(NSDictionary *)rtcUserInfo andMsgType:(NSString *)msgType Succ:(LiveMsgManagerSucc)succ andFail:(LiveMsgManagerFail)fail
{
    [LiveMsgManager sendMsg:rtcUserInfo andMsgType:rtcUserInfo[@"type"] Succ:succ andFail:fail];
}

@end
