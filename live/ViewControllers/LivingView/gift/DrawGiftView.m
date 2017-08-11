//
//  DrawGiftView.m
//  HuoWuLive
//
//  Created by 林伟池 on 16/11/18.
//  Copyright © 2016年 上海七夕. All rights reserved.
//

#import "DrawGiftView.h"
#import "SendGiftRequest.h"
#import "DrawBottomSelectView.h"

#define OFFSET_DRAW 10

@implementation DrawGiftView
{
    UIView *mBackgroundView;
    UIView *mBackgroundBottomView;
    UIView *mBackgroundTopView;
    
    NSMutableArray<NSDictionary *> *mDrawPointsArray;
    
    UIView *mCanvasView;
    UIImageView *mCanvasBackgroundView;
    
    DrawBottomSelectView *mBottomSelectView;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initBackgroundView];
        [self initCanvasView];
        [self initBottomSelectView];
        [self resetView];
    }
    return self;
}



#pragma mark - init

- (void)initBackgroundView {
    self.backgroundColor = [UIColor clearColor];
    mBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height / 2 - self.width / 2, self.width, self.width)];
    mBackgroundView.backgroundColor = [UIColor blackColor];
    mBackgroundView.alpha = 0.3;
    [self addSubview:mBackgroundView];
    
    mBackgroundBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height / 2 + self.width / 2, self.width, self.height / 2 - self.width / 2)];
    mBackgroundBottomView.backgroundColor = [UIColor whiteColor];
    mBackgroundBottomView.alpha = 0.3;
    [self addSubview:mBackgroundBottomView];
    
    mBackgroundTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mBackgroundView.width, mBackgroundView.top - 30)];
    [self addSubview:mBackgroundTopView];
    ESWeakSelf;
    [mBackgroundTopView addTapGestureHandler:^(UITapGestureRecognizer *gestureRecognizer, UIView *view, CGPoint locationInView) {
        ESStrongSelf;
        [_self.mDrawDelegate hiddenDrawGiftView];
    }];
    
}

- (void)initCanvasView {
    mCanvasView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height / 2 - self.width / 2, self.width, self.width)];
    mCanvasView.backgroundColor = [UIColor clearColor];
    [self addSubview:mCanvasView];
    mCanvasBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image/liveroom/draw_background"]];
    mCanvasBackgroundView.size = CGSizeMake(95, 105);
    mCanvasBackgroundView.center = CGPointMake(mCanvasView.centerX, mCanvasView.centerY);
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.font = [UIFont systemFontOfSize:15];
    descLabel.textColor = [UIColor whiteColor];
    descLabel.text = @"在此区域绘制礼物图案";
    [descLabel sizeToFit];
    descLabel.center = CGPointMake(mCanvasBackgroundView.width / 2, mCanvasBackgroundView.height + 50);
    [mCanvasBackgroundView addSubview:descLabel];
    [self addSubview:mCanvasBackgroundView];
    
    
    UIButton *mResetBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [mResetBtn setBackgroundImage:[UIImage imageNamed:@"image/liveroom/draw_reset"] forState:UIControlStateNormal];
    mResetBtn.right = self.width - OFFSET_DRAW;
    mResetBtn.top = mCanvasView.top + OFFSET_DRAW;
    [self addSubview:mResetBtn];
    [mResetBtn addTarget:self action:@selector(resetView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *mCloseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [mCloseBtn setBackgroundImage:[UIImage imageNamed:@"image/liveroom/draw_close"] forState:UIControlStateNormal];
    mCloseBtn.left = OFFSET_DRAW;
    mCloseBtn.top = mCanvasView.top + OFFSET_DRAW;
    [self addSubview:mCloseBtn];
    [mCloseBtn addTarget:self action:@selector(onCloseBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initBottomSelectView {
    mBottomSelectView = [[DrawBottomSelectView alloc] initWithFrame:mBackgroundBottomView.frame];
    [self addSubview:mBottomSelectView];
    ESWeakSelf;
    [mBottomSelectView setMDrawSelectBlock:^() {
        ESStrongSelf;
        [_self resetView];
    }];
    [mBottomSelectView setMDrawSendBlock:^() {
        ESStrongSelf;
        [_self sendGiftMsg];
    }];
    [mBottomSelectView setMDrawRechargeBlock:^() {
        ESStrongSelf;
        if (_self.mDrawDelegate) {
            [_self.mDrawDelegate drawShowRecharge];
        }
    }];
}

#pragma mark - ui
- (void)onCloseBtnClick {
    if (self.mDrawDelegate) {
        [self.mDrawDelegate hiddenDrawGiftView];
    }
}


- (void)resetView {
    mDrawPointsArray = [NSMutableArray array];
    self.mDrawCount = @(0);
    [mCanvasView removeAllSubviews];
}
#pragma mark - update


#pragma mark - get / set
- (void)setMDrawCount:(NSNumber *)mDrawCount {
    mBottomSelectView.mDrawCount = mDrawCount;
    if (mDrawCount.intValue > 0) {
        mCanvasBackgroundView.hidden = YES;
    }
    else {
        mCanvasBackgroundView.hidden = NO;
    }
    _mDrawCount = mDrawCount;
}


#pragma mark - delegate


- (BOOL)isSubview:(UIView *)view {
    return self == view || [self.subviews containsObject:view] || [[mCanvasView subviews] containsObject:view];
}

#pragma mark - touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([touches anyObject].view == mCanvasView) {
        CGPoint point = [[touches anyObject] locationInView:mCanvasView];
        UIImageView *imageView = [self getOnePointWith:point];
        if (imageView && mDrawPointsArray.count < POINT_MAX_COUNT) {
            [mDrawPointsArray addObject:@{@"x":[NSString stringWithFormat:@"%.3f", point.x],
                                          @"y":[NSString stringWithFormat:@"%.3f", point.y]}];
            self.mDrawCount = @(mDrawPointsArray.count);
            [mCanvasView addSubview:imageView];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([touches anyObject].view == mCanvasView) {
        CGPoint point = [[touches anyObject] locationInView:mCanvasView];
        UIImageView *imageView = [self getOnePointWith:point];
        if (imageView && mDrawPointsArray.count < POINT_MAX_COUNT) {
            [mDrawPointsArray addObject:@{@"x":[NSString stringWithFormat:@"%.3f", point.x],
                                          @"y":[NSString stringWithFormat:@"%.3f", point.y]}];
            self.mDrawCount = @(mDrawPointsArray.count);
            [mCanvasView addSubview:imageView];
        }
    }
}

- (UIImageView *)getOnePointWith:(CGPoint)point {
    UIImageView *ret;
    if (CGRectContainsRect(mCanvasView.bounds, CGRectMake(point.x, point.y, POINT_SIZE_WIDTH, POINT_SIZE_HEIGHT))) {
        
        if (mDrawPointsArray.count > 0) {
            NSDictionary *dict = [mDrawPointsArray lastObject];
            CGPoint lastPoint = CGPointMake([(NSString *)dict[@"x"] floatValue], [(NSString *)dict[@"y"] floatValue]);
            if (fabs(lastPoint.x - point.x) < POINT_SIZE_WIDTH / 2 && fabs(lastPoint.y - point.y) < POINT_SIZE_HEIGHT / 2) {
                return nil;
            }
        }
        ret = [[UIImageView alloc] initWithFrame:CGRectMake(point.x, point.y, POINT_SIZE_WIDTH, POINT_SIZE_HEIGHT)];
        ret.image = [UIImage imageNamed:[NSString stringWithFormat:@"image/liveroom/draw_gift_item%d", mBottomSelectView.mSelectIndex.intValue]];
    }
    
    
    return ret;
}


#pragma mark - message
- (NSDictionary *)convertPointsData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 @(mCanvasView.size.width), @"square_size",
                                 @([mDrawPointsArray count] * 2), @"point_count",
                                 mDrawPointsArray, @"point_data",
                                 mBottomSelectView.mSelectIndex, @"point_type",
                                 nil];
    return dict;
}


- (void)sendGiftMsg {
    //是否选择有礼物
    int selectGiftId = PAINT_GIFT;
    
    int cost = self.mDrawCount.intValue * 10;

    if (cost > [LCMyUser mine].diamond) {
        ESWeakSelf;
        UIAlertView *alertView = [UIAlertView alertViewWithTitle:@"提示" message:@"余额不足，请充值！" cancelButtonTitle:@"确认" didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            ESStrongSelf;
            if (_self.mDrawDelegate) {
                [_self.mDrawDelegate drawShowRecharge];
            }
        } otherButtonTitles:nil, nil];
        [alertView show];
        return ;
    }

    
    ESWeakSelf;
    NSDictionary *giftParamDic=@{@"giftid":[NSNumber numberWithInt:selectGiftId],
                                 @"uid":[LCMyUser mine].userID,
                                 @"liveuid":[LCMyUser mine].liveUserId,
                                 @"num":self.mDrawCount,
                                 @"type":@(1)
                                 };
    
    [SendGiftRequest sendDrawGift:giftParamDic
                      succeed:^(NSDictionary *responseDic) {
                          ESStrongSelf;
                          NSLog(@"responseDic==%@",responseDic);
                          int stat=[responseDic[@"stat"] intValue];
                          if(stat==200)
                          {
                              [_self sendRoomMsgWith:responseDic];
                          }
                          else if (520 == stat)
                          {
                              UIAlertView *alertView = [UIAlertView alertViewWithTitle:@"提示" message:@"余额不足，请充值！" cancelButtonTitle:@"确认" didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                  ESStrongSelf;
                                  if (_self.mDrawDelegate) {
                                      [_self.mDrawDelegate drawShowRecharge];
                                  }
                              } otherButtonTitles:nil, nil];
                              [alertView show];
                          }
                          else
                          {
                              [LCNoticeAlertView showMsg:responseDic[@"msg"]];
                          }
                          
                      } failed:^(NSError *error) {
                          NSLog(@"send gift fail");
                      }];
}

- (void)sendRoomMsgWith:(NSDictionary *)responseDic {
    
    [LCMyUser mine].diamond = [responseDic[@"diamond"] intValue];
    [LCMyUser mine].send_diamond = [responseDic[@"send_diamond"] intValue];
    int tempLiveRecDiamond = [responseDic[@"recv_diamond"] intValue];
    if (![LCMyUser mine].playBackUserId) {
        if (tempLiveRecDiamond > [LCMyUser mine].liveRecDiamond) {
            [LCMyUser mine].liveRecDiamond = tempLiveRecDiamond;
        }
    }
    
    NSMutableDictionary *sendGift = [NSMutableDictionary dictionary];
    sendGift[@"gift_id"] = [NSNumber numberWithInt:PAINT_GIFT];
    sendGift[@"gift_nums"] = @(mDrawPointsArray.count);
    sendGift[@"gift_type"] = @(GIFT_TYPE_LUXURY);
    sendGift[@"gift_name"] = [NSString stringWithFormat:@"%lu个性礼物", (unsigned long)mDrawPointsArray.count];
    sendGift[@"price"] = @(10);
    sendGift[@"recv_diamond"] = responseDic[@"recv_diamond"];
    sendGift[@"type"] = LIVE_GROUP_GIFT;              // 消息类型
    sendGift[@"uid"] = [LCMyUser mine].userID;        // 用户id
    sendGift[@"nickname"] = [LCMyUser mine].nickname; // 用户昵称
    sendGift[@"face"] = [LCMyUser mine].faceURL;      // 用户头像
    sendGift[@"offical"] = @([LCMyUser mine].showManager?1:0);
    if ([responseDic[@"grade"] intValue] > 0) {
        sendGift[@"grade"] = responseDic[@"grade"];  // 用户级别 (用户升级后会返回)
    } else {
        sendGift[@"grade"] = @([LCMyUser mine].userLevel);  // 用户级别
    }
    sendGift[@"paint"] = [self convertPointsData];
    [LiveMsgManager sendGiftMsg:sendGift andSucc:nil andFail:nil];
    [self resetView];
    [self.mDrawDelegate drawSendWithDict:sendGift];
    [self.mDrawDelegate hiddenDrawGiftView];

}
@end
