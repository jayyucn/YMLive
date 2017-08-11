//
//  Business.h
//  live
//
//  Created by hysd on 15/8/6.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import <Foundation/Foundation.h> 
/**
 *  成功回调
 */
typedef void (^businessSucc)(NSString* msg, id data);
/**
 *  失败回调
 */
typedef void (^businessFail)(NSString *error);
@interface Business : NSObject
/**
 * 获取单例
 */
+ (Business*) sharedInstance;


/**
 *  登录
 *  @param phone  账号（电话号码）
 *  @param succ   成功回调
 *  @param fail   失败回调
 */
//- (void)loginPhone:(NSString*)phone pass:(NSString*)pass succ:(businessSucc)succ fail:(businessFail)fail;

/**
 *  获取用户imtoken
 *  @param succ   成功回调
 *  @param fail   失败回调
 */
- (void)getUserIMTokenSucc:(businessSucc)succ fail:(businessFail)fail;

///**
// *  获取房间号
// *  @param succ   成功回调
// *  @param fail   失败回调
// */
//- (void)getRoomnumSucc:(businessSucc)succ fail:(businessFail)fail;
/**
 *  插入创建直播到数据库
 *  @param title  直播标题
 *  @param phone  账号（电话号码）
 *  @param room   直播房间号
 *  @param chat   聊天室号码
 *  @param image  直播封面
 *  @param succ   成功回调
 *  @param fail   失败回调
 */
- (void)insertLive:(NSString*)tilte addr:(NSString*)addr withVdoid:(NSString *)vdoid succ:(businessSucc)succ fail:(businessFail)fail;
/**
 *  插入进入直播到数据库
 *  @param phone  观众账号（电话号码）
 *  @param room   直播房间号
 *  @param succ   成功回调
 *  @param fail   失败回调
 */
- (void)enterRoomSucc:(businessSucc)succ fail:(businessFail)fail;
/**
 *  获取用户信息
 *  @param phone  账号（电话号码）
 *  @param succ   成功回调
 *  @param fail   失败回调
 */
//- (void)getUserInfoByPhone:(NSString*)phone succ:(businessSucc)succ fail:(businessFail)fail;
/**
 *  点赞
 *  @param room   房间号
 *  @param count  增加点赞数
 *  @param succ   成功回调
 *  @param fail   失败回调
 */
-(void)loveLive:(NSInteger)room addCount:(int)count succ:(businessSucc)succ fail:(businessFail)fail;
/**
 *  关闭房间
 *  @param room   房间号
 *  @param succ   成功回调
 *  @param fail   失败回调
 */
-(void)closeRoomTimer:(int)timer withVdoid:(NSString *)vdoid withTitle:(NSString *)title  withPraise:(int)praise withAudience:(int)audience succ:(businessSucc)succ fail:(businessFail)fail;
/**
 *  离开房间
 *  @param room   房间号
 *  @param phone  用户手机
 *  @param succ   成功回调
 *  @param fail   失败回调
 */
- (void)leaveRoom:(NSInteger)room phone:(NSString*)phone succ:(businessSucc)succ fail:(businessFail)fail;

/**
 *  获取用户列表
 *  @param room   房间id
 *  @param succ   成功回调
 *  @param fail   失败回调
 */
- (void)getUserListByRoom:(NSInteger)room succ:(businessSucc)succ fail:(businessFail)fail;

/**
 *  获取直播信息
 *  @param room   房间id
 *  @param succ   成功回调
 *  @param fail   失败回调
 */
//- (void)getLive:(NSInteger)room succ:(businessSucc)succ fail:(businessFail)fail;

/**
 *  插入预告数据
 *  @param title  标题
 *  @param phone  账号（电话号码）
 *  @param time   时间
 *  @param image  封面
 *  @param succ   成功回调
 *  @param fail   失败回调
 */
//- (void)insertTrailer:(NSString*)tilte phone:(NSString*)phone time:(NSString*)time image:(UIImage*)image succ:(businessSucc)succ fail:(businessFail)fail;

/**
 *  获取直播列表
 *  @param lastTime 最新时间
 *  @param succ   成功回调
 *  @param fail   失败回调
 */
- (void)getLives:(long)lastTime succ:(businessSucc)succ fail:(businessFail)fail;

/**
 *  获取审核列表
 *
 *  @param lastTime 最新时间
 *  @param succ     成功回调
 *  @param fail     失败回调
 */
- (void)getReviewLives:(long)lastTime succ:(businessSucc)succ fail:(businessFail)fail;

/**
 *  获取隐藏列表
 *
 *  @param lastTime 最新时间
 *  @param succ     成功回调
 *  @param fail     失败回调
 */
- (void)getHiddenLives:(long)lastTime succ:(businessSucc)succ fail:(businessFail)fail;


// 获取关注的直播列表
- (void)getAttentLives:(long)lastTime succ:(businessSucc)succ fail:(businessFail)fail;
// 获取热门直播列表
- (void)getHotLives:(long)lastTime succ:(businessSucc)succ fail:(businessFail)fail;
// 获取最新直播列表
- (void)getNewLives:(long)lastTime succ:(businessSucc)succ fail:(businessFail)fail;

- (void)getActivityLives:(long)lastTime succ:(businessSucc)succ fail:(businessFail)fail;



// 举报
- (void)liveReportSucc:(businessSucc)succ fail:(businessFail)fail;

@end
