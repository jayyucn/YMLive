//
//  FinishView.h
//  live
//
//  Created by hysd on 15/8/23.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FinishView;
@protocol FinishViewDelegate <NSObject>
- (void)finishViewClose:(FinishView*)fv;
@end

@interface FinishView : UIView
@property (weak, nonatomic) id<FinishViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *sepView;
@property (weak, nonatomic) IBOutlet UILabel *audienceLabel;
@property (weak, nonatomic) IBOutlet UILabel *audienceNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *praiseLabel;
@property (weak, nonatomic) IBOutlet UILabel *praiseNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
- (IBAction)closeAction:(id)sender;
/**
 *  showView
 *  @param superView  父视图
 *  @param audience   观众数量
 *  @param praise     点赞数量
 */
- (void)showView:(UIView*)superView audience:(NSString*)audience praise:(NSString*)praise;
@end
