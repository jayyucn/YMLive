//
//  DoLiveViewController.h
//  live
//
//  Created by kenneth on 15-7-9.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DoLiveDelegate  <NSObject>
- (void)publishTrailerSuccess;
@end
@interface DoLiveViewController : UIViewController
@property (nonatomic,weak) id<DoLiveDelegate> delegate;
@end
