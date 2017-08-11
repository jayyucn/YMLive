//
//  UserInfoView.h
//  live
//
//  Created by hysd on 15/7/14.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *userLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userSignLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userFansImageView;
@property (weak, nonatomic) IBOutlet UILabel *userFansLabel;
- (void)showWithName:(NSString*)name signature:(NSString*)sig praise:(NSString*)praise logo:(NSString*)logo;
@end
