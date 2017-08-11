//
//  RePaintView.m
//  HuoWuLive
//
//  Created by 林伟池 on 16/11/18.
//  Copyright © 2016年 上海七夕. All rights reserved.
//

#import "AnimationPaintView.h"
#import "DrawGiftView.h"
#import "LuxuryManager.h"

@implementation AnimationPaintView
{
    UIView *mCanvasView;
    NSMutableArray *mRePaintArray;
    NSTimer *mTimer;
    int mPointType;
    float square_size;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self customInit];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self customInit];
    return self;
}

- (void)dealloc {
    NSLog(@"dealloc");
}


- (void)setMNickName:(NSString *)mNickName {
    UILabel* nameLabel = [[UILabel alloc] init];
    nameLabel.text = mNickName;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.shadowColor = [UIColor yellowColor];
    [nameLabel sizeToFit];
    nameLabel.center = CGPointMake(self.width / 2, -20);
    [self addSubview:nameLabel];
}


- (void)customInit {
    self.backgroundColor = [UIColor clearColor];
    mCanvasView = [[UIView alloc] initWithFrame:self.bounds];
    mCanvasView.backgroundColor = [UIColor clearColor];
    [self addSubview:mCanvasView];
}

- (void)setMDataDict:(NSDictionary *)mDataDict {
    _mDataDict = mDataDict;
    [self startRepaint];
}

- (void)startRepaint {
    mRePaintArray = [NSMutableArray arrayWithArray:_mDataDict[@"point_data"]];
    square_size = [_mDataDict[@"square_size"] floatValue];
    mPointType = [_mDataDict[@"point_type"] intValue];
    
    mTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 userInfo:nil repeats:YES block:^(NSTimer *timer) {
        UIImageView *imageView = [self getOnePoint];
        if (imageView) {
            [mCanvasView addSubview:imageView];
        }
        else {
            [mTimer invalidate];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:1.0 animations:^{
                    self.alpha = 0;
                } completion:^(BOOL finished) {
                    [self removeFromSuperview];
                    [self callBackManager];
                }];
                
            });
        }
    }];
}


- (UIImageView *)getOnePoint {
    UIImageView *ret;
    if (mRePaintArray.count > 0) {
        NSDictionary *dict = [mRePaintArray firstObject];
        float x = [dict[@"x"] floatValue];
        float y = [dict[@"y"] floatValue];
        [mRePaintArray removeObjectAtIndex:0];
        
        x = x / square_size * mCanvasView.width;
        y = y / square_size * mCanvasView.height;
        
        ret=  [[UIImageView alloc] initWithFrame:CGRectMake(x, y, POINT_SIZE_WIDTH, POINT_SIZE_HEIGHT)];
        ret.image = [UIImage imageNamed:[NSString stringWithFormat:@"image/liveroom/draw_gift_item%d", mPointType]];
    }
    return ret;
}



- (void)callBackManager {
    [LuxuryManager luxuryManager].isShowAnimation = NO;
    [[LuxuryManager luxuryManager] showLuxuryAnimation];
}


@end
