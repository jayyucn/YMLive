//
//  LCGameNiuniu.m
//  TaoHuaLive
//
//  Created by Jay on 2017/7/26.
//  Copyright © 2017年 上海七夕. All rights reserved.
//

#import "LCGameNiuniu.h"
#import "LCGameView.h"
#import "LCGameNiuniuModel.h"
#import <AVFoundation/AVFoundation.h>


@interface LCGameNiuniuPoker : UIView

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImage *colorImg;
@property (nonatomic, strong) UIImage *sizeImg;

@property (nonatomic, copy) void (^completionBlock)(NSInteger index);

@end

@implementation LCGameNiuniuPoker

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.frame];
        [self addSubview:self.imageView];
        
    }
    return self;
}

- (void)setSizeImg:(UIImage *)sizeImg
{
    _sizeImg = sizeImg;
    if (sizeImg) {
        
        UIImageView *imgV = [[UIImageView alloc] initWithImage:sizeImg];
        imgV.tag = 1001;
        imgV.frame = CGRectMake(3, 3, 8, 8);
        [self addSubview:imgV];
    }else {
        if ([self viewWithTag:1001]) {
            [[self viewWithTag:1001] removeFromSuperview];
        }
    }
}
- (void)setColorImg:(UIImage *)colorImg
{
    _colorImg = colorImg;
    if (colorImg) {
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:colorImg];
        imgView.tag = 1002;
        imgView.frame = CGRectMake(3, 15, 8, 8);
        [self addSubview:imgView];
    }else {
        if ([self viewWithTag:1002]) {
            [[self viewWithTag:1002] removeFromSuperview];
        }
    }
}

- (void)layoutSubviews
{
    self.imageView.frame = self.bounds;
    [self setNeedsDisplay];
}

@end


@interface LCGameNiuniu ()
{
    //    dispatch_source_t _timer;
    NSTimer *_timer;
}

@property (nonatomic, strong) UIView *firstPokerContainerView;
@property (nonatomic, strong) UIView *secondPokerContainerView;
@property (nonatomic, strong) UIView *thirdPokerContainerView;

@property (nonatomic, strong) UILabel *bet1Lb;
@property (nonatomic, strong) UILabel *bet2Lb;
@property (nonatomic, strong) UILabel *bet3Lb;

@property (nonatomic, strong) UILabel *myBet1Lb;
@property (nonatomic, strong) UILabel *myBet2Lb;
@property (nonatomic, strong) UILabel *myBet3Lb;

@property (nonatomic, strong) NSMutableArray *pokerViewArray;

@property (nonatomic, strong) UIView *clockView;
@property (nonatomic, strong) UIImageView *decimalDigitImgView;
@property (nonatomic, strong) UIImageView *unitDigitImgView;

@property (nonatomic, copy) void (^completionHandler)(NSInteger amount, NSInteger index);

@property (nonatomic, assign) NSInteger win; //赢家

//展示结果
@property (nonatomic, strong) UIImageView *firstShowResultBgView;
@property (nonatomic, strong) UIImageView *secondShowResultBgView;
@property (nonatomic, strong) UIImageView *thirdShowResultBgView;

@property (nonatomic, strong) UIImageView *firstShowResultView;
@property (nonatomic, strong) UIImageView *secondShowResultView;
@property (nonatomic, strong) UIImageView *thirdShowResultView;

@property (nonatomic, strong) UIView *firstMaskView;
@property (nonatomic, strong) UIView *secondMaskView;
@property (nonatomic, strong) UIView *thirdMaskView;

@property (nonatomic, strong) UIImageView *toastView;

@property (nonatomic, strong) AVAudioPlayer *player;

@end

static int deliverCount = 0;
CGFloat const kGameViewHeight = 204.0f;


@implementation LCGameNiuniu

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

- (instancetype)initWithFrame:(CGRect)frame isHost:(BOOL)isHost
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pokerViewArray = [[NSMutableArray alloc] initWithCapacity:15];
        [self setBackgroundColor:[UIColor colorWithRed:50.0/255 green:130.0/255 blue:130.0/255 alpha:1.0]]; //color should be modified
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:UIRectCornerAllCorners
                                                         cornerRadii:CGSizeMake(8, 8)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = self.bounds;
        maskLayer.path = path.CGPath;
        self.layer.mask = maskLayer;
        _isHost = isHost;
        _selectedSegmentIndex = 0;
        [super setNeedsDisplay];
        [self resetUI];
    }
    return self;
}

#pragma mark- initial stuffs
- (void)resetUI
{
    deliverCount = 0;
//    segment 1
    if (!self.firstPokerContainerView) {
        self.firstPokerContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/3, self.height)];
        UIImage *cowImage = [UIImage imageNamed:@"image/games/ic_bull_starblue"];
        UIImage *pokerBackImg = [UIImage imageNamed:@"image/games/poker_back_bull"];
        CGFloat imgHeight = pokerBackImg.size.height/2;
        CGFloat width  = self.firstPokerContainerView.width;
        UIView *pokerBGView = [[UIView alloc] initWithFrame:CGRectMake(8, 8, width-16, imgHeight)];
        pokerBGView.backgroundColor = [UIColor darkGrayColor];
        [self.firstPokerContainerView addSubview:pokerBGView];
        
        UIImageView *cowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(3, pokerBGView.bottom+8, cowImage.size.width*2/3, cowImage.size.height*2/3)];
        cowImgView.image = cowImage;
        [self.firstPokerContainerView addSubview:cowImgView];
        
        self.bet1Lb = [[UILabel alloc] initWithFrame:CGRectMake(cowImgView.right+8, cowImgView.centerY-11, 60, 21)];
        self.bet1Lb.textColor = [UIColor whiteColor];
        [self.firstPokerContainerView addSubview:self.bet1Lb];
        if (!_isHost) {
            self.myBet1Lb = [[UILabel alloc] initWithFrame:CGRectMake(cowImgView.right+8, _bet1Lb.bottom+8, 60, 21)];
            self.myBet1Lb.textColor = [UIColor whiteColor];
            [self.firstPokerContainerView addSubview:self.myBet1Lb];
        }
        
        [self addSubview:self.firstPokerContainerView];
        
        if (!self.isHost) {
            ESWeakSelf
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint locationInView) {
                [weak_self betActionAtIndex:0];
            }];
            [self.firstPokerContainerView addGestureRecognizer:tap];
        }
    }
//    segment 2
    if (!self.secondPokerContainerView) {
        self.secondPokerContainerView = [[UIView alloc] initWithFrame:CGRectMake(self.firstPokerContainerView.right, 0, ScreenWidth/3, self.height)];
        UIImage *pokerBackImg = [UIImage imageNamed:@"image/games/poker_back_bull"];
        
        CGFloat imgHeight = pokerBackImg.size.height/2;
        
        self.secondPokerContainerView.backgroundColor = [UIColor clearColor];
        CGFloat width  = self.secondPokerContainerView.width;
        UIView *pokerBGView = [[UIView alloc] initWithFrame:CGRectMake(8, 8, width-16, imgHeight)];
        pokerBGView.backgroundColor = [UIColor darkGrayColor];
        [self.secondPokerContainerView addSubview:pokerBGView];
        
        UIImage *cowImage = [UIImage imageNamed:@"image/games/ic_bull_starred"];
        UIImageView *cowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(3, pokerBGView.bottom+8, cowImage.size.width*2/3, cowImage.size.height*2/3)];
        cowImgView.image = cowImage;
        [self.secondPokerContainerView addSubview:cowImgView];
        
        self.bet2Lb = [[UILabel alloc] initWithFrame:CGRectMake(cowImgView.right+8, cowImgView.centerY-11, 60, 21)];
        self.bet2Lb.textColor = [UIColor whiteColor];
        [self.secondPokerContainerView addSubview:self.bet2Lb];
        
        if (!_isHost) {
            self.myBet2Lb = [[UILabel alloc] initWithFrame:CGRectMake(cowImgView.right+8, _bet2Lb.bottom+8, 60, 21)];
            self.myBet2Lb.textColor = [UIColor whiteColor];
            [self.secondPokerContainerView addSubview:self.myBet2Lb];
        }
        
        [self addSubview:self.secondPokerContainerView];
        
        if (!self.isHost) {
            ESWeakSelf
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint locationInView) {
                [weak_self betActionAtIndex:1];
            }];
            [self.secondPokerContainerView addGestureRecognizer:tap];
        }
    }
//    segment 3
    if (!self.thirdPokerContainerView) {
        self.thirdPokerContainerView = [[UIView alloc] initWithFrame:CGRectMake(self.secondPokerContainerView.right, 0, ScreenWidth/3, self.height)];
        UIImage *pokerBackImg = [UIImage imageNamed:@"image/games/poker_back_bull"];
        CGFloat imgheight = pokerBackImg.size.height/2;
        CGFloat width  = self.thirdPokerContainerView.width;
        
        UIView *pokerBGView = [[UIView alloc] initWithFrame:CGRectMake(8, 8, width-16, imgheight)];
        pokerBGView.backgroundColor = [UIColor darkGrayColor];
        [self.thirdPokerContainerView addSubview:pokerBGView];
        
        UIImage *cowImage = [UIImage imageNamed:@"image/games/ic_bull_staryellow"];
        //    CGFloat imgHeight = height/2;
        UIImageView *cowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(3, pokerBGView.bottom+8, cowImage.size.width*2/3, cowImage.size.height*2/3)];
        cowImgView.image = cowImage;
        [self.thirdPokerContainerView addSubview:cowImgView];
        
        self.bet3Lb = [[UILabel alloc] initWithFrame:CGRectMake(cowImgView.right+8, cowImgView.centerY-11, 60, 21)];
        self.bet3Lb.textColor = [UIColor whiteColor];
        [self.thirdPokerContainerView addSubview:self.bet3Lb];
        
        if (!_isHost) {
            self.myBet3Lb = [[UILabel alloc] initWithFrame:CGRectMake(cowImgView.right+8, _bet3Lb.bottom+8, 60, 21)];
            self.myBet3Lb.textColor = [UIColor whiteColor];
            [self.thirdPokerContainerView addSubview:self.myBet3Lb];
        }
        
        [self addSubview:self.thirdPokerContainerView];
        
        if (!self.isHost) {
            ESWeakSelf
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint locationInView) {
                [weak_self betActionAtIndex:2];
            }];
            [self.thirdPokerContainerView addGestureRecognizer:tap];
        }
    }
    
//    show pokers
    if (!self.pokerViewArray || self.pokerViewArray.count != 15) {
        self.pokerViewArray = [[NSMutableArray alloc] initWithCapacity:15];
        for (int i = 0; i < 15; i++) {
            UIImage *pokerBackImg = [UIImage imageNamed:@"image/games/poker_back_bull"];
            
            LCGameNiuniuPoker *poker = [[LCGameNiuniuPoker alloc] initWithFrame:CGRectMake(self.width/2, self.height/2, 0, 0)];
            [poker.imageView setImage:pokerBackImg];
            
            [self.pokerViewArray addObject:poker];
            
            [self addSubview:poker];
        }
    }else {
        for (int i = 0; i < 15; i++) {
            UIImage *pokerBackImg = [UIImage imageNamed:@"image/games/poker_back_bull"];
            
            LCGameNiuniuPoker *poker = (LCGameNiuniuPoker *)self.pokerViewArray[i];
            [poker.imageView setImage:pokerBackImg];
            [poker setSizeImg:nil];
            [poker setColorImg:nil];
            poker.frame = CGRectMake(self.width/2, self.height/2, 0, 0);

        }
    }
   
//    show clock view
    if (!self.clockView) {
        UIImage *clockImg = [UIImage imageNamed:@"image/games/ic_clock"];
        UIImage *decimalImg = [UIImage imageNamed:@"image/games/img_clock_3_red"];
        UIImage *unitImg = [UIImage imageNamed:@"image/games/img_clock_0_red"];
        CGFloat clockWidth = clockImg.size.width*2/3;
        CGFloat clockHeight = clockImg.size.height*2/3;
        self.clockView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2, self.height/2-30, 50, 50)];
        //    self.clockView.backgroundColor = [UIColor magentaColor];
        [self addSubview:self.clockView];
        UIImageView *clockImgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.clockView.width-clockWidth)/2, (self.clockView.height-clockHeight)/2, clockWidth, clockHeight)];
        [clockImgView setImage:clockImg];
        [self.clockView addSubview:clockImgView];
        CGFloat numWidth = decimalImg.size.width/2;
        CGFloat numHeight = decimalImg.size.height/2;
        CGFloat numLeading = (self.clockView.width-numWidth-12)/2;
        CGFloat numTop = (self.clockView.height - numHeight)/2;
        self.decimalDigitImgView = [[UIImageView alloc] initWithImage:decimalImg];
        self.decimalDigitImgView.frame = CGRectMake(numLeading, numTop, numWidth, numHeight);
        [self.clockView addSubview:self.decimalDigitImgView];
        self.unitDigitImgView = [[UIImageView alloc] initWithImage:unitImg];
        self.unitDigitImgView.frame = CGRectMake(numLeading+10, numTop, numWidth, numHeight);
        [self.clockView addSubview:self.unitDigitImgView];
    }
    self.clockView.hidden = YES;
    
//    show results
    
    UIImage *pokerBackImg = [UIImage imageNamed:@"image/games/poker_back_bull"];
    CGFloat pokerBackBottom = self.firstPokerContainerView.top+8+pokerBackImg.size.height/2;
    UIImage *showResultBGImg = [UIImage imageNamed:@"image/games/bg_poker_result_text"];
    UIImage *showResultImg = [UIImage imageNamed:@"image/games/text_bull_nn"];
    CGFloat bgWidth = showResultBGImg.size.width*2/3;
    CGFloat bgHeight = showResultBGImg.size.height*2/3;
    CGFloat reWidth = showResultImg.size.width*2/3;
    CGFloat reHeight = showResultImg.size.height*2/3;
    
    if (!self.firstShowResultBgView) {
        self.firstShowResultBgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.firstPokerContainerView.centerX-bgWidth/2, pokerBackBottom-bgHeight, bgWidth, bgHeight)];
        self.firstShowResultBgView.image = showResultBGImg;
        [self addSubview:self.firstShowResultBgView];
    }
    self.firstShowResultBgView.hidden = YES;
    
    if (!self.firstShowResultView) {
        self.firstShowResultView = [[UIImageView alloc] initWithFrame:CGRectMake(self.firstPokerContainerView.centerX-reWidth/2, self.firstShowResultBgView.top, reWidth, reHeight)];
        [self addSubview:self.firstShowResultView];
    }
    self.firstShowResultView.hidden = YES;
    
    if (!self.secondShowResultBgView) {
        self.secondShowResultBgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.secondPokerContainerView.centerX-bgWidth/2, pokerBackBottom-bgHeight, bgWidth, bgHeight)];
        self.secondShowResultBgView.image = showResultBGImg;
        [self addSubview:self.secondShowResultBgView];
    }
    self.secondShowResultBgView.hidden = YES;
    
    if (!self.secondShowResultView) {
        self.secondShowResultView = [[UIImageView alloc] initWithFrame:CGRectMake(self.secondPokerContainerView.centerX-reWidth/2, self.secondShowResultBgView.top, reWidth, reHeight)];
        [self addSubview:self.secondShowResultView];
    }
    self.secondShowResultView.hidden = YES;
    
    if (!self.thirdShowResultBgView) {
        self.thirdShowResultBgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.thirdPokerContainerView.centerX-bgWidth/2, pokerBackBottom-bgHeight, bgWidth, bgHeight)];
        self.thirdShowResultBgView.image = showResultBGImg;
        [self addSubview:self.thirdShowResultBgView];
    }
    self.thirdShowResultBgView.hidden = YES;
    
    if (!self.thirdShowResultView) {
        self.thirdShowResultView = [[UIImageView alloc] initWithFrame:CGRectMake(self.thirdPokerContainerView.centerX-reWidth/2, self.thirdShowResultBgView.top, reWidth, reHeight)];
        [self addSubview:self.thirdShowResultView];
    }
    self.thirdShowResultView.hidden = YES;
    
//    show mask views
    if (!self.firstMaskView) {
        self.firstMaskView = [[UIView alloc] initWithFrame:self.firstPokerContainerView.frame];
        self.firstMaskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4];
        [self addSubview:self.firstMaskView];
    }
    self.firstMaskView.hidden = YES;
    
    if (!self.secondMaskView) {
        self.secondMaskView = [[UIView alloc] initWithFrame:self.secondPokerContainerView.frame];
//        self.secondMaskView.backgroundColor = [UIColor colorWithRed:173.0/255 green:173.0/255 blue:173.0/255 alpha:0.7];
        self.secondMaskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4];
        [self addSubview:self.secondMaskView];
    }
    self.secondMaskView.hidden = YES;
    
    if (!self.thirdMaskView) {
        self.thirdMaskView = [[UIView alloc] initWithFrame:self.thirdPokerContainerView.frame];
        self.thirdMaskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4];
        [self addSubview:self.thirdMaskView];
    }
    self.thirdMaskView.hidden = YES;
    
//    比牌开始
    if (!self.toastView) {
        UIImage *toastImg = [UIImage imageNamed:@"image/games/toast_bpks"];
        CGFloat toastWidth = toastImg.size.width;
        CGFloat toastHeight = toastImg.size.height;
        self.toastView = [[UIImageView alloc] initWithImage:toastImg];
        self.toastView.frame = CGRectMake(self.centerX-toastWidth/2, self.centerY-toastHeight/2, toastWidth, toastHeight);
        [self addSubview:self.toastView];
    }
    self.toastView.hidden = YES;
    
    //gestures
    
    //bottom views
}

#pragma mark- start a game

- (void)startWithAnimation:(BOOL)animated
{

    NSLog(@"game started!");
//    self.completionHandler = completionHandler;
    if (animated) {
        
        // 取出资源的URL
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"poke_delivering.mp3" withExtension:nil];
        
        // 创建播放器
        NSError *error = nil;
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        
        
        // 准备播放
        [_player prepareToPlay];
        
        // 播放歌曲
        [self.player play];
        
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f/15 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self animationAtIndex:deliverCount];
            deliverCount++;
        }];
    }else {
        
        UIImage *pokerBackImg = [UIImage imageNamed:@"image/games/poker_back_bull"];
        CGFloat imgWidth = pokerBackImg.size.width/2;
        CGFloat imgHeight = pokerBackImg.size.height/2;
        CGFloat top = 8;
        CGFloat gap = (5 * imgWidth - (ScreenWidth / 3 -16)) / 5;
        for (int i = 0; i < self.pokerViewArray.count; i++) {
            LCGameNiuniuPoker *poker = (LCGameNiuniuPoker  *)self.pokerViewArray[i];
            CGFloat leading = ScreenWidth / 3 * (i / 5) + 8;
            CGRect rect = CGRectMake(leading+gap*(i%5), top, imgWidth, imgHeight);
            poker.frame = rect;
        }
    }
    
 
}

- (void)animationAtIndex:(NSInteger)index
{
    if (index >= 14) {
        [_timer invalidate];
//        self.completionHandler();
    }
    
    UIImage *pokerBackImg = [UIImage imageNamed:@"image/games/poker_back_bull"];
    CGFloat imgWidth = pokerBackImg.size.width/2;
    CGFloat imgHeight = pokerBackImg.size.height/2;
    CGFloat leading = ScreenWidth / 3 * (index / 5) + 8;
    CGFloat top = 8;
    CGFloat gap = (5 * imgWidth - (ScreenWidth / 3 -16)) / 5;
    LCGameNiuniuPoker *poker = nil;
    poker = (LCGameNiuniuPoker  *)self.pokerViewArray[index];

    CGRect rect = CGRectMake(leading+gap*(index%5), top, imgWidth, imgHeight);
    [UIView animateWithDuration:1.0f animations:^{
        poker.frame = rect;
    }];
}

- (void)timeoutCounting:(NSInteger)counting
{
//    [self resetUI];
    NSArray *numArray = @[
                          [UIImage imageNamed:@"image/games/img_clock_0_red"],
                          [UIImage imageNamed:@"image/games/img_clock_1_red"],
                          [UIImage imageNamed:@"image/games/img_clock_2_red"],
                          [UIImage imageNamed:@"image/games/img_clock_3_red"],
                          [UIImage imageNamed:@"image/games/img_clock_4_red"],
                          [UIImage imageNamed:@"image/games/img_clock_5_red"],
                          [UIImage imageNamed:@"image/games/img_clock_6_red"],
                          [UIImage imageNamed:@"image/games/img_clock_7_red"],
                          [UIImage imageNamed:@"image/games/img_clock_8_red"],
                          [UIImage imageNamed:@"image/games/img_clock_9_red"]
                          ];
    
    NSInteger unitDigit = counting % 10;
    NSInteger decimalDigit = counting / 10;
    [self.unitDigitImgView setImage:numArray[unitDigit]];
    [self.decimalDigitImgView setImage:numArray[decimalDigit]];
    
    self.clockView.hidden = NO;
    
    if (counting == 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.clockView.hidden = YES;
        });
    }
    
    [self.clockView setNeedsDisplay];
}

- (void)showBetActionWithArray:(NSArray *)array
{
    for (int i = 0; i < array.count; i++) {
        id obj = array[i];
        if ([obj isKindOfClass:[NSNumber class]]) {
            NSNumber *num = (NSNumber *)obj;
            int win = [num intValue];
            win = win?:0;
            if (0 == i) {
                self.bet1Lb.text = [NSString stringWithFormat:@"%d", win];
            }else if (1 == i) {
                self.bet2Lb.text = [NSString stringWithFormat:@"%d", win];
            }else if (2 == i) {
                self.bet3Lb.text = [NSString stringWithFormat:@"%d", win];
            }
        }
    }
}

- (void)showMyBetActionWithArray:(NSArray *)array
{
    for (int i = 0; i < array.count; i++) {
        id obj = array[i];
        if ([obj isKindOfClass:[NSNumber class]]) {
            NSNumber *num = (NSNumber *)obj;
            int win = [num intValue];
            win = win?:0;
            if (0 == i) {
                self.myBet1Lb.text = [NSString stringWithFormat:@"%d", win];
            }else if (1 == i) {
                self.myBet2Lb.text = [NSString stringWithFormat:@"%d", win];
            }else if (2 == i) {
                self.myBet3Lb.text = [NSString stringWithFormat:@"%d", win];
            }
        }
    }
}

#pragma mark- show results
- (void)showResultWithDict:(NSDictionary *)dict
{
    self.toastView.hidden = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.toastView.hidden = YES;
    });
    self.win = [[dict objectForKey:@"win"] integerValue];
    NSArray *detail = [dict objectForKey:@"detail"];
    NSMutableArray *pokers = [[NSMutableArray alloc] initWithCapacity:15];
    for (int i = 0; i < detail.count; i++) {
        id subDetail = detail[i];
        if ([subDetail isKindOfClass:[NSDictionary class]]) {
            NSDictionary *subDetailDict = (NSDictionary *)subDetail;
            if ([[subDetailDict objectForKey:@"cards"] isKindOfClass:[NSArray class]]) {
                NSArray *cards = [subDetailDict objectForKey:@"cards"];
                [pokers addObjectsFromArray:cards];
            }
            NSInteger result = [[subDetailDict objectForKey:@"result"] integerValue];
            [self showPokerResult:result atIndex:i];
        }
    }
    
    [self showPokersWithPokersArray:pokers];
}

- (void)showMaskView
{
    NSArray *maskArray = @[self.firstMaskView, self.secondMaskView, self.thirdMaskView];
    for (int i = 0; i  <maskArray.count; i++) {
        UIView *maskView = maskArray[i];
        if (i == self.win) {
            maskView.hidden = YES;
        }else {
            maskView.hidden = NO;
        }
    }
    //游戏结束通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kGameResultDidShowNotification object:nil];
}

/**
 牛值

 @param result 牛几
 */
- (void)showPokerResult:(NSInteger)result atIndex:(NSInteger)index
{
    if (index > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showResult:result atIndex:index];
        });
    }else {
        [self showResult:result atIndex:index];
    }
    [self showMaskView];
}
- (void)showResult:(NSInteger)result atIndex:(NSInteger)index
{
    UIImageView *resultView = nil;
    if (index == 0) {
        resultView = self.firstShowResultView;
        self.firstShowResultView.hidden = NO;
        self.firstShowResultBgView.hidden = NO;
    }else if (index == 1) {
        resultView = self.secondShowResultView;
        self.secondShowResultView.hidden = NO;
        self.secondShowResultBgView.hidden = NO;
    }else {
        resultView = self.thirdShowResultView;
        self.thirdShowResultView.hidden = NO;
        self.thirdShowResultBgView.hidden = NO;
    }
    switch (result) {
        case 0:
        {
            // 没牛
            [resultView setImage:[UIImage imageNamed:@"image/games/text_bull_mn"]];
        }
            break;
        case 1:
        {
            // 牛一
            [resultView setImage:[UIImage imageNamed:@"image/games/text_bull_n1"]];
        }
            break;
        case 2:
        {
            // 牛二
            [resultView setImage:[UIImage imageNamed:@"image/games/text_bull_n2"]];
        }
            break;
        case 3:
        {
            // 牛三
            [resultView setImage:[UIImage imageNamed:@"image/games/text_bull_n3"]];
        }
            break;
        case 4:
        {
            // 牛四
            [resultView setImage:[UIImage imageNamed:@"image/games/text_bull_n4"]];
        }
            break;
        case 5:
        {
            // 牛五
            [resultView setImage:[UIImage imageNamed:@"image/games/text_bull_n5"]];
        }
            break;
        case 6:
        {
            // 牛六
            [resultView setImage:[UIImage imageNamed:@"image/games/text_bull_n6"]];
        }
            break;
        case 7:
        {
            // 牛七
            [resultView setImage:[UIImage imageNamed:@"image/games/text_bull_n7"]];
        }
            break;
        case 8:
        {
            // 牛八
            [resultView setImage:[UIImage imageNamed:@"image/games/text_bull_n8"]];
        }
            break;
        case 9:
        {
            // 牛九
            [resultView setImage:[UIImage imageNamed:@"image/games/text_bull_n9"]];
        }
            break;
        case 10:
        {
            // 牛牛
            [resultView setImage:[UIImage imageNamed:@"image/games/text_bull_nn"]];
        }
            break;
            
        default:
            break;
    }
}

/**
 翻牌
 @param pokers  poker value
 */
- (void)showPokersWithPokersArray:(NSMutableArray *)pokers
{
    NSMutableArray *imgViewArray = [[NSMutableArray alloc] initWithCapacity:15];
    imgViewArray = self.pokerViewArray;
//    [imgViewArray addObjectsFromArray:self.firstPokerViewArray];
//    [imgViewArray addObjectsFromArray:self.secondPokerViewArray];
//    [imgViewArray addObjectsFromArray:self.thirdPokerViewArray];
    for (int i = 0; i < pokers.count; i++) {
        LCGameNiuniuPoker *poker = imgViewArray[i];
        [self showPokerImage:poker withString:pokers[i]];
    }
}

- (void)showPokerImage:(LCGameNiuniuPoker *)poker withString:(NSString *)code
{
    
    NSString *color = [code substringToIndex:1];
    NSString *size = [code substringFromIndex:1];
    UIImage *colorImg = nil;
    if ([color isEqualToString:@"A"]) {
        colorImg = [UIImage imageNamed:@"image/games/poker_spade"];
    }else if ([color isEqualToString:@"B"]) {
        colorImg = [UIImage imageNamed:@"image/games/poker_heart"];
    }else if ([color isEqualToString:@"C"]) {
        colorImg = [UIImage imageNamed:@"image/games/poker_diamond"];
    }else if ([color isEqualToString:@"D"]) {
        colorImg = [UIImage imageNamed:@"image/games/poker_club"];
    }
    BOOL isBlack = ([color isEqualToString:@"A"] || [color isEqualToString:@"D"]) ? YES : NO;
    NSString *imgStr = nil;
    if ([size isEqualToString:@"14"]) {
        imgStr = isBlack?@"img_poker_ace_black":@"img_poker_ace_red";
    }else if ([size isEqualToString:@"13"]) {
        imgStr = isBlack?@"img_poker_king_black":@"img_poker_king_red";
    }else if ([size isEqualToString:@"12"]) {
        imgStr = isBlack?@"img_poker_queen_black":@"img_poker_queen_red";
    }else if ([size isEqualToString:@"11"]) {
        imgStr = isBlack?@"img_poker_jack_black":@"img_poker_jack_red";
    }else if ([size isEqualToString:@"10"]) {
        imgStr = isBlack?@"img_poker_10_black":@"img_poker_10_red";
    }else if ([size isEqualToString:@"9"]) {
        imgStr = isBlack?@"img_poker_9_black":@"img_poker_9_red";
    }else if ([size isEqualToString:@"8"]) {
        imgStr = isBlack?@"img_poker_8_black":@"img_poker_8_red";
    }else if ([size isEqualToString:@"7"]) {
        imgStr = isBlack?@"img_poker_7_black":@"img_poker_7_red";
    }else if ([size isEqualToString:@"6"]) {
        imgStr = isBlack?@"img_poker_6_black":@"img_poker_6_red";
    }else if ([size isEqualToString:@"5"]) {
        imgStr = isBlack?@"img_poker_5_black":@"img_poker_5_red";
    }else if ([size isEqualToString:@"4"]) {
        imgStr = isBlack?@"img_poker_4_black":@"img_poker_4_red";
    }else if ([size isEqualToString:@"3"]) {
        imgStr = isBlack?@"img_poker_3_black":@"img_poker_3_red";
    }else if ([size isEqualToString:@"2"]) {
        imgStr = isBlack?@"img_poker_2_black":@"img_poker_2_red";
    }
    UIImage *sizeImg = [UIImage imageNamed:[NSString stringWithFormat:@"image/games/%@", imgStr]];
    
    poker.sizeImg = sizeImg;
    poker.colorImg = colorImg;
    [poker.imageView setImage:[UIImage imageNamed:@"image/games/poker_background"]];
}

#pragma mark- 下注
- (void)betActionAtIndex:(NSInteger)index
{
    NSInteger bet = 0;
    switch (self.selectedSegmentIndex) {
        case 0:
            bet = 50;
            break;
        case 1:
            bet = 100;
            break;
        case 2:
            bet = 500;
            break;
        default:
            break;
    }
    self.completionHandler(bet, index);
}

- (void)betActionWithCompletionHandler:(void (^)(NSInteger, NSInteger))completionHandler
{
    self.completionHandler = completionHandler;
}

@end
