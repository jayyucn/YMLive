//
//  PushParamView.m
//  live
//
//  Created by wilderliao on 15/10/19.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import "PushParamView.h"
#import "Macro.h"
#import "Common.h"
//#import <ImSDK/IMSdkComm.h>

enum MENUITEMINDEX {
    SDKTYPE_NORMAL = 0,    //普通开发SDK业务
    SDKTYPE_IOTCamera,     //普通物联网摄像头SDK业务
    SDKTYPE_COASTCamera    //滨海摄像头SDK业务
};

@implementation PushParamView
{
    PushConfirm confirmBlock;
    PushCancel cancelBlock;
    UIView* mBackgroundView;
    UIWindow *mOriginalWindow;
}

- (void)awakeFromNib
{

        self.backgroundColor = RGB16(COLOR_BG_WHITE);
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        
        self.confirmButton.backgroundColor = RGB16(COLOR_BG_WHITE);
        [self.confirmButton setTitleColor:RGB16(COLOR_FONT_RED) forState:UIControlStateNormal];
        self.confirmButton.layer.cornerRadius = self.confirmButton.frame.size.height/2;
        self.confirmButton.layer.borderWidth = 1;
        self.confirmButton.layer.borderColor = RGB16(COLOR_BG_RED).CGColor;
        
        self.cancelButton.backgroundColor = RGB16(COLOR_BG_RED);
        [self.cancelButton setTitleColor:RGB16(COLOR_BG_WHITE) forState:UIControlStateNormal];
        self.cancelButton.layer.cornerRadius = self.cancelButton.frame.size.height/2;
        
//        self.sdkTpyeButton.tag = AVSDK_TYPE_NORMAL;
    
        self.nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入直播名字" attributes:@{NSForegroundColorAttributeName: RGB16(COLOR_FONT_LIGHTGRAY)}];
        self.describeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入直播描述" attributes:@{NSForegroundColorAttributeName: RGB16(COLOR_FONT_LIGHTGRAY)}];
//        self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入直播间密码" attributes:@{NSForegroundColorAttributeName: RGB16(COLOR_FONT_LIGHTGRAY)}];
    
        CGRect rect = [UIScreen mainScreen].bounds;
        mOriginalWindow = [[UIWindow alloc] initWithFrame:rect];
        mOriginalWindow.windowLevel = UIWindowLevelAlert;
        
        mBackgroundView  = [[UIView alloc] initWithFrame:rect];
        mBackgroundView.alpha = 0.4;
        mBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
        mBackgroundView.backgroundColor = [UIColor blackColor];
        mBackgroundView.center = mOriginalWindow.center;
        self.center = mOriginalWindow.center;
        
        [mOriginalWindow addSubview:mBackgroundView];
        [mOriginalWindow addSubview:self];
        [mOriginalWindow makeKeyAndVisible];
//        [mOriginalWindow resignKeyWindow];
        
        //为TextField添加inputAccessoryView
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-55, 5, 50.0f, 30.0f)];
        button.layer.cornerRadius = 4;
        [button setBackgroundColor:RGB16(COLOR_FONT_RED)];
        button.titleLabel.font = [UIFont systemFontOfSize: 15.0];
        [button setTitle:@"完成" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(completeInput) forControlEvents:UIControlEventTouchUpInside];
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40.0f)];
        [toolbar addSubview:button];
        toolbar.backgroundColor = RGB16(COLOR_BG_LIGHTGRAY);
        self.nameTextField.inputAccessoryView = toolbar;
        self.describeTextField.inputAccessoryView = toolbar;
//        self.passwordTextField.inputAccessoryView = toolbar;

}
#pragma mark - 界面按钮响应
- (IBAction)sdkTypeAction:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    [self becomeFirstResponder];
    UIMenuItem *normalItem = [[UIMenuItem alloc] initWithTitle:LIVE_AVSDK_TYPE_NORMAL action:@selector(normal:)];
    UIMenuItem *iotCameraItem = [[UIMenuItem alloc] initWithTitle:LIVE_AVSDK_TYPE_IOTCamera action:@selector(IOTCamera:)];
    UIMenuItem *coastCameraItem = [[UIMenuItem alloc] initWithTitle:LIVE_AVSDK_TYPE_COASTCamera action:@selector(coastCamera:)];
    
    UIMenuController *sdkMenu = [UIMenuController sharedMenuController];
    [sdkMenu setMenuItems:[NSArray arrayWithObjects:normalItem,iotCameraItem,coastCameraItem, nil]];
    [sdkMenu setTargetRect:btn.frame inView:btn.superview];
    [sdkMenu setMenuVisible:YES animated:YES];
}

- (void)normal:(id)sender
{
    
}

- (void)IOTCamera:(id)sender
{
    
}

- (void)coastCamera:(id)sender
{
    
}

- (IBAction)confirmAction:(id)sender
{
    if([self.nameTextField.text isEqualToString:@""]){
        [[Common sharedInstance] shakeView:self.nameTextField];
        return;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha=0;
    } completion:^(BOOL finished) {
        if (confirmBlock) {
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
        UIMenuController *sdkMenu = [UIMenuController sharedMenuController];
        if (sdkMenu) {
            [sdkMenu setMenuVisible:NO animated:YES];
            sdkMenu = nil;
        }
    }];
}

#pragma mark - avsdk业务类型Menu相关
//- (void)normal:(id)sender{
//    UIMenuController *sdkMenu = (UIMenuController *)sender;
//    NSArray *itemArray = [sdkMenu menuItems];
//    UIMenuItem *currentItem = itemArray[SDKTYPE_NORMAL];
//    self.sdkTpyeButton.tag = AVSDK_TYPE_NORMAL;
//    [self.sdkTpyeButton setTitle:currentItem.title forState:UIControlStateNormal];
//}
//- (void)IOTCamera:(id)sender{
//    UIMenuController *sdkMenu = (UIMenuController *)sender;
//    NSArray *itemArray = [sdkMenu menuItems];
//    UIMenuItem *currentItem = itemArray[SDKTYPE_IOTCamera];
//    self.sdkTpyeButton.tag = AVSDK_TYPE_IOTCamera;
//    [self.sdkTpyeButton setTitle:currentItem.title forState:UIControlStateNormal];
//}
//- (void)coastCamera:(id)sender{
//    UIMenuController *sdkMenu = (UIMenuController *)sender;
//    NSArray *itemArray = [sdkMenu menuItems];
//    UIMenuItem *currentItem = itemArray[SDKTYPE_COASTCamera];
//    self.sdkTpyeButton.tag = AVSDK_TYPE_COASTCamera;
//    [self.sdkTpyeButton setTitle:currentItem.title forState:UIControlStateNormal];
//}
//
//- (BOOL)canBecomeFirstResponder{
//    return YES;
//}
//
//-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
//    if (action == @selector(normal:) ||
//        action == @selector(IOTCamera:) ||
//        action == @selector(coastCamera:)) {
//        return YES;
//    }
//    return NO;
//}

- (void)completeInput{
    [self.nameTextField resignFirstResponder];
    [self.describeTextField resignFirstResponder];
//    [self.passwordTextField resignFirstResponder];
}

- (void)showTitle:(NSString*)title confirmTitle:(NSString*)conTitle cancelTitle:(NSString*)canTitle confirm:(PushConfirm)confirm cancel:(PushCancel)cancel{
    self.titleLabel.text = title;
    [self.confirmButton setTitle:conTitle forState:UIControlStateNormal];
    [self.cancelButton setTitle:canTitle forState:UIControlStateNormal];
    CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
    confirmBlock = confirm;
    cancelBlock = cancel;
    
    self.alpha=0;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha=1;
    } completion:^(BOOL finished) {
    }];
}

@end
