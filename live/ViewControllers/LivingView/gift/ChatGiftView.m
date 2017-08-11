//
//  ChatGiftView.m
//  qianchuo
//
//  Created by 林伟池 on 16/5/16.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ChatGiftView.h"
#import "SendGiftRequest.h"


#define GiftViewHeight 241
@interface ChatGiftView(){
   
}
@end

@implementation ChatGiftView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (id)initWithFrame:(CGRect)frame withIsOrign:(BOOL)isOVO
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame=CGRectMake(0,0, ScreenWidth, 240);
        if (isOVO)
        {
            self.backgroundColor=[UIColor clearColor];
        } else {
            self.backgroundColor=[UIColor whiteColor];
        }
        
        UIImage *backImage = [UIImage createImageWithColor:RGBA16(0x30000000)];
        
        UIImageView *backView=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,GiftViewHeight)];
        backView.image=backImage;
        [self addSubview:backView];
       
        
        _selectImg = [[UIImageView alloc] initWithImage:[UIImage createImageWithColor:RGBA16(0xff61b3)]];
        [self addSubview:_selectImg];
        
        _giftScrollView=[[LiveGiftScrollView alloc] initWithFrame:CGRectZero isFromChat:YES];
        ESWeakSelf;
        _giftScrollView.selectGiftBlock = ^(int selectGiftId){
            ESStrongSelf;
            
        };
        [self addSubview:_giftScrollView];
        
        _rechargeView = [[UIView alloc] initWithFrame:CGRectMake(isOVO?10:80, 200, ScreenWidth/2, 40)];
        _rechargeView.userInteractionEnabled=YES;
        [self addSubview:_rechargeView];
        
        _rechargeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 40, 40)];
        _rechargeLabel.textAlignment = NSTextAlignmentCenter;
        _rechargeLabel.textColor=[UIColor yellowColor];
        _rechargeLabel.font=[UIFont systemFontOfSize:13];
        _rechargeLabel.backgroundColor =[UIColor clearColor];
        _rechargeLabel.text = @"充值: ";
        [_rechargeView addSubview:_rechargeLabel];
        
        _diamondLabel = [[UILabel alloc] initWithFrame:CGRectMake(_rechargeLabel.right+2, 0, ScreenWidth/2 - 45, 40)];
        _diamondLabel.textAlignment = NSTextAlignmentLeft;
        _diamondLabel.textColor=[UIColor yellowColor];
        _diamondLabel.font=[UIFont systemFontOfSize:14];
        _diamondLabel.backgroundColor =[UIColor clearColor];
        [_rechargeView addSubview:_diamondLabel];
        
        [self setCurrentBalance];
        
        UIImage *sendImage = [UIImage createImageWithColor:ColorPink];
        _sendGiftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendGiftBtn setBackgroundImage:sendImage
                                forState:UIControlStateNormal];
        [_sendGiftBtn setTitle:@"发 送" forState:UIControlStateNormal];
        [_sendGiftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendGiftBtn.frame=CGRectMake(SCREEN_WIDTH - 80, 200, 80, 40);
        [self addSubview:_sendGiftBtn];
        [_sendGiftBtn addTarget:self
                         action:@selector(sendAction)
               forControlEvents:UIControlEventTouchUpInside];
        
        if (!isOVO) {
            _hideGiftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_hideGiftBtn setBackgroundImage:sendImage
                                    forState:UIControlStateNormal];
            [_hideGiftBtn setTitle:@"取 消" forState:UIControlStateNormal];
            [_hideGiftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _hideGiftBtn.frame=CGRectMake(0, 200, 80, 40);
            [self addSubview:_hideGiftBtn];
            [_hideGiftBtn addTarget:self
                             action:@selector(hideView)
                   forControlEvents:UIControlEventTouchUpInside];
        }
       
        
        
                
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMyDiamond:) name:LCUserLiveDiamondDidChangeNotification object:nil];
        
        _rechargeView.userInteractionEnabled = YES;
        UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(rechargeAction)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [_rechargeView addGestureRecognizer:singleRecognizer];
    }
    return self;
}

- (void)hideView {
    NSLog(@"hideView");
    if (self.hideGiftBlock) {
        self.hideGiftBlock();
    }
}


#pragma mark - 充值
- (void) rechargeAction
{
    NSLog(@"rechargeAction ");
    if (_showRechargeBlock) {
        _showRechargeBlock();
    }
}

- (void)updateMyDiamond:(NSNotification *)notification
{
    if (notification.object != [LCMyUser mine]) {
        return;
    }
    
    [self setCurrentBalance];
}

-(void)upDateGiftList
{
    [_giftScrollView groupGifts:NO];
}

-(void)setSelectUserId:(NSString *)selectId
{
    _selectUserId=selectId;
}

// 单发礼物
-(void)sendAction
{
    //是否选择有礼物
    int selectGiftId=[LiveGiftItemView getSelectKey];
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
    
    
    ESWeakSelf;
    NSDictionary *giftParamDic=@{@"giftid":[NSNumber numberWithInt:selectGiftId],
                                 @"uid":[LCMyUser mine].userID,
                                 @"liveuid":@(self.mGiftUserId)
                                 };
   
    [SendGiftRequest sendGift:giftParamDic
                      succeed:^(NSDictionary *responseDic) {
                          ESStrongSelf;
                          
                          NSLog(@"chatgiftview responseDic==%@",responseDic);
                          
                          int stat=[responseDic[@"stat"] intValue];
                          
                          if(stat==200)
                          {
                              [_self dealSendGift:giftDic withSelectGiftId:selectGiftId withResponse:responseDic];
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

#pragma mark - 处理送礼物
- (void) dealSendGift:(NSDictionary *)giftDic withSelectGiftId:(int)selectGiftId withResponse:(NSDictionary *)responseDic
{
        //标记
        [LCMyUser mine].diamond = [responseDic[@"diamond"] intValue];
        [LCMyUser mine].send_diamond = [responseDic[@"send_diamond"] intValue];
        int tempLiveRecDiamond = [responseDic[@"recv_diamond"] intValue];
//        if (tempLiveRecDiamond > [LCMyUser mine].liveRecDiamond) {
//            [LCMyUser mine].liveRecDiamond = tempLiveRecDiamond;
//        }
    
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
            
            sendGift[@"gift_id"] = [NSNumber numberWithInt:selectGiftId];
            sendGift[@"gift_nums"] = [NSNumber numberWithInt:giftNum];
            
        } else if ([giftDic[@"type"] intValue] == GIFT_TYPE_REDPACKET) {// 红包类型
            int packetid = [responseDic[@"packetid"] intValue];
            //                                  NSLog(@"red packetid:%d",packetid);
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
        
        
        if (_sendGiftBlock) {
            _sendGiftBlock(sendGift);
        }
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
    
//    iconAttachment.image = [UIImage imageWithImage:image scaleToSize:CGSizeMake(image.size.width, image.size.height)];
    iconAttachment.image = image;
    NSAttributedString *iconAttributedString = [NSAttributedString attributedStringWithAttachment:iconAttachment];
    
    iconAttachment = [[NSTextAttachment alloc] init];
//    iconAttachment.image = [UIImage imageWithImage:rightImage scaleToSize:rightImage.size];
    iconAttachment.image = rightImage;
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




@end
