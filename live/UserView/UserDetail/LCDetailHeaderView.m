//
//  LCDetailHeaderView.m
//  XCLive
//
//  Created by ztkztk on 14-5-12.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCDetailHeaderView.h"

#import "UIImage+Blur.h"

@implementation LCDetailHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor colorWithRed:38.0/255 green:38.0/255 blue:38.0/255 alpha:1.0f];
        
//        CGFloat statusNavigationHeight = [[UIApplication sharedApplication] statusBarFrame].size.height+ [LCCore appRootViewController].navigationController.navigationBar.height;
//        NSLog(@"%f",statusNavigationHeight);
        _blurImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0,frame.size.width,150.0)];
        
        [self addSubview:_blurImageView];
        
        _avatar=[[CircleImageView alloc] initWithFrame:CGRectMake(0, 45, 115, 115)];
        [self addSubview:_avatar];
        _avatar.centerX = frame.size.width / 2;
        _avatar.userInteractionEnabled=YES;
        
        _sexImage = [[UIImageView alloc] initWithFrame:CGRectMake(30 + (frame.size.width - 320) - 15, 90,15.0,15.0)];
        _sexImage.centerX = _avatar.left - (320.0-115)/4;
        [self addSubview:_sexImage];
        
//        _liveImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cr_go1"]];
//        _liveImage.animationImages = @[[UIImage imageNamed:@"cr_go1"],[UIImage imageNamed:@"cr_go2"],[UIImage imageNamed:@"cr_go3"]];
//        _liveImage.animationRepeatCount = 0;
//        _liveImage.animationDuration = 1.f;
//        _liveImage.hidden = YES;
//        //[_liveImage startAnimating];
//        _liveImage.backgroundColor = [UIColor clearColor];
//        _liveImage.frame = CGRectMake(ScreenWidth - 60, 20, 38, 18);
//        //_liveImage.animationDuration = 1.f;
//        [self addSubview:_liveImage];

        
        _ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,80,20)];
        _ageLabel.textAlignment = NSTextAlignmentLeft;
        _ageLabel.textColor=[UIColor whiteColor];
        _ageLabel.font=[UIFont systemFontOfSize:15];
        _ageLabel.backgroundColor =[UIColor clearColor];
        _ageLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_ageLabel];
        _ageLabel.left=_sexImage.right + 2;
        _ageLabel.centerY=_sexImage.centerY;
        
        _constellation = [[UILabel alloc] initWithFrame:CGRectMake(0,0,80,20)];
        _constellation.textAlignment = NSTextAlignmentLeft;
        _constellation.textColor=[UIColor whiteColor];
        _constellation.font=[UIFont systemFontOfSize:11];
        _constellation.backgroundColor =[UIColor clearColor];
        _constellation.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_constellation];
        _constellation.left=_sexImage.left;
        _constellation.top=_sexImage.bottom + 6;
        
        self.vipCapImageView = [[UIImageView alloc]initWithImage:UIImageFromCache(@"image/vip/vip_hat")];
        self.vipCapImageView.left = self.avatar.right - self.vipCapImageView.width + 4.f;
        self.vipCapImageView.top = self.avatar.top;
        self.vipCapImageView.hidden = YES;
        [self insertSubview:self.vipCapImageView belowSubview:_avatar];

        // flip button
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *playImage = [UIImage imageNamed:@"image/video/btn_play_bg_b"];
        [_playBtn setBackgroundImage:playImage
                  forState:UIControlStateNormal];
        CGRect playFrame = _playBtn.frame;
        playFrame.size = _avatar.size;
        _playBtn.frame = playFrame;
        
        [_playBtn addTarget:self
                     action:@selector(playVideo)
           forControlEvents:UIControlEventTouchUpInside];
        
        [_avatar addSubview:_playBtn];
        
        _playBtn.alpha=0.5;

        _distance = [[UILabel alloc] initWithFrame:CGRectMake(0,0,80,20)];
        _distance.textAlignment = NSTextAlignmentCenter;
        _distance.textColor=[UIColor whiteColor];
        _distance.font=[UIFont systemFontOfSize:15];
        _distance.backgroundColor =[UIColor clearColor];
        _distance.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_distance];
        
        
        _distance.centerY=_sexImage.centerY;
        _distance.centerX = _avatar.right+(ScreenWidth-115)/4;
        
        _recentlyLanding = [[UILabel alloc] initWithFrame:CGRectMake(0,0,80,20)];
        _recentlyLanding.textAlignment = NSTextAlignmentCenter;
        _recentlyLanding.textColor=[UIColor whiteColor];
        _recentlyLanding.font=[UIFont systemFontOfSize:11];
        _recentlyLanding.backgroundColor =[UIColor clearColor];
        _recentlyLanding.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_recentlyLanding];
        _recentlyLanding.top = _distance.bottom+6;
        _recentlyLanding.centerX=_distance.centerX;
        
        
        _sign = [[UILabel alloc] initWithFrame:CGRectMake(0,0,260,40)];
        _sign.textAlignment = NSTextAlignmentCenter;
        _sign.textColor=[UIColor whiteColor];
        _sign.font=[UIFont systemFontOfSize:13];
        _sign.backgroundColor =[UIColor clearColor];
        //_sign.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_sign];
        _sign.centerX = frame.size.width / 2;
        _sign.top=_avatar.bottom+10;
        
        _sign.numberOfLines=2;
        _blurImageView.height=_sign.bottom+20;
        
        _photoTableView=[[LCPhotoTableView alloc] initWithFrame:CGRectMake(0, _sign.bottom + 25, ScreenWidth, 0)];
        [self addSubview:_photoTableView];
        
        _noPhotoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,_sign.bottom+30, 320, 30)];
        _noPhotoLabel.textAlignment = NSTextAlignmentCenter;
        _noPhotoLabel.textColor=[UIColor grayColor];
        _noPhotoLabel.font=[UIFont systemFontOfSize:15];
        _noPhotoLabel.backgroundColor =[UIColor clearColor];
        _noPhotoLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_noPhotoLabel];
        _noPhotoLabel.hidden=YES;
        _noPhotoLabel.text=@"暂时没有照片";
        
    
        _credit = [[UILabel alloc] initWithFrame:CGRectMake(5,0,100,20)];
        _credit.textAlignment = NSTextAlignmentLeft;
        _credit.textColor=[UIColor whiteColor];
        //_charm.font=[UIFont systemFontOfSize:13];
        _credit.backgroundColor =[UIColor clearColor];
        //_charm.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_credit];
#if 1 //-Elf
          _credit.font = [UIFont boldSystemFontOfSize:16];
#endif
        
        _charm = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 80,0,30,20)];
        _charm.textAlignment = NSTextAlignmentLeft;
        _charm.textColor=[UIColor whiteColor];
        _charm.font=[UIFont systemFontOfSize:13];
        _charm.backgroundColor =[UIColor clearColor];
        _charm.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_charm];
        _charm.text=@"魅力:";
        
        _degreeProgress=[[DDProgressView alloc] initWithFrame:CGRectMake(_charm.right+2,0,80,20)];
        [_degreeProgress setOuterColor: [UIColor clearColor]] ;
        [_degreeProgress setInnerColor: [UIColor blueColor]] ;
        [_degreeProgress setEmptyColor: [UIColor darkGrayColor]] ;
        [self addSubview: _degreeProgress] ;
        [_degreeProgress setProgress:0.5];
        
        _currentCharmDegreeView =[[UIImageView alloc] initWithFrame:CGRectMake(_charm.right+2,0,40,40)];
        [self addSubview: _currentCharmDegreeView] ;
      //  [self startLoadingAnimation];
    }
    return self;
}


-(void)startLoadingAnimation
{
    if(!_loadingImageView)
    {
        _loadingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 10, 10)];
        //_loadingImageView.image=[UIImage imageNamed:@"image/video/btn_upload_glow"];
        _loadingImageView.backgroundColor=[UIColor redColor];
        
        _loadingImageView.layer.cornerRadius = 5;
        _loadingImageView.clipsToBounds = YES;

        [self addSubview:_loadingImageView];

    }
    _loadingImageView.hidden = NO;
    
    //创建运转动画
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration = 2.0;
    pathAnimation.repeatCount = 1000;
    //设置运转动画的路径
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathAddArc(curvedPath, NULL, _avatar.centerX, _avatar.centerY, _avatar.width/2, M_PI / 6, M_PI / 6 + 2 * M_PI, 0);
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    
    [_loadingImageView.layer addAnimation:pathAnimation forKey:@"Circle"];
}

-(void)stopLoadingAnimation
{
    [_loadingImageView.layer removeAnimationForKey:@"Circle"];
    _loadingImageView.hidden=YES;
}

-(void)playVideo
{
    _playVideoBlock(_videoPath);
    
    /*
    if(!_playerController)
    {
        
        //视频播放对象
        _playerController = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:_videoPath]];
        _playerController.controlStyle = MPMovieControlStyleNone;
        [_playerController.view setFrame:CGRectMake(0, 0, _blurImageView.height, _blurImageView.height)];
        _playerController.initialPlaybackTime = -1;
        _playerController.view.centerX=160.0f;
        [self addSubview:_playerController.view];
        // 注册一个播放结束的通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(myMovieFinishedCallback:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:_playerController];

    }
    
    _playerController.view.hidden=NO;
    [_playerController play];
     
     */
}

-(void)showData:(NSDictionary *)dict photos:(NSArray *)photos
{
    LCSex sex = LCSexMan;
    ESIntegerVal(&sex, dict[@"sex"]);
    
    if(sex==LCSexMan)
        _sexImage.image=[UIImage imageNamed:@"image/globle/md_boy"];
    else
        _sexImage.image=[UIImage imageNamed:@"image/globle/md_girl"];
    
    NSString *age = @"";
    ESStringVal(&age, dict[@"age"]);
    _ageLabel.text=[NSString stringWithFormat:@"%@",age];
    
    NSString *xingzuo = @"";
    ESStringVal(&xingzuo, dict[@"xingzuo"]);
    _constellation.text=xingzuo;
    
    NSString *room = @"";
    ESStringVal(&room, dict[@"room_name"]);
//    if (![room isEqualToString:@""])
//    {
//        self.liveImage.hidden = NO;
//        [self.liveImage startAnimating];
//    }
    
        
    NSString *imageURL=[NSString faceURLString:dict[@"face"]];
        ESWeakSelf;
    ESWeak(_avatar);
    [_avatar sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:UIImageFromCache(@"image/globle/placeholder") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
    {
        ESStrongSelf;
        ESStrong(_avatar);
        __avatar.image = image;
        _self.blurImageView.image = [image boxblurImageWithBlur:.9];    
    }];
    
    NSString *videoPath = @"";
    ESStringVal(&videoPath, dict[@"video"]);
   
    _videoPath=videoPath;
    
    if([_videoPath isEqualToString:@""])
    {
        _playBtn.hidden=YES;
    }else{
        _playBtn.hidden=NO;
    }
    
    NSString *distance = @"";
    ESStringVal(&distance, dict[@"distance"]);
    _distance.text=distance;
    
    
    NSString *time = @"";
    ESStringVal(&time, dict[@"time"]);
    _recentlyLanding.text=time;
    
    NSString *sign = @"";
    ESStringVal(&sign, dict[@"sign"]);
    _sign.text = sign;
    
    
    float photoHeight;
    
    if (![photos isKindOfClass:[NSArray class]])
    {
        
//        _noPhotoLabel.hidden=NO;
//        
//        photoHeight=_noPhotoLabel.height;
//        _photoTableView.hidden=YES;
        NSMutableArray *tempPhotos = [NSMutableArray array];
        
        [tempPhotos addObject:@{@"id":@"0",@"url":@"ABAdvisePhoto.png"}];
        
        photos = tempPhotos;
    }
    else
    {
        if (photos.count <= 3)
        {
            NSMutableArray *tempPhotos = [NSMutableArray arrayWithArray:photos];
            
            //[_photos insertObject:@{@"id":@"0",@"url":@"ABAdvisePhoto.png"} atIndex:_photos.count];
            [tempPhotos addObject:@{@"id":@"0",@"url":@"ABAdvisePhoto.png"}];
            photos = tempPhotos;
            //[_photos addObject:@{@"id":@"0",@"url":@"ABAdvisePhoto.png"}];
        }
    }
    
        _noPhotoLabel.hidden=YES;
        if([photos count] > 4)
            photoHeight=PhotoWidth*2+4+12;
        else
            photoHeight=PhotoWidth+2+12;
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
        [tempArray addObjectsFromArray:photos];
        
        _photoTableView.photos = tempArray;
        [_photoTableView reloadData];
   
    
    _photoTableView.height=photoHeight;
    [_photoTableView setNeedsDisplay];
    
    _credit.top=_photoTableView.bottom+10;
    _credit.text=[NSString stringWithFormat:@"魅力:%@",dict[@"charm"]];
    _charm.top=_credit.top;
    _degreeProgress.top=_credit.top;
    
    //self.height=_charm.bottom+10;
    
#if 0 // -Elf
    self.height=_photoTableView.bottom+12;
        _charm.hidden=YES;
        _degree.hidden=YES;
        _degreeProgress.hidden=YES;
#else
        _charm.hidden = NO;
        _degreeProgress.hidden = YES;
        
        NSMutableString *star = [NSMutableString string];
        int credit = 0;
        ESIntVal(&credit, dict[@"credit"]);
        if (credit > 0) {
                credit = (int)(floorf((float)credit / 100));
                credit = MAX(0, MIN(credit, 5));
                for (int ci = 0; ci < credit; ++ci) {
                        [star appendString:@"⭐️"];
                }
        }
    
        if (ESIsStringWithAnyText(star)) {
                _credit.text = NSStringWith(@"诚信等级: %@", star);
        } else {
                _credit.text = NSStringWith(@"诚信等级: %@", @"暂未认证");
        }
    
                [_credit sizeToFit];
                //_charm.left = 20.f;
                _credit.top = _photoTableView.bottom + 10.f;
                _credit.hidden = NO;
                self.height = _credit.bottom + 10.f;
    
#endif
            int authorDegree=[[LCLevelManager sharedDegreeManage] getCharmDegreeByIncome:[dict[@"charm"] doubleValue]];
            NSLog(@"KFDegreeManage===%d",authorDegree);
    
            UIImage *currentAuthor=[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",authorDegree]];
            _currentCharmDegreeView.image=currentAuthor;
            _currentCharmDegreeView.width=currentAuthor.size.width;
            _currentCharmDegreeView.height=currentAuthor.size.height;
            _currentCharmDegreeView.bottom = _charm.bottom-5.0f;
    
        int vipLevel = 0;
        if (ESIntVal(&vipLevel, dict[@"vip"]) && vipLevel > 0) {
                self.vipCapImageView.hidden = NO;
        } else {
                self.vipCapImageView.hidden = YES;
        }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
