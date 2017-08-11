//
//  AttentFansSegView.h
//  qianchuo
//
//  Created by jacklong on 16/8/4.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

@class AttentFansSegView;

@protocol AttentFansSegViewDelegate <NSObject>

- (void)attentFansSegmentView:(AttentFansSegView*)segmentView selectIndex:(NSInteger)index;

@end

@interface AttentFansSegView : UIView

@property (nonatomic, assign) BOOL isMySpaceUser;
@property (nonatomic,weak) id<AttentFansSegViewDelegate> delegate;

@property (nonatomic, strong) NSArray *items;


- (void)setSelectIndex:(NSInteger)index;

- (NSInteger)getSelectIndex;

@end
