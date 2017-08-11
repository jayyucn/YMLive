//
//  LiveUser.h
//  live
//
//  Created by AlexiChen on 15/10/30.
//  Copyright © 2015年 kenneth. All rights reserved.
//

#import <Foundation/Foundation.h>

//{
//userLogo = "18681537580/head-1442307053.jpg";
//userName = alexi;
//userPhone = 18681537580;
//}

typedef NS_ENUM(NSInteger, LiveUserRole)
{
    ELiveUserRole_None,
    ELiveUserRole_Anchor, // 主播
    ELiveUserRole_Normal, // 普通用户
    ELiveUserRole_Interact, // 互动
};


@interface LiveUser : NSObject

@property (nonatomic, assign) LiveUserRole role;  // 默认ELiveUserRole_Normal
@property (nonatomic, copy) NSString *userLogo;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) int     userGrade;// 用户等级
@property (nonatomic, assign) int     userOffical;// 官方用户
@property (nonatomic, assign) int  zuojia;     // zuo jia
@property (nonatomic, assign) BOOL  isInRoom;// 在房间里面



@property (nonatomic, assign) BOOL hasVideo;    // 是否有视频
@property (nonatomic, assign) BOOL hasAudio;    // 是否有麦
@property (nonatomic, assign) BOOL hasInRoom;   // 是否在房间看用户信息


// for接口序列化
@property (nonatomic, copy) NSString *face;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, assign) int    grade;
@property (nonatomic, assign) int    offical;

- (instancetype)initWithPhone:(NSString *)phone name:(NSString *)name logo:(NSString *)logo;


//- (NSString *)logoUrl:(NSInteger)width height:(NSInteger)height;

- (NSString *)avsdkIdentifier;

- (BOOL)isInvited;

- (BOOL)isNormal;

@end


//===========================================================

//addr = "";
//"begin_time" = "2015-11-05 17:50:28";
//coverimagepath = "18926044525/coverimage-12089.jpg";
//groupid = "@TGS#3RDWQPAEV";
//headimagepath = "18926044525/head-1444878369.jpg";
//praisenum = 0;
//programid = 12089;
//subject = "\U53ef\U4ee5\U7528";
//totalnum = 2;
//url = "";
//username = "\U591a\U5566a\U68a6";
//userphone = 18926044525;
//viewernum = 2;
// 直接信息
@interface LiveItemInfo : NSObject

@property (nonatomic, copy) NSString *addr;
@property (nonatomic, copy) NSString *begin_time;
@property (nonatomic, copy) NSString *coverimagepath;
@property (nonatomic, copy) NSString *groupid;
@property (nonatomic, copy) NSString *headimagepath;
@property (nonatomic, assign) NSInteger praisenum;
@property (nonatomic, assign) NSInteger programid;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, assign) NSInteger totalnum;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *userphone;
@property (nonatomic, assign) NSInteger viewernum;

@end
