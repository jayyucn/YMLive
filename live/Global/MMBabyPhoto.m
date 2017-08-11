//
//  MMBabyPhoto.m
//  MaMaTao
//
//  Created by ztkztk on 14-8-18.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "MMBabyPhoto.h"
#import "LCMyUser.h"


@implementation MMBabyPhoto

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       
        _photoImage=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,120,120)];
        _photoImage.image=[UIImage imageNamed:@"image/reg/reg_upload_btn.png"];
        [self addSubview:_photoImage];
        _photoImage.layer.cornerRadius = 4;
        _photoImage.layer.masksToBounds = YES;
        
        self.userInteractionEnabled=YES;
        _photoImage.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(tapAction:)];
        tap.delegate=self;
        
        [_photoImage addGestureRecognizer:tap];

        
        /*
        _photoBtn=[UIButton buttonWithType:UIButtonTypeSystem];
        _photoBtn.frame=CGRectMake(0,0,80,80);
        [_photoBtn addTarget:self
                       action:@selector(tapAction)
             forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_photoBtn];
        
        _photoBtn.backgroundColor=[UIColor clearColor];
        _photoImage.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        _photoBtn.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
         */
        _photoImage.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        
    }
    return self;
}


-(void)showImage
{
    [_photoImage sd_setImageWithURL:[NSURL URLWithString:[LCMyUser mine].faceURL]
                  placeholderImage:UIImageFromCache(@"image/globle/placeholder")];
}

-(void)tapAction:(UIGestureRecognizer*)sender
{
    NSLog(@"tapAction");
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        _babyPhotoBlock();

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
