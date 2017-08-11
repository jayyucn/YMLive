//
//  PushParamView.h
//  live
//
//  Created by wilderliao on 15/10/19.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^PushConfirm)();
typedef void (^PushCancel)();

@interface PushParamView : UIView

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *describeTextField;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

- (IBAction)confirmAction:(id)sender;
- (IBAction)cancelAction:(id)sender;


- (void)showTitle:(NSString*)title confirmTitle:(NSString*)conTitle cancelTitle:(NSString*)canTitle confirm:(PushConfirm)confirm cancel:(PushCancel)cancel;

@end
