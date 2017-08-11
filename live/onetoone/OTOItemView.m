//
//  OTOItemView.m
//  qianchuo
//
//  Created by jacklong on 16/11/1.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "OTOItemView.h"

#define IntervalPixel 8.0

#define BigWidth (ScreenWidth-IntervalPixel*3)/2
#define BigHeight BigWidth*4/3 + 40
#define smallHeight 104.0

#define BigTextFont 13
#define SmallTextFont 11

#define  CellAutoresizingMask   UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin

#define LabelFont

#define LabelTextColor [UIColor colorWithHexString:@"f1f1f1"]


@implementation OTOItemView


@synthesize otoItemDic;
@synthesize portraitView;
@synthesize setDiamondNumLabel;
@synthesize otoFlagView;
//@synthesize userInfoShadowView;
@synthesize userNameLabel;
@synthesize userSignLabel;
@synthesize maskView;


+(id)initWithType:(OTOItemType)itemType withFrame:(CGRect)frame
{
    OTOItemView *instanceView=[[OTOItemView alloc] initWithFrame:CGRectMake(0,0,BigWidth,BigHeight)];
    [instanceView setAutoresizesSubviews:YES];
    [instanceView initView];
    
    instanceView.frame=frame;
    
    
//    if(itemType==SmallType)
//    {
//        UIImage *smallAnchorInfoShadow=[UIImage imageNamed:@"image/liveHall/infoShadowS"];
//        
//        instanceView.userInfoShadowView.frame=CGRectMake(0, frame.size.height+smallAnchorInfoShadow.size.height, smallAnchorInfoShadow.size.width, smallAnchorInfoShadow.size.height);
//        
//        NSLog(@"anchorInfoShadowView CGRECT :%@",NSStringFromCGRect(instanceView.anchorInfoShadowView.frame));
//        //        instanceView.anchorInfoShadowView.image=smallAnchorInfoShadow;
//        instanceView.userInfoShadowView.backgroundColor = [UIColor whiteColor];
//        instanceView.audienceNum.font=[UIFont boldSystemFontOfSize:SmallTextFont];
//        
//        instanceView.authorName.font=[UIFont boldSystemFontOfSize:SmallTextFont];
//        
//    }
    
    return instanceView;
}

-(void)initView
{
    portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BigWidth, BigWidth*4/3)];
    portraitView.image=[UIImage imageNamed:@"default_head"];
    portraitView.autoresizingMask = CellAutoresizingMask;
    [self addSubview:portraitView];
    
    UIImage *diamondBgImg = [UIImage imageNamed:@"image/onetoone/rec_diamond_bg"];
    UIImageView *diamondBgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, diamondBgImg.size.width, diamondBgImg.size.height)];
    diamondBgImgView.image = diamondBgImg;
    [self addSubview:diamondBgImgView];
    
    UIImage *diamondImg = [UIImage imageNamed:@"image/liveroom/me_myaccount_reddiamond"];
    UIImageView *diamondImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, diamondImg.size.width, diamondImg.size.height)];
    diamondImgView.image = diamondImg;
    diamondImgView.centerY = diamondBgImgView.height/2+10;
    [self addSubview:diamondImgView];
    
   
    setDiamondNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, diamondBgImgView.width-15, diamondBgImgView.height)];
    setDiamondNumLabel.textAlignment = NSTextAlignmentLeft;
    setDiamondNumLabel.centerY = diamondBgImgView.height/2;
    setDiamondNumLabel.text = [NSString stringWithFormat:@"20 钻石/分钟"];
    setDiamondNumLabel.textColor = [UIColor whiteColor];
    setDiamondNumLabel.font = [UIFont systemFontOfSize:14];
    [diamondBgImgView addSubview:setDiamondNumLabel];
    
    
 
    
    
    otoFlagView = [[UIImageView alloc] initWithFrame:CGRectMake(BigWidth-25, portraitView.bottom-22-4, 20, 20)];
    otoFlagView.autoresizingMask = CellAutoresizingMask;
    [self addSubview:otoFlagView];
    
    UIView *userInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, portraitView.bottom, BigWidth, 40.f)];
    userInfoView.backgroundColor = [UIColor whiteColor];
    //    anchorInfoShadowView.autoresizingMask = CellAutoresizingMask;
    [self addSubview:userInfoView];
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:userInfoView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(3, 3)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = userInfoView.bounds;
    maskLayer.path = maskPath.CGPath;
    userInfoView.layer.mask = maskLayer;
    //    anchorInfoShadowView.image=[UIImage imageNamed:@"image/liveHall/anchorInfoShadow"];
    //    [anchorInfoShadowView setAutoresizesSubviews:YES];
    
    
    
    userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, BigWidth-20, 20)];
    userNameLabel.autoresizingMask = CellAutoresizingMask;
    userNameLabel.textAlignment = NSTextAlignmentLeft;
    userNameLabel.textColor=[UIColor blackColor];
    userNameLabel.font=[UIFont boldSystemFontOfSize:BigTextFont];
    userNameLabel.text = @"ddfffff";//self.bo.ybBriefDesc;
    userNameLabel.backgroundColor = [UIColor clearColor];
    [userInfoView addSubview:userNameLabel];
    
    userSignLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,userNameLabel.bottom, BigWidth-20, 20)];
    userNameLabel.autoresizingMask = CellAutoresizingMask;
    userNameLabel.textAlignment = NSTextAlignmentLeft;
    userNameLabel.textColor=[UIColor blackColor];
    userNameLabel.font=[UIFont boldSystemFontOfSize:11.f];
    userNameLabel.text = @"ddfffff";//self.bo.ybBriefDesc;
    userNameLabel.backgroundColor = [UIColor clearColor];
    [userInfoView addSubview:userNameLabel];

    
    maskView = [[UIImageView alloc] initWithImage:[self createImageWithColor:[UIColor clearColor]] highlightedImage:[self createImageWithColor:UIColorWithRGBAHexString(@"0x000000", .5)]];
    maskView.frame = CGRectMake(0, 0, BigWidth, BigHeight);
    maskPath = [UIBezierPath bezierPathWithRoundedRect:maskView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(3, 3)];
    maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = maskView.bounds;
    maskLayer.path = maskPath.CGPath;
    maskView.layer.mask = maskLayer;
    [self addSubview:maskView];
}

- (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event
{
    self.maskView.highlighted = YES;
}

- (void)touchesCancelled:(NSSet *) touches withEvent:(UIEvent *) event
{
    self.maskView.highlighted = NO;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        //autoresizingMask
        
        self.userInteractionEnabled=YES;
        
        UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(singleTap)];
        
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        
        
        [self addGestureRecognizer:singleRecognizer];
        
        
    }
    return self;
}


-(void)singleTap
{
    self.maskView.highlighted = NO;
    NSLog(@"singleTap==%@",otoItemDic);
}


//加载数据
-(void)upDateOfView
{
    NSLog(@"show user info =%@",otoItemDic);
    
    NSString *faceString=[NSString faceURLString:otoItemDic[@"face"]];
    [portraitView sd_setImageWithURL:[NSURL URLWithString:faceString]
                 placeholderImage:[UIImage imageNamed:@"default_head"]];
    
    
    userNameLabel.text=@"jack";
    userSignLabel.text = otoItemDic[@"singature"];
    setDiamondNumLabel.text =  [NSString stringWithFormat:@"%@ 钻/分钟",otoItemDic[@"money"]];
}


@end
