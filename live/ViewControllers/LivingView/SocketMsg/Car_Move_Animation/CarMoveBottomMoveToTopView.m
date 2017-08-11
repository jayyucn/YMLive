//
//  CarMoveBottomMoveToTopView.m
//  IOS_3D_UI
//
//  Created by jacklong on 16/4/5.
//
//

#import "CarMoveBottomMoveToTopView.h"
 
#import "AirPlaneMoveWindow.h"
#import "LuxuryManager.h"

@interface CarMoveBottomMoveToTopView()
{
    float angleBefore;
    float angleAfter;
    BOOL isStopRightToLeft;
    UIImageView *carImgView;
    UIImageView *leftLightImgView;
    UIImageView *rightLightImageView;
    UIImageView *beforeWheelImgView;
    UIImageView *afterWheelImgView;
    
    UIImageView *exhaustImgView;
}

@end

@implementation CarMoveBottomMoveToTopView

static CarMoveBottomMoveToTopView *alertCarView = nil;

+ (void) realseCar
{
    alertCarView = nil;
}

//+ (void)showCar
//{
//    if (!alertCarView) {
//        alertCarView =[[CarMoveBottomMoveToTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    }
//    
//    [alertCarView showWithAnimated];
//}

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
    isStopRightToLeft = NO;
    
    UIImage *carImg = [UIImage imageNamed:@"image/liveroom/car_1"];
    
    carImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, carImg.size.width*3/5
                                                               , carImg.size.height*3/5)];
    carImgView.image = carImg;
    [self addSubview:carImgView];
    
    carImgView.left = SCREEN_WIDTH;
    carImgView.top = SCREEN_HEIGHT - 50;
    
    UIImage *wheelImg = [UIImage imageNamed:@"image/liveroom/car_wheel"];
    beforeWheelImgView = [[UIImageView alloc] initWithFrame:CGRectMake(-4, 29, wheelImg.size.width/13+4, wheelImg.size.height/13+4)];
    beforeWheelImgView.image = wheelImg;
    [carImgView addSubview:beforeWheelImgView];
    
    afterWheelImgView = [[UIImageView alloc] initWithFrame:CGRectMake(carImgView.width/2-wheelImg.size.width/8-2,59, wheelImg.size.width/8+5, wheelImg.size.height/8+5)];
    afterWheelImgView.image = wheelImg;
    [carImgView addSubview:afterWheelImgView];
    
    UIImage *leftLightImg = [UIImage imageNamed:@"image/liveroom/Redocn_back_light"];
    leftLightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(carImgView.width/2+10, 53, leftLightImg.size.width*2/3, leftLightImg.size.height*2/3)];
    leftLightImgView.image = leftLightImg;
    [carImgView addSubview:leftLightImgView];
    leftLightImgView.hidden = YES;
    
    
    UIImage *rightLightImg = [UIImage imageNamed:@"image/liveroom/Redocn_back_light"];
    
    rightLightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(carImgView.width - 32, 30.5, rightLightImg.size.width*3/5, rightLightImg.size.height*3/5)];
    rightLightImageView.image = rightLightImg;
    [carImgView addSubview:rightLightImageView];
    rightLightImageView.hidden = YES;
    
    UIImage *exhuastImg = [UIImage imageNamed:@"image/liveroom/Redocn_paiqi"];
    exhaustImgView = [[UIImageView alloc] initWithFrame:CGRectMake(carImgView.width - 75, 71.5, exhuastImg.size.width*3/5, exhuastImg.size.height*3/5)];
    exhaustImgView.image = exhuastImg;
    [carImgView addSubview:exhaustImgView];
    exhaustImgView.hidden = YES;
    
//    isStopRightToLeft = NO;
//    [self startBeforeWheelAnimation];
//    [self startAfterWheelAnimation];
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

//- (void) showWheelAnimation
//{
//    CABasicAnimation* rotationAnimation;
//    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
//    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
//    rotationAnimation.duration = 1;
//    rotationAnimation.cumulative = YES;
//    rotationAnimation.repeatCount = MAXFLOAT;
//
//    [beforeWheelImgView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
//}


- (void) changeRotationPosImageView:(UIImageView *)imgView
{
    //    if (imgView) {
    //        CALayer *layer = imgView.layer;
    //        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    //        rotationAndPerspectiveTransform.m34 = 1.0 / -500;
    //        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 30.0f * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
    //        layer.transform = rotationAndPerspectiveTransform;
    //    }
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
 
    
    
    [UIView animateWithDuration:.02 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CALayer *layer = beforeWheelImgView.layer;
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / -500;
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -(M_PI/20), 1, 0,0);
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform,M_PI/2+M_PI/6, 0, 1,0);
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform,angleBefore * M_PI / 180.0f, 0,0,1);
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
    
    [UIView animateWithDuration:.02 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CALayer *layer = afterWheelImgView.layer;
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / -500;
         rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, (M_PI/19), 1, 0,0);
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -(M_PI/2+M_PI/6+M_PI/20), 0, 1,0);
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform,angleAfter * M_PI / 180.0f, 0,0,1);
        layer.transform = rotationAndPerspectiveTransform;
    } completion:^(BOOL finished) {
        angleAfter += 15;
        
        [self startAfterWheelAnimation];
    }];
}



#pragma mark 屏幕点击
- (void) singleTap
{
//    [UIView animateWithDuration:.3 animations:^{
//        self.top = SCREEN_HEIGHT;
//    } completion:^(BOOL finished) {
//        self.hidden = YES;
//    }];
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
    isStopRightToLeft = NO;
    angleAfter = 0;
    angleBefore = 0;
    [self startBeforeWheelAnimation];
    [self startAfterWheelAnimation];
    carImgView.left = SCREEN_WIDTH;
    carImgView.top = SCREEN_HEIGHT - 50;
//    carImgView.centerY = SCREEN_HEIGHT/2;
//    carImgView.centerX = SCREEN_WIDTH/2;
    self.hidden = NO;
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
    if (flag) {
        if (isStopRightToLeft) {
            return;
        }
        NSString *animationName = [anim valueForKey:@"animationName"];
        if ([animationName isEqualToString:@"left_light"])
        {
            leftLightImgView.hidden = YES;
            rightLightImageView.hidden = YES;
            [self exhuastAnimation];
        } else if ([animationName isEqualToString:@"exhust_light"]) {
            exhaustImgView.hidden = YES;
            [self showSecondMoveAnimation];
        }
    }
}


#pragma mark - 显示车的动画
- (void) showStartMoveRightMoveToLeft
{
    int x = arc4random() % 5+1;
    
    UIImage *carImg = [UIImage imageNamed:[NSString stringWithFormat:@"image/liveroom/car_%d",x]];
    carImgView.image = carImg;
    [UIView animateWithDuration:.8 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        carImgView.left =  SCREEN_WIDTH - carImgView.width/3;
        carImgView.top = SCREEN_HEIGHT - carImgView.width/3-50;
    } completion:^(BOOL finished) {
        [self showFirstMoveAnimation];
    }];
}


- (void) showFirstMoveAnimation
{
    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        carImgView.centerX = self.frame.size.width/2;
        carImgView.centerY = self.frame.size.height/2;
    } completion:^(BOOL finished) {
        [self opacityAnimation:.5 withView:leftLightImgView withAnimaitonName:@"left_light"];
        [self opacityAnimation:.5 withView:rightLightImageView withAnimaitonName:@"right_light"];
    }];
}


- (void) exhuastAnimation
{
    [self opacityAnimation:.1 withView:exhaustImgView withAnimaitonName:@"exhust_light"];
}

- (void) showSecondMoveAnimation
{
    [UIView animateWithDuration:.7 animations:^{
        carImgView.right = 0;
        carImgView.top = 30;
    } completion:^(BOOL finished) {
        carImgView.left = SCREEN_WIDTH;
        carImgView.top = SCREEN_HEIGHT - 50;
        isStopRightToLeft = YES;
        self.hidden = YES;
        [carImgView removeFromSuperview];
        [self removeFromSuperview];
        
        [LuxuryManager luxuryManager].isShowAnimation = NO;
        [[LuxuryManager luxuryManager] showLuxuryAnimation];
    }];
}

@end
