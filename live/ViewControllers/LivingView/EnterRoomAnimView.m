//
//  EnterRoomAnimView.m
//  qianchuo 进房特效
//
//  Created by jacklong on 16/7/9.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "EnterRoomAnimView.h"
#import <CoreText/CoreText.h>

@interface EnterRoomAnimView()
{
    NSMutableArray *labels;
    NSMutableArray *numArr;
    NSMutableArray *dataArr;
    
    UIView *vi;
}

@end

@implementation EnterRoomAnimView

- (void)dealloc
{
    NSLog(@"dealloc %@",NSStringFromClass(self.class));
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}


- (void) showEnterRoomView
{
    if (vi) {
        return;
    }
    
    if (!_enterInfoArray || _enterInfoArray.isEmpty) {
        return;
    }
    
    NSDictionary *enterRoomDict = [_enterInfoArray firstObject];
    [_enterInfoArray removeObject:enterRoomDict];
    
    UIImage *bgImage = nil;
    
    UIImage *starImage = nil;
    
    if ([enterRoomDict[@"grade"] intValue] >= LIVE_USER_GRADE * 7) {
        bgImage = [UIImage imageNamed:@"image/liveroom/room_enter_6"];
//        starImage  = [UIImage imageNamed:@"image/liveroom/room_enter_xing"];
    } else if ([enterRoomDict[@"grade"] intValue] >= LIVE_USER_GRADE * 6) {
        bgImage = [UIImage imageNamed:@"image/liveroom/room_enter_5"];
//        starImage  = [UIImage imageNamed:@"image/liveroom/room_enter_xing"];
    } else if ([enterRoomDict[@"grade"] intValue] >= LIVE_USER_GRADE * 5) {
        bgImage = [UIImage imageNamed:@"image/liveroom/room_enter_4"];
//        starImage  = [UIImage imageNamed:@"image/liveroom/room_enter_xing"];
    } else if ([enterRoomDict[@"grade"] intValue] >= LIVE_USER_GRADE * 4) {
        bgImage = [UIImage imageNamed:@"image/liveroom/room_enter_3"];
    } else if ([enterRoomDict[@"grade"] intValue] >= LIVE_USER_GRADE * 3) {
        bgImage = [UIImage imageNamed:@"image/liveroom/room_enter_2"];
    } else if ([enterRoomDict[@"grade"] intValue] >= LIVE_USER_GRADE * 2){
        bgImage = [UIImage imageNamed:@"image/liveroom/room_enter_1"];
    }
    
    NSLog(@"bgimage size:%@",NSStringFromCGSize(bgImage.size));
    vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    vi.left = SCREEN_WIDTH;
    [self addSubview:vi];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    bgImageView.image = bgImage;
    [vi addSubview:bgImageView];
    
    
    if (starImage) {
        
        UIImageView *starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, bgImageView.height  - 35, starImage.size.width, starImage.size.height)];
        starImageView.image = starImage;
        [bgImageView addSubview:starImageView];
        
        UIImageView *starImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(38, bgImageView.height  - 28, starImage.size.width/2, starImage.size.height/2)];
        starImageView2.image = starImage;
        [bgImageView addSubview:starImageView2];
        
        UIImageView *starImageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(45, bgImageView.height  - 25, starImage.size.width, starImage.size.height)];
        starImageView3.image = starImage;
        [bgImageView addSubview:starImageView3];
        
        [self zoomView:starImageView withScale:(float)(arc4random() % 2 + 1)/2];
        [self zoomView:starImageView2 withScale:(float)(arc4random() % 2 + 1)/2];
        [self zoomView:starImageView3 withScale:(float)(arc4random() % 2 + 1)/2];
        
        UIImageView *starImageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(bgImageView.width - 53, bgImageView.height  - 30, starImage.size.width, starImage.size.height)];
        starImageView4.image = starImage;
        [bgImageView addSubview:starImageView4];
        
        UIImageView *starImageView5 = [[UIImageView alloc] initWithFrame:CGRectMake(bgImageView.width - 50, bgImageView.height  - 22, starImage.size.width/2, starImage.size.height/2)];
        starImageView5.image = starImage;
        [bgImageView addSubview:starImageView5];
        
        UIImageView *starImageView6 = [[UIImageView alloc] initWithFrame:CGRectMake(bgImageView.width - 58, bgImageView.height  - 20, starImage.size.width, starImage.size.height)];
        starImageView6.image = starImage;
        [bgImageView addSubview:starImageView6];
        
        [self zoomView:starImageView withScale:(float)(arc4random() % 2 + 1)/2];
        [self zoomView:starImageView2 withScale:(float)(arc4random() % 2 + 1)/2];
        [self zoomView:starImageView3 withScale:(float)(arc4random() % 2 + 1)/2];
        [self zoomView:starImageView4 withScale:(float)(arc4random() % 2 + 1)/2];
        [self zoomView:starImageView5 withScale:(float)(arc4random() % 2 + 1)/2];
        [self zoomView:starImageView6 withScale:(float)(arc4random() % 2 + 1)/2];
        
    }
    
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = CGRectMake(20,bgImage.size.height - 20, vi.frame.size.width- 40,35);
    
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    [vi.layer addSublayer:textLayer];
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.wrapped = YES;
    
    
    UIFont *font = [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:12];
    
    NSString *nickNameStr = enterRoomDict[@"nickname"];
    if (nickNameStr) {
        if (nickNameStr.length > 12) {
            nickNameStr = [nickNameStr substringToIndex:12];
        }
    }
    NSString *str = [NSString stringWithFormat:@"%@ 进入直播间",nickNameStr];
    
    NSMutableAttributedString *string = nil;
    string = [[NSMutableAttributedString alloc] initWithString:str];
    CFStringRef fontName = (__bridge CFStringRef)(font.fontName);
    CGFloat fontSize = font.pointSize;
    CTFontRef fontRef = CTFontCreateWithName(fontName, fontSize, NULL);
    NSDictionary *attribs = @{
                              (__bridge id)kCTForegroundColorAttributeName:(__bridge id)[UIColor clearColor].CGColor,
                              (__bridge id)kCTFontAttributeName:(__bridge id)fontRef
                              };
    [string setAttributes:attribs range:NSMakeRange(0, str.length)];
    
    dataArr = [NSMutableArray arrayWithObjects:(__bridge id _Nonnull)(fontRef),attribs,string,str,textLayer, nil];
    numArr = [NSMutableArray array];
    
    [UIView animateWithDuration:.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         vi.centerX = SCREEN_WIDTH/2;
                     } completion:^(BOOL finished) {
                         for (int i = 0; i < str.length; i++) {
                             [numArr addObject:[NSNumber numberWithInt:i]];
                             [self performSelector:@selector(changeToBlack) withObject:nil afterDelay:.05 * i];
                         }
                         CFRelease(fontRef);
                     }];
}

- (void) zoomView:(UIView *)zoomView withScale:(float)scale{
    if (!vi) {
        return;
    }
    
    zoomView.transform = CGAffineTransformMakeScale(scale,scale);
    [UIView animateWithDuration:.3
                     animations:^{
                         zoomView.transform = CGAffineTransformMakeScale(scale + 1, scale+1);
                     }completion:^(BOOL finish){
                         [UIView animateWithDuration:.2
                                          animations:^{
                                              zoomView.transform = CGAffineTransformMakeScale(scale , scale);
                                          }completion:^(BOOL finish){
                                              [UIView animateWithDuration:.3
                                                               animations:^{
                                                                   zoomView.transform = CGAffineTransformMakeScale(1, 1);
                                                               }completion:^(BOOL finish){
                                                                   [self zoomView:zoomView withScale:(float)(arc4random() % 2 + 1)/2];
                                                               }];
                                          }];
                     }];
}


- (void)changeToBlack {
    CTFontRef fontRef = (__bridge CTFontRef)(dataArr[0]);
    NSMutableAttributedString *string = dataArr[2];
    NSNumber *num = [numArr firstObject];
    int y = [num intValue];
    NSDictionary *attribs = dataArr[1];
    attribs = @{
                (__bridge id)kCTForegroundColorAttributeName:(__bridge id)[UIColor yellowColor].CGColor,
                (__bridge id)kCTFontAttributeName:(__bridge id)fontRef
                };
    [string setAttributes:attribs range:NSMakeRange(y, 1)];
    if (numArr.count > 1) {
        [numArr removeObjectAtIndex:0];
    } else {
        [UIView animateWithDuration:.5f delay:3.0f options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             vi.right = 0;
                         } completion:^(BOOL finished) {
                             [vi removeFromSuperview];
                             vi = nil;
                             
                             dataArr = nil;
                             numArr = nil;
                             [self showEnterRoomView];
                         }];
    }
    CATextLayer *textLayer = [dataArr lastObject];
    if (textLayer) {
        textLayer.string = string;
    }
}


@end
