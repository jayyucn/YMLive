//
//  LuxuryManager.h
//  qianchuo
//
//  Created by jacklong on 16/4/16.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//


@interface LuxuryManager : NSObject

ES_SINGLETON_DEC(luxuryManager);

@property (nonatomic, assign)BOOL            isShowAnimation;

@property (nonatomic, strong)NSDictionary    *luxuryDict;

@property (nonatomic, strong)NSMutableArray  *luxuryArray;

@property (nonatomic, strong)UIView          *livingView;

- (void) showLuxuryAnimation;
@end
