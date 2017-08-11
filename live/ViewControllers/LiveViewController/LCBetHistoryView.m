//
//  LCBetHistoryView.m
//  TaoHuaLive
//
//  Created by Jay on 2017/7/31.
//  Copyright © 2017年 上海七夕. All rights reserved.
//

#import "LCBetHistoryView.h"

@interface LCBetHistoryLineView : UIView

@end

@implementation LCBetHistoryLineView

- (instancetype)initWithFrame:(CGRect)frame winAtIndex:(NSInteger)index
{
    self = [super initWithFrame:frame];
    if (self) {
        CGSize size = frame.size;
        UILabel *lb1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width/3, size.height)];
        lb1.textAlignment = NSTextAlignmentCenter;
        lb1.font = [UIFont systemFontOfSize:17];
        [self addSubview:lb1];
        
        UILabel *lb2 = [[UILabel alloc] initWithFrame:CGRectMake(size.width/3, 0, size.width/3, size.height)];
        lb2.textAlignment = NSTextAlignmentCenter;
        lb2.font = [UIFont systemFontOfSize:17];
        [self addSubview:lb2];
        
        UILabel *lb3 = [[UILabel alloc] initWithFrame:CGRectMake(size.width*2/3, 0, size.width/3, size.height)];
        lb3.textAlignment = NSTextAlignmentCenter;
        lb3.font = [UIFont systemFontOfSize:17];
        [self addSubview:lb3];
        
        [self configLabels:@[lb1,lb2,lb3] withIndex:index];
    }
    return self;
}

- (void)configLabels:(NSArray *)lbs withIndex:(NSInteger)index
{
    for (int i = 0; i < lbs.count; i++) {
        UILabel *lb = (UILabel *)lbs[i];
        if (i == index) {
            lb.attributedText = [[NSAttributedString alloc] initWithString:@"胜" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor redColor]}];
        }else {
            lb.attributedText = [[NSAttributedString alloc] initWithString:@"负" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor blueColor]}];
        }
        
        
    }
}

@end


@interface LCBetHistoryView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *infoArray;
@property (nonatomic, assign) CGFloat lineHeight;

@end

@implementation LCBetHistoryView

- (void)dealloc
{
    _scrollView = nil;
    _infoArray = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
                    infoArray:(NSArray *)infoArray
                   lineHeight:(CGFloat)lineHeight
{
    self = [super initWithFrame:frame];
    if (self) {
        _infoArray = infoArray;
        _lineHeight = lineHeight?:44;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    UIView *lineGap = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 1)];
    lineGap.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineGap];
    UIImage *blueCowImage = [UIImage imageNamed:@"image/games/ic_bull_starblue"];
    UIImage *redCowImage = [UIImage imageNamed:@"image/games/ic_bull_starred"];
    UIImage *yellowCowImage = [UIImage imageNamed:@"image/games/ic_bull_staryellow"];
    
    UIImageView *blueImgView = [[UIImageView alloc] initWithImage:blueCowImage];
    UIImageView *redImgView = [[UIImageView alloc] initWithImage:redCowImage];
    UIImageView *yellowImgView = [[UIImageView alloc] initWithImage:yellowCowImage];
    
    CGFloat imgWidth = blueCowImage.size.width*2/3;
    CGFloat imgHeight = blueCowImage.size.height*2/3;
    blueImgView.frame = CGRectMake(self.width/6-imgWidth/2, 8, imgWidth, imgHeight);
    redImgView.frame = CGRectMake(self.width/2-imgWidth/2, 8, imgWidth, imgHeight);
    yellowImgView.frame = CGRectMake(self.width*5/6-imgWidth/2, 8, imgWidth, imgHeight);
    
    [self addSubview:blueImgView];
    [self addSubview:redImgView];
    [self addSubview:yellowImgView];
    
    CGRect frame = self.frame;
    frame.origin.y = blueImgView.bottom+8;
    _scrollView = [[UIScrollView alloc] initWithFrame:frame];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(self.width, _infoArray.count*_lineHeight);
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    for (int i = 0; i < _infoArray.count; i++) {
        id obj = _infoArray[i];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)obj;
            NSInteger win = [[dict objectForKey:@"win"] integerValue];
            LCBetHistoryLineView *lineView = [[LCBetHistoryLineView alloc] initWithFrame:CGRectMake(0, i*_lineHeight, self.width, _lineHeight) winAtIndex:win];
            [_scrollView addSubview:lineView];
        }
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
