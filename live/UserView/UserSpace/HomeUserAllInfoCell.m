//
//  HomeUserAllInfoCell.m
//  qianchuo
//
//  Created by jacklong on 16/8/11.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "HomeUserAllInfoCell.h"

@implementation HomeUserAllInfoCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _homeUserInfoView =  [[HomeUserInfoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height) withShowHeadRefresh:NO withShowFooterRefresh:NO];
        
        [self addSubview:_homeUserInfoView];

    }
    return self;
}

- (void) setShowRankBlock:(ShowRankVCBlock)showRankBlock
{
    _homeUserInfoView.showRankBlock = showRankBlock;
}
@end
