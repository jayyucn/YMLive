//
//  OnlineUserView.h
//  qianchuo 用户详情
//
//  Created by jacklong on 16/3/7.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "MeFollowSegView.h"
#import "LiveUserDetailScrollView.h"

#define ONLINE_USER_HEIGTH 370


// 显示用户详情
typedef void(^ShowUserDetailBlock)(NSDictionary *userInfoDict);
// 回复用户
typedef void(^ReViewUserBlock)(NSDictionary *userInfoDict);
// 私信用户
typedef void(^PrivChatUserBlock)(NSDictionary *userInfoDict);
// 关注用户
typedef void(^AttentUserBlock)(NSString *userId);
// 禁言用户
typedef void(^GagUserBlock)(NSDictionary  *gagInfoDict);
// 解除禁言
typedef void(^RemoveGagUserBlock)(NSDictionary  *removeGagInfoDict);

// 管理员用户
typedef void(^AddManagerUserBlock)(NSDictionary *addManagerInfoDict);
// 删除管理员
typedef void(^RemoveManagerUserBlock)(NSDictionary *removeManagerInfoDict);
// 显示管理员列表
typedef void(^ShowManagerListBlock)();
// 换直播
typedef void(^ChangeLiveRoomBlock)(NSDictionary *userInfoDict);

// 显示主页
typedef void(^ShowUserHomeBlock)(NSString *userId);
// 邀请上麦
typedef void(^InviteUpMikeBlock)(NSDictionary *userInfoDict);

@interface UserSpaceViewController : UIViewController <MeFollowSegViewDelegate,UIGestureRecognizerDelegate>

//+ (void) ShowOnLineUserWindowWithUserInfo:(LiveUser *)liveUser withReViewUserBlock:(ReViewUserBlock)reviewBlock withPrivChatUserBlock:(PrivChatUserBlock)privateChatBlock;
//
//+ (void) releaseMemory;

@property (nonatomic, strong) LiveUser  *liveUser;

@property (nonatomic, assign) BOOL isShowBg; 

@property (nonatomic, assign) BOOL isNoShowPrivChat;

@property (nonatomic, assign) BOOL isInviteUpMike;
 

@property (nonatomic, copy) ShowUserDetailBlock  showUserDetailBlock;// 显示详情
@property (nonatomic, copy) ReViewUserBlock reViewBlock;// 回复
@property (nonatomic, copy) PrivChatUserBlock privateChatBlock;// 私聊
@property (nonatomic, copy) AttentUserBlock attentUserBlock;// 关注
@property (nonatomic, copy) GagUserBlock  gagUserBlock;// 解除禁言
@property (nonatomic, copy) RemoveGagUserBlock  unGagUserBlock;// 禁言
@property (nonatomic, copy) AddManagerUserBlock addManagerBlock;// 添加管理员
@property (nonatomic, copy) RemoveManagerUserBlock removeManagerBlock;// 删除管理员
@property (nonatomic, copy) ShowManagerListBlock showManagerListBlock;// 显示管理员列表
@property (nonatomic, copy) ChangeLiveRoomBlock  changeLiveRoomBlock;//  换房间
@property (nonatomic, copy) ShowUserHomeBlock  showUserHomeBlock;//  显示主页
@property (nonatomic, copy) InviteUpMikeBlock  inviteUpmikeBlock;// 邀请上麦

- (void) getUserDetailInfo:(LiveUser *)liveUser;

@end


