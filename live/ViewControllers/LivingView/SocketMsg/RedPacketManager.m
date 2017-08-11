//
//  RedPacketManager.m
//  qianchuo
//
//  Created by jacklong on 16/4/29.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "RedPacketManager.h"
#import "RobRedPacketViewController.h"

@implementation RedPacketManager

ES_SINGLETON_IMP(redPacketManager);

- (void) setRedPacketDict:(NSDictionary *)redPacketDict
{
    if (!_redPacketArray) {
        _redPacketArray = [NSMutableArray array];
    }
    
    [_redPacketArray addObject:redPacketDict];
    
    [self showRedPacketVC];
}

#pragma mark - 显示红包
- (void) showRedPacketVC
{
    if ([RobRedPacketViewController isShowRedPacket]) {
        return;
    }
    
    if ([RedPacketManager redPacketManager].redPacketArray && [RedPacketManager redPacketManager].redPacketArray.count > 0) {
        
        NSDictionary *redPacketDict = [[RedPacketManager redPacketManager].redPacketArray objectAtIndex:0];
        [[RedPacketManager redPacketManager].redPacketArray removeObjectAtIndex:0];
        
        RobRedPacketViewController *robRedPacketVC = [[RobRedPacketViewController alloc] init];
        robRedPacketVC.bagInfoDict = redPacketDict;
        robRedPacketVC.isShowDetail = NO;
        [[ESApp rootViewControllerForPresenting] popupViewController:robRedPacketVC completion:nil];
    } else {
        [RobRedPacketViewController isCloseRedPacket] ;
    }

}

@end
