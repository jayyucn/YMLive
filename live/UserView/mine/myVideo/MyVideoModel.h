//
//  MyVideoModel.h
//  XCLive
//
//  Created by 王威 on 15/3/19.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyVideoModel : NSObject
@property (nonatomic, strong)NSString *face;
@property (nonatomic, strong)NSString *videoId;
@property (nonatomic, strong)NSString *videoImag;
@property (nonatomic, strong)NSString *videoUrl;
@property (nonatomic, strong)NSString *timeStr;
@property (nonatomic, strong)NSString *commentStr;


+ (MyVideoModel *)initModelArrayWithData:(NSDictionary *)dic;
@end
