//
//  WelcomeView.h
//  live
//
//  Created by hysd on 15/7/28.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeView : UIView
@property (strong, nonatomic) NSDate* date;
- (id)initWithFrame:(CGRect)frame andName:(NSString*)name;
@end
