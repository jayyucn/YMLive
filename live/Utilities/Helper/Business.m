//
//  Business.m
//  live
//
//  Created by hysd on 15/8/6.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import "Business.h"
#import "Macro.h"
@interface Business(){
}
@end
@implementation Business
static Business *sharedObj = nil;
+ (Business*) sharedInstance
{
    @synchronized (self)
    {
        if (sharedObj == nil)
        {
            sharedObj = [[self alloc] init];
        }
    }
    return sharedObj;
}

- (void)getUserIMTokenSucc:(businessSucc)succ fail:(businessFail)fail
{
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        NSInteger code = [[responseDic objectForKey:@"stat"] integerValue];
        if (URL_REQUEST_SUCCESS == code)
        {
          
            if (succ)
            {
                succ(responseDic[@"msg"],responseDic);
            }
        }
        else
        {
            if (fail)
            {
                fail(responseDic[@"msg"]);
            }
        }
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        if (fail)
        {
            fail(@"获取房间号失败");
        }
    };
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"ry":@(1)}
                                                  withPath:URL_GET_IMTOKEN
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}

- (void)insertLive:(NSString*)title addr:(NSString*)addr withVdoid:(NSString *)vdoid succ:(businessSucc)succ fail:(businessFail)fail
{
  
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        NSLog(@"create live %@",responseDic);
        if (URL_REQUEST_SUCCESS == [[responseDic objectForKey:@"stat"] integerValue])
        {
            if (succ)
            {
                succ(@"插入直播数据成功",responseDic);
            }
        }
        else
        {
            if (fail)
            {
                fail(responseDic[@"msg"]);
            }
        }
        
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error)
    {
        if (fail)
        {
            fail(@"插入直播数据失败");
        }
    };
      
   
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"livetitle":title,@"addr":addr,@"vdoid":vdoid}
                                                      withPath:URL_LIVE_CREATE
                                                   withRESTful:GET_REQUEST
                                              withSuccessBlock:successBlock
                                                 withFailBlock:failBlock];
}


- (void)enterRoomSucc:(businessSucc)succ fail:(businessFail)fail
{
    if (![LCMyUser mine].liveUserId) {
        return;
    }
    
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic)
    {
        NSString* code = [responseDic objectForKey:@"stat"];
        
        if (URL_REQUEST_SUCCESS == [code intValue])
        {
            if (succ)
            {
                succ(@"进入直播数据成功",responseDic);
            }
        }
        else
        {
            if (fail)
            {
                fail(responseDic[@"msg"]);
            }
        }
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error)
    {
        if (fail)
        {
            fail(@"进入直播数据失败");
        }
    };
    
    NSDictionary * paramter = @{@"liveuid":[LCMyUser mine].liveUserId};
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:paramter
                                                  withPath:URL_LIVE_ENTERROOM
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}


-(void)loveLive:(NSInteger)room addCount:(int)count succ:(businessSucc)succ fail:(businessFail)fail
{
    if (![LCMyUser mine].liveUserId) {
        return;
    }
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        NSInteger code = [[responseDic objectForKey:@"stat"] integerValue];
        if (URL_REQUEST_SUCCESS == code)
        {
            if (succ)
            {
                succ(@"",nil);
            }
        }
        else
        {
            if (fail)
            {
                fail(@"");
            }
        }
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        if (fail)
        {
            fail(@"");
        }
    };
    
    NSDictionary *parameter = @{@"roomid":[NSString stringWithFormat:@"%ld",(long)room],@"liveuid":[LCMyUser mine].liveUserId};
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameter
                                                  withPath:URL_LIVE_PARAISE
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}

-(void) closeRoomTimer:(int)timer withVdoid:(NSString *)vdoid withTitle:(NSString *)title withPraise:(int)praise withAudience:(int)audience succ:(businessSucc)succ fail:(businessFail)fail
{
    if (![LCMyUser mine].liveUserId) {
        return;
    }
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        NSInteger code = [[responseDic objectForKey:@"stat"] integerValue];
        if (URL_REQUEST_SUCCESS == code)
        {
            if (succ)
            {
                succ(@"",nil);
            }
        }
        else
        {
            if (fail)
            {
                fail(responseDic[@"msg"]);
            }
        }
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        if (fail)
        {
            fail(@"");
        }
    };
    
    if (![LCMyUser mine].liveUserId || !vdoid || !title) {
        return ;
    }
    NSDictionary *parameter = @{@"liveuid":[LCMyUser mine].liveUserId,@"time":[NSNumber numberWithInt:timer],@"zan":[NSNumber numberWithInt:praise],@"visitor":[NSNumber numberWithInt:audience],@"vdoid":vdoid,@"title":title};
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameter
                                                  withPath:URL_LIVE_CLOSE
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}

- (void)leaveRoom:(NSInteger)room phone:(NSString*)userId succ:(businessSucc)succ fail:(businessFail)fail
{
    if (![LCMyUser mine].liveUserId) {
        return;
    }
    
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        if (URL_REQUEST_SUCCESS == [[responseDic objectForKey:@"stat"] integerValue])
        {
            if (succ)
            {
                succ(@"",nil);
            }
        }
        else
        {
            if (fail)
            {
                fail(responseDic[@"msg"]);
            }
        }

    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        if (fail)
        {
            fail(@"离开房间失败");
        }
    };
    if (!userId) {
        userId = @"";
    }
     NSDictionary *parameter = @{@"userid":userId,@"liveuid":[LCMyUser mine].liveUserId};
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameter
                                                  withPath:URL_LIVE_LEAVEROOM
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}

- (void)getUserListByRoom:(NSInteger)room succ:(businessSucc)succ fail:(businessFail)fail
{
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        NSLog(@"user list %@",responseDic);
        
        if (URL_REQUEST_SUCCESS == [[responseDic objectForKey:@"stat"] integerValue])
        {
            if (succ)
            {
                succ(@"获取在线用户成功",[responseDic objectForKey:@"list"]);
            }
        }
        else
        {
            if (fail)
            {
                fail(@"获取在线用户失败");
            }
        }
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        if (fail)
        {
            fail(@"获取在线用户失败");
        }
    };
    
     NSDictionary *parameter = @{@"liveuid":[LCMyUser mine].userID};
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameter
                                                  withPath:URL_LIVE_USERLIST
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}



- (void)getLives:(long)lastTime succ:(businessSucc)succ fail:(businessFail)fail
{
    
    NSDictionary *parameter = nil;
    if(lastTime != 0)
    {
        parameter = @{@"time":@(lastTime)};
    }

 
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        if (URL_REQUEST_SUCCESS == [[responseDic objectForKey:@"stat"] integerValue])
        {
            NSArray* data = [responseDic objectForKey:@"list"];
            
            if (succ)
            {
                succ(@"获取直播成功", data);
            }
        }
        else
        {
            if (fail)
            {
                fail(@"获取直播失败");
            }
        }
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        if (fail)
        {
            fail(@"获取直播失败");
        }
    };
    
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameter
                                                  withPath:URL_LIVING_HOT
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}


// 获取关注的直播列表
- (void)getAttentLives:(long)lastTime succ:(businessSucc)succ fail:(businessFail)fail
{
    NSDictionary *parameter = nil;
    if(lastTime != 0)
    {
        parameter = @{@"time":@(lastTime)};
    }
    
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        if (URL_REQUEST_SUCCESS == [[responseDic objectForKey:@"stat"] integerValue])
        {
            NSArray* data = [responseDic objectForKey:@"list"];
            
            if (succ)
            {
                succ(@"获取直播成功", data);
            }
        }
        else
        {
            if (fail)
            {
                fail(@"获取直播失败");
            }
        }
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        if (fail)
        {
            fail(@"获取直播失败");
        }
    };
    
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameter
                                                  withPath:URL_LIVING_ATTENT
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}

// 获取热门直播列表
- (void)getHotLives:(long)lastTime succ:(businessSucc)succ fail:(businessFail)fail
{
    NSDictionary *parameter = nil;
    if(lastTime != 0)
    {
        parameter = @{@"time":@(lastTime)};
    }
    
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        NSLog(@"response:%@",responseDic);
        if (URL_REQUEST_SUCCESS == [[responseDic objectForKey:@"stat"] integerValue])
        {
//            NSArray* data = [responseDic objectForKey:@"list"];
            
            if (succ)
            {
                succ(@"获取直播成功", responseDic);
            }
        }
        else
        {
            if (fail)
            {
                fail(@"获取直播失败");
            }
        }
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        if (fail)
        {
            fail(@"获取直播失败");
        }
    };
    
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameter
                                                  withPath:URL_LIVING_HOT
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];}

// 获取最新直播列表
- (void)getNewLives:(long)lastTime succ:(businessSucc)succ fail:(businessFail)fail
{
    NSDictionary *parameter = nil;
    
    if(lastTime != 0)
    {
        parameter = @{@"time":@(lastTime)};
    }
    
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        if (URL_REQUEST_SUCCESS == [[responseDic objectForKey:@"stat"] integerValue])
        {
            NSArray* data = [responseDic objectForKey:@"list"];
            
            if (succ)
            {
                succ(@"获取直播成功", data);
            }
        }
        else
        {
            if (fail)
            {
                fail(@"获取直播失败");
            }
        }
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        if (fail)
        {
            fail(@"获取直播失败");
        }
    };
    
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameter
                                                  withPath:URL_LIVING_New
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}


- (void)getActivityLives:(long)lastTime succ:(businessSucc)succ fail:(businessFail)fail
{
    NSDictionary *parameter = nil;
    
    if(lastTime != 0)
    {
        parameter = @{@"time":@(lastTime)};
    }
    
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        if (URL_REQUEST_SUCCESS == [[responseDic objectForKey:@"stat"] integerValue])
        {
            NSArray* data = [responseDic objectForKey:@"list"];
            
            if (succ)
            {
                succ(@"获取直播成功", data);
            }
        }
        else
        {
            if (fail)
            {
                fail(@"获取直播失败");
            }
        }
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        if (fail)
        {
            fail(@"获取直播失败");
        }
    };
    
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameter
                                                  withPath:URL_LIVING_ACTIVITY
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}



- (void)getReviewLives:(long)lastTime succ:(businessSucc)succ fail:(businessFail)fail
{
    NSDictionary *parameter = nil;
    if(lastTime != 0)
    {
        parameter = @{@"time":@(lastTime)};
    }
    
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        if (URL_REQUEST_SUCCESS == [[responseDic objectForKey:@"stat"] integerValue])
        {
            NSArray* data = [responseDic objectForKey:@"list"];
            
            if (succ)
            {
                succ(@"获取直播成功", data);
            }
        }
        else
        {
            if (fail)
            {
                fail(@"获取直播失败");
            }
        }
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        if (fail)
        {
            fail(@"获取直播失败");
        }
    };
    
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameter
                                                  withPath:URL_LIVING_REVIEW
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}

// 管理员获取隐藏直播列表
- (void)getHiddenLives:(long)lastTime succ:(businessSucc)succ fail:(businessFail)fail
{
    NSDictionary *parameter = nil;
    if(lastTime != 0)
    {
        parameter = @{@"time":@(lastTime)};
    }
    
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        if (URL_REQUEST_SUCCESS == [[responseDic objectForKey:@"stat"] integerValue])
        {
            NSArray* data = [responseDic objectForKey:@"list"];
            
            if (succ)
            {
                succ(@"获取直播成功", data);
            }
        }
        else
        {
            if (fail)
            {
                fail(@"获取直播失败");
            }
        }
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        if (fail)
        {
            fail(@"获取直播失败");
        }
    };
    
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameter
                                                  withPath:URL_LIVING_HIDDEN
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}

- (void)liveReportSucc:(businessSucc)succ fail:(businessFail)fail
{
    if (![LCMyUser mine].liveUserId) {
        return;
    }
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        if (URL_REQUEST_SUCCESS == [[responseDic objectForKey:@"stat"] integerValue])
        {
            if (succ)
            {
                succ(@"举报成功！感谢您的举报",responseDic);
            }
        }
        else
        {
            if (fail)
            {
                
                fail(@"举报失败");
            }
        }
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        if (fail)
        {
            fail(@"举报失败");
        }
    };
    
    NSDictionary *parameter = @{@"type":@"1",@"liveuid":[LCMyUser mine].liveUserId};
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameter
                                                  withPath:URL_LIVE_REPORT
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}

@end
