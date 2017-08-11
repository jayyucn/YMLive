//
//  LiveGiftScrollView.h
//  qianchuo
//
//  Created by jacklong on 16/3/5.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "LiveGiftListView.h"
#import "ChatGiftListView.h"
#import "LiveGiftFile.h"

typedef void(^SelectGiftBlock)(int currentGiftId);

@interface LiveGiftScrollView  : UIView<UIScrollViewDelegate>

@property (nonatomic)int currentTag;
@property (nonatomic,copy)SelectGiftBlock selectGiftBlock;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIPageControl *pageControl;
//@property (nonatomic,strong)NSNumber *selectKey;
@property (nonatomic,strong)NSDictionary *giftsDic;
@property (nonatomic,strong)NSMutableArray *firstGifts;
@property (nonatomic,strong)NSMutableArray *secondGifts;
@property (nonatomic,strong)NSMutableArray *threeGifts;
@property (nonatomic,strong)NSMutableArray *fourGifts;
@property (nonatomic,strong)NSMutableArray *fiveGifts;
@property (nonatomic,strong)NSMutableArray *sixGifts;
@property (nonatomic)BOOL isFirstLoad;
@property (nonatomic , assign) BOOL isFromChat;

-(void)groupGifts:(BOOL)isRefreshGiftView;
-(void)selectTag:(int)tagNum; 

- (id)initWithFrame:(CGRect)frame isFromChat:(BOOL)fromChat;

@end
