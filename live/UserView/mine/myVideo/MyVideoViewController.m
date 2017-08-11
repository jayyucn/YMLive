//
//  MyVideoViewController.m
//  XCLive
//
//  Created by 王威 on 15/3/19.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import "MyVideoViewController.h"
#import "VideoCollectionViewCell.h"
#import "MyVideoModel.h"
//#import "MVRecorderViewController.h"
#import "MJRefresh.h"
#import "MyVideoDetailViewController.h"
#import "MyVideoCell.h"
#import "MyVideoDetailViewController.h"

@import AVFoundation;
@import AssetsLibrary;

//UICollectionViewDataSource
@interface MyVideoViewController ()<UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
//    MVPlayerView *_currentPlayerView;
    IBOutlet UIImageView *_bottomImage;
    IBOutlet UIButton *_creatVideoBtn;
}


//@property (nonatomic, strong)MVPlayerView *playerView;
@property (nonatomic, strong)NSMutableArray *playVideoArray;
@property (nonatomic,assign)NSInteger currTag;

@end

@implementation MyVideoViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的视频";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerStoped) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    _currentPage = 1;
    self.playVideoArray = [NSMutableArray arrayWithCapacity:0];
    _myVideoTable.width = self.view.width;
    _myVideoTable.height = self.view.height - 44;
    _bottomImage.width = ScreenWidth;
    _bottomImage.bottom = ScreenHeight;
    _creatVideoBtn.centerX = ScreenWidth / 2;
    _creatVideoBtn.bottom = ScreenHeight;
//    ESWeakSelf;
//    [_myVideoTable addHeaderWithCallback:^
//     {
//         ESStrongSelf;
//         [_self getMyVideoData];
//     }];
//    [_myVideoTable headerBeginRefreshing];
//    
//    [_myVideoTable addFooterWithCallback:^
//    {
//        ESStrongSelf;
//        [_self getMoreData];
//    }];
    
        //[self getMyVideoData];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self playerStoped];
}

- (void)getMoreData
{
    if (_currentPage >= 1)
    {
        _currentPage ++;
        [self getMoreVideoData];
    }
}

- (void)setTable
{
    [_myVideoTable setDelegate:self];
    [_myVideoTable setDataSource:self];
    _myVideoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myVideoTable reloadData];
}

#pragma mark ---
#pragma mark UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _videoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cell";
    MyVideoModel *model = _videoArray[indexPath.row];
    MyVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if (!cell)
    {
        cell = [[MyVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier withVideoUrl:model.videoUrl];
    }
    
    [self setTableVideoWithUrl:model.videoUrl cell:cell indexPath:indexPath];
    cell.replyBtn.tag = indexPath.row;
    [cell.replyBtn addTarget:self action:@selector(goVideoDetail:) forControlEvents:UIControlEventTouchUpInside];
    [cell.replyBtn setTitle:NSStringWith(@"评论   %@",model.commentStr) forState:UIControlStateNormal];
    
    [cell.timeBtn setTitle:NSStringWith(@"时间   %@",model.timeStr) forState:UIControlStateNormal];
    cell.backgroundColor = UIColorWithRGB(25.f, 24.f, 33.f);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 320.f;
}

- (void)setTableVideoWithUrl:(NSString *)url cell:(MyVideoCell *)cell indexPath:(NSIndexPath *)index
{
//    MVPlayer *player = nil;
//    MVPlayerView *playerView = nil;
//    
//    if (index.row + 1 <= self.playVideoArray.count)
//    {
//        playerView = _playVideoArray[index.row];
//    }
//    else
//    {
//        player = [[MVPlayer alloc] initWithURL:NSURLWith(@"%@",url)];
//        playerView = [[MVPlayerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 270) player:player];
//        playerView.tag = index.row;
//        [self.playVideoArray addObject:playerView];
//    }
//    player.loopEnabled = YES;
//    cell.playerScrollView.width = ScreenWidth;
//    [cell.playerScrollView addSubview:playerView];
//
//    _playerView.backgroundColor = [UIColor clearColor];
//    _flag.playerPaused = YES;
//    playerView.imageViewForPausedState.hidden = NO;
//    [playerView.player pause];
//    playerView.imageForPausedState = UIImageFromCache(@"video_play_button");
//    
//    ESWeakSelf;
//    [playerView setTapActionHandler:^(MVPlayerView *playerView, BOOL isPlaying)
//     {
//         ESStrongSelf;
//         NSLog(@"player view taped");
////         if (_currentPlayerView)
////         {
////             [_self pausePlaying];
////         }
//         
////         if (_self.currTag  > 0) {
////             [_self stopVideoPlay:_self.currTag];
////         }
////         
////         _self.currTag = playerView.tag;
//         _currentPlayerView = playerView;
//         _self->_flag.playerPaused = !isPlaying;
////         [_self startPlaying];
//    }];
}

- (void)_updateUI
{
//    _currentPlayerView.imageViewForPausedState.hidden = self.playerView.player.isPlaying;
}

- (void)updateUI
{
    ESWeakSelf;
    ESDispatchOnMainThreadAsynchrony(^{
        ESStrongSelf;
        [_self _updateUI];
    });
}

- (void)pausePlaying
{
//    [_currentPlayerView.player pause];
    [self updateUI];
}

- (void)resumePlaying
{
//    if (_flag.playerPaused) {
//        return;
//    }
//    
//    if (!_currentPlayerView.player.currentOriginalItem) {
//        [self startPlaying];
//    } else {
//        _flag.playerPaused = NO;
//        [_currentPlayerView.player play];
//        [self updateUI];
//    }
}

- (void)startPlaying
{
    if (self.currTag > 0) {
        [self stopVideoPlay:self.currTag];
    }
    
    _flag.playerPaused = NO;
//    self.currTag = _currentPlayerView.tag;
//    [_currentPlayerView.player play];
}

- (void)playerStoped
{
//    [self stopVideoPlay:_currentPlayerView.tag];
}

- (void) stopVideoPlay:(NSInteger)index
{
    if (_videoArray && _videoArray.count > index)
    {
        __unused MyVideoModel *model = _videoArray[index];
//        [_currentPlayerView.player replaceCurrentItemWithURL:NSURLWith(@"%@",model.videoUrl)];
//        //[self.playerView.player replaceCurrentItemWithPlayerItem:self.recordSession.playerItem];
//        _currentPlayerView.imageViewForPausedState.hidden = NO;
//        [_currentPlayerView.player pause];
    }
}

#pragma mark ---
#pragma mark Button Clicked Method

- (void)goVideoDetail:(UIButton *)btn
{
//    int index = (int )btn.tag;
//    MyVideoModel *model = _videoArray[index];
//    MyVideoDetailViewController *detailVC = [[[NSBundle mainBundle] loadNibNamed:@"MyVideoDetailViewController" owner:self options:nil] lastObject];
//    detailVC.videoID = model.videoId;
//    [self.navigationController pushViewController:detailVC animated:YES];
}

- (IBAction)goCamera:(id)sender
{
//    if (ESIsStringWithAnyText([LCMyUser mine].videoURL) &&
//        [[LCMyUser mine].videoURL.lowercaseString hasPrefix:@"http"])
//    {
//        ESWeakSelf;
//        UIActionSheet *action = [UIActionSheet actionSheetWithTitle:nil
//                                                  cancelButtonTitle:@"取消"
//                                                    didDismissBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex)
//                                 {
//                                     ESStrongSelf;
//                                     if (0 == buttonIndex) {
//                                         [_self recordVideo];
//                                     } else if (1 == buttonIndex) {
//                                         UIAlertView *alert = [UIAlertView alertViewWithTitle:@"确定要删除个人视频吗?" message:nil cancelButtonTitle:@"取消" didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
//                                             if (buttonIndex != alertView.cancelButtonIndex) {
//                                                 ESStrongSelf;
//                                                 [_self removeVideo];
//                                             }
//                                         } otherButtonTitles:@"确定删除", nil];
//                                         [alert show];
//                                     }
//                                 } otherButtonTitles:@"录制个人视频", @"删除个人视频", nil];
//        action.destructiveButtonIndex = 1;
//        [action showInView:self.view];
//    } else {
//        [self recordVideo];
//    }

}

- (void)recordVideo
{
    if ([[AVCaptureDevice class] respondsToSelector:@selector(authorizationStatusForMediaType:)])
    {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        
        if(authStatus==AVAuthorizationStatusRestricted||authStatus==AVAuthorizationStatusDenied)
        {
            //[LCNoticeAlertView showMsg:@"相机已禁用，请在系统设置里打开应用相机权限"];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"相机已禁用，请在系统设置里打开应用相机权限"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil,nil];
            
            [alert show];
            
            return;
        }
        
    }
    
#if 0
    PBJViewController *jControlller=[[PBJViewController alloc] init];
    //[self.navigationController pushViewController:jControlller animated:YES];
    BaseNavigationController *videoNav=[[BaseNavigationController alloc] initWithRootViewController:jControlller];
    
    [self.navigationController presentModalViewController:videoNav animated:YES];
#else
//    /* 设置草稿保存在用户目录下 */
//    [MVRecorderSession setRootDirectory:[[LCMyUser mine].documentsDirectory appendPathComponent:@"video_recorder"]];
//    
//    /* 创建录制配置 */
//    MVConfig *config = [MVConfig defaultConfig];
//    // 最短和最长录制时间
//    config.minRecordedDuration = 5;
//    config.maxRecordedDuration = 20;
//    // 视频尺寸
//    config.videoSize = 480;
//    // 默认前置还是后置摄像头
//    config.preferredCameraPosition = AVCaptureDevicePositionFront;
//    
////    /* 打开拍摄界面 */
////    ESWeakSelf;
////    [MVRecorderViewController presentWithConfig:config finishedBlock:^(MVRecorderViewController *recorderController, MVRecorderSession *recorderSession)
////    {
////        // NSLog(@"RecorderViewController finished with session: %@", recorderSession);
////        [recorderController.presentingViewController dismissViewControllerAnimated:YES completion:^{
////            ESStrongSelf;
////            [_self getMyVideoData];
////        }];
////    }];
#endif
}

- (void)removeVideo
{
//    ESWeakSelf;
//    [LCJSONClient get:@"/profile/videoshow" parameters:@{@"type":@(0)} success:^(NSDictionary *result) {
//        if ([result isKindOfClass:[NSDictionary class]]) {
//            int ok = 0;
//            if (ESIntVal(&ok, result[@"stat"]) && 200 == ok) {
////                [LCMyUser mine].videoURL = @"";
//                [[LCMyUser mine] save];
//                ESStrongSelf;
//                if (_self.isViewVisible) {
//                    [JDMessageView showWithSuperView:_self.view title:@"个人视频已删除!" message:nil];
//                }
//                return;
//            }
//        }
//        
//        ESStrongSelf;
//        if (_self.isViewVisible)
//            [JDMessageView showWithSuperView:_self.view title:@"个人视频删除失败,请重试" message:nil];
//        
//    } failure:^(NSError *error) {
//        ESStrongSelf;
//        if (_self.isViewVisible)
//            [JDMessageView showWithSuperView:_self.view title:@"个人视频删除失败,请重试" message:nil];
//    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected obCmeraject to the new view controller.
}
*/

@end
