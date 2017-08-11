//
//  NetStatusView.m
//  live
//
//  Created by hysd on 15/8/24.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import "NetStatusView.h"
@interface NetStatusView(){
    UIImageView* waitImageView;
    UILabel* waitLabel;
}
@end;
@implementation NetStatusView

- (id)init{
    self = [super init];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        waitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 25, 25)];
        waitLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 45, 200)];
        waitLabel.text = @"马上回来,努力加速中...";
        waitImageView.image = [UIImage imageNamed:@"dolive"];
        self.frame = CGRectMake(0, 0, 245, 45);
        [self addSubview:waitImageView];
        [self addSubview:waitLabel];
    }
    return self;
}

- (void)showView:(UIView*)superView{
    self.alpha=0;
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha=1;
    } completion:^(BOOL finished) {
    }];
}

- (void)hideView{
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha=0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
