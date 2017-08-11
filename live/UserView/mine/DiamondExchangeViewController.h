//
//  钻石兑换界面
//  DiamondExchangeViewController.h
//
//  Created by garsonge on 17/2/20.
//


@interface DiamondExchangeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *numOfDiamond;
@property (nonatomic, weak) IBOutlet UILabel *numOfHana;

@property (nonatomic, weak) IBOutlet UITableView *exchangeRateTable;

@property (nonatomic, weak) IBOutlet UIButton *sendMsg;

@property (nonatomic, strong) NSMutableArray *list;

@property (nonatomic, assign) NSInteger numOfDia;


// 兑换钻石
- (IBAction)sendDiamondExchangeInfo;

@end
