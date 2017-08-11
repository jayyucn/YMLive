//
//  LiveGiftFile.h
//  礼物缓存
//
//  Created by jacklong on 16/3/5.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^RequestGiftStoreBlock)(NSDictionary *storeDics);
typedef void(^GetGiftImageBlock)(int giftKey, UIImage *giftImage);

extern NSInteger KFGiftID_Fireworks;

@interface LiveGiftFile : NSObject

@property (nonatomic,strong)UIImage *giftImage;
@property (nonatomic,strong)NSDictionary *giftFrames;
@property (nonatomic,strong)NSDictionary *giftsDic;


// 创建缓存礼物文件
+ (LiveGiftFile *)sharedLiveGiftFile;
// 获取礼物路径
+(NSString *)getGiftPath;
// 创建礼物文档
+(void)creatGiftDocument;
// 礼物写入缓存文件
+(BOOL)writeGiftFile:(NSDictionary *)giftDic;
// 读取礼物列表
+(NSDictionary *)readGiftList;
// 检查礼物图片是否存在
-(BOOL)giftImageExist:(int)giftKey;
// 获取礼物图片
-(UIImage *)getGiftImage:(int)giftKey;

// 获取礼物图片
-(void)getGiftImage:(int)giftKey withBlock:(GetGiftImageBlock)getGiftImageBlock;

// 获取礼物对象
- (NSDictionary *)giftWithID:(NSInteger)giftID;

#pragma mark - 更新礼物列表
+ (void) updateGiftList:(int)newVersion;

+(void)requestGiftList;



@end

