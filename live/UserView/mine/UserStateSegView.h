//
//  UserStateSegView.h
//  XCLive
//
//  Created by jacklong on 16/1/15.
//  Copyright © 2016年 www.yuanphone.com. All rights reserved.
//

@class UserStateSegView;

@protocol UserStateSegmentViewDelegate <NSObject>
- (void)segmentView:(UserStateSegView*)segmentView selectIndex:(NSInteger)index;
@end

@interface UserStateSegView : UITableViewCell

@property (nonatomic,weak) id<UserStateSegmentViewDelegate> delegate;

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) BOOL isMySpaceUser;


//- (id)initWithFrame:(CGRect)frame andItems:(NSArray*)items andSize:(NSInteger)size andMyUser:(BOOL)isMyUser;
- (void)setSelectIndex:(NSInteger)index;
- (NSInteger)getSelectIndex;

@end

