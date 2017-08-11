//
//  MyAttentCell.h
//  TaoHuaLive
//
//  Created by kellyke on 2017/6/28.
//  Copyright © 2017年 上海七夕. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyAttentCellDelegate <NSObject>

-(void)segmentView:(NSInteger)index;

@end
@interface MyAttentCell : UITableViewCell

@property (nonatomic,weak) id<MyAttentCellDelegate> delegate;

-(void)setInfo:(NSString *)attenttop setAttentBootom:(NSString *)attenbttom setFanstop:(NSString *) fanstop setFansBottom:(NSString *)fansbttom;
@end
