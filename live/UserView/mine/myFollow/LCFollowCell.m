////
////  LCFollowCell.m
////  XCLive
////
////  Created by ztkztk on 14-6-4.
////  Copyright (c) 2014年 ztkztk. All rights reserved.
////
//
//#import "LCFollowCell.h"
//
//@implementation LCFollowCell
//
//- (id)initWithStyle:(UITableViewCellStyle)style
//    reuseIdentifier:(NSString *)reuseIdentifier
//             height:(CGFloat)height
// leftUtilityButtons:(NSArray *)leftUtilityButtons
//rightUtilityButtons:(NSArray *)rightUtilityButtons {
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier height:height leftUtilityButtons:leftUtilityButtons rightUtilityButtons:rightUtilityButtons];
//    if (self)
//    {
//        _myStyleCell=[[LCStyleCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                        reuseIdentifier:@"styleCell"];
//        // 取消选择模式
//        _myStyleCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        _myStyleCell.timeLabel.hidden=YES;
//        
//        _myStyleCell.height=94.0f;
//        
//        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                            action:@selector(tapAction:)];
//        
//        
//        [_myStyleCell addGestureRecognizer:tap];
//
//        
//        
//        /*
//         ESWeakSelf;
//         _myStyleCell.modifyLevelBlock=^(NSDictionary *dic){
//         ESStrongSelf;
//         [_self modifyFriend:dic];
//         };
//         */
//        [self.contentView addSubview:_myStyleCell];
//    }
//    
//    return self;
//}
//
//-(void)tapAction:(UIGestureRecognizer*)sender{
//    NSLog(@"tapAction");
//    if (sender.state == UIGestureRecognizerStateEnded)
//    {
//        _tapCellBlock(_myStyleCell.infoDic);
//               
//    }
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
