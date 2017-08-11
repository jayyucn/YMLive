//
//  ParseContentCommon.h
//  qianchuo
//
//  Created by jacklong on 16/6/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseContentCommon : NSObject

#pragma mark - 解析礼物消息
- (void) parseGiftMsg:(NSString *)msg withMsgInfo:(NSMutableDictionary *)_showMsgDict;

@end
