//
//  LCUserDetailViewController+TabBarOperate.m
//  XCLive
//
//  Created by ztkztk on 14-5-12.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCUserDetailViewController+TabBarOperate.h"
//#import "GiftRootViewController.h"
#import "LCMatchAlertView.h"
//#import "LCRadarViewController.h"
//#import "LCChatRequestManager.h"
//#import "LiveShowRootViewController.h"
@implementation LCUserDetailViewController (TabBarOperate)

-(void)doAction:(NSString *)title
{
    if([self.userID isEqualToString:[LCMyUser mine].userID])
        return;
    if([title isEqualToString:@"聊天"])
    {
        [self chat];
    }else if([title isEqualToString:@"夫妻相"])
    {
        [self matchCouple];
    }else if([title isEqualToString:@"关注"]||[title isEqualToString:@"取消关注"])
    {
        [self follow];
    }else if([title isEqualToString:@"更多"])
    {
        [self more];
    }
    else if ([title isEqualToString:@"礼物"])
    {
        [self gift];
    }

    
}

- (void)gift
{
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Gift" bundle:nil];
//    GiftRootViewController *gift = [storyBoard instantiateViewControllerWithIdentifier:@"GiftRootViewController"];
//    ESWeakSelf;
//    gift.sendGiftSuccess = ^(BOOL success,NSDictionary *giftDic)
//    {
//        ESStrongSelf;
//        if (success)
//        {
//            LCChatMessage *message = [LCChatMessage sendGiftMessageTo:_self.userID content:giftDic[@"name"]];
//            message.thumbnailURL = giftDic[@"pic"];
//            message.contentDuration = [giftDic[@"diamond"] intValue];
//            message.contentSize =  [giftDic[@"charm"] intValue];
//            message.type = LCChatMessageTypeGift;
//            ESDispatchOnMainThreadAsynchronously(^{
//                ESStrongSelf;
//                [LCCore hideProgressHUD:NO];
//                [message save];
//                [[LCChatRequestManager sharedManager] sendMessage:message];
//            });
//        }
//    };
//    NSLog(@"%@",self.userID);
//
//    gift.personID = self.userID;
//    gift.isScanner = NO;
//    gift.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:gift animated:YES];
}

-(void)chat
{
//    LiveShowRoomViewController *room = [LiveShowRootViewController getCurrentRoom];
//    if (room)
//    {
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        [dic setValue:self.userDic[@"userinfo"] forKey:@"info"];
//        [dic setValue:self forKey:@"controller"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_NarrowGroup object:nil userInfo:dic];
//    }
//    else
//    {
        NSLog(@"userinfo dict:%@",self.userDic[@"userinfo"]);
//        [LCChatViewController openChatWithUser:[LCChatUser userWithDictionary:self.userDic[@"userinfo"]]];
//    }
    /*
    if ([DataManager sharedManager].moreActionType != ShowNomalMoreAction || [DataManager sharedManager].narrowType != ShowNomalMoreAction)
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:self.userDic[@"userinfo"] forKey:@"info"];
        [dic setValue:self forKey:@"controller"];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_NarrowGroup object:nil userInfo:dic];
    }
    else
    {
#if 1 // -Elf, 从雷达进聊天时退出雷达
        if ([self.previousViewController isKindOfClass:[LCRadarViewController class]]) {
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
#endif
        [LCChatViewController openChatWithUser:[LCChatUser userWithDictionary:self.userDic[@"userinfo"]]];
    }
     */
}

-(void)matchCouple
{
//    [LCMatchAlertView showMatchAlertView:self.userDic[@"userinfo"]
//                          withController:self];
//    self.coupleRootView.hidden=NO;
//    self.coupleRootView.matchView.matchUser=self.userDic[@"userinfo"];
}

-(void)follow
{
    if(self.atten==0)
    {
        [self addFriend];
    }else{
        [self deleteFriend];
    }
}

-(void)more
{
    UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                                    initWithTitle:nil
                                    delegate:self
                                    cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                    otherButtonTitles: @"黑名单", @"举报",nil];
    [myActionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
                ESWeakSelf;
            NSString *msg=[NSString stringWithFormat:@"是否要将“%@”加入黑名单？",self.title];
                UIAlertView *alert = [UIAlertView alertViewWithTitle:@"提示" message:msg cancelButtonTitle:@"取消" didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        ESStrongSelf;
                        if (alertView.cancelButtonIndex != buttonIndex) {
                                [_self blackList];
                        }
                } otherButtonTitles:@"确定", nil];
                [alert show];
//            [UIAlertView alertViewWithTitle:[NSString stringWithFormat:@"提示"]
//                                    message:msg
//                          cancelButtonTitle:@"取消"
//                         customizationBlock:nil
//                               dismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
//                                   [self blackList];
//                                   
//                               }
//                                cancelBlock:^{
//                                    
//                                }
//                          otherButtonTitles: @"确定",nil];

        }
            break;
        case 1:
        {
            NSArray *array=@[@"色情内容",@"骚扰信息",@"虚假身份",@"广告欺诈"];
            ESWeakSelf;
            [LCTableAlertView showTableAlertView:@"举报"
                                           array:array
                                       withBlock:^(NSInteger select){
                                           ESStrongSelf;
                                           [_self report:select];
            }];
            //[self report];
        }
            break;
        default:
            break;
    }
}
@end
