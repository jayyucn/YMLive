//
//  DrawGiftView.h
//  HuoWuLive
//
//  Created by 林伟池 on 16/11/18.
//  Copyright © 2016年 上海七夕. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DrawGiftViewDelegate <NSObject>

- (void)hiddenDrawGiftView;
- (void)drawShowRecharge;
- (void)drawSendWithDict:(NSDictionary *)dict;

@end

#define CANVAS_WIDTH 300
#define CANVAS_HEIGHT 300
#define POINT_SIZE_WIDTH 20
#define POINT_SIZE_HEIGHT 20
#define POINT_MAX_COUNT 200
#define SQUARE_SZIE 400

@interface DrawGiftView : UIView

@property (nonatomic , weak) NSObject<DrawGiftViewDelegate> *mDrawDelegate;
@property (nonatomic , strong) NSNumber *mDrawCount;

- (BOOL)isSubview:(UIView *)view;

@end
