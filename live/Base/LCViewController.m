//
//  KFViewController.m
//  KaiFang
//
//  Created by Elf Sundae on 8/2/13.
//  Copyright (c) 2013 www.0x123.com. All rights reserved.
//

#import "LCViewController.h"
#import "LCDefines.h"

@implementation LCViewController

-(id)init{
        if(self=[super init])
        {
                [self setHidesBottomBarWhenPushed:YES];
        }
        return self;
}

- (void)viewDidLoad
{
        [super viewDidLoad];
    
        if(IOS_VERSION>=7.0)
        {
                self.edgesForExtendedLayout=UIRectEdgeNone;
                self.extendedLayoutIncludesOpaqueBars=NO;
        }
    
        self.view.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight-self.navigationController.navigationBar.height-StatusBarHeight);
//        self.view.backgroundColor=[UIColor colorWithRed:241.0/255 green:232.0/255 blue:207.0/255 alpha:1.0];
        self.view.backgroundColor = ColorBackGround;
        
        self.rightItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightItemBtn.frame=CGRectMake(0, 0, 60.0, 25.0);
        _rightItemBtn.backgroundColor=[UIColor clearColor];
        [_rightItemBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_rightItemBtn addTarget:self
                          action:@selector(rightAction)
                forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithCustomView:_rightItemBtn];
        
        self.navigationItem.rightBarButtonItem=rightItem;
        self.navigationItem.rightBarButtonItem.customView.hidden=YES;
        
}

-(void)setRightItemTitle:(NSString *)title
{
        [_rightItemBtn setTitle:title forState:UIControlStateNormal];
}

-(void)rightAction
{
        
}

- (void)viewWillAppear:(BOOL)animated
{
        [super viewWillAppear:animated];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        //[self resetViewDeckPanningMode];
        
}
- (void)viewDidAppear:(BOOL)animated
{
        [super viewDidAppear:animated];
//        if (self.view.window) {
//                [self resetViewDeckPanningMode];
//        }
}

- (void)viewWillDisappear:(BOOL)animated
{
        [super viewWillDisappear:animated];
//        if (self.disableViewDeckPanning) {
//                //self.viewDeckController.enabled = YES;
//        }
}

//- (void)resetViewDeckPanningMode
//{
//        if (self.disableViewDeckPanning) {
//                //self.viewDeckController.panningMode = IIViewDeckNoPanning;
//                //self.viewDeckController.enabled = NO;
//        }
//}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public Methods
//- (void)closeLeftViewDeckController
//{
//        //        [self.viewDeckController closeLeftViewBouncing:nil];
//}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
        return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
        return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
        return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
        return UIInterfaceOrientationPortrait;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(NSString *)testFuc
{
        NSLog(@"hhhhhh");
        return @"";
}
//- (UIBarButtonItem *)navToggleLeftBarItem
//{
//        if (nil == _navToggleLeftBarItem) {
//                //_navToggleLeftBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"image/nav_left"] style:UIBarButtonItemStyleBordered target:self.viewDeckController action:@selector(toggleLeftView)];
//        }
//        return _navToggleLeftBarItem;
//}
@end
