//
//  MessageView.h
//  live
//
//  Created by hysd on 15/7/22.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageView : UIView
@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (strong, nonatomic) NSDate* date;
- (id)initWithView:(UIView*)view message:(NSString*)message user:(LiveUser *)user liver:(BOOL)liver;
@end
