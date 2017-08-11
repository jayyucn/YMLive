//
//  MyVideoViewController.h
//  XCLive
//
//  Created by 王威 on 15/3/19.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyVideoViewController : UIViewController
{
    struct {
        // 用户手动暂停了
        unsigned int playerPaused:1;
        unsigned int viewAppearing:1;
        unsigned int submitting:1;
        unsigned int isObserverThumbnailActualTime:1;
        unsigned int isPopingBack:1;
        unsigned int isRefreshingMusic:1;
    } _flag;
}

@property (nonatomic,assign)int currentPage;
@property (nonatomic, strong)IBOutlet UICollectionView *videoCollectionView;
@property (nonatomic, strong)IBOutlet UITableView *myVideoTable;
@property (nonatomic, strong)NSMutableArray *videoArray;

- (void)setTable;

@end

@interface MyVideoViewController (Network)
- (void)getMyVideoData;
- (void)getMoreVideoData;
@end