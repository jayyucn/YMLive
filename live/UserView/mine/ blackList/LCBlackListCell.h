//
//  LCBlackListCell.h
//  XCLive
//
//  Created by ztkztk on 14-5-13.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DeleteBlackSuccess)(void);

@interface LCBlackListCell : UITableViewCell

@property (nonatomic,strong)NSDictionary *blackDic;
@property (nonatomic,strong)UIImageView *photoView;
@property (nonatomic,strong)UILabel *nameLabel;
//@property (nonatomic,strong)UIImageView *sexView;
@property (nonatomic,strong)UILabel *IDLabel;
@property (nonatomic,strong)DeleteBlackSuccess deleteBlackSuccess;

-(void)showInfo:(NSDictionary *)dic;
@end
