//
//  MyInfoModel.h
//  TaoHuaLive
//
//  Created by kellyke on 2017/6/30.
//  Copyright © 2017年 上海七夕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyInfoModel : NSObject

@property(nonatomic, assign) int atten_total;
@property(nonatomic, copy) NSString *city;
@property(nonatomic, assign) int diamond;
@property(nonatomic, assign) int distance;
@property(nonatomic, assign) int exchange_diamond;
@property(nonatomic, assign) int exp_value;
@property(nonatomic, assign) int fans_total;
@property(nonatomic, assign) int goodid;
@property(nonatomic, assign) int guard;
@property(nonatomic, assign) int is_live;
@property(nonatomic, copy) NSString *lat;
@property(nonatomic, copy) NSString *lng;
@property(nonatomic, assign) int offical;
@property(nonatomic, assign) int onetone;
@property(nonatomic, assign) int recv_diamond;
@property(nonatomic, assign) int room_manager;

@property(nonatomic, copy) NSString *tag;
@property(nonatomic, strong)NSArray *tops;
@property(nonatomic, assign) int type;
@property(nonatomic, copy) NSString *url;
@property(nonatomic, assign) int wx_bindid;
@property(nonatomic, assign) int zuojia;
@property(nonatomic, copy) NSString *nickname; //昵称
@property(nonatomic, assign) int uid; //id
@property(nonatomic, copy) NSString *signature;//签名
@property(nonatomic, assign) int send_diamond;//送出的钻石
@property(nonatomic, copy) NSString *face; //头像
@property(nonatomic, assign) int sex;//性别
@property(nonatomic, assign) int grade; //等级



@end
