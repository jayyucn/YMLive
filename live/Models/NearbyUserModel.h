//
//  NearbyUserModel.h
//  qianchuo 附近的用户对象
//


@interface NearbyUserModel : NSObject

@property (nonatomic, strong) NSString  *uid;
@property (nonatomic, strong) NSString  *nickname;
@property (nonatomic, strong) NSString  *face;
@property (nonatomic, assign) NSInteger sex;

@property (nonatomic, strong) NSString  *distance;
@property (nonatomic, strong) NSString  *last_login_time;

- (NearbyUserModel *)initWithDictionary:(NSDictionary *)dict;

+ (NearbyUserModel *)modelWithDictionary:(NSDictionary *)dict;

@end
