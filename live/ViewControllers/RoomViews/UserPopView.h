//
//  UserPopView.h
//  live
//
//  Created by hysd on 15/8/24.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserPopView : UIView
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *praiseLabel;
- (void)showView:(UIView*)view name:(NSString*)name address:(NSString*)address praise:(NSString*)praise;
- (void)hideView;
@end
