//
//  KFNetworkInterfaceURL.h
//  KaiFang
//
//  Created by ztkztk on 13-9-29.
//  Copyright (c) 2013年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCNetworkInterfaceURL : NSObject
{
//@private
    
}

extern NSString* getBaseURL(void);
extern NSString* getPhotoBaseURL(void);

extern NSString* getLiveStartURL(void);// 有美直播启动URL

extern NSString* getLiveLoginURL(void);// 登录URL

extern NSString* getLiveThridLoginURL(void);// 第三方登录接口

extern NSString* getLivePhoneRegURL(void);// 手机注册

extern NSString* getLivePhoneSendSmsURL(void);// 手机发送短信

extern NSString* getLiveRegUploadFaceURL(void);// 注册上传faceurl

extern NSString* getLiveRegDetailURL(void);// 上传用户信息

extern NSString* getLiveFindPwdURL(void);// 找回密码

extern NSString* getLiveFindPwdResetSendsms(void);// 发送找回密码重置密码接口

extern NSString* getLiveUserDetailURL(void);// 用户详情

extern NSString* getLiveMyMoneyURL(void);// 我的钻石


extern NSString* getStartURL(void);//开始确认登录状态

extern NSString* postFaceResultURL(void);//上传face信息

extern NSString* uploadPictureURL(void);//上传照片

extern NSString* basicRegisterURL(void);//注册

extern NSString* detailRegisterURL(void);//注册

//登录

extern NSString* loginURL(void);//登录
extern NSString* getPassword(void);//找回密码


// 广场
extern NSString* squareListURL(void);//广场列表
extern NSString* squareSearchURL(void);//搜索
extern NSString * squareNewSign(void);//最近登录



extern NSString* reportURL(void);//举报


//发现

extern NSString* couplesURL(void);//夫妻相列表

extern NSString* couplesMatchURL(void);//夫妻匹配

extern NSString* wifemergeURL(void);//生成夫妻相

extern NSString * photoDetailURL(void);//相片信息


//雷达

extern NSString*  radarURL(void);//雷达


//来访者

extern NSString* visitorListURL(void);//来访列表
extern NSString* deleteVisitorURL(void);//删除来访
extern NSString* removeAllVisitorsURL(void);//清空来访

//我的
extern NSString* mineInfoURL(void);//我的列表
extern NSString* modifyInfoURL(void);//修改基本资料
extern NSString* modifyPhotoURL(void);//修改头像

//关注
extern NSString* addFriendURL(void);//关注
extern NSString* friendsURL(void);//关注列表
extern NSString* modifyFriendURL(void);//修改特别关注
extern NSString* deleteFriendURL(void);//删除关注

//足迹

extern NSString* footprintsURL(void);//足迹
extern NSString* deleteFootsURL(void);//删除足迹
extern NSString* removeAllFootsURL(void);//清空足迹

//黑名单

extern NSString* blackListURL(void);//黑名单列表
extern NSString* blackaddURL(void);//添加黑名单
extern NSString* blackdelURL(void);//删除黑名单


//相册
extern NSString* photoListURL(void);//相册列表
extern NSString* updatePhotoURL(void);//上传相片
extern NSString* deletePhotoURL(void);//删除照片
extern NSString* setAvaterURL(void);//设为头像

//约会
extern NSString* addDatesURL(void);

//设置
extern NSString* setURL(void);//设置


extern NSString* modifySecretURL(void);//修改隐私
extern NSString* pushsetURL(void);//消息设置

extern NSString* requestVerifyingCodeURL(void);//获取手机验证码
extern NSString* verifyPhoneURL(void);//验证手机
extern NSString* requestVerifyEmailURL(void);//邮箱验证

extern NSString* modifyPwdURL(void);//修改密码

extern NSString* modifyPhoneAndEmailURL(void);//修改电话，邮箱

extern NSString* feedBackURL(void);//意见反馈

extern NSString* exitURL(void);//退出



extern NSString* introductionURL(void);//功能介绍


extern NSString *pushToken(void);//推送


extern NSString *searchUser(void);//搜索


extern NSString *locationHelp(void);//搜索

extern NSString *analytics(void);//统计

extern NSString *findStar(void);//明星



extern NSString *shareStar(void);//明星分享

extern NSString *quickRegiter(void);//直接注册

extern NSString *upLoadVideo(void);//上传视频

extern NSString *upLoadVideoNew(void);//上传视频 新

extern NSString *upLoadVideoImage(void);

extern NSString *resetSMS(void);//密码通过手获取验证码

extern NSString *resetpwd(void);//密码通过手机

extern NSString *contractSever(void);//联系客服

extern NSString *inviteMain(void);//邀请界面

extern NSString *inviteCode(void);//邀请码验证请求

extern NSString *inviteList(void);//邀请列表

extern NSString *exchange(void);//兑换

extern NSString *startRegister(void);//开始注册

extern NSString *startRegisterUpdateP(void);//上传照片

extern NSString *registerBaseInfo(void);//提交基本

extern NSString *registerSign(void);//账号密码

extern NSString *registerSign(void);//账号密码

extern NSString *addLivePhotoURL(void);//
extern NSString *upLoadGroupVideoNew(void);
extern NSString *matchList(void);
extern NSString *jumpURL(void);
extern NSString *likeURL(void);

// 聊天上传视频
extern NSString *uploadChatPrivVideo(void);

// 第三方登录
extern NSString *thridLogin(void);

// 语音广场
extern NSString *liveShowURL(void);

@end
