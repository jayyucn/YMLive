
//
//  KFUser.h
//  KaiFang
//
//  Created by Elf Sundae on 13-10-28.
//  Copyright (c) 2013年 www.0x123.com. All rights reserved.
//
#import "LCUserEnum.h"

typedef NS_ENUM(NSUInteger, LIVETYPE) {
    LIVE_WATCH = 0,     // 看直播
    LIVE_DOING = 1,     // 直播
    LIVE_UPMIKE = 2,   // 上麦
    LIVE_NONE = 3       // 无情况
};

FOUNDATION_EXTERN NSString *const LCUserLiveRecDiamondDidChangeNotification;
FOUNDATION_EXTERN NSString *const LCUserLiveDiamondDidChangeNotification;
FOUNDATION_EXTERN NSString *const LCUserLiveSendDiamondDidChangeNotification;
FOUNDATION_EXTERN NSString *const LCUserMyRecDiamondDidChangeNotification;

#define LIVE_ONLINE_USER_DEAL_COUNT 3500

#define LIVE_USER_GRADE 16



@interface LCUser : NSObject

// 腾讯直播
@property (nonatomic, copy) NSString *userSig;     // 腾讯用户签名

// 融云token
@property (nonatomic, copy) NSString *imToken;


// 用户信息
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *goodID;       //
@property (nonatomic, copy) NSString *account;      //
@property (nonatomic, copy) NSString *nickname;     //昵称
@property (nonatomic, copy) NSString *faceURL;      //头像
@property (nonatomic, copy) NSString *tagFlag;      //认证
@property (nonatomic) LCSex sex;                    //性别
@property (nonatomic, copy) NSString *birthday;     //生日
@property (nonatomic, copy) NSString *signature;    // 签名
@property (nonatomic, assign) int diamond;          //我的钻石数目
@property (nonatomic, assign) int atten_total;      //关注人数
@property (nonatomic, assign) int fans_total;       //粉丝数
@property (nonatomic, assign) int live_total;       //在线人数
@property (nonatomic, assign) int recv_diamond;     //收到钻石数
@property (nonatomic, assign) int exchange_diamond; // 兑换钻石数
@property (nonatomic, assign) int send_diamond;     // 送出钻石数
@property (nonatomic, assign) int userLevel;        // 用户级别
@property (nonatomic, assign) int userCharm;        // 用户收礼物级别

@property (nonatomic, assign) CGFloat curlongi;     // 当前经度
@property (nonatomic, assign) CGFloat curlati;      // 当前纬度

// 当前钻石数量
@property (nonatomic, copy) NSString *curDiamond;
// 可兑换有美币数量
@property (nonatomic, copy) NSString *recvDiamond;
// 是否已经绑定微信
@property (nonatomic, assign) BOOL isBindWX;
// 人民币兑换有美币的比例
@property (nonatomic, assign) NSInteger rmtToHana;
// 钻石兑换有美币的比例
@property (nonatomic, assign) NSInteger diaToHana;

// 私信开启标识
@property (nonatomic, copy) NSString *priChatTag;

// 上次提现的银行卡号
@property (nonatomic, copy) NSString *lastBankAccount;

// 在直播间状态
@property (nonatomic, assign) BOOL isServerFilterAD;      // 过滤广告（服务端返回的）
@property (nonatomic, assign) BOOL isGag;           // 是否被禁言
@property (nonatomic, assign) BOOL isManager;       // 是否是管理员
@property (nonatomic, assign) BOOL showManager;     // 是否显示禁止直播(超级管理员)
@property (nonatomic, assign) NSString* activityName;    // 活动
@property (nonatomic, assign) int  zuojia;          // 座驾
@property (nonatomic, assign) int  sendMsgGrade;    // 控制发送消息
@property (nonatomic, assign) int  gag_grade;       // 控制发公聊消息
@property (nonatomic , strong) NSString *uplive_url; //推流地址
@property (nonatomic, strong) NSArray    *wanjiaMedalArray;// 玩家荣耀

// 是否继续直播
@property (nonatomic, assign) BOOL isContinueLive;  // 是否继续直播
// 换房间
@property (nonatomic, strong) NSDictionary  *roomInfoDict;// 换房间


// 我关注的所有用户id集合
@property (nonatomic, strong) NSMutableString        *attentUserIdsStr;

//直播信息
@property (nonatomic) BOOL isInLiveRoom;    //是否进入房间
@property (nonatomic) BOOL isInChatRoom;    //是否进入房间
@property (nonatomic) NSInteger tmpLiveRoomId;//获取房间号，创建成功后赋予liveRoomId,用户未退出上一个房间时，上一个房间的id不会被此次分配的房间id覆盖
@property (nonatomic) NSInteger liveRoomId;
@property (strong,nonatomic) NSString* chatRoomId;
@property (nonatomic) LIVETYPE liveType;
@property (strong,nonatomic) NSString* liveTime;
@property (strong,nonatomic) NSString* liveTitle;
@property (strong,nonatomic) NSString* liveUserId;
@property (strong,nonatomic) NSString* liveUserName;
@property (strong,nonatomic) NSString* liveUserLogo;
@property (strong,nonatomic) NSString* livePraiseNum;
@property (assign,nonatomic) int       liveUserGrade;
@property (assign,nonatomic) int       liveOnlineUserCount;
@property (strong,nonatomic) NSString* liveAddr;
@property (nonatomic) LCSex            liveUserSex;
@property (nonatomic, assign) int      liveRecDiamond;     //收到钻石数
@property (nonatomic, strong) NSArray* liveAnchorMedalArray;// 玩家荣耀
// 上麦增加
@property (nonatomic, strong) NSString* liveOnWheatUserId;// 上麦用户id
// 1v1 增加
@property (nonatomic, assign) int       onetone;// 是否开通1v1


@property (strong,nonatomic) NSString* playBackUserId;     //回看的用户id
@property (strong,nonatomic) NSString* playVdoid;          //点播的直播id
//旁播信息
@property (strong,nonatomic) NSNumber* channelID;//频道ID

// 我禁言用户id集合
@property (nonatomic, strong) NSMutableString        *gagUserIdsStr;



//@property (nonatomic)NSInteger height;              //身高
//@property (nonatomic, copy) NSString *degree;           //学历
//@property (nonatomic)unsigned long long wage;       //薪水
//@property (nonatomic)LCMarriageType marry;       //婚姻
//@property (nonatomic,copy)NSString *ithink;          //我想
//@property (nonatomic,copy)NSString *monologue;      //独白
@property (nonatomic,copy)NSString *province;       //省份
@property (nonatomic,copy)NSString *city;           //城市
@property (nonatomic) float longitude;               //经度
@property (nonatomic) float latitude;                //纬度





//@property (nonatomic,copy)NSString *realname;   //真实名字
//@property (nonatomic,copy)NSString *car;
//@property (nonatomic,copy)NSString *good;
//@property (nonatomic,copy)NSString *hobbies;
//@property (nonatomic,copy)NSString *home_city;
//@property (nonatomic,copy)NSString *home_prov;
//@property (nonatomic,copy)NSString *house;
//@property (nonatomic,copy)NSString *sign;
//@property (nonatomic,copy)NSString *stature;
//@property (nonatomic,copy)NSString *job;
//@property (nonatomic,copy)NSString *email;
//
//@property (nonatomic, copy) NSString *videoURL;

//@property (nonatomic, copy) NSString *age;
//@property (nonatomic, copy) NSString *grade;
//@property (nonatomic, copy) NSString *charm;
//@property (nonatomic, copy) NSString *vip;

//@property (nonatomic) int VIPLevel;
//@property (nonatomic) int credit;

//- (NSString *)creditString;

/**
 *  根据服务端返回结果创建 User 对象.
 *
 *  @return nil if failed.
 */
+ (instancetype)userWithDictionary:(NSDictionary *)dict forUserID:(NSString *)userID;

/**
 *  根据服务端返回结果创建 User 对象. uid已包含在dict中了。
 *
 *  @return nil if failed.
 */
+ (instancetype)userWithDictionary:(NSDictionary *)dict;

/**
 * @param dict 必须包含键"uid"
 */
- (BOOL)fillWithDictionary:(NSDictionary *)dict;

- (NSDate *)dirthdayDate;
-(void)modifyInfo:(NSDictionary *)dict;

- (BOOL)isVIP;

@end

