//
//  RoomAudienceTableView.h
//  qianchuo
//
//  Created by jacklong on 16/4/18.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "AudienceMyTableView.h"

// 回复用户
typedef void(^ReViewUserBlock)(NSDictionary * userInfoDict);
// 私信用户
typedef void(^PrivChatUserBlock)(NSDictionary * userInfoDict);
// 禁言用户
typedef void(^GagUserBlock)(NSDictionary  *gagInfoDict);
// 管理员用户
typedef void(^AddManagerUserBlock)(NSDictionary *addManagerInfoDict);
// 删除管理员
typedef void(^RemoveManagerUserBlock)(NSDictionary *removeManagerInfoDict);
// 显示用户空间
typedef void(^ShowUserSpaceBlock)(LiveUser *liveUser);

@interface RoomAudienceTableView : AudienceMyTableView

@property (nonatomic, copy) ReViewUserBlock reViewBlock;// 回复
@property (nonatomic, copy) PrivChatUserBlock privateChatBlock;// 私聊
@property (nonatomic, copy) GagUserBlock  gagUserBlock;// 禁言
@property (nonatomic, copy) AddManagerUserBlock addManagerBlock;// 添加管理员
@property (nonatomic, copy) RemoveManagerUserBlock removeManagerBlock;// 删除管理员
@property (nonatomic, copy) ShowUserSpaceBlock showUserBlock;// 显示用户空间


- (void) loadAudienceData;

- (void) addUserToAudience:(LiveUser *)user;

// 更新可见部分用户
- (BOOL) isReloadDataVisibleUser:(LiveUser *)user;
@end
