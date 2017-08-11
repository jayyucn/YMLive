//
//  LiveAlertView.h
//  live
//
//  Created by hysd on 15/8/21.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^LiveAlertConfirm)();
typedef void (^LiveAlertCancel)();

@interface LiveAlertView : UIView
@property (weak, nonatomic) IBOutlet UIView *sepVView;
@property (weak, nonatomic) IBOutlet UIView *sepHView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
- (IBAction)confirmAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
/**
 *  showView
 *  @param superView  父view
 *  @param title      标题
 *  @param conTitle   确定
 *  @param canTitle   取消
 *  @param confirm    确定block
 *  @param cancel     取消block
 */
- (void)showTitle:(NSString*)title confirmTitle:(NSString*)conTitle cancelTitle:(NSString*)canTitle confirm:(LiveAlertConfirm)confirm cancel:(LiveAlertCancel)cancel;

- (void)addInviteUser:(LiveUser *)user;
@end
