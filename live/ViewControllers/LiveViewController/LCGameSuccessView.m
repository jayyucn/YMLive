//
//  LCGameSuccessView.m
//  TaoHuaLive
//
//  Created by Jay on 2017/8/2.
//  Copyright © 2017年 上海七夕. All rights reserved.
//

#import "LCGameSuccessView.h"

@interface LCGameSuccessView ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *diamondLb;

@end

@implementation LCGameSuccessView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_BG_CLEAR;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    UIImage *topImage = [UIImage imageNamed:@"image/games/winner"];
    CGFloat topWidth = topImage.size.width;
    CGFloat topHeight = topImage.size.height;
    UIImageView *topImageView = [[UIImageView alloc] initWithImage:topImage];
    topImageView.frame = CGRectMake(0, 0, self.width, self.width*topHeight/topWidth);
    [self addSubview:topImageView];
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(20, topImageView.bottom, self.width-40, self.height-topImageView.bottom)];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.containerView];
   
    UIImage *diamondImage = [UIImage imageNamed:@"diamond"];
    CGFloat diamondWidth = 36;
    CGFloat diamondHeight = 36;
    UIImageView *diamondImageView = [[UIImageView alloc] initWithImage:diamondImage];
    diamondImageView.frame = CGRectMake(self.containerView.centerX-diamondWidth/2, 8, diamondWidth, diamondHeight);
    [self.containerView addSubview:diamondImageView];
    
    UILabel *textLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, diamondImageView.left-8, 30)];
    textLb.text = ESLocalizedString(@"获得");
    textLb.textAlignment = NSTextAlignmentRight;
    textLb.font = [UIFont systemFontOfSize:22];
    [self.containerView addSubview:textLb];
    
    self.diamondLb = [[UILabel alloc] initWithFrame:CGRectMake(diamondImageView.right+8, 8, self.containerView.width-diamondImageView.right, 30)];
    self.diamondLb.text = @"150";
    textLb.font = [UIFont systemFontOfSize:22];
    [self.containerView addSubview:self.diamondLb];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(0, self.containerView.height-30, self.containerView.width, 30);
    closeBtn.backgroundColor = ColorPink;
    [closeBtn setTitle:@"确定" forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:closeBtn];
}

- (void)closeButtonAction:(UIButton *)sender{
    
    if (self.closeBlock) self.closeBlock();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
