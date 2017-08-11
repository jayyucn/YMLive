//
//  LCCancelAndOKView.m
//  XCLive
//
//  Created by ztkztk on 14-4-17.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCCancelAndOKView.h"

@implementation LCCancelAndOKView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.shouldDismissWhenTouchsAnywhere=NO;
        self.autoDismissTimeInterval=0;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,200,30)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor=[UIColor blackColor];
        _titleLabel.font=[UIFont boldSystemFontOfSize:20];
        _titleLabel.backgroundColor =[UIColor clearColor];
        [self.backgroundView addSubview:_titleLabel];
        _titleLabel.centerX=LCAlertViewWidth/2;
        
        
        _cancelBtn = [ESButton buttonWithTitle:@"取消" buttonColor:ESButtonColorRed];
        _cancelBtn.frame=CGRectMake(0,0,100,40);
        _OKBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
//        [_OKBtn sizeToFit];
        [_cancelBtn addTarget:self
                      action:@selector(cancelAction)
            forControlEvents:UIControlEventTouchUpInside];
        [self.backgroundView addSubview:_cancelBtn];
        _cancelBtn.centerX=LCAlertViewWidth/4;
        
         UIImage *image = [UIImage imageNamed:@"adClose"];
        _addCoseBtn=[[UIImageView alloc] init];
        _addCoseBtn.image = image;
        _addCoseBtn.width = image.size.width;
        _addCoseBtn.height = image.size.height;
        
        _addCoseBtn.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAction)];
        [_addCoseBtn addGestureRecognizer:singleTap];

        [self.backgroundView addSubview:_addCoseBtn];
        _addCoseBtn.centerX = LCAlertViewWidth - 10;
        _addCoseBtn.centerY = 10;
        
        _addCoseBtn.hidden = YES;
        
        /*
         
        [_cancelBtn setTitleColor:[UIColor whiteColor]
                        forState:UIControlStateNormal];
        
        
        [_cancelBtn setBackgroundImage:[[UIImage imageNamed:@"image/actionsheet/actionsheet_button"] stretchableImageWithLeftCapWidth:19 topCapHeight:0] forState:UIControlStateNormal];
         
         */
        
        _OKBtn = [ESButton buttonWithTitle:@"确定" buttonColor:ESButtonColorRed];
        _OKBtn.size = CGSizeMake(100,40);
        _OKBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
//        [_OKBtn sizeToFit];
//        [_OKBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_OKBtn addTarget:self
                  action:@selector(okAction)
        forControlEvents:UIControlEventTouchUpInside];
        [self.backgroundView addSubview:_OKBtn];
        _OKBtn.centerX=LCAlertViewWidth*3/4;
        
        /*
        [_OKBtn setTitleColor:[UIColor whiteColor]
                    forState:UIControlStateNormal];
        
        [_OKBtn setBackgroundImage:[[UIImage imageNamed:@"image/actionsheet/actionsheet_button"] stretchableImageWithLeftCapWidth:19 topCapHeight:0] forState:UIControlStateNormal];
         */


    }
    return self;
}



-(void)setTitle:(NSString *)title{
    self.titleLabel.text=title;
}

- (void)layoutSubviews
{
    UIView *aView=(UIView *)self.editView;
    aView.top=self.titleLabel.bottom+5.0f;
    self.OKBtn.top=aView.bottom+5;
    self.cancelBtn.top=aView.bottom+5;
    self.height=self.cancelBtn.bottom+5;
    self.backgroundView.height=self.height;
    
    const CGFloat padding = 5.0;
    CGRect backgroundFrame = self.backgroundView.frame;
    CGRect frame = backgroundFrame;
    frame.size.width = 2 * padding + backgroundFrame.size.width;
    frame.size.height = 2 * padding + backgroundFrame.size.height;
    frame.origin.x = floorf((self.screenSize.width - frame.size.width) / 2.0);
    frame.origin.y = floorf((self.screenSize.height - frame.size.height) / 2.0) - 30.0;
    self.frame = frame;
    backgroundFrame.origin.x = backgroundFrame.origin.y = padding;
    self.backgroundView.frame = backgroundFrame;
    
    self.top=self.top-_offsetY;
    
}



-(void)cancelAction
{
    [self dismissWithAnimated];
}

-(void)okAction
{
    [self dismissWithAnimated];
    [self submitAction];
    
    
}

-(void)submitAction
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
