//
//  UserRankModel.h
//  qianchuo 排行榜用户对象
//
//  Created by jacklong on 16/3/30.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

@interface UserRankModel : NSObject

@property (nonatomic, strong) NSString  *uid;
@property (nonatomic, strong) NSString  *face;
@property (nonatomic, assign) LCSex     sex;
@property (nonatomic, assign) int       send_diamond;
@property (nonatomic, assign) int       recv_diamond;
@property (nonatomic, assign) int       consume_diamond;
@property (nonatomic, strong) NSString  *nickname;
@property (nonatomic, strong) NSString  *tag;
@property (nonatomic, strong) NSString  *signature;
@property (nonatomic, assign) int       grade;
@property (nonatomic, assign) int       offical;

-(UserRankModel *)initWithDictionary:(NSDictionary *)dict;

+(UserRankModel *)modelWithDictionary:(NSDictionary *)dict;

@end
