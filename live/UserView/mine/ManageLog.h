//
//  ManageLog.h
//  TaoHuaLive
//
//  Created by garsonge on 17/2/23.
//  All rights reserved.
//


@interface ManageLog : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *logTable;
@property (nonatomic, weak) IBOutlet UILabel *pageNum;

@property (nonatomic, strong) NSMutableArray *list;

@property (nonatomic, assign) NSInteger page;


- (IBAction)nextPage;
- (IBAction)previousPage;

- (IBAction)closeCurrentView;

@end
