//
//  LiveInviteAlertView.h
//  live
//
//  Created by AlexiChen on 15/10/21.
//  Copyright © 2015年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LiveInviteAlertView;
@protocol LiveInviteAlertViewDelegate <NSObject>

@required
// for 邀请
- (void)onInviteView:(LiveInviteAlertView *)alert invite:(LiveUser *)user inviteOrClose:(BOOL)isInvite;

// for action

- (void)onInviteView:(LiveInviteAlertView *)alert user:(LiveUser *)user enableMic:(BOOL)enable;
- (void)onInviteView:(LiveInviteAlertView *)alert user:(LiveUser *)user enableCamera:(BOOL)enable;
- (void)onInviteView:(LiveInviteAlertView *)alert switchUserToMain:(LiveUser *)user;
- (void)onInviteView:(LiveInviteAlertView *)alert hangupUser:(LiveUser *)user;

@required


@end

@interface LiveInviteAlertView : UIView
{
@protected
    UIView  *_backgroundView;
    UIWindow *_alertWindow;
    
    __weak IBOutlet UIView *_container;
    
    __weak IBOutlet UIImageView *_headIcon;
    
    __weak IBOutlet UILabel *_nickName;
    
    __weak IBOutlet UIView *_actionsView;
    
   

    __weak IBOutlet UIButton *_speaker;

    __weak IBOutlet UIButton *_camera;
    
    __weak IBOutlet UIButton *_switchWindow;

    __weak IBOutlet UIButton *_hangUp;

    __weak IBOutlet UIButton *_interactButton;
    
     __weak IBOutlet UILabel *_statusTip;

    __weak IBOutlet UIButton *_closeButton;

}

@property (nonatomic, weak) id<LiveInviteAlertViewDelegate> delegate;


- (instancetype)initInviteView:(LiveUser *)dic normale:(BOOL)normal;

- (instancetype)initAtionView:(LiveUser *)dic;

- (void)showSelfAction;

- (void)disableInteract;

- (void)show;


@end
