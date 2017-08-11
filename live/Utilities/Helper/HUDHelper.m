//
//  HUDHelper.m
//  pizus
//
//  Created by 陈耀武 on 12-11-28.
//  Copyright (c) 2012年 pizus. All rights reserved.
//

#import "HUDHelper.h"
#import "AppDelegate.h"

@implementation HUDHelper

static HUDHelper *_instance = nil;


//@synthesize window = _window;


+ (HUDHelper *)sharedInstance
{
    @synchronized(_instance)
    {
        if (_instance == nil)
        {
            _instance = [[HUDHelper alloc] init];
        }
        return _instance;
    }
}

- (void)dealloc
{
//    CommonRelease(_window);
//    CommonRelease(_showingHUDs);
//    CommonRelease(_loadingHud);
//    CommonSuperDealloc();
//    [_window release];
//    [_showingHUDs release];
//    [_loadingHud release];
//    [super dealloc];
}

- (id)init
{
    if (self = [super init])
    {
//        _window = [AppDelegate sharedAppDelegate].window;
        _showingHUDs = [[NSMutableArray alloc] init];
    }
    return self;
}



- (void)hudWasHidden:(MBProgressHUD *)hud
{
    @synchronized(_loadingHud)
    {
        if (_loadingHud == hud) {
            [_loadingHud removeFromSuperview];
            [self removeHUD:_loadingHud];
//            CommonRelease(_loadingHud);
//            [_loadingHud release];
            _loadingHud = nil;
        }
    }
    
}

- (void)addHUD:(MBProgressHUD *)hud
{
    @synchronized(_showingHUDs)
    {
        [_showingHUDs addObject:hud];
    }
}
- (void)removeHUD:(MBProgressHUD *)hud
{
    @synchronized(_showingHUDs)
    {
        [_showingHUDs removeObject:hud];
    }
}

- (void)serviceLoading:(NSInteger)maxRequestCount
{
    @synchronized(_loadingHud)
    {
        if (_loadingHud == nil) {
            _loadingHud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//            CommonRetain(_loadingHud);
            _loadingHud.delegate = self;
            _loadingHud.tag = 0;
            [self addHUD:_loadingHud];
            [_loadingHud show:YES];
        }
        if (_loadingHud)
        {
            
            _loadingHud.tag++;
        }
    }
}

- (void)loading
{
    if ([NSThread isMainThread])
    {
        @synchronized(_loadingHud)
        {
            if (_loadingHud == nil) {
                _loadingHud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//                CommonRetain(_loadingHud);
                _loadingHud.delegate = self;
                _loadingHud.tag = 0;
                [self addHUD:_loadingHud];
                [_loadingHud show:YES];
            }
            if (_loadingHud)
            {
                
                _loadingHud.tag++;
            }
//            DebugLog(@"stopLoading :loadingHud count %ld",(long)_loadingHud.tag);
        }
    }
    else
    {
        [self performSelectorOnMainThread:@selector(loading) withObject:nil waitUntilDone:NO];
    }
    
}

- (void)stopLoading
{
    if ([NSThread isMainThread]) {
        @synchronized(_loadingHud)
        {
            if (_loadingHud)
            {
                if (--_loadingHud.tag <= 0)
                {
                    [_loadingHud hide:YES];
                }
                
//                DebugLog(@"stopLoading :loadingHud count %ld",(long)_loadingHud.tag);
                
            }
        }
    }
    else
    {
        [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:NO];
    }
    
}

- (void)tipMessage:(NSString *)msg delay:(CGFloat)seconds
{
    if (!msg) {
        return;
    }
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    HUD.mode = MBProgressHUDModeText;
    HUD.delegate = self;
    HUD.labelText = msg;
    [HUD show:YES];
    [HUD hide:YES afterDelay:seconds];
//    CommonRelease(HUD);
}

- (void)delayTipMessage:(NSString *)msg
{
    [self tipMessage:msg delay:2.0];
}

- (void)tipMessage:(NSString *)msg
{
    if (!msg) {
        return;
    }
    
    if ([NSThread isMainThread])
    {
        [self performSelector:@selector(delayTipMessage:) withObject:msg afterDelay:0.2];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(tipMessage:) withObject:msg waitUntilDone:NO];
    }
    
}


- (void)loadingFor:(CGFloat)seconds
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    [HUD show:YES];
    [HUD hide:YES afterDelay:seconds];
}


- (void)loadingFor:(CGFloat)seconds inView:(UIView *)view
{
    if (!view)
    {
        return;
    }
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    [HUD show:YES];
    [HUD hide:YES afterDelay:seconds];
}
@end
