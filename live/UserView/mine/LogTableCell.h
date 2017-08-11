//
//  兑换记录
//  LogTableCell.h
//
//  Created by garsonge on 17/2/22.
//


@interface LogTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *time;
@property (nonatomic, weak) IBOutlet UILabel *channel;
@property (nonatomic, weak) IBOutlet UILabel *content;
@property (nonatomic, weak) IBOutlet UILabel *status;


// 设置cell的属性
- (void)setupCell;

@end
