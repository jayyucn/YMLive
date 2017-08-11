//
//  AboutAlertView.h
//  live
//
//  Created by hysd on 15/8/21.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutAlertView : UIView
@property (weak, nonatomic) IBOutlet UIView *sepView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
- (IBAction)closeAction:(id)sender;
/**
 *  showView
 *  @param title      标题
 *  @param content    内容
 */
- (void)showTitle:(NSString*)title content:(NSString*)content;
@end
