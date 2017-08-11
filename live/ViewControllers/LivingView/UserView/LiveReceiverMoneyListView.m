//
//  LiveReceiverMoneyListView.m
//  qianchuo
//
//  Created by jacklong on 16/3/8.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "LiveReceiverMoneyListView.h"

@implementation LiveReceiverMoneyListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_noDataView];
        _noDataView.hidden = YES;
        
        _noDataImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image/liveroom/default_no_data"]];
        _noDataImg.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        [_noDataView  addSubview:_noDataImg];
        
        _noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _noDataImg.bottom, frame.size.width, 20)];;
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
        _noDataLabel.font = [UIFont boldSystemFontOfSize:14];
        _noDataLabel.textColor = [UIColor blackColor];
        _noDataLabel.text = @"暂无数据3";
        [_noDataView addSubview:_noDataLabel];
        
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(100, 100, 60, 60)];
        [self addSubview:self.activityIndicator];
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.activityIndicator.hidden = YES;
        
        _receiverMoneyTableView = [[UserReceiverMoneyTableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _receiverMoneyTableView.noDataView = _noDataView;
        _receiverMoneyTableView.noDataLabel = _noDataLabel;
        _receiverMoneyTableView.activityIndicator = _activityIndicator;
        _receiverMoneyTableView.backgroundColor = [UIColor clearColor];
        [self addSubview:_receiverMoneyTableView]; 
    }
    return self;
}

- (void) layoutSubviews
{
    _activityIndicator.center = CGPointMake(self.frame.size.width/2, self.height/2);
    _noDataView.height = self.height;
    _receiverMoneyTableView.height = self.height;
}

- (void) beginLoadData
{
    if (_receiverMoneyTableView.datas.count <= 0) {
        [_receiverMoneyTableView refreshData];
    }
}

- (void) clearData
{
    
}

@end
