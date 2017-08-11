//
//  DriveBaseView.m
//  qianchuo
//
//  Created by 林伟池 on 16/8/9.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "DriveBaseView.h"
#import "DriveManager.h"

@implementation DriveBaseView


- (void)setMNickName:(NSString *)mNickName {
    UILabel* nameLabel = [[UILabel alloc] init];
    nameLabel.text = mNickName;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.shadowColor = [UIColor yellowColor];
    [nameLabel sizeToFit];
    nameLabel.center = CGPointMake(self.width / 2, self.height / 2 - 100);
    [self addSubview:nameLabel];
}

- (void)endAnimation {
    [self removeFromSuperview];
    [[DriveManager shareInstance] onAnimationFinish];
}

@end
