//
//  SegmentView.m
//  live
//
//  Created by hysd on 15/8/19.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import "SegmentView.h"
#import "Macro.h"
@interface SegmentView(){
    UISegmentedControl* segmentControl;
}
@end
@implementation SegmentView


- (id)initWithFrame:(CGRect)frame andItems:(NSArray*)items andSize:(NSInteger)size border:(BOOL)border
{
    self = [super initWithFrame:frame];
    if(self){
        segmentControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        // NSLog(@"JoyYouLive :: get segmentControl frame size as w:%f && h:%f", frame.size.width, frame.size.height);
        for(int index = 0; index < items.count; index++){
            [segmentControl insertSegmentWithTitle:items[index] atIndex:index animated:NO];
        }
        segmentControl.selectedSegmentIndex = 0;
        segmentControl.tintColor = [UIColor clearColor];
        segmentControl.backgroundColor = [UIColor clearColor];
        [segmentControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
        
        NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:size], NSForegroundColorAttributeName: RGB16(COLOR_FONT_WHITE)};
        [segmentControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
        NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:size], NSForegroundColorAttributeName: RGB16(COLOR_FONT_BLACK)};
        [segmentControl setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
        
        // _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-3, frame.size.width/items.count, 3)];
        // _indicatorView.backgroundColor = RGB16(COLOR_FONT_WHITE);
        // [self addSubview:_indicatorView];
        
        _selImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width/items.count, frame.size.height/2)];
        [_selImgView setImage:[UIImage imageNamed:@"image/liveroom/nv_seg_bg"]];
        _selImgView.centerY = frame.size.height/2;
        [self addSubview:_selImgView];
        
        [self addSubview:segmentControl];
        if(border){
            UIView* sep = [[UIView alloc] initWithFrame:CGRectMake(0, segmentControl.frame.size.height-1, segmentControl.frame.size.width, 1)];
            sep.backgroundColor = RGB16(COLOR_BG_GRAY);
            [segmentControl addSubview:sep];
        }
    }
    return self;
}

- (void)segmentChanged:(id)sender
{
    NSInteger newX = segmentControl.selectedSegmentIndex * _selImgView.frame.size.width;
    [UIView animateWithDuration:0.2f animations:^{
        // _indicatorView.frame = CGRectMake(newX, _indicatorView.frame.origin.y, _indicatorView.frame.size.width, _indicatorView.frame.size.height);
        
        _selImgView.frame = CGRectMake(newX, _selImgView.frame.origin.y, _selImgView.frame.size.width, _selImgView.frame.size.height);
    }];
    
    if(self.delegate){
        [self.delegate segmentView:self selectIndex:segmentControl.selectedSegmentIndex];
    }
}

- (void)setSelectIndex:(NSInteger)index
{
    segmentControl.selectedSegmentIndex = index;
    NSInteger newX = segmentControl.selectedSegmentIndex * _selImgView.frame.size.width;
    [UIView animateWithDuration:0.2f animations:^{
        // _indicatorView.frame = CGRectMake(newX, _indicatorView.frame.origin.y, _indicatorView.frame.size.width, _indicatorView.frame.size.height);
        
        _selImgView.frame = CGRectMake(newX, _selImgView.frame.origin.y, _selImgView.frame.size.width, _selImgView.frame.size.height);
    }];
}

- (NSInteger)getSelectIndex
{
    return segmentControl.selectedSegmentIndex;
}
@end
