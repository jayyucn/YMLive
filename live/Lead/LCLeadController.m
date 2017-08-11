//
//  LCLeadController.m
//  XCLive
//
//  Created by ztkztk on 14-6-13.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "LCLeadController.h"

#import "LCStart.h"

@interface LCLeadController ()

@end

@implementation LCLeadController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
    self.title=@"有美直播";
    
    UIButton *rightItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItemBtn.frame=CGRectMake(0, 0, 65.0, 30.0);
    
    [rightItemBtn setTitle:@"跳过"
                  forState:UIControlStateNormal];
    rightItemBtn.backgroundColor=[UIColor clearColor];
    
    [rightItemBtn addTarget:self
                     action:@selector(rightAction)
           forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithCustomView:rightItemBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
     */

    /*
    float viewHeight;
    if(ScreenHeight>480)
        viewHeight=504.0f;
    else
        viewHeight=416.0f;
     */
        
    _imageScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _imageScroll.userInteractionEnabled = YES;
    _imageScroll.directionalLockEnabled = YES; //只能一个方向滑动
    _imageScroll.pagingEnabled = YES; //是否翻页
    _imageScroll.backgroundColor=[UIColor clearColor];
    _imageScroll.showsVerticalScrollIndicator =NO; //垂直方向的滚动指示
    _imageScroll.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    _imageScroll.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    _imageScroll.delegate = self;
    [_imageScroll setContentSize:CGSizeMake(ScreenWidth*3, ScreenHeight)];
    [self creatScrollView];
    [self.view addSubview:_imageScroll];
    
    
//    _pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(ScreenWidth/2-50, ScreenHeight-50, 100, 10)];
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    _pageControl.hidesForSinglePage = YES;
    _pageControl.userInteractionEnabled = NO;
    _pageControl.backgroundColor = [UIColor redColor];
    _pageControl.numberOfPages = 3;
//    _pageControl.center.y = CGPointMake(Sc, ScreenHeight - 50);
    _pageControl.centerX = self.view.frame.size.width/2;
    _pageControl.centerY = ScreenHeight - 50;
    [self.view addSubview:_pageControl];
    
//    _pageControl.centerX=ScreenWidth/4+ScreenWidth/8;
    
    /*
    ESButton *exitLeadBtn= [ESButton buttonWithTitle:@"跳过" buttonColor:ESButtonColorBlue];
    exitLeadBtn.frame=CGRectMake(ScreenWidth-120,25,80,30);
    
    
    [exitLeadBtn addTarget:self
                  action:@selector(exitLead)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitLeadBtn];

    */

}

-(void)exitLead
{
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"HadShowLeadView"];
    
    [[LCStart sharedStart] requestForStart:YES];
}


-(void)creatScrollView
{
    
    for(int i=0;i<3;i++)
    {
        
       // UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"image/lead/%d/%d",(int)(ScreenHeight),i+1]];
        
        UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"image/lead/568/%d",i+1]];

        
       // UIImageView *imageView= [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,_imageScroll.height)];
        
        UIImageView *imageView= [[UIImageView alloc] initWithImage:image];
        //imageView.image=image;
        
        
        imageView.width  = ScreenWidth;
        imageView.height = ScreenHeight;
        imageView.left=i*ScreenWidth;
        imageView.centerY=ScreenHeight/2;
        [self.imageScroll addSubview:imageView];
      }
}



- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = fabs(scrollView.contentOffset.x)/self.view.frame.size.width;
    
    _pageControl.currentPage = index;
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"scrollView.contentOffset.x==%f",scrollView.contentOffset.x);
    if(scrollView.contentOffset.x>ScreenWidth*2+10)
    {
        [self exitLead];
    }
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
