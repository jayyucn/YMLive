//
//  LoginViewController.m
//  登录引导界面
//
//

#import "LoginViewController.h"
#import "LCLandViewController.h"
#import "LCInsetsLabel.h"
#import "BaseNavigationController.h"
#import "QCTencentManager.h"
#import "WXPayManager.h"

@interface LoginViewController ()
{
    AVPlayer *avPlayer;
    AVPlayerLayer *avPlayerLayer;
    CMTime time;
}

@end


@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    // --------------------------- AVPLAYER STUFF -------------------------------
    NSString *AVResource = [[NSBundle mainBundle] pathForResource:@"welcomeVideo" ofType:@"mp4"];
    
    NSURL *urlPathOfVideo = [NSURL fileURLWithPath:AVResource];
    avPlayer = [AVPlayer playerWithURL:urlPathOfVideo];
    avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:avPlayer];
    avPlayerLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view.layer addSublayer:avPlayerLayer];
    
    [avPlayer play];
    time = kCMTimeZero;
    
    // prevent music coming from other app
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    
    // AVPlayer Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[avPlayer currentItem]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pauseVideo)
                                                 name:@"PauseBgVideo"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resumeVideo)
                                                 name:@"ResumeBgVideo"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self setUp];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        [obj removeFromSuperview];
    }];
}


#pragma mark - AVPlayer methods

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

- (void)pauseVideo
{
    [avPlayer pause];
    time = avPlayer.currentTime;
}

- (void)resumeVideo
{
    [avPlayer seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [avPlayer play];
}


- (void)setUp
{
    LCInsetsLabel *sectionFooterLabel = [[LCInsetsLabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50) andInsets:UIEdgeInsetsMake(3, 12, 0, 12)];
    
    sectionFooterLabel.top = ScreenHeight / 3 * 2;
    sectionFooterLabel.textAlignment = NSTextAlignmentCenter;
    sectionFooterLabel.textColor = [UIColor grayColor];
    sectionFooterLabel.font = [UIFont systemFontOfSize:16.f];
    sectionFooterLabel.backgroundColor =[UIColor clearColor];
    sectionFooterLabel.numberOfLines = 0;
    
    NSString *labelString= [NSString stringWithFormat:@"----------  %@  ----------", NSLocalizedString(@"选择登录方式", nil)];
    
    NSDictionary *attrs = @{NSFontAttributeName : sectionFooterLabel.font};
    CGSize size = [labelString boundingRectWithSize:CGSizeMake(sectionFooterLabel.width-sectionFooterLabel.insets.left*2, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
    sectionFooterLabel.height = size.height + 12;
    sectionFooterLabel.text = labelString;
    sectionFooterLabel.textColor = [UIColor blackColor];
    [self.view addSubview:sectionFooterLabel];
    
    UIImage *qqImage = [UIImage imageNamed:@"image/reg/login_new_qq"];
    UIButton *qqLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    qqLoginBtn.frame = CGRectMake(0, sectionFooterLabel.bottom+10, 50, 50);
    qqLoginBtn.centerX = SCREEN_WIDTH / 4;
    [qqLoginBtn setBackgroundImage:qqImage forState:UIControlStateNormal];
    [qqLoginBtn addTarget:self
                   action:@selector(qqLoginAction)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qqLoginBtn];
    
    UIImage *phoneImage = [UIImage imageNamed:@"image/reg/login_new_phone"];
    UIButton *phoneLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneLoginBtn.frame = CGRectMake(0, sectionFooterLabel.bottom+10, qqLoginBtn.width, qqLoginBtn.height);
    phoneLoginBtn.centerX = SCREEN_WIDTH / 4 * 2;
    [phoneLoginBtn setBackgroundImage:phoneImage forState:UIControlStateNormal];
    [phoneLoginBtn addTarget:self
                      action:@selector(phoneLoginAction)
            forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:phoneLoginBtn];
    
    UIImage *wxImage = [UIImage imageNamed:@"image/reg/login_new_weixin"];
    UIButton *wxLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    wxLoginBtn.frame = CGRectMake(0, sectionFooterLabel.bottom+10, qqLoginBtn.width, qqLoginBtn.height);
    wxLoginBtn.centerX = SCREEN_WIDTH / 4 * 3;
    [wxLoginBtn setBackgroundImage:wxImage forState:UIControlStateNormal];
    [wxLoginBtn addTarget:self
                   action:@selector(wxLoginAction)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wxLoginBtn];
    
    // 提审苹果时隐藏第三方登录
    if (![[LCCore globalCore] shouldShowPayment])
    {
        qqLoginBtn.hidden = YES;
        wxLoginBtn.hidden = YES;
    }
}


#pragma mark - login action

- (void)qqLoginAction
{
    [LCCore globalCore].isThirdLogin = true;
    
    [[QCTencentManager tencentManager] tencentOAuthWithoutSafari];
}

- (void)wxLoginAction
{
    [LCCore globalCore].isThirdLogin = true;
    
    [WXPayManager wxPayManager].showWxView = self;
    [[WXPayManager wxPayManager] sendAuthReq];
}

- (void)phoneLoginAction
{
    // 跳转手机登录界面
    LCLandViewController *landController = [[LCLandViewController alloc] init];
    [self.navigationController pushViewController:landController animated:true];
}


#pragma mark - Life cycle methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
