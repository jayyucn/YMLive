//
//  MyAppTableViewCell.h
//  live
//
//  Created by hysd on 15/8/28.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MyAppDelegate <NSObject>
- (void)logout;
- (void)about;
@end;
@interface MyAppTableViewCell : UITableViewCell
@property (weak, nonatomic) id<MyAppDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
- (IBAction)logoutAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *aboutView;

@end
