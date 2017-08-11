//
//  TrailerLiveViewController.h
//  live
//
//  Created by hysd on 15/8/20.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TrailerLiveViewDelegate <NSObject>
- (void)startLiveController:(NSString*)title image:(UIImage*)image;
- (void)publishTrailerSuccess;
@end
@interface TrailerLiveViewController : UIViewController
@property (nonatomic,weak) id<TrailerLiveViewDelegate> delegate;
@end
