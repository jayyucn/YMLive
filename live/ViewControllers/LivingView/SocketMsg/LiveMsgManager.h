//
//  LiveMsgManager.h
//  qianchuo
//
//  Created by jacklong on 16/3/10.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#define LIVE_GROUP_GIFT         @"gift"                     // 送礼物
#define LIVE_GROUP_CHAT_MSG     @"chat"                     // 聊天消息（grade 用户名称:聊天消息）
#define LIVE_GROUP_SYSTEM_MSG   @"system"                   // 系统消息 （直播消息：主播离开一下，精彩不中断，不要走开）
#define LIVE_GROUP_ENTER_ROOM   @"enter"                    // 进入房间 （直播消息:一道金光闪过，用户名称进入直播间）
#define LIVE_GROUP_EXIT_ROOM    @"exit"                     // 退出房间
#define LIVE_GROUP_ATTENT       @"attent"                   // 关注消息（直播消息:用户名称关注了主播，不错过下次直播）
#define LIVE_GROUP_UPGRADE      @"upgrade"                  // 用户升级（grade用户名称升到级别）
#define LIVE_GROUP_USER_LOVE    @"love"                     // 用户点赞(grade用户名称:我点亮了《心的颜色》)
#define LIVE_GROUP_BARRAGE      @"barrage"                  // 用户弹幕
#define LIVE_GROUP_GAG          @"gag"                      // 用户被禁言（直播消息:用户名被管理员禁言）
#define LIVE_GROUP_REMOVE_GAG          @"remove_gag"               // 用户解除禁言
#define LIVE_GROUP_MANAGER             @"manager"           // 用户管理员（直播消息:恭喜你获得了直播间禁言权限）
#define LIVE_GROUP_REMOVE_MANAGER      @"remove_manager"    // 删除管理员
#define LIVE_GROUP_SHARE        @"share"                    // 分享消息（直播消息:昵称分享了直播）
#define LIVE_GROUP_ROOM_NOTIFICATION     @"room_notification"        // 房间通知
#define LIVE_GROUP_ROOM_ANCHOR_LEAVE     @"anchor_leave"             // 房间消息（直播消息:主播离开一下，精彩不中断，不要走开哦）
#define LIVE_GROUP_ROOM_ANCHOR_RESTORE   @"anchor_restore"           // 房间消息 (直播消息:主播回来啦，视频即将恢复)
#define LIVE_GROUP_LIVE_BAN             @"live_ban"                  // 禁止直播

// 上麦
#define LIVE_RTCLIVE_TYPE               @"live_rtc"                  // 上麦类型

#define RTCLIVE_INVITE_USER            1            // 主播邀请玩家上麦 (主播先自己注册成功后发邀请)
#define RTCLIVE_AGREE_INVITE           2            // 玩家同意主播邀请
#define RTCLIVE_REJECT_INVITE          3            // 玩家拒绝主播邀请
#define RTCLIVE_REGISTER_FAIL          4            // 上麦注册失败
#define RTCLIVE_REGISTER_SUCC          5            // 上麦注册成功
#define RTCLIVE_CALL_SUCC              6            // 呼叫成功（连麦成功）
#define RTCLIVE_CALL_FAIL              7            // 呼叫失败 (连麦失败)
#define RTCLIVE_EXIT                   8            // 下麦


#define GIFT_TYPE_CONTINUE      1            // 连续礼物
#define GIFT_TYPE_REDPACKET     2            // 红包类型
#define GIFT_TYPE_LUXURY        3            // 豪华礼物

#define FIREWORKS_GIFT          10           // 烟花
#define CAR_GIFT                11           // 车
#define SHIP_GIFT               12           // 轮船
#define AIRPLANE_GIFT           13           // 飞机
#define MARRY_GIFT              20           // 结婚礼物
#define CRYSTAL_SHOE_GIFT       27        // 水晶鞋
#define CROWN_GIFT              28        // 冠
#define FLOWER_GIFT             29        // 花
#define DRESS_GIFT              30          // 婚纱
#define MOON_GIFT               33           // 赏月

#define ANGEL_GIFT              400          // 天使
#define CASTLE_GIFT             401          // 城堡


#define PAINT_GIFT              1000          // 绘制礼物



#define DRIVE_MOUSE             1
#define DRIVE_BULL              2
#define DRIVE_TIGER             3
#define DRIVE_RABBIT            4
#define DRIVE_DARGON            5
#define DRIVE_SNAKE             6
#define DRIVE_HORSE             7
#define DRIVE_GOAT              8
#define DRIVE_MONKEY            9
#define DRIVE_ROOSTER           10
#define DRIVE_DOG               11
#define DRIVE_PIG               12



/**
 *  成功回调
 */
typedef void (^LiveMsgManagerSucc)();
/**
 *  失败回调
 */
typedef void (^LiveMsgManagerFail)();

@interface LiveMsgManager : NSObject

// 送礼物
+ (void) sendGiftMsg:(NSDictionary *)giftDict andSucc:(LiveMsgManagerSucc)succ andFail:(LiveMsgManagerFail)fail;

// 发送聊天消息
+ (void) sendChatMsg:(NSDictionary *)msgDict andSucc:(LiveMsgManagerSucc)succ andFail:(LiveMsgManagerFail)fail;

// 发送系统消息
+ (void) sendSystemMsg:(NSDictionary *)systemDict andSucc:(LiveMsgManagerSucc)succ andFail:(LiveMsgManagerFail)fail;

// 发送进入房间消息
+ (void) sendEnterRoomSucc:(LiveMsgManagerSucc)succ andFail:(LiveMsgManagerFail)fail;

// 发送退出房间消息
+ (void) sendQuitRoom:(NSDictionary *)systemDict andSucc:(LiveMsgManagerSucc)succ andFail:(LiveMsgManagerFail)fail;

// 发送关注消息
+ (void) sendAttentMsg:(NSDictionary *)attentDict Succ:(LiveMsgManagerSucc)succ andFail:(LiveMsgManagerFail)fail;

// 用户升级
+ (void) sendUserUpGrade:(NSDictionary *)upgradeDict Succ:(LiveMsgManagerSucc)succ andFail:(LiveMsgManagerFail)fail;

// 用户点亮
+ (void) sendLightUp:(NSDictionary *)socket UserLoveSucc:(LiveMsgManagerSucc)succ andFail:(LiveMsgManagerFail)fail;

// 用户弹幕
+ (void) sendUserBarrageMsg:(NSString *)msg Succ:(LiveMsgManagerSucc)succ andFail:(LiveMsgManagerFail)fail;

// 禁言用户
+ (void) sendGagInfo:(NSDictionary *)gagInfoDict Succ:(LiveMsgManagerSucc)succ andFail:(LiveMsgManagerFail)fail;

// 解除禁言
+ (void) removeGagInfo:(NSDictionary *)removeGagInfoDict Succ:(LiveMsgManagerSucc)succ andFail:(LiveMsgManagerFail)fail;

// 设置管理员
+ (void) sendManagerInfo:(NSDictionary *)managerInfoDict Succ:(LiveMsgManagerSucc)succ andFail:(LiveMsgManagerFail)fail;

// 解除管理员
+ (void) sendRemoveManagerInfo:(NSDictionary *)removeManagerInfoDict Succ:(LiveMsgManagerSucc)succ andFail:(LiveMsgManagerFail)fail;

// 分享直播间
+ (void) shareRoomInfo:(NSDictionary *)shareInfoDict Succ:(LiveMsgManagerSucc)succ andFail:(LiveMsgManagerFail)fail;

// 房间消息
+ (void) roomNotificationInfo:(NSDictionary *)shareInfoDict Succ:(LiveMsgManagerSucc)succ andFail:(LiveMsgManagerFail)fail;

// 发送消息
+ (void) sendMsg:(NSDictionary *)msgInfo andMsgType:(NSString *)msgType Succ:(LiveMsgManagerSucc)succ andFail:(LiveMsgManagerFail)fail;

#pragma mark - 上麦模块

// 上麦消息处理
+ (void) sendRTCLiveInfo:(NSDictionary *)rtcUserInfo andMsgType:(NSString *)msgType Succ:(LiveMsgManagerSucc)succ andFail:(LiveMsgManagerFail)fail;



@end
