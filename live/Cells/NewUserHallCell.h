//
//  NewUserHallCell.h
//  qianchuo
//
//  Created by jacklong on 16/4/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "NewUserItemView.h"

#define kNum 3

#define IntervalPixel 4.0
 
#define kCell_Items_Width (ScreenWidth-IntervalPixel*(kNum+1))/kNum
#define kCell_Items_Height (ScreenWidth-IntervalPixel*(kNum+1))/kNum

@interface NewUserHallCell : UITableViewCell

- (void)clear;

@end
