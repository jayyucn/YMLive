//
//  MyRankUserView.m
//  qianchuo 我的用户排行
//
//  Created by jacklong on 16/3/30.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "MyRankUserView.h"

@implementation MyRankUserView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //self.frame=CGRectMake(0, 0, ViewScale, ViewScale);
        
        float memberViewScale=self.frame.size.width;
        
        _portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, memberViewScale, memberViewScale)];
        //圆形头像
        self.portraitView.layer.cornerRadius = self.portraitView.frame.size.width/2;
        self.portraitView.clipsToBounds = YES;
        self.portraitView.image = [UIImage imageNamed:@"default_head"];
        self.portraitView.userInteractionEnabled = YES;
        [self addSubview:_portraitView];
        
        UIImage *gradeFlagImg = [UIImage imageNamed:@"image/yonghu/grade_flag/grade_flag_1"];
        _gradeFlagImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_portraitView.right - gradeFlagImg.size.width, _portraitView.bottom - gradeFlagImg.size.height, gradeFlagImg.size.width, gradeFlagImg.size.height)];
        _gradeFlagImgView.image = gradeFlagImg;
        [self addSubview:_gradeFlagImgView];
        _gradeFlagImgView.hidden = YES;
        
        self.userInteractionEnabled=YES;
        
        UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(singleTap)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [self addGestureRecognizer:singleRecognizer];
    }
    return self;
}


-(void)singleTap
{
    // NSLog(@"singleTap==%@",_amateurItemDic);
    
    //    NSMutableDictionary *notifiDic=[NSMutableDictionary dictionaryWithDictionary:_userDic];
    //
    //    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_TapAmateurMember
    //                                                        object:nil
    //                                                      userInfo:notifiDic];
    
    
    /*
     _tapBlock(_amateurDic);
     
     if([self authority])
     _tapBlock(_amateurDic);
     else
     [KFNoticeAlertView showMsg:@"您的级别不够不能查看用户资料"];
     
     */
    
    if (_showRankDetail) {
        _showRankDetail();
    }
    
}

- (void)setUserInfoDict:(NSDictionary *)userInfoDict
{
    _userInfoDict = userInfoDict;
    if ([_userInfoDict[@"face"] isEqualToString:@"image/liveroom/me_qiudiamond"]) {
        _portraitView.image = [UIImage createContentsOfFile:_userInfoDict[@"face"]];
        _gradeFlagImgView.hidden = YES;
    } else {
        self.portraitView.layer.borderWidth = 1;
        self.portraitView.layer.borderColor = [UIColor whiteColor].CGColor;
        NSString *faceString=[NSString faceURLString:_userInfoDict[@"face"]];
        [_portraitView sd_setImageWithURL:[NSURL URLWithString:faceString]
                         placeholderImage:[UIImage imageNamed:@"default_head"]];
        
        int grade = ESIntValue(userInfoDict[@"grade"]);
        if (grade > 0) {
            _gradeFlagImgView.image = [UIImage createUserGradeFlagImage:grade withIsManager:(userInfoDict[@"offical"] && [userInfoDict[@"offical"] intValue] ==1)?true:false];
            _gradeFlagImgView.hidden = NO;
        } else {
            _gradeFlagImgView.hidden = YES;
        }
    }
    
}

@end
