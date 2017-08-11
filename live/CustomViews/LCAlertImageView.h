//
//  LCAlertImageView.h
//  XCLive
//
//  Created by ztkztk on 14-6-19.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "LCCancelAndOKView.h"

typedef void(^AlertImageOKBlock)(NSDictionary *imageDic);
@interface LCAlertImageView : LCCancelAndOKView
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)NSDictionary *imageDic;
@property (nonatomic,copy)AlertImageOKBlock alertImageBlock;

+(void)showAlertImage:(NSDictionary *)imageDic withBlock:(AlertImageOKBlock)alertImageBlock;

@end
