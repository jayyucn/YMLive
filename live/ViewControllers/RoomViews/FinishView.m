//
//  FinishView.m
//  live
//
//  Created by hysd on 15/8/23.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import "FinishView.h"
#import "Macro.h"
@interface FinishView(){
}
@end;
@implementation FinishView

- (id)init{
    self  = [[[NSBundle mainBundle] loadNibNamed:@"FinishView" owner:self options:nil] lastObject];
    if(self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.titleLabel.textColor = RGB16(COLOR_FONT_BLACK);
        self.sepView.backgroundColor = RGB16(COLOR_BG_RED);
        self.audienceLabel.textColor = RGB16(COLOR_FONT_DARKGRAY);
        self.audienceNumLabel.textColor = RGB16(COLOR_FONT_BLACK);
        self.praiseLabel.textColor = RGB16(COLOR_FONT_DARKGRAY);
        self.praiseNumLabel.textColor = RGB16(COLOR_FONT_BLACK);
        [self.closeButton setTitleColor:RGB16(COLOR_FONT_RED) forState:UIControlStateNormal];
        self.closeButton.backgroundColor = RGB16(COLOR_BG_WHITE);
        self.closeButton.layer.cornerRadius = self.closeButton.frame.size.height/2;
        self.closeButton.layer.borderColor = RGB16(COLOR_BG_RED).CGColor;
        self.closeButton.layer.borderWidth = 1;
    }
    return self;
}
- (void)showView:(UIView*)superView audience:(NSString*)audience praise:(NSString*)praise{
    self.audienceNumLabel.text = audience;
    self.praiseNumLabel.text = praise;
    [superView addSubview:self];
    self.alpha=0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=1;
    } completion:^(BOOL finished) {
    }];
}
- (IBAction)closeAction:(id)sender {
    if(self.delegate){
        [self.delegate finishViewClose:self];
    }
}
@end
