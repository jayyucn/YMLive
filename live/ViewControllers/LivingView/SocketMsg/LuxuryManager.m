//
//  LuxuryManager.m
//  qianchuo 
//
//  Created by jacklong on 16/4/16.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "LuxuryManager.h"
#import "AirplaneAnimationView.h"
#import "CarMoveBottomMoveToTopView.h"
#import "CarPorscheTopMoveView.h"
#import "AnimationBoatView.h"
#import "AnimationFireworksView.h"
#import "AnimationMarryView.h"
#import "AnimationFlowerView.h"
#import "AnimationCrystalShoesView.h"
#import "AnimationCrownView.h"
#import "AnimationDressView.h"
#import "AnimationMoonView.h"
#import "AnimationAngelView.h"
#import "AnimationCastleView.h"
#import "AnimationPaintView.h"

@implementation LuxuryManager
// 

ES_SINGLETON_IMP(luxuryManager);


- (void) setLuxuryDict:(NSDictionary *)luxuryDict
{
    if (!_luxuryArray) {
        _luxuryArray = [NSMutableArray array];
    }
    
    [_luxuryArray addObject:luxuryDict];
    
    [self showLuxuryAnimation];
}

- (void) showLuxuryAnimation
{
    if (_isShowAnimation) {
        return;
    }
    
    if ([LuxuryManager luxuryManager].luxuryArray && [LuxuryManager luxuryManager].luxuryArray.count > 0) {
        _isShowAnimation = YES;
        
        NSDictionary *luxuryDict = [[LuxuryManager luxuryManager].luxuryArray objectAtIndex:0];
        [[LuxuryManager luxuryManager].luxuryArray removeObjectAtIndex:0];
        if ([luxuryDict[@"gift_id"] intValue] == FIREWORKS_GIFT) {
            if (_livingView) {
//#ifdef DEBUG
//                AnimationAngelView *angelView = [[AnimationAngelView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//                angelView.mNickName = luxuryDict[@"nickname"];
//                [_livingView addSubview:angelView];
//                return ;
//#endif
                AnimationFireworksView* fireworksView = [[AnimationFireworksView alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - const_fireworks_height / 2, ScreenHeight * (1 - 1.0 / 5) - const_fireworks_height , const_fireworks_height, const_fireworks_height)];
                fireworksView.mNickName = luxuryDict[@"nickname"];
                [_livingView addSubview:fireworksView];
            }
        }
        else if ([luxuryDict[@"gift_id"] intValue] == CAR_GIFT) {
            if (_livingView) {
                CarPorscheTopMoveView* carView = [[CarPorscheTopMoveView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                carView.mNickName = luxuryDict[@"nickname"];
                [_livingView addSubview:carView];
            }
        } else if([luxuryDict[@"gift_id"] intValue] == AIRPLANE_GIFT) {
            if (_livingView) {
                AirplaneAnimationView* planeView = [[AirplaneAnimationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                planeView.mNickName = luxuryDict[@"nickname"];
                [_livingView addSubview:planeView];
            }
        } else if ([luxuryDict[@"gift_id"] intValue] == SHIP_GIFT){
            if (_livingView) {
                AnimationBoatView* boatView = [[AnimationBoatView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                boatView.userInteractionEnabled = NO;
                boatView.mNickName = luxuryDict[@"nickname"];
                [_livingView addSubview:boatView];
            }
        } else if ([luxuryDict[@"gift_id"] intValue] == MARRY_GIFT){
            if (_livingView) {
                AnimationMarryView* marryView = [[AnimationMarryView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                marryView.userInteractionEnabled = NO;
                marryView.mNickName = luxuryDict[@"nickname"];
                [_livingView addSubview:marryView];
            }
        } else if ([luxuryDict[@"gift_id"] intValue] == CRYSTAL_SHOE_GIFT) {
            AnimationCrystalShoesView *crystalShoesView = [[AnimationCrystalShoesView alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - CRYSTAL_SHOES_WIDTH / 2, SCREEN_HEIGHT / 2 - CRYSTAL_SHOES_HEIGHT / 2, CRYSTAL_SHOES_WIDTH, CRYSTAL_SHOES_HEIGHT)];
            crystalShoesView.mNickName = luxuryDict[@"nickname"];
            [_livingView addSubview:crystalShoesView];
        } else if ([luxuryDict[@"gift_id"] intValue] == FLOWER_GIFT) {
            AnimationFlowerView *flowerView = [[AnimationFlowerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            flowerView.mNickName = luxuryDict[@"nickname"];
            [_livingView addSubview:flowerView];
        } else if ([luxuryDict[@"gift_id"] intValue] == CROWN_GIFT) {
            AnimationCrownView *crownView = [[AnimationCrownView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            crownView.mNickName = luxuryDict[@"nickname"];
            [_livingView addSubview:crownView];
        } else if ([luxuryDict[@"gift_id"] intValue] == DRESS_GIFT) {
            
            AnimationDressView *dressView = [[AnimationDressView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            dressView.mNickName = luxuryDict[@"nickname"];
            [_livingView addSubview:dressView];
        } else if ([luxuryDict[@"gift_id"] intValue] == MOON_GIFT) {
            AnimationMoonView *moonView = [[AnimationMoonView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            moonView.mNickName = luxuryDict[@"nickname"];
            moonView.mFace0 = luxuryDict[@"face"];
            moonView.mFace1 = [[LCMyUser mine] liveUserLogo];
            [_livingView addSubview:moonView];
        } else if ([luxuryDict[@"gift_id"] intValue] == ANGEL_GIFT) {
            AnimationAngelView *angelView = [[AnimationAngelView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            angelView.mNickName = luxuryDict[@"nickname"];
            [_livingView addSubview:angelView];
        } else if ([luxuryDict[@"gift_id"] intValue] == CASTLE_GIFT) {
            AnimationCastleView *castleView = [[AnimationCastleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            castleView.mNickName = luxuryDict[@"nickname"];
            [_livingView addSubview:castleView];
        } else if ([luxuryDict[@"gift_id"] intValue] == PAINT_GIFT) {
            AnimationPaintView *paintView = [[AnimationPaintView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT / 2 - SCREEN_WIDTH / 2, SCREEN_WIDTH, SCREEN_WIDTH)];
            paintView.mNickName = luxuryDict[@"nickname"];
            paintView.userInteractionEnabled = NO;
            [_livingView addSubview:paintView];
            NSDictionary *dict = luxuryDict[@"paint"];
            paintView.mDataDict = dict;
        }
    } else {
        _isShowAnimation = NO;
    }
}


@end
