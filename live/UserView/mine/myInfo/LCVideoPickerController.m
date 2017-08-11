//
//  LCVideoPickerController.m
//  XCLive
//
//  Created by ztkztk on 14-7-16.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "LCVideoPickerController.h"

@interface LCVideoPickerController ()

@end

@implementation LCVideoPickerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.view.backgroundColor=[UIColor redColor];
    self.title=@"有美直播";
    
    _photoView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, ScreenHeight)];
    [self.view addSubview:_photoView];
    
    UIImage *coverImage;
    if(ScreenHeight > 480)
        coverImage = [UIImage imageNamed:@"image/camaraShade-568"];
    else
        coverImage=[UIImage imageNamed:@"image/camaraShade"];
    
    UIImageView * coverView=[[UIImageView alloc] initWithImage:coverImage];
    [self.view addSubview:coverView];
    
    
    _againPhotoBtn=[ESButton buttonWithTitle:@"重新拍照" buttonColor:ESButtonColorRed];
    _againPhotoBtn.frame=CGRectMake(10,ScreenHeight-80, 100,40);
    [_againPhotoBtn setTitleColor:[UIColor whiteColor]
                         forState:UIControlStateNormal];
    
    [_againPhotoBtn addTarget:self
                       action:@selector(againPhoto)
             forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_againPhotoBtn];
    
    
    _againPhotoBtn.centerX=80.0f;
    
       
    _againPhotoBtn.hidden=YES;
    
    [self createCamara];
    [self photoAction];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(photoAction)
                                                 name:@"RephotoNotification"
                                               object:nil];
    
}


-(void)createCamara
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        
        _imagePicker = [[UIImagePickerController alloc] init];
        
        self.imagePicker.delegate = self;
        
        
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        NSArray* availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        self.imagePicker.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];
        self.imagePicker.allowsEditing = YES;
        self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        self.imagePicker.videoMaximumDuration = 10;
        self.imagePicker.showsCameraControls = NO;
        
        [self createOverlayView];
        
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"failed to camera"
                              message:@""
                              delegate:nil
                              cancelButtonTitle:@"OK!"
                              otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}


-(void)againPhoto
{
    [self pickFromCamera];
}

-(void)photoAction
{
    [self performSelector:@selector(pickFromCamera) withObject:nil afterDelay:0.3];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.isMovingToParentViewController)
    {
        NSLog(@"llisMovingToParentViewController");
    }else{
        NSLog(@"llelseelseelse");
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}



-(void)createOverlayView
{
    
    UIImage *coverImage;
    if(ScreenHeight>480)
        coverImage=[UIImage imageNamed:@"image/camaraShade-568"];
    else
        coverImage=[UIImage imageNamed:@"image/camaraShade"];
    
    
    UIView *overView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, ScreenHeight)];
    
    // aView.alpha=0.3;
    
    overView.backgroundColor=[UIColor colorWithPatternImage:coverImage];
    
    // [aView addSubview:overView];
    
    
    NSLog(@"---%f",overView.frame.size.height);
    
    NSLog(@"---%f",coverImage.size.height);
    
    self.imagePicker.cameraOverlayView=overView;
    
    UIButton *turnBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    turnBtn.frame=CGRectMake(240,20,28,21);
    
    [turnBtn setBackgroundImage:[UIImage imageNamed:@"image/turnphoto.png"]
                       forState:UIControlStateNormal];
    
    [turnBtn setTintColor:[UIColor whiteColor]];
    [overView addSubview:turnBtn];
    
    
    
    [turnBtn addTarget:self
                action:@selector(turnCamara)
      forControlEvents:UIControlEventTouchUpInside];
    
    
    
    ESButton *photoBtn=[ESButton buttonWithTitle:@"拍照" buttonColor:[UIColor es_primaryButtonColor]];
    photoBtn.frame=CGRectMake(10,ScreenHeight-80, 100,40);
    [photoBtn setTitleColor:[UIColor whiteColor]
                   forState:UIControlStateNormal];
    
    [photoBtn addTarget:self
                 action:@selector(getPhoto)
       forControlEvents:UIControlEventTouchUpInside];
    [overView addSubview:photoBtn];
    
    photoBtn.centerX=160;
    
    
}

-(void)turnCamara
{
    if(self.imagePicker.cameraDevice==UIImagePickerControllerCameraDeviceFront)
    {
        self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }else{
        self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    
}

-(void)getPhoto
{
    
    [self.imagePicker startVideoCapture];
}


-(void)pickFromCamera{
    
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        
        self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        [self presentViewController:self.imagePicker animated:NO completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"failed to camera"
                              message:@""
                              delegate:nil
                              cancelButtonTitle:@"OK!"
                              otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.videoURL = info[UIImagePickerControllerMediaURL];
    
//    NSLog(@"%d kb", [self getFileSize:[[_videoURL absoluteString] substringFromIndex:16]]);
    
    NSLog(@"%.0f s", [self getVideoDuration:_videoURL]);
   
   
    _againPhotoBtn.hidden=NO;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [picker dismissViewControllerAnimated:NO completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - private Method

- (NSInteger) getFileSize:(NSString*) path
{
    NSFileManager * filemanager = [[NSFileManager alloc]init];
    if([filemanager fileExistsAtPath:path]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        NSNumber *theFileSize;
        if ( (theFileSize = [attributes objectForKey:NSFileSize]) )
            return  [theFileSize intValue] / 1024;
        else
            return -1;
    }
    else
    {
        return -1;
    }
}

- (CGFloat) getVideoDuration:(NSURL*) URL
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:URL options:opts];
    float second = 0;
    second = urlAsset.duration.value/urlAsset.duration.timescale;
    return second;
}



@end
