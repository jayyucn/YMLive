//
//  EarningsDetailView.h
//  XCLive
//
//  Created by jacklong on 16/1/20.
//  Copyright © 2016年 www.yuanphone.com. All rights reserved.
// 

@interface EarningsDetailView : UIView

@property (nonatomic,strong)UIView*         headView;
@property (nonatomic,strong)UIImageView*    iconImg;
@property (nonatomic,strong)UILabel*        promptLabel;

@property (nonatomic,strong)UILabel*        recvDiamondLabel;

@property (nonatomic,strong)UILabel*        incomePromptLabel;
@property (nonatomic,strong)UILabel*        incomeLabel;

@property (nonatomic,strong)UILabel*        incomeLimitPromptLabel;
@property (nonatomic,strong)UILabel*        incomeLimitLabel;

@property (nonatomic,strong)UIView*         lineView;

@property (nonatomic,strong)UIButton*       exchangeBtn;
@property (nonatomic,strong)UIButton*       withDrawalBtn;
@property (nonatomic,strong)UIButton*       problemBtn;

-(void)updateIncomeView;
@end
