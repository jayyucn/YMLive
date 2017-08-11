//
//  AttentFansSegView.m
//  qianchuo
//
//  Created by jacklong on 16/8/4.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "AttentFansSegView.h"

@interface AttentFansSegView(){
    UISegmentedControl* segmentControl;
//    UIView* indicatorView;
}
@end

@implementation AttentFansSegView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        segmentControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, frame.size.width,  self.frame.size.height)];
        
        segmentControl.selectedSegmentIndex = 0;
        segmentControl.tintColor = [UIColor clearColor];
        segmentControl.backgroundColor = [UIColor clearColor];
        
        [segmentControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5f, 20.f)];
        [lineView setBackgroundColor:[UIColor whiteColor]];
        lineView.centerX = frame.size.width/2;
        lineView.centerY = self.frame.size.height/2;
        
        [self addSubview:segmentControl];
        [self addSubview:lineView];

    }
    return self;
}


-(void)setItems:(NSArray *)items
{
    [segmentControl removeAllSegments];
    
    _items = items;
    for(int index = 0; index < _items.count; index++){
        [segmentControl insertSegmentWithTitle:_items[index] atIndex:index animated:NO];
    }
    
//    if (!indicatorView) {
//        indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-3, ScreenWidth/_items.count, 3)];
//        indicatorView.backgroundColor = RGB16(COLOR_FONT_WHITE);
//        
//        [self addSubview:indicatorView];
//    }
}

- (void) setIsMySpaceUser:(BOOL)isMySpaceUser
{
    _isMySpaceUser = isMySpaceUser;
    if (_isMySpaceUser) {
        NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.f], NSForegroundColorAttributeName: RGB16(COLOR_FONT_WHITE)};
        [segmentControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
        NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.f], NSForegroundColorAttributeName: RGB16(COLOR_FONT_WHITE)};
        [segmentControl setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    } else  {
        NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.f], NSForegroundColorAttributeName: RGB16(COLOR_FONT_WHITE)};
        [segmentControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
        NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.f], NSForegroundColorAttributeName: RGB16(COLOR_FONT_WHITE)};
        [segmentControl setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    }
    
}

- (id)initWithFrame:(CGRect)frame andItems:(NSArray*)items andSize:(NSInteger)size andMyUser:(BOOL)isMyUser{
    self = [super initWithFrame:frame];
    if(self){
        
    }
    return self;
}

- (void)segmentChanged:(id)sender{
//    if (!_isMySpaceUser) {
//        NSInteger newX = segmentControl.selectedSegmentIndex * indicatorView.frame.size.width;
//        [UIView animateWithDuration:0.2f animations:^{
//            indicatorView.frame = CGRectMake(newX, indicatorView.frame.origin.y, indicatorView.frame.size.width, indicatorView.frame.size.height);
//        }];
//    }
    
    if(self.delegate){
        [self.delegate attentFansSegmentView:self selectIndex:segmentControl.selectedSegmentIndex];
    }
    
    [segmentControl setSelectedSegmentIndex:-1];
}

- (void)setSelectIndex:(NSInteger)index{
    if (index < 0 ) {
        return;
    }
    segmentControl.selectedSegmentIndex = index;
//    if (!_isMySpaceUser) {
//        NSInteger newX = segmentControl.selectedSegmentIndex * indicatorView.frame.size.width;
//        [UIView animateWithDuration:0.2f animations:^{
//            indicatorView.frame = CGRectMake(newX, indicatorView.frame.origin.y, indicatorView.frame.size.width, indicatorView.frame.size.height);
//        }];
//    }
}

- (NSInteger)getSelectIndex{
    return segmentControl.selectedSegmentIndex;
}


@end
