//
//  UserInfoView.m
//  live
//
//  Created by hysd on 15/7/14.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import "UserInfoView.h"
#import "Macro.h"
#import "UIImage+Category.h"

@interface UserInfoView(){
    UIWindow *mOriginalWindow;
    UIView *mBackgroundView;
}
@end
@implementation UserInfoView
- (void)awakeFromNib
{

        //设置圆角
        self.layer.cornerRadius = 5;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH-60, self.frame.size.height);
        //圆形头像
        self.userLogoImageView.image = [UIImage imageNamed:@"default_head"];
        self.userLogoImageView.layer.cornerRadius = self.userLogoImageView.frame.size.width/2;
        self.userLogoImageView.clipsToBounds = YES;
        //关闭按钮
        UIButton* closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame = CGRectMake(self.frame.size.width-30, -10, 40, 40);
        [closeButton setImage:[UIImage imageNamed:@"close_red_circle"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        //名字
        self.userNameLabel.textColor = RGB16(COLOR_FONT_BLACK);
        //签名
        self.userSignLabel.textColor = RGB16(COLOR_FONT_GRAY);
        //fans
        self.userFansImageView.image = [UIImage imageNamed:@"ilike"];
        self.userFansLabel.textColor = RGB16(COLOR_FONT_LIGHTGRAY);
        
        CGRect rect = [UIScreen mainScreen].bounds;
        mOriginalWindow = [[UIWindow alloc] initWithFrame:rect];
        mOriginalWindow.windowLevel = UIWindowLevelAlert;
        mOriginalWindow.tag =100;
        
        mBackgroundView  = [[UIView alloc] initWithFrame:rect];
        mBackgroundView.alpha = 0.4;
        mBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
        mBackgroundView.backgroundColor = [UIColor blackColor];
        mBackgroundView.center = mOriginalWindow.center;
        self.center = mOriginalWindow.center;
        
        [mOriginalWindow addSubview:mBackgroundView];
        [mOriginalWindow addSubview:self];
        //[mOriginalWindow becomeKeyWindow];
        [mOriginalWindow makeKeyAndVisible];
//        [mOriginalWindow resignKeyWindow];
}

- (void)showWithName:(NSString*)name signature:(NSString*)sig praise:(NSString*)praise logo:(NSString*)logo{
    self.userNameLabel.text = name;
    self.userSignLabel.text = sig;
    //用户头像
    if([logo isEqualToString:@""]){
        self.userLogoImageView.image = [UIImage imageNamed:@"default_head"];
    }
    else{
//        NSInteger width = self.userLogoImageView.frame.size.width*SCALE;
//        NSInteger height = width;
//        NSString *logoUrl = [NSString stringWithFormat:URL_IMAGE,logo,width,height];
        [self.userLogoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString faceURLString:logo]] placeholderImage:[UIImage imageWithColor:RGB16(COLOR_FONT_WHITE) andSize:self.userLogoImageView.frame.size]];
    }
    self.userFansLabel.text = praise;
    CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH-60, size.height);
    self.center = mOriginalWindow.center;
    self.alpha=0;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha=1;
    } completion:^(BOOL finished) {
    }];
}
- (void)closeView:(id)sender {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha=0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [mBackgroundView removeFromSuperview];
        [[AppDelegate sharedAppDelegate] makeSelfVisible];
        mOriginalWindow = nil;
    }];
}
@end
