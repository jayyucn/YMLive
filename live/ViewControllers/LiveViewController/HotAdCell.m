//
//  HotAdCell.m
//  qianchuo
//
//  Created by jacklong on 16/7/11.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "HotAdCell.h"

@interface HotAdCell()

@property (nonatomic, strong)RollingView *view;

@end

@implementation HotAdCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        _view = [RollingView carouselViewWithImageArray:nil describeArray:nil];
        [_view setPageColor:[UIColor whiteColor] andCurrentPageColor:ColorPink];
        _view.time = 4.0;
        _view.delegate = self;
        _view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100); 
        [self addSubview:_view];
    }
    return self;
}


- (void)setTopADs:(NSMutableArray *)topADs
{
    _topADs = topADs;
    
    NSMutableArray *imageUrls = [NSMutableArray array];
    for (NSDictionary *topADDict in topADs) {
        [imageUrls addObject:topADDict[@"pic"]];
    }
  
    _view.imageArray = imageUrls;
}

#pragma mark - RollingViewDelegate
- (void)carouselView:(RollingView *)carouselView clickImageAtIndex:(NSInteger)index
{
    if (self.imageClickBlock) {
        self.imageClickBlock(index);
    }
}
@end
