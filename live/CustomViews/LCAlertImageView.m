//
//  LCAlertImageView.m
//  XCLive
//
//  Created by ztkztk on 14-6-19.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "LCAlertImageView.h"
#import "NSString+ManageFaceURLString.h"

@implementation LCAlertImageView

+(void)showAlertImage:(NSDictionary *)imageDic
            withBlock:(AlertImageOKBlock)alertImageBlock
{
    LCAlertImageView *alertImage=[[LCAlertImageView alloc] init];
    alertImage.imageDic=imageDic;
    alertImage.alertImageBlock=alertImageBlock;
    [alertImage showWithAnimated];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"%@",self.imageDic);
        self.titleLabel.text=@"与她分享此夫妻相";
        _imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,200,200)];
        [self.backgroundView addSubview:_imageView];
        _imageView.centerX=self.backgroundView.width/2;
        self.editView=_imageView;
    }
    return self;
}


-(void)setImageDic:(NSDictionary *)imageDic
{
    _imageDic=imageDic;
     NSLog(@"setImageDic %@",self.imageDic);
    if (ESIsStringWithAnyText([imageDic[@"percent"] stringValue]))
    {
        if ([imageDic[@"percent"] intValue] > 70) {
            self.titleLabel.text = @"哇塞，很有夫妻相呀，赶紧分享给Ta";
        } else if([imageDic[@"percent"] intValue] > 60){
            self.titleLabel.text = @"还真的挺像的呀，赶快发给Ta";
        } else if([imageDic[@"percent"] intValue] > 50){
            self.titleLabel.text = @"感觉像吗？没看出来呀";
        } else {
            self.titleLabel.text = @"我们真的没缘吗？发给Ta";
        }
    }
    
    self.titleLabel.font=[UIFont boldSystemFontOfSize:14];
  
    [self.OKBtn setTitle:@"与Ta分享" forState:UIControlStateNormal];
 
    self.OKBtn.centerX=LCAlertViewWidth/2;
    self.cancelBtn.hidden = YES;
    self.addCoseBtn.hidden = NO;
    NSString *imageURL=[NSString faceURLString:imageDic[@"url"]];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:UIImageFromCache(@"image/globle/placeholder")];

}



-(void)submitAction
{
    _alertImageBlock(_imageDic);
}

/*

-(void)shareWithHer:(NSDictionary *)dic
{
    NSDictionary *data=@{@"type":@(LCChatMessageTypePicture),\
                         @"data":dic
                         };
    
    [LCMessageListViewController sendChatMessage:data toUser:self.matchUser[@"uid"]];
    
}
 
 */


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
