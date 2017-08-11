//
//  MyInfoCell.h
//  TaoHuaLive
//
//  Created by kellyke on 2017/6/29.
//  Copyright © 2017年 上海七夕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyInfoModel.h"

@protocol MyInfoCellDelegate <NSObject>

-(void)showEditUserInfo;
-(void)showRankDetailAction;

@end
@interface MyInfoCell : UITableViewCell

@property (nonatomic,weak) id<MyInfoCellDelegate> delegate;
- (void)configCellWithModel:(MyInfoModel *)model;

@end
