//
//  KFTableViewController.h
//  KaiFang
//
//  Created by Elf Sundae on 8/2/13.
//  Copyright (c) 2013 www.0x123.com. All rights reserved.
//

#import "LCViewController.h"
#import <ESFramework/ESFrameworkUIKit.h>

@interface LCTableViewController : LCViewController
<UITableViewDataSource, UITableViewDelegate>
{
        UITableViewStyle _tableViewStyle;
        BOOL _hasRefreshControl;
        int currentPage;
    int locationCurrentPage;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign, readonly) UITableViewStyle tableViewStyle;
@property (nonatomic, strong) NSMutableArray *list, *locationList;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, assign) BOOL isLoadingMore; // 标记正在加载更多。如果正在加载更多时，刷新则停止加载更多。
@property (nonatomic,assign)int currentPage, locationCurrentPage;
@property (nonatomic,assign) BOOL isLocation;
@property (strong,nonatomic)UIButton *loadMoreButton;

@property (nonatomic, assign) BOOL clearsSelectionOnViewWillAppear; // default to YES

@property (nonatomic,assign)BOOL isRefreshing;
@property (nonatomic, assign, readonly) BOOL hasRefreshControl; // 是否有下拉刷新
//@property (nonatomic, strong) ESRefreshControl *refreshHeaderView;

@property (nonatomic,strong)UILabel *noDataNotice;
@property (nonatomic,strong)UIImageView *noDataImageView;
- (ESRefreshControl *)refreshHeaderView;
//@property (nonatomic, strong) ESErrorView *errorView;
//@property (nonatomic, strong) UIView *tableOverlayView;

- (id)initWithStyle:(UITableViewStyle)style hasRefreshControl:(BOOL)hasRefreshControl;
//- (void)showErrorViewWithTitle:(NSString *)title subTitle:(NSString *)subTitle image:(UIImage *)image showReloadButton:(BOOL)showReload;
//- (void)hideErrorView;
//- (void)reloadButtonInErrorViewPressed:(id)sender;

- (void)scrollTableViewToTop:(BOOL)animated;
- (void)setVisibleCellsNeedsDisplay;
- (void)setVisibleCellsNeedsLayout;

// editing
@property (nonatomic, assign) BOOL canEditing;
- (UIBarButtonItem *)editButtonItem;
- (UIBarButtonItem *)doneEditingButtonItem;
- (UIBarButtonItem *)deleteAllButtonItem;


// subclass
- (void)refreshData;
- (void)loadMoreData;
- (void)toggleTableViewEditing;
- (void)deleteAllItemPressed:(id)sender;


@end
