//
//  AgreeOTOCell.h
//  qianchuo
//
//  Created by jacklong on 16/10/25.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

typedef void(^AgreeCellBlock)(BOOL on);

@interface AgreeOTOCell : UITableViewCell

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UIButton *agreeBtn;
@property (nonatomic,strong)AgreeCellBlock agreeCellBlock;

@end
