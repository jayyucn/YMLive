//
//  LCMyPhotoView.m
//  XCLive
//
//  Created by ztkztk on 14-4-22.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCMyPhotoView.h"

@implementation LCMyPhotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)setPhotoDic:(NSDictionary *)photoDic
{
    _photoDic=photoDic;
    
    NSString *imageURL=[NSString faceURLString:_photoDic[@"url"]];
    [self sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:UIImageFromCache(@"image/globle/placeholder")];
//    ESWeak(self, weakPortraitView);
//    [self setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageURL]]
//                placeholderImage:[UIImage imageNamed:@"image/globle/placeholder"]
//                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
//                             ESStrong(weakPortraitView, strongPortraitView);
//                             if (strongPortraitView)
//                                 strongPortraitView.image = image;
//                             
//                             
//                         }
//                         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
//                             
//                         }];
    
    
}


-(void)tapAction
{
    self.singleTapBlock(_photoDic);
}
-(void)longPress
{
    //self.longPressBlock(_photoDic);
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
