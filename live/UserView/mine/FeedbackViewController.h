//
//  FeedbackViewController.h
//  TaoHuaLive
//
//  Created by garsonge on 17/2/23.
//  All rights reserved.
//


@interface FeedbackViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITextView *questionDes;
@property (nonatomic, weak) IBOutlet UITableView *questionTypeTable;

@property (nonatomic, weak) IBOutlet UIButton *sendMsg;

@property (nonatomic, strong) NSMutableArray *list;


// 回退到上一层界面
- (IBAction)backToPreviousView;

// 发送反馈
- (IBAction)sendFeedbackInfo;

@end
