//
//  LCUserInterImageView.h
//  XCLive
//
//  Created by ztkztk on 14-4-22.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^LCImageSingleTapBlock)(NSDictionary *dic);
typedef void (^LCImageLongPressBlock)(NSDictionary *dic);
@interface LCMutualImageView : UIImageView<UIGestureRecognizerDelegate>

@property (nonatomic,strong)LCImageSingleTapBlock singleTapBlock;
@property (nonatomic,strong)LCImageLongPressBlock longPressBlock;

-(void)tapAction;
-(void)longPress;

@end
