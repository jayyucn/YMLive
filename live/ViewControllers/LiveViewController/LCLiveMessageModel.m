//
//  LCLiveMessageModel.m
//  TaoHuaLive
//
//  Created by Jay on 2017/8/8.
//  Copyright © 2017年 上海七夕. All rights reserved.
//

#import "LCLiveMessageModel.h"

@interface LCLiveMessageModel ()

@property (nonatomic, assign) LiveMessageEvent event;

@property (nonatomic, copy) MessageBlock messageBlock;

@end

@implementation LCLiveMessageModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        __gSendingMessagesQueue = dispatch_queue_create("com.qianchuo.ShowMessagesQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)onReceiveGroupMsg:(NSNotification *)notification withHandler:(MessageBlock)message
{
    if (message) {
        self.messageBlock = message;
    }
    
    RCMessage *rcMessage = notification.object;
    NSString *targetId = [NSString stringWithFormat:@"%@", rcMessage.targetId];
    
    if ([targetId isEqualToString:@"10000"]) {
        // 系统消息
        [self addToQueueWithGroupMessage:rcMessage];
    }
    
    if (![targetId isEqualToString:[LCMyUser mine].liveUserId] || ![rcMessage.content isKindOfClass:[QCCustomMessage class]])
    {
        return;
    }
    
    
    
    [self addToQueueWithGroupMessage:rcMessage];
}
/**
 add message to queue
 
 @param rcMessage rc message
 */
- (void) addToQueueWithGroupMessage:(RCMessage *)rcMessage {
    
    if (!__gSendingMessagesQueue) {
        return;
    }
    
    QCCustomMessage *msg = (QCCustomMessage *)rcMessage.content;
    if (!msg) {
        return;
    }
    
    ESWeakSelf;
    
    if (__gSendingMessagesQueue) {
        dispatch_async(__gSendingMessagesQueue, ^{
            ESStrongSelf;
            
            [_self.pendingMessages addObject:msg];
            
            ESDispatchOnMainThreadAsynchrony(^{
                ESStrongSelf;
                
                if (!_self.displayLink) {
                    _self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateUI:)];
                    _self.displayLink.frameInterval = 10;
                    
                    [_self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
                }
            });
        });
    }
}

/**
 update UI
 
 @param displayLink a timer with a interval related to screen update
 */
- (void)updateUI:(CADisplayLink *)displayLink
{
    if (!__gSendingMessagesQueue) {
        return;
    }
    
    ESWeakSelf;
    dispatch_async(__gSendingMessagesQueue, ^{
        ESStrongSelf;
        if (_self.pendingMessages.isEmpty) {
            return;
        }
        
        QCCustomMessage *msg = _self.pendingMessages.firstObject;
        [_self.pendingMessages removeObjectAtIndex:0];
        
        if ([msg isKindOfClass:[RCTextMessage class]]) {
            return;
        }
        
        if (!msg || !msg.type || !msg.data) {
            return;
        }
        
        ESDispatchOnMainThreadAsynchrony(^{
            ESStrongSelf;
            [_self showMainThreadDealMsgType:msg.type withMsgContent:msg.data];
        });
    });
}

- (void)showMainThreadDealMsgType:(NSString *)msgType withMsgContent:(NSDictionary *)socketData
{
    LiveMessageEvent event = LiveMessageEventNone;
    if ([msgType isEqualToString:LIVE_RTCLIVE_TYPE])
    {
        int upMikeType = [socketData[@"upmike_type"] intValue];
        
        if (upMikeType == RTCLIVE_AGREE_INVITE) {
            // 同意上麦
            event = LiveMessageEventInvitationGranted;
        } else if (upMikeType == RTCLIVE_REJECT_INVITE) {
            // 拒绝上麦
            event = LiveMessageEventInvitationDeclined;
            [LCNoticeAlertView showMsg:[NSString stringWithFormat:@"%@ 拒绝上麦！", socketData[@"nickname"]]];
        } else if (upMikeType == RTCLIVE_REGISTER_FAIL) {
            // 注册失败
            event = LiveMessageEventRegisterFailed;
            [LCNoticeAlertView showMsg:[NSString stringWithFormat:@"%@ 上麦失败！", socketData[@"nickname"]]];
        } else if (upMikeType == RTCLIVE_REGISTER_SUCC) {
            // 注册成功，开始呼叫
            event = LiveMessageEventRegisterSucceed;
            
        } else if (upMikeType == RTCLIVE_CALL_SUCC) {
            // 呼叫成功
            // 更新livingView，允许玩家下麦
            event = LiveMessageEventCallSucceed;
        } else if (upMikeType == RTCLIVE_CALL_FAIL) {
            // 呼叫失败
            event = LiveMessageEventCallFailed;
            [LCNoticeAlertView showMsg:[NSString stringWithFormat:@"%@ 上麦失败！", socketData[@"nickname"]]];
        } else if (upMikeType == RTCLIVE_EXIT) {
            // 下麦
            _upMikeUserInfoDict = nil;
            _inviteUserInfoDict = nil;
            
            isSendCall = NO;
            _livingView.exitUpMikeBtn.hidden = YES;
            
            [_livingView updateShowMsgArea:NO withEixtUpMike:YES];
            
//            // init with default filter
//            GPUImageOutput<GPUImageInput> *_curFilter = [[KSYGPUBeautifyExtFilter alloc] init];
//            // int val = (nalVal * 5) + 1; // level 1~5
//            [(KSYGPUBeautifyExtFilter *)_curFilter setBeautylevel:5];
//            [_kit setupFilter:_curFilter];
        }
    } else {
        if ([msgType isEqualToString:LIVE_GROUP_ENTER_ROOM]) {
            if ([socketData[@"total"] intValue] > 0 && [socketData[@"total"] intValue] > [LCMyUser mine].liveOnlineUserCount) {
                [LCMyUser mine].liveOnlineUserCount = [socketData[@"total"] intValue];
            } else {
                [LCMyUser mine].liveOnlineUserCount++;
            }
            event = LiveMessageEventEnterTheRoom;
        } else if([msgType isEqualToString:LIVE_GROUP_CHAT_MSG]) {
            // if needed
            event = LiveMessageEventChatMessage;
        } else if([msgType isEqualToString:LIVE_GROUP_EXIT_ROOM]) {
            event = LiveMessageEventLeaveTheRoom;
            
        } else if ([msgType isEqualToString:LIVE_GROUP_USER_LOVE]) {
            // if needed
            event = LiveMessageEventLove;
        } else if ([msgType isEqualToString:LIVE_GROUP_GIFT]) {
            event = LiveMessageEventGift;
        }
        if (self.messageBlock) {
            self.messageBlock(event, socketData);
        }
        [_livingView showDealGroupMsgType:msgType withMsgContent:socketData];
    }
}


@end
