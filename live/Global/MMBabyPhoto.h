//
//  MMBabyPhoto.h
//  MaMaTao
//
//  Created by ztkztk on 14-8-18.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapBabyPhotoBlock)(void);
@interface MMBabyPhoto : UIView<UIGestureRecognizerDelegate>

@property (nonatomic,strong)UIImageView *photoImage;
//@property (nonatomic,strong)UIButton *photoBtn;
@property (nonatomic,copy)TapBabyPhotoBlock babyPhotoBlock;
-(void)showImage;
@end
