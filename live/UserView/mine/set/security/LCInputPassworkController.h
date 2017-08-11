//
//  LCInputPassworkController.h
//  XCLive
//
//  Created by ztkztk on 14-4-28.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCInputTextViewController.h"



/**
 * 验证类型
 */

typedef NS_ENUM(NSInteger,LCAuthType){
    LCAuthPhone =0,
    LCAuthChangePhone =1,
    LCAuthEmail=2,
    LCAuthChangeEmail=3,
    
};

/**
 * 验证类型title
 */
static inline NSString *LCIThinkName(LCAuthType authType) {
    NSString *authTitle = @"";
    switch (authType) {
        case LCAuthPhone: authTitle = @"绑定手机号码"; break;
        case LCAuthChangePhone: authTitle = @"修改手机号码"; break;
        case LCAuthEmail : authTitle = @"绑定邮箱地址"; break;
        case LCAuthChangeEmail : authTitle = @"修改邮箱地址"; break;
        default: break;
    }
    return authTitle;
}

@interface LCInputPassworkController : LCInputTextViewController

@property (nonatomic) LCAuthType authType;

+(id)inputPasswordViewWithAuthType:(LCAuthType)authType;
-(void)pushNextViewController;
@end
