//
//  LCLiveMessageModel.h
//  TaoHuaLive
//
//  Created by Jay on 2017/8/8.
//  Copyright © 2017年 上海七夕. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LivingView.h"

/**
 消息处理类
 */

typedef NS_ENUM(NSInteger, LiveMessageEvent) {
    LiveMessageEventNone,
    LiveMessageEventInvitationGranted,
    LiveMessageEventInvitationDeclined,
    LiveMessageEventRegisterFailed,
    LiveMessageEventRegisterSucceed,
    LiveMessageEventCallSucceed,
    LiveMessageEventCallFailed,
    LiveMessageEventDisconnected,
    LiveMessageEventEnterTheRoom,
    LiveMessageEventChatMessage,
    LiveMessageEventLeaveTheRoom,
    LiveMessageEventLove,
    LiveMessageEventGift
    
};

typedef void(^MessageBlock)(LiveMessageEvent event, NSDictionary *messageDict);

@interface LCLiveMessageModel : NSObject
{
    LivingView         *_livingView;
    
    int roomAudienceCount; // 看过的人数
    int roomRecMoneyCount; // 收到钻石
    int roomPraiseCount; // 点亮
    BOOL isHostLeaveRoom;
    BOOL isSendCall; // 避免重复呼叫
    dispatch_queue_t            __gSendingMessagesQueue;
}
@property (nonatomic, strong) CADisplayLink         *displayLink;
@property (nonatomic, strong) NSMutableArray        *pendingMessages;
@property (nonatomic, strong) NSDictionary  *upMikeUserInfoDict; // 上麦用户信息
@property (nonatomic, strong) NSDictionary  *inviteUserInfoDict; // 受邀请用户信息（只有注册成功后才能发送邀请）


- (void)onReceiveGroupMsg:(NSNotification *)notification withHandler:(MessageBlock)message;

@end
