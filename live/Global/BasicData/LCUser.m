//
//  KFUser.m
//  KaiFang
//
//  Created by Elf Sundae on 13-10-28.
//  Copyright (c) 2013年 www.0x123.com. All rights reserved.
//

#import "LCUser.h"

NSString *const LCUserLiveRecDiamondDidChangeNotification = @"LCUserLiveRecDiamondDidChangeNotification";
NSString *const LCUserLiveDiamondDidChangeNotification = @"LCUserLiveDiamondDidChangeNotification";
NSString *const LCUserLiveSendDiamondDidChangeNotification = @"LCUserLiveSendDiamondDidChangeNotification";
NSString *const LCUserMyRecDiamondDidChangeNotification = @"LCUserMyRecDiamondDidChangeNotification";

@implementation LCUser

- (id)init
{
    self = [super init];
    if (self) {
        _sex = LCSexNone;
        
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"<%@: %p>\n"
            @"UserID: %@\n"
            @"Nickname: %@\n"
            @"GAG: %@\n",
            NSStringFromClass([self class]), self,
            self.userID,
            self.nickname,
            self.gagUserIdsStr];
}

- (void)setImToken:(NSString *)imToken {
    //    imToken = @"abcdefg";
    NSLog(@"im before %@", imToken);
    if (imToken && imToken.length > 5) {
        NSString *str = [imToken substringWithRange:NSMakeRange(imToken.length - 5, 5)];
        NSString *ret = [imToken substringWithRange:NSMakeRange(0, imToken.length - 5)];
        NSMutableString *token = [NSMutableString stringWithString:ret];
        [token insertString:str atIndex:0];
        NSLog(@"im after %@", token);
        _imToken = token;
    }
    else {
        _imToken = imToken;
    }
}



- (BOOL)fillWithDictionary:(NSDictionary *)dict
{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    
    NSString *uid = nil;
    if (!ESStringVal(&uid, dict[@"uid"])) {
        return NO;
    }
    self.userID = uid;
    
    NSString *userSig = nil;
    ESStringVal(&userSig, dict[@"usersig"]);
    self.userSig = userSig;
    
    
    self.imToken = ESStringValueWithDefault(dict[@"im_token"], @""); //添加默认值
    
    NSString *nickname = @"";
    ESStringVal(&nickname, dict[@"nickname"]);
    self.nickname = nickname;
    
    NSString *tagFlag = nil;
    ESStringVal(&tagFlag, dict[@"tag"]);
    self.tagFlag = tagFlag;
    
    NSString *account = @"";
    ESStringVal(&account, dict[@"account"]);
    self.account = account;
    
    NSString *goodID = @"";
    ESStringVal(&goodID, dict[@"goodid"]);
    self.goodID = goodID;
    
    NSString *face = @"";
    ESStringVal(&face, dict[@"face"]);
    self.faceURL = face;
    
    LCSex sex = LCSexNone;
    ESIntegerVal(&sex, dict[@"sex"]);
    self.sex = (LCSex)sex;
    
    NSString *birthday = @"";
    ESStringVal(&birthday, dict[@"birthday"]);
    self.birthday = birthday;
    
    int diamond = 0;
    ESIntVal(&diamond, dict[@"diamond"]);
    self.diamond = diamond;
    
    int atten_total = 0;
    ESIntVal(&atten_total, dict[@"atten_total"]);
    self.atten_total = atten_total;
    
    int fans_total = 0;
    ESIntVal(&fans_total, dict[@"fans_total"]);
    self.fans_total = fans_total;
    
    int live_total = 0;
    ESIntVal(&live_total, dict[@"live_total"]);
    self.live_total = live_total;
    
    int recv_diamond = 0;
    ESIntVal(&recv_diamond, dict[@"recv_diamond"]);
    self.recv_diamond = recv_diamond;
    
    int send_diamond = 0;
    ESIntVal(&send_diamond, dict[@"send_diamond"]);
    self.send_diamond = send_diamond;
    
    int userGrade = 0;
    ESIntVal(&userGrade, dict[@"grade"]);
    self.userLevel = userGrade;
    
    NSString *prov = @"";
    ESStringVal(&prov, dict[@"prov"]);
    self.province = prov;
    
    
    NSString *city = @"";
    ESStringVal(&city, dict[@"city"]);
    self.city = city;
    
    NSString *sign = @"";
    ESStringVal(&sign, dict[@"signature"]);
    self.signature = sign;
    
    int charm = 0;
    ESIntVal(&charm, dict[@"charm"]);
    self.userCharm = charm;
    
    int grade = 0;
    ESIntVal(&grade, dict[@"grade"]);
    self.userLevel = grade;
    
    if([dict[@"show_manager"] isKindOfClass:[NSString class]] || [dict[@"show_manager"] isKindOfClass:[NSNumber class]]) {
        int showManager = 0;
        ESIntVal(&showManager, dict[@"show_manager"]);
        self.showManager = showManager;
        NSLog(@"%d %d",self.showManager,showManager);
    }
    NSLog(@"%@",dict[@"show_manager"]);
    //        unsigned long long wage = 0;
    //        ESULongLongVal(&wage, dict[@"wage"]);
    //        self.wage = wage;
    
    //        LCMarriageType  marry = LCUnmarried;
    //        ESIntegerVal(&marry, dict[@"marry"]);
    //        self.marry = (LCMarriageType)marry;
    
    //        NSInteger height = 0;
    //        ESIntegerVal(&height, dict[@"height"]);
    //        self.height = height;
    
    
    //        NSString *degree = LCDegreeName(LCDegreePrimary);
    //        ESStringVal(&degree, dict[@"degree"]);
    //        self.degree = degree;
    
    //                NSString *ithink = @"";
    //        ESStringVal(&ithink, dict[@"ithink"]);
    //        self.ithink = ithink;
    
    //        NSString *monologue = @"";
    //        ESStringVal(&monologue, dict[@"dubai"]);
    //        self.monologue = monologue;
    
    
    
    float longitude = 0;
    ESFloatVal(&longitude, dict[@"longitude"]);
    self.longitude = longitude;
    
    float latitude = 0;
    ESFloatVal(&latitude, dict[@"latitude"]);
    self.latitude = latitude;
    
    //        NSString *realname = @"";
    //        ESStringVal(&realname, dict[@"realname"]);
    //        self.realname = realname;
    //
    //        NSString *car = @"";
    //        ESStringVal(&car, dict[@"car"]);
    //        self.car = car;
    
    
    //        NSString *good = @"";
    //        ESStringVal(&good, dict[@"good"]);
    //        self.good = good;
    //
    //
    //        NSString *hobbies = @"";
    //        ESStringVal(&hobbies, dict[@"hobbies"]);
    //        self.hobbies = hobbies;
    
    
    //        NSString *home_city = @"";
    //        ESStringVal(&home_city, dict[@"home_city"]);
    //        self.home_city = home_city;
    //
    //
    //        NSString *home_prov = @"";
    //        ESStringVal(&home_prov, dict[@"home_prov"]);
    //        self.home_prov = home_prov;
    
    
    //        NSString *house = @"";
    //        ESStringVal(&house, dict[@"house"]);
    //        self.house = house;
    //
    //        NSString *stature = @"";
    //        ESStringVal(&stature, dict[@"stature"]);
    //        self.stature = stature;
    
    //        NSString *job = @"";
    //        ESStringVal(&job, dict[@"job"]);
    //        self.job = job;
    //
    //        NSString *videoURL = @"";
    //        ESStringVal(&videoURL, dict[@"video"]);
    //        self.videoURL = videoURL;
    //
    //        NSString *age = @"";
    //        ESStringVal(&age, dict[@"age"]);
    //        self.age = age;
    return YES;
}

+ (instancetype)userWithDictionary:(NSDictionary *)dict forUserID:(NSString *)userID
{
    if (![dict isKindOfClass:[NSDictionary class]] ||
        ![userID isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:dict];
    dictionary[@"uid"] = userID;
    
    return [self userWithDictionary:(NSDictionary *)dictionary];
}

+ (instancetype)userWithDictionary:(NSDictionary *)dict
{
    LCUser *user = [[self alloc] init];
    if (![user fillWithDictionary:dict]) {
        return nil;
    }
    return user;
}


#pragma mark -- custom fuction

- (NSDate *)dirthdayDate{
    
    if([self.birthday isEqualToString:@""])
    {
        return nil;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    
    NSDate *destDate= [dateFormatter dateFromString:self.birthday];
    
    return destDate;
    
}

-(void)modifyInfo:(NSDictionary *)dict
{
    for(NSString *name in [dict allKeys])
    {
        if([name isEqualToString:@"nickname"])
        {
            NSString *nickname = @"";
            ESStringVal(&nickname, dict[@"nickname"]);
            self.nickname = nickname;
        }
        else if([name isEqualToString:@"sex"])
        {
            LCSex sex = LCSexNone;
            ESIntegerVal(&sex, dict[@"sex"]);
            self.sex = (LCSex)sex;
            
        }
        else if([name isEqualToString:@"birthday"])
        {
            NSString *birthday = @"";
            ESStringVal(&birthday, dict[@"birthday"]);
            self.birthday = birthday;
            
        }
        else if([name isEqualToString:@"account"])
        {
            NSString *account = @"";
            ESStringVal(&account, dict[@"account"]);
            self.account = account;
        }
        else if ( [name isEqualToString:@"usersig"])
        {
            NSString * usersig = nil;
            ESStringVal(&usersig, dict[@"usersig"]);
            self.userSig = usersig;
        }
    }
}

- (void)setLiveRecDiamond:(int)liveRecDiamond
{
    _liveRecDiamond = liveRecDiamond;
   
    if ([LCMyUser mine].liveUserId
            && [[LCMyUser mine].liveUserId isEqualToString:[LCMyUser mine].userID]) {
        [LCMyUser mine].recv_diamond = _liveRecDiamond;
    }
    
    ESWeakSelf
    ESDispatchOnMainThreadAsynchrony(^{
        ESStrongSelf;
        [[NSNotificationCenter defaultCenter] postNotificationName:LCUserLiveRecDiamondDidChangeNotification object:_self];
    });
}

- (void)setDiamond:(int)diamond
{
    _diamond = diamond;
    ESWeakSelf;
    ESDispatchOnMainThreadAsynchrony(^{
        ESStrongSelf;
        [[NSNotificationCenter defaultCenter] postNotificationName:LCUserLiveDiamondDidChangeNotification object:_self];
    });
}

- (void)setSend_diamond:(int)send_diamond
{
    _send_diamond = send_diamond;
    ESWeakSelf;
    ESDispatchOnMainThreadAsynchrony(^{
        ESStrongSelf;
        [[NSNotificationCenter defaultCenter] postNotificationName:LCUserLiveSendDiamondDidChangeNotification object:_self];
    });
}

- (void) setRecv_diamond:(int)recv_diamond
{
    _recv_diamond = recv_diamond;
    ESWeakSelf;
    ESDispatchOnMainThreadAsynchrony(^{
        ESStrongSelf;
        [[NSNotificationCenter defaultCenter] postNotificationName:LCUserMyRecDiamondDidChangeNotification object:_self];
    });
}

- (BOOL)isVIP
{
    return NO;
    //        return self.VIPLevel > 0;
}
//
//- (NSString *)creditString
//{
//        NSMutableString *star = [NSMutableString string];
//        int credit = self.credit;
//        if (credit > 0) {
//                credit = (int)(floorf((float)credit / 100));
//                credit = MAX(0, MIN(credit, 5));
//                for (int ci = 0; ci < credit; ++ci) {
//                        [star appendString:@"⭐️"];
//                }
//        }
//        return (NSString *)star;
//}

@end
