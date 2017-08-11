//
//  LiveUserSendGiftView.m
//  qianchuo
//
//  Created by jacklong on 16/3/11.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "LiveUserSendGiftView.h"
#import "LiveGiftFile.h"
#import "UIImage+Category.h"

@implementation LiveUserSendGiftView

- (void)dealloc
{
    NSLog(@"dealloc %@",NSStringFromClass(self.class));
    if (self.giftImg) {
        [self.giftImg removeFromSuperview];
        self.giftImg = nil;
    }
    
    [self removeFromSuperview];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImage *bgImage = [UIImage createContentsOfFile:@"image/liveroom/continue_gift_bg"];
//        UIImage *bgImage = [UIImage imageNamed:@"image/liveroom/continue_gift_bg"];
        bgImage = [self scaleImage:bgImage toScale:0.5f];
        CGFloat top = 0; // 顶端盖高度
        CGFloat bottom = 0; // 底端盖高度
        CGFloat left = 2; // 左端盖宽度
        CGFloat right = bgImage.size.width-2; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        // 伸缩后重新赋值
        bgImage = [bgImage resizableImageWithCapInsets:insets];
    
        
        _bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(10+(frame.size.height-5)/2, 10, frame.size.width-15-80, frame.size.height-10)];
        _bgImg.image = bgImage;
        [self addSubview:_bgImg];
        
        _sendFaceImg = [[UIImageView alloc] initWithFrame:CGRectMake(10,10, _bgImg.height,_bgImg.height)];
        _sendFaceImg.layer.borderWidth = 0.5f;
        _sendFaceImg.layer.borderColor = ColorPink.CGColor;
        _sendFaceImg.layer.cornerRadius = _sendFaceImg.frame.size.width/2;
        _sendFaceImg.clipsToBounds = YES;
        _sendFaceImg.image = [UIImage imageNamed:@"default_head"];
        _sendFaceImg.userInteractionEnabled = YES;
        [self addSubview:_sendFaceImg];
        
        UIImage *gradeFlagImg = [UIImage imageNamed:@"image/yonghu/grade_flag/grade_flag_1"];
        _gradeFlagImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_sendFaceImg.right - gradeFlagImg.size.width, _sendFaceImg.bottom - gradeFlagImg.size.height+2, gradeFlagImg.size.width, gradeFlagImg.size.height)];
        _gradeFlagImgView.image = gradeFlagImg;
        [self addSubview:_gradeFlagImgView];
        
        _giftImg = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-80-frame.size.height/2-10, 0, frame.size.height-10, frame.size.height-10)];
        [self addSubview:_giftImg];
        
        _giftNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-80+5, 0, 120, frame.size.height/2)];
        _giftNumLabel.textAlignment = NSTextAlignmentLeft;
        _giftNumLabel.font = [UIFont boldSystemFontOfSize:16.f];
        _giftNumLabel.textColor =  ColorPink;
        _giftNumLabel.layer.shadowColor = [UIColor whiteColor].CGColor;
        _giftNumLabel.layer.shadowOpacity = 1.0;
        _giftNumLabel.layer.shadowRadius = 5.0;
        _giftNumLabel.layer.shadowOffset = CGSizeMake(0, 1);
        _giftNumLabel.clipsToBounds = NO;
        [self addSubview:_giftNumLabel];
        
        _sendNickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_sendFaceImg.right+10, _bgImg.top, frame.size.width - _sendFaceImg.right-5-_giftNumLabel.width-_giftImg.width, _bgImg.height/2)];
        _sendNickNameLabel.textAlignment = NSTextAlignmentLeft;
        _sendNickNameLabel.font = [UIFont systemFontOfSize:13.f];
        _sendNickNameLabel.textColor =  [UIColor whiteColor];
        _sendNickNameLabel.numberOfLines = 1;
        [self addSubview:_sendNickNameLabel];
        
        _sendGiftNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_sendFaceImg.right+5, _sendNickNameLabel.bottom,_sendNickNameLabel.width + 10, _bgImg.height/2)];
        _sendGiftNameLabel.textAlignment = NSTextAlignmentLeft;
        _sendGiftNameLabel.font = [UIFont systemFontOfSize:13.f];
        _sendGiftNameLabel.textColor =  [UIColor yellowColor];
        _sendGiftNameLabel.numberOfLines = 1;
        [self addSubview:_sendGiftNameLabel];
    }
    return self;
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

#pragma mark - 设置送礼物详情
-(void)setSendGiftDict:(NSDictionary *)sendGiftDict
{
    _sendGiftDict = sendGiftDict;
    NSString *faceString=[NSString faceURLString:sendGiftDict[@"face"]];
    
    [_sendFaceImg sd_setImageWithURL:[NSURL URLWithString:faceString] placeholderImage:[UIImage imageNamed:@"default_head"]];
  
    int grade = ESIntValue(sendGiftDict[@"grade"]);
    if (grade > 0) {
        _gradeFlagImgView.image = [UIImage createUserGradeFlagImage:grade withIsManager:(sendGiftDict[@"offical"] && [sendGiftDict[@"offical"] intValue]) == 1?true:false];
        _gradeFlagImgView.hidden = NO;
    } else {
        _gradeFlagImgView.hidden = YES;
    }
    
    [self showGiftNum:sendGiftDict];
    
    _sendNickNameLabel.text = sendGiftDict[@"nickname"];
    _sendGiftNameLabel.text = [NSString stringWithFormat:@"送一个%@",sendGiftDict[@"gift_name"]];
    
    ESWeakSelf;
    [[LiveGiftFile sharedLiveGiftFile] getGiftImage:[sendGiftDict[@"gift_id"] intValue]
                                          withBlock:^(int giftKeyBlock, UIImage *giftImage){
                                              ESStrongSelf;
                                              _self.giftImg.image  = giftImage;
                                              _self.giftImg.width  = giftImage.size.width/4;
                                              _self.giftImg.height = giftImage.size.height/4;
                                          }];
}

- (void) showGiftNum:(NSDictionary *)giftDict
{
//    if (!giftDict[@"num_attr"]) {
        self.giftNumLabel.attributedText = [self loadGiftNumAttr:giftDict];
//    } else {
//        NSLog(@"load num attr cache");
//        if (self.giftNumLabel) {
//            self.giftNumLabel.attributedText = giftDict[@"num_attr"];
//        }
//    }
}

#pragma mark - 加载数字属性
- (NSMutableAttributedString *) loadGiftNumAttr:(NSDictionary *)giftDict
{
    int giftNum = [giftDict[@"gift_nums"] intValue];
    if (giftNum >= 100000)
    {
        giftNum = 99999;
    }
    
    NSInteger giftNumLength = [NSString stringWithFormat:@"%d",giftNum].length;
    
    NSString *sendGiftNumStr = [NSString stringWithFormat:@"X%d",giftNum];
    NSMutableAttributedString * mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:sendGiftNumStr];
    
    UIImage *giftNumIcon = [UIImage imageNamed:@"image/liveroom/img_no_2_x"];
    
    NSTextAttachment *giftXAttachment = [[NSTextAttachment alloc] init];
    giftXAttachment.image = giftNumIcon;
    NSAttributedString *giftXAttributedString = [NSAttributedString attributedStringWithAttachment:giftXAttachment];
    [mutableAttributedString replaceCharactersInRange:NSMakeRange(0, 1) withAttributedString:giftXAttributedString];
    
    
    switch (giftNumLength) {
        case 1:
        {
            UIImage *giftNumIcon = [UIImage imageNamed:[NSString stringWithFormat:@"image/liveroom/img_no_2_%d",giftNum]];
            
            NSTextAttachment *giftXAttachment = [[NSTextAttachment alloc] init];
            giftXAttachment.image = giftNumIcon;
            NSAttributedString *giftXAttributedString = [NSAttributedString attributedStringWithAttachment:giftXAttachment];
            [mutableAttributedString replaceCharactersInRange:NSMakeRange(sendGiftNumStr.length-1, 1) withAttributedString:giftXAttributedString];
            
        }
            break;
        case 2:
        {
            int firstNum = [[sendGiftNumStr substringWithRange:NSMakeRange(1,1)] intValue];
            int secondNum = [[sendGiftNumStr substringWithRange:NSMakeRange(2,1)] intValue];
            
            UIImage *giftNumIcon = [UIImage imageNamed:[NSString stringWithFormat:@"image/liveroom/img_no_2_%d",firstNum]];
            
            NSTextAttachment *giftXAttachment = [[NSTextAttachment alloc] init];
            giftXAttachment.image = giftNumIcon;
            NSAttributedString *giftXAttributedString = [NSAttributedString attributedStringWithAttachment:giftXAttachment];
            [mutableAttributedString replaceCharactersInRange:NSMakeRange(sendGiftNumStr.length-2, 1) withAttributedString:giftXAttributedString];
            
            
            UIImage *giftSecondNumIcon = [UIImage imageNamed:[NSString stringWithFormat:@"image/liveroom/img_no_2_%d",secondNum]];
            
            NSTextAttachment *giftSecondAttachment = [[NSTextAttachment alloc] init];
            giftSecondAttachment.image = giftSecondNumIcon;
            NSAttributedString *giftSecondAttributedString = [NSAttributedString attributedStringWithAttachment:giftSecondAttachment];
            [mutableAttributedString replaceCharactersInRange:NSMakeRange(sendGiftNumStr.length-1, 1) withAttributedString:giftSecondAttributedString];
        }
            break;
        case 3:
        {
            int firstNum = [[sendGiftNumStr substringWithRange:NSMakeRange(1,1)] intValue];
            int secondNum = [[sendGiftNumStr substringWithRange:NSMakeRange(2,1)] intValue];
            int threeNum = [[sendGiftNumStr substringWithRange:NSMakeRange(3,1)] intValue];
            
            UIImage *giftNumIcon = [UIImage imageNamed:[NSString stringWithFormat:@"image/liveroom/img_no_2_%d",firstNum]];
            
            NSTextAttachment *giftXAttachment = [[NSTextAttachment alloc] init];
            giftXAttachment.image = giftNumIcon;
            NSAttributedString *giftXAttributedString = [NSAttributedString attributedStringWithAttachment:giftXAttachment];
            [mutableAttributedString replaceCharactersInRange:NSMakeRange(sendGiftNumStr.length-3, 1) withAttributedString:giftXAttributedString];
            
            
            UIImage *giftSecondNumIcon = [UIImage imageNamed:[NSString stringWithFormat:@"image/liveroom/img_no_2_%d",secondNum]];
            
            NSTextAttachment *giftSecondAttachment = [[NSTextAttachment alloc] init];
            giftSecondAttachment.image = giftSecondNumIcon;
            NSAttributedString *giftSecondAttributedString = [NSAttributedString attributedStringWithAttachment:giftSecondAttachment];
            [mutableAttributedString replaceCharactersInRange:NSMakeRange(sendGiftNumStr.length-2, 1) withAttributedString:giftSecondAttributedString];
            
            UIImage *giftThreeNumIcon = [UIImage imageNamed:[NSString stringWithFormat:@"image/liveroom/img_no_2_%d",threeNum]];
            
            NSTextAttachment *giftThreeAttachment = [[NSTextAttachment alloc] init];
            giftThreeAttachment.image = giftThreeNumIcon;
            NSAttributedString *giftThreeAttributedString = [NSAttributedString attributedStringWithAttachment:giftThreeAttachment];
            [mutableAttributedString replaceCharactersInRange:NSMakeRange(sendGiftNumStr.length-1, 1) withAttributedString:giftThreeAttributedString];
        }
            break;
        case 4:
        {
            int firstNum = [[sendGiftNumStr substringWithRange:NSMakeRange(1,1)] intValue];
            int secondNum = [[sendGiftNumStr substringWithRange:NSMakeRange(2,1)] intValue];
            int threeNum = [[sendGiftNumStr substringWithRange:NSMakeRange(3,1)] intValue];
            int fourNum = [[sendGiftNumStr substringWithRange:NSMakeRange(4,1)] intValue];
            
            UIImage *giftNumIcon = [UIImage imageNamed:[NSString stringWithFormat:@"image/liveroom/img_no_2_%d",firstNum]];
            
            NSTextAttachment *giftXAttachment = [[NSTextAttachment alloc] init];
            giftXAttachment.image = giftNumIcon;
            NSAttributedString *giftXAttributedString = [NSAttributedString attributedStringWithAttachment:giftXAttachment];
            [mutableAttributedString replaceCharactersInRange:NSMakeRange(sendGiftNumStr.length-4, 1) withAttributedString:giftXAttributedString];
            
            
            UIImage *giftSecondNumIcon = [UIImage imageNamed:[NSString stringWithFormat:@"image/liveroom/img_no_2_%d",secondNum]];
            
            NSTextAttachment *giftSecondAttachment = [[NSTextAttachment alloc] init];
            giftSecondAttachment.image = giftSecondNumIcon;
            NSAttributedString *giftSecondAttributedString = [NSAttributedString attributedStringWithAttachment:giftSecondAttachment];
            [mutableAttributedString replaceCharactersInRange:NSMakeRange(sendGiftNumStr.length-3, 1) withAttributedString:giftSecondAttributedString];
            
            UIImage *giftThreeNumIcon = [UIImage imageNamed:[NSString stringWithFormat:@"image/liveroom/img_no_2_%d",threeNum]];
            
            NSTextAttachment *giftThreeAttachment = [[NSTextAttachment alloc] init];
            giftThreeAttachment.image = giftThreeNumIcon;
            NSAttributedString *giftThreeAttributedString = [NSAttributedString attributedStringWithAttachment:giftThreeAttachment];
            [mutableAttributedString replaceCharactersInRange:NSMakeRange(sendGiftNumStr.length-2, 1) withAttributedString:giftThreeAttributedString];
            
            UIImage *giftFourNumIcon = [UIImage imageNamed:[NSString stringWithFormat:@"image/liveroom/img_no_2_%d",fourNum]];
            
            NSTextAttachment *giftFourAttachment = [[NSTextAttachment alloc] init];
            giftFourAttachment.image = giftFourNumIcon;
            NSAttributedString *giftFourAttributedString = [NSAttributedString attributedStringWithAttachment:giftFourAttachment];
            [mutableAttributedString replaceCharactersInRange:NSMakeRange(sendGiftNumStr.length-1, 1) withAttributedString:giftFourAttributedString];
            
        }
            break;
        case 5:
        {
            int firstNum = [[sendGiftNumStr substringWithRange:NSMakeRange(1,1)] intValue];
            int secondNum = [[sendGiftNumStr substringWithRange:NSMakeRange(2,1)] intValue];
            int threeNum = [[sendGiftNumStr substringWithRange:NSMakeRange(3,1)] intValue];
            int fourNum = [[sendGiftNumStr substringWithRange:NSMakeRange(4,1)] intValue];
            int fiveNum = [[sendGiftNumStr substringWithRange:NSMakeRange(5,1)] intValue];
            UIImage *giftNumIcon = [UIImage imageNamed:[NSString stringWithFormat:@"image/liveroom/img_no_2_%d",firstNum]];
            
            NSTextAttachment *giftXAttachment = [[NSTextAttachment alloc] init];
            giftXAttachment.image = giftNumIcon;
            NSAttributedString *giftXAttributedString = [NSAttributedString attributedStringWithAttachment:giftXAttachment];
            [mutableAttributedString replaceCharactersInRange:NSMakeRange(sendGiftNumStr.length-5, 1) withAttributedString:giftXAttributedString];
            
            
            UIImage *giftSecondNumIcon = [UIImage imageNamed:[NSString stringWithFormat:@"image/liveroom/img_no_2_%d",secondNum]];
            
            NSTextAttachment *giftSecondAttachment = [[NSTextAttachment alloc] init];
            giftSecondAttachment.image = giftSecondNumIcon;
            NSAttributedString *giftSecondAttributedString = [NSAttributedString attributedStringWithAttachment:giftSecondAttachment];
            [mutableAttributedString replaceCharactersInRange:NSMakeRange(sendGiftNumStr.length-4, 1) withAttributedString:giftSecondAttributedString];
            
            UIImage *giftThreeNumIcon = [UIImage imageNamed:[NSString stringWithFormat:@"image/liveroom/img_no_2_%d",threeNum]];
            
            NSTextAttachment *giftThreeAttachment = [[NSTextAttachment alloc] init];
            giftThreeAttachment.image = giftThreeNumIcon;
            NSAttributedString *giftThreeAttributedString = [NSAttributedString attributedStringWithAttachment:giftThreeAttachment];
            [mutableAttributedString replaceCharactersInRange:NSMakeRange(sendGiftNumStr.length-3, 1) withAttributedString:giftThreeAttributedString];
            
            UIImage *giftFourNumIcon = [UIImage imageNamed:[NSString stringWithFormat:@"image/liveroom/img_no_2_%d",fourNum]];
            
            NSTextAttachment *giftFourAttachment = [[NSTextAttachment alloc] init];
            giftFourAttachment.image = giftFourNumIcon;
            NSAttributedString *giftFourAttributedString = [NSAttributedString attributedStringWithAttachment:giftFourAttachment];
            [mutableAttributedString replaceCharactersInRange:NSMakeRange(sendGiftNumStr.length-2, 1) withAttributedString:giftFourAttributedString];
            
            UIImage *giftFiveNumIcon = [UIImage imageNamed:[NSString stringWithFormat:@"image/liveroom/img_no_2_%d",fiveNum]];
            
            NSTextAttachment *giftFiveAttachment = [[NSTextAttachment alloc] init];
            giftFiveAttachment.image = giftFiveNumIcon;
            NSAttributedString *giftFiveAttributedString = [NSAttributedString attributedStringWithAttachment:giftFiveAttachment];
            [mutableAttributedString replaceCharactersInRange:NSMakeRange(sendGiftNumStr.length-1, 1) withAttributedString:giftFiveAttributedString];
            
        }
            break;
        default:
            break;
    }
    
    return mutableAttributedString;
}
@end
