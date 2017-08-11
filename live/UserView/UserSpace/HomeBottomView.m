//
//  HomeBottomView.m
//  qianchuo
//
//  Created by jacklong on 16/8/4.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "HomeBottomView.h"

@interface HomeBottomView()
{
    UIView   *lineView;
    UIButton *attentBtn;
    UIView   *oneLineView;
    UIView   *twoLineView; 
    
    UIView   *threeLineView;
    UIButton *_blackBtn;

    
    BOOL isAddAttentRequest;
    BOOL isBlackUser;
}

@end

@implementation HomeBottomView

- (id)initWithFrame:(CGRect)frame withUserId:(NSString *)userId
{
    self = [super initWithFrame:frame];
    if (self) {
        _userId = userId;
        
        self.backgroundColor = [UIColor whiteColor];
        lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, .5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineView];
        
        attentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        attentBtn.backgroundColor = [UIColor clearColor];
        attentBtn.frame =  CGRectMake(0, .5, SCREEN_WIDTH/3-.5, 39);
        attentBtn.titleLabel.textColor = ColorPink;
        [attentBtn setTitleColor:ColorPink forState:UIControlStateNormal];
        attentBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:attentBtn];
        [attentBtn addTarget:self action:@selector(attentAction) forControlEvents:UIControlEventTouchUpInside];
       
        if ([[LCMyUser mine] isAttentUser:userId]) {
            [attentBtn setTitle:ESLocalizedString(@"已关注") forState:UIControlStateNormal];
            attentBtn.titleLabel.text = ESLocalizedString(@"已关注");
            attentBtn.titleLabel.textColor = [UIColor grayColor];
            [attentBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        } else {
            attentBtn.titleLabel.textColor = ColorPink;
            [attentBtn setTitleColor:ColorPink forState:UIControlStateNormal];
            [attentBtn setTitle:ESLocalizedString(@"关注") forState:UIControlStateNormal];
            attentBtn.titleLabel.text = ESLocalizedString(@"关注");
        }
        
        oneLineView = [[UIView alloc] initWithFrame:CGRectMake(attentBtn.right, 10, .5, 20)];
        oneLineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:oneLineView];
        
        _privBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _privBtn.backgroundColor = [UIColor clearColor];
        _privBtn.frame =  CGRectMake(oneLineView.right, 1, SCREEN_WIDTH/3-.5, 39);
        [_privBtn setTitle:ESLocalizedString(@"私信") forState:UIControlStateNormal];
        [_privBtn setTitleColor:ColorPink forState:UIControlStateNormal];
        _privBtn.titleLabel.text = ESLocalizedString(@"私信");
        _privBtn.titleLabel.textColor = ColorPink;
        _privBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:_privBtn];
        
        twoLineView = [[UIView alloc] initWithFrame:CGRectMake(_privBtn.right, 10, .5, 20)];
        twoLineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:twoLineView];
        
//        _oneToOneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _oneToOneBtn.backgroundColor = [UIColor clearColor];
//        _oneToOneBtn.frame =  CGRectMake(twoLineView.right, 1, SCREEN_WIDTH/4-.5, 39);
//        [_oneToOneBtn setTitle:ESLocalizedString(@"1v1") forState:UIControlStateNormal];
//        [_oneToOneBtn setTitleColor:ColorPink forState:UIControlStateNormal];
//        _oneToOneBtn.titleLabel.text = ESLocalizedString(@"1v1");
//        _oneToOneBtn.titleLabel.textColor = ColorPink;
//        _oneToOneBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
//        [self addSubview:_oneToOneBtn];
//        
//        threeLineView = [[UIView alloc] initWithFrame:CGRectMake(_oneToOneBtn.right, 10, .5, 20)];
//        threeLineView.backgroundColor = [UIColor lightGrayColor];
//        [self addSubview:threeLineView];
        
        _blackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _blackBtn.backgroundColor = [UIColor clearColor];
        _blackBtn.frame =  CGRectMake(twoLineView.right, 1, SCREEN_WIDTH/3-.5, 39);
//        [blackBtn setTitle:ESLocalizedString(@"拉黑") forState:UIControlStateNormal];
//        blackBtn.titleLabel.text = ESLocalizedString(@"拉黑");
        [_blackBtn setTitleColor:ColorPink forState:UIControlStateNormal];
        _blackBtn.titleLabel.textColor = ColorPink;
        _blackBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:_blackBtn];
        [_blackBtn addTarget:self action:@selector(blackAction) forControlEvents:UIControlEventTouchUpInside];
        
        ESWeakSelf;
        [[RCIMClient sharedRCIMClient] getBlacklistStatus:[NSString stringWithFormat:@"%d",[userId intValue]] success:^(int bizStatus) {
            ESStrongSelf;
            ESDispatchOnMainThreadAsynchrony(^{
                ESStrongSelf;
                [_self updateBlackState:bizStatus];
            });
            
        } error:^(RCErrorCode status) {
            
        }];
    }
    
    
    return self;
}

- (void) attentAction
{
    if ([[LCMyUser mine] isAttentUser:_userId])
    {
        return;
    }
    
    // 添加关注
    if (isAddAttentRequest) {
        return;
    }
    
    isAddAttentRequest = YES;
    
    ESWeakSelf;
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic)
    {
        ESStrongSelf;
        _self->isAddAttentRequest = NO;
        NSInteger code = [[responseDic objectForKey:@"stat"] integerValue];
        if (URL_REQUEST_SUCCESS == code)
        {
            [[LCMyUser mine] addAttentUser:_userId];

            [_self->attentBtn setTitle:ESLocalizedString(@"已关注") forState:UIControlStateNormal];
            [_self->attentBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
        else
        {
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        [LCNoticeAlertView showMsg:@"Error！"];
        ESStrongSelf;
        _self->isAddAttentRequest = NO;
    };
    
    NSDictionary *paramter = @{@"u":_userId};
    //    NSLog(@"paramter %@",paramter);
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:paramter
                                                  withPath:URL_ADD_ATTENT_USER
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}

#pragma mark 加入黑名单
- (void) blackAction
{
    if (isBlackUser) {
        ESWeakSelf;
        [[RCIMClient sharedRCIMClient] removeFromBlacklist:[NSString stringWithFormat:@"%d",[_userId intValue]] success:^{
            ESStrongSelf;
            ESDispatchOnMainThreadAsynchrony(^{
                ESStrongSelf;
                [_self updateBlackState:1];
            });
        } error:^(RCErrorCode status) {
            //            NSLog(@"blcak code:%d",(int)status);
            //            [LCNoticeAlertView showMsg:@"解除拉黑失败！"];
        }];
    } else {
        ESWeakSelf;
        UIAlertView *alert =  [UIAlertView alertViewWithTitle:ESLocalizedString(@"提示") message:ESLocalizedString(@"拉黑后Ta不能再私信你") cancelButtonTitle:@"取消" didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                ESStrongSelf;
                [[RCIMClient sharedRCIMClient] addToBlacklist:[NSString stringWithFormat:@"%d",[_userId intValue]] success:^{
                    ESStrongSelf;
                    ESDispatchOnMainThreadAsynchrony(^{
                        ESStrongSelf;
                        [_self updateBlackState:0];
                    });
                } error:^(RCErrorCode status) {
                    //                    NSLog(@"blcak code:%d",(int)status);
                    //                    [LCNoticeAlertView showMsg:@"拉黑失败！"];
                }];
            }
        } otherButtonTitles:ESLocalizedString(@"拉黑"), nil];
        [alert show];
    }
}


#pragma mark - 更新1v1 状态
- (void)updateOneToOneState:(int)isOpenOneToOne
{
    if (isOpenOneToOne) {
        _oneToOneBtn.titleLabel.textColor = ColorPink;
    } else {
        _oneToOneBtn.titleLabel.textColor = [UIColor grayColor];
    }
}

#pragma mark - 更新黑名单状态
- (void) updateBlackState:(int)bizStatus
{
    if (bizStatus == 0) {
        isBlackUser = YES;
        [_blackBtn setTitle:ESLocalizedString(@"解除拉黑") forState:UIControlStateNormal];
        _blackBtn.titleLabel.text = ESLocalizedString(@"解除拉黑");
    } else {
        isBlackUser = NO;
        [_blackBtn setTitle:ESLocalizedString(@"拉黑") forState:UIControlStateNormal];
        _blackBtn.titleLabel.text = ESLocalizedString(@"拉黑");
    }
    
}


@end
