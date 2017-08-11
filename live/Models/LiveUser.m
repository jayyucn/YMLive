//
//  LiveUser.m
//  live
//
//  Created by AlexiChen on 15/10/30.
//  Copyright © 2015年 kenneth. All rights reserved.
//

#import "LiveUser.h"

@implementation LiveUser


- (instancetype)init
{
    if (self = [super init])
    {
        _role = ELiveUserRole_Normal;
    }
    return self;
}

- (instancetype)initWithPhone:(NSString *)phone name:(NSString *)name logo:(NSString *)logo
{
    if (self = [self init])
    {
        _userId = phone;
        _userName = name;
        _userLogo = logo;
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    BOOL ise = [super isEqual:object];
    
    if (!ise)
    {
        if ([object isKindOfClass:[LiveUser class]])
        {
            LiveUser *li = (LiveUser *)object;
            ise = [li.userId isEqualToString:_userId];
        }
    }
    return ise;
}

- (BOOL)isInvited
{
    return _role == ELiveUserRole_Interact;
}

- (BOOL)isNormal
{
    return _role == ELiveUserRole_Normal || _role == ELiveUserRole_None;
}
//- (NSString *)logoUrl:(NSInteger)width height:(NSInteger)height
//{
//    if (_userLogo.length)
//    {
//        return [NSString stringWithFormat:URL_IMAGE, _userLogo, width * SCALE, height * SCALE];
//    }
//    return nil;
//}

- (NSString *)avsdkIdentifier
{
//    return [_userId hasPrefix:@"86-"]? _userId : [NSString stringWithFormat:@"86-%@", _userId];
    return _userId;
}


//===================================

// for接口序列化
- (void)setFace:(NSString *)face
{
    _userLogo = face;
}

- (NSString *)face
{
    return _userLogo;
}

- (void)setUsername:(NSString *)username
{
    _userName = username;
}

- (NSString *)username
{
    return _userName;
}

- (void)setUid:(NSString *)uid
{
    _userId = uid;
}

- (NSString *)uid
{
    return  _userId;
}

-(int) grade
{
    return  _userGrade;
}

- (void) setGrade:(int)grade
{
    _userGrade = grade;
}

- (int)offical
{
    return _userOffical;
}

- (void) setOffical:(int)offical
{
    _userOffical = offical;
}

@end


//===========================================================



@implementation LiveItemInfo

@end
