//
//  LiveView.h
//  live
//
//  Created by hysd on 15/8/20.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LiveView;
@protocol LiveViewDelegate <NSObject>
- (void)liveViewTakeCover:(LiveView*)liveView;
- (void)liveVIewStartLive:(LiveView*)liveView;
@end
@interface LiveView : UIView
@property (weak, nonatomic) id<LiveViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *coverLabel;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIView *titleSepView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIButton *liveButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
- (IBAction)liveAction:(id)sender;

@end
