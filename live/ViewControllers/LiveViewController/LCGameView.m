//
//  LCGameView.m
//  TaoHuaLive
//
//  Created by Jay on 2017/7/25.
//  Copyright © 2017年 上海七夕. All rights reserved.
//

#import "LCGameView.h"
#import "LCGameNiuniu.h"
#import "LEEAlert.h"

NSNotificationName const  kGameResultDidShowNotification = @"kGameResultDidShowNotification";

@interface LCGameView ()

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UIButton *diamondBtn;
@property (nonatomic, strong) UIButton *historyBtn;
@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, assign) NSInteger stake;

@property (nonatomic, strong) LCGameNiuniu *niuniu;

@end

@implementation LCGameView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#pragma mark- initial stuffs

- (void)showWithGameType:(CurrentGameType)type isHost:(BOOL)isHost
{
    _type = type;
    _isHost = isHost;
    [self removeAllSubviews];
    switch (type) {
        case CurrentGameTypeNiuniu:
        {
            [self initialization];
            self.niuniu = [[LCGameNiuniu alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.height-44) isHost:isHost];
            [self addSubview:self.niuniu];
            
            
        }
            break;
            
        default:
            break;
    }
}

- (void)initialization {
    UIImage *diamondImage = [UIImage imageNamed:@"diamond"];
    self.diamondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.diamondBtn.frame = CGRectMake(16, self.height-37, 30, 30);
    [self.diamondBtn setImage:diamondImage forState:UIControlStateNormal];
    [self.diamondBtn addTarget:self action:@selector(diamondRecharge) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.diamondBtn];
    
    UILabel *diamondLb = [[UILabel alloc] initWithFrame:CGRectMake(self.diamondBtn.right+8, self.height-37, 60, 30)];
    diamondLb.text = [NSString stringWithFormat:@"%d",[LCMyUser mine].diamond];
    [self addSubview:diamondLb];
    
    if (_isHost) {
        UIImage *closeImg = [UIImage imageNamed:@"image/games/ic_bottom_close"];
        CGFloat closeWidth = closeImg.size.width/2;
        CGFloat closeHeight = closeImg.size.height/2;
        self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closeBtn.frame = CGRectMake(ScreenWidth-8-closeWidth, self.height-3-closeHeight, closeWidth, closeHeight);
        [self.closeBtn setImage:closeImg forState:UIControlStateNormal];
        [self.closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.closeBtn];
    }else {
        
        UIImage *historyImg = [UIImage imageNamed:@"image/games/lsjl"];
        _historyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_historyBtn setImage:historyImg forState:UIControlStateNormal];
        _historyBtn.frame = CGRectMake(ScreenWidth-38, self.height-37, 30, 30);
        [_historyBtn addTarget:self action:@selector(betHistory) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_historyBtn];
        
        self.segment = [[UISegmentedControl alloc] initWithItems:@[@"50", @"100", @"500"]];
        self.segment.frame = CGRectMake(_historyBtn.left-128, self.height-37, 120, 30);
        self.segment.backgroundColor = [UIColor clearColor];
        self.segment.tintColor = ColorPink;
        [self.segment setSelectedSegmentIndex:0];
        [self.segment addTarget:self action:@selector(chooseBetAmount:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.segment];
        
    }
}
- (void)chooseBetAmount:(UISegmentedControl *)segment
{
    self.niuniu.selectedSegmentIndex = segment.selectedSegmentIndex;
}
//下注
- (void)betActionWithCompletionHander:(void (^)(NSInteger, NSInteger))completionHandler
{
    [self.niuniu betActionWithCompletionHandler:completionHandler];
}
- (void)showBetActionWithArray:(NSArray *)array
{
    [self.niuniu showBetActionWithArray:array];
}
- (void)showMyBetActionWithArray:(NSArray *)array
{
    [self.niuniu showMyBetActionWithArray:array];
}
//充值
- (void)diamondRecharge
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gameShouldRechargeDiamond)]) {
        [self.delegate performSelector:@selector(gameShouldRechargeDiamond)];
    }
}
//历史记录
- (void)betHistory
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showHistory)]) {
        [self.delegate performSelector:@selector(showHistory)];
    } 
}

/**
 结束游戏

 @param sender a
 */
- (void)closeAction:(UIButton *)sender
{
    __weak typeof(self)weakself = self;
    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {
        label.text = ESLocalizedString(@"关闭游戏？");
        label.textColor = [UIColor darkGrayColor];
    })
    .LeeAddContent(^(UILabel *label) {
        label.text = ESLocalizedString(@"关闭后，本轮游戏无效！");
        label.textColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.75];
    })
    .LeeAddAction(^(LEEAction *action) {
        action.type = LEEActionTypeCancel;
        action.title = ESLocalizedString(@"取消");
        action.titleColor = [UIColor lightGrayColor];
        action.backgroundColor = [UIColor whiteColor];
        action.clickBlock = ^{
            //cancel actions
        };
    })
    .LeeAddAction(^(LEEAction *action) {
        action.type = LEEActionTypeDefault;
        action.title = ESLocalizedString(@"确定");
        action.titleColor = ColorPink;
        action.backgroundColor = [UIColor whiteColor];
        action.clickBlock = ^{
            //comfirm actions
            [weakself closeTheGame];
        };
    })
    .LeeHeaderColor(ColorPink)
    .LeeShow();
//    UIAlertView *alertView = [UIAlertView alertViewWithTitle:ESLocalizedString(@"温馨提示") message:ESLocalizedString(@"是否确定结束游戏？") cancelButtonTitle:ESLocalizedString(@"取消") didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
//        if (buttonIndex == 0) {
//            [self closeTheGame];
//        }
//    } otherButtonTitles:@"确定", nil];
//    [alertView show];
}
- (void)closeTheGame
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gameShouldClose)]) {
        [self.delegate performSelector:@selector(gameShouldClose)];
    }
}

- (void)startWithAnimation:(BOOL)animated
{
    switch (self.type) {
        case CurrentGameTypeNiuniu:
        {
            
            [self.niuniu startWithAnimation:animated];
        }
            break;
            
        default:
            break;
    }
}

- (void)timeoutCounting:(NSInteger)counting
{
    [self.niuniu timeoutCounting:counting];
}

- (void)showResultWithDict:(NSDictionary *)dict
{
    [self.niuniu showResultWithDict:dict];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
