//
//  LCPhotoImageView.m
//  XCLive
//
//  Created by ztkztk on 14-5-12.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCPhoto.h"

@implementation LCPhoto

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // Initialization code
        
        self.backgroundColor=[UIColor colorWithRed:30.0/255 green:30.0/255 blue:30.0/255 alpha:1.0];
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        [self.layer setBorderWidth:2];
        [self.layer setBorderColor:(__bridge CGColorRef)([UIColor whiteColor])];
        self.contentMode = UIViewContentModeScaleToFill;
        
        
      
        
        _moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,self.height-20,self.width,20)];
        _moreLabel.textAlignment = NSTextAlignmentCenter;
        _moreLabel.textColor=[UIColor whiteColor];
        _moreLabel.font=[UIFont systemFontOfSize:13];
        _moreLabel.backgroundColor =[UIColor blackColor];
        _moreLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_moreLabel];
        _moreLabel.text=@"查看更多";
        _moreLabel.alpha=0.7;
        _moreLabel.hidden=YES;

        
        
        self.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(tapAction:)];
        tap.delegate=self;
        
        [self addGestureRecognizer:tap];


    }
    return self;
}

-(void)cleanView
{
    _photoDic=nil;
    _moreLabel.hidden=YES;
}

-(void)setPhotoDic:(NSDictionary *)photoDic
{
    _photoDic = photoDic;
    
    if(_photoDic)
    {
        NSString *idStr = NSStringWith(@"%@",photoDic[@"id"]);
        
        if([idStr isEqualToString:@"0"])
        {
            self.image = [UIImage imageNamed:photoDic[@"url"]];
        }
        else
        {
            NSString *imageURL=[NSString faceURLString:photoDic[@"url"]];
            [self sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:UIImageFromCache(@"image/globle/placeholder")];
        }

    }else
    {
        self.image=nil;
    }
}

-(void)tapAction:(UIGestureRecognizer*)sender
{
    NSLog(@"tapAction");
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_LookPhoto
                                                                object:nil
                                                              userInfo:_photoDic];
    }
}

- (void)inviteUserUpdatePhoto
{
    
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
