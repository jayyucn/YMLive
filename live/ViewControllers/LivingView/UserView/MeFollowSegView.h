//
//  MeFollowSegView.h
//  qianchuo
//
//  Created by jacklong on 16/3/9.
//  Copyright © 2016年 kenneth. All rights reserved.
//

@class MeFollowSegView;

@protocol MeFollowSegViewDelegate <NSObject>
- (void)segmentView:(MeFollowSegView*)segmentView selectIndex:(NSInteger)index;
@end

@interface MeFollowSegView : UIView

@property (nonatomic,weak) id<MeFollowSegViewDelegate> delegate;

@property (nonatomic, strong) UIView* indicatorView;

- (id)initWithFrame:(CGRect)frame andItemsName:(NSArray*)nameItems andItems:(NSArray*)items andSize:(NSInteger)size border:(BOOL)border;
- (void) setItemsName:(NSArray*)nameItems andItems:(NSArray*)items;
- (void) setSelectIndex:(NSInteger)index;
- (NSInteger) getSelectIndex;

@end
