//
//  GSPChatMessage.h
//  presentAnimation
//
//  Created by jacklong on 16/7/28.
//  Copyright © 2016年 jacklong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSPChatMessage : NSObject

@property (nonatomic,retain) NSString *senderName;
@property (nonatomic,retain) NSString *text;
@property (nonatomic,retain) NSString *senderChatID;
@property (nonatomic,retain) NSString *senderGrade;

@end
