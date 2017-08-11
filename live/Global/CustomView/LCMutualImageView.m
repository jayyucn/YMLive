//
//  LCUserInterImageView.m
//  XCLive
//
//  Created by ztkztk on 14-4-22.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCMutualImageView.h"

@implementation LCMutualImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(tapAction:)];
        tap.delegate=self;
        
        [self addGestureRecognizer:tap];
        
        UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handleLongPressGestures:)];
        //longPress.numberOfTouchesRequired = 2;
        
       // [longPress requireGestureRecognizerToFail:tap];

       
        //longPress.allowableMovement = 100.0f;
        //longPress.minimumPressDuration = 1.0;
        [self addGestureRecognizer:longPress];
    }
    return self;
}




-(void)tapAction:(UIGestureRecognizer*)sender{
    NSLog(@"tapAction");
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        //_singleTapBlock(_photoDic);
        [self tapAction];
    }
    
}

-(void)tapAction
{
    
}

- (void) handleLongPressGestures:(UILongPressGestureRecognizer *)paramSender{
    //_longPressBlock(_photoDic);
    
    if (paramSender.state == UIGestureRecognizerStateBegan)
    {
        //_singleTapBlock(_photoDic);
        [self longPress];
    }

    
}

-(void)longPress
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
