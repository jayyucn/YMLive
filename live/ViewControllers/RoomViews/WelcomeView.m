//
//  WelcomeView.m
//  live
//
//  Created by hysd on 15/7/28.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import "WelcomeView.h"
#import "Macro.h"
#define MARGIN_Y 8
#define MARGIN_X 8
#define SEPERATOR_HEIGHT 5

@interface WelcomeView(){
    UILabel* messageLabel;
}
@end
@implementation WelcomeView
- (id)initWithFrame:(CGRect)frame andName:(NSString*)name{
    self = [super init];
    if(self){
        self.backgroundColor = RGB16(COLOR_BG_WHITE);
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        //消息
        messageLabel = [[UILabel alloc] init];
        messageLabel.text = [NSString stringWithFormat:@"欢迎 %@",name];
        messageLabel.font = [UIFont fontWithName:@"Times New Roman" size:14];
        messageLabel.textColor = RGB16(COLOR_FONT_BLACK);
        messageLabel.numberOfLines = 0;
        self.date = [NSDate date];
        //计算消息宽高
        CGSize messageSize = [messageLabel.text boundingRectWithSize:CGSizeMake(frame.size.width-2*MARGIN_X, frame.size.height) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: messageLabel.font} context:nil].size;
        [self addSubview:messageLabel];
        
        CGFloat messageViewWidth = messageSize.width+2*MARGIN_X;
        CGFloat messageViewHeight = messageSize.height+2*MARGIN_Y;
        messageLabel.frame = CGRectMake(MARGIN_X, MARGIN_Y,messageSize.width, messageSize.height);
        self.frame = CGRectMake(0, frame.size.height, messageViewWidth, messageViewHeight);
    }
    return self;
}

@end
