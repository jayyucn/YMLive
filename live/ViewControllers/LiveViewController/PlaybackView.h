//
//  PlaybackView.h
//  TaoHuaLive
//
//  Created by Jay on 2017/7/13.
//  Copyright © 2017年 上海七夕. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CancelActionBlock)(UIButton *sender);

@protocol PlaybackViewDelegate <NSObject>
@optional

- (void)playbackViewRecordDidBegin;
- (void)playbackViewRecordShouldEnd;
- (void)playbackViewRecordDidCancel;

@end

@interface PlaybackView : UIView

@property (nonatomic, weak) id<PlaybackViewDelegate> delegate;

@property (nonatomic, copy) NSString *videoURL;
@property (nonatomic, copy) CancelActionBlock cancelActionBlock;

- (instancetype)initWithFrame:(CGRect)frame;


- (void)recordShouldBegin;

- (void)recordDidEnd;

- (void)recordDidCancel;

@end
