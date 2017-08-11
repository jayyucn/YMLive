//
//  LiveAttentListView.m
//  qianchuo
//
//  Created by jacklong on 16/3/8.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "LiveAttentListView.h"

@implementation LiveAttentListView

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
        _noDataLabel.text = @"暂无数据1";
        [_noDataView addSubview:_noDataLabel];
        
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(100, 100, 60, 60)];
        [self addSubview:self.activityIndicator];
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.activityIndicator.hidden = YES;
        
        
        _attentTableView = [[UserAttentTableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _attentTableView.noDataView = _noDataView;
        _attentTableView.noDataLabel = _noDataLabel;
        [self addSubview:_attentTableView];
    }
    return self;
}

- (void) layoutSubviews
{
    _activityIndicator.center = CGPointMake(self.frame.size.width/2, self.height/2);
    _noDataView.height = self.height;
    _attentTableView.height = self.height;
}

- (void) beginLoadData
{
    if (_attentTableView.datas.count <= 0) {
        [_attentTableView refreshData];
    }
}

- (void) clearData
{

}
@end
