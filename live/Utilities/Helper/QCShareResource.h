//
//  QCShareResource.h
//  qianchuo
//
//  Created by jacklong on 16/5/2.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

UIKIT_EXTERN NSString *const QCShareTitle;//分享主题
UIKIT_EXTERN NSString *const QCShareDescription;//详细信息
UIKIT_EXTERN NSString *const QCShareUrlString;//url地址
UIKIT_EXTERN NSString *const QCShareImageUrl;//图片url
UIKIT_EXTERN NSString *const QCShareImageName;//本地图片

@interface QCShareResource : NSObject

ES_SINGLETON_DEC(shareResource);

@property (nonatomic,strong)NSString *shareTitle;
@property (nonatomic,strong)NSString *shareDescription;
@property (nonatomic,strong)NSString *shareUrlString;
@property (nonatomic,strong)NSString *shareImgUrl;

@end
