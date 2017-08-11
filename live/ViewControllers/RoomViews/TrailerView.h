//
//  TrailerView.h
//  live
//
//  Created by hysd on 15/8/20.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TrailerView;
@protocol TrailerViewDelegate <NSObject>
- (void)trailerViewTakeCover:(TrailerView*)trailerView;
- (void)trailerViewPublish:(TrailerView*)trailerView;
- (void)trailerViewTime:(TrailerView*)trailerView;
@end

@interface TrailerView : UIView
@property (weak, nonatomic) id<TrailerViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *coverLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIView *timeSepView;
@property (weak, nonatomic) IBOutlet UIView *titleSepView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;
@property (weak, nonatomic) IBOutlet UILabel *leftTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *publishButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
- (IBAction)publishAction:(id)sender;

@end
