//
//  ShowGroupMsgTableView.h
//  qianchuo
//
//  Created by jacklong on 16/4/15.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

// 用户空间
typedef void(^ShowUserSpaceBlock)(LiveUser *liveUser);

typedef void(^ReviewUserBlock)(LiveUser *liveUser);
//// 私信用户
//typedef void(^PrivChatUserBlock)(NSDictionary * userInfoDict);
//// 换直播
//typedef void(^ChangeLiveRoomBlock)(NSDictionary *userInfoDict);
//// 禁言
//typedef void(^GapChatBlock)(NSDictionary *userInfoDict);

@interface ShowGroupMsgView : UIView


@property (nonatomic, strong) UITableView *contentTable;

@property (nonatomic, strong) NSMutableArray    *contentArray;

@property (nonatomic, copy) ShowUserSpaceBlock     showUserSpaceBlock;
@property (nonatomic, copy) ReviewUserBlock        reviewUserBlock;// 回复
//@property (nonatomic, copy) ChangeLiveRoomBlock changeLiveRoomBlock;//  换房间
//@property (nonatomic, copy) GapChatBlock        gapChatBlock;//  换房间

- (void) addMsgToGroupMsgView:(NSDictionary *)msgInfoDict;

+ (CGFloat) getTxtSize:(NSString *)txtStr withUserGrade:(int)grade withGift:(BOOL)isGift withContentWidth:(int)contentWidth;

+ (NSAttributedString *)getTrumpetStringWithDict:(NSDictionary *)dict;

@end
