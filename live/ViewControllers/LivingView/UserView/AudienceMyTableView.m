//
//  AudienceMyTableView.m
//  qianchuo
//
//  Created by jacklong on 16/4/18.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "AudienceMyTableView.h"
#import "UserSpaceViewController.h"

@implementation AudienceMyTableView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        //tableview逆时针旋转90度。
        self.transform = CGAffineTransformMakeRotation(-M_PI/2);
        // scrollbar 不显示
        self.showsVerticalScrollIndicator = NO;
        
        _datas = [NSMutableArray array];
        
//        //添加上拉加载
//        _footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
//        _footer.stateLabel.hidden = YES;
//        _footer.stateLabel.frame = CGRectZero;
//        self.mj_footer = _footer;
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
//    self.width = ViewWidth + ViewPadding;
//    NSLog(@"audience frame:%@",NSStringFromCGRect(self.frame));
//    self.width = SCREEN_WIDTH - 90;
}


- (void)loadData
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_datas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frame.size.height; // 返回的是高度;
}
 

@end
