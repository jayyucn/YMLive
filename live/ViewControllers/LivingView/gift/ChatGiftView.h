//
//  ChatGiftView.h
//  qianchuo
//
//  Created by 林伟池 on 16/5/16.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveGiftScrollView.h"

typedef void(^ChatSendGiftBlock)(NSDictionary *giftDic);

typedef void(^ChatShowRechargeBlock)();
typedef void(^ChatHideGiftBlock)();

@interface ChatGiftView : UIView

@property (nonatomic,strong)UIImageView * selectImg;

@property (nonatomic,strong)LiveGiftScrollView *giftScrollView;

@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)UIView     *rechargeView;
@property (nonatomic,strong)UILabel    *rechargeLabel;
@property (nonatomic,strong)UILabel    *diamondLabel;
@property (nonatomic,strong)UIImageView*iconImg;
@property (nonatomic,strong)UIButton   *sendGiftBtn;
@property (nonatomic , strong) UIButton *hideGiftBtn;

@property (nonatomic,copy)ChatSendGiftBlock sendGiftBlock;
@property (nonatomic,copy)ChatShowRechargeBlock  showRechargeBlock;
@property (nonatomic , strong) ChatHideGiftBlock hideGiftBlock;

@property (nonatomic,strong)NSString *selectUserId;
@property (nonatomic,strong)NSDictionary *shapeDic;

@property (nonatomic,strong)NSMutableDictionary *userSendGiftDict;

@property (nonatomic , assign) long mGiftUserId;

- (id)initWithFrame:(CGRect)frame withIsOrign:(BOOL)isOVO;

-(BOOL)sendGiftAuthority;
-(void)setCurrentBalance;

-(void)upDateGiftList;

@end
