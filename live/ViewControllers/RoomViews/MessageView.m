//
//  MessageView.m
//  live
//
//  Created by hysd on 15/7/22.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import "MessageView.h"
#import "Macro.h" 
#import "UIImage+Category.h"

@implementation MessageView

- (id)initWithView:(UIView*)view message:(NSString*)message user:(LiveUser *)user liver:(BOOL)liver
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"MessageView" owner:self options:nil] lastObject];
    
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        //头像
        self.logoImageView.layer.cornerRadius = self.logoImageView.frame.size.height/2;
        self.logoImageView.clipsToBounds = YES;
        self.logoImageView.layer.borderWidth = 1;
        self.logoImageView.layer.borderColor = RGB16(COLOR_BG_WHITE).CGColor;
        
//        NSInteger width = self.logoImageView.frame.size.width*SCALE;
        NSString *logo = user.userLogo;
        if(!logo)
        {
            self.logoImageView.image = [UIImage imageNamed:@"default_head"];
        }
        else
        {
            [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString faceURLString:user.userLogo]] placeholderImage:[UIImage imageWithColor:RGB16(COLOR_FONT_WHITE) andSize:self.logoImageView.frame.size]];
        }
        
        
        //消息背景
        self.messageView.backgroundColor = RGB16(COLOR_BG_WHITE);
        self.messageView.layer.cornerRadius = 3;
        //消息
        self.messageLabel.text = message;
        self.messageLabel.textColor = RGB16(COLOR_FONT_BLACK);
        self.messageLabel.preferredMaxLayoutWidth = view.frame.size.width-self.logoImageView.frame.size.width-10;
        self.date = [NSDate date];
        [view addSubview:self];
        CGSize size = [self systemLayoutSizeFittingSize:view.frame.size];
        self.frame = CGRectMake(0, view.frame.size.height, size.width, size.height);
        
        //是否为主播
        if(liver)
        {
            self.logoImageView.layer.borderColor = RGB16(COLOR_BG_RED).CGColor;
            self.messageView.backgroundColor = RGB16(COLOR_BG_RED);
            self.messageLabel.textColor = RGB16(COLOR_FONT_WHITE);
        }
    }
    return self;
}

@end
