//
//  DriveManager.m
//  auvlive
//
//  Created by 林伟池 on 16/8/9.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "DriveManager.h"
#import "LiveMsgManager.h"
#import "DriveBaseView.h"
#import "DrivePigView.h"
#import "DriveMouseView.h"
#import "DriveHorseView.h"
#import "DriveTigerView.h"
#import "DriveMonkeyView.h"
#import "DriveSnakeView.h"
#import "DriveGoatView.h"
#import "DriveRoosterView.h"
#import "DriveDogView.h"
#import "DriveBullView.h"
#import "DriveRabbitView.h"
#import "DriveDragonView.h"

@interface DriveManager ()

@property (nonatomic , strong) NSMutableArray *mDrivesArray;
@property (nonatomic , assign) BOOL mPlaying;

@end


@implementation DriveManager

#pragma mark - init


+ (instancetype)shareInstance {
    static id test;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        test = [[[self class] alloc] init];
    });
    return test;
}

- (instancetype)init {
    self = [super init];
    self.mDrivesArray = [NSMutableArray array];
    self.mPlaying = NO;
    
    return self;
}
#pragma mark - update

- (void)showDriveAnimation:(NSDictionary *)dict {
    if (dict) {
        [self.mDrivesArray addObject:dict];
        [self startAnimation];
    }
}


- (void)startAnimation {
    if (!self.mPlaying) {
        if (self.mDrivesArray.count > 0) {
            NSDictionary* dict = self.mDrivesArray[0];
            [self.mDrivesArray removeObjectAtIndex:0];
            DriveBaseView *baseView = [self getDriveBaseView:dict];
            if (baseView) {
                self.mPlaying = YES;
            }
            else {
                [self startAnimation];
            }
        }
    }
}

- (DriveBaseView *)getDriveBaseView:(NSDictionary *)dict {
    DriveBaseView* ret;
    
    if (self.containerView) {
        switch ([dict[@"zuojia"] intValue]) {
            case DRIVE_MOUSE:
            {
                DriveMouseView *mouseView = [[DriveMouseView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                mouseView.mNickName = dict[@"nickname"];
                [self.containerView addSubview:mouseView];
                ret = mouseView;
                break;
            }
                
            case DRIVE_BULL:
            {
                DriveBullView *bullView = [[DriveBullView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                bullView.mNickName = dict[@"nickname"];
                [self.containerView addSubview:bullView];
                ret = bullView;
                break;
                
            }
                
            case DRIVE_TIGER:
            {
                DriveTigerView *tigerView = [[DriveTigerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                tigerView.mNickName = dict[@"nickname"];
                [self.containerView addSubview:tigerView];
                ret = tigerView;
                break;
            }
                
            case DRIVE_RABBIT:
            {
                DriveRabbitView *rabbitView = [[DriveRabbitView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                rabbitView.mNickName = dict[@"nickname"];
                [self.containerView addSubview:rabbitView];
                ret = rabbitView;
                break;
            }
                
            case DRIVE_DARGON:
            {
                DriveDragonView *dragonView = [[DriveDragonView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                dragonView.mNickName = dict[@"nickname"];
                [self.containerView addSubview:dragonView];
                ret = dragonView;
                break;
            }

                
            case DRIVE_SNAKE:
            {
                DriveSnakeView *snakeView = [[DriveSnakeView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                snakeView.mNickName = dict[@"nickname"];
                [self.containerView addSubview:snakeView];
                ret = snakeView;
                break;
            }
                
            case DRIVE_HORSE:
            {
                DriveHorseView *horseView = [[DriveHorseView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                horseView.mNickName = dict[@"nickname"];
                [self.containerView addSubview:horseView];
                ret = horseView;
                break;
            }
                
            case DRIVE_GOAT:
            {
                DriveGoatView *goatView = [[DriveGoatView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                goatView.mNickName = dict[@"nickname"];
                [self.containerView addSubview:goatView];
                ret = goatView;
                break;
                
            }
                
            case DRIVE_MONKEY:
            {
                DriveMonkeyView *monkeyView = [[DriveMonkeyView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                monkeyView.mNickName = dict[@"nickname"];
                [self.containerView addSubview:monkeyView];
                ret = monkeyView;
                break;
            }
                
            case DRIVE_ROOSTER:
            {
                DriveRoosterView *roosterView = [[DriveRoosterView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                roosterView.mNickName = dict[@"nickname"];
                [self.containerView addSubview:roosterView];
                ret = roosterView;
                break;
            }
                
            case DRIVE_DOG:
            {
                DriveDogView *dogView = [[DriveDogView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                dogView.mNickName = dict[@"nickname"];
                [self.containerView addSubview:dogView];
                ret = dogView;
                break;
            }
                
            case DRIVE_PIG:
            {
#ifdef DEBUG
                DriveDragonView *dragonView = [[DriveDragonView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                dragonView.mNickName = dict[@"nickname"];
                [self.containerView addSubview:dragonView];
                ret = dragonView;
                break;

                
#endif
                
                DrivePigView *pigView = [[DrivePigView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                pigView.mNickName = dict[@"nickname"];
                [self.containerView addSubview:pigView];
                ret = pigView;
                break;
            }
            default:
                break;
        }
        
    }
    
    return ret;
}

- (void)onAnimationFinish {
    self.mPlaying = NO;
    [self startAnimation];
}

- (void)clearAnimation {
    self.mPlaying = NO;
    [self.mDrivesArray removeAllObjects];
}

#pragma mark - message

@end
