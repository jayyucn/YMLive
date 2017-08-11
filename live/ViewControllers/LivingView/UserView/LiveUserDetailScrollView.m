//
//  LiveUserDetailScrollView.m
//  qianchuo
//
//  Created by jacklong on 16/3/8.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "LiveUserDetailScrollView.h"

#define COLOR_HEAD      0x30000000

@interface LiveUserDetailScrollView ()
{
    LiveAttentListView *attentListView;
    LiveFansListView *fansListView;
    LiveReceiverMoneyListView *receiverListView;
}

@end

@implementation LiveUserDetailScrollView

- (void)dealloc
{
    NSLog(@"dealloc %@",NSStringFromClass(self.class));
    _scrollView.delegate = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    { 
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 5)];
        _lineView.backgroundColor = UIColorWithRGB(244,244,244);
        [self addSubview:_lineView];
        
        _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0,_lineView.bottom,frame.size.width,frame.size.height - 5)];
        _scrollView.contentSize = CGSizeMake(3*frame.size.width, frame.size.height - 5);
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        
        [self addSubview:_scrollView];
      
        [self addScrollSubView];
    }
    return self;
}

- (void)layoutSubviews
{
    _scrollView.height = self.height - 5 + 5;
    
    attentListView.height = _scrollView.height;
    fansListView.height = _scrollView.height;
    receiverListView.height = _scrollView.height;
    
    UIBezierPath *showPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *showLayer = [[CAShapeLayer alloc] init];
    showLayer.frame = self.bounds;
    showLayer.path = showPath.CGPath;
    self.layer.mask = showLayer;
}

- (void) setUserInfoDict:(NSDictionary *)userInfoDict
{
    _userInfoDict = userInfoDict;
    NSLog(@"_userinfoDict:%@",userInfoDict);
    if (_userInfoDict) {
        attentListView.attentTableView.userInfoDict =  _userInfoDict;
        
        fansListView.fansTableView.userInfoDict = _userInfoDict;
        
        receiverListView.receiverMoneyTableView.userInfoDict = _userInfoDict;
    }
}

- (void) setShowUserDetailBlock:(ShowUserDetailBlock)showUserDetailBlock
{
    attentListView.attentTableView.showUserDetailBlock = showUserDetailBlock;
    fansListView.fansTableView.showUserDetailBlock = showUserDetailBlock;
    receiverListView.receiverMoneyTableView.showUserDetailBlock = showUserDetailBlock;
}

-(void)addScrollSubView
{
    attentListView = [[LiveAttentListView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH - 60,_scrollView.height)];
    attentListView.tag =1;
    [_scrollView addSubview:attentListView];
    
    fansListView = [[LiveFansListView alloc] initWithFrame:CGRectMake(self.frame.size.width,0,SCREEN_WIDTH - 60,_scrollView.height)];
    fansListView.tag =2;
    [_scrollView addSubview:fansListView];
    
    receiverListView = [[LiveReceiverMoneyListView alloc] initWithFrame:CGRectMake(self.frame.size.width*2,0,SCREEN_WIDTH - 60,_scrollView.height)];
    receiverListView.tag =3;
    [_scrollView addSubview:receiverListView];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scroll
{
    CGPoint offset = _scrollView.contentOffset;
    NSInteger page = (offset.x + _scrollView.frame.size.width/2) / _scrollView.frame.size.width;
    if (_segView)
    {
      [_segView setSelectIndex:page];
    }

    if (page == 0) {
        [self loadAttentData];
    } else if (page == 1) {
        [self loadFansData];
    } else if (page == 2) {
        [self loadReceiverData];
    }
}

// 加载关注列表数据
- (void) loadAttentData
{
    [attentListView beginLoadData];
}

// 加载粉丝列表数据
- (void) loadFansData
{
    [fansListView beginLoadData];
}

// 加载收入列表数据
- (void) loadReceiverData
{
    [receiverListView beginLoadData];
}

@end
