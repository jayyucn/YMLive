////
////  MyVideoDetailViewController.m
////  XCLive
////
////  Created by 王威 on 15/3/20.
////  Copyright (c) 2015年 www.0x123.com. All rights reserved.
////
//
//#import "MyVideoDetailViewController.h"
//#import "VideoDetailTopView.h"
////#import "MVBaseViewController.h"
//#import "DetailCommentCell.h"
//#import "DetailVideoCell.h"
//#import "VideoBottomView.h"
//#import "LCChatToolEmoticonContentView.h"
//#import "ESEmoticonManager.h"
//#import "KVNProgress.h"
//#import "MJRefresh.h"
//
//@import AVFoundation;
//@import AssetsLibrary;
//
//@interface MyVideoDetailViewController ()<UITableViewDataSource,UITableViewDelegate,HPGrowingTextViewDelegate,LCChatToolEmoticonContentViewDelegate>
//{
//    LCChatToolEmoticonContentView *_emotionView;
//    //IBOutlet UIButton *_emotionSwitchBtn;
//    CGPoint _tablePoint;
//    BOOL _aniKeyboardShow;
//    UIView *_bgView;
//    UIWindow *_window;
//}
////@property (nonatomic, strong)MVPlayerView *playerView;
//@property (nonatomic, strong)VideoBottomView *bottomViewx;
//@property (nonatomic, assign)BOOL keyboardIsShow;
//
//@end
//
//@implementation MyVideoDetailViewController
//
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerStoped) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [_bottomViewx removeFromSuperview];
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    self.title = @"视频详情";
//    self.view.backgroundColor = UIColorWithRGB(25.f, 24.f, 33.f);
//
//
//    
//    _currentPage = 1;
//    _aniKeyboardShow = NO;
//    
//    _window = [UIApplication sharedApplication].keyWindow;
//    _bgView = [[UIView alloc] initWithFrame:_window.frame];
//    _bgView.backgroundColor = UIColorWithRGB(25.f, 24.f, 33.f);
//    _bgView.alpha = .7f;
//    _bgView.hidden = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHideKeyboard)];
//    [_bgView addGestureRecognizer:tap];
//    [_window addSubview:_bgView];
//    
//
//    
//    [_videoDetailTable setBackgroundView:nil];
//    [_videoDetailTable setBackgroundColor:[UIColor clearColor]];
//    _videoDetailTable.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
//    ESWeakSelf;
////    [_videoDetailTable addFooterWithCallback:^
////    {
////        ESStrongSelf;
////        [_self getMore];
////    }];
//    _videoDetailTable .separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    [_videoDetailTable setDelegate:self];
//    [_videoDetailTable setDataSource:self];
//    _videoDetailTable.width = ScreenWidth;
////    _videoDetailTable.height = ScreenHeight - 40;
//    self.videoDetailTable.height = ScreenHeight - [LCCore globalCore].tabBarController.tabBar.height - 55;
//    _videoDetailTable.separatorColor = UIColorWithRGB(35, 33, 43);
//    
//    if ([self.videoDetailTable respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.videoDetailTable setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    if ([self.videoDetailTable respondsToSelector:@selector(setLayoutMargins:)]) {
//        
//        [self.videoDetailTable setLayoutMargins:UIEdgeInsetsZero];
//    }
//
//    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain handler:^(UIBarButtonItem *barButton)
//    {
//        UIAlertView *alert = [UIAlertView alertViewWithTitle:@"提示" message:@"确定要删除吗?" cancelButtonTitle:@"取消" didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex)
//            {
//                ESStrongSelf;
//                if(buttonIndex == 0)
//                {
//                    [_self deleteVideo];
//                }
//            }
//            otherButtonTitles:@"确定", nil];
//        [alert show];
//
//    }];
//    
//    [self setBottomUI];
//    
//    self.navigationItem.rightBarButtonItem = rightBarButton;
//}
//
//- (void)setBottomUI
//{
//    _bottomViewx = [[[NSBundle mainBundle] loadNibNamed:@"VideoBottomView" owner:self options:nil] lastObject];
//    _bottomViewx.backgroundColor = [UIColor clearColor];
//    _bottomViewx.origin = CGPointMake(0, ScreenHeight - 40);
////    _bottomViewx.frame = CGRectMake(0, ScreenHeight - 40, ScreenWidth, 40);
//    _bottomViewx.contentView.width = ScreenWidth - 60 -_bottomViewx.sendBtn.width;
//    _bottomViewx.sendBtn.left = ScreenWidth - _bottomViewx.sendBtn.width - 10;
//    _contentView = _bottomViewx.contentView;
//    [_contentView setDelegate:self];
//    _contentView.placeholder = @"输入评论内容";
//    
//    _bottomViewx.emotionSwitchBtn.selected = YES;
//    [_bottomViewx.emotionSwitchBtn addTarget:self action:@selector(showEmotionKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
//    [_bottomViewx.sendBtn addTarget:self action:@selector(submitComment) forControlEvents:UIControlEventTouchUpInside];
//    [_window addSubview:_bottomViewx];
//}
//
//- (void)getMore
//{
//    if (_currentPage >= 1)
//    {
//        _currentPage ++;
//        [self getMoreCommentDataWithVideo];
//    }
//}
//
//- (void)setVideoID:(NSString *)videoID
//{
//     NSLog(@"%@",_videoID);
//    _videoID = videoID;
//    [self getVideoDetailData:_videoID];
//}
//
//- (void)tapHideKeyboard
//{
//    [self dismissBgView];
//    if (_contentView.isFirstResponder)
//    {
//        [_bottomViewx.emotionSwitchBtn setImage:UIImageFrom(@"btn_publish_keyboard_b") forState:UIControlStateNormal];
//        [_contentView resignFirstResponder];
//    }
//    _bottomViewx.emotionSwitchBtn.selected = !_bottomViewx.emotionSwitchBtn.selected;
//    if (_aniKeyboardShow)
//    {
//        [UIView animateWithDuration:0.2 animations:^
//         {
//             _emotionView.frame = CGRectMake(0, self.view.height, self.view.width,240);
//             CGRect rect = _bottomViewx.frame;
//             rect.origin.y = self.view.height - rect.size.height;
//             _bottomViewx.frame = rect;
//         } completion:^(BOOL isFinshed)
//         {
//             if (isFinshed)
//             {
//                 [_bottomViewx.emotionSwitchBtn setImage:UIImageFrom(@"btn_publish_face_b.png") forState:UIControlStateNormal];
//
//             }
//         }];
//        //[self dismissEmotionKeyboardWithAnimation];
//    }
//}
//
//#pragma mark ---
//#pragma mark UIKeyboard Notification
//
//- (void)keyboardWillShow:(NSNotification *)notification
//{
//    NSLog(@"执行几次？？？");
//    NSDictionary *userInfo = notification.userInfo;
//    
//    NSString *keyboard_frame_begin_NSRectString = [userInfo[UIKeyboardFrameBeginUserInfoKey] description];
//    
//    NSString *keyboard_frame_begin_CGRectString= nil;
//    
//    if ([keyboard_frame_begin_NSRectString hasPrefix:@"NSRect"])
//    {
//        keyboard_frame_begin_CGRectString=[keyboard_frame_begin_NSRectString stringByReplacingOccurrencesOfString:@"NSRect"withString:@"CGRect" ];
//        
//    }
//    else if( [keyboard_frame_begin_NSRectString hasPrefix:@"CGRect"])
//    {
//        
//        keyboard_frame_begin_CGRectString=keyboard_frame_begin_NSRectString;
//        
//    }
//    
//    CGRect keyboard_frame_begin= CGRectFromString(keyboard_frame_begin_CGRectString);
//    
//    NSString *keyboard_frame_end_NSRectString= [userInfo[UIKeyboardFrameEndUserInfoKey] description];
//    
//    NSString *keyboard_frame_end_CGRectString= nil;
//    
//    if ([keyboard_frame_end_NSRectString hasPrefix:@"NSRect"])
//    {
//        keyboard_frame_end_CGRectString=[keyboard_frame_end_NSRectString stringByReplacingOccurrencesOfString:@"NSRect"withString:@"CGRect" ];
//    }
//    else if( [keyboard_frame_end_NSRectString hasPrefix:@"CGRect"])
//    {
//        keyboard_frame_end_CGRectString=keyboard_frame_end_NSRectString;
//    }
//    
//    CGRect keyboard_frame_end = CGRectFromString(keyboard_frame_end_CGRectString);
//    
//    CGRect rect = self.bottomViewx.frame;
//    
//    CGFloat y_keyboard_begin = keyboard_frame_begin.origin.y;
//    
//    CGFloat y_keyboard_end = keyboard_frame_end.origin.y;
//    
//    CGFloat y_current = CGRectGetMinY(rect);
//    
//    CGFloat y_keyboard_change = y_keyboard_end - y_keyboard_begin;
//    
//    CGFloat y = y_current + y_keyboard_change;
//    NSLog(@"y===========%f",y );
//    if(y!= 209.f)
//    {
//        
//        //NSLog(@"y===========%f",y );
//        rect.origin.y =  y;
//        self.bottomViewx.frame = rect;
//    }
//
//}
//
//- (void)showEmotionKeyBoard:(UIButton *)btn
//{
//    
//    [self showBgView];
//    if (btn.selected)
//    {
//        [btn setImage:UIImageFrom(@"btn_publish_keyboard_b") forState:UIControlStateNormal];
//        if(!_emotionView)
//        {
//            _emotionView  = [[LCChatToolEmoticonContentView alloc] initWithFrame:CGRectMake(0, self.view.height, self.view.width,240)];
//            [_emotionView setDelegate:self];
//            [_window addSubview:_emotionView];
//        }
//        btn.selected = !btn.selected;
//        [self showEmotionKeyboardWithAnimation];
//    }
//    else
//    {
//        btn.selected = !btn.selected;
//        [btn setImage:UIImageFrom(@"btn_publish_face_b.png") forState:UIControlStateNormal];
//        [self dismissEmotionKeyboardWithAnimation];
//    }
//}
//
//- (void)showBgView
//{
//    _bgView.hidden = NO;
//}
//
//- (void)dismissBgView
//{
//    _bgView.hidden = YES;
//}
//
//- (void)showEmotionKeyboardWithAnimation
//{
//    //[_contentView resignFirstResponder];
//
//    if (_contentView.isFirstResponder)
//    {
//        [self performSelector:@selector(showEmotionKeyboardWithAnimation) withObject:nil afterDelay:.1f];
//        [_contentView resignFirstResponder];
//    }
//    else
//    {
//        ESWeakSelf;
//        [UIView animateWithDuration:0.2 animations:^
//         {
//             ESStrongSelf;
//             _emotionView.frame = CGRectMake(0, self.view.height - 240, self.view.width,240);
//             CGRect rect = _bottomViewx.frame;
//             rect.origin.y = rect.origin.y - 240;
//             _bottomViewx.frame = rect;
//             _aniKeyboardShow = YES;
//             
//         }];
//    }
//}
//
//- (void)dismissEmotionKeyboardWithAnimation
//{
//    [UIView animateWithDuration:0.2 animations:^
//     {
//         _emotionView.frame = CGRectMake(0, self.view.height, self.view.width,240);
//         CGRect rect = _bottomViewx.frame;
//         rect.origin.y = self.view.height - rect.size.height;
//         _bottomViewx.frame = rect;
//     } completion:^(BOOL isFinshed)
//     {
//         if (isFinshed)
//         {
//             [_contentView becomeFirstResponder];
//         }
//     }];
//}
//
//- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView
//{
//    //[self dismissEmotionKeyboardWithAnimation];
//}
//
//- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView
//{
//    
//    [self showBgView];
//    if(!_bottomViewx.emotionSwitchBtn.selected)
//    {
//        [_bottomViewx.emotionSwitchBtn setImage:UIImageFrom(@"btn_publish_face_b.png") forState:UIControlStateNormal];
//        [self dismissEmotionKeyboardWithAnimation];
//    }
//    return YES;
//}
//
//#pragma mark ---
//#pragma mark LCChatToolEmoticonContentViewDelegate
//
//- (void)emoticonContentView:(LCChatToolEmoticonContentView *)contentView didSelectEmoticon:(NSString *)emoticon
//{
//    NSLog(@"%@",emoticon);
//    [self replaceStringInTextView:emoticon];
//    
//}
//- (void)emoticonContentViewDeleteBackward:(LCChatToolEmoticonContentView *)contentView
//{
//    [self deleteBackwardInTextView];
//}
//
//- (void)replaceStringInTextView:(NSString *)text
//{
//    [self replaceStringInTextView:text inRange:_contentView.selectedRange];
//}
//
//- (void)replaceStringInTextView:(NSString *)text inRange:(NSRange)range
//{
//    _contentView.text = [_contentView.text replaceInRange:range with:text];
//    _contentView.selectedRange = NSMakeRange(range.location + text.length, 0);
//}
//
//- (void)deleteBackwardInTextView
//{
//    NSRange seletedRange = _contentView.selectedRange;
//    if (seletedRange.length > 0)
//    {
//        [self replaceStringInTextView:@""];
//        return;
//    }
//    NSRange textRange = NSMakeRange(0, seletedRange.location);
//    NSRange lastEmoticonRange = [[ESEmoticonManager sharedManager]
//                                 rangeOfLastMatchedEmoticonInString:_contentView.text
//                                 range:textRange];
//    if (lastEmoticonRange.length > 0)
//    {
//        [self replaceStringInTextView:@"" inRange:lastEmoticonRange];
//        return;
//    }
//    [_contentView.internalTextView deleteBackward];
//}
//
//#pragma mark ---
//#pragma mark Submit Method
//
//- (IBAction)submitComment
//{
//    NSString *contentStr = _contentView.text;
//    
//   // [_contentView resignFirstResponder];
//    //[self dismissEmotionKeyboardWithAnimation];
//    [self tapHideKeyboard];
//    [self.videoDetailTable setContentOffset:CGPointMake(0, 0) animated:YES];
//    if([contentStr isEqualToString:@""] || [contentStr isEqual:[NSNull null]])
//    {
//        [KVNProgress showErrorWithStatus:@"请输入内容!"];
//        
//        return;
//    }
//    NSLog(@"%@",contentStr);
//    [self commiteCommentData:contentStr];
//}
//
//#pragma mark ---
//#pragma mark UITableView DataSource
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return _commentArray.count + 1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *commentCellIndentifier = @"commentCell";
//    static NSString *videoCellIndentifier = @"videoCell";
//    if (indexPath.row == 0)
//    {
//        DetailVideoCell  *cell = [tableView dequeueReusableCellWithIdentifier:videoCellIndentifier];
//        if (!cell)
//        {
//            cell = [[DetailVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:videoCellIndentifier];
//        }
//        cell.playerScrollView.width = ScreenWidth;
////        [cell.playerScrollView addSubview:_playerView];
//        cell.backgroundColor = [UIColor clearColor];
//        cell.commentCountLabel.text = self.contentDic[@"comm_total"];
//        self.commtenTotalLabel = cell.commentCountLabel;
//        return cell;
//    }
//    else
//    {
//        DetailCommentCell  *cell = [tableView dequeueReusableCellWithIdentifier:commentCellIndentifier];
//        if (!cell)
//        {
//            cell = [[DetailCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentCellIndentifier];
//        }
//        NSDictionary *dic = self.commentArray[indexPath.row - 1];
//        [cell.userFaceImage sd_setImageWithURL:dic[@"face"] placeholderImage:UIImageFrom(@"image/globle/placeholder")];
//        cell.nameLabel.text = dic[@"nickname"];
//        NSString *html = [[self class] HTMLFromMessageContent:dic[@"msg"]];
//        cell.contentLabel.text = [TTStyledText textFromXHTML:html lineBreaks:YES URLs:YES];
//        cell.backgroundColor = [UIColor clearColor];
//        return cell;
//    }
//    return 0;
//}
//
//#pragma mark ---
//#pragma mark Table view delegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//   if(indexPath.row != 0)
//   {
//       __block NSDictionary *commentDic = _commentArray[indexPath.row - 1];
//       ESWeakSelf;
//       UIActionSheet *act = [UIActionSheet actionSheetWithTitle:nil cancelButtonTitle:@"取消" didDismissBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex)
//        {
//            ESStrongSelf;
//            if(buttonIndex == 0)
//            {
//                [_self.contentView  becomeFirstResponder];
//                _self.contentView.text = NSStringWith(@"@%@:",commentDic[@"nickname"]);
//            }
//            else if (buttonIndex == 1)
//            {
//
//                [_self deleteCommentWithId:commentDic];
//            }
//        } otherButtonTitles:@"回复",@"删除", nil];
//       [act showInView:self.view];
//
//   }
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(indexPath.row == 0)
//    {
//        return 300.f;
//    }
//    return 55.f;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 50.f;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    VideoDetailTopView *topView = [[VideoDetailTopView alloc] initWithFrame:CGRectMake(0, 0, self.view.size.width, 60)];
//    
//    [topView.faceImage sd_setImageWithURL:[NSURL URLWithString:_contentDic[@"face"]] placeholderImage:[UIImage imageNamed:@""]];
//    topView.timeLabel.text = _contentDic[@"time"];
//    topView.nameLabel.text = _contentDic[@"nickname"];
//    topView.backgroundColor = UIColorWithRGB(25.f, 24.f, 33.f);;
//    return topView;
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    NSLog(@"dadadadsadafafsa");
//    _tablePoint = _videoDetailTable.contentOffset;
//    NSLog(@">>>>>>%f",_tablePoint.y);
//}
//
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
//    {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
//    {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}
//
//#pragma mark ---
//#pragma mark Player status
//
//- (void)setPlayView
//{
//    /* Player view */
////    ESWeakSelf;
////    MVPlayer *player = [[MVPlayer alloc] initWithURL:NSURLWith(@"%@",_contentDic[@"url"])];
////    
////    player.loopEnabled = YES;
////    [MVPlayer playerWithDidPlayToEndTimeBlock:^(MVPlayer *player, AVPlayerItem *currentOriginalItem, NSError *error)
////    {
////        NSLog(@"结束了啊啊啊啊啊a");
////    }];
////    self.playerView = [[MVPlayerView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 250) player:player];
////    _playerView.backgroundColor = [UIColor clearColor];
////    self.playerView.imageForPausedState = UIImageFromCache(@"video_play_button");
////    [self startPlaying];
////    
////    [self.playerView setTapActionHandler:^(MVPlayerView *playerView, BOOL isPlaying)
////     {
////        ESStrongSelf;
////         NSLog(@"player view taped");
////        _self->_flag.playerPaused = !isPlaying;
////    }];
//}
//
//- (void)_updateUI
//{
////    self.playerView.imageViewForPausedState.hidden = self.playerView.player.isPlaying;
//}
//
//- (void)updateUI
//{
//    ESWeakSelf;
//    ESDispatchOnMainThreadAsynchronously(^{
//        ESStrongSelf;
//        [_self _updateUI];
//    });
//}
//
//- (void)pausePlaying
//{
////    [self.playerView.player pause];
//    [self updateUI];
//}
//
//- (void)resumePlaying
//{
//    if (_flag.playerPaused) {
//        return;
//    }
//    
////    if (!self.playerView.player.currentOriginalItem) {
////        [self startPlaying];
////    } else {
////        _flag.playerPaused = NO;
////        [self.playerView.player play];
////        [self updateUI];
////    }
//}
//
//- (void)startPlaying
//{
//    _flag.playerPaused = NO;
////    [self.playerView.player play];
//}
//
//- (void)playerStoped
//{
////    NSLog(@"你播放结束的了么骚年");
////    [self.playerView.player replaceCurrentItemWithURL:NSURLWith(@"%@",_contentDic[@"url"])];
////    //[self.playerView.player replaceCurrentItemWithPlayerItem:self.recordSession.playerItem];
////    self.playerView.imageViewForPausedState.hidden = NO;
////    [self.playerView.player pause];
//}
//
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end
