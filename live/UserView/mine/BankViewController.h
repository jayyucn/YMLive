//
//  银联兑换界面
//  BankViewController.h
//
//  Created by garsonge on 17/2/21.
//


@interface BankViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *numOfHana;

@property (nonatomic, weak) IBOutlet UITextField *nameText;
@property (nonatomic, weak) IBOutlet UITextField *bankAccountText;

@property (nonatomic, weak) IBOutlet UITableView *exchangeRateTable;

@property (nonatomic, weak) IBOutlet UIButton *sendMsg;

@property (nonatomic, strong) NSMutableArray *list;

@property (nonatomic, assign) NSInteger numOfRMB;


// 银联兑换
- (IBAction)sendBankExchangeInfo;

@end
