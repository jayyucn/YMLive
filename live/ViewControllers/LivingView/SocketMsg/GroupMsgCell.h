//
//  GroupMsgCell.h
//  qianchuo
//
//  Created by jacklong on 16/4/15.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
// 

#import "TapNameLabel.h"

@interface GroupMsgCell : UITableViewCell

+ (NSString *) CellContent:(NSDictionary *)showMsgDict;
+ (BOOL)shouldShowContent:(NSDictionary *)_showMsgDict;

@property (nonatomic, assign) int tableViewWidth;
@property (nonatomic, assign) int cellHeight;

@property (nonatomic, strong) UIImageView    *gradeImgView; //等级图片
@property (nonatomic, strong) TapNameLabel   *msgLabel;// 显示消息


@property (nonatomic, strong) UIButton       *redPacketBtn;// 显示红包

@property (nonatomic, strong) UIImageView    *medalFirstImgView;// 荣耀徽章
@property (nonatomic, strong) UIImageView    *medalTwoImgView;
@property (nonatomic, strong) UIImageView    *medalThreeImgView;
@property (nonatomic, strong) UIImageView    *medalFourImgView;


@property (nonatomic, strong) NSDictionary   *showMsgDict;
@end
