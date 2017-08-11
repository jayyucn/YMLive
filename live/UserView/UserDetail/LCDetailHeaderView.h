//
//  LCDetailHeaderView.h
//  XCLive
//
//  Created by ztkztk on 14-5-12.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleImageView.h"
#import "LCPhotoTableView.h"
#import "DDProgressView.h"



typedef  void(^LCPlayVideoBlock)(NSString *videoPath);
@interface LCDetailHeaderView : UIView

@property (nonatomic,strong)UIImageView *blurImageView;
@property (nonatomic,strong)UIImageView *sexImage;
//@property (nonatomic,strong)UIImageView *liveImage;
@property (nonatomic,strong)UILabel *ageLabel;
@property (nonatomic,strong)UILabel *constellation;
@property (nonatomic,strong)CircleImageView *avatar;
@property (nonatomic,strong)UILabel *distance;
@property (nonatomic,strong)UILabel *recentlyLanding;
@property (nonatomic,strong)UILabel *sign;

@property (nonatomic,strong)UILabel *noPhotoLabel;
@property (nonatomic,strong)LCPhotoTableView *photoTableView;
@property (nonatomic,strong)UILabel *credit;
@property (nonatomic,strong)UILabel *charm;
@property (nonatomic,strong)UIImageView *currentCharmDegreeView;
@property (nonatomic,strong)DDProgressView *degreeProgress;

@property (nonatomic,strong)UIButton *playBtn;


@property (nonatomic,strong)NSString *videoPath;

@property (nonatomic,strong)UIImageView *loadingImageView;

@property (nonatomic,copy)LCPlayVideoBlock playVideoBlock;

@property (nonatomic, strong) UIImageView *vipCapImageView;

-(void)showData:(NSDictionary *)dict photos:(NSArray *)photos;

-(void)startLoadingAnimation;
-(void)stopLoadingAnimation;
@end
