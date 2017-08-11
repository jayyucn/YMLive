//
//  LCVideoPickerController.h
//  XCLive
//
//  Created by ztkztk on 14-7-16.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "LCViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface LCVideoPickerController : LCViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,strong)UIImageView *photoView;
@property (nonatomic,strong)UIImagePickerController *imagePicker;
@property (nonatomic,strong)NSURL *videoURL;

@property (nonatomic,strong)ESButton *photoBtn;

@property (nonatomic,strong)ESButton *againPhotoBtn;


@end
