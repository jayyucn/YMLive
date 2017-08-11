////
////  LCMatchAlertView.m
////  XCLive
////
////  Created by ztkztk on 14-5-29.
////  Copyright (c) 2014年 ztkztk. All rights reserved.
////
//
//#import "LCMatchAlertView.h"
//
//@implementation LCMatchAlertView
//
//
//+(void)showMatchAlertView:(NSDictionary *)userDic withController:(id)controller
//{
//    LCMatchAlertView *alertView=[[LCMatchAlertView alloc] init];
//    alertView.matchView.matchUser=userDic;
//    alertView.matchView.viewController=controller;
//    [alertView showWithAnimated];
//    
//}
//
//
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//        
//        
//        self.shouldDismissWhenTouchsAnywhere=YES;
//        self.autoDismissTimeInterval=0;
//        
//        
//        
//        UILabel *_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,200,30)];
//        _titleLabel.textAlignment = NSTextAlignmentCenter;
//        _titleLabel.textColor=[UIColor blackColor];
//        _titleLabel.font=[UIFont boldSystemFontOfSize:20];
//        _titleLabel.backgroundColor =[UIColor clearColor];
//        [self.backgroundView addSubview:_titleLabel];
//        _titleLabel.centerX=LCAlertViewWidth/2;
//        _titleLabel.text=@"夫妻相匹配";
//
//     
//        _matchView=[MatchCoupleView matchCoupleView:CGRectMake(0,_titleLabel.bottom+8,LCAlertViewWidth,200*LCAlertViewWidth/320)];
//        
//        ESWeakSelf;
//        _matchView.hiddenMatchBlock=^(void){
//            ESStrongSelf;
//            [_self dismissWithAnimated];
//        };
//        _matchView.matchCoupleViewMatching=^(BOOL matching){
//        
//            ESStrongSelf;
//            if(matching)
//                _self.shouldDismissWhenTouchsAnywhere=NO;
//            else
//                _self.shouldDismissWhenTouchsAnywhere=YES;
//                
//        
//        };
//        [self.backgroundView addSubview:_matchView];
//    }
//    return self;
//}
//
//
//
//
//- (void)layoutSubviews
//{
//    
//    
//       
//    self.backgroundView.height=_matchView.bottom;
//    
//    const CGFloat padding = 5.0;
//    CGRect backgroundFrame = self.backgroundView.frame;
//    CGRect frame = backgroundFrame;
//    frame.size.width = 2 * padding + backgroundFrame.size.width;
//    frame.size.height = 2 * padding + backgroundFrame.size.height;
//    frame.origin.x = floorf((self.screenSize.width - frame.size.width) / 2.0);
//    frame.origin.y = floorf((self.screenSize.height - frame.size.height) / 2.0) - 30.0;
//    self.frame = frame;
//    backgroundFrame.origin.x = backgroundFrame.origin.y = padding;
//    self.backgroundView.frame = backgroundFrame;
//    
//  
//}
//
//
//
///*
//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//}
//*/
//
//@end
