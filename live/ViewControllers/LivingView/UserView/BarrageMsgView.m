//
//  BarrageMsgView.m
//  qianchuo
//
//  Created by jacklong on 16/3/11.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "BarrageMsgView.h"

@implementation BarrageMsgView

- (void)dealloc
{
    NSLog(@"dealloc %@",NSStringFromClass(self.class));
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) { 
        _sendNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.height+10, 0, frame.size.width, frame.size.height/2)];
        _sendNameLabel.textAlignment = NSTextAlignmentLeft;
        _sendNameLabel.font = [UIFont systemFontOfSize:13.f];
        _sendNameLabel.textColor =  ColorPink;
        [self addSubview:_sendNameLabel];
    
        _bgContentView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.height/2, _sendNameLabel.bottom, frame.size.width - 20, frame.size.height/2)];
        _bgContentView.backgroundColor = RGBA16(0x30000000);
        UIBezierPath *showPath = [UIBezierPath bezierPathWithRoundedRect:_bgContentView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(frame.size.height/4, frame.size.height/4)];
        CAShapeLayer *showLayer = [[CAShapeLayer alloc] init];
        showLayer.frame = _bgContentView.bounds;
        showLayer.path = showPath.CGPath;
        _bgContentView.layer.mask = showLayer;
        [self addSubview:_bgContentView];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.height/2+10, 0, frame.size.width-frame.size.height/2-10, self.frame.size.height/2)];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.font = [UIFont boldSystemFontOfSize:14.f];
        _contentLabel.textColor =  [UIColor whiteColor];
        [_bgContentView addSubview:_contentLabel];
        
        _sendFaceImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.height)];
        _sendFaceImg.layer.borderWidth = 0.5f;
        _sendFaceImg.layer.borderColor = ColorPink.CGColor;
        _sendFaceImg.layer.cornerRadius = _sendFaceImg.frame.size.width/2;
        _sendFaceImg.clipsToBounds = YES;
        _sendFaceImg.image = [UIImage imageNamed:@"default_head"];
        _sendFaceImg.userInteractionEnabled = YES;
        [self addSubview:_sendFaceImg];
        
        
        UIImage *flagImg = [UIImage imageNamed:@"image/yonghu/grade_flag/grade_flag_1"];
        _gradeFlagImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_sendFaceImg.width-flagImg.size.width*3/4, _sendFaceImg.height-flagImg.size.height, flagImg.size.width, flagImg.size.height)];
        _gradeFlagImgView.image = flagImg;
        [self addSubview:_gradeFlagImgView];
    }
    return self;
}

#pragma mark - 设置弹幕的内容
- (void) setBarrageInfoDict:(NSDictionary *)barrageInfoDict
{
    _barrageInfoDict = barrageInfoDict;
    NSString *faceString=[NSString faceURLString:barrageInfoDict[@"face"]];
    [_sendFaceImg sd_setImageWithURL:[NSURL URLWithString:faceString] placeholderImage:[UIImage imageNamed:@"default_head"]];

    int grade = ESIntValue(barrageInfoDict[@"grade"]);
    if (grade > 0) {
        _gradeFlagImgView.image = [UIImage createUserGradeFlagImage:grade withIsManager:(barrageInfoDict[@"offical"] && [barrageInfoDict[@"offical"] intValue] == 1)?true:false];
        _gradeFlagImgView.hidden = NO;
    } else {
        _gradeFlagImgView.hidden = YES;
    }

    
    _sendNameLabel.text = barrageInfoDict[@"nickname"];
    _contentLabel.text = barrageInfoDict[@"chat_msg"];
}

#pragma mark - 计算内容的宽度
- (float) getContentWidth
{
    if (!_barrageInfoDict) {
        return 0;
    }
    CGSize contentSize = [_barrageInfoDict[@"chat_msg"] sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}];
    CGSize nicknameSize = [_barrageInfoDict[@"nickname"] sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}];
    
//    NSLog(@"contentSize:%@ nickname:%@",NSStringFromCGSize(contentSize),NSStringFromCGSize(nicknameSize));
    
    if (nicknameSize.width > contentSize.width) {
        return  nicknameSize.width;
    }
   
    return contentSize.width;
}

#pragma mark - 动态改变内容的宽度
- (void) layoutSubviews
{
    if ([self getContentWidth] > 0)
    {
        if ([self getContentWidth] >= ScreenWidth)
        {
            _bgContentView.width = [self getContentWidth] + _sendFaceImg.width/2+10;
            _contentLabel.width = [self getContentWidth];
        }
        else
        {
            _bgContentView.width = _sendFaceImg.right/2+10 + [self getContentWidth]+10;
        }
    }
    
    _bgContentView.backgroundColor = RGBA16(0x30000000);
    UIBezierPath *showPath = [UIBezierPath bezierPathWithRoundedRect:_bgContentView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(self.frame.size.height/4, self.frame.size.height/4)];
    CAShapeLayer *showLayer = [[CAShapeLayer alloc] init];
    showLayer.frame = _bgContentView.bounds;
    showLayer.path = showPath.CGPath;
    _bgContentView.layer.mask = showLayer;

}

@end
