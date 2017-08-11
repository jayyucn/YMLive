//
//  RobRedPacketViewController.m
//  qianchuo
//
//  Created by jacklong on 16/4/14.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "RobRedPacketViewController.h"
#import "RobRedPacketUserTableView.h"
#import "RedPacketManager.h"

#define NO_SHOW_USER_HEIGHT ScreenHeight*2/3

@interface RobRedPacketViewController()
{
    
    BOOL            isStartRob;
    int             bottomViewHeight;
    float           angleBefore;
    UIView          *contentView;
    
    UIImageView     *firstHeadImg;
    UIImageView     *headFaceImg;
    UIImageView     *gradeFlagImgView;
    UILabel         *nickNameLabel;
    UILabel         *promptLabel;
    UIView          *firstBgView;// 138,49,44
    UIView          *bottomView;// 109,36,31
    UIButton        *closeRedBtn;
    UIButton        *robRedBagBtn;
   
    
    UIView          *secondView;
    UIImageView     *headSecondImg;
    UIView          *secondBgView;
    UIImageView     *headSecondFaceImg;
    UIImageView     *secondGradeFlagImgView;
    UILabel         *secondNickNameLabel;
    UILabel         *robPromptLabel;
    UIView          *lineView;
    
    UILabel         *lookLuckyPromptLabel;
    UIButton        *lookLuckyBtn;
    UIButton        *findLuckBtn;
    
    UIActivityIndicatorView       *activityIndicator;
    RobRedPacketUserTableView     *luckDetailUserTableView;
    
}
@end

@implementation RobRedPacketViewController

static BOOL isShow;

+ (BOOL) isShowRedPacket
{
    return isShow;
}

+ (void) isCloseRedPacket
{
    isShow = NO;
}

- (void)dealloc
{
    NSLog(@"dealloc %@",NSStringFromClass(self.class));
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        isShow = YES;
        self.hidesBottomBarWhenPushed = YES;
        self.contentSizeInPopup = CGSizeMake(SCREEN_WIDTH - SCREEN_WIDTH/5, NO_SHOW_USER_HEIGHT);
    }
    return self;
}

- (STPopupController *)preferredPopupController
{
    STPopupController *popup = [super preferredPopupController];
    popup.navigationBarHidden = YES;
    popup.tapBackgroundViewToDismiss = YES;
    popup.containerView.backgroundColor = [UIColor clearColor];
    return popup;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    contentView = self.view;
    contentView.backgroundColor = [UIColor whiteColor];
    UIBezierPath *showPath = [UIBezierPath bezierPathWithRoundedRect:contentView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *showLayer = [[CAShapeLayer alloc] init];
    showLayer.frame = contentView.bounds;
    showLayer.path = showPath.CGPath;
    contentView.layer.mask = showLayer;
    contentView.userInteractionEnabled=YES;
    contentView.backgroundColor = [UIColor whiteColor];
    
    secondView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentView.width, contentView.height)];
    [contentView addSubview:secondView];
    secondView.hidden = NO;
    
    firstBgView = [[UIView alloc] initWithFrame:CGRectMake(0, contentView.height/3, contentView.width, contentView.height*2/3)];
    [firstBgView setBackgroundColor:UIColorWithRGB(138,49,44)];
    [contentView addSubview:firstBgView];
    
    UIImage *bg_room_red_packet_head = [UIImage createContentsOfFile:@"image/liveroom/bg_room_red_packet_head"];
    UIEdgeInsets insetsHead = UIEdgeInsetsMake(10, 0, bg_room_red_packet_head.size.height - 15, 0);
    // 指定为拉伸模式，伸缩后重新赋值
    bg_room_red_packet_head = [bg_room_red_packet_head resizableImageWithCapInsets:insetsHead resizingMode:UIImageResizingModeStretch];
    
    firstHeadImg = [[UIImageView alloc] initWithFrame:CGRectMake(-2, 0, contentView.width+2,contentView.height*2/3)];
    firstHeadImg.image = bg_room_red_packet_head;
    //        UIBezierPath *showFirstHeadPath = [UIBezierPath bezierPathWithRoundedRect:firstHeadView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    //        CAShapeLayer *showFirstHeadLayer = [[CAShapeLayer alloc] init];
    //        showFirstHeadLayer.frame = firstHeadView.bounds;
    //        showFirstHeadLayer.path = showFirstHeadPath.CGPath;
    //        firstHeadView.layer.mask = showFirstHeadLayer;
    
    [contentView addSubview:firstHeadImg];
    
    headFaceImg = [[UIImageView alloc] initWithFrame:CGRectMake(contentView.width/2-25, 50, 50, 50)];
    headFaceImg.layer.borderWidth = 1;
    headFaceImg.layer.borderColor = [UIColor clearColor].CGColor;
    headFaceImg.layer.cornerRadius = headFaceImg.frame.size.width/2;
    headFaceImg.clipsToBounds = YES;
    headFaceImg.image = [UIImage createContentsOfFile:@"default_head"];
    [firstHeadImg addSubview:headFaceImg];
    
    UIImage *gradeFlagImg = [UIImage imageNamed:@"image/yonghu/grade_flag/grade_flag_1"];
    gradeFlagImgView = [[UIImageView alloc] initWithFrame:CGRectMake(headFaceImg.right - gradeFlagImg.size.width, headFaceImg.bottom - gradeFlagImg.size.height+2, gradeFlagImg.size.width, gradeFlagImg.size.height)];
    gradeFlagImgView.image = gradeFlagImg;
    [firstHeadImg addSubview:gradeFlagImgView];
    
    nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, headFaceImg.bottom+15, contentView.width, 20)];
    nickNameLabel.font = [UIFont systemFontOfSize:15.f];
    nickNameLabel.textColor = [UIColor whiteColor];
    nickNameLabel.textAlignment =  NSTextAlignmentCenter;
    [firstHeadImg addSubview:nickNameLabel];
    
    promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, nickNameLabel.bottom+10, contentView.width, 15)];
    promptLabel.font = [UIFont systemFontOfSize:11.f];
    promptLabel.textColor = UIColorWithRGB(251, 165, 165);
    promptLabel.text = @"给你发来一个红包";
    promptLabel.textAlignment = NSTextAlignmentCenter;
    [firstHeadImg addSubview:promptLabel];
    
    // 抢红包的按钮
    UIImage *robRedImage = [UIImage imageNamed:@"image/liveroom/gift_qiang"];
    robRedBagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    robRedBagBtn.frame =  CGRectMake(contentView.width/2-robRedImage.size.width/2, firstHeadImg.height-robRedImage.size.height/2, robRedImage.size.width, robRedImage.size.height);
    [robRedBagBtn setImage:robRedImage forState:UIControlStateNormal];
    [firstHeadImg addSubview:robRedBagBtn];
    [robRedBagBtn addTarget:self action:@selector(openRedPacketAction) forControlEvents:UIControlEventTouchUpInside];
    
    // 底部bottomView
    UIImage *closeImg = [UIImage createContentsOfFile:@"image/liveroom/redpacket_close"];
    bottomViewHeight = closeImg.size.height/3+20;
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, contentView.height - bottomViewHeight, contentView.width, bottomViewHeight)];
    bottomView.backgroundColor = UIColorWithRGB(109,36,31);
    
    UIBezierPath *showBottomPath = [UIBezierPath bezierPathWithRoundedRect:bottomView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *showBottomLayer = [[CAShapeLayer alloc] init];
    showBottomLayer.frame = bottomView.bounds;
    showBottomLayer.path = showBottomPath.CGPath;
    bottomView.layer.mask = showBottomLayer;
    [contentView addSubview:bottomView];
    
    
    closeRedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeRedBtn setImage:closeImg forState:UIControlStateNormal];
    closeRedBtn.frame = CGRectMake(contentView.width/2 - closeImg.size.width/6, 10, closeImg.size.width/3,closeImg.size.height/3);
    [closeRedBtn addTarget:self action:@selector(closeRedPacketAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:closeRedBtn];
    
    UIButton * closeRedPacketBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeRedPacketBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    closeRedPacketBtn.frame = CGRectMake(contentView.width/2 - bottomView.height/2, 0, bottomView.height,bottomView.height);
    [closeRedPacketBtn addTarget:self action:@selector(closeRedPacketAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:closeRedPacketBtn];
    
    secondBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, contentView.width, contentView.height - 80)];
    [secondBgView setBackgroundColor:[UIColor whiteColor]];
    [secondView addSubview:secondBgView];
    
    UIImage * bg_room_red_packet_open_head = [UIImage createContentsOfFile:@"image/liveroom/bg_room_red_packet_open_head"];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 0, bg_room_red_packet_open_head.size.height - 15, 0);
    // 指定为拉伸模式，伸缩后重新赋值
    bg_room_red_packet_open_head = [bg_room_red_packet_open_head resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    headSecondImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, contentView.width, contentView.height/3)];
    headSecondImg.image = bg_room_red_packet_open_head;
    [secondView addSubview:headSecondImg];
    
    
    headSecondFaceImg = [[UIImageView alloc] initWithFrame:CGRectMake(contentView.width/2-25, 30, 50, 50)];
    headSecondFaceImg.layer.cornerRadius = headSecondFaceImg.frame.size.width/2;
    headSecondFaceImg.clipsToBounds = YES;
    [headSecondImg addSubview:headSecondFaceImg];
    
    secondGradeFlagImgView = [[UIImageView alloc] initWithFrame:CGRectMake(headSecondFaceImg.right - gradeFlagImg.size.width, headSecondFaceImg.bottom - gradeFlagImg.size.height+2, gradeFlagImg.size.width, gradeFlagImg.size.height)];
    secondGradeFlagImgView.image = gradeFlagImg;
    [headSecondImg addSubview:secondGradeFlagImgView];
    
    
    secondNickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, headSecondImg.bottom+10, contentView.width, 20)];
    secondNickNameLabel.font = [UIFont systemFontOfSize:13.f];
    secondNickNameLabel.textColor = [UIColor blackColor];
    secondNickNameLabel.textAlignment =  NSTextAlignmentCenter;
    [secondView addSubview:secondNickNameLabel];
    
    
    robPromptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, secondNickNameLabel.bottom+10, contentView.width, 30)];
    robPromptLabel.font = [UIFont systemFontOfSize:15.f];
    robPromptLabel.textColor = UIColorWithRGB(180, 77, 64);
    robPromptLabel.textAlignment =  NSTextAlignmentCenter;
    robPromptLabel.text = ESLocalizedString(@"手太慢，已发完");
    [secondView addSubview:robPromptLabel];
    robPromptLabel.hidden = YES;
    
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, robPromptLabel.bottom+10, contentView.width, .5f)];
    lineView.backgroundColor = RGBA16(0x30000000);
    [secondView addSubview:lineView];
    
    
    UIImage *lookLuckImg = [UIImage createContentsOfFile:@"image/liveroom/redpacket_expand"];
    
    lookLuckyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lookLuckyBtn.frame = CGRectMake(contentView.width/2 - lookLuckImg.size.width/8, contentView.height - bottomView.height - 25, lookLuckImg.size.width/4, lookLuckImg.size.height/4);
    [lookLuckyBtn setImage:lookLuckImg forState:UIControlStateNormal];
    
    [lookLuckyBtn addTarget:self action:@selector(showRobUserInfoAction) forControlEvents:UIControlEventTouchUpInside];
    [secondView addSubview:lookLuckyBtn];
    
    
    findLuckBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    findLuckBtn.frame = CGRectMake(contentView.width/2 - lookLuckImg.size.width/2, contentView.height - bottomView.height - 25, lookLuckImg.size.width, lookLuckImg.size.height);
    [findLuckBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    
    [findLuckBtn addTarget:self action:@selector(showRobUserInfoAction) forControlEvents:UIControlEventTouchUpInside];
    [secondView addSubview:findLuckBtn];
    
    lookLuckyPromptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, lookLuckyBtn.top - 45, contentView.width, 20)];
    lookLuckyPromptLabel.font = [UIFont systemFontOfSize:15.f];
    lookLuckyPromptLabel.textColor = UIColorWithRGB(180, 77, 64);
    lookLuckyPromptLabel.textAlignment =  NSTextAlignmentCenter;
    lookLuckyPromptLabel.text = ESLocalizedString(@"看看大家的手气");
    [secondView addSubview:lookLuckyPromptLabel];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(contentView.width/2, lineView.bottom + (contentView.height-lineView.bottom)/2,60, 60)];
    activityIndicator.centerX = contentView.width/2;
    [contentView addSubview:activityIndicator];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    activityIndicator.hidden = YES;
    
    
    luckDetailUserTableView = [[RobRedPacketUserTableView alloc] initWithFrame:CGRectMake(0, lineView.bottom, contentView.width, contentView.height-lineView.bottom-bottomView.height)];
    luckDetailUserTableView.activityIndicator = activityIndicator;
    [secondView addSubview:luckDetailUserTableView];
    luckDetailUserTableView.hidden = YES;
    
    
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(singleTap)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    singleRecognizer.delegate = self;
    [contentView addGestureRecognizer:singleRecognizer];
    
     [self setRedDataInfo];
    
    if (_isShowDetail) {
        [self showRedPacketDetail];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    isShow = NO;
}

#pragma mark 屏幕点击
- (void) singleTap
{
   [self.popupController dismiss];
}

#pragma mark - 点击范围
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    CGPoint point = [touch locationInView:contentView];
    if (point.x > 0 && point.x < contentView.frame.size.width
        && point.y > 0 && point.y < contentView.frame.size.height ) {
        
        CGPoint  openPacketPoint = [touch locationInView:robRedBagBtn];
        if (openPacketPoint.x > 0 && openPacketPoint.x < robRedBagBtn.frame.size.width &&
            openPacketPoint.y > 0 && openPacketPoint.y < robRedBagBtn.frame.size.height) {
            [self openRedPacketAction];
        }
        return NO;
    }
   
    return YES;
}


//- (void) showWithAnimated
//{
//    if ([self isShow])
//    {
//        return;
//    }
//    
//    self.hidden = NO;
//    [UIView animateWithDuration:.3 animations:^{
//        self.top = 0;
//    } completion:^(BOOL finished) {
//        
//    }];
//}
//
//
//-(BOOL)isShow
//{
//    if (!self.hidden)
//    {
//        return YES;
//    }
//    return NO;
//}

#pragma mark - view 消失
- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"red packet queue");
    [RobRedPacketViewController isCloseRedPacket];
    [[RedPacketManager redPacketManager] showRedPacketVC];
}


#pragma mark - layout改变
- (void) layoutSubviews
{
    secondView.height = contentView.height;
    secondBgView.height = contentView.height - 80;
    luckDetailUserTableView.height = contentView.height-lineView.bottom-bottomView.height;
    
    UIBezierPath *showPath = [UIBezierPath bezierPathWithRoundedRect:contentView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(12, 12)];
    CAShapeLayer *showLayer = [[CAShapeLayer alloc] init];
    showLayer.frame = contentView.bounds;
    showLayer.path = showPath.CGPath;
    contentView.layer.mask = showLayer;
    
    
    UIBezierPath *showBottomPath = [UIBezierPath bezierPathWithRoundedRect:bottomView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *showBottomLayer = [[CAShapeLayer alloc] init];
    showBottomLayer.frame = bottomView.bounds;
    showBottomLayer.path = showBottomPath.CGPath;
    bottomView.layer.mask = showBottomLayer;
}

- (void) viewWillLayoutSubviews
{
    secondView.height = contentView.height;
    secondBgView.height = contentView.height - 80;
    luckDetailUserTableView.height = contentView.height-lineView.bottom-bottomView.height;
    
    UIBezierPath *showPath = [UIBezierPath bezierPathWithRoundedRect:contentView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(12, 12)];
    CAShapeLayer *showLayer = [[CAShapeLayer alloc] init];
    showLayer.frame = contentView.bounds;
    showLayer.path = showPath.CGPath;
    contentView.layer.mask = showLayer;
    
    
    UIBezierPath *showBottomPath = [UIBezierPath bezierPathWithRoundedRect:bottomView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *showBottomLayer = [[CAShapeLayer alloc] init];
    showBottomLayer.frame = bottomView.bounds;
    showBottomLayer.path = showBottomPath.CGPath;
    bottomView.layer.mask = showBottomLayer;

}

- (void) closeRedPacketAction
{ 
    [self.popupController dismiss];
}

- (void) showRobUserInfoAction
{
    [self robUserInfoDetailState];
}

- (void) setBagInfoDict:(NSDictionary *)bagInfoDict
{
    _redBagInfoDict = [NSMutableDictionary dictionaryWithDictionary:bagInfoDict];
}

// 抢红包事件
- (void) openRedPacketAction
{
    [robRedBagBtn setImage:[UIImage imageNamed:@"image/liveroom/redpacket_diamond_circle"] forState:UIControlStateNormal];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2];
    rotationAnimation.duration = .3;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 20;
    rotationAnimation.delegate = self;
    
    [rotationAnimation setValue:@"rob_rotation" forKey:@"animationName"];
    
    [robRedBagBtn.layer addAnimation:rotationAnimation forKey:@"animationName"];
    
    [self startRobDiamond];
}

// 显示红包详情
- (void) showRedPacketDetail
{
    robRedBagBtn.hidden = YES;
    promptLabel.hidden = YES;
    [self startRobDiamond];
}

//  初始化来红包的状态
- (void) initRedPacketState
{
    robRedBagBtn.hidden = NO;
    firstBgView.hidden = NO;
    firstHeadImg.hidden = NO;
    
    [self noUserInfoState];
}

// 没抢到的动画
- (void) noRobHaveAnimation
{
    robRedBagBtn.hidden = YES;
    [robRedBagBtn setImage:[UIImage imageNamed:@"image/liveroom/gift_qiang"] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:.5 animations:^{
        firstBgView.top = contentView.height;
        firstHeadImg.bottom = 0;
        
    } completion:^(BOOL finished) {
        firstBgView.hidden = YES;
        firstHeadImg.hidden = YES;
        firstHeadImg.bottom = contentView.height*2/3;
        firstBgView.top = contentView.height/3;
        
        [self noUserInfoState];
    }];
}

// 抢到了动画
- (void)robHaveAnimation
{
    robRedBagBtn.hidden = YES;
    [robRedBagBtn setImage:[UIImage imageNamed:@"image/liveroom/gift_qiang"] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:.5 animations:^{
        firstBgView.top = contentView.height;
        firstHeadImg.bottom = 0;
        
    } completion:^(BOOL finished) {
        firstBgView.hidden = YES;
        firstHeadImg.hidden = YES;
        firstHeadImg.bottom = contentView.height*2/3;
        firstBgView.top = contentView.height/3;
        
        [self robUserInfoDetailState];
    }];
}


// 显示用户详情状态
- (void) robUserInfoDetailState
{
    [UIView animateWithDuration:.5 animations:^{
       
        bottomView.top = contentView.height - bottomViewHeight;
        secondView.height = contentView.height;
        secondBgView.height = contentView.height - 80;
        luckDetailUserTableView.height = contentView.height-lineView.bottom-bottomView.height;
        
    } completion:^(BOOL finished) {
        firstBgView.hidden = YES;
        firstHeadImg.hidden = YES;
        
        lookLuckyBtn.hidden = YES;
        findLuckBtn.hidden = YES;
        lookLuckyPromptLabel.hidden = YES;
        
        luckDetailUserTableView.hidden = NO;
        
        self.contentSizeInPopup = CGSizeMake(SCREEN_WIDTH - SCREEN_WIDTH/5, SCREEN_HEIGHT - 100);
        contentView.height = SCREEN_HEIGHT - 100;
        
        bottomView.top = contentView.height - bottomViewHeight;
        secondView.height = contentView.height;
        secondBgView.height = contentView.height - 80;
        luckDetailUserTableView.height = contentView.height-lineView.bottom-bottomView.height;

        
        luckDetailUserTableView.packetId = [NSString stringWithFormat:@"%d",[_redBagInfoDict[@"gift_id"] intValue]];
        [luckDetailUserTableView refreshData];
    }];
}

// 不显示用户详情状态
- (void) noUserInfoState
{
    self.contentSizeInPopup = CGSizeMake(SCREEN_WIDTH - SCREEN_WIDTH/5, NO_SHOW_USER_HEIGHT);
    contentView.height = NO_SHOW_USER_HEIGHT;
    firstHeadImg.top = 0;
    firstHeadImg.height = contentView.height*2/3;
    firstBgView.top = contentView.height/3;
    firstBgView.height = contentView.height*2/3;
    bottomView.top = contentView.height - bottomViewHeight;
    
    lookLuckyBtn.hidden = NO;
    findLuckBtn.hidden = NO;
    lookLuckyPromptLabel.hidden = NO;
    
    activityIndicator.hidden = YES;
    luckDetailUserTableView.hidden = YES;
    [luckDetailUserTableView clearData];
}


#pragma CATransition动画实现

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        NSString *animationName = [anim valueForKey:@"animationName"];
        if ([animationName isEqualToString:@"first"])
        {
            firstBgView.hidden = YES;
            firstHeadImg.hidden = YES;
        }
        else if([animationName isEqualToString:@"rotation"])
        {
            
            robRedBagBtn.hidden = YES;
            [robRedBagBtn setImage:[UIImage imageNamed:@"image/liveroom/gift_qiang"] forState:UIControlStateNormal];
            
            [UIView animateWithDuration:.5 animations:^{
                firstBgView.top = contentView.height;
                firstHeadImg.bottom = 0;
                
            } completion:^(BOOL finished) {
                firstBgView.hidden = YES;
                firstHeadImg.hidden = YES;
                firstHeadImg.bottom = contentView.height*2/3;
                firstBgView.top = contentView.height/2;
            }];
        }
//        else if ([animationName isEqualToString:@"rob_rotation"])
//        {
//            robRedBagBtn.hidden = YES;
//            promptLabel.hidden = YES;
//            
//            if ([_redBagInfoDict[@"grab"] intValue] > 0)
//            {
//                [self setRedDataInfo];
//                [self robHaveAnimation];
//            }
//            else
//            {
//                [self noRobHaveAnimation];
//            }
//        }
    }
}

#pragma mark - 开始抢
- (void) startRobDiamond
{
    if (isStartRob || ![LCMyUser mine].liveUserId)
    {
        return;
    }
    isStartRob = YES;
    
    ESWeakSelf;
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        ESStrongSelf;
        isStartRob = NO;
        if (URL_REQUEST_SUCCESS == [[responseDic objectForKey:@"stat"] integerValue])
        {
            if ([responseDic[@"grab"] intValue] > 0) {
                [_self.redBagInfoDict setObject:responseDic[@"grab"] forKey:@"grab"];
                [LCMyUser mine].diamond += [responseDic[@"grab"] intValue];
                
                [_self setRedDataInfo];
                [_self robHaveAnimation];
            } else {
                [_self noRobHaveAnimation];
            }
        }
        else if (201 == [[responseDic objectForKey:@"stat"] integerValue])// 已经抢过
        {
            if ([responseDic[@"grab"] intValue] > 0) {
                [_self.redBagInfoDict setObject:responseDic[@"grab"] forKey:@"grab"];
                [_self setRedDataInfo];
                [_self robHaveAnimation];
            } else {
                [_self noRobHaveAnimation];
            }
        }
        else
        {
            [_self noRobHaveAnimation];
        }
        
        if (!_self->robRedBagBtn.hidden) {
            [_self->robRedBagBtn.layer removeAllAnimations];
            _self->robRedBagBtn.hidden = YES;
            _self->promptLabel.hidden = YES;
        }

    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        isStartRob = NO;
        ESStrongSelf;
        [_self noRobHaveAnimation];
        
        if (!_self->robRedBagBtn.hidden) {
            [_self->robRedBagBtn.layer removeAllAnimations];
            _self->robRedBagBtn.hidden = YES;
            _self->promptLabel.hidden = YES;
        }
    };
    
    NSDictionary *parameter =  @{@"packetid":_redBagInfoDict[@"gift_id"],@"liveuid":[LCMyUser mine].liveUserId};
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameter
                                                  withPath:URL_ROB_RED_PACKET
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
    
}

// 设置红包信息
- (void) setRedDataInfo
{
    nickNameLabel.text = _redBagInfoDict[@"nickname"];
    secondNickNameLabel.text =  _redBagInfoDict[@"nickname"];
    [headSecondFaceImg sd_setImageWithURL:[NSURL URLWithString:[NSString faceURLString:_redBagInfoDict[@"face"]]] placeholderImage:[UIImage imageNamed:@"default_head"]];
    [headFaceImg sd_setImageWithURL:[NSURL URLWithString:[NSString faceURLString:_redBagInfoDict[@"face"]]] placeholderImage:[UIImage imageNamed:@"default_head"]];
    
    int grade = ESIntValue(_redBagInfoDict[@"grade"]);
    if (grade > 0) {
        gradeFlagImgView.image = [UIImage createUserGradeFlagImage:grade  withIsManager:(_redBagInfoDict[@"offical"] && [_redBagInfoDict[@"offical"] intValue] ==1)?true:false];
        gradeFlagImgView.hidden = NO;
        secondGradeFlagImgView.image = [UIImage createUserGradeFlagImage:grade  withIsManager:(_redBagInfoDict[@"offical"] && [_redBagInfoDict[@"offical"] intValue] ==1)?true:false];
        secondGradeFlagImgView.hidden = NO;
    } else {
        gradeFlagImgView.hidden = YES;
        secondGradeFlagImgView.hidden = YES;
    }
    
    int grabDiamond = 0; // 初始
    ESIntVal(&grabDiamond, _redBagInfoDict[@"grab"]);
    
    if (grabDiamond > 0) {
        robPromptLabel.font = [UIFont boldSystemFontOfSize:26.f];
        
        
        NSString *sendDiamondInfoStr = [NSString stringWithFormat:@"%d  d",grabDiamond];
        NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:sendDiamondInfoStr];
        
        UIImage *diamondIcon = [UIImage imageNamed:@"image/liveroom/me_myaccount_reddiamond"];
        
        NSTextAttachment *diamondAttachment = [[NSTextAttachment alloc] init];
        diamondAttachment.image = [UIImage imageWithImage:diamondIcon scaleToSize:CGSizeMake(diamondIcon.size.width*4/5, diamondIcon.size.height*4/5)];
        NSAttributedString *diamondAttributedString = [NSAttributedString attributedStringWithAttachment:diamondAttachment];
        [mutableAttributedString replaceCharactersInRange:NSMakeRange(sendDiamondInfoStr.length-1, 1) withAttributedString:diamondAttributedString];
        robPromptLabel.attributedText = mutableAttributedString;
        if (!firstBgView.hidden) {
            robRedBagBtn.hidden = YES;
            lookLuckyBtn.hidden = YES;
            findLuckBtn.hidden = YES;
            lookLuckyPromptLabel.hidden = YES;
            luckDetailUserTableView.hidden = NO;
            [robRedBagBtn setImage:[UIImage imageNamed:@"image/liveroom/gift_qiang"] forState:UIControlStateNormal];
        }
        
    } else {
        robPromptLabel.font = [UIFont systemFontOfSize:15.f];
        robPromptLabel.text = ESLocalizedString(@"手太慢，已发完");
    }
    
    robPromptLabel.hidden = NO;
    robRedBagBtn.hidden = NO;
}


@end
