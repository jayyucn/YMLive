//
//  DrawBottomSelectView.h
//  HuoWuLive
//
//  Created by 林伟池 on 16/11/21.
//  Copyright © 2016年 上海七夕. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DrawSelectBlcok)();
typedef void(^DrawSendBlcok)();
typedef void(^DrawRechargeBlcok)();

@interface DrawBottomSelectView : UIView

@property (nonatomic , strong) NSNumber *mSelectIndex;
@property (nonatomic , strong) NSNumber *mDrawCount;
@property (nonatomic , copy) DrawSendBlcok mDrawSendBlock;
@property (nonatomic , copy) DrawSelectBlcok mDrawSelectBlock;
@property (nonatomic , copy) DrawRechargeBlcok mDrawRechargeBlock;

@end
