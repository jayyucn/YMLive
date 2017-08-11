//
//  LCSelectPhotoToSubmit.h
//  XCLive
//
//  Created by ztkztk on 14-4-22.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "LocationManager.h"

#import <AssetsLibrary/AssetsLibrary.h>

typedef void(^LCSelectPhotoBlock)(UIImage *selectImage);
typedef void(^LCSubmitSuccessBlock)(NSDictionary *dic);

@interface LCSelectPhoto: NSObject<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,weak)UIViewController *viewController;
@property (nonatomic,strong)NSString *submitURL;
@property (nonatomic,strong)LCSelectPhotoBlock selectPhotoBlock;
@property (nonatomic,strong)LCSubmitSuccessBlock submitSuccessBlock;
//@property (nonatomic,strong)LocationManager *locationManager;
@property (nonatomic,strong)UIImagePickerController *picker;
@property (nonatomic)UIImagePickerControllerCameraDevice pickerDevice;
+(id)selectPhoto;
-(void)showSelectItemWithController:(UIViewController *)viewController withSelectBlock:(LCSelectPhotoBlock)selectPhotoBlock;
-(void)showSelectItemWithController:(UIViewController *)viewController
                          submitURL:(NSString *)submitURL
                    withSubmitBlock:(LCSubmitSuccessBlock)submitSuccessBlock;

-(void)showSelectItemForPortraitWithController:(UIViewController *)viewController
                                     submitURL:(NSString *)submitURL
                               withSubmitBlock:(LCSubmitSuccessBlock)submitSuccessBlock;
- (void)showSingleItemWithViewcontroller:(UIViewController *)viewcontroller
                                isCamera:(BOOL )isCamera
                         withSubmitBlock:(LCSubmitSuccessBlock)submitSuccessBlock
                               submitURL:(NSString *)submitURL;
@end
