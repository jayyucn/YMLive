//
//  RedPacketManager.h
//  qianchuo
//
//  Created by jacklong on 16/4/29.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

@interface RedPacketManager : NSObject

ES_SINGLETON_DEC(redPacketManager);

@property (nonatomic, strong)NSDictionary    *redPacketDict;

@property (nonatomic, strong)NSMutableArray  *redPacketArray;

#pragma mark - 显示红包
- (void) showRedPacketVC;
@end

