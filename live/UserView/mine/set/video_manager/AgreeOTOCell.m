//
//  AgreeOTOCell.m
//  qianchuo
//
//  Created by jacklong on 16/10/25.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "AgreeOTOCell.h"
@interface AgreeOTOCell(){
    BOOL isRequest;
}
@end;

@implementation AgreeOTOCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,0,185,25)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor=[UIColor blackColor];
        _titleLabel.font=[UIFont systemFontOfSize:16];
        _titleLabel.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:_titleLabel];
        _titleLabel.centerY = 25;
        //_titleLabel.adjustsFontSizeToFitWidth=YES;
        
        UIImage *agreeImg = [UIImage imageNamed:@"image/setotomoney/check_focus"];
        UIImage *noAgreeImg = [UIImage imageNamed:@"image/setotomoney/check_normal"];
        _agreeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0,agreeImg.size.width,agreeImg.size.height)];
        bool isAgree = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserOnetoOneAgreeKey] boolValue];
        if (isAgree) {
           [_agreeBtn setImage:agreeImg forState:UIControlStateNormal];
        } else {
           [_agreeBtn setImage:noAgreeImg forState:UIControlStateNormal];
        }
        
        _agreeBtn.left = ScreenWidth - _agreeBtn.width-10;
        _agreeBtn.centerY=_titleLabel.centerY;
        [self.contentView addSubview:_agreeBtn];
        
        [_agreeBtn addTarget:self action:@selector(agreeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)agreeAction:(id)sender
{
    bool isAgree = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserOnetoOneAgreeKey] boolValue];
 
    [self startRequest:!isAgree];// 在原来的值取反
}



- (void) startRequest:(BOOL) isAgree
{
    if (isRequest) {
        return;
    }
    
    isRequest = YES;
    
    ESWeakSelf;
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"type":isAgree?@(1):@(0)}  withPath:URL_OVO_OPEN withRESTful:GET_REQUEST withSuccessBlock:^(NSDictionary *responseDic) {
        ESStrongSelf;
        _self->isRequest = NO;
        
        NSLog(@"URL_OVO_OPEN res %@", responseDic);
        
        if ([responseDic[@"stat"] intValue] == 200) {
            [[NSUserDefaults standardUserDefaults] setObject:@(isAgree) forKey:kUserOnetoOneAgreeKey];
            
            UIImage *agreeImg = [UIImage imageNamed:@"image/setotomoney/check_focus"];
            UIImage *noAgreeImg = [UIImage imageNamed:@"image/setotomoney/check_normal"];
            if (isAgree) {
                [_self.agreeBtn setImage:agreeImg forState:UIControlStateNormal];
            } else {
                [_self.agreeBtn setImage:noAgreeImg forState:UIControlStateNormal];
            }
            
            if(_self.agreeCellBlock)
                _self.agreeCellBlock(isAgree);
        } else {
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
        
    } withFailBlock:^(NSError *error) {
        ESStrongSelf;
        _self->isRequest = NO;
        [LCNoticeAlertView showMsg:@"设置失败"];
    }];
}
@end
