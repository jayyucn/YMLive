//
//  CarPorscheFirstView.m
//  auvlive
//
//  Created by jacklong on 16/4/2.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "CarPorscheTopMoveView.h"
#import "CarMoveBottomMoveToTopView.h"
#import "AirPlaneMoveWindow.h"
#import "LuxuryManager.h"


#define SPEED_WHEEL_SLOW .04
#define SPEED_WHEEL_MIDDLE .03
#define SPEED_WHEEL_QUICKY .01

@interface CarPorscheTopMoveView()
{
    float angleBefore;
    float angleAfter;
    float wheelSpeed;
    BOOL isStopRightToLeft;
    
    UIImageView *carImgView;
    UIImageView *leftLightImgView;
    UIImageView *rightLightImageView;
    UIImageView *beforeWheelImgView;
    UIImageView *afterWheelImgView;
    
    UIImageView *exhaustImgView;
}

@end

@implementation CarPorscheTopMoveView

static CarPorscheTopMoveView *alertCarView = nil;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) { 
        
        [self initRightToLeftView];
        
        [self showWithAnimated];
        
        self.userInteractionEnabled = NO;
    }
    return self;
}


- (void) initRightToLeftView
{
    isStopRightToLeft = YES;
    
    UIImage *carImg = [UIImage imageNamed:@"image/liveroom/car_2-2"];
    
    carImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, carImg.size.width*3/5
                                                               , carImg.size.height*3/5)];
    carImgView.image = carImg;
    [self addSubview:carImgView];
    
    carImgView.left = SCREEN_WIDTH;
    carImgView.top = 0;
    
    UIImage *wheelImg = [UIImage imageNamed:@"image/liveroom/car_wheel"];
    beforeWheelImgView = [[UIImageView alloc] initWithFrame:CGRectMake(carImgView.width/3+3, carImgView.height - wheelImg.size.width/12-23, wheelImg.size.width/12+5, wheelImg.size.height/12+5)];
    beforeWheelImgView.image = wheelImg;
    [carImgView addSubview:beforeWheelImgView];
    
    afterWheelImgView = [[UIImageView alloc] initWithFrame:CGRectMake(carImgView.width-wheelImg.size.width/12-13, beforeWheelImgView.top-wheelImg.size.width/12+8, wheelImg.size.width/12+2, wheelImg.size.height/12+2)];
    afterWheelImgView.image = wheelImg;
    [carImgView addSubview:afterWheelImgView];
 
    
    UIImage *leftLightImg = [UIImage imageNamed:@"image/liveroom/Redocn_light2"];
    
    leftLightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(-leftLightImg.size.width/6, 38, leftLightImg.size.width/2, leftLightImg.size.height/2)];
    leftLightImgView.image = leftLightImg;
    [carImgView addSubview:leftLightImgView];
    leftLightImgView.hidden = YES;
    
    
    UIImage *rightLightImg = [UIImage imageNamed:@"image/liveroom/Redocn_light1"];
    
    rightLightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-rightLightImg.size.height/4, 10, rightLightImg.size.width/2, rightLightImg.size.height/2)];
    rightLightImageView.image = rightLightImg;
    [carImgView addSubview:rightLightImageView];
    rightLightImageView.hidden = YES;
    
    wheelSpeed = SPEED_WHEEL_MIDDLE;
}


#pragma mark === 闪烁的动画 ======
-(void)opacityAnimation:(float)time withView:(UIImageView *)imgView withAnimaitonName:(NSString *)name
{
    imgView.hidden = NO;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = 1;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    
    animation.duration = .5;
    animation.removedOnCompletion = YES;
    animation.delegate = self;
    
    [animation setValue:name forKey:@"animationName"];
    [imgView.layer addAnimation:animation forKey:@"animationName"];
}

- (void)setMNickName:(NSString *)mNickName {
    UILabel* nameLabel = [[UILabel alloc] init];
    nameLabel.text = mNickName;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.shadowColor = [UIColor yellowColor];
    [nameLabel sizeToFit];
    nameLabel.center = CGPointMake(carImgView.width / 2, -10);
    [carImgView addSubview:nameLabel];
}

- (void) showCarAnimation
{
    wheelSpeed = SPEED_WHEEL_SLOW;
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (int i=5; i>=1; i--) {
        [arrayM addObject:[UIImage imageNamed:[NSString stringWithFormat:@"image/liveroom/car_%d-%d",i,i]]];
    }
    
    // 1. 设置图片的数组
    [carImgView setAnimationImages:arrayM];
    
    // 2. 设置动画时长，默认每秒播放5张图片
    [carImgView setAnimationDuration:.9];
    
    // 3. 设置动画重复次数，默认为0，无限循环
    [carImgView setAnimationRepeatCount:1];
    
    // 4. 开始动画
    [carImgView startAnimating];
    
    //    // 5. 动画播放完成后，清空动画数组
    ESWeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(carImgView.animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ESStrongSelf;
        [_self opacityAnimation:.5 withView:leftLightImgView withAnimaitonName:@"left_light"];
        [_self opacityAnimation:.5 withView:rightLightImageView withAnimaitonName:@"right_light"];
    });
    //    [self performSelector:@selector(openFlowerAnimaiton:) withObject:nil afterDelay:fireFlowerImgView.animationDuration];
}


- (void) startBeforeWheelAnimation
{
    if (isStopRightToLeft) {
        return;
    }
    
    if (!beforeWheelImgView)
    {
        return;
    }
    
    [UIView animateWithDuration:wheelSpeed delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CALayer *layer = beforeWheelImgView.layer;
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / -500;
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, M_PI/18, 1, 0,0);
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -(M_PI/5-M_PI/35), 0, 1,0);
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform,-angleBefore * M_PI / 180.0f, 0,0,1);
        layer.transform = rotationAndPerspectiveTransform;
    } completion:^(BOOL finished) {
        angleBefore += 15;
        
        [self startBeforeWheelAnimation];
    }];
}

- (void) startAfterWheelAnimation
{
    if (isStopRightToLeft) {
        return;
    }
    
    if (!afterWheelImgView)
    {
        return;
    }
    
    [UIView animateWithDuration:wheelSpeed delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CALayer *layer = afterWheelImgView.layer;
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / -500;
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, M_PI/20, 1, 0,0);
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -(M_PI/6+M_PI/30), 0, 1,0);
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform,-angleAfter * M_PI / 180.0f, 0,0,1);
        layer.transform = rotationAndPerspectiveTransform;
    } completion:^(BOOL finished) {
        angleAfter += 15;
        
        [self startAfterWheelAnimation];
    }];
}

- (void)dealloc
{
    NSLog(@"dealloc %@",NSStringFromClass(self.class));
}


#pragma mark 屏幕点击
- (void) singleTap
{
    [UIView animateWithDuration:.3 animations:^{
        self.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        isStopRightToLeft = YES;
    }];
}

#pragma mark - 点击范围
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (gestureRecognizer.view == self) {
        if (!self.hidden) {
            CGPoint point = [touch locationInView:carImgView];
            if (point.x > 0 && point.x < carImgView.frame.size.width
                && point.y > 0 && point.y < carImgView.frame.size.height ) {
                return NO;
            }
        }
    }
    return YES;
}


- (void) showWithAnimated
{    
    self.hidden = NO;
    angleBefore = 0;
    angleAfter = 0;
    isStopRightToLeft = NO;
    [self startBeforeWheelAnimation];
    [self startAfterWheelAnimation];
    carImgView.left = SCREEN_WIDTH;
    carImgView.top = 30;
//    carImgView.centerX = SCREEN_WIDTH/2;
//    carImgView.centerY = SCREEN_HEIGHT/2;
    [UIView animateWithDuration:.3 animations:^{
        self.top = 0;
    } completion:^(BOOL finished) {
        [self showStartMoveRightMoveToLeft];
    }];
}


-(BOOL)isShow
{
    if (!self.hidden)
    {
        return YES;
    }
    return NO;
}



- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
     {
        NSString *animationName = [anim valueForKey:@"animationName"];
        if ([animationName isEqualToString:@"left_light"])
        {
            leftLightImgView.hidden = YES;
            rightLightImageView.hidden = YES;
            wheelSpeed = SPEED_WHEEL_QUICKY;
            [self showSecondMoveAnimation];
        } else if ([animationName isEqualToString:@"left_light_1"]) {
            leftLightImgView.hidden = YES;
            rightLightImageView.hidden = YES;
            [self showFirstMoveAnimation];
        }
    }
}


#pragma mark - 显示车的动画
- (void) showStartMoveRightMoveToLeft
{
//    isStopRightToLeft = NO;
//    [self startBeforeWheelAnimation];
//    [self startAfterWheelAnimation];
    int x = arc4random() % 5+1;
    
    UIImage *carImg = [UIImage imageNamed:[NSString stringWithFormat:@"image/liveroom/car_%d-%d",x,x]];
    carImgView.image = carImg;
    [UIView animateWithDuration:.8 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        carImgView.left =  SCREEN_WIDTH - carImgView.width/3;
        carImgView.top = carImgView.width/3;
    } completion:^(BOOL finished) {
        [self opacityAnimation:.5 withView:leftLightImgView withAnimaitonName:@"left_light_1"];
        [self opacityAnimation:.5 withView:rightLightImageView withAnimaitonName:@"right_light_1"];
    }];
}


- (void) showFirstMoveAnimation
{
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        carImgView.centerX = self.frame.size.width/2;
        carImgView.centerY = self.frame.size.height/2;
    } completion:^(BOOL finished) {
        [self showCarAnimation];
    }];
}

- (void) showSecondMoveAnimation
{
    [UIView animateWithDuration:1.0 animations:^{
        carImgView.right = 0;
        carImgView.top = SCREEN_HEIGHT - 100;
    } completion:^(BOOL finished) {
        carImgView.left = SCREEN_WIDTH;
        carImgView.top = 30;
        isStopRightToLeft = YES;
        self.hidden = YES;
        [carImgView removeFromSuperview];
        [self removeFromSuperview];
        
        [LuxuryManager luxuryManager].isShowAnimation = NO;
        [[LuxuryManager luxuryManager] showLuxuryAnimation];
    }];
}

@end
