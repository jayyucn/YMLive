//
//  UserStateSegView.m
//  XCLive
//
//  Created by jacklong on 16/1/15.
//  Copyright © 2016年 www.yuanphone.com. All rights reserved.
//

#import "UserStateSegView.h"
#import "SegmentView.h"

@interface UserStateSegView(){
    UISegmentedControl  *segmentControl;
    UIView  *indicatorView;
    UIView  *lineView;
    UIView  *bottomLineView;
}
@end

@implementation UserStateSegView


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        segmentControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,  self.frame.size.height)];
        
        segmentControl.selectedSegmentIndex = 0;
        segmentControl.tintColor = [UIColor clearColor];
        segmentControl.backgroundColor = [UIColor clearColor];
        
        [segmentControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5f, 20.f)];
        [lineView setBackgroundColor:[UIColor grayColor]];
        lineView.centerX = ScreenWidth/2;
        lineView.centerY = self.frame.size.height/2;
        
        bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-.5, ScreenWidth, .5)];
        bottomLineView.backgroundColor = [UIColor lightGrayColor];
        
        [self addSubview:segmentControl];
        [self addSubview:lineView];
        [self addSubview:bottomLineView];
        bottomLineView.hidden = YES;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        segmentControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,  self.frame.size.height)];
        
        segmentControl.selectedSegmentIndex = 0;
        segmentControl.tintColor = [UIColor clearColor];
        segmentControl.backgroundColor = [UIColor clearColor];
        
        [segmentControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5f, 20.f)];
        [lineView setBackgroundColor:[UIColor grayColor]];
        lineView.centerX = ScreenWidth/2;
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

    if (_isMySpaceUser) {
        if (!indicatorView) {
            indicatorView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4-20, self.frame.size.height-3, 40 , 3)];
            indicatorView.backgroundColor = ColorDark;
            
            [self addSubview:indicatorView];
        }
    }
}

- (void) setIsMySpaceUser:(BOOL)isMySpaceUser
{
    _isMySpaceUser = isMySpaceUser;
    if (_isMySpaceUser) {
        lineView.hidden = YES;
        if (bottomLineView) {
            bottomLineView.hidden = NO;
        }
        
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:ColorPink,NSForegroundColorAttributeName,[UIFont fontWithName:@"AppleGothic"size:14.f],NSFontAttributeName ,nil];
//        [segmentControl setTitleTextAttributes:dic forState:UIControlStateNormal];
//
//         NSDictionary *selectDic = [NSDictionary dictionaryWithObjectsAndKeys:ColorPink,NSBackgroundColorAttributeName,[UIFont fontWithName:@"AppleGothic"size:14.f],NSFontAttributeName ,nil];
//        [segmentControl setTitleTextAttributes:selectDic forState:UIControlStateSelected];//设置文字属性
//        [segmentControl setTitleTextAttributes:selectDic forState:UIControlStateFocused];//设置文字属性
        NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.f], NSForegroundColorAttributeName: ColorPink};
        [segmentControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
        NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.f], NSForegroundColorAttributeName: ColorPink};
        [segmentControl setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    } else  {
        NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.f], NSForegroundColorAttributeName: RGB16(COLOR_FONT_RED)};
        [segmentControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
        NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.f], NSForegroundColorAttributeName: RGB16(COLOR_FONT_GRAY)};
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
    if (_isMySpaceUser) {
        NSInteger newX = segmentControl.selectedSegmentIndex * indicatorView.frame.size.width;
        [UIView animateWithDuration:0.2f animations:^{
            indicatorView.frame = CGRectMake(newX==0?SCREEN_WIDTH/4-20:SCREEN_WIDTH*3/4-20, indicatorView.frame.origin.y, indicatorView.frame.size.width, indicatorView.frame.size.height);
        }];
    }
    
    if(self.delegate){
        [self.delegate segmentView:self selectIndex:segmentControl.selectedSegmentIndex];
    }
    
    [segmentControl setSelectedSegmentIndex:-1];
}

- (void)setSelectIndex:(NSInteger)index{
    if (index < 0 ) {
        return; 
    }
    segmentControl.selectedSegmentIndex = index;
    if (_isMySpaceUser) {
        NSInteger newX = segmentControl.selectedSegmentIndex * indicatorView.frame.size.width;
        [UIView animateWithDuration:0.2f animations:^{
            indicatorView.frame = CGRectMake(newX, indicatorView.frame.origin.y, indicatorView.frame.size.width, indicatorView.frame.size.height);
        }];
    }
}

- (NSInteger)getSelectIndex{
    return segmentControl.selectedSegmentIndex;
}


@end
