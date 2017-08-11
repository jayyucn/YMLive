//
//  兑换记录界面
//  ExchangeLogViewController.h
//
//  Created by garsonge on 17/2/22.
//


@interface ExchangeLogViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *logTable;
@property (nonatomic, weak) IBOutlet UILabel *pageNum;

@property (nonatomic, strong) NSMutableArray *list;

@property (nonatomic, assign) NSInteger page;


- (IBAction)nextPage;
- (IBAction)previousPage;

@end
