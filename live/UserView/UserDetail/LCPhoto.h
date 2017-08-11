//
//  LCPhotoImageView.h
//  XCLive
//
//  Created by ztkztk on 14-5-12.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCPhoto : UIImageView<UIGestureRecognizerDelegate>

@property (nonatomic,strong)UILabel *moreLabel;
@property (nonatomic,strong)NSDictionary *photoDic;

-(void)cleanView;
@end
