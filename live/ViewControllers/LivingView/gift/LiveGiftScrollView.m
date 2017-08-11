//
//  LiveGiftScrollView.m
//  qianchuo
//
//  Created by jacklong on 16/3/5.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "LiveGiftScrollView.h"

@implementation LiveGiftScrollView

- (void) dealloc
{
    NSLog(@"%@ dealloc", NSStringFromClass(self.class));
    _scrollView.delegate = nil;
}

- (id)initWithFrame:(CGRect)frame isFromChat:(BOOL)fromChat
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame=CGRectMake(0,5,ScreenWidth,191);

        self.isFromChat = fromChat;
        _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,191)];
        _scrollView.userInteractionEnabled = YES;
        _scrollView.directionalLockEnabled = YES; //只能一个方向滑动
        _scrollView.pagingEnabled = YES; //是否翻页
        _scrollView.backgroundColor=ColorDark; // [UIColor colorWithRed:139.0/255 green:182.0/255 blue:251.0/255 alpha:1.0]
        _scrollView.showsVerticalScrollIndicator =NO; //垂直方向的滚动指示
        //        _scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
        _scrollView.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
        _scrollView.delegate = self;
        CGSize newSize = CGSizeMake(ScreenWidth*1, 191);
        [_scrollView setContentSize:newSize];
        
        [self addSubview:_scrollView];
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 191, SCREEN_WIDTH, 20)];
        _pageControl.numberOfPages = 1;
        _pageControl.currentPage = 0;
        _pageControl.currentPageIndicatorTintColor = ColorPink;
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        [self addSubview:_pageControl];
        [_pageControl addTarget:self action:@selector(actionCotrolPage) forControlEvents:UIControlEventValueChanged];
        
        _currentTag=1;
        
        _isFirstLoad=YES;
        
        [self groupGifts:NO];
    }
    return self;
}

#pragma mark - 礼物
-(void)groupGifts:(BOOL)isRefreshGiftView
{
    if(_isFirstLoad)
    {
        _giftsDic=[LiveGiftFile readGiftList];
        if (!_giftsDic || _giftsDic.count <= 0) {
            ESWeakSelf;
            LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
                
                ESStrongSelf;
                int stat=[responseDic[@"stat"] intValue];
                if(stat==200)
                {
                    [LiveGiftFile writeGiftFile:responseDic];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES]
                                                              forKey:@"GiftList"];
                    _self.giftsDic = responseDic;
                    [_self setGiftData];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒"
                                                                    message:responseDic[@"msg"]
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    alert.delegate=_self;
                    alert.tag=3;
                    [alert show];
                }
            };
            LCRequestFailResponseBlock failBlock=^(NSError *error){
                NSLog(@"request gift fail =%@",error);
                
            };
            
            [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"v":[NSNumber numberWithInt:0]}
                                                            withPath:URL_LIVE_GIFT_URL
                                                         withRESTful:GET_REQUEST
                                                    withSuccessBlock:successBlock
                                                       withFailBlock:failBlock];
        }
        else
        {
            [self setGiftData];
        }
    } else {
       
    }
    
}

-(void)setGiftData
{
    _firstGifts  = [NSMutableArray array];
    _secondGifts = [NSMutableArray array];
    _threeGifts  = [NSMutableArray array];
    _fourGifts   = [NSMutableArray array];
    _fiveGifts   = [NSMutableArray array];
    _sixGifts    = [NSMutableArray array];
    
    NSMutableDictionary *giftObjDic=[NSMutableDictionary dictionaryWithDictionary:_giftsDic[@"gifts"]];
    
    //得到词典中所有Value值
    NSEnumerator * enumeratorValue = [giftObjDic objectEnumerator];
    
    NSArray *array =  enumeratorValue.allObjects;
    
    NSMutableArray *giftAllArray = [NSMutableArray arrayWithArray:array];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"num" ascending:YES];//其中，num为数组中的对象的属性，这个针对数组中存放对象比较更简洁方便
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    [giftAllArray sortUsingDescriptors:sortDescriptors];
    
    for(int i=0,j=0;j<giftAllArray.count;j++)
    {
        NSDictionary *giftDic= giftAllArray[j];
        if (self.isFromChat && [(NSNumber *)giftDic[@"type"] integerValue] == GIFT_TYPE_REDPACKET) {
            continue;
        }
         if (i < 8) {
            [_firstGifts addObject:giftDic];
        } else if (i >= 8 && i < 16){
            [_secondGifts addObject:giftDic];
        } else if (i >= 16 && i < 24){
            [_threeGifts addObject:giftDic];
        } else if (i >= 24 && i < 32){
            [_fourGifts addObject:giftDic];
        } else if (i >= 32 && i < 40){
            [_fiveGifts addObject:giftDic];
        } else if (i >= 40 && i < 48){
            [_sixGifts addObject:giftDic];
        }
        ++i;
    }
    
    
    if (self.isFromChat) {
        [self addChatGiftSubView:giftAllArray.count];
    } else {
        [self addScrollSubView:giftAllArray.count];
    }
    
    _isFirstLoad=NO;
}

- (void) addChatGiftSubView:(NSInteger)giftCount
{
    NSInteger pageCount = 0;
    if (giftCount % 8 == 0) {
        pageCount = giftCount/8;
    } else {
        pageCount = giftCount/8 + 1;
    }
    
    CGSize newSize = CGSizeMake(ScreenWidth*pageCount, 191);
    [_scrollView setContentSize:newSize];
    _pageControl.numberOfPages = pageCount;
    
    for(int i=0;i<pageCount;i++)
    {
        ChatGiftListView *giftListView=[[ChatGiftListView alloc] initWithFrame:CGRectMake(ScreenWidth*i,0,ScreenWidth,191)];
        giftListView.backgroundColor=[UIColor clearColor];
        switch (i) {
            case 0:
            {
                giftListView.giftArray=_firstGifts;
//                NSLog(@"giftListView.giftArray:%@",_firstGifts);
                [giftListView reflashMe];
            }
                break;
            case 1:
                giftListView.giftArray=_secondGifts;
                break;
            case 2:
                giftListView.giftArray=_threeGifts;
                break;
            case 3:
                giftListView.giftArray=_fourGifts;
                break;
            case 4:
                giftListView.giftArray=_fiveGifts;
                break;
            case 5:
                giftListView.giftArray= _sixGifts;
                break;
            default:
                break;
        }
        
        giftListView.tag=10000+i+1;
        
        giftListView.seleckGiftBlock = _selectGiftBlock;
        
        [_scrollView addSubview:giftListView];
    }
}

-(void)addScrollSubView:(NSInteger)giftCount
{
    NSInteger pageCount = 0;
    if (giftCount % 8 == 0) {
        pageCount = giftCount/8;
    } else {
        pageCount = giftCount/8 + 1;
    }
    
    CGSize newSize = CGSizeMake(ScreenWidth*pageCount, 191);
    [_scrollView setContentSize:newSize];
    _pageControl.numberOfPages = pageCount;
    
    for(int i=0;i<pageCount;i++)
    {
        LiveGiftListView *giftListView=[[LiveGiftListView alloc] initWithFrame:CGRectMake(ScreenWidth*i,0,ScreenWidth,191)];
        giftListView.backgroundColor=[UIColor clearColor];
        switch (i) {
            case 0:
            {
                giftListView.giftArray=_firstGifts;
//                NSLog(@"giftListView.giftArray:%@",_firstGifts);
                [giftListView reflashMe];
            }
                break;
            case 1:
                giftListView.giftArray=_secondGifts;
                break;
            case 2:
                giftListView.giftArray=_threeGifts;
                break;
            case 3:
                giftListView.giftArray=_fourGifts;
                break;
            case 4:
                giftListView.giftArray=_fiveGifts;
                break;
            case 5:
                giftListView.giftArray= _sixGifts;
                break;
            default:
                break;
        }
        
        giftListView.tag=10000+i+1;
        
        giftListView.seleckGiftBlock = _selectGiftBlock;
//        ^(int selectGiftId){
//            if (_selectGiftBlock) {
//                _selectGiftBlock(selectGiftId);
//            }
//        };
        [_scrollView addSubview:giftListView];
    }
}

-(void)selectTag:(int)tagNum
{
    _currentTag = tagNum+1;
    
     [self refreshListView];
    
    [UIView animateWithDuration:0.5f animations:^{
        _scrollView.contentOffset = CGPointMake(ScreenWidth*(_currentTag-1), 0);
    } completion:^(BOOL finished){
        
    }];
    
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage = _scrollView.contentOffset.x/SCREEN_WIDTH;
    
    int index = fabs(scrollView.contentOffset.x)/self.frame.size.width;
    _currentTag=index+1;
    
    [self refreshListView];
}

- (void) refreshListView
{
    if (self.isFromChat) {
        ChatGiftListView *giftListView=(ChatGiftListView *)[_scrollView viewWithTag:10000+_currentTag];
        
        [giftListView reflashMe];
    } else {
        LiveGiftListView *giftListView=(LiveGiftListView *)[_scrollView viewWithTag:10000+_currentTag];
        
        [giftListView reflashMe];
    }
}

#pragma mark - pagecontrol
- (void) actionCotrolPage
{
    [_scrollView setContentOffset:CGPointMake(_pageControl.currentPage * SCREEN_WIDTH, 0) animated:YES];
}


@end
