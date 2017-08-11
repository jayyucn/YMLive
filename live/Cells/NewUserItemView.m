//
//  NewUserItemView.m
//  qianchuo
//
//  Created by jacklong on 16/4/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "NewUserItemView.h"
#define IntervalPixel 4

#define HEAD_WIDHT (ScreenWidth-IntervalPixel*4)/3

#define  CellAutoresizingMask   UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin

@implementation NewUserItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, HEAD_WIDHT,HEAD_WIDHT)];
        _portraitView.image=[UIImage imageNamed:@"default_head"];
        _portraitView.autoresizingMask = CellAutoresizingMask;
        [self addSubview:_portraitView];
        
        self.userInteractionEnabled=YES;
        
        UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(singleTap)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [self addGestureRecognizer:singleRecognizer];
    }
    return self;
}

// 单击事件
- (void) singleTap
{
    if (_itemBlock) {
        _itemBlock(_userInfoDict);
    }
}


- (void) setUserInfoDict:(NSDictionary *)userInfoDict
{
    _userInfoDict = userInfoDict;
    NSLog(@"authorItemDicauthorItemDic=%@",userInfoDict);
    
    
    NSString *face = (NSString *)userInfoDict[@"face"];
    if (face && face.length > 0) {
        ESWeakSelf;
        
        NSURL *url = [NSURL URLWithString:[NSString faceURLString:userInfoDict[@"face"]]];
        if ([[SDWebImageManager sharedManager] cachedImageExistsForURL:url]) {
            [_portraitView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_head"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                ESStrongSelf;
                [_self showCellAnim:image animation:NO];
            }];
        }
        else {
            [_portraitView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_head"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                ESStrongSelf;
                [_self showCellAnim:image animation:YES];
            }];
        }
    }
    else {
        [self showCellAnim:[UIImage imageNamed:@"default_head"] animation:NO];
    }
}

- (void) showCellAnim:(UIImage *)image animation:(BOOL)animation
{
    if (animation) {
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        
        scaleAnimation.fromValue = @.5;
        scaleAnimation.toValue = @1;
        scaleAnimation.duration = 0.4;
        
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [_portraitView.layer addAnimation:scaleAnimation forKey:@"buttonAnimation"];
        _portraitView.image = image;
    }
    else {
        _portraitView.image = image;
    }
}
@end
