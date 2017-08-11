//
//  BarrageAllMsgView.h
//  qianchuo 所有弹幕消息
//
//  Created by jacklong on 16/3/14.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "BarrageMsgView.h"

@interface BarrageAllMsgView : UIView

@property (nonatomic, strong)BarrageMsgView *barrageFirstView;
@property (nonatomic, strong)BarrageMsgView *barrageSecondView;
@property (nonatomic, strong)BarrageMsgView *barrageThreeView;

@property (nonatomic, strong)NSMutableArray *barrageInfoArray;


-(void) showBarrageAnimation;
@end
