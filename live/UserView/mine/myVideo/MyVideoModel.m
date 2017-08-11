//
//  MyVideoModel.m
//  XCLive
//
//  Created by 王威 on 15/3/19.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import "MyVideoModel.h"

@implementation MyVideoModel

+ (MyVideoModel *)initModelArrayWithData:(NSDictionary *)dic
{
    MyVideoModel *model = [[MyVideoModel alloc] init];
    model.face = dic[@"face"];
    model.videoId = NSStringWith(@"%@",dic[@"id"]);
    model.videoImag = NSStringWith(@"%@",dic[@"img"]);
    model.videoUrl = NSStringWith(@"%@",dic[@"url"]);
    model.timeStr = NSStringWith(@"%@",dic[@"time"]);
    model.commentStr = NSStringWith(@"%@",dic[@"comm_total"]);
    return model;
}
@end
