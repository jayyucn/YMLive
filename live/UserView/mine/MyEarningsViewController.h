//
//  我的收益界面
//  MyEarningsViewController.h
//
//  Created by garsonge on 17/2/17.
//


@interface MyEarningsViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton *aliExchangeButton;
@property (nonatomic, weak) IBOutlet UIImageView *aliExchangeImg;

@property (nonatomic, weak) IBOutlet UIButton *wxExchangeButton;
@property (nonatomic, weak) IBOutlet UIImageView *wxExchangeImg;

@property (nonatomic, weak) IBOutlet UIButton *bankExchangeButton;
@property (nonatomic, weak) IBOutlet UIImageView *bankExchangeImg;

@property (nonatomic, weak) IBOutlet UIButton *diaExchangeButton;
@property (nonatomic, weak) IBOutlet UIImageView *diaExchangeImg;

@property (nonatomic, weak) IBOutlet UIButton *familyManageButton;
@property (nonatomic, weak) IBOutlet UIImageView *familyManageImg;

@property (nonatomic, weak) IBOutlet UILabel *numOfDiamond;
@property (nonatomic, weak) IBOutlet UILabel *numOfHana;

// 主播类型
@property (nonatomic, copy) NSString *anchorType;


// 回退到上一层界面
- (IBAction)backToPreviousView;

// 打开微信兑换web页面
- (IBAction)openWXExchangeView;

// 打开家族管理web页面
- (IBAction)openFamilyView;

// 打开常见问题界面
- (IBAction)openFAQView;

@end
