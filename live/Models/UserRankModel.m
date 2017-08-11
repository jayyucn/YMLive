//
//  UserRankModel.m
//  qianchuo 
//
//  Created by jacklong on 16/3/30.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "UserRankModel.h"

@implementation UserRankModel

-(UserRankModel *)initWithDictionary:(NSDictionary *)dict
{
    if (self=[super init])
    {
        NSString *uid = nil;
        if (!ESStringVal(&uid, dict[@"uid"])) {
            return  nil;
        }
        self.uid = uid;
        
        NSString *face;
        ESStringVal(&face,dict[@"face"]);
        self.face = face;
        
        LCSex sex;
        ESIntegerVal(&sex,dict[@"sex"]);
        self.sex = sex;
        
        int send_diamond;
        ESIntVal(&send_diamond,dict[@"send_diamond"]);
        self.send_diamond = send_diamond;
        
        int recv_diamond;
        ESIntVal(&recv_diamond,dict[@"recv_diamond"]);
        self.recv_diamond = recv_diamond;
        
        int consume_diamond;
        ESIntVal(&consume_diamond,dict[@"consume_diamond"]);
        self.consume_diamond = consume_diamond;
        
        NSString *nickname;
        ESStringVal(&nickname,dict[@"nickname"]);
        self.nickname = nickname;
        
        NSString *tag;
        ESStringVal(&tag,dict[@"tag"]);
        self.tag = tag;
        
        NSString *signature;
        ESStringVal(&signature,dict[@"signature"]);
        self.signature = signature;

        int grade;
        ESIntVal(&grade,dict[@"grade"]);
        self.grade = grade;
        
        int offical = 0;
        ESIntVal(&offical,dict[@"offical"]);
        self.offical = offical;
    }
    return self;
}

+(UserRankModel *)modelWithDictionary:(NSDictionary *)dict
{
    UserRankModel *model=[[UserRankModel alloc] initWithDictionary:dict];
    return model;
}
@end
