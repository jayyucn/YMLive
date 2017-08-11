//
//  NearbyUserModel.m
//  qianchuo 附近的用户对象
//


#import "NearbyUserModel.h"


@implementation NearbyUserModel

- (NearbyUserModel *)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init])
    {
        NSString *uid = nil;
        if (!ESStringVal(&uid, dict[@"uid"]))
        {
            return nil;
        }
        self.uid = uid;
        
        NSString *nickname;
        ESStringVal(&nickname, dict[@"nickname"]);
        self.nickname = nickname;
        
        NSString *face;
        ESStringVal(&face, dict[@"face"]);
        self.face = face;
        
        NSInteger sex;
        ESIntegerVal(&sex, dict[@"sex"]);
        self.sex = sex;
        
        NSString *distance;
        ESStringVal(&distance, dict[@"distance"]);
        self.distance = distance;
        
        NSString *last_login_time;
        ESStringVal(&last_login_time, dict[@"login_time"]);
        self.last_login_time = last_login_time;
    }
    
    return self;
}

+ (NearbyUserModel *)modelWithDictionary:(NSDictionary *)dict
{
    NearbyUserModel *model = [[NearbyUserModel alloc] initWithDictionary:dict];
    
    return model;
}

@end
