//
//  KFTableViewController.m
//  KaiFang
//
//  Created by Elf Sundae on 8/2/13.
//  Copyright (c) 2013 www.0x123.com. All rights reserved.
//

#import "LCTableViewController.h"
#import "LCDefines.h"

@interface LCTableViewController ()
@property (nonatomic, assign, readwrite) UITableViewStyle tableViewStyle;
@property (nonatomic, assign, readwrite) BOOL hasRefreshControl; // 是否有下拉刷新



@end

@implementation LCTableViewController

@synthesize hasMore;
@synthesize isLoadingMore;
@synthesize isRefreshing;
@synthesize loadMoreButton;
@synthesize currentPage;
@synthesize locationCurrentPage;


- (void)dealloc
{
    
    if (_tableView.refreshControl) {
        _tableView.refreshControl = nil;
    }
    
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    
    NSLog(@"dealloc %@",NSStringFromClass(self.class));
}

- (id)initWithStyle:(UITableViewStyle)style hasRefreshControl:(BOOL)hasRefreshControl
{
        self = [super init];
        if (self) {
                self.tableViewStyle = style;
                self.hasRefreshControl = hasRefreshControl;
                self.list = [[NSMutableArray alloc] init];
            self.locationList = [[NSMutableArray alloc] init];
            self.clearsSelectionOnViewWillAppear = YES;
           
            hasMore=YES;
            isLoadingMore=NO;
            _isLocation = NO;
            
        }
        return self;
}

- (id)init
{
        return [self initWithStyle:UITableViewStylePlain hasRefreshControl:YES];
}


- (void)viewDidLoad
{
        [super viewDidLoad];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        CGRect tableFrame = CGRectMake(0.0, 0.0, SCREEN_WIDTH, self.view.height);
        if (self.navigationController)
        {
            tableFrame.size.height -= self.navigationController.navigationBar.height;
        }
        self.tableView = [[UITableView alloc] initWithFrame:window.bounds style:self.tableViewStyle];
    
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        //self.tableView.backgroundColor = kColor_DarkBackground;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.view addSubview:self.tableView];
        
        if (self.canEditing && self.navigationController) {
                self.navigationItem.rightBarButtonItem = [self editButtonItem];
        }
        
        if (self.hasRefreshControl) {
                ESWeakSelf;
                self.tableView.refreshControl = [ESRefreshControl refreshControlWithDidStartRefreshingBlock:^(ESRefreshControl *refreshControl) {
                    ESStrongSelf;
                    [_self refreshData];
                }];
//                ESWeak(self, _self);
//                self.refreshHeaderView = [ESRefreshControl controlWithSuperView:self.tableView
//                                                         forTableViewController:self
//                                                                     refreshing:^(ESRefreshControl *refreshControl) {
//                                                                             if (_self) {
//                                                                                     [_self refreshData];
//                                                                             }
//                                                                     }
//                                                          forceUseCustomControl:NO];
                
        }
    
    
    self.loadMoreButton= [UIButton buttonWithType:UIButtonTypeCustom];
    [loadMoreButton setTitle:@"加载更多" forState:UIControlStateNormal];
    [loadMoreButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [loadMoreButton setTintColor:[UIColor grayColor]];
    
    /*
    [loadMoreButton addTarget:self
                       action:@selector(loadMoreAction)
             forControlEvents:UIControlEventTouchUpInside];
     */
    
    loadMoreButton.frame=CGRectMake(0, 0, 320, 30);
    self.tableView.tableFooterView=loadMoreButton;
    self.loadMoreButton.hidden=YES;
    
    self.tableView.tableFooterView=nil;
    
    self.noDataImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,100,100)];
    _noDataImageView.centerX=ScreenWidth / 2;
    _noDataImageView.top=100;
    _noDataImageView.image=[UIImage imageNamed:@"image/globle/noDataIcon"];
    [self.view addSubview:_noDataImageView];
    _noDataImageView.hidden=YES;
    
    
    self.noDataNotice = [[UILabel alloc] initWithFrame:CGRectMake(0,0,300,22)];
    _noDataNotice.textAlignment = NSTextAlignmentCenter;
    _noDataNotice.textColor=[UIColor grayColor];
    _noDataNotice.font=[UIFont boldSystemFontOfSize:16];
    _noDataNotice.backgroundColor =[UIColor clearColor];
    [self.view addSubview:_noDataNotice];
    _noDataNotice.adjustsFontSizeToFitWidth=YES;
    _noDataNotice.hidden=YES;
    
    _noDataNotice.centerX=ScreenWidth / 2;
    _noDataNotice.top=_noDataImageView.bottom+10;
}

- (ESRefreshControl *)refreshHeaderView
{
        return self.tableView.refreshControl;
}

-(void)loadMoreAction
{
    [self loadMoreData];
}

- (void)viewWillAppear:(BOOL)animated
{
        [super viewWillAppear:animated];
        if (self.clearsSelectionOnViewWillAppear && [self.tableView indexPathForSelectedRow]) {
                [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
        }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Error View
//- (void)showErrorViewWithTitle:(NSString *)title subTitle:(NSString *)subTitle image:(UIImage *)image showReloadButton:(BOOL)showReload
//{
//        if (title.length || subTitle.length || image || showReload) {
//                
//                if (self.errorView) {
//                        self.errorView.title = title;
//                        self.errorView.subtitle = subTitle;
//                        self.errorView.image = image;
//                        if (self.errorView.reloadButton && !showReload) {
//                                [self.errorView.reloadButton removeFromSuperview];
//                                self.errorView.reloadButton = nil;
//                        } else if (!self.errorView.reloadButton && showReload) {
//                                [self.errorView addReloadButton];
//                        }
//                        self.errorView.backgroundColor = self.tableView.backgroundColor;
//                        [self.errorView setNeedsLayout];
//                } else {
//                        ESErrorView *v = [[ESErrorView alloc] initWithTitle:title subtitle:subTitle image:image];
//                        if (showReload) {
//                                [v addReloadButton];
//                        }
//                        v.backgroundColor = self.tableView.backgroundColor;
//                        self.errorView = v;
//                }
//                
//                if (self.errorView.reloadButton) {
//                        [self.errorView.reloadButton addTarget:self action:@selector(reloadButtonInErrorViewPressed:) forControlEvents:UIControlEventTouchUpInside];
//                }
//        }
//}
//
//- (void)hideErrorView
//{
//        self.errorView = nil;
//}
//
//- (void)setErrorView:(ESErrorView *)errorView
//{
//        if (errorView != _errorView) {
//                if (_errorView) {
//                        [_errorView removeFromSuperview];
//                }
//                _errorView = errorView;
//                if (_errorView) {
//                        [self addToOverlayView:_errorView];
//                } else {
//                        [self resetOverlayView];
//                }
//        }
//}
//
//- (void)reloadButtonInErrorViewPressed:(id)sender
//{
//        
//}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Overlay View

//- (void)addToOverlayView:(UIView *)view
//{
//        if (!self.tableOverlayView) {
//                CGRect frame = self.tableView.frame;
//                self.tableOverlayView = [[UIView alloc] initWithFrame:frame];
//                self.tableOverlayView.autoresizesSubviews = YES;
//                self.tableOverlayView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
//                NSInteger tableIndex = [self.tableView.superview.subviews indexOfObject:self.tableView];
//                if (tableIndex != NSNotFound) {
//                        [self.tableView.superview addSubview:self.tableOverlayView];
//                }
//        }
//        
//        view.frame = self.tableOverlayView.bounds;
//        view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
//        [self.tableOverlayView addSubview:view];
//}
//
//- (void)resetOverlayView
//{
//        if (self.tableOverlayView && !self.tableOverlayView.subviews.count) {
//                [self.tableOverlayView removeFromSuperview];
//                self.tableOverlayView = nil;
//        }
//}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    
//        if (self.refreshHeaderView && [self.refreshHeaderView isKindOfClass:[ESRefreshControl class]]) {
//                [self.refreshHeaderView scrollViewDidScroll:scrollView];
//        }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//        if (self.refreshHeaderView && [self.refreshHeaderView isKindOfClass:[ESRefreshControl class]]) {
//                [self.refreshHeaderView scrollViewDidEndDragging:scrollView];
//        }
    
    NSLog(@"%f,%f,%f,%f",scrollView.bounds.size.height,scrollView.contentOffset.y,scrollView.contentSize.height,self.tableView.height);
    
    
 
        if((scrollView.bounds.size.height<scrollView.contentSize.height)&&scrollView.bounds.size.height + scrollView.contentOffset.y - scrollView.contentSize.height >5)
        {
                NSLog(@"%f,%f,%f,%f",scrollView.bounds.size.height,scrollView.contentOffset.y,scrollView.contentSize.height,self.tableView.height);
                if(hasMore&&!isLoadingMore)
                {
                        
                        [self loadMoreData];
                        isLoadingMore=YES;
                }
                
        }
        
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - TalbeView Edting
- (UIBarButtonItem *)editButtonItem
{
        return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(toggleTableViewEditing)];
}
- (UIBarButtonItem *)doneEditingButtonItem
{
        return [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(toggleTableViewEditing)];
//        return [UIBarButtonItem itemDoneStyleWithTitle:@" 完成 " target:self action:@selector(toggleTableViewEditing)];
}
- (UIBarButtonItem *)deleteAllButtonItem
{
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"删除所有" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteAllItemPressed:)];
        item.tintColor = UIColorWithRGBHex(0xfa140e);
        return item;
//        return [UIBarButtonItem itemRedStyleWithTitle:@"删除所有" target:self action:@selector(deleteAllItemPressed:)];
}

- (void)deleteAllItemPressed:(id)sender
{
        [self toggleTableViewEditing];
}

- (void)toggleTableViewEditing
{
        if (self.list.count == 0 && !self.tableView.isEditing ) {
                return;
        }
        
        [self.tableView setEditing:!self.tableView.isEditing animated:YES];
        
        if (self.tableView.isEditing) {
                self.navigationItem.rightBarButtonItem = [self doneEditingButtonItem];
        } else {
                self.navigationItem.rightBarButtonItem = [self editButtonItem];
        }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - TableView Delegate


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    /*
    if(section==0)
    {
        if(IOS_VERSION_IS_ABOVE_7)
            return 10.0f;
        else
            return 20.0f;

    }else{
        return 20.0f;
    }
     */
    if(self.tableViewStyle==UITableViewStyleGrouped)
        return 10;
    else
        return 0;
    
    
}


/*
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

 */


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return nil;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public Methods

- (void)scrollTableViewToTop:(BOOL)animated
{
        [self.tableView setContentOffset:CGPointZero animated:animated];
}

- (void)setVisibleCellsNeedsDisplay
{
        NSArray *visibleCells = [self.tableView visibleCells];
        if (visibleCells) {
                [visibleCells makeObjectsPerformSelector:@selector(setNeedsDisplay)];
        }
}

- (void)setVisibleCellsNeedsLayout
{
        NSArray *visibleCells = [self.tableView visibleCells];
        if (visibleCells) {
                [visibleCells makeObjectsPerformSelector:@selector(setNeedsLayout)];
        }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Subclass
- (void)refreshData
{
    
        if (self.tableView.refreshControl) {
                [self.tableView.refreshControl endRefreshing];
        }
//        if (self.refreshHeaderView) {
//            
//            
//                [self.refreshHeaderView endRefreshing];
//        }
}

- (void)loadMoreData
{
        
}


@end
