//
//  MeFollowSegView.m
//  qianchuo
//
//  Created by jacklong on 16/3/9.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "MeFollowSegView.h"

@interface MeFollowSegView(){
    UISegmentedControl* segmentControl;
}
@end

@implementation MeFollowSegView

- (void)dealloc
{
    NSLog(@"dealloc %@",NSStringFromClass(self.class));
}

- (id)initWithFrame:(CGRect)frame andItemsName:(NSArray*)nameItems andItems:(NSArray*)items andSize:(NSInteger)size border:(BOOL)border{
    self = [super initWithFrame:frame];
    if(self){
        segmentControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        segmentControl.selectedSegmentIndex = -1;
        segmentControl.tintColor = [UIColor clearColor];
        segmentControl.backgroundColor = [UIColor clearColor];
        [segmentControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
        
        NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:size], NSForegroundColorAttributeName: ColorPink};
        [segmentControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
        NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:size], NSForegroundColorAttributeName: ColorPink};
        [segmentControl setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
        
        _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-3, frame.size.width/items.count, 3)];
        _indicatorView.backgroundColor = ColorPink;
        _indicatorView.hidden = YES;
        
        
        [self addSubview:segmentControl];
       
        [self addSubview:_indicatorView];
    }
    return self;
}

- (void) setItemsName:(NSArray*)nameItems andItems:(NSArray*)items
{
    [segmentControl removeAllSegments];
    
    for(int index = 0; index < items.count; index++)
    {
        float total = 0;
        ESFloatVal(&total, items[index]);
        float tempTotalFloat = 0.f;
        if (total >= 10000) {
            tempTotalFloat = total/10000;
        }
        
        NSString * totalStr;
        if (tempTotalFloat > 0) {
            totalStr = [NSString stringWithFormat:@"%.2f%@",tempTotalFloat, ESLocalizedString(@"万")];
        } else {
            totalStr = [NSString stringWithFormat:@"%d",(int)total];
        }
        
        [segmentControl insertSegmentWithTitle:[NSString stringWithFormat:@"%@",totalStr] atIndex:index animated:NO];
    }
}

- (void)segmentChanged:(id)sender
{
    if (index < 0) {
        _indicatorView.hidden = YES;
    }
    
    if (segmentControl.selectedSegmentIndex >= 0) {
        NSInteger newX = segmentControl.selectedSegmentIndex * _indicatorView.frame.size.width;
        [UIView animateWithDuration:0.2f animations:^{
            _indicatorView.frame = CGRectMake(newX, _indicatorView.frame.origin.y, _indicatorView.frame.size.width, _indicatorView.frame.size.height);
        }];
        
        if(self.delegate){
            [self.delegate segmentView:self selectIndex:segmentControl.selectedSegmentIndex];
        }
    }
}

- (void)setSelectIndex:(NSInteger)index
{
    if (index < 0) {
        _indicatorView.hidden = YES;
    }
    segmentControl.selectedSegmentIndex = index;
    
    if (index >= 0) {
        NSInteger newX = segmentControl.selectedSegmentIndex * _indicatorView.frame.size.width;
        [UIView animateWithDuration:0.2f animations:^{
            _indicatorView.frame = CGRectMake(newX, _indicatorView.frame.origin.y, _indicatorView.frame.size.width, _indicatorView.frame.size.height);
        }];
    }
    
    [self segmentChanged:nil];
 }

- (NSInteger)getSelectIndex{
    return segmentControl.selectedSegmentIndex;
}


@end
