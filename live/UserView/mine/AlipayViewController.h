//
//  支付宝兑换界面
//  AlipayViewController.h
//
//  Created by garsonge on 17/2/20.
//


@interface AlipayViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *numOfHana;

@property (nonatomic, weak) IBOutlet UITextField *nameText;
@property (nonatomic, weak) IBOutlet UITextField *alipayAccountText;

@property (nonatomic, weak) IBOutlet UITableView *exchangeRateTable;

@property (nonatomic, weak) IBOutlet UIButton *sendMsg;

@property (nonatomic, strong) NSMutableArray *list;

@property (nonatomic, assign) NSInteger numOfRMB;


// 支付宝兑换
- (IBAction)sendAlipayExchangeInfo;

@end
