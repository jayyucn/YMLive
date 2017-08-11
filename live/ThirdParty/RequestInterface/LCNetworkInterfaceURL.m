//
//  KFNetworkInterfaceURL.m
//  KaiFang
//
//  Created by ztkztk on 13-9-29.
//  Copyright (c) 2013年 www.0x123.com. All rights reserved.
//

#import "LCNetworkInterfaceURL.h"

#define RANK_TOPff @"sds"

@implementation LCNetworkInterfaceURL


-(id)init
{
    if(self=[super init])
    {
      
    }
    return self;
}

//
NSString* getBaseURL(void)
{
    return [LCCore requestUrlHead];
}

NSString* getPhotoBaseURL(void)
{
    return [LCCore imgUrlHead];
}

// 有美直播启动URL
NSString* getLiveStartURL(void)
{
    return @"index/sync";
}

// 登录URL
NSString* getLiveLoginURL(void)
{
    return @"index/login";
}

// 第三方登录接口
NSString* getLiveThridLoginURL(void)
{
    return @"index/oauth";
}

// 手机注册
NSString* getLivePhoneRegURL(void)
{
    return @"reg/sign";
}

// 手机发送短信
NSString* getLivePhoneSendSmsURL(void)
{
    return @"reg/sendsms";
}

// 注册上传faceurl
NSString* getLiveRegUploadFaceURL(void)
{
    return @"reg/upface";
}

// 上传用户信息
NSString* getLiveRegDetailURL(void)
{
    return @"reg/detail";
}

// 找回密码
NSString* getLiveFindPwdURL(void)
{
    return @"reg/resetpwd";
}

// 发送找回密码重置密码接口
NSString* getLiveFindPwdResetSendsms(void)
{
    return @"reg/sendpwdsms";
}

// 用户详情
NSString* getLiveUserDetailURL(void)
{
    return @"home";
}

// 我的钻石
NSString* getLiveMyMoneyURL(void)
{
    return @"pay";
}

NSString* getStartURL(void)
{
    return @"index/sync";
}

NSString* postFaceResultURL(void)
{
    return @"reg/create";
}

NSString* uploadPictureURL(void)
{
    
    NSString *url=[NSString stringWithFormat:@"reg/upimg?udid=%@",[UIDevice openUDID]];
    return url;
}

NSString* basicRegisterURL(void)//注册
{
    return @"reg/basic";
}

NSString* addDatesURL(void)//注册
{
    return @"dates/upimg";
}

NSString* addLivePhotoURL(void)//注册
{
    return @"chat/upimg";
}

NSString* detailRegisterURL(void)
{
    return @"reg/detail";
}


NSString* loginURL(void)//登录
{
    return @"index/login";
}


NSString* getPassword(void)//找回密码
{
    return @"profile/backpwd";
}


// 广场
NSString* squareListURL(void)//广场列表
{
    return @"index/nearby";
}
NSString* squareSearchURL(void)//搜索
{
    return @"index/search";
}

NSString * squareNewSign(void)//最近登录
{
    return @"index/newsign";
}

NSString * photoDetailURL(void)//相片信息
{
    return @"home/photo";
}

NSString* addFriendURL(void)//关注
{
    return @"friend/add";
}


NSString* reportURL(void)//举报
{
    return @"home/report";
}




//发现

NSString* couplesURL(void)//夫妻相列表
{
    return @"find/wifeface";
}

NSString* couplesMatchURL(void)//夫妻匹配
{
    return @"find/wifematch";
}

NSString* wifemergeURL(void)//生成夫妻相
{
    return @"find/wifemerge";
}

//雷达

NSString*  radarURL(void)//雷达
{
    return @"find/radar";
}


//来访者

NSString* visitorListURL(void)//来访列表
{
    return @"find/visit";
}
NSString* deleteVisitorURL(void)//删除来访
{
    return @"find/visitdel";
}
NSString* removeAllVisitorsURL(void)//清空来访
{
    return @"find/visitdelall";
}




//黑名单

NSString* blackListURL(void)//黑名单列表
{
    return @"profile/blacklist";
}
NSString* blackaddURL(void)//添加黑名单
{
    return @"profile/blackadd";
}
NSString* blackdelURL(void)//删除黑名单
{
    return @"profile/blackdel";
}

//mine


NSString* mineInfoURL(void)
{
    return @"profile";
}

NSString* modifyInfoURL(void)
{
    return @"profile/modify";
}

NSString* modifyPhotoURL(void)
{
    return @"profile/upface";
}


//相册
NSString* photoListURL(void)//相册列表
{
    return @"photo";
}
NSString* updatePhotoURL(void)//上传相片
{
    return @"photo/upload";
}
NSString* deletePhotoURL(void)//删除照片
{
    return @"photo/del";
}


NSString* setAvaterURL(void)//设为头像
{
    return @"photo/setface";
}


//关注

NSString* friendsURL(void)//关注列表
{
    return @"friend";
}
NSString* modifyFriendURL(void)//修改特别关注
{
    return @"friend/level";
}
NSString* deleteFriendURL(void)//删除关注
{
    return @"friend/del";
}


//足迹

NSString* footprintsURL(void)//足迹
{
    return @"profile/footprint";
}

NSString* deleteFootsURL(void)//删除足迹
{
    return @"profile/footdel";
}

NSString*  removeAllFootsURL(void)//清空足迹
{
    return @"profile/footdelall";
}



//设置
NSString* setURL(void)
{
    return @"profile/set";
}

NSString* modifySecretURL(void)
{
    return @"profile/privacy";
}

NSString* pushsetURL(void)
{
    return @"profile/pushset";
}


NSString* requestVerifyingCodeURL(void)//获取手机验证码
{
    return @"profile/sendsms";
}
NSString* verifyPhoneURL(void)//验证手机
{
    return @"profile/verify";
}
NSString* requestVerifyEmailURL(void)//邮箱验证
{
    return @"profile/sendmail";
}
NSString* modifyPwdURL(void)//修改密码
{
    return @"profile/pwdmodify";
}

NSString* modifyPhoneAndEmailURL(void)//修改电话，邮箱
{
    return @"profile/modify";
}


NSString* feedBackURL(void)//意见反馈
{
    return @"other/idea";
}

NSString* exitURL(void)//退出
{
    return @"profile/quit";
}

NSString* introductionURL(void)//功能介绍
{
    return [getBaseURL() stringByAppendingString:@"other/intro"];
}


//发送pushToken
NSString *pushToken(void)
{
    return @"profile/token";
}

NSString *searchUser(void)//搜索
{
    return @"friend/search";
}

NSString *locationHelp(void)//搜索
{
    return [getBaseURL() stringByAppendingString:@"other/locate"];
    
}

NSString *analytics(void)//统计
{
    return @"reg/stats";
}

NSString *findStar(void)//明星
{
    return @"find/star";
}

NSString *shareStar(void)//明星分享
{
    return @"find/starmerge";
}

NSString *quickRegiter(void)//直接注册
{
    return @"reg/add";
}


NSString *upLoadVideo(void)//上传视频
{
    return [getBaseURL() stringByAppendingString:@"profile/upvideo"];
}

NSString *upLoadVideoNew(void)//上传视频
{
    return [getBaseURL() stringByAppendingString:@"video/upload"];
}

NSString *upLoadGroupVideoNew(void)//上传群聊视频
{
    return [getBaseURL() stringByAppendingString:@"chat/upvideo"];
}
NSString *upLoadVideoImage(void)//上传视频
{
    return [getBaseURL() stringByAppendingString:@"video/upimg"];
}




NSString *resetSMS(void)//密码通过手机
{
    return @"profile/phonesms";
}

NSString *resetpwd(void)//密码通过手机
{
    return @"profile/resetpwd";
}




NSString *contractSever(void)//联系客服
{
    return @"other/contact";
}




NSString *inviteMain(void)//邀请界面
{
    return @"invite";
}

NSString *inviteCode(void)//邀请码验证请求
{
    return @"invite/validate";
}

NSString *inviteList(void)//邀请列表
{
    return @"invite/users";
}

NSString *exchange(void)//兑换
{
    return @"invite/exchange";
}

NSString *startRegister(void)//开始注册
{
    return @"register/start";
}

NSString *startRegisterUpdateP(void)//上传照片
{
    return @"register/upface";
}

NSString *registerBaseInfo(void)//提交基本
{
    return @"register/basic";
}

NSString *registerSign(void)//账号密码
{
    return @"register/sign";
}

NSString *matchList(void)
{
    return @"pairing";
}

NSString *jumpURL(void)
{
    return @"pairing/skip";
}

NSString *likeURL(void)
{
    return @"pairing/like";
}

NSString *uploadChatPrivVideo(void)
{
    return @"msg/upvideo";
}

NSString *thridLogin(void)
{
    return @"index/oauth";
}

NSString *liveShowURL(void)
{
    return @"chat";
}
@end
