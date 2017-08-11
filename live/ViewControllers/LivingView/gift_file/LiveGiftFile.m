//
//  LiveGiftFile.m
//  qianchuo
//
//  Created by jacklong on 16/3/5.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "LiveGiftFile.h"

@implementation LiveGiftFile

#define giftPath [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/gift_live"]

static LiveGiftFile *_sharedLiveGiftFile = nil;

+ (LiveGiftFile *)sharedLiveGiftFile
{
    
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        //_sharedDegreeImage =[UIImage imageNamed:@"image/globle/degree"];
        _sharedLiveGiftFile =[[LiveGiftFile alloc] init];
        
        _sharedLiveGiftFile.giftImage=[UIImage imageWithContentsOfFile:[giftPath stringByAppendingPathComponent:@"gift.png"]];
        _sharedLiveGiftFile.giftFrames=[NSDictionary dictionaryWithContentsOfFile:[giftPath stringByAppendingPathComponent:@"giftFrame.plist"]][@"frames"];
        _sharedLiveGiftFile.giftsDic=[LiveGiftFile readGiftList];
        
    });
    return _sharedLiveGiftFile;
}


#pragma mark - 创建礼物文件夹：
+(void)creatGiftDocument
{
    NSString *rootPath=[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:rootPath];
    if (!fileExists) {
        [fileManager createDirectoryAtPath:rootPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *giftDocu=[rootPath stringByAppendingPathComponent:@"gift_live"];
    fileExists = [fileManager fileExistsAtPath:giftDocu];
    
    if (!fileExists) {
        [fileManager createDirectoryAtPath:giftDocu withIntermediateDirectories:YES attributes:nil error:nil];
    }
}




#pragma mark - 获取缓存的文件路径
+(NSString *)getGiftPath
{
    return giftPath;
}

#pragma mark - 写礼物文件
+(BOOL)writeGiftFile:(NSDictionary *)giftDic
{
    NSString *filesPath=[giftPath stringByAppendingPathComponent:@"giftList.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:filesPath])
    {
        [fileManager removeItemAtPath:@"createdNewFile" error:nil];
    }
    
    [fileManager createFileAtPath:filesPath
                         contents:nil
                       attributes:nil];
    
    
    BOOL write =  [giftDic writeToFile:filesPath atomically:NO];
    _sharedLiveGiftFile.giftsDic = [LiveGiftFile readGiftList];
    return write;
}



#pragma mark - 读取礼物列表
+(NSDictionary *)readGiftList
{
    
    NSString *filesPath=[giftPath stringByAppendingPathComponent:@"giftList.plist"];
    
    return [NSDictionary dictionaryWithContentsOfFile:filesPath];
}

#pragma mark - 获取礼物图片
-(UIImage *)getGiftImage:(int)giftKey
{
    NSString *imagePath=[giftPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png", giftKey]];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL success = [fm fileExistsAtPath:imagePath];
    if(success) {
        return [UIImage imageWithContentsOfFile:imagePath];
    }
    else{
        return nil;
    }
}


#pragma mark - 判断礼物图片是否存在
-(BOOL)giftImageExist:(int)giftKey
{
    NSString *imagePath=[giftPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png", giftKey]];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL success = [fm fileExistsAtPath:imagePath];
    if(success) {
        return YES;
    }
    else
    {
        NSString *giftImageURL=[NSString stringWithFormat:@"%@/%d.png",URL_GIFT_HEAD,giftKey];
        
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:giftImageURL]];
        
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:giftImageURL] options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            NSString *requestString=[request URL].relativeString;
            
            NSInteger location = [requestString rangeOfString:@"/" options:NSBackwardsSearch].location;
            
            NSString *imageName=[requestString substringFromIndex:location+1];
            
            NSString *giftImagePath=[[LiveGiftFile getGiftPath] stringByAppendingPathComponent:imageName];
            [UIImagePNGRepresentation(image) writeToFile:giftImagePath atomically:YES];
            
        }];
        return NO;
    }
    
}

#pragma mark - 获取礼物图片
-(void)getGiftImage:(int)giftKey withBlock:(GetGiftImageBlock)getGiftImageBlock
{
    NSString *imagePath=[giftPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png", giftKey]];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL success = [fm fileExistsAtPath:imagePath];
    if(success)
    {
        UIImage *image=[UIImage imageWithContentsOfFile:imagePath];
        getGiftImageBlock(giftKey,image);
    }
    else
    {
        NSString *giftImageURL=[NSString stringWithFormat:@"%@/%d.png",URL_GIFT_HEAD,giftKey];
        
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:giftImageURL]];
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:giftImageURL] options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            NSString *requestString=[request URL].relativeString;
            
            NSInteger location = [requestString rangeOfString:@"/" options:NSBackwardsSearch].location;
            
            NSString *imageName=[requestString substringFromIndex:location+1];
            
            NSString *giftImagePath=[[LiveGiftFile getGiftPath] stringByAppendingPathComponent:imageName];
            NSLog(@"giftImagePath:%@",giftImagePath);
            BOOL isWrite =[UIImagePNGRepresentation(image) writeToFile:giftImagePath atomically:YES];
            NSLog(@"iswrite %d", isWrite);
            getGiftImageBlock(giftKey,[UIImage imageWithContentsOfFile:giftImagePath]);
        }];
    }
}

#pragma mark - 获取礼物对象
- (NSDictionary *)giftWithID:(NSInteger)giftID
{
    //return self.giftsDic[@(giftID)];
    NSString *key = [NSString stringWithFormat:@"%ld", (long)giftID];
    return self.giftsDic[key];
}

#pragma mark - 更新礼物列表
+ (void) updateGiftList:(int)newVersion
{
    /* Gift upgrade */
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    int localGiftVersion = 0;
    ESIntVal(&localGiftVersion, [ud objectForKey:@"giftVersion"]);
    if (localGiftVersion < newVersion) {
        //TODO: 请求完礼物列表再保存最新版本号
        [ud setObject:@(newVersion) forKey:@"giftVersion"];
        [ud setObject:@NO forKey:@"GiftList"];
        [LiveGiftFile requestGiftList];
    } else {
        BOOL isUpdated = NO;
        ESBoolVal(&isUpdated, [ud objectForKey:@"GiftList"]);
        if (!isUpdated) {
            [LiveGiftFile requestGiftList];
        }
    }

}

#pragma mark - 请求礼物列表
+(void)requestGiftList
{
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        
        
        int stat=[responseDic[@"stat"] intValue];
        if(stat==200)
        {
            [LiveGiftFile writeGiftFile:responseDic];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES]
                                                      forKey:@"GiftList"];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒"
                                                            message:responseDic[@"msg"]
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            alert.delegate=self;
            alert.tag=3;
            [alert show];
        }
    };
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        NSLog(@"requestGiftList error =%@",error);
        
    };
     
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"v":[NSNumber numberWithInt:0]}
                                                    withPath:URL_LIVE_GIFT_URL
                                                 withRESTful:GET_REQUEST
                                            withSuccessBlock:successBlock
                                               withFailBlock:failBlock];
    
}

@end

