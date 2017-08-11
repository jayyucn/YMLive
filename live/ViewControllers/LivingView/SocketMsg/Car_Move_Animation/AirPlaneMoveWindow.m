//
//  AirPlaneMoveWindow.m
//  IOS_3D_UI
//
//  Created by jacklong on 16/4/5.
//
//

#import "AirPlaneMoveWindow.h"
#import "CarMoveBottomMoveToTopView.h"
#import "LuxuryManager.h"

@interface AirPlaneMoveWindow()
{
    BOOL isFinishAnimation;
    float angleFirst;
    float angleSecond;
    float angleThree;
    float angleFour;
    UIImageView *airPlaneImageView;
    UIImageView *airPlaneShadowImageView;
    UIImageView *firstPropellerImgView;
    UIImageView *secondPropellerImgView;
    UIImageView *threePropellerImgView;
    UIImageView *fourPropellerImgView;
}

@end

@implementation AirPlaneMoveWindow

static AirPlaneMoveWindow *alertAriPlainView = nil;


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = NO;
        
        UIImage *airPlaneImg = [UIImage imageNamed:@"image/animation/gift_plane"];
        airPlaneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, airPlaneImg.size.width*2/3, airPlaneImg.size.height*2/3)];
        airPlaneImageView.image = airPlaneImg;
        [self addSubview:airPlaneImageView];
 
        UIImage *airPlaneShadowImg = [UIImage imageNamed:@"image/animation/gift_missile"];
        airPlaneShadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, airPlaneImageView.height+ 50, airPlaneShadowImg.size.width*2/3, airPlaneShadowImg.size.height*2/3)];
        airPlaneShadowImageView.image = airPlaneShadowImg;
        [airPlaneImageView addSubview:airPlaneShadowImageView];
        
        UIImage *propellerImg = [UIImage imageNamed:@"image/animation/gift_missile_fire"];
        firstPropellerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(airPlaneImageView.width/2-14, airPlaneImageView.height - 25, propellerImg.size.width/3, propellerImg.size.height/3)];
        firstPropellerImgView.image = propellerImg;
        [airPlaneImageView addSubview:firstPropellerImgView];
        
        secondPropellerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(airPlaneImageView.width/2-54, airPlaneImageView.height - 35, propellerImg.size.width*2/5, propellerImg.size.height*2/5)];
        secondPropellerImgView.image = propellerImg;
        [airPlaneImageView addSubview:secondPropellerImgView];
        
        threePropellerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(40, airPlaneImageView.height - 44, propellerImg.size.width/5, propellerImg.size.height/5)];
        threePropellerImgView.image = propellerImg;
        [airPlaneImageView addSubview:threePropellerImgView];
        
        fourPropellerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, airPlaneImageView.height/2-5, propellerImg.size.width/3, propellerImg.size.height/3)];
        fourPropellerImgView.image = propellerImg;
        [airPlaneImageView addSubview:fourPropellerImgView];
        
        [self showWithAnimated];
    }
    return self;
}


- (void) showWithAnimated
{
    self.hidden = NO;
    
    isFinishAnimation = NO;
    
//    airPlaneImageView.centerX = SCREEN_WIDTH/2;
//    airPlaneImageView.centerY = SCREEN_HEIGHT/2;
    
    airPlaneImageView.left = SCREEN_WIDTH;
    airPlaneImageView.top = 30;
    
    angleFirst = 0;
    angleSecond = 0;
    angleThree = 0;
    angleFour = 0;
    
    [self startFirstPropllerAnimation:firstPropellerImgView];
    [self startSecondPropllerAnimation:secondPropellerImgView];
    [self startThreePropllerAnimation:threePropellerImgView];
    [self startFourPropllerAnimation:fourPropellerImgView];
    
    self.hidden = NO;
    [UIView animateWithDuration:.3 animations:^{
        self.top = 0;
    } completion:^(BOOL finished) {
        [self startAirplaneAnimation];
        
        
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

- (void)setMNickName:(NSString *)mNickName {
    UILabel* nameLabel = [[UILabel alloc] init];
    nameLabel.text = mNickName;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.shadowColor = [UIColor yellowColor];
    [nameLabel sizeToFit];
    nameLabel.center = CGPointMake(airPlaneImageView.width / 2, -10);
    [airPlaneImageView addSubview:nameLabel];
}

- (void) startAirplaneAnimation
{
    [UIView animateWithDuration:1.5 animations:^{
        airPlaneImageView.centerX = SCREEN_WIDTH/2;
        airPlaneImageView.centerY = SCREEN_HEIGHT/2;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.8 delay:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            airPlaneImageView.right = 0;
            airPlaneImageView.top = SCREEN_HEIGHT - 50;
        } completion:^(BOOL finished) {
            airPlaneImageView.left = SCREEN_WIDTH;
            airPlaneImageView.top = 30;
            isFinishAnimation = YES;
            self.hidden = YES;
            [airPlaneImageView removeFromSuperview];
            [self removeFromSuperview];
            
            [LuxuryManager luxuryManager].isShowAnimation = NO;
            [[LuxuryManager luxuryManager] showLuxuryAnimation];
        }];
    }];
}


- (void) startFirstPropllerAnimation:(UIImageView *)propellerView
{
    if (isFinishAnimation) {
        return;
    }
    
    if (!propellerView)
    {
        return;
    }
    
    [UIView animateWithDuration:.01 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CALayer *layer = propellerView.layer;
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / -500;
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -(M_PI/20), 1, 0,0);
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform,M_PI/2+M_PI/6, 0, 1,0);
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform,angleFirst * M_PI / 180.0f, 0,0,1);
        layer.transform = rotationAndPerspectiveTransform;
    } completion:^(BOOL finished) {
        angleFirst += 15;
        
        [self startFirstPropllerAnimation:propellerView];
    }];
}

- (void) startSecondPropllerAnimation:(UIImageView *)propellerView
{
    if (isFinishAnimation) {
        return;
    }
    
    if (!propellerView)
    {
        return;
    }
    
    [UIView animateWithDuration:.01 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CALayer *layer = propellerView.layer;
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / -500;
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -(M_PI/20), 1, 0,0);
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform,M_PI/2+M_PI/6, 0, 1,0);
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform,angleSecond * M_PI / 180.0f, 0,0,1);
        layer.transform = rotationAndPerspectiveTransform;
    } completion:^(BOOL finished) {
        angleSecond += 15;
        
        [self startSecondPropllerAnimation:propellerView];
    }];
}

- (void) startThreePropllerAnimation:(UIImageView *)propellerView
{
    if (isFinishAnimation) {
        return;
    }
    
    if (!propellerView)
    {
        return;
    }
    
    [UIView animateWithDuration:.01 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CALayer *layer = propellerView.layer;
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / -500;
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -(M_PI/20), 1, 0,0);
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform,M_PI/2+M_PI/6, 0, 1,0);
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform,angleThree * M_PI / 180.0f, 0,0,1);
        layer.transform = rotationAndPerspectiveTransform;
    } completion:^(BOOL finished) {
        angleThree += 15;
        
        [self startThreePropllerAnimation:propellerView];
    }];
}


- (void) startFourPropllerAnimation:(UIImageView *)propellerView
{
    if (isFinishAnimation) {
        return;
    }
    
    if (!propellerView)
    {
        return;
    }
    
    [UIView animateWithDuration:.01 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CALayer *layer = propellerView.layer;
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / -500;
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -(M_PI/20), 1, 0,0);
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform,M_PI/2+M_PI/6, 0, 1,0);
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform,angleFour * M_PI / 180.0f, 0,0,1);
        layer.transform = rotationAndPerspectiveTransform;
    } completion:^(BOOL finished) {
        angleFour += 15;
        
        [self startFourPropllerAnimation:propellerView];
    }];
}


#pragma mark 屏幕点击
- (void) singleTap
{
//        [UIView animateWithDuration:.3 animations:^{
//            self.top = SCREEN_HEIGHT;
//        } completion:^(BOOL finished) {
//            self.hidden = YES;
//            isFinishAnimation = YES;
//        }];
}

#pragma mark - 点击范围
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (gestureRecognizer.view == self) {
        if (!self.hidden) {
            CGPoint point = [touch locationInView:airPlaneImageView];
            if (point.x > 0 && point.x < airPlaneImageView.frame.size.width
                && point.y > 0 && point.y < airPlaneImageView.frame.size.height ) {
                return NO;
            }
        }
    }
    return YES;
}



@end
