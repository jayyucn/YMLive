//
//  UIViewController+YingYingImagePickerController.m
//  Yingying
//
//  Created by 林伟池 on 16/1/3.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "EditUserInfoViewController+YingYingImagePickerController.h"
//#import <objc/runtime.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation EditUserInfoViewController (YingYingImagePickerController)
//@dynamic myPickImage;
//
//- (id) myPickImage
//{
//    return objc_getAssociatedObject(self, @selector(myPickImage));
//}
//
//- (void)setMyPickImage:(id)image
//{
//    objc_setAssociatedObject(self, @selector(myPickImage), image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}


- (void)lyModalChoosePicker {
    if ([[UIDevice currentDevice].model rangeOfString:@"iPhone" options:NSCaseInsensitiveSearch].location != NSNotFound && NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_8_0) {
        UIAlertController* controller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        @weakify(self);
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:ESLocalizedString(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"cancel");
        }];
        [controller addAction:cancel];
        
        UIAlertAction* takePhoto = [UIAlertAction actionWithTitle:ESLocalizedString(@"拍照") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
            [self takePhoto];
        }];
        [controller addAction:takePhoto];
        
        UIAlertAction* localPhoto = [UIAlertAction actionWithTitle:ESLocalizedString(@"从相册中选择") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
            [self LocalPhoto];
        }];
        [controller addAction:localPhoto];
        [self presentViewController:controller animated:YES completion:nil];
    }
    else {
        UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                                        initWithTitle:nil
                                        delegate:self
                                        cancelButtonTitle:ESLocalizedString(@"取消")
                                        destructiveButtonTitle:nil
                                        otherButtonTitles: ESLocalizedString(@"从相册选择"), ESLocalizedString(@"拍照"),nil];
        if(self.view) {
            [myActionSheet showInView:self.view];
        }
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
         
        default:
            break;
    }
}
#pragma mark - ui

-(void)takePhoto
{
//    if([ALAssetsLibrary authorizationStatus]==ALAuthorizationStatusRestricted||[ALAssetsLibrary authorizationStatus]==ALAuthorizationStatusDenied)
//    {
//        
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                        message:@"相册已禁用，请在系统设置里设置此应用访问相册权限"
//                                                       delegate:self
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil,nil];
//        
//        [alert show];
//        
//        return;
//    }
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        
        if (ESIsPhoneDevice()) {
            picker.allowsEditing = YES;
        }
        
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //    picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    if (ESIsPhoneDevice()) {
        picker.allowsEditing = YES;
    }
    [self presentViewController:picker animated:YES completion:nil];
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
        CGRect rect = [[info objectForKey:UIImagePickerControllerCropRect] CGRectValue];
        [picker dismissViewControllerAnimated:YES completion:nil];
        rect.size = CGSizeMake(MIN(rect.size.width, rect.size.height), MIN(rect.size.width, rect.size.height));
        if (rect.size.width == 0) {
            rect.size = image.size;
        }
        image = [self lyCropImage:image inRect:rect];

        if ([image isKindOfClass:[UIImage class]]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UI_IMAGE_PICKER_DONE object:image];
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}


/**
 *  裁剪图片，注意图像朝向会影响
 *
 *  @param image 图像
 *  @param rect  相框
 *
 *  @return 裁剪后图像
 */
- (UIImage *)lyCropImage:(UIImage*)image inRect:(CGRect)rect
{
    double (^rad)(double) = ^(double deg) {
        return deg / 180.0 * M_PI;
    };
    
    CGAffineTransform rectTransform;
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(90)), 0, -image.size.height);
            break;
        case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-90)), -image.size.width, 0);
            break;
        case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-180)), -image.size.width, -image.size.height);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
    };
    rectTransform = CGAffineTransformScale(rectTransform, image.scale, image.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectApplyAffineTransform(rect, rectTransform));
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    
    return result;
}

@end
