//
//  PlayBackCell.h
//  qianchuo
//
//  Created by jacklong on 16/8/8.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

typedef void(^TapPlayBackBlock)(NSDictionary *dic);

@interface PlayBackCell : UITableViewCell

@property (nonatomic, copy) TapPlayBackBlock playBackBlock;

@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, strong) UILabel   *playBackTimeLabel;
@property (nonatomic, strong) UILabel   *visitTotalLabel;
@property (nonatomic, strong) UILabel   *lookFlagLabel;
@property (nonatomic, strong) UIView    *lineView;


@property (nonatomic, strong) NSDictionary *playBackInfoDict;
@end
