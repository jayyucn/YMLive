//
//  LCSelectPhotoToSubmit.m
//  XCLive
//
//  Created by ztkztk on 14-4-22.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCSelectPhoto.h"
#import <AVFoundation/AVFoundation.h>
#import <MBProgressHUD.h>
#import "LCNoticeAlertView.h"

@implementation LCSelectPhoto


static LCSelectPhoto *_sharedSelectPhoto = nil;
+(id)selectPhoto
{
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        _sharedSelectPhoto = [[LCSelectPhoto alloc] init];
//        _sharedSelectPhoto.locationManager=[LocationManager locationManager];
        
        
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
            _sharedSelectPhoto.picker = [[UIImagePickerController alloc] init];
            _sharedSelectPhoto.picker.delegate = _sharedSelectPhoto;
            //设置拍照后的图片可被编辑
            _sharedSelectPhoto.picker.allowsEditing = YES;
            //资源类型为照相机
        }
    });
    return _sharedSelectPhoto;
    
    
}


-(void)showSelectItemForPortraitWithController:(UIViewController *)viewController
                                     submitURL:(NSString *)submitURL
                               withSubmitBlock:(LCSubmitSuccessBlock)submitSuccessBlock
{
    self.pickerDevice = UIImagePickerControllerCameraDeviceFront;
    self.submitSuccessBlock = submitSuccessBlock;
    self.submitURL = submitURL;
    [self showSelectItemWithController:viewController withSelectBlock:nil];
}


-(void)showSelectItemWithController:(UIViewController *)viewController
                          submitURL:(NSString *)submitURL
                    withSubmitBlock:(LCSubmitSuccessBlock)submitSuccessBlock
{
    self.pickerDevice = UIImagePickerControllerCameraDeviceRear;
    self.submitSuccessBlock=submitSuccessBlock;
    self.submitURL=submitURL;
    [self showSelectItemWithController:viewController withSelectBlock:nil];
}

-(void)showSelectItemWithController:(UIViewController *)viewController withSelectBlock:(LCSelectPhotoBlock)selectPhotoBlock
{
    self.viewController=viewController;
    self.selectPhotoBlock=selectPhotoBlock;
    UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                                    initWithTitle:nil
                                    delegate:self
                                    cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                    otherButtonTitles: @"从相册选择", @"拍照",nil];
    myActionSheet.tag=1002;
    if(self.viewController)
        [myActionSheet showInView:self.viewController.view];
    
}

- (void)showSingleItemWithViewcontroller:(UIViewController *)viewcontroller
                                isCamera:(BOOL )isCamera
                                withSubmitBlock:(LCSubmitSuccessBlock)submitSuccessBlock
                                submitURL:(NSString *)submitURL
{
    self.viewController = viewcontroller;
    self.submitURL = submitURL;
    self.submitSuccessBlock = submitSuccessBlock;
    if(isCamera)
    {
        [self takePhoto];
    }
    else
    {
        [self LocalPhoto];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //从相册选择
            [self LocalPhoto];
            break;
        case 1:
            //拍照
            [self takePhoto];
            break;
//        case 2:
//            if ([DataManager sharedManager].addState == AddPhotoStateChanged)
//            {
//                [DataManager sharedManager].addState = AddPhotoStateSuccess;
//                
//            }
//            break;
        default:
            break;
    }
}

//从相册选择
-(void)LocalPhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        //if ([[ALAssetsLibrary class] respondsToSelector:@selector(authorizationStatus)]) {
        if (ESOSVersionIsAbove(NSFoundationVersionNumber_iOS_5_1)) {
            //NSLog(@"=========%d",(int)[ALAssetsLibrary authorizationStatus]);
            if([ALAssetsLibrary authorizationStatus]==ALAuthorizationStatusRestricted||[ALAssetsLibrary authorizationStatus]==ALAuthorizationStatusDenied)
            {
                
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"相册已禁用，请在系统设置里设置此应用访问相册权限"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil,nil];
                
                [alert show];
                
                return;
            }
        }
        
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        if(self.viewController)
        {
            [self.viewController presentViewController:self.picker animated:YES completion:nil];
        }
        
    }
}

//拍照
-(void)takePhoto{
    
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        if ([[AVCaptureDevice class] respondsToSelector:@selector(authorizationStatusForMediaType:)])
        {
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            
            
            if(authStatus==AVAuthorizationStatusRestricted||authStatus==AVAuthorizationStatusDenied)
            {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"相机已禁用，请在系统设置里打开应用相机权限"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil,nil];
                
                [alert show];
                return;
                
            }
            
        }
        
        
        if(self.picker)
        {
            self.picker.sourceType=UIImagePickerControllerSourceTypeCamera;
            self.picker.cameraDevice = self.pickerDevice;
            
            //[UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
            
            if(self.viewController)
            {
                [self.viewController presentViewController:_picker
                                                  animated:YES
                                                completion:nil];
            }
            
        }else{
            NSLog(@"该设备无摄像头");
        }
        
        
    }
    else
    {
        [LCNoticeAlertView showMsg:@"相机已禁用，请在系统设置里打开相机应用"];
    }
    
    /*
     //资源类型为照相机
     UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
     //判断是否有相机
     
     [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
     
     
     if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
     UIImagePickerController *picker = [[UIImagePickerController alloc] init];
     picker.delegate = self;
     //设置拍照后的图片可被编辑
     picker.allowsEditing = YES;
     //资源类型为照相机
     picker.sourceType = sourceType;
     
     picker.cameraDevice=UIImagePickerControllerCameraDeviceFront;
     if(self.viewController)
     {
     if ([self.viewController respondsToSelector:@selector(presentViewController:animated:completion:)]) {
     
     [self.viewController presentViewController:picker
     animated:YES
     completion:nil];
     
     }else{
     [self.viewController presentModalViewController:picker animated:YES];
     }
     }
     
     
     }else {
     NSLog(@"该设备无摄像头");
     }
     
     
     */
}

#pragma Delegate method UIImagePickerControllerDelegate

//图像选取器的委托方法，选完图片后回调该方法
-(void)imagePickerController:(UIImagePickerController *)picker
       didFinishPickingImage:(UIImage *)image
                 editingInfo:(NSDictionary *)editingInfo{
    
    
    if (image != nil) {
        //_selectPhotoBlock(image);
        
//        if([_submitURL isEqualToString:modifyPhotoURL()])
//        {
//            if(image.size.width<120||image.size.height<120)
//            {
//                [picker dismissModalViewControllerAnimated:YES];
//                [LCNoticeAlertView showMsg:@"图片尺寸不能小于120*120"];
//                return;
//            }
//        }
//        
        [self locationAndSubmit:image];
        
        // [DataManager sharedManager].addPhotoSuccess = YES;
        
        //bug is here?
        [picker dismissViewControllerAnimated:YES completion:^{}];
        
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
//    if ([DataManager sharedManager].addState == AddPhotoStateChanged)
//    {
//        [DataManager sharedManager].addState = AddPhotoStateCancel;
//    }
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

-(void)locationAndSubmit:(UIImage *)image
{
//    NSLog(@"--------%ld",[DataManager sharedManager].addState);
//    if([DataManager sharedManager].addState == AddPhotoStateRepare || [DataManager sharedManager].addState == AddPhotoStateChanged)
//    {
//        NSLog(@"乃进来了？");
//        [KVNProgress showWithStatus:@"上传中..."];
//    }
    
//    if([_submitURL isEqualToString:getLiveRegUploadFaceURL()])
//    {
//        [self submitPhoto:[image resizedImage:CGSizeMake(100, 100) interpolationQuality:kCGInterpolationMedium] url:_submitURL];
//        return;
//    }
    
     [self submitPhoto:image url:_submitURL];
}

-(void)submitPhoto:(UIImage *)image url:(NSString *)urlString
{
    ESWeakSelf;
    MBProgressHUD* hub = [[MBProgressHUD alloc] initWithView:self.viewController.view];
    hub.mode = MBProgressHUDModeDeterminateHorizontalBar;
    [self.viewController.view addSubview:hub];
    hub.labelText = @"上传中...";
    hub.progress = 0;
    [hub show:YES];
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        [hub removeFromSuperview];
        NSLog(@"upload image =%@",responseDic);
        
        int stat=[responseDic[@"stat"] intValue];
        if(stat == URL_REQUEST_SUCCESS)
        {
            // [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:kUserDefaultsKey_SubmitLocation];
            ESStrongSelf;
            if(_self.submitSuccessBlock)
                _submitSuccessBlock(responseDic);
        }
        else
        {
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
        
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        [hub removeFromSuperview];
        NSLog(@"upload image fail %@",error);
        [LCNoticeAlertView showMsg:@"上传失败"];
    };
    
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"?uid=%@", [LCMyUser mine].userID]];
    
    [[LCHTTPClient sharedHTTPClient] upLoadImage:image
                                       withParam:nil
                                        withPath:urlString
                                        progress:^(NSProgress *progress) {
                                            hub.progress = progress.completedUnitCount * 1.0 / progress.totalUnitCount;
//                                            NSLog(@"complete %f", hub.progress);
                                        }
                                     withRESTful:POST_REQUEST
                                withSuccessBlock:successBlock
                                   withFailBlock:failBlock];
}


@end
