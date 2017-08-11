//
//  FinishLiveView.m
//  qianchuo
//
//  Created by jacklong on 16/4/25.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "FinishLiveView.h"
#import "WXPayManager.h"
#import "QCShareResource.h"
//#import "QCSinaManager.h"
#import "QCTencentManager.h"

#import "UserCellView.h"
#import "WatchCutLiveViewController.h"


@interface FinishLiveView() {
    BOOL          isLoading;
    UILabel       *endPromptLabel;
    UILabel       *audiencePromtLabel;
    UILabel       *recvMoneyPromptLabel;
    
    UILabel       *suggestionLabel;
    
    UILabel       *sharePromptLabel;

    UIButton      *sinaShareBtn;
    UIButton      *wxShareBtn;
    UIButton      *wxCircleShareBtn;
    UIButton      *qqShareBtn;
    UIButton      *qqZoneShareBtn;
    
    UIButton      *addAttentBtn;
    UIButton      *continueLiveBtn;// 继续直播
    UIButton      *finishBtn;
    
    NSMutableArray *usersArray;
    
}


@end

@implementation FinishLiveView

 

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.backgroundColor = RGBA16(0xcf000000);
        UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        bgImgView.image = [UIImage imageNamed:@"image/liveroom/room_start_live_bg"];
        [self addSubview:bgImgView];
//        endPromptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/6, SCREEN_WIDTH, 40)];
        endPromptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64+10, SCREEN_WIDTH, 40)];
        endPromptLabel.text = ESLocalizedString(@"直播结束");
        endPromptLabel.font = [UIFont boldSystemFontOfSize:40];
        endPromptLabel.textColor = ColorPink;
        endPromptLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:endPromptLabel];
        
        audiencePromtLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, endPromptLabel.bottom+10, SCREEN_WIDTH, 20)];
        audiencePromtLabel.textColor = [UIColor whiteColor];
        audiencePromtLabel.text = ESLocalizedString(@"看过");
        audiencePromtLabel.font = [UIFont systemFontOfSize:20];
        audiencePromtLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:audiencePromtLabel];
        
        recvMoneyPromptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, audiencePromtLabel.bottom+10, SCREEN_WIDTH, 20)];
        recvMoneyPromptLabel.textColor = [UIColor whiteColor];
        recvMoneyPromptLabel.text =  ESLocalizedString(@"看过");
        recvMoneyPromptLabel.font = [UIFont systemFontOfSize:20];
        recvMoneyPromptLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:recvMoneyPromptLabel];
        recvMoneyPromptLabel.hidden = YES;
//精彩推荐
        suggestionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, recvMoneyPromptLabel.bottom+10, ScreenWidth, 20)];
        suggestionLabel.textColor = [UIColor whiteColor];
        suggestionLabel.text = ESLocalizedString(@"精彩推荐");
        suggestionLabel.font = [UIFont systemFontOfSize:22];
        suggestionLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:suggestionLabel];
        suggestionLabel.hidden = YES;
        CGFloat padding = 100;
        CGFloat width = (ScreenWidth - padding * 2 - 12) / 2;
        CGFloat height = width + 20;
        usersArray = [NSMutableArray arrayWithCapacity:4];
        for (int i = 1; i <= 4; i++) {
            UserCellView *cellView = nil;
            if (i < 3) {
                cellView = [[UserCellView alloc] initWithFrame:CGRectMake(padding + (i+1)%2*(width + 12), suggestionLabel.bottom+10, width, height)];
            }else {
                
                cellView = [[UserCellView alloc] initWithFrame:CGRectMake(padding + (i+1)%2*(width + 12), suggestionLabel.bottom+10 + height+12, width, height)];
            }
            
            [usersArray addObject:cellView];
        }
        
        
        UIImage *finishNormalImg = [UIImage imageNamed:@"image/liveroom/room_button"];
        UIImage *finishFocusImg = [UIImage imageNamed:@"image/liveroom/room_button_p"];
        
        
        CGFloat left = 30; // 左端盖宽度
        CGFloat right = 30; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(0, left, 0, right);
        // 伸缩后重新赋值
        finishNormalImg = [finishNormalImg resizableImageWithCapInsets:insets];
        // 伸缩后重新赋值
        finishFocusImg = [finishFocusImg resizableImageWithCapInsets:insets];
        
        finishBtn = [[UIButton alloc] initWithFrame:CGRectMake(30,SCREEN_HEIGHT - finishNormalImg.size.height - 50, SCREEN_WIDTH - 60, finishNormalImg.size.height)];
        [finishBtn setBackgroundImage:finishNormalImg forState:UIControlStateNormal];
        [finishBtn setBackgroundImage:finishFocusImg forState:UIControlStateHighlighted];
        [finishBtn setTitle:ESLocalizedString(@"返回首页") forState:UIControlStateNormal];
        finishBtn.titleLabel.textColor = [UIColor whiteColor];
        [finishBtn addTarget:self action:@selector(finishLiveAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:finishBtn];


        addAttentBtn = [[UIButton alloc] initWithFrame:CGRectMake(30,finishBtn.top - finishNormalImg.size.height - 10, SCREEN_WIDTH - 60, finishNormalImg.size.height)];
        addAttentBtn.titleLabel.textColor = [UIColor whiteColor];
        [addAttentBtn addTarget:self action:@selector(addAttentAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addAttentBtn];
        [self changeAttentState];
        
        continueLiveBtn = [[UIButton alloc] initWithFrame:CGRectMake(30,finishBtn.top - finishNormalImg.size.height - 10, SCREEN_WIDTH - 60, finishNormalImg.size.height)];
        continueLiveBtn.titleLabel.textColor = [UIColor whiteColor];
        [continueLiveBtn addTarget:self action:@selector(continueLiveAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:continueLiveBtn];
        continueLiveBtn.hidden = YES;
        
        
//        UIImage *sinaNormalImg = [UIImage imageNamed:@"image/liveroom/over_weibo"];
//        sinaShareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, sinaNormalImg.size.width, sinaNormalImg.size.height)];
//        sinaShareBtn.center = CGPointMake(20+(SCREEN_WIDTH-40)/10, addAttentBtn.top - sinaShareBtn.height - 40);
//        [sinaShareBtn setImage:sinaNormalImg forState:UIControlStateNormal];
//        [self addSubview:sinaShareBtn];
//        [sinaShareBtn addTarget:self action:@selector(sinaShareAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIImage *wxNormalImg = [UIImage imageNamed:@"image/liveroom/over_weixin"];
        wxShareBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, wxNormalImg.size.width, wxNormalImg.size.height)];
        wxShareBtn.center = CGPointMake(20+(SCREEN_WIDTH-30)/8, addAttentBtn.top - wxShareBtn.height -40);
        [wxShareBtn setImage:wxNormalImg forState:UIControlStateNormal];
        [self addSubview:wxShareBtn];
        [wxShareBtn addTarget:self action:@selector(wxShareAction) forControlEvents:UIControlEventTouchUpInside];
        wxShareBtn.userInteractionEnabled = YES;
        
        UIImage *wxCircleNormalImg = [UIImage imageNamed:@"image/liveroom/over_pengyouquan"];
        wxCircleShareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, wxNormalImg.size.width, wxNormalImg.size.height)];
        wxCircleShareBtn.center = CGPointMake(20+(SCREEN_WIDTH-30)/4 + (SCREEN_WIDTH-30)/8, wxShareBtn.centerY);
        [wxCircleShareBtn setImage:wxCircleNormalImg forState:UIControlStateNormal];
        [self addSubview:wxCircleShareBtn];
        [wxCircleShareBtn addTarget:self action:@selector(wxCircleShareAction) forControlEvents:UIControlEventTouchUpInside];
        wxCircleShareBtn.userInteractionEnabled = YES;
        
        UIImage *qqNormalImg = [UIImage imageNamed:@"image/liveroom/over_qq"];
        
        qqShareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, wxNormalImg.size.width, wxNormalImg.size.height)];
        qqShareBtn.center = CGPointMake(20+(SCREEN_WIDTH-30)*2/4 + (SCREEN_WIDTH-30)/8, wxShareBtn.centerY);
        [qqShareBtn setImage:qqNormalImg forState:UIControlStateNormal];
        [self addSubview:qqShareBtn];
        [qqShareBtn addTarget:self action:@selector(qqShareAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *qqZoneNormalImg = [UIImage imageNamed:@"image/liveroom/over_kongjian"];
        
        qqZoneShareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, wxNormalImg.size.width, wxNormalImg.size.height)];
        qqZoneShareBtn.center = CGPointMake(20+(SCREEN_WIDTH-30)*3/4 + (SCREEN_WIDTH-30)/8, wxShareBtn.centerY);
        [qqZoneShareBtn setImage:qqZoneNormalImg forState:UIControlStateNormal];
        [self addSubview:qqZoneShareBtn];
        [qqZoneShareBtn addTarget:self action:@selector(qqZoneShareAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        sharePromptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, wxShareBtn.top - 30, SCREEN_WIDTH, 14)];
        sharePromptLabel.textAlignment = NSTextAlignmentCenter;
        sharePromptLabel.textColor = [UIColor grayColor];
        sharePromptLabel.font = [UIFont systemFontOfSize:14];
        sharePromptLabel.text = ESLocalizedString(@"分享到");
        [self addSubview:sharePromptLabel];
        
        // 屏蔽微博分享
//        sinaShareBtn.hidden = YES;
    }
    return self;
}

- (void)showView:(UIView*)superView audience:(int)audience revMoney:(int )money praise:(int)praise hotData:(NSMutableArray *)hotArray
{
    if ([LCMyUser mine].liveType == LIVE_WATCH) {
        NSString *audienceStr = [NSString stringWithFormat:@"<html><body><font size=\"5\" color=\"#fc3a9a\">%d <font size=\"5\" color=\"#ffffff\">%@</body></html>", audience, ESLocalizedString(@"人看过")];
        NSAttributedString *audienceAtr = [[NSAttributedString alloc] initWithData:[audienceStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        audiencePromtLabel.attributedText = audienceAtr;
        audiencePromtLabel.textAlignment =  NSTextAlignmentCenter;
        audiencePromtLabel.hidden = NO;

        
//        NSString *praiseStr = [NSString stringWithFormat:@"<html><body><font size=\"5\" color=\"#fc3a9a\">%d <font size=\"5\" color=\"#ffffff\"> %@</body></html>",praise, ESLocalizedString(@"点亮")];
//        NSAttributedString *praiseAtr = [[NSAttributedString alloc] initWithData:[praiseStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
//        recvMoneyPromptLabel.frame = CGRectMake(0, audiencePromtLabel.bottom+10, SCREEN_WIDTH, 20);
//        recvMoneyPromptLabel.attributedText = praiseAtr;
//        recvMoneyPromptLabel.textAlignment =  NSTextAlignmentCenter;
        
    } else {
        NSString *audienceStr = [NSString stringWithFormat:@"<html><body><font size=\"5\" color=\"#fc3a9a\">%d <font size=\"5\" color=\"#ffffff\">%@</body></html>",audience, ESLocalizedString(@"人看过")];
        NSAttributedString *audienceAtr = [[NSAttributedString alloc] initWithData:[audienceStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        audiencePromtLabel.attributedText = audienceAtr;
        audiencePromtLabel.textAlignment =  NSTextAlignmentCenter;
        audiencePromtLabel.hidden = NO;
        
        NSString *praiseStr = [NSString stringWithFormat:@"<html><body><font size=\"5\" color=\"#ffffff\">%@ <font color=\"#ff0000\">%d</font> <font color=\"#ffffff\"> %@</body></html>", ESLocalizedString(@"有"),praise, ESLocalizedString(@"人为你点亮")];
        NSAttributedString *praiseAtr = [[NSAttributedString alloc] initWithData:[praiseStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        recvMoneyPromptLabel.attributedText = praiseAtr;
        recvMoneyPromptLabel.textAlignment =  NSTextAlignmentCenter;
        recvMoneyPromptLabel.hidden = NO;
        
        suggestionLabel.hidden = NO;
        ESWeakSelf;
        int pageCount = 0;
        if (hotArray.count > 0) {
            if (hotArray.count >= 4) pageCount = 4;
            else pageCount = (int)hotArray.count;
            
            for (int i= 0; i < pageCount; i++)
            {
                UserCellView *cellView = (UserCellView *)usersArray[i];
                [cellView configViewWithDict:hotArray[i]];
                cellView.itemBlock = ^(NSDictionary *userInfoDict) {
                    ESStrongSelf;
                    [_self onItemClick:userInfoDict with:i];
                };
                [self addSubview:cellView];
            }
        }
        
//
        addAttentBtn.hidden = YES;
        
        if (self.connectTimeout) {
            
            [continueLiveBtn setTitle:ESLocalizedString(@"继续直播") forState:UIControlStateNormal];
            
            UIImage *continueNormalImg = [UIImage imageNamed:@"image/liveroom/room_button"];
            UIImage *continueFocusImg = [UIImage imageNamed:@"image/liveroom/room_button_p"];
            
            CGFloat left = 30; // 左端盖宽度
            CGFloat right = 30; // 右端盖宽度
            UIEdgeInsets insets = UIEdgeInsetsMake(0, left, 0, right);
            // 伸缩后重新赋值
            continueNormalImg = [continueNormalImg resizableImageWithCapInsets:insets];
            // 伸缩后重新赋值
            continueFocusImg = [continueFocusImg resizableImageWithCapInsets:insets];
      
            [continueLiveBtn setBackgroundImage:continueNormalImg forState:UIControlStateNormal];
            [continueLiveBtn setBackgroundImage:continueFocusImg forState:UIControlStateHighlighted];
            
            wxShareBtn.centerY = continueLiveBtn.top - wxShareBtn.height - 40;
//            wxShareBtn.centerY = sinaShareBtn.centerY;
            wxCircleShareBtn.centerY = wxShareBtn.centerY;
            qqShareBtn.centerY = wxShareBtn.centerY;
            qqZoneShareBtn.centerY = wxShareBtn.centerY;
            sharePromptLabel.top = wxShareBtn.top - 30;
            
            continueLiveBtn.hidden = NO;
        } else {
            wxShareBtn.centerY = finishBtn.top - wxShareBtn.height - 40;
            wxShareBtn.centerY = wxShareBtn.centerY;
            wxCircleShareBtn.centerY = wxShareBtn.centerY;
            qqShareBtn.centerY = wxShareBtn.centerY;
            qqZoneShareBtn.centerY = wxShareBtn.centerY;
            sharePromptLabel.top = wxShareBtn.top - 30;
            continueLiveBtn.hidden = YES;
        }
    }
    
    
    [superView addSubview:self];
    self.alpha=0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=1;
    } completion:^(BOOL finished) {
    }];
}

// item单击事件
- (void)onItemClick:(NSDictionary *)item with:(NSInteger)currPos
{
    [[HUDHelper sharedInstance] tipMessage:ESLocalizedString(@"主播离开了")];
    NSString *uidStr = [NSString stringWithFormat:@"%@",[item objectForKey:@"uid"]];
    if ([uidStr isEqualToString:[LCMyUser mine].userID] || [LCMyUser mine].liveUserId)
    {
        return;
    }
#pragma warming
//    UINavigationController *nav = (UINavigationController *)self.nextResponder.nextResponder;
//    if (self.watchViewController)
//    {
//        [WatchCutLiveViewController ShowWatchLiveViewController:nav withInfoDict:item withArray:usersArray withPos:(int)currPos];
//    }
}

#pragma mark - 返回首页
- (void) finishLiveAction
{
    if(self.delegate)
    {
        [self.delegate finishViewClose:self];
    }
}

#pragma mark - 继续直播
- (void) continueLiveAction
{
    if (self.delegate) {
        [self.delegate onContinueLive];
    }
}

#pragma mark - 关注
- (void) addAttentAction
{
    
    if (isLoading || ![LCMyUser mine].liveUserId) {
        return;
    }
    
    isLoading = YES;
    
    if ([[LCMyUser mine] isAttentUser:[LCMyUser mine].liveUserId]) {
        ESWeakSelf;
        LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
            
            isLoading = NO;
            
            ESStrongSelf;
            NSInteger code = [[responseDic objectForKey:@"stat"] integerValue];
            if (URL_REQUEST_SUCCESS == code)
            {
                [[LCMyUser mine] removeAttentUser:[LCMyUser mine].liveUserId];
                [_self changeAttentState];
            }
            else
            {
                [LCNoticeAlertView showMsg:responseDic[@"msg"]];
            }
        };
        
        LCRequestFailResponseBlock failBlock=^(NSError *error){
            [LCNoticeAlertView showMsg:@"Error！"];
            isLoading = NO;
        };
        
        NSDictionary *paramter = @{@"u":[LCMyUser mine].liveUserId};
        NSLog(@"paramter %@",paramter);
        
        [[LCHTTPClient sharedHTTPClient] requestWithParameters:paramter
                                                      withPath:URL_CANCEL_ATTENT
                                                   withRESTful:GET_REQUEST
                                              withSuccessBlock:successBlock
                                                 withFailBlock:failBlock];
    } else {
        ESWeakSelf;
        LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
            
            isLoading = NO;
            
            ESStrongSelf;
            NSInteger code = [[responseDic objectForKey:@"stat"] integerValue];
            if (URL_REQUEST_SUCCESS == code)
            {
                [[LCMyUser mine] addAttentUser:[LCMyUser mine].liveUserId];
                [_self changeAttentState];
            }
            else
            {
                [LCNoticeAlertView showMsg:responseDic[@"msg"]];
            }
        };
        
        LCRequestFailResponseBlock failBlock=^(NSError *error){
            [LCNoticeAlertView showMsg:@"Error！"];
            isLoading = NO;
        };
        
        NSDictionary *paramter = @{@"u":[LCMyUser mine].liveUserId};
        
        [[LCHTTPClient sharedHTTPClient] requestWithParameters:paramter
                                                      withPath:URL_ADD_ATTENT_USER
                                                   withRESTful:GET_REQUEST
                                              withSuccessBlock:successBlock
                                                 withFailBlock:failBlock];
}
}

- (void) changeAttentState
{
    if ([[LCMyUser mine] isAttentUser:[LCMyUser mine].liveUserId]) {
        [addAttentBtn setTitle:ESLocalizedString(@"已关注") forState:UIControlStateNormal];
        
        UIImage *finishNormalImg = [UIImage imageNamed:@"image/liveroom/room_button"];
        UIImage *finishFocusImg = [UIImage imageNamed:@"image/liveroom/room_button_p"];
        
        CGFloat left = 30; // 左端盖宽度
        CGFloat right = 30; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(0, left, 0, right);
        // 伸缩后重新赋值
        finishNormalImg = [finishNormalImg resizableImageWithCapInsets:insets];
        // 伸缩后重新赋值
        finishFocusImg = [finishFocusImg resizableImageWithCapInsets:insets];
        
        // 伸缩后重新赋值
        UIImage *attentFocusImg = finishFocusImg;
 
        [addAttentBtn setBackgroundImage:attentFocusImg forState:UIControlStateNormal];
    } else {
        [addAttentBtn setTitle:ESLocalizedString(@"添加关注") forState:UIControlStateNormal];
        
        UIImage *finishNormalImg = [UIImage imageNamed:@"image/liveroom/room_button"];
        UIImage *finishFocusImg = [UIImage imageNamed:@"image/liveroom/room_button_p"];
        
        CGFloat left = 30; // 左端盖宽度
        CGFloat right = 30; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(0, left, 0, right);
        // 伸缩后重新赋值
        finishNormalImg = [finishNormalImg resizableImageWithCapInsets:insets];
        // 伸缩后重新赋值
        finishFocusImg = [finishFocusImg resizableImageWithCapInsets:insets];
        
        // 伸缩后重新赋值
        UIImage *attentNormalImg =  finishNormalImg;
        [addAttentBtn setBackgroundImage:attentNormalImg forState:UIControlStateNormal];
    }
}

#pragma mark - 分享
- (void) sinaShareAction
{
//    [[QCSinaManager sinaManager] sinaDoShare];
}

- (void) wxShareAction
{
    [WXPayManager wxPayManager].shareType = SHARE_FINISH_LIVE;
    [WXPayManager wxPayManager].scene = WXSceneSession;
    [[WXPayManager wxPayManager] sendLinkContent];
}

- (void) wxCircleShareAction
{
    [WXPayManager wxPayManager].shareType = SHARE_FINISH_LIVE;
    [WXPayManager wxPayManager].scene = WXSceneTimeline;
    [[WXPayManager wxPayManager] sendLinkContent];
}

- (void) qqShareAction
{
   [QCTencentManager tencentManager].shareType = SHARE_FINISH_LIVE;
   [[QCTencentManager tencentManager] shareWithFriend];
}

- (void) qqZoneShareAction
{
    [QCTencentManager tencentManager].shareType = SHARE_FINISH_LIVE;
    [[QCTencentManager tencentManager] shareInQzone];
}


@end
