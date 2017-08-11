//
//  TrailerLiveViewController.m
//  live
//
//  Created by hysd on 15/8/20.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import "TrailerLiveViewController.h"
#import "Macro.h"
#import "TrailerView.h"
#import "LiveView.h" 
#import "SegmentView.h"
#import "TimePickView.h"
#import "Business.h"
#import "Common.h" 
#import "MBProgressHUD.h" 
#import "UIImage+Category.h"

#define TITLE_LENGHT 32

@interface TrailerLiveViewController ()<UITextViewDelegate>
{
//    SegmentView* segmentView;
//    UIScrollView* scrollView;
//    UIView* contentView;
//    LiveView* liveView;
//    StartLiveView *startLiveView;
//    TrailerView* trailerView;
//    TimePickView* timePickView;
//    MBProgressHUD* HUD;
    
    UIButton    *closeLiveBtn;
    
    UITextView *liveTitleTextView;
    UILabel *promptLabel;
    
    UIView *shareView;
    UIButton *sinaShareBtn;
    UIButton *wxShareBtn;
    UIButton *wxCircleShareBtn;
    UIButton *qqShareBtn;
    UIButton *qqZoneShareBtn;
    
    UIButton  *startLiveBtn;
}
@end

@implementation TrailerLiveViewController

- (void)dealloc
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self createNavView];
//    [self createScrollView];
//    [self createLiveView];
//    [self createTrailerView];
//    [self createDatePickeView];
//    
//    //初始化MBProgressHUD
//    HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:HUD];
//    [HUD show:YES];
//    HUD.hidden = YES;
    
    [self hideStatusBar];
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgImgView.image = [UIImage imageNamed:@"image/liveroom/room_start_live_bg"];
    [self.view addSubview:bgImgView];
    
    UIImage *roomShutImage = [UIImage imageNamed:@"image/liveroom/roomshut"];
    closeLiveBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - roomShutImage.size.width *3/5 -5, 25, roomShutImage.size.width *3/5, roomShutImage.size.height *3/5)];
    [closeLiveBtn setImage:roomShutImage forState:UIControlStateNormal];
    [closeLiveBtn addTarget:self action:@selector(closeRoomAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeLiveBtn];
    
    
    promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/6, SCREEN_WIDTH, 50)];
    promptLabel.text = @"给直播写个标题吧";
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.font = [UIFont systemFontOfSize:22];
    promptLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:promptLabel];
    
    UIView * contentContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, promptLabel.top, SCREEN_WIDTH, 100)];
    //发送框容器
    contentContainerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:contentContainerView];
    
    liveTitleTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, contentContainerView.height)];
    liveTitleTextView.text = @"";
    liveTitleTextView.backgroundColor = [UIColor clearColor];
    liveTitleTextView.textColor = [UIColor whiteColor];
    liveTitleTextView.delegate = self;
    liveTitleTextView.font = [UIFont systemFontOfSize:22.f];
    [liveTitleTextView setReturnKeyType:UIReturnKeyDefault];
    [contentContainerView addSubview:liveTitleTextView];
    [liveTitleTextView becomeFirstResponder];
    
    shareView = [[UIView alloc] initWithFrame:CGRectMake(0, contentContainerView.bottom+10, SCREEN_WIDTH, 40)];
    [self.view addSubview:shareView];
    shareView.userInteractionEnabled = YES;
    
    
    UIImage *sinaNormalImg = [UIImage imageNamed:@"image/liveroom/b_weibo_h"];
    UIImage *sinaFocusImg = [UIImage imageNamed:@"image/liveroom/b_weibo_n"];
    sinaShareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, sinaNormalImg.size.width, sinaNormalImg.size.height)];
    sinaShareBtn.center = CGPointMake(20+(SCREEN_WIDTH-40)/10, shareView.top+25);
    [sinaShareBtn setImage:sinaNormalImg forState:UIControlStateNormal];
    [sinaShareBtn setImage:sinaFocusImg forState:UIControlStateSelected];
    [self.view addSubview:sinaShareBtn];
    
    
    UIImage *wxNormalImg = [UIImage imageNamed:@"image/liveroom/b_weixin_h"];
    UIImage *wxFocusImg = [UIImage imageNamed:@"image/liveroom/b_weixin_n"];
    wxShareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, sinaNormalImg.size.width, sinaNormalImg.size.height)];
    wxShareBtn.center = CGPointMake(20+(SCREEN_WIDTH-40)/5+(SCREEN_WIDTH-40)/10, shareView.top+25);
    [wxShareBtn setImage:wxNormalImg forState:UIControlStateNormal];
    [wxShareBtn setImage:wxFocusImg forState:UIControlStateSelected];
    [self.view addSubview:wxShareBtn];
    
    UIImage *wxCircleNormalImg = [UIImage imageNamed:@"image/liveroom/b_pengyouquan_h"];
    UIImage *wxCircleFocusImg = [UIImage imageNamed:@"image/liveroom/b_pengyouquan_n"];
    wxCircleShareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, sinaNormalImg.size.width, sinaNormalImg.size.height)];
    wxCircleShareBtn.center = CGPointMake(20+(SCREEN_WIDTH-40)*2/5 + (SCREEN_WIDTH-40)/10, shareView.top+25);
    [wxCircleShareBtn setImage:wxCircleNormalImg forState:UIControlStateNormal];
    [wxCircleShareBtn setImage:wxCircleFocusImg forState:UIControlStateSelected];
    [self.view addSubview:wxCircleShareBtn];
    
    
    UIImage *qqNormalImg = [UIImage imageNamed:@"image/liveroom/b_qq_h"];
    UIImage *qqFocusImg = [UIImage imageNamed:@"image/liveroom/b_qq_n"];
    
    qqShareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, sinaNormalImg.size.width, sinaNormalImg.size.height)];
    qqShareBtn.center = CGPointMake(20+(SCREEN_WIDTH-40)*3/5 + (SCREEN_WIDTH-40)/10, shareView.top+25);
    [qqShareBtn setImage:qqNormalImg forState:UIControlStateNormal];
    [qqShareBtn setImage:qqFocusImg forState:UIControlStateSelected];
    [self.view addSubview:qqShareBtn];
    
    UIImage *qqZoneNormalImg = [UIImage imageNamed:@"image/liveroom/b_kongjian_h"];
    UIImage *qqZoneFocusImg = [UIImage imageNamed:@"image/liveroom/b_kongjian_n"];
    
    qqZoneShareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, sinaNormalImg.size.width, sinaNormalImg.size.height)];
    qqZoneShareBtn.center = CGPointMake(20+(SCREEN_WIDTH-40)*4/5 + (SCREEN_WIDTH-40)/10, shareView.top+25);
    [qqZoneShareBtn setImage:qqZoneNormalImg forState:UIControlStateNormal];
    [qqZoneShareBtn setImage:qqZoneFocusImg forState:UIControlStateSelected];
    [self.view addSubview:qqZoneShareBtn];
    [qqZoneShareBtn addTarget:self action:@selector(qqZoneShareAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImage *startLiveNormalImg = [UIImage imageNamed:@"image/liveroom/room_button"];
    UIImage *startLiveFocusImg = [UIImage imageNamed:@"image/liveroom/room_button_p"];
    
  
    CGFloat left = 30; // 左端盖宽度
    CGFloat right = 30; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(0, left, 0, right);
    // 伸缩后重新赋值
    startLiveNormalImg = [startLiveNormalImg resizableImageWithCapInsets:insets];
    // 伸缩后重新赋值
    startLiveFocusImg = [startLiveFocusImg resizableImageWithCapInsets:insets];
    
    startLiveBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, shareView.bottom+10, SCREEN_WIDTH - 40, startLiveFocusImg.size.height)];
    [startLiveBtn setBackgroundImage:startLiveNormalImg forState:UIControlStateNormal];
    [startLiveBtn setBackgroundImage:startLiveFocusImg forState:UIControlStateHighlighted];
    [startLiveBtn setTitle:@"开始直播" forState:UIControlStateNormal];
    startLiveBtn.titleLabel.text = @"开始直播";
    startLiveBtn.titleLabel.textColor = [UIColor whiteColor];
    [startLiveBtn addTarget:self action:@selector(startLiveAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startLiveBtn];
    
    // 屏蔽微博分享
    sinaShareBtn.hidden = YES;
}


- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [liveTitleTextView resignFirstResponder];
}

#pragma mark 创建滚动视图
- (void)createScrollView
{
//    //设置scrollview
//    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44+STATUS_HEIGHT, self.view.frame.size.width, self.view.frame.size.height-44+STATUS_HEIGHT)];
//    scrollView.backgroundColor = RGB16(COLOR_BG_LIGHTGRAY);
//    scrollView.contentSize = CGSizeMake(2*SCREEN_WIDTH, 0);
//    scrollView.pagingEnabled = YES;
//    scrollView.bounces = NO;
//    scrollView.showsHorizontalScrollIndicator = NO;
//    scrollView.delegate = self;
//    [self.view addSubview:scrollView];
    //设置contentView
//    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,self.view.frame.size.height-44+STATUS_HEIGHT)];
//    contentView.backgroundColor = RGB16(COLOR_BG_WHITE);
//    [self.view addSubview:contentView];
}
#pragma mark 创建分段视图
- (void)createNavView
{
//    //分段视图
//    NSArray* items = [NSArray arrayWithObjects:@"发布直播",@"发布预告", nil];
//    CGRect segmentFrame = CGRectMake(SCREEN_WIDTH/4, 0, SCREEN_WIDTH/2, 44+STATUS_HEIGHT);
//    segmentView = [[SegmentView alloc] initWithFrame:segmentFrame andItems:items andSize:14 border:NO];
//    segmentView.delegate = self;
//    //导航栏
//    UINavigationBar* navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44+STATUS_HEIGHT)];
//    
//    UINavigationItem* navItem = [[UINavigationItem alloc] init];
//    navItem.title = @"发布直播";
//    
//    [navBar pushNavigationItem:navItem animated:NO];
//    [self.view addSubview:navBar];
//    
//    //关闭
//    UIImage *closeImage = [UIImage imageNamed:@"close_red"];
//    UIButton *closeBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
//    [closeBtn setImage:closeImage forState:UIControlStateNormal];
//    [closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
//    [closeBtn setFrame:CGRectMake(0, 0, closeImage.size.width, closeImage.size.height)];
//    navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeBtn];
}

- (void) qqZoneShareAction
{
    NSLog(@"qqzone share action");
    if ( qqZoneShareBtn.isSelected) {
        qqZoneShareBtn.selected = NO;
    } else {
        qqZoneShareBtn.selected = YES;
    }
}

-(void)closeRoomAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark 创建发直播视图
- (void)createLiveView
{
//    liveView = [[[NSBundle mainBundle] loadNibNamed:@"LiveView" owner:self options:nil] lastObject];
//    liveView.frame = CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height);
//    liveView.backgroundColor = [UIColor clearColor];
//    liveView.delegate = self;
    
//    startLiveView = [[StartLiveView alloc] initWithFrame:CGRectMake(0, 0, contentView.width,contentView.height)];
//    startLiveView.delegate = self;
//    [contentView addSubview:startLiveView];
}
#pragma mark 创建发预告视图
- (void)createTrailerView
{
//    trailerView = [[[NSBundle mainBundle] loadNibNamed:@"TrailerView" owner:self options:nil] lastObject];
//    trailerView.frame = CGRectMake(scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height);
//    trailerView.backgroundColor = [UIColor clearColor];
//    trailerView.delegate = self;
//    [contentView addSubview:trailerView];
}
#pragma mark 创建时间选择视图
- (void)createDatePickeView
{
//    timePickView = [[[NSBundle mainBundle] loadNibNamed:@"TimePickView" owner:self options:nil] lastObject];
//    timePickView.delegate = self;
}
#pragma mark scrollview 代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scroll
{
//    CGPoint offset = scrollView.contentOffset;
//    NSInteger page = (offset.x + scrollView.frame.size.width/2) / scrollView.frame.size.width;
//    [segmentView setSelectIndex:page];
}
#pragma mark segmentview 代理
- (void)segmentView:(SegmentView *)segmentView selectIndex:(NSInteger)index
{
//    [UIView animateWithDuration:0.2f animations:^{
//        scrollView.contentOffset = CGPointMake(scrollView.frame.size.width*index, 0);
//    }];
}
- (void)startLiveAction
{
//    if([startLiveView.titleTextView.text isEqualToString:@""])
//    {
//        [[Common sharedInstance] shakeView:liveView.titleTextField];
//        return;
//    }
//#if DEBUG
//    if(self.delegate)
//    {
//        [self.delegate startLiveController:liveView.titleTextField.text image:[UIImage imageNamed:@"default_cover.jpg"]];
//    }
//    
//#else
//    if(![liveView.coverImageView viewWithTag:101])
//    {
        if(self.delegate)
        {
            [self.delegate startLiveController:liveTitleTextView.text image:nil];
        }
//    } else {
//        if(self.delegate)
//        {
//            [self.delegate startLiveController:liveView.titleTextField.text image:liveView.coverImageView.image];
//        }
//
//    }
    
   //#endif
}

#pragma mark trailerview 代理
- (void)trailerViewTakeCover:(TrailerView *)tv
{
    [self openImageActionSheet];
}
- (void)trailerViewPublish:(TrailerView *)tv
{
//    if([trailerView.titleTextField.text isEqualToString:@""])
//    {
//        [[Common sharedInstance] shakeView:trailerView.titleTextField];
//        return;
//    }
//    if(![trailerView.coverImageView viewWithTag:101]){
//        [[Common sharedInstance] shakeView:trailerView.coverImageView];
//        return;
//    }
//    if([trailerView.timeTextField.text isEqualToString:@""])
//    {
//        [[Common sharedInstance] shakeView:trailerView.timeTextField];
//        return;
//    }
//    NSString *futureTime = trailerView.timeTextField.text;
//    [HUD showText:@"正在发布预告" atMode:MBProgressHUDModeIndeterminate];
//    
//    __weak TrailerLiveViewController *ws = self;
//    __weak MBProgressHUD *wh = HUD;
//    [[Business sharedInstance] insertTrailer:trailerView.titleTextField.text phone:[LCMyUser mine].userID time:futureTime image:trailerView.coverImageView.image succ:^(NSString *msg, id data) {
//        [wh hideText:msg atMode:MBProgressHUDModeText andDelay:1 andCompletion:^{
//            [ws dismissViewControllerAnimated:YES completion:^{
//                if(ws.delegate)
//                {
//                    [ws.delegate publishTrailerSuccess];
//                }
//            }];
//        }];
//    } fail:^(NSString *error) {
//        [HUD hideText:error atMode:MBProgressHUDModeText andDelay:1 andCompletion:nil];
//    }];
    
    
}
- (void)trailerViewTime:(TrailerView *)trailerView
{
//    [timePickView showView:self.view];
}
#pragma datepickview liveview 代理
- (void)datePickViewConfirm:(TimePickView *)dpv
{
//    trailerView.timeTextField.text = [timePickView getSelectTime];
//    trailerView.leftTimeLabel.text = [timePickView getLeftTime];
}
#pragma mark 打开拍照或相册
- (void)openImageActionSheet
{
//    [liveView._titleTextView resignFirstResponder];
//    [trailerView.titleTextField resignFirstResponder];
//    [trailerView.timeTextField resignFirstResponder];
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
//    actionSheet.cancelButtonIndex = 2;
//    [actionSheet showInView:self.view];
}
#pragma mark 图片选择
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    UIImageView* imageView = liveView.coverImageView;
//    if(1 == [segmentView getSelectIndex])
//    {
//        imageView = trailerView.coverImageView;
//    }
//    if (buttonIndex == actionSheet.cancelButtonIndex)
//    {
//        return;
//    }
//    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//    imagePicker.delegate = self;
//    imagePicker.allowsEditing = YES;
//    
//    if (buttonIndex == 0 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//    {
//        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    }
//    else if (buttonIndex == 1 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
//    {
//        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    }
//    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    UIImageView* imageView = liveView.coverImageView;
//    if(1 == [segmentView getSelectIndex])
//    {
//        imageView = trailerView.coverImageView;
//    }
//    UIImage* image = info[UIImagePickerControllerEditedImage];
//    CGFloat hOffset = (image.size.height - 2*image.size.width/3)/2;
//    imageView.image = [image getSubImage:CGRectMake(0, hOffset, image.size.width, 2*image.size.width/3)];
//    UIView* tmp = [imageView viewWithTag:101];
//    if(tmp == nil)
//    {
//        UIButton* delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        delBtn.tag = 101;
//        delBtn.frame = CGRectMake(imageView.frame.size.width-20, -10, 30, 30);
//        [delBtn setImage:[UIImage imageNamed:@"close_circle"] forState:UIControlStateNormal];
//        [delBtn addTarget:self action:@selector(delImage:) forControlEvents:UIControlEventTouchUpInside];
//        [imageView addSubview:delBtn];
//    }
//    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 删除封面
- (void)delImage:(id)sender
{
    UIImageView* imageView = (UIImageView*)((UIButton*)sender).superview;
    imageView.image = [UIImage imageNamed:@"addimage"];
    [((UIButton*)sender) removeFromSuperview];
}

#pragma mark 显示status bar
- (void)hideStatusBar
{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView == liveTitleTextView) {
        if (textView.text.length > TITLE_LENGHT) {
            textView.text = [textView.text substringToIndex:TITLE_LENGHT];
        }
        promptLabel.hidden = YES;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string
{
    if (textView == liveTitleTextView) {
        if (textView.text.length == 0) return YES;
        
        NSInteger existedLength = textView.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > TITLE_LENGHT) {
            return NO;
        }
    }
    
    return YES;
}

@end
