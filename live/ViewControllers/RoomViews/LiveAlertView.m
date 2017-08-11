//
//  LiveAlertView.m
//  live
//
//  Created by hysd on 15/8/21.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import "LiveAlertView.h"
#import "Macro.h"
@interface LiveAlertView(){
    UIView* mBackgroundView;
    UIWindow *mOriginalWindow;
    LiveAlertConfirm confirmBlock;
    LiveAlertCancel cancelBlock;
    
    __weak LiveUser *_observUser;
}
@end
@implementation LiveAlertView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib
{
    
        self.layer.cornerRadius = 5;
        self.backgroundColor = RGB16(COLOR_BG_WHITE);
        self.clipsToBounds = YES;
        self.contentLabel.textColor = RGB16(COLOR_FONT_BLACK);
        self.contentLabel.numberOfLines = 0;
        
        self.confirmButton.backgroundColor = RGB16(COLOR_BG_WHITE);
        [self.confirmButton setTitleColor:RGB16(COLOR_FONT_GRAY) forState:UIControlStateNormal];
        
        self.cancelButton.backgroundColor = RGB16(COLOR_BG_WHITE);
        [self.cancelButton setTitleColor:RGB16(COLOR_FONT_RED) forState:UIControlStateNormal];
        
        self.sepHView.backgroundColor = RGB16(COLOR_BG_LIGHTGRAY);
        self.sepVView.backgroundColor = RGB16(COLOR_BG_LIGHTGRAY);
        
        CGRect rect = [UIScreen mainScreen].bounds;
        mOriginalWindow = [[UIWindow alloc] initWithFrame:rect];
        mOriginalWindow.windowLevel = UIWindowLevelAlert;
        
        mBackgroundView  = [[UIView alloc] initWithFrame:rect];
        mBackgroundView.alpha = 0.4;
        mBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
        mBackgroundView.backgroundColor = [UIColor blackColor];
        mBackgroundView.center = mOriginalWindow.center;
        
        [mOriginalWindow addSubview:mBackgroundView];
        [mOriginalWindow addSubview:self];
        [mOriginalWindow makeKeyAndVisible];
        //        [mOriginalWindow resignKeyWindow];
}

- (void)showTitle:(NSString*)title confirmTitle:(NSString*)conTitle cancelTitle:(NSString*)canTitle confirm:(LiveAlertConfirm)confirm cancel:(LiveAlertCancel)cancel
{
    self.contentLabel.text = title;
    [self.confirmButton setTitle:conTitle forState:UIControlStateNormal];
    [self.cancelButton setTitle:canTitle forState:UIControlStateNormal];
    CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
    self.center = mOriginalWindow.center;
    confirmBlock = confirm;
    cancelBlock = cancel;
    
    self.alpha=0;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha=1;
    } completion:^(BOOL finished) {
    }];
}


- (IBAction)confirmAction:(id)sender
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha=0;
    } completion:^(BOOL finished) {
        if (confirmBlock)
        {
            confirmBlock();
        }
        [self removeFromSuperview];
        [mBackgroundView removeFromSuperview];
        [[AppDelegate sharedAppDelegate] makeSelfVisible];
        mOriginalWindow = nil;
    }];
}

- (IBAction)cancelAction:(id)sender
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha=0;
    } completion:^(BOOL finished) {
        if (cancelBlock) {
            cancelBlock();
        }
        [self removeFromSuperview];
        [mBackgroundView removeFromSuperview];
        [[AppDelegate sharedAppDelegate] makeSelfVisible];
        mOriginalWindow = nil;
    }];
}

- (void)addInviteUser:(LiveUser *)user
{
    _observUser = user;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onInviteUserExit:) name:@"CancelInviteUserNotification" object:nil];
    
}

- (void)onInviteUserExit:(NSNotification *)notification
{
    LiveUser *user = (LiveUser *)notification.object;
    
    if ([user.userId isEqualToString:_observUser.userId])
    {
        [self cancelAction:nil];
    }
}
@end
