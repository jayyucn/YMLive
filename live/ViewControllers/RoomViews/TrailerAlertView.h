//
//  TrailerAlertView.h
//  live
//
//  Created by hysd on 15/8/21.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrailerAlertView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *praiseLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourLLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourRLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeSepLLaebl;
@property (weak, nonatomic) IBOutlet UILabel *minuteLLabel;
@property (weak, nonatomic) IBOutlet UILabel *minuteRLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeSepRLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondRLabel;
/**
 *  showView
 *  @param time       直播时间
 *  @param logo       头像路径
 *  @param name       昵称
 *  @param praise     点赞数量
 */
- (void)showTime:(NSString*)time logo:(NSString*)logo name:(NSString*)name praise:(NSString*)praise;
@end
