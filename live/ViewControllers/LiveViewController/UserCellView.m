//
//  UserCellView.m
//  TaoHuaLive
//
//  Created by Jay on 2017/7/3.
//  Copyright © 2017年 上海七夕. All rights reserved.
//

#import "UserCellView.h"

@interface UserCellView()
{
    UIImageView *bgImgView;
    UILabel     *nicknameLb;
    
    NSDictionary *userInfoDict;
}

@end

@implementation UserCellView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height-20)];
        [self addSubview:bgImgView];
        nicknameLb = [[UILabel alloc] initWithFrame:CGRectMake(0, bgImgView.bottom, self.width, 20)];
        nicknameLb.textColor = [UIColor blackColor];
        nicknameLb.font = [UIFont systemFontOfSize:14];
        nicknameLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:nicknameLb];
        UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(singleTap)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [self addGestureRecognizer:singleRecognizer];
    }
    return self;
}
- (void)singleTap {
    if (_itemBlock) {
        _itemBlock(userInfoDict);
    }
}

- (void)configViewWithDict:(NSDictionary *)dict {
    userInfoDict = dict;
    [bgImgView sd_setImageWithURL:[NSURL URLWithString:dict[@"face"]] placeholderImage:[UIImage imageNamed:@"default_head"]];
    nicknameLb.text = dict[@"nickname"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
