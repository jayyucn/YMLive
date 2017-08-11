//
//  AudienceUserCell.m
//  qianchuo
//
//  Created by jacklong on 16/3/4.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "AudienceUserCell.h"

@implementation AudienceUserCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth+ViewPadding*2, ViewWidth)];
        [self addSubview:view];
        _portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(ViewPadding, 0, ViewWidth, ViewWidth)];
        
        //圆形头像
        self.portraitView.layer.borderWidth = 1;
        self.portraitView.layer.borderColor = ColorPink.CGColor;
        self.portraitView.layer.cornerRadius = self.portraitView.frame.size.width/2;
        self.portraitView.clipsToBounds = YES;
        self.portraitView.image = [UIImage imageNamed:@"default_head"];
        self.portraitView.userInteractionEnabled = YES;
        [view addSubview:_portraitView];
        
        UIImage *flagImg = [UIImage imageNamed:@"image/yonghu/grade_flag/grade_flag_1"];
        self.gradeFlagImgView = [[UIImageView alloc] initWithFrame:CGRectMake(view.width-flagImg.size.width-ViewPadding, view.height-flagImg.size.height, flagImg.size.width, flagImg.size.height)];
        self.gradeFlagImgView.image = flagImg;
        [view addSubview:_gradeFlagImgView];
        view.transform = CGAffineTransformMakeRotation(M_PI/2);
    }
    return self;
}


//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//        
//        //self.frame=CGRectMake(0, 0, ViewScale, ViewScale);
//        
//        float memberViewScale=self.frame.size.width;
//        
//        _portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, memberViewScale, memberViewScale)];
//        
//        //圆形头像
//        self.portraitView.layer.borderWidth = 1;
//        self.portraitView.layer.borderColor = ColorPink.CGColor;
//        self.portraitView.layer.cornerRadius = self.portraitView.frame.size.width/2;
//        self.portraitView.clipsToBounds = YES;
//        self.portraitView.image = [UIImage imageNamed:@"default_head"];
//        self.portraitView.userInteractionEnabled = YES;
//
//       
//        [self addSubview:_portraitView];
//        
////        self.userInteractionEnabled=YES;
////        
////        UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
////                                                                                           action:@selector(singleTap)];
////        
////        singleRecognizer.numberOfTapsRequired = 1; // 单击
////        
////        
////        [self addGestureRecognizer:singleRecognizer];
//    }
//    return self;
//}


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
    
    if (_showUserDetail && _liveUser) {
        _showUserDetail(_liveUser);
    }
    
}

- (void)setLiveUser:(LiveUser *)liveUser
{
    _liveUser = liveUser;
    NSString *faceString=[NSString faceURLString:liveUser.userLogo];
    [_portraitView sd_setImageWithURL:[NSURL URLWithString:faceString]
                     placeholderImage:[UIImage imageNamed:@"default_head"]];
    
    if (liveUser.userGrade > 0) {
        _gradeFlagImgView.image = [UIImage createUserGradeFlagImage:liveUser.userGrade withIsManager:liveUser.userOffical];
        _gradeFlagImgView.hidden = NO;
    } else {
        _gradeFlagImgView.hidden = YES;
    }
    
}

@end
