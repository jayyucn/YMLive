//
//  Macro.h
//  live
//
//  Created by Jacklong on 15-7-9.
//  Copyright (c) 2015年 Jacklong. All rights reserved.
//

#ifndef live_Macro_h
#define live_Macro_h

//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCALE ([UIScreen mainScreen].scale)
//状态栏、导航栏、标签栏高度
#define STATUS_HEIGHT ([UIApplication sharedApplication].statusBarFrame.size.height)
#define NAVIGATIONBAR_HEIGHT (self.navigationController.navigationBar.frame.size.height)
#define TABBAR_HEIGHT (self.tabBarController.tabBar.frame.size.height)

#define DEFINE_IS_HuoWuLive ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.qixi.HuoWuLive"])
#define DEFINE_IS_VLIVE ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.qixi.auvlive"])
#define DEFINE_IS_DEV_LIVE ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.qixi.HuoWuLive.dev"])


//字体颜色
#define COLOR_FONT_RED   0xD54A45
#define COLOR_FONT_WHITE 0xFFFFFF
#define COLOR_FONT_LIGHTWHITE 0xEEEEEE
#define COLOR_FONT_DARKGRAY  0x555555
#define COLOR_FONT_GRAY  0x777777
#define COLOR_FONT_LIGHTGRAY  0x999999
#define COLOR_FONT_BLACK 0x000000

//背景颜色
#define COLOR_BG_GRAY      0xEDEDED
#define COLOR_BG_ALPHABLACK     0x88000000
#define COLOR_BG_ORANGE 0xf69e21
#define COLOR_BG_ALPHARED  0x88D54A45
#define COLOR_BG_LIGHTGRAY 0xEEEEEE
#define COLOR_BG_ALPHAWHITE 0x55FFFFFF
#define COLOR_BG_WHITE     0xFFFFFF
#define COLOR_BG_DARKGRAY     0xAFAEAE
#define COLOR_BG_RED       0xD54A45
#define COLOR_BG_BLUE      0x4586DA
#define COLOR_BG_CLEAR     0x00000000

//rbg转UIColor(16进制)
#define RGB16(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define RGBA16(rgbaValue) [UIColor colorWithRed:((float)((rgbaValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbaValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbaValue & 0xFF))/255.0 alpha:((float)((rgbaValue & 0xFF000000) >> 24))/255.0]

#define KSY_APP_ID @"2BlIyk3cMuw7X6Td5lXt"  // 金山云appid
#define KSY_ACCESS_KEY  @"DfC9k+Ohbqm4kbWRjGPhCZtkNjtonKaH841r9nfw" // access_key

#define TENCENT_SDK_APP_ID @"1400004644"// 互动直播app_id
#define TENCENT_ACCOUNT_TYPE @"2396" // 互动直播的账号类型


#ifdef DEBUG
#define URL_HEAD    [LCCore requestUrlHead]
#else

#define URL_HEAD    [LCCore requestUrlHead]
#endif

#define URL_PHOTO_HEAD  [LCCore imgUrlHead]
#define URL_GIFT_HEAD   [[LCCore imgUrlHead] stringByAppendingString:@"gift/"]
#define URL_UPLOAD_PHOTO_HEAD [LCCore uploadFaceUrlHead] //都改成这个地址

#define URL_UPLOADED_VIDEO_HEAD  [LCCore uploadedVideoUrlHead] //视频上传后的地址前缀

#define URL_SOCKET_HOST     @"139.199.184.20"   //host of socket server
#define PORT_SOCKET_HOST    9501            //port of socket

// 第三方登录
#define URL_THIRD_LOGIN @"index/oauth"

// app 启动
#define URL_LIVE_START @"index/sync"

// APP 退出
#define URL_LIVE_EXIT @"profile/quit"
// APP 登录
#define URL_LIVE_LOGIN @"index/login"

//联系客服
#define URL_LIVE_CONTACT_SERVER @"other/contact"
// 第三方登录
#define URL_LIVE_THIRD_LOGIN @"index/oauth"
// 手机注册
#define URL_LIVE_PHONE_REG @"reg/sign"
// 手机发送短信
#define URL_LIVE_PHONE_SENDSMS @"reg/sendsms"
// 注册上传faceurl
#define URL_LIVE_REG_UPLOAD_FACE URL_UPLOAD_PHOTO_HEAD
// 上传用户信息
#define URL_LIVE_REG_DETAIL @"reg/detail"
// 找回密码
#define URL_LIVE_FIND_PWD @"reg/resetpwd"
// 发送找回密码重置密码接口
#define URL_LIVE_FIND_PWD_RESET_SENDSMS @"reg/sendpwdsms"
// 用户基本信息
#define URL_EDIT_USER_INFO @"profile/save"
// 更改头像
#define URL_MODIFY_FACE URL_UPLOAD_PHOTO_HEAD//@"profile/upface"
// 用户详情
#define URL_LIVE_USER_DETAIL @"home"
// 关注列表
#define URL_ATTENT_USER_LIST        @"atten"
// 添加关注
#define URL_ADD_ATTENT_USER         @"atten/add"
// 取消关注
#define URL_CANCEL_ATTENT           @"atten/del"
// 粉丝列表
#define URL_FANS_LIST               @"fans"
// 有美币榜
#define URL_RECEIVER_TOPS_LIST      @"live/tops"
// 有美币周榜
#define URL_RECEIVER_WEEK           @"live/weekrank"
// 有美币日榜
#define URL_RECEIVER_DAILY          @"live/dailyrank"
// 主播排行榜
#define URL_TOPS_LIVER              @"rank/anchor"
// 土豪排行榜
#define URL_TOPS_Sender             @"rank/live"
// 用户排行榜
#define URL_TOPS_USER               @"rank/user"
// 关注用户id集合
#define URL_ATTENT_ARRAY_SYNC_LIST  @"atten/sync"
// 检索
#define URL_SEARCH_USER             @"live/search"
// 购买钻石列表
#define URL_BUY_DIAMOND             @"pay"
// 禁止直播
#define URL_BAN_LIVE                @"manage/forbid"
// 直播列表
#define URL_CALLBACK_LIVE_LIST      @"home/dianbo"
// 删除回放接口
#define URL_DEL_CALLBACK_LIVE       @"home/delvdoid"
// 附近
#define URL_NEARBY_USER             @"nearby"
// 上传消息
#define URL_UPLOAD_MSG              @"other/filtermsg"


// 获取用户兑换信息
#define URL_EXCHANGE_INFO           @"exchange/info"
// 支付宝兑换
#define URL_EXCHANGE_ALIPAY         @"exchange/alipay"
// 银联兑换
#define URL_EXCHANGE_BANK           @"exchange/lianlianpay"
// 钻石兑换
#define URL_EXCHANGE_DIAMOND        @"exchange/diamond"
// 兑换记录
#define URL_EXCHANGE_LOG            @"exchange/log"
// 超管操作记录
#define URL_MANAGE_LOG              @"manage/log"

// 绑定微信
#define URL_PROFILE_BINDWX          @"profile/bindwx"

#define URL_LIVE_UPLOAD_TOKEN       @"share/token"

// 我的钻石
#define URL_LIVE_MONEY @"pay"
//发送pushToken
#define URL_LIVE_PUSH_TOKEN @"profile/token"
// 统计
#define URL_ANALYTIS_COUNT  @"reg/stats"

// 直播用户信息
#define URL_LIVE_USERINFO_URL   @"home"
// 礼物列表
#define URL_LIVE_GIFT_URL       @"gift/mall"
// 赠送礼物
#define URL_LIVE_SENG_GIFT_URL  @"gift/send"

#define URL_LIVE_DRAW_GIFT_URL  @"gift/drawsend"

// 弹幕
#define URL_LIVE_BARRAGE        @"live/barrage"
// 红包
#define URL_SEND_RED_PACKET     @"gift/sendredbag"
// 抢红包
#define URL_ROB_RED_PACKET      @"gift/grabredbag"
// 红包列表
#define URL_SHOW_RED_PACKET_DETAIL   @"gift/redbaglist"

// Live举报
#define URL_LIVE_REPORT         @"live/report"
// 禁言
#define URL_LIVE_GAG_USER       @"live/gag"
// 添加管理员 (type=0 删除管理员  type=1添加管理员)
#define URL_LIVE_OPERATE_MANAGER    @"live/manage"
// 管理员列表
#define URL_LIVE_MANAGER_LIST   @"live/managelist"

#define URL_BET_HISTORY             @"live/gamehistory"

// 获取imtoken
#define URL_GET_IMTOKEN         @"index/imtoken"

// 1v1
//1、主播列表 /onetone?page=1
#define URL_OVO_LIST            @"onetone"

//返回 list = {}
//2、签权 /onetone/sign?anchor=12121&user=1212
#define URL_OVO_SIGN            @"onetone/sign"
//520 余额不足
//502 没有开通一对一
//返回 live_url user_url domain_url
//3、设置每分钟钻石 /onetone/set?diamond=20
#define URL_OVO_SET_DEDUCTION       @"onetone/set"
//
//4、每分钟扣款接口/onetone/deduct?anchor=1212&user=1212
#define URL_OVO_DEDUCTION           @"onetone/deduct"
//返回 520 余额不足  200 正常
//5、关闭一对一 /onetone/close?anchor=1212
#define URL_OVO_CLOSE               @"onetone/close"
//
//6、开通1v1 /profile/onetone
#define URL_OVO_OPEN                @"profile/onetone"
// 获取用户自己有美币
#define URL_GET_RECDIAMOND          @"onetone/userinfo"
// 获取用户设置钻石
#define URL_GET_SETDIAMOND          @"onetone/get"


//url
//已经是群成员
#define URL_REQUEST_SUCCESS 200
#define URL_ROOM_CLOSE 562
#define URL_REGISTER_FAIL 561
#define URL_REGISTER_PHONEUSED 562
#define URL_REGISTER_NAMEUSED 563
#define URL_REGISTER_NOIMAGE 260
#define URL_SAVEUSER_NOIMAGE 260
#define URL_SAVE_NAMEUSED 562


// 关注
#define URL_LIVING_ATTENT       @"live/atten"
// 最热
#define URL_LIVING_HOT          @"live/hot"
// 最新
#define URL_LIVING_New         @"live/news"
// 审核
#define URL_LIVING_REVIEW      @"live/check"
// 隐藏
#define URL_LIVING_HIDDEN      @"live/hide"
// 活动
#define URL_LIVING_ACTIVITY     @"live/activity"

//#define URL_GETROOMID [URL_ENTRY stringByAppendingString:@"/create_room_id.php"]
//创建房间
#define URL_LIVE_CREATE         @"live/begin"
//#define URL_CREATELIVE [URL_ENTRY stringByAppendingString:@"/live_create.php"]
//创建预告
//#define URL_CREATETRAILER [URL_ENTRY stringByAppendingString:@"/live_forcastcreate.php"]
//关闭房间
#define URL_LIVE_CLOSE          @"live/close"

//#define URL_CLOSELIVE [URL_ENTRY stringByAppendingString:@"/live_close.php"]
//进入房间
#define URL_LIVE_ENTERROOM      @"live/enter"
//#define URL_ENTERROOM [URL_ENTRY stringByAppendingString:@"/enter_room.php"]
//关闭房间
#define URL_LIVE_LEAVEROOM      @"live/quit"

//点赞
#define URL_LIVE_PARAISE        @"live/zan"
//批量获取用户
#define URL_LIVE_USERLIST       @"live/userlist"
//推流心跳
#define URL_LIVE_HEART @"live/ping"
//主播状态同步
#define URL_LIVE_SYNC @"live/sync"
//开七牛连麦房间
#define URL_LIVE_CREATMIKE @"live/createmike"  //@"live/mikesign"
//关闭七牛连麦房间
#define URL_LIVE_CLOSEMIKE @"live/closemike"
//进入七牛连麦房间
#define URL_LIVE_SIGNMIKE @"live/mikesign"
// 上麦通知
#define URL_LIVE_UPMIKE   @"live/upmike"
// 下麦通知
#define URL_LIVE_DOWNMIKE   @"live/downmike"
//
#define URL_SHARE_SCREEN    @"share/screen"

//自定义消息命令
#define MSG_SEPERATOR   @"&"
#define MSG_PRAISE      @"%@&%d&%d" //userid&cmd&praisecount
#define MSG_ADDUSER     @"%@&%d&%@&%@"  //userid&cmd&username&userlogo
#define MSG_DELUSER     @"%@&%d" //userid&cmd
#define MSG_CMD_PRAISE  1
#define MSG_CMD_ADDUSER 2
#define MSG_CMD_DELUSER 3


//const int PRIASE_MSG = 1;
//const int MEMBER_ENTER_MSG = 2;
//const int MEMBER_EXIT_MSG = 3;
#define VIDEOCHAT_INVITE  4
#define YES_I_JOIN  5
#define NO_I_REFUSE 6
#define MUTEVOICE   7
#define UNMUTEVOICE 8
#define MUTEVIDEO   9
#define UNMUTEVIDEO 10

// 自定义
#define MY_MSG_IFNO @"%d&%@"         // cmd&msgContent
#define SYSTEM_NOTICE_ROOM       103 // 系统消息
#define ENTER_ROOM               104 // 进入房间
#define EXIT_ROOM                105 // 退出房间
#define MSG_COETENT_ROOM         106 // 聊天内容
#define MSG_GIFT_ROOM            107 // 送礼物
#define ATTENT_USER_ROOM         108 // 关注用户
#define UPGRADE_USER_ROOM        109 // 用户升级
#define LOVE_ANCHOR              110 // 点亮
#define BARRAGE_USER             111 // 用户弹幕
#define GAG_USER                 112 // 禁言用户
#define REMOVE_GAG_USER          113 // 解除禁言
#define MANAGER_ROOM             114 // 设置管理员
#define REMOVE_MANAGER_ROOM      115 // 移除管理员
#define START_LIVE               116 // 开始直播
#define SUPER_CLOSE_LIVE         117 // 管理员关闭房间


// 取消互动
#define VIDEOCHAT_Cancel_INVITE  11

#define MSG_INVITE_FORMAT @"%@&%d&%@&%@&"


//通知标识
#define NOTIFICATION_NETWORK @"NOTIFICATION_NETWORK"
#endif

//sdk类型item文本显示
#define LIVE_AVSDK_TYPE_NORMAL @"普通开发SDK业务"
#define LIVE_AVSDK_TYPE_IOTCamera @"普通物联网摄像头SDK业务"
#define LIVE_AVSDK_TYPE_COASTCamera @"滨海摄像头SDK业务"

