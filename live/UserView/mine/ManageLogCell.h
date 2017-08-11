//
//  ManageLogCell.h
//  TaoHuaLive
//
//  Created by garsonge on 17/2/23.
//  All rights reserved.
//


@interface ManageLogCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *time;
@property (nonatomic, weak) IBOutlet UILabel *userId;
@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *content;


// 设置cell的属性
- (void)setupCell;

@end
