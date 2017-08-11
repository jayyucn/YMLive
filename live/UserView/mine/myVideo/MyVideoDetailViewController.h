////
////  MyVideoDetailViewController.h
////  XCLive
////
////  Created by 王威 on 15/3/20.
////  Copyright (c) 2015年 www.0x123.com. All rights reserved.
////
//
//#import <UIKit/UIKit.h>
//
//@interface MyVideoDetailViewController : UIViewController
//{
//    struct {
//        // 用户手动暂停了
//        unsigned int playerPaused:1;
//        unsigned int viewAppearing:1;
//        unsigned int submitting:1;
//        unsigned int isObserverThumbnailActualTime:1;
//        unsigned int isPopingBack:1;
//        unsigned int isRefreshingMusic:1;
//    } _flag;
//
//}
//@property (nonatomic, strong)IBOutlet UITableView *videoDetailTable;
//@property (nonatomic, strong)NSString *videoID;
//@property (nonatomic, strong)NSMutableDictionary *contentDic;
//@property (nonatomic, strong)NSMutableArray *commentArray;
////@property (nonatomic, strong)MVRecorderSession *recordSession;
////@property(nonatomic, strong)HPGrowingTextView *contentView;
//@property (nonatomic, assign)int currentPage;
//@property (nonatomic, strong)UILabel *commtenTotalLabel;
//
//
//- (void)setPlayView;
//@end
//
//@interface MyVideoDetailViewController (Network)
//
//- (void)getVideoDetailData:(NSString *)videoId;
//- (void)commiteCommentData:(NSString *)content;
//- (void)deleteCommentWithId:(NSDictionary *)commDic;
//- (void)deleteVideo;
//- (void)getMoreCommentDataWithVideo;
//@end
//
//@interface MyVideoDetailViewController (Helper)
//+ (NSString *)HTMLFromMessageContent:(NSString *)content;
//@end