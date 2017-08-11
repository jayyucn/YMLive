//
//  LiveGiftView.h
//  qianchuo 礼物界面
//
//  Created by jacklong on 16/3/5.
//  Copyright © 2016年 kenneth. All rights reserved.
//
#import "LiveGiftScrollView.h"
#import "RTLabel.h"

typedef void(^SendGiftBlock)(NSDictionary *giftDic);

typedef void(^ShowRechargeBlock)();

@interface LiveGiftView : UIView<UITextFieldDelegate>

@property (nonatomic,strong)UIView *DispalyArea;

@property (nonatomic,strong)UIImageView * selectImg;

@property (nonatomic,strong)LiveGiftScrollView *giftScrollView;

@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)UIView     *rechargeView;
@property (nonatomic,strong)UILabel    *rechargeLabel;
@property (nonatomic,strong)UILabel    *diamondLabel;
@property (nonatomic,strong)UIImageView*iconImg;
@property (nonatomic,strong)UIButton   *sendGiftBtn;
@property (nonatomic,strong)UIButton   *dodgersBtn;// 连发按钮

@property (nonatomic,copy)SendGiftBlock sendGiftBlock;
@property (nonatomic,copy)ShowRechargeBlock  showRechargeBlock;


@property (nonatomic,strong)NSString *selectUserId;
@property (nonatomic,strong)NSDictionary *shapeDic;

@property (nonatomic,assign)BOOL isUpdateGiftView;// 跳转到聊天页面后需要更新礼物列表 

@property (nonatomic,strong)NSMutableDictionary *userSendGiftDict; 

-(BOOL)sendGiftAuthority;
-(void)setCurrentBalance;

-(void)upDateGiftList;

- (void)stopRefreshTimer;

- (void)sendRedPacketAction;
@end
