//
//  LiveGiftView.m
//  qianchuo
//
//  Created by jacklong on 16/3/5.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "LiveGiftView.h"
#import "UIImage+Category.h"
#import "SendGiftRequest.h"
#import "LiveMsgManager.h"

#define GiftViewHeight 241
#define START_TIME  30
@interface LiveGiftView() {
    int countTime;
    NSTimer * _refreshTimer;
    BOOL bLongPress;
    dispatch_queue_t __gSendingMessagesQueue;
}
@end

@implementation LiveGiftView

- (void)dealloc
{
    NSLog(@"livegiftview dealloc %@",NSStringFromClass(self.class));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
    [self removeFromSuperview];
    
    __gSendingMessagesQueue = nil;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //        self.frame=CGRectMake(0,0, 320, ScreenHeight);
        self.frame=CGRectMake(0,0, ScreenWidth, ScreenHeight);
        
        _DispalyArea=[[UIView alloc] initWithFrame:CGRectMake(0,ScreenHeight - GiftViewHeight, ScreenWidth, GiftViewHeight)];
        [self addSubview:_DispalyArea];
        _DispalyArea.userInteractionEnabled=YES;
        
        self.backgroundColor=[UIColor clearColor];
        UIImage *backImage = [UIImage createImageWithColor:RGBA16(0x30000000)];
        
        //        UIImage *image = [backImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 0, 0, 0)];
        
        UIImageView *backView=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,GiftViewHeight)];
        backView.image=backImage;
        [_DispalyArea addSubview:backView];
        
        
        _selectImg = [[UIImageView alloc] initWithImage:[UIImage createImageWithColor:RGBA16(0xff61b3)]];
        [_DispalyArea addSubview:_selectImg];
        
        _bottomView=[[UIView alloc] initWithFrame:CGRectMake(0,_DispalyArea.height - 50,ScreenWidth,50)];
        _bottomView.userInteractionEnabled=YES;
        _bottomView.backgroundColor = [UIColor blackColor];
        [_DispalyArea addSubview:_bottomView];
        
        _rechargeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/2, 50)];
        _rechargeView.userInteractionEnabled=YES;
        [_bottomView addSubview:_rechargeView];
        
        _rechargeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 40, 50)];
        _rechargeLabel.textAlignment = NSTextAlignmentCenter;
        _rechargeLabel.textColor=[UIColor yellowColor];
        _rechargeLabel.font=[UIFont systemFontOfSize:13];
        _rechargeLabel.backgroundColor =[UIColor clearColor];
        _rechargeLabel.text = @"充值: ";
        [_rechargeView addSubview:_rechargeLabel];
        
        _diamondLabel = [[UILabel alloc] initWithFrame:CGRectMake(_rechargeLabel.right+2, 5, ScreenWidth/2 - 45, 50)];
        _diamondLabel.textAlignment = NSTextAlignmentLeft;
        _diamondLabel.textColor=[UIColor yellowColor];
        _diamondLabel.font=[UIFont systemFontOfSize:14];
        _diamondLabel.backgroundColor =[UIColor clearColor];
        [_rechargeView addSubview:_diamondLabel];
        
        [self setCurrentBalance];
        
        
        UIImage *sendImage = [UIImage createImageWithColor:[UIColor blackColor]];
        _sendGiftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        _sendBtn.backgroundColor = UIColorFromRGB(248, 113, 198);
        
        [_sendGiftBtn setBackgroundImage:sendImage
                                forState:UIControlStateNormal];
        [_sendGiftBtn setTitle:@"发 送" forState:UIControlStateNormal];
        [_sendGiftBtn setTitleColor:ColorPink forState:UIControlStateNormal];
        
        
        _sendGiftBtn.frame=CGRectMake(SCREEN_WIDTH - 80, 5, 80, 50);
        
        [_bottomView addSubview:_sendGiftBtn];
        
        [_sendGiftBtn addTarget:self
                         action:@selector(sendAction)
               forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *normalDodgerImg = [UIImage imageNamed:@"image/liveroom/btn_dt_l"];
        UIImage *focusDodgerImg = [UIImage imageNamed:@"image/liveroom/btn_dt_d"];
        
        _dodgersBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _dodgersBtn.frame = CGRectMake(SCREEN_WIDTH-normalDodgerImg.size.width-5, _DispalyArea.height-normalDodgerImg.size.height-5, normalDodgerImg.size.width, normalDodgerImg.size.height);
        [_dodgersBtn setBackgroundImage:normalDodgerImg forState:UIControlStateNormal];
        [_dodgersBtn setBackgroundImage:focusDodgerImg forState:UIControlStateSelected];
        [_dodgersBtn setBackgroundImage:focusDodgerImg forState:UIControlStateHighlighted];
        
    
//        _dodgersBtn.adjustsImageWhenHighlighted = YES;
        _dodgersBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _dodgersBtn.titleLabel.textColor = [UIColor whiteColor];
        _dodgersBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_DispalyArea addSubview:_dodgersBtn];
        _dodgersBtn.hidden = YES;
        [_dodgersBtn addTarget:self
                         action:@selector(dodgersAction)
              forControlEvents:UIControlEventTouchUpInside];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        [_dodgersBtn addGestureRecognizer:longPress];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMyDiamond:) name:LCUserLiveDiamondDidChangeNotification object:nil];
        
        _giftScrollView=[[LiveGiftScrollView alloc] initWithFrame:CGRectZero isFromChat:NO];
        ESWeakSelf;
        _giftScrollView.selectGiftBlock = ^(int selectGiftId){
            ESStrongSelf;
            NSDictionary *giftDic=_self.giftScrollView.giftsDic[@"gifts"][[NSString stringWithFormat:@"%d",selectGiftId]];
            if ([giftDic[@"type"] intValue] != 1) {
                [_self stopRefreshTimer];
            }
        };
        [_DispalyArea addSubview:_giftScrollView];
        
        _rechargeView.userInteractionEnabled = YES;
        UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(rechargeAction)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [_rechargeView addGestureRecognizer:singleRecognizer];
        
        __gSendingMessagesQueue = dispatch_queue_create("com.qianchuo.ShowMessagesQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

#pragma mark - 充值
- (void) rechargeAction
{
    NSLog(@"rechargeAction ");
    if (_showRechargeBlock) {
        _showRechargeBlock();
    }
}


- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (self.superview && !newSuperview) {
        [self stopRefreshTimer];
    }
}

-(void)recharge
{
    //    [KFPurchaseView showPurchaseViewWithRoomId:[self.rootViewController.roomInfo ID]];
}

-(void)showShapeSelectView
{
    //    [[KFGiftShapeMenu sharedShapeMenu] showShapeMenuWithSelectGiftShapeBlock:^(NSDictionary *selectShape)
    //     {
    //         NSLog(@"selectShape=%@",selectShape);
    //
    //         self.shapeDic=selectShape;
    //         self.giftNum.text=[NSString stringWithFormat:@"%@",selectShape[@"num"]];
    //     }];
    //
    //    NSLog(@"");
    //
    //    NSStringFromCGRect(CGRectMake(_selectUserBtn.left,_DispalyArea.top+_bottomView.top+_selectUserBtn.top,106,0));
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if (object == [LCMyUser mine]) {
//        if ([keyPath isEqualToString:@"diamond"]) {
//            unsigned long long money = [change[NSKeyValueChangeNewKey] unsignedLongLongValue];
//            [self setCurrentBalance:money];
//        }
//    }
//}

- (void)updateMyDiamond:(NSNotification *)notification
{
    if (notification.object != [LCMyUser mine]) {
        return;
    }
    
    [self setCurrentBalance];
}

-(void)upDateGiftList
{
    if (_isUpdateGiftView) {
        _isUpdateGiftView = NO;
        [_giftScrollView groupGifts:YES];
    } else {
        [_giftScrollView groupGifts:NO];
    }
}

-(void)setSelectUserId:(NSString *)selectId
{
    _selectUserId=selectId;
}

#pragma mark - 主播发红包
- (void)sendRedPacketAction
{
  [self sengGift:8];
}

#pragma mark - 连发礼物
- (void) dodgersAction
{
    [self startCountDownTimer];
    [self sendAction];
}


- (void)longPressAction:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        bLongPress = YES;
        [self sendAction];
        _dodgersBtn.selected = YES;
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        bLongPress = NO;
        _dodgersBtn.selected = NO;
    }
}

// 单发礼物
-(void)sendAction
{
    int selectGiftId=[LiveGiftItemView getSelectKey];
    [self sengGift:selectGiftId];
}

- (void) sengGift:(int)selectGiftId
{
    //是否选择有礼物
    if(selectGiftId<=0)
    {
        NSString *msg=@"请选择礼物！";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒"
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        alert.delegate=self;
        alert.tag=3;
        [alert show];
        
        return;
    }
    
    NSDictionary *giftDic=_giftScrollView.giftsDic[@"gifts"][[NSString stringWithFormat:@"%d",selectGiftId]];
    if (!giftDic) {
        [_giftScrollView groupGifts:NO];
        return;
    }
    
    if(_giftScrollView.currentTag!=6)
    {
        NSLog(@"giftsDic%@",_giftScrollView.giftsDic);
        
        float giftValue= [giftDic[@"price"] floatValue];
        if(giftValue>[LCMyUser mine].diamond)
        {
            ESWeakSelf;
            UIAlertView *alertView = [UIAlertView alertViewWithTitle:@"提示" message:@"余额不足，请充值！" cancelButtonTitle:@"确认" didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                ESStrongSelf;
                if (_self.showRechargeBlock) {
                    _self.showRechargeBlock();
                }
            } otherButtonTitles:nil, nil];
            [alertView show];
            return ;
        }
    }
    
    if ([giftDic[@"type"]intValue] != 1) {// 连续礼物
        [self stopRefreshTimer];
    }
    
    NSString *recUid;
    if ([LCMyUser mine].playBackUserId) {
        recUid = [LCMyUser mine].playBackUserId;
    } else if ([LCMyUser mine].liveUserId) {
        recUid = [LCMyUser mine].liveUserId;
    }
    
    if (!recUid) {
        return;
    }
    
    ESWeakSelf;
    NSDictionary *giftParamDic=@{@"giftid":@(selectGiftId),
                                 @"uid":[LCMyUser mine].userID,
                                 @"liveuid":recUid,
                                 @"vdoid":[LCMyUser mine].playVdoid?[LCMyUser mine].playVdoid:@""};
    NSLog(@"giftDic%@",giftParamDic);
    
    [SendGiftRequest sendGift:giftParamDic
                      succeed:^(NSDictionary *responseDic) {
                          ESStrongSelf;
                          
                          NSLog(@"responseDic==%@",responseDic);
                          
                          int stat=[responseDic[@"stat"] intValue];
                          
                          
                          if (stat != 520 && bLongPress && [giftDic[@"type"]intValue] == 1) {
                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                  [self sendAction];
                              });
                          }
                          
                          if(stat==200)
                          {
                              if ([giftDic[@"type"]intValue] == 1) {// 连续礼物
                                   [_self startCountDownTimer];
                              } else {
                                  [_self stopRefreshTimer];
                              }
                              
                              if ([recUid isEqualToString:[NSString stringWithFormat:@"%@",responseDic[@"recv_uid"]]]) {
                                  [_self dealSendGift:giftDic withSelectGiftId:selectGiftId withResponse:responseDic];
                              }
                          }
                          else if (520 == stat)
                          {
                              UIAlertView *alertView = [UIAlertView alertViewWithTitle:@"提示" message:@"余额不足，请充值！" cancelButtonTitle:@"确认" didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                  ESStrongSelf;
                                  if (_self.showRechargeBlock) {
                                      _self.showRechargeBlock();
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

- (void) syncDealSendGift:(NSDictionary *)giftDic withSelectGiftId:(int)selectGiftId withResponse:(NSDictionary *)responseDic
{
    if (!__gSendingMessagesQueue) {
        return;
    }
   
    ESWeakSelf;
    if (__gSendingMessagesQueue) {
        dispatch_async(__gSendingMessagesQueue, ^{
            ESStrongSelf;
                [_self dealSendGift:giftDic withSelectGiftId:selectGiftId withResponse:responseDic];
        });
    }
}

#pragma mark - 处理送礼物
- (void) dealSendGift:(NSDictionary *)giftDic withSelectGiftId:(int)selectGiftId withResponse:(NSDictionary *)responseDic
{
    //标记
    [LCMyUser mine].diamond = [responseDic[@"diamond"] intValue];
    [LCMyUser mine].send_diamond = [responseDic[@"send_diamond"] intValue];
    int tempLiveRecDiamond = [responseDic[@"recv_diamond"] intValue];
    if (![LCMyUser mine].playBackUserId) {
        if (tempLiveRecDiamond > [LCMyUser mine].liveRecDiamond) {
            [LCMyUser mine].liveRecDiamond = tempLiveRecDiamond;
        }
    }
    
    if (!_userSendGiftDict) {
        _userSendGiftDict = [NSMutableDictionary dictionary];
    }
    
    NSMutableDictionary *sendGift = [NSMutableDictionary dictionary];
    
    if ([giftDic[@"type"] intValue] == GIFT_TYPE_CONTINUE) {// 连续礼物
        
        if (!_userSendGiftDict[[LCMyUser mine].userID])
        {
            NSMutableDictionary * sendGiftDict = [NSMutableDictionary dictionary];
            [sendGiftDict setObject:[NSNumber numberWithInt:1] forKey:[NSNumber numberWithInt:selectGiftId]];
            [_userSendGiftDict setObject:sendGiftDict forKey:[LCMyUser mine].userID];
        }
        else
        {
            NSMutableDictionary *sendGiftNumDict = _userSendGiftDict[[LCMyUser mine].userID];
            if (sendGiftNumDict[[NSNumber numberWithInt:selectGiftId]]) {
                int giftNum = [sendGiftNumDict[[NSNumber numberWithInt:selectGiftId]] intValue] + 1;
                [sendGiftNumDict setObject:[NSNumber numberWithInt:giftNum] forKey:[NSNumber numberWithInt:selectGiftId]];
            } else {
                [sendGiftNumDict setObject:[NSNumber numberWithInt:1] forKey:[NSNumber numberWithInt:selectGiftId]];
            }
        }
        
        int giftNum = [_userSendGiftDict[[LCMyUser mine].userID][[NSNumber numberWithInt:selectGiftId]] intValue];
        
        NSLog(@"send gift num:%d",giftNum);
        
        sendGift[@"gift_id"] = [NSNumber numberWithInt:selectGiftId];
        sendGift[@"gift_nums"] = [NSNumber numberWithInt:giftNum];
        
        
    } else if ([giftDic[@"type"] intValue] == GIFT_TYPE_REDPACKET) {// 红包类型
        int packetid = [responseDic[@"packetid"] intValue];
        NSLog(@"red packetid:%d",packetid);
        sendGift[@"gift_id"] = [NSNumber numberWithInt:packetid];
        sendGift[@"gift_nums"] = @"1";
    } else if ([giftDic[@"type"] intValue] == GIFT_TYPE_LUXURY) {// 豪华礼物
        sendGift[@"gift_id"] = [NSNumber numberWithInt:selectGiftId];
        sendGift[@"gift_nums"] = @"1";
    }
    
    sendGift[@"gift_type"] = giftDic[@"type"];
    sendGift[@"gift_name"] = giftDic[@"name"];
    sendGift[@"price"] = giftDic[@"price"];
    sendGift[@"recv_diamond"] = responseDic[@"recv_diamond"];
    sendGift[@"type"] = LIVE_GROUP_GIFT;              // 消息类型
    sendGift[@"uid"] = [LCMyUser mine].userID;        // 用户id
    sendGift[@"nickname"] = [LCMyUser mine].nickname; // 用户昵称
    if ([responseDic[@"grade"] intValue] > 0) {
        sendGift[@"grade"] = responseDic[@"grade"];  // 用户级别 (用户升级后会返回)
    } else {
        sendGift[@"grade"] = @([LCMyUser mine].userLevel);  // 用户级别
    }
    sendGift[@"face"] = [LCMyUser mine].faceURL;      // 用户头像
    sendGift[@"offical"] = @([LCMyUser mine].showManager?1:0);
    
    ESWeakSelf;
    ESDispatchOnMainThreadAsynchrony(^{
        ESStrongSelf;
        if (_self.sendGiftBlock) {
            _self.sendGiftBlock(sendGift);
        }
    });
    
    [LiveMsgManager sendGiftMsg:sendGift andSucc:^(NSString *msg) {
    } andFail:^(NSString *error) {
    }];
}


-(void)setCurrentBalance
{
    //    NSString *balanceString=[NSString stringWithFormat:@"<font size=10 color='#000000'>当前余额:</font><font size=10 color='#ead381'>%llu</font>",balance];
    //    [_balanceLabel setText:balanceString];
    UIImage *rightImage=[UIImage imageNamed:@"icon_detail"];
    
    NSString *priceText = [NSString stringWithFormat:@"%d d d",[LCMyUser mine].diamond];
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:priceText];
    
    NSTextAttachment *iconAttachment = [[NSTextAttachment alloc] init];
    UIImage *image = [UIImage imageNamed:@"image/liveroom/me_myaccount_reddiamond"];
    iconAttachment.image = image;
//    iconAttachment.image = [UIImage imageWithImage:image scaleToSize:CGSizeMake(image.size.width, image.size.height)];
    NSAttributedString *iconAttributedString = [NSAttributedString attributedStringWithAttachment:iconAttachment];
    
    iconAttachment = [[NSTextAttachment alloc] init];
    iconAttachment.image = rightImage;
//    iconAttachment.image = [UIImage imageWithImage:rightImage scaleToSize:rightImage.size];
    NSAttributedString *rightAttributedString = [NSAttributedString attributedStringWithAttachment:iconAttachment];
    
    
    [mutableAttributedString replaceCharactersInRange:NSMakeRange(priceText.length-1, 1) withAttributedString:rightAttributedString];
    [mutableAttributedString replaceCharactersInRange:NSMakeRange(priceText.length-3, 1) withAttributedString:iconAttributedString];
    
    _diamondLabel.attributedText = mutableAttributedString;
}

// 送礼物前判断状态
-(BOOL)sendGiftAuthority
{
    return YES;
}

// 开启定时器
- (void)startCountDownTimer
{
    if (countTime < START_TIME/2) {
        countTime = START_TIME;
//        NSLog(@"startCountDownTimer %d",countTime);
    }
    
    [_dodgersBtn setTitle:[NSString stringWithFormat:@"%d",countTime] forState:UIControlStateNormal];
    
    if (!_refreshTimer) {
        _refreshTimer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
    
    _sendGiftBtn.hidden = YES;
    _dodgersBtn.hidden = NO;
}

// 关闭定时器
- (void)stopRefreshTimer
{
    _dodgersBtn.hidden = YES;
    _sendGiftBtn.hidden = NO;
    
    countTime = START_TIME;
    [_dodgersBtn setTitle:[NSString stringWithFormat:@"%d",countTime] forState:UIControlStateNormal];
    
    if (_refreshTimer) {
        [_refreshTimer invalidate];
        _refreshTimer = nil;
    }
}

// 倒计时
- (void) countDown
{
   countTime--;
    
    if (countTime > 0) {
        _dodgersBtn.hidden = NO;
        _sendGiftBtn.hidden = YES;
//        NSLog(@"countDown %d",countTime);
       [_dodgersBtn setTitle:[NSString stringWithFormat:@"%d",countTime] forState:UIControlStateNormal];
    } else {
        [self stopRefreshTimer];
    }
    
}

@end
